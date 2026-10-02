#!/usr/bin/env python3
"""Import exact resource differences against extracted, unmodified game resources.

This is a maintenance tool, not a Pages build dependency. It changes guide data
and copies original icons only; it never changes game files.
"""
import argparse
import hashlib
import json
import re
import shutil
from collections import defaultdict
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / 'docs'
parser = argparse.ArgumentParser()
parser.add_argument('--baseline', type=Path, required=True)
parser.add_argument('--eid', type=Path, required=True)
args = parser.parse_args()


def names(language):
    text = (args.eid / 'descriptions/names' / (language + '.lua')).read_text()
    return {(group, int(number)): value.replace('\\"', '"')
            for group, number, value in re.findall(r'\[(C_ID|T_ID)\s*\.\.\s*(\d+)\]\s*=\s*"((?:[^"\\]|\\.)*)"', text)}


english, korean = names('en_us'), names('ko_kr')
definitions = ET.parse(ROOT / 'resources/items.xml').getroot()
base_definitions = ET.parse(args.baseline / 'items.xml').getroot()
base_items = {(e.tag, int(e.get('id'))): e for e in base_definitions if e.get('id')}
items = {(e.tag, int(e.get('id'))): e for e in definitions if e.get('id')}
base_meta = {(e.tag, int(e.get('id'))): e for e in ET.parse(args.baseline / 'items_metadata.xml').getroot()}
meta = {(e.tag, int(e.get('id'))): e for e in ET.parse(ROOT / 'resources/items_metadata.xml').getroot()}
catalog = json.loads((DOCS / 'items-content.json').read_text())
by_number = {('T_ID' if e['kind'] == 'trinket' else 'C_ID', e['number']): e
             for e in catalog['entries'] if isinstance(e.get('number'), int)}
icons = {p.name.casefold(): p for p in (args.baseline / 'gfx/items').rglob('*.png')}
snapshot = {'baseline': {f: hashlib.sha256((args.baseline / f).read_bytes()).hexdigest()
                        for f in ['items.xml', 'items_metadata.xml', 'itempools.xml']},
            'itemAttributes': [], 'metadata': [], 'pools': [], 'unregisteredPoolItems': []}
tags = {'angel': '천사 변신', 'baby': '샴쌍둥이 변신', 'battery': '배터리 계열',
        'bob': '밥 변신', 'book': '책벌레 변신', 'dead': '죽은 물건 계열', 'devil': '악마 변신',
        'fly': '파리 변신', 'food': '폭식의 음식 보상', 'guppy': '구피 변신', 'mom': '엄마 변신',
        'devilsacrifice': '악마 거래 희생 구매 허용',
        'monstermanual': '몬스터 도감 소환 대상', 'mushroom': '버섯 변신',
        'nocantrip': 'Cantripped 챌린지 제외', 'nochallenge': '챌린지 제외', 'nodaily': '데일리 제외',
        'noeden': '에덴 무작위 시작 아이템 제외', 'nogreed': '탐욕 모드 제외',
        'nokeeper': '키퍼 계열 제외', 'nolostbr': '로스트 생득권 제외',
        'offensive': '더럽혀진 로스트 허용', 'poop': '똥 변신', 'quest': '퀘스트 아이템',
        'spider': '거미 변신', 'stars': '천체 계열', 'summonable': '레메게톤 소환 대상',
        'syringe': '약물 변신', 'tearsup': '연사 상승 계열', 'tech': '기술 계열',
        'uniquefamiliar': '패밀리어 중복 제한', 'lazarusshared': '더럽혀진 나사로 형태 간 공유',
        'lazarussharedglobal': '더럽혀진 나사로 전체 소지 검사 공유'}
cache = {'firedelay': '연사', 'damage': '공격력', 'speed': '이동속도', 'range': '사거리',
         'tearcolor': '눈물 색', 'tearflag': '눈물 효과', 'color': '색', 'size': '크기',
         'shotspeed': '탄속', 'all': '전체', 'luck': '행운', 'flying': '비행',
         'weapon': '무기', 'familiars': '패밀리어'}
