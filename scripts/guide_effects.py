"""Conservative presentation patterns for reviewed item effects.

Patterns split complete sentences or rows; they never reorder effects across
activation conditions, infer a reward, or change a numeric modifier.
"""
import re

STAT_ICONS = {
    '공격력': 'DamageSmall', '최종 공격력': 'DamageSmall',
    '연사': 'TearsSmall', '이동속도': 'SpeedSmall', '이동 속도': 'SpeedSmall',
    '사거리': 'RangeSmall', '탄속': 'ShotspeedSmall', '행운': 'LuckSmall',
    '최대 체력': 'Heart', '빨간하트': 'Heart', '소울하트': 'SoulHeart',
    '블랙하트': 'BlackHeart', '폭탄': 'Bomb', '열쇠': 'Key', '동전': 'Coin',
}
STAT = re.compile(
    r'(?P<direction>[↑↓]\s*)?(?P<context>\((?:빨강|초록|파랑)\))?'
    r'(?P<label>최종 공격력|공격력|연사|이동속도|이동 속도|사거리|탄속|행운|'
    r'최대 체력|빨간하트|소울하트|블랙하트|폭탄|열쇠|동전)'
    r'(?P<modifier>\(\+상한\)| 배율| 상한)?\s+'
    r'(?P<value>(?:[+−-]|[×x])\s*\d+(?:\.\d+)?(?:%p|%)?|\d+(?:\.\d+)?)'
)
EVENT = re.compile(
    r'(?P<trigger>황금 장신구 상태이거나 엄마의 상자를 소지하면|'
    r'엄마의 상자를 가지고 일반 형태의 이 장신구를 소지하면|'
    r'장신구 효과 배수가 2 이상이면|'
    r'처음 획득할 때|최초 획득 시|첫 획득 시|획득 시|'
    r'스테이지 진입 시|스테이지 입장 시|새 층에 들어갈 때|'
    r'방 입장 시|방에 들어갈 때|방 클리어 시|보스방 클리어 시|'
    r'적 처치 시|적 명중 시|동전 획득 시|피격 시|'
    r'소지중일 때|소지 중|소지 시|사용 시|사용하면|'
    r'\d+(?:\.\d+)?초마다)\s+(?P<result>.+)', re.S
)
LUCK_NOTE = re.compile(r'행운 \d+(?:\.\d+)? 이상일 때 \d+(?:\.\d+)?% 확률 \(행운 1당 \+\d+(?:\.\d+)?%p\)')
BASE_STATS = re.compile(r'기본 효과에 (?P<each>개수마다 )?(?P<stats>.+) 보정이 추가됩니다\.')


def stat_parts(text):
    match = STAT.fullmatch(text.strip())
    if not match:
        return None
    # A bare number is a cap, not an additive bonus or a damage formula.
    if not re.match(r'[+−×x-]', match['value']) and match['modifier'] != ' 상한':
        return None
    return {**match.groupdict(), 'icon': STAT_ICONS[match['label']]}


def summary_kind(text):
    match = BASE_STATS.fullmatch(text)
    if match and all(stat_parts(part) for part in match['stats'].split(' · ')):
        return 'stats'
    return 'event' if EVENT.fullmatch(text) else None


def sprite_label(key, icons=None):
    if key.startswith('Quality'):
        return key.removeprefix('Quality')
    names = {'Heart': '빨간하트', 'SoulHeart': '소울하트', 'BlackHeart': '블랙하트',
             'Coin': '동전', 'Bomb': '폭탄', 'Key': '열쇠', 'Pill': '알약',
             'Crafting11': '행운 동전', 'Crafting17': '기가 폭탄',
             'Crafting18': '마이크로 배터리', 'Crafting19': '배터리'}
    if key.startswith('Card') and icons:
        return next((name for name, record in icons['names'].items() if record.get('eid') == key), '')
    return names.get(key, '')


def icon_text(line, index, icons=None):
    key = line[index].get('icon', '')
    label = sprite_label(key, icons)
    if not label or key.startswith('Quality'):
        return label
    following = ''.join(part.get('text', part.get('item', '')) for part in line[index + 1:]).lstrip()
    aliases = [label]
    if key == 'Heart':
        aliases += ['빨간 하트', '최대 체력', '하트']
    if key in ('SoulHeart', 'BlackHeart'):
        aliases += [label.replace('하트', ' 하트')]
    return '' if any(following.startswith(name) for name in aliases) else label


def effect_text(lines, icons=None):
    """Include meanings carried only by icons in search and verification."""
    return ' '.join(''.join(segment.get('text', segment.get('item', icon_text(line, index, icons)))
                            for index, segment in enumerate(line)) for line in lines)
