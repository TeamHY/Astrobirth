"""Share reviewed upgrade relationships between probability and item pages."""


def apply_upgrade_notes(catalog, upgrades):
    by_id = {entry['id']: entry for entry in catalog['entries']}
    for pattern in upgrades['patterns']:
        for role, own, other in [('from', pattern['target'], pattern['original']),
                                 ('to', pattern['original'], pattern['target'])]:
            entry = by_id.get(own['id'])
            if entry is None:
                continue
            relation = {'role': role, 'item': other, 'chance': pattern['chance'],
                        'condition': pattern['condition'], 'directMethod': pattern.get('directMethod'),
                        'href': './upgrades.html#' + pattern['group']}
            entry.setdefault('upgradeRelations', []).append(relation)
            # An upgrade effect is reader-facing even for a previously pool-only entry.
            if 'effect' not in entry.get('changeKinds', ['effect']):
                entry['changeKinds'].append('effect')
            if 'astro/collectibles/ex-upgrade.lua' not in entry.setdefault('itemSources', []):
                entry['itemSources'].append('astro/collectibles/ex-upgrade.lua')
    for pattern in upgrades.get('directPatterns', []):
        entry = by_id[pattern['targetId']]
        entry.setdefault('upgradeRelations', []).append({
            'role': 'direct', 'item': {'title': pattern['original'], 'id': None},
            'condition': pattern['condition'], 'href': './index.html#' + pattern['qaId']})


def relation_text(relation):
    name = relation['item']['title']
    if relation['role'] == 'direct':
        return f'{name}에서 직접 변환할 수 있습니다. ' + relation['condition']
    prefix = f'{name}의 강화 버전입니다. ' if relation['role'] == 'from' else ''
    chance = relation['chance']
    if chance:
        if relation['role'] == 'from':
            text = f'원본 등장 시 {chance}% 확률로 이 아이템으로 대체됩니다.'
        else:
            text = f'등장 시 {chance}% 확률로 강화 아이템 ‘{name}’이 대신 나옵니다.'
        return prefix + text + (' ' + relation['condition'] if relation['condition'] else '')
    return prefix + '자동 업그레이드 확률은 0%입니다. ' + relation['directMethod']