pool_names = {'treasure': '보물방', 'shop': '상점', 'boss': '보스방', 'devil': '악마방',
              'angel': '천사방', 'secret': '비밀방', 'library': '책방', 'shellGame': '야바위',
              'goldenChest': '황금 상자', 'redChest': '빨간 상자', 'beggar': '거지',
              'demonBeggar': '악마 거지', 'curse': '저주방', 'keyMaster': '열쇠 거지',
              'batteryBum': '배터리 거지', 'momsChest': '엄마의 상자', 'craneGame': '크레인 게임',
              'ultraSecret': '울트라 비밀방', 'bombBum': '폭탄 거지', 'planetarium': '천체관',
              'oldChest': '낡은 상자', 'babyShop': '베이비 상점', 'woodenChest': '나무 상자',
              'rottenBeggar': '썩은 거지', 'greedTreasure': '탐욕 보물방', 'greedBoss': '탐욕 보스 보상',
              'greedShop': '탐욕 상점', 'greedCurse': '탐욕 저주방', 'greedDevil': '탐욕 악마방',
              'greedAngel': '탐욕 천사방', 'greedSecret': '탐욕 비밀방'}


def card(group, number):
    if (group, number) in by_number:
        return by_number[group, number]
    kind = 'trinket' if group == 'T_ID' else 'active' if ('active', number) in items else 'passive'
    definition = next(e for (tag, n), e in items.items()
                      if n == number and (tag == 'trinket') == (group == 'T_ID') and tag != 'null')
    name = english[(group, number)]
    title = korean.get((group, number)) or name
    slug = re.sub(r'[^a-z0-9]+', '-', name.lower()).strip('-') or 'item'
    # Include IDs for newly added cards; retain all existing permalink IDs.
    slug += '-' + str(number) + ('-trinket' if group == 'T_ID' else '')
    original = icons[definition.get('gfx').casefold()]
    image = DOCS / 'assets/items' / (slug + '.png')
    shutil.copyfile(original, image)
    entry = {'id': slug, 'title': title, 'name': name, 'number': number, 'kind': kind,
             'scene': '수치·분류·배열 설정 변경', 'body': '기본 게임과 달라진 설정은 아래에 정리했습니다.',
             'tag': '설정 변경', 'image': 'assets/items/' + image.name, 'keywords': name + ' ' + str(number),
             'source': 'resources/items.xml', 'resourceOnly': True, 'changeKinds': []}
    catalog['entries'].append(entry)
    by_number[group, number] = entry
    return entry


def add_source(entry, path):
    if path != entry.get('source') and path not in entry.get('extraSources', []):
        entry.setdefault('extraSources', []).append(path)


def group_rules(entry, title, rules, source):
    if not rules:
        return
    entry.setdefault('effectGroups', []).append({'title': title, 'items': rules})
    entry['changeKinds'].append('config')
    add_source(entry, source)


def old_value(value, default='기본 설정'):
    return value if value is not None else default


for entry in catalog['entries']:
    entry['changeKinds'] = [] if entry.get('resourceOnly') else ['effect']
    entry['effectGroups'] = [g for g in entry.get('effectGroups', [])
                             if g['title'] not in ['가격·충전·획득 설정', '품질·분류 설정']]
    entry.pop('poolTable', None)

