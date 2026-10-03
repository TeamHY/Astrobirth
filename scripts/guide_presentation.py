"""Compact catalog presentation; the reviewed source sentences stay intact."""
from copy import deepcopy
import re
from guide_effects import summary_kind

CONFIG_FIELDS = {
    '아이템 퀄리티': ('퀄리티', 'quality', ''),
    '조합용 퀄리티': ('조합 퀄리티', 'craftquality', ''),
    '상점 기본 가격': ('상점 가격', 'shopprice', 'Coin'),
    '악마 거래의 빨간 하트 기본 가격': ('악마 거래', 'devilprice', 'Heart'),
    '충전 요구량': ('충전', 'maxcharges', 'Battery'),
    '충전 방식': ('충전 방식', 'chargetype', 'Battery'),
    '획득 시 초기 충전 지정값': ('초기 충전', 'initcharge', 'Battery'),
    '사용 효과의 기본 지속 시간': ('지속 시간', 'cooldown', ''),
    '획득 시 폭탄 지급량': ('획득 시 폭탄', 'addbombs', 'Bomb'),
    '획득 시 빨간 하트 회복': ('획득 시 회복', 'hearts', 'Heart'),
    '획득 시 소울 하트 지급': ('획득 시 소울 하트', 'soulhearts', 'SoulHeart'),
}
SHARED_ENHANCED = '황금 장신구나 엄마의 상자 등으로 장신구 효과가 강화된 경우에 적용됩니다.'
NO_RESTRICTIONS = '이 캐릭터만의 추가 금지 목록은 없습니다. 공통 금지와 누적 밴은 별도로 적용됩니다.'


def display_value(value, field):
    if value.startswith('None'):
        return '기본 가격' if field in ('shopprice', 'devilprice') else '기본 설정'
    if field == 'devilprice' and value.isdigit():
        return value + '칸'
    if field == 'shopprice' and value.isdigit():
        return value + '센트'
    return value


def compact_entry(original, players=False):
    entry = deepcopy(original)
    entry['configChanges'] = []
    entry['loadout'] = []
    if not players:
        for line in entry.get('eidEffects', []):
            separated = []
            for segment in line:
                if separated and 'item' in separated[-1] and 'item' in segment:
                    separated.append({'text': ', '})
                separated.append(segment)
            line[:] = separated
        groups = []
        for group in entry.get('effectGroups', []):
            if group['title'] not in ('가격·충전·획득 설정', '퀄리티·분류 설정'):
                groups.append(group)
                continue
            remaining = []
            for line in group['items']:
                match = re.fullmatch(r'([^:]+): (.*?) → (.*?)입니다\.(?: .*)?', line)
                if match and match[1] in CONFIG_FIELDS:
                    label, field, icon = CONFIG_FIELDS[match[1]]
                    entry['configChanges'].append({
                        'label': label, 'field': field, 'icon': icon,
                        'before': display_value(match[2], field),
                        'after': display_value(match[3], field),
                    })
                elif line.startswith(('분류 추가:', '분류 제외:', '획득 시 재계산 항목 추가:', '획득 시 재계산 항목 제외:')):
                    label, value = line.removesuffix('입니다.').split(': ', 1)
                    entry['configChanges'].append({'label': label, 'value': value})
                elif line == '출생증명서와 수집 목록에서 제외됩니다.':
                    entry['configChanges'].append({'label': '출생증명서·수집 목록', 'value': '제외'})
                else:
                    remaining.append(line)
            if remaining:
                groups.append({**group, 'items': remaining})
        entry['effectGroups'] = groups
        described_items = {segment['item'] for line in entry.get('eidEffects', []) for segment in line if 'item' in segment}
        def repeats_eid_items(line):
            match = re.fullmatch(r'정리 대상 (\d+)종: (.+)\.', line)
            names = match[2].split(', ') if match else []
            return bool(match and len(names) == int(match[1]) and set(names) <= described_items)
        entry['rules'] = [line for line in entry.get('rules', []) if not repeats_eid_items(line)]
        mod = entry.get('modItem', {})
        fields = {change.get('field') for change in entry['configChanges']}
        if 'quality' in mod and 'quality' not in fields:
            entry['configChanges'].append({'label': '퀄리티', 'field': 'quality', 'value': mod['quality']})
        if mod.get('type') == 'active' and 'maxcharges' in mod and 'maxcharges' not in fields:
            entry['configChanges'].append({'label': '충전', 'field': 'maxcharges', 'icon': 'Battery', 'value': mod.get('chargeLabel', mod['maxcharges'] + '칸')})
        if entry.get('resourceOnly'):
            entry['body'] = ''
            entry['scene'] = ''
        elif summary_kind(entry.get('body', '')):
            # The structured effect already states the result; keep the original
            # scene as a search alias without repeating it above the same effect.
            entry['searchScene'] = entry.get('scene', '')
            entry['scene'] = ''
        if SHARED_ENHANCED in entry.get('rules', []):
            entry['rules'].remove(SHARED_ENHANCED)
            entry['configChanges'].insert(0, {'label': '적용 조건', 'value': '황금·강화 장신구'})
        return entry

    entry['body'] = ''
    if entry.get('restrictionNote') == NO_RESTRICTIONS:
        entry.pop('restrictionNote')
    start = entry['rules'][0]
    if start.startswith('시작방에 추가 등장: '):
        entry['loadout'].append({'label': '시작방 추가', 'items': start.removeprefix('시작방에 추가 등장: ').removesuffix('.').split(', ')})
        entry['rules'].pop(0)
    elif start == '별도의 시작방 추가 아이템·카드는 없습니다.':
        entry['loadout'].append({'label': '시작방 추가', 'value': '없음'})
        entry['rules'].pop(0)
    elif start == '야곱과 에사우 각각의 시작방에 신성한 카드를 소환합니다.':
        entry['loadout'].append({'label': '시작방 추가', 'items': ['신성한 카드'], 'note': '야곱·에사우 각각'})
        entry['rules'].pop(0)
    if entry.get('scene') == start:
        entry['scene'] = ''
    remaining = []
    for line in entry['rules']:
        first, separator, rest = line.partition('. ')
        sentence = first if separator else first.removesuffix('.')
        simple = re.fullmatch(r'시작 (빨간|소울|블랙) 하트는 (.+?)으로 설정합니다', sentence)
        multiple = re.fullmatch(r'시작 빨간 하트는 (.+?), 소울 하트는 (.+?)으로 설정합니다', sentence)
        basic = re.fullmatch(r'기본 시작 체력은 (.+?)이며 (.+?)를 설정합니다', sentence)
        hearts, supplies = [], []
        if multiple:
            hearts = [('빨간', multiple[1]), ('소울', multiple[2])]
        elif simple:
            hearts = [(simple[1], simple[2])]
        elif basic:
            hearts = re.findall(r'(빨간|소울|블랙) 하트 (\d+칸)', basic[1])
            supplies = re.findall(r'(폭탄|열쇠) (\d+개)', basic[2])
        if hearts:
            entry['loadout'].append({'label': '시작 체력', 'values': [
                {'label': kind + ' 하트', 'value': value, 'icon': {'빨간': 'Heart', '소울': 'SoulHeart', '블랙': 'BlackHeart'}[kind]}
                for kind, value in hearts]})
            if supplies:
                entry['loadout'].append({'label': '시작 소모품', 'values': [
                    {'label': kind, 'value': value, 'icon': {'폭탄': 'Bomb', '열쇠': 'Key'}[kind]}
                    for kind, value in supplies]})
            if rest:
                remaining.append(rest)
        else:
            remaining.append(line)
    entry['rules'] = remaining
    return entry
