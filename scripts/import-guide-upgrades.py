#!/usr/bin/env python3
"""Import committed upgrade tables without evaluating game callbacks."""
import argparse
import hashlib
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / 'docs'
parser = argparse.ArgumentParser()
parser.add_argument('--base-mod', type=Path, required=True)
parser.add_argument('--eid', type=Path, required=True)
args = parser.parse_args()
guide = json.loads((DOCS / 'guide-content.json').read_text())
sha = guide['sources']['Astro-Items']
catalog = json.loads((DOCS / 'items-content.json').read_text())
registered = json.loads((DOCS / 'astro-items.json').read_text())
by_number = {entry['number']: entry for entry in catalog['entries'] if entry.get('origin', 'base') == 'base' and entry.get('kind') in ('active', 'passive')}
by_name = {entry['name']: entry for entry in registered['entries']}
source = subprocess.check_output(['git', '-C', str(args.base_mod), 'show', sha + ':astro/collectibles/ex-upgrade.lua']).decode()
definitions = subprocess.check_output(['git', '-C', str(args.base_mod), 'grep', '-h', '-F', 'Isaac.GetItemIdByName', sha, '--', 'astro']).decode()
symbols = dict(re.findall(r'Astro\.Collectible\.([A-Z0-9_]+)\s*=\s*Isaac.GetItemIdByName\("([^"]+)"\)', definitions))
base_names = (args.eid / 'descriptions/names/en_us.lua').read_text()
english_names = {int(number): name for number, name in re.findall(r'\[C_ID\s*\.\.\s*(\d+)\]\s*=\s*"((?:[^"\\]|\\.)*)"', base_names)}
korean_names = {int(number): name for number, name in re.findall(r'\[C_ID\s*\.\.\s*(\d+)\]\s*=\s*"((?:[^"\\]|\\.)*)"', (args.eid / 'descriptions/names/ko_kr.lua').read_text())}
enums = {}
for number, name in re.findall(r'\[C_ID\s*\.\.\s*(\d+)\]\s*=\s*"((?:[^"\\]|\\.)*)"', base_names):
    key = re.sub('[^A-Z0-9]+', '_', name.upper().replace("'", '').replace('\\', '')).strip('_')
    for alias in {key, key.removeprefix('THE_')}:
        enums[alias] = int(number)


def item(token):
    if token.startswith('Astro.Collectible.'):
        entry = by_name[symbols[token.rsplit('.', 1)[1]]]
        return {'id': entry['id'], 'title': entry['eidName'], 'name': entry['name']}
    number = enums[token.removeprefix('CollectibleType.COLLECTIBLE_')]
    if number not in by_number:
        return {'id': None, 'title': korean_names[number], 'name': english_names[number]}
    entry = by_number[number]
    return {key: entry[key] for key in ('id', 'title', 'name')}


tables = {}
for table, contents in re.findall(r'Astro\.(UPGRADE_LIST|\w+_UPGRADE_LIST) = \{(.*?)\n\}', source, re.S):
    contents = re.sub(r'--[^\n]*', '', contents)
    tables[table] = [(old, new, round(float(chance) * 100)) for old, new, chance in re.findall(
        r'\[([\w.]+)\]\s*=\s*\{\s*Id\s*=\s*([\w.]+),\s*Chance\s*=\s*([\d.]+)\s*\}', contents)]
assert set(tables) == {'PLANETARIUM_UPGRADE_LIST', 'PLANET_UPGRADE_LIST', 'UPGRADE_LIST'}
planet_originals = {old for old, _, _ in tables['PLANET_UPGRADE_LIST']}
patterns = []
for table in ['UPGRADE_LIST', 'PLANETARIUM_UPGRADE_LIST', 'PLANET_UPGRADE_LIST']:
    for old, new, chance in tables[table]:
        if table == 'PLANETARIUM_UPGRADE_LIST' and old in planet_originals:
            continue  # These 0% entries use the separate 30% planet logic.
        group = 'planet-auto' if table == 'PLANET_UPGRADE_LIST' else 'manual-only' if not chance else 'standard-auto'
        condition = '비밀방·일급 비밀방·천체관에서 등장하고, 모든 플레이어가 초행성을 보유하지 않은 경우에만 적용합니다.' if group == 'planet-auto' else ''
        pattern = {'original': item(old), 'target': item(new), 'chance': chance,
                   'group': group, 'condition': condition, 'sourceTable': table,
                   'originalSymbol': old, 'targetSymbol': new}
        if not chance:
            pattern['directMethod'] = ('주사위방에서 4면 주사위를 사용해 직접 변환합니다.' if table == 'UPGRADE_LIST'
                                       else '방 바닥에 둔 원본 별자리에 알비레오를 사용해 직접 변환합니다.')
        patterns.append(pattern)