for key, after in items.items():
    before = base_items.get(key)
    if before is None or key[0] == 'null':
        continue
    changes = {k: {'before': before.get(k), 'after': after.get(k)}
               for k in set(before.attrib) | set(after.attrib) if before.get(k) != after.get(k)}
    if not changes:
        continue
    number = key[1]
    entry = card('T_ID' if key[0] == 'trinket' else 'C_ID', number)
    lines = []
    for field, values in sorted(changes.items()):
        b, a = values['before'], values['after']
        if field == 'shopprice': lines.append(f'상점 기본 가격: {old_value(b, "기본 가격")} → {a}센트입니다. 할인 등 가격 보정은 별도로 적용됩니다.')
        elif field == 'devilprice': lines.append(f'악마 거래의 빨간 하트 기본 가격: {old_value(b, "기본 가격")} → {a}칸입니다. 체력 구성에 따른 거래 방식은 별도로 적용됩니다.')
        elif field == 'maxcharges':
            def charge(value, definition):
                if value is None: return '기본 설정'
                return value + ('프레임' if definition.get('chargetype') == 'timed' else ' (특수 충전 지정값)' if definition.get('chargetype') == 'special' else '칸')
            lines.append(f'충전 요구량: {charge(b, before)} → {charge(a, after)}입니다.')
        elif field == 'chargetype': lines.append(f'충전 방식: { {"normal":"방 클리어","timed":"시간","special":"특수 조건"}.get(b,"방 클리어")} → { {"normal":"방 클리어","timed":"시간","special":"특수 조건"}.get(a,"방 클리어")}입니다.')
        elif field == 'initcharge': lines.append(f'획득 시 초기 충전 지정값: {old_value(b)} → {old_value(a)}입니다.')
        elif field == 'persistent': lines.append('사용 효과가 방 이동·이어하기 후에도 유지됩니다.' if a == 'true' else '사용 효과가 방 이동·이어하기 후 유지되지 않도록 변경됩니다.')
        elif field == 'hidden': lines.append('출생증명서와 수집 목록에서 제외됩니다.' if a == 'true' else '출생증명서·수집 목록의 숨김 지정을 해제합니다.')
        elif field == 'cooldown': lines.append(f'사용 효과의 기본 지속 시간: {old_value(b)} → {old_value(a)}프레임입니다.')
        elif field == 'cache':
            added = set((a or '').split()) - set((b or '').split());removed = set((b or '').split()) - set((a or '').split())
            if added: lines.append('획득 시 재계산 항목 추가: ' + ', '.join(cache[x] for x in sorted(added)) + '입니다.')
            if removed: lines.append('획득 시 재계산 항목 제외: ' + ', '.join(cache[x] for x in sorted(removed)) + '입니다.')
        elif field in ('hearts', 'soulhearts'):
            label = '빨간 하트 회복' if field == 'hearts' else '소울 하트 지급'
            lines.append(f'획득 시 {label}: {float(b or 0)/2:g} → {float(a or 0)/2:g}칸입니다.')
        elif field == 'bombs': lines.append(f'획득 시 폭탄 지급량: {b or 0} → {a or 0}개입니다.')
        else: raise ValueError(('Unreviewed field', field, key))
    group_rules(entry, '가격·충전·획득 설정', lines, 'resources/items.xml')
    snapshot['itemAttributes'].append({'kind': key[0], 'number': number, 'entry': entry['id'], 'changes': changes})

for (meta_kind, number), after in meta.items():
    before = base_meta[meta_kind, number]
    changes = {k: {'before': before.get(k), 'after': after.get(k)}
               for k in set(before.attrib) | set(after.attrib) if before.get(k) != after.get(k)}
    if not changes:
        continue
    entry = card('T_ID' if meta_kind == 'trinket' else 'C_ID', number)
    lines = []
    for field, values in sorted(changes.items()):
        b, a = values['before'], values['after']
        if field == 'quality': lines.append(f'아이템 품질: {b} → {a}입니다. 다음 판 금지 후보 등 품질을 검사하는 규칙에도 적용됩니다.')
        elif field == 'craftquality': lines.append(f'조합용 품질: {old_value(b, "기본 품질")} → {old_value(a, "기본 품질")}입니다.')
        elif field == 'tags':
            added = set((a or '').split()) - set((b or '').split());removed = set((b or '').split()) - set((a or '').split())
            if added: lines.append('분류 추가: ' + ', '.join(tags[x] for x in sorted(added)) + '입니다.')
            if removed: lines.append('분류 제외: ' + ', '.join(tags[x] for x in sorted(removed)) + '입니다.')
        else: raise ValueError(('Unreviewed metadata', field, number))
    group_rules(entry, '품질·분류 설정', lines, 'resources/items_metadata.xml')
    snapshot['metadata'].append({'kind': meta_kind, 'number': number, 'entry': entry['id'], 'changes': changes})


def pools(path):
    result = {}
    for pool in ET.parse(path).getroot():
        name = pool.get('Name')
        grouped = defaultdict(list)
        for item in pool:
            grouped[int(item.get('Id'))].append({k: v for k, v in item.attrib.items() if k != 'Id'})
        normalized = dict(grouped)
        if name in result:
            # Retain distinct values from duplicate pool definitions. Do not
            # assume a load-order rule or discard either Ghost Pepper weight.
            for number, rows in normalized.items():
                existing = result[name].setdefault(number, [])
                existing.extend(row for row in rows if row not in existing)
        else:
            result[name] = normalized
    return result


def pool_text(rows):
    if not rows:
        return '배열에 포함되지 않습니다'
    return ' / '.join('가중치 ' + r['Weight'] + ' · 감소 ' + r['DecreaseBy'] + ' · 제외 기준 ' + r['RemoveOn'] for r in rows)


old_pools, new_pools = pools(args.baseline / 'itempools.xml'), pools(ROOT / 'resources/itempools.xml')
for name, pool in new_pools.items():
    original = old_pools.get(name, {})
    for number in sorted(set(pool) | set(original)):
        before, after = original.get(number), pool.get(number)
        if before == after:
            continue
        if not any(n == number and tag not in ('null', 'trinket') for tag, n in items):
            snapshot['unregisteredPoolItems'].append({'pool': name, 'number': number,
                                                     'before': before, 'after': after})
            continue
        entry = card('C_ID', number)
        if 'pool' not in entry['changeKinds']: entry['changeKinds'].append('pool')
        add_source(entry, 'resources/itempools.xml')
        table = entry.setdefault('poolTable', {'caption': '배열별 등장 설정 변경', 'columns': ['배열', '기본 게임', '대결 모드'], 'rows': [],
                                             'note': '가중치는 같은 배열 안에서의 상대값입니다. 감소는 배열에서 뽑힐 때의 가중치 감소량이며, 제외 기준 이하가 되면 더 이상 뽑히지 않습니다. 같은 아이템의 여러 설정은 함께 표시합니다. 고정 금지·캐릭터 금지·다음 판 금지는 별도로 적용됩니다.'})
        table['rows'].append([pool_names[name], pool_text(before), pool_text(after)])
        snapshot['pools'].append({'pool': name, 'number': number, 'entry': entry['id'], 'before': before, 'after': after})
        if name == 'greedDevil' and number == 495:
            entry['caution'] = '탐욕 악마방의 중복 설정에 가중치 0.1과 0.5가 각각 지정되어 있습니다. 두 값을 모두 표시하며 단일 등장 확률로 환산하지 않습니다.'

for entry in catalog['entries']:
    entry['changeKinds'] = sorted(set(entry['changeKinds']))
    if entry.get('resourceOnly'):
        labels = []
        if 'config' in entry['changeKinds']: labels.append('가격·품질·충전')
        if 'pool' in entry['changeKinds']: labels.append('배열')
        entry['scene'] = ' · '.join(labels) + ' 설정 변경'
catalog['intro'] = '효과뿐 아니라 가격·품질·충전량·분류·배열 변경을 아이템별로 확인할 수 있습니다. 카드와 기반 모드의 대결 전용 효과도 포함합니다.'
(DOCS / 'items-content.json').write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + '\n')
(DOCS / 'resource-changes.json').write_text(json.dumps(snapshot, ensure_ascii=False, indent=2) + '\n')
print('Imported', len(snapshot['itemAttributes']), 'item settings,', len(snapshot['metadata']), 'metadata settings,', len(snapshot['pools']), 'pool settings; total', len(catalog['entries']), 'cards.')