groups = [
    ('standard-auto', '일반 아이템의 자동 업그레이드', '원본이 새로 등장할 때 적용하는 아이템별 대체 확률입니다. 방 종류나 행운에 따른 추가 제한은 이 업그레이드 판정에 없습니다.'),
    ('planet-auto', '행성의 자동 업그레이드', '비밀방·일급 비밀방·천체관에서만 30% 판정합니다. 협동 플레이를 포함해 누군가 초행성을 보유하면 자동 변환하지 않습니다. 알비레오를 사용하는 직접 변환은 이 제한과 별개입니다.'),
    ('manual-only', '자동 업그레이드가 없는 아이템', '아래 원본의 자동 업그레이드 확률은 0%입니다. 별자리는 알비레오, 4면 주사위는 주사위방에서의 사용으로 직접 변환합니다.')]
entries = []
for group, title, description in groups:
    members = [p for p in patterns if p['group'] == group]
    table = {'caption': title + ' 전체 목록', 'columns': ['원본 아이템', '강화 아이템', '대체 확률'],
             'rows': [[p['original']['title'], p['target']['title'], str(p['chance']) + '%'] for p in members],
             'rowLinks': [[p['original']['id'], p['target']['id'], None] for p in members]}
    if group == 'manual-only':
        table['note'] = '0%는 자동 대체가 없다는 뜻입니다. 직접 변환 방법은 입문 Q&A에 정리했습니다.'
    entries.append({'id': group, 'title': title, 'body': description, 'open': True,
                    'keywords': '업글 업그레이드 확률 강화 대체 원본 ' + ' '.join(p['original']['name'] + ' ' + p['target']['name'] for p in members),
                    'rewardTable': table, 'itemSources': ['astro/collectibles/ex-upgrade.lua', 'astro/collectibles/reroll.lua'],
                    'relatedLinks': [{'href': './index.html#' + ('planet-upgrade' if group == 'planet-auto' else 'special-upgrades' if group == 'manual-only' else 'item-upgrade'), 'label': '업그레이드 사용 방법'}]})

direct = [
    ('astro-scales-of-obedience', '천칭자리', '검은 양초를 소지하고 방 바닥의 천칭자리에 버리기 버튼을 길게 누릅니다. 검은 양초를 소모합니다.', 'upgrade-combinations'),
    ('astro-artifact-ignition', '서큐버스', '혼돈을 소지하고 방 바닥의 서큐버스에 버리기 버튼을 길게 누릅니다.', 'upgrade-combinations'),
    ('astro-legacy', '생득권', '변신 세트 아이템 합계 6개 이상을 소지하고 방 바닥의 생득권에 버리기 버튼을 길게 누릅니다.', 'upgrade-combinations'),
    ('astro-blighted-guppy', '구피 세트 아이템', '구피 변신과 썩은 하트를 갖춘 뒤 방 바닥의 구피 아이템에 버리기 버튼을 길게 누릅니다.', 'upgrade-combinations'),
    ('astro-brimstone-guppy', '구피 세트 아이템', '구피 변신과 유황불을 갖춘 뒤 방 바닥의 구피 아이템에 버리기 버튼을 길게 누릅니다.', 'upgrade-combinations'),
    ('astro-divine-guppy', '구피 세트 아이템', '구피 변신과 이터널 하트를 갖춘 뒤 방 바닥의 구피 아이템에 버리기 버튼을 길게 누릅니다.', 'upgrade-combinations'),
    ('astro-golden-guppy', '구피 세트 아이템', '구피 변신 상태에서 황금 하트 개수가 줄어들 때 방 바닥의 구피 아이템을 변환합니다.', 'special-upgrades'),
    ('astro-skeleton-guppy', '구피 세트 아이템', '구피 변신 상태에서 뼈 하트 개수가 줄어들 때 방 바닥의 구피 아이템을 변환합니다.', 'special-upgrades'),
    ('astro-p-key', 'R 키', 'R 키를 소지하고 P 키를 누르면 R 키를 소모하고 P키를 바닥에 생성합니다.', 'special-upgrades'),
    ('astro-marigold', '미다스의 손길', '미다스의 손길을 소지하거나 방 바닥에 둔 상태에서 꿀꺽! 알약 또는 용광로를 사용합니다.', 'special-upgrades')]
payload = {'schema': 1, 'reviewed': '2026-10-04', 'commit': sha,
           'sourceSHA256': hashlib.sha256(source.encode()).hexdigest(),
           'intro': '원본 아이템이 새로 등장할 때 정해진 확률로 강화 아이템이 대신 나오는 패턴을 모두 정리했습니다. 일반 아이템·행성의 확률과 자동 변환이 없는 대상을 구분합니다.',
           'entries': entries, 'patterns': patterns,
           'directPatterns': [dict(zip(('targetId', 'original', 'condition', 'qaId'), row)) for row in direct]}
(DOCS / 'upgrades-content.json').write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n')
print(f'Upgrade patterns: {len(patterns)}; automatic: {sum(p["chance"] > 0 for p in patterns)}; direct only: {sum(p["chance"] == 0 for p in patterns)}')
