#!/usr/bin/env python3
"""Generate the viewer guide, detailed rules, catalogs and room comparison."""
import html
import hashlib
import json
import re
from html.parser import HTMLParser
from pathlib import Path
from guide_presentation import compact_entry
from guide_effects import BASE_STATS, EVENT, LUCK_NOTE, effect_text, icon_text, stat_parts, summary_kind
from guide_upgrades import apply_upgrade_notes, relation_text

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / 'docs'
data = json.loads((DOCS / 'guide-content.json').read_text(encoding='utf-8'))
items = json.loads((DOCS / 'items-content.json').read_text(encoding='utf-8'))
upgrades = json.loads((DOCS / 'upgrades-content.json').read_text(encoding='utf-8'))
apply_upgrade_notes(items, upgrades)
players = json.loads((DOCS / 'players-content.json').read_text(encoding='utf-8'))
rules = json.loads((DOCS / 'rules-content.json').read_text(encoding='utf-8'))
room_data = json.loads((DOCS / 'rooms-content.json').read_text(encoding='utf-8'))
icons = json.loads((DOCS / 'guide-icons.json').read_text(encoding='utf-8'))
effect_pickup_icons = {'꿀꺽! 알약': 'Pill', '행운 동전': 'Crafting11', '기가 폭탄': 'Crafting17',
                       '마이크로 배터리': 'Crafting18', '블랙하트': 'BlackHeart', '소울하트': 'SoulHeart',
                       '빨간 하트': 'Heart'}
effect_item_names = '|'.join(re.escape(name) for name in sorted(set(icons['names']) | set(effect_pickup_icons), key=len, reverse=True) if name)
effect_item_pattern = re.compile(r'(?<![\w가-힣])(?P<name>' + effect_item_names + r')(?P<particle>[을를와과]?)(?=\s+(?:효과|소환|획득|흡수|소지|가지고|장신구|알약|카드|\d)|(?:을|를)\s+(?:소환|획득|흡수|소지|가지고))')
layout = (ROOT / 'scripts/guide-layout.html').read_text(encoding='utf-8')
esc = html.escape

# Preserve imported pool settings in the source catalog for maintenance, while
# omitting them from both the viewer catalog and its search index.
items['entries'] = [
    entry for entry in items['entries']
    if any(kind != 'pool' for kind in entry.get('changeKinds', ['effect']))
]
for entry in items['entries']:
    entry.pop('poolTable', None)
    entry['changeKinds'] = [kind for kind in entry.get('changeKinds', ['effect']) if kind != 'pool']
items['entries'] = [compact_entry(entry) for entry in items['entries']]
players['entries'] = [compact_entry(entry, players=True) for entry in players['entries']]
visible_item_ids = {entry['id'] for entry in items['entries']}


def icon_image(key, named=False):
    record = (icons['names'] if named else icons['sprites']).get(key)
    if not record:
        return ''
    return f'<img class="inline-icon{" item-inline-icon" if named else ""}" src="./{esc(record["image"], quote=True)}" alt="" aria-hidden="true" width="{28 if named else 20}" height="{28 if named else 20}" loading="lazy" decoding="async">'


def named_items(names):
    return '<span class="named-items">' + ', '.join(
        '<span class="named-item">' + icon_image(name, True) + '<span>' + esc(name) + '</span></span>'
        for name in names) + '</span>'


def render_effect_segments(line):
    segments = []
    for index, segment in enumerate(line):
        if 'text' in segment:
            segments.append(esc(segment['text']))
        elif 'item' in segment:
            segments.append(named_items([segment['item']]))
        elif 'icon' in segment:
            key = segment['icon']
            segments.append(icon_image(key))
            label = icon_text(line, index, icons)
            if label:
                segments.append('<span class="effect-icon-label">' + esc(label) + '</span>')
    return ''.join(segments)


def stat_effect(text, existing_icons=()):
    stat = stat_parts(text)
    if not stat:
        return None
    image = ''.join(icon_image(key) for key in existing_icons) or icon_image(stat['icon'])
    label = esc((stat['context'] or '') + stat['label'] + (stat['modifier'] or ''))
    direction = '<span class="effect-direction">' + esc(stat['direction'] or '') + '</span>'
    return '<li class="effect-stat" data-effect-template="stat"><span class="effect-stat-label">' + image + direction + '<span>' + label + ' </span></span><strong class="effect-stat-value">' + esc(stat['value']) + '</strong></li>'


def split_effect_segments(line, offset):
    before, after, position = [], [], 0
    for segment in line:
        text = segment.get('text', segment.get('item', ''))
        if position >= offset:
            after.append(segment)
        elif position + len(text) <= offset:
            before.append(segment)
        elif 'text' in segment:
            cut = offset - position
            before.append({'text': text[:cut]})
            after.append({'text': text[cut:]})
        else:
            return None
        position += len(text)
    return before, after


def effect_row(line):
    text = ''.join(segment.get('text', segment.get('item', '')) for segment in line)
    if all('text' in segment or 'icon' in segment for segment in line):
        stat = stat_effect(text, [segment['icon'] for segment in line if 'icon' in segment])
        if stat:
            return stat
    rendered = render_effect_segments(line)
    if text.strip().endswith(':'):
        return '<li class="effect-condition" data-effect-template="condition">' + rendered + '</li>'
    if LUCK_NOTE.fullmatch(text.strip()):
        return '<li class="effect-note" data-effect-template="chance">' + icon_image('LuckSmall') + rendered + '</li>'
    event = EVENT.fullmatch(text)
    if event:
        split = split_effect_segments(line, event.start('result'))
        if split:
            trigger, result = map(render_effect_segments, split)
            return '<li class="effect-event" data-effect-template="event"><span class="effect-trigger">' + trigger + '</span><span class="effect-result">' + result + '</span></li>'
    return '<li>' + rendered + '</li>'


def eid_effects(lines, preview=False):
    if not lines:
        return ''
    rendered = [effect_row(line) for line in lines]
    return '<ul class="catalog-eid-effects' + (' catalog-eid-preview' if preview else '') + '">' + ''.join(rendered) + '</ul>'


def eid_text(lines):
    return effect_text(lines, icons)


def linked_effect_text(text):
    # Decorate explicit item actions only; ordinary nouns such as 달 or 신
    # must not be inferred to mean a collectible.
    cursor, parts = 0, []
    for match in effect_item_pattern.finditer(text):
        start, end, name = match.start(), match.end(), match['name']
        parts.append(esc(text[cursor:start]))
        image = icon_image(effect_pickup_icons[name]) if name in effect_pickup_icons else icon_image(name, True)
        parts.append('<span class="named-item">' + image + '<span>' + esc(text[start:end]) + '</span></span>')
        cursor = end
    return ''.join(parts) + esc(text[cursor:])


def catalog_description(entry):
    text = entry.get('body', '')
    if not text:
        return ''
    kind = summary_kind(text)
    if kind == 'stats':
        match = BASE_STATS.fullmatch(text)
        rows = []
        if match['each']:
            rows.append('<li class="effect-condition">' + esc(match['each']) + '</li>')
        for part in match['stats'].split(' · '):
            if rows and rows[-1].startswith('<li class="effect-stat'):
                rows.append('<li class="effect-source-boilerplate"> · </li>')
            rows.append(stat_effect(part))
        return '<div class="catalog-effect-summary"><span class="effect-source-boilerplate">기본 효과에 </span><ul class="catalog-eid-effects">' + ''.join(rows) + '</ul><span class="effect-source-boilerplate"> 보정이 추가됩니다.</span></div>'
    if kind == 'event':
        match = EVENT.fullmatch(text)
        trigger = text[:match.start('result')]
        result = text[match.start('result'):]
        return '<div class="catalog-effect-summary"><ul class="catalog-eid-effects"><li class="effect-event" data-effect-template="event"><span class="effect-trigger">' + linked_effect_text(trigger) + '</span><span class="effect-result">' + linked_effect_text(result) + '</span></li></ul></div>'
    return '<p class="catalog-description">' + esc(text) + '</p>'


def catalog_facts(entry):
    rows = []
    for change in entry.get('configChanges', []):
        label = icon_image(change.get('icon', '')) + esc(change['label'])
        if 'before' in change:
            values = []
            for side in ('before', 'after'):
                value = change[side]
                quality = icon_image('Quality' + value) if change.get('field') in ('quality', 'craftquality') else ''
                values.append(f'<span class="fact-{side}">{quality}<span>{esc(value)}</span></span>')
            value = '<span class="fact-arrow" aria-hidden="true">→</span>'.join(values)
        else:
            value = (icon_image('Quality' + change['value']) if change.get('field') == 'quality' else '') + esc(change['value'])
        field = esc(change.get('field', ''), quote=True)
        rows.append(f'<div class="fact-row" data-config-field="{field}"><dt>{label}</dt><dd>{value}</dd></div>')
    for loadout in entry.get('loadout', []):
        if 'items' in loadout:
            value = named_items(loadout['items'])
        elif 'values' in loadout:
            value = '<span class="loadout-values">' + ''.join(
                '<span class="loadout-value">' + icon_image(part['icon']) + '<span class="fact-type">' + esc(part['label']) + '</span><strong>' + esc(part['value']) + '</strong></span>'
                for part in loadout['values']) + '</span>'
        else:
            value = esc(loadout['value'])
        if loadout.get('note'):
            value += '<span class="fact-note">' + esc(loadout['note']) + '</span>'
        rows.append('<div class="fact-row"><dt>' + esc(loadout['label']) + '</dt><dd>' + value + '</dd></div>')
    return '<dl class="catalog-facts">' + ''.join(rows) + '</dl>' if rows else ''


def source_comment(entry):
    sources = []
    for repo, paths in [('Astrobirth', ([entry['source']] if entry.get('source') else []) + entry.get('extraSources', [])),
                        ('Astro-Items', entry.get('itemSources', []))]:
        for path in paths:
            sha = data['sources'][repo]
            sources.append({'repository': repo, 'commit': sha, 'path': path,
                            'url': f'https://github.com/TeamHY/{repo}/blob/{sha}/{path}'})
    references = entry.get('references', [])
    if not sources and not references:
        return ''
    material = {'entry': entry['id'], 'sources': sources}
    if entry.get('agentNotes'):
        material['agentNotes'] = entry['agentNotes']
    if references:
        material['references'] = references
    reference = json.dumps(material, ensure_ascii=False, indent=2)
    reference = reference.replace('--', '\\u002d\\u002d')
    return '\n<!-- Agent reference material\n' + reference + '\n-->\n'


def permalink(entry):
    label = esc(entry['title'] + ' 고유 링크', quote=True)
    return f'''<a class="permalink" href="#{entry['id']}" aria-label="{label}" title="이 설명의 고유 링크"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M10 13a5 5 0 0 0 7.1 0l3-3a5 5 0 0 0-7.1-7.1l-1.7 1.7M14 11a5 5 0 0 0-7.1 0l-3 3a5 5 0 0 0 7.1 7.1l1.7-1.7"/></svg></a>'''


def upgrade_notes(entry):
    notes = []
    for relation in entry.get('upgradeRelations', []):
        text = esc(relation_text(relation))
        item = relation['item']
        if item.get('id') in visible_item_ids:
            name = esc(item['title'])
            text = text.replace(name, f'<a href="./items.html#{esc(item["id"], quote=True)}">{name}</a>', 1)
        notes.append('<p class="catalog-upgrade">' + text + ' <a class="upgrade-conditions" href="' + esc(relation['href'], quote=True) + '">확률·조건 보기 ↗</a></p>')
    return ''.join(notes)


def body(entry, include_body=True, include_facts=True):
    parts = [f'<p>{esc(entry["body"])}</p>'] if include_body else []
    if include_body:
        parts.append(upgrade_notes(entry))
    parts.append(eid_effects(entry.get('eidEffects', [])))
    if include_facts:
        parts.append(catalog_facts(entry))
    if entry.get('rules'):
        parts.append('<ul class="rule-list">' + ''.join(f'<li>{esc(rule)}</li>' for rule in entry['rules']) + '</ul>')
    groups = ''.join(f'<section class="effect-group"><h3>{esc(group["title"])}</h3><ul class="rule-list">' + ''.join(f'<li>{esc(rule)}</li>' for rule in group['items']) + '</ul></section>' for group in entry.get('effectGroups', []))
    if not entry.get('tableFirst'):
        parts.append(groups)
    for table_key in ['rewardTable', 'poolTable']:
        table = entry.get(table_key)
        if not table:
            continue
        headers = ''.join(f'<th scope="col">{esc(column)}</th>' for column in table['columns'])
        rows = []
        for index, row in enumerate(table['rows']):
            cells = []
            row_links = table.get('rowLinks', [])
            for column, cell in enumerate(row):
                text = esc(cell)
                target = row_links[index][column] if row_links else None
                if target in visible_item_ids:
                    text = f'<a href="./items.html#{esc(target, quote=True)}">{text}</a>'
                cells.append(('<th scope="row">' if column == 0 else '<td>') + text + ('</th>' if column == 0 else '</td>'))
            rows.append('<tr>' + ''.join(cells) + '</tr>')
        rows = ''.join(rows)
        parts.append(f'<table class="reward-table"><caption>{esc(table["caption"])}</caption><thead><tr>{headers}</tr></thead><tbody>{rows}</tbody></table>')
        if table.get('note'):
            parts.append(f'<p class="table-note">{esc(table["note"])}</p>')
    if entry.get('tableFirst'):
        parts.append(groups)
    if entry.get('watch'):
        parts.append(f'<div class="watch-note"><strong>관전 시 참고사항</strong>{esc(entry["watch"])}</div>')
    if entry.get('caution'):
        parts.append(f'<p class="detail-caution">{esc(entry["caution"])}</p>')
    if entry.get('restrictions'):
        parts.append('<div class="restriction-list"><h4>캐릭터별 추가 금지</h4>')
        for category in entry['restrictions']:
            parts.append(f'<p><strong>{esc(category["label"])}</strong> {named_items(category["items"])}</p>')
        parts.append('</div>')
    elif entry.get('restrictionNote'):
        parts.append(f'<p class="restriction-note">{esc(entry["restrictionNote"])}</p>')
    links = []
    if entry.get('related'):
        links.append(f'<a href="#{esc(entry["related"])}">관련 설명 읽기</a>')
    for link in entry.get('relatedLinks', []):
        links.append(f'<a class="related-link" href="{esc(link["href"], quote=True)}">{esc(link["label"])} <span aria-hidden="true">↗</span></a>')
    if links:
        parts.append('<div class="entry-links">' + ''.join(links) + '</div>')
    parts.append(source_comment(entry))
    return ''.join(parts)


def write_page(page, title, description, content, script):
    page_nav = '<nav class="page-nav" aria-label="가이드 페이지">' + ''.join(
        f'<a href="./{key}.html' + ('#overview' if key == 'index' else '') + '"' + (' aria-current="page"' if key == page else '') + f'>{esc(label)}</a>'
        for key, label in [('index', '입문 Q&A'), ('rules', '전체 규칙'), ('items', '아이템 가이드'), ('upgrades', '업그레이드 확률'), ('players', '캐릭터 가이드'), ('rooms', '방 변경사항')]) + '</nav>'
    replacements = {'PAGE_TITLE': esc(title), 'DESCRIPTION': esc(description, quote=True),
                    'PAGE_NAV': page_nav, 'CONTENT': content, 'PAGE_KEY': page,
                    'REVIEWED': data['reviewed'], 'VERSION': data['version'],
                    'SCRIPT': script,
                    'SCRIPT_REVISION': hashlib.sha256((DOCS / script).read_bytes()).hexdigest()[:12],
                    'SEARCH_REVISION': hashlib.sha256((DOCS / 'search.js').read_bytes()).hexdigest()[:12],
                    'SEARCH_INDEX_REVISION': hashlib.sha256((DOCS / 'search-index.json').read_bytes()).hexdigest()[:12],
                    'BASELINE_RECORD': json.dumps({key: data[key] for key in ('reviewed', 'version', 'sources')}, ensure_ascii=False, indent=2).replace('--', '\\u002d\\u002d'),
                    'STYLE_REVISION': hashlib.sha256((DOCS / 'guide.css').read_bytes()).hexdigest()[:12],
                    'EXTRA_STYLES': '<link rel="stylesheet" href="./rooms.css">' if page == 'rooms' else ''}
    output = layout
    for key, value in replacements.items():
        output = output.replace('{{' + key + '}}', value)
    assert '{{' not in output, 'Unresolved template value'
    output = '\n'.join(line.rstrip() for line in output.splitlines()) + '\n'
    (DOCS / (page + '.html')).write_text(output, encoding='utf-8')


def empty_state():
    return '<div class="empty-state" id="empty-state" hidden><h3>해당 분류의 항목이 없습니다.</h3><button type="button" id="reset-filters">전체 목록 보기</button></div>'


def catalog_details(entry):
    if not entry.get('detailsFrom'):
        return entry
    shared = next((qa for section in data['sections'] for qa in section['entries'] if qa['id'] == entry['detailsFrom']), None)
    assert shared is not None, 'Missing shared details: ' + entry['detailsFrom']
    detail_entry = {**shared, **entry}
    for shared_list in ['effectGroups', 'rules']:
        detail_entry[shared_list] = shared.get(shared_list, []) + entry.get(shared_list, [])
    return detail_entry


class VisibleText(HTMLParser):
    def __init__(self, markup):
        super().__init__()
        self.parts = []
        self.feed(markup)

    def handle_data(self, value):
        self.parts.append(value)


def build_search_index():
    # Index reader-facing content only. Source comments and agent notes are excluded.
    entries = []
    for page, content in [('index', data), ('rules', rules), ('items', items), ('upgrades', upgrades), ('players', players)]:
        records = content['entries'] + content.get('sharedNotes', []) if 'entries' in content else [entry for section in content['sections'] for entry in section['entries']]
        for entry in records:
            detail = catalog_details(entry) if page in ('items', 'players') else entry
            text = ' '.join(' '.join(VisibleText(body(detail)).parts).split())
            record = {
                'page': page, 'title': entry['title'], 'href': f"./{page}.html#{entry['id']}",
                'description': entry['body'] or eid_text(entry.get('eidEffects', [])[:3]) or ' '.join(VisibleText(catalog_facts(entry)).parts), 'name': entry.get('name', ''),
                'text': ' '.join([text, entry.get('scene', ''), entry.get('searchScene', ''), entry.get('tag', '')]),
                'keywords': entry.get('keywords', ''),
            }
            if entry.get('image'):
                record['image'] = './' + entry['image']
            entries.append(record)

    payload = {'schema': 1, 'entries': entries}
    (DOCS / 'search-index.json').write_text(json.dumps(payload, ensure_ascii=False, separators=(',', ':')) + '\n', encoding='utf-8')
    print(f"Generated search-index.json: {len(entries)} entries.")


def render_sections(section_data):
    seen, sections, count = set(), [], 0
    for number, section in enumerate(section_data, 1):
        assert section['id'] not in seen, 'Duplicate section ID'
        seen.add(section['id'])
        entries = []
        for entry in section['entries']:
            assert entry['id'] not in seen, 'Duplicate entry ID'
            seen.add(entry['id'])
            count += 1
            opened = ' open' if entry.get('open') else ''
            entries.append(f'<details class="entry" id="{entry["id"]}" data-keywords="{esc(entry.get("keywords", ""), quote=True)}"{opened}><summary><span class="entry-title-row"><span class="entry-title">{esc(entry["title"])}</span>{permalink(entry)}</span></summary><div class="entry-body">{body(entry)}</div></details>')
        sections.append(f'<section class="guide-section" id="{section["id"]}" aria-labelledby="heading-{section["id"]}"><div class="section-heading"><span class="section-index">{number:02}</span><h2 id="heading-{section["id"]}">{esc(section["title"])}</h2><p>{esc(section["subtitle"])}</p></div>{"".join(entries)}</section>')
    chapter_links = ''.join(f'<a href="#{section["id"]}"><span class="nav-number" aria-hidden="true">{number:02}</span>{esc(section["title"])}</a>' for number, section in enumerate(section_data, 1))
    return sections, count, chapter_links


def render_qa():
    sections, count, chapter_links = render_sections(data['sections'])
    content = f'''
<section class="hero" id="overview" aria-labelledby="page-title">
<p class="eyebrow">Astrobirth 대결</p><h1 id="page-title">입문 Q&amp;A</h1><p class="hero-copy">헌영의 아이작 대결에 사용되는 Astrobirth의 주요 규칙을 설명합니다.<br>노피격으로 에이플을 확보·유지하는 과정과 보상 변화를 중심으로 정리했습니다.</p><p class="hero-detail-link"><a href="./rules.html">금지 목록과 세부 조건을 포함한 전체 규칙 ↗</a></p></section>
<nav class="chapter-toc" aria-label="입문 Q&A 목차"><p class="toc-label">이 페이지 목차</p><div class="section-nav">{chapter_links}</div></nav>
<section id="guide" aria-labelledby="guide-title"><div class="guide-toolbar"><div><h2 id="guide-title">주요 규칙 Q&A</h2><p>전체 {count}개</p></div></div>
{''.join(sections)}</section>
<aside class="scope-note" aria-labelledby="scope-title"><span class="scope-icon" aria-hidden="true">i</span><div><h2 id="scope-title">모드 기능과 경기 운영 규칙</h2><p>Astrobirth와 기반 모드 Astro-Items의 기능을 설명합니다. 경기 목표, 허용 아이템, 보조 모드와 밴 해제 여부는 해당 방송의 공지가 우선입니다. 업데이트 후 실제 게임과 다를 수 있습니다.<br>직접 플레이하는 경우 <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=3260980911" target="_blank" rel="noopener noreferrer">Astro-Items</a>와 <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=1630138997" target="_blank" rel="noopener noreferrer">한국어 아이템 설명 모드</a>도 참고할 수 있습니다.</p></div></aside>'''
    write_page('index', '입문 Q&A', '헌영의 아이작 대결을 처음 보는 시청자를 위한 입문 Q&A입니다. 아이템과 캐릭터의 기능 및 대결 변경사항을 함께 설명합니다.', content, 'guide.js')
    print(f'Generated index.html: {len(sections)} sections, {count} entries.')


def render_rules():
    sections, count, chapter_links = render_sections(rules['sections'])
    intro = rules.get('intro', '금지 목록, 방·층 구성, 피격과 보상, 소비 아이템의 세부 조건을 정리했습니다. 개별 아이템과 캐릭터는 아이템 가이드·캐릭터 가이드에서 확인할 수 있습니다.')
    content = f'''<section class="hero" id="overview" aria-labelledby="page-title"><p class="eyebrow">Astrobirth 대결</p><h1 id="page-title">전체 규칙</h1><p class="hero-copy">{esc(intro)}</p></section>
<nav class="chapter-toc" aria-label="전체 규칙 목차"><p class="toc-label">이 페이지 목차</p><div class="section-nav">{chapter_links}</div></nav>
<section id="guide" aria-labelledby="guide-title"><div class="guide-toolbar"><div><h2 id="guide-title">분야별 세부 규칙</h2><p>전체 {count}개</p></div></div>{''.join(sections)}</section>
<aside class="catalog-end"><p>설명 기준 Astrobirth v{data['version']} · 확인 {data['reviewed']}</p><a href="./index.html">입문 Q&amp;A로 돌아가기 ↗</a></aside>'''
    write_page('rules', '전체 규칙', intro, content, 'guide.js')
    print(f'Generated rules.html: {len(sections)} sections, {count} entries.')


def render_catalog(page, catalog, kinds, title, subtitle):
    entries, cards, seen = catalog['entries'], [], set()
    is_players = page == 'players'
    unit = '명' if is_players else '개'
    for entry in entries:
        assert entry['id'] not in seen, 'Duplicate catalog ID'
        assert (DOCS / entry['image']).is_file(), 'Missing image: ' + entry['image']
        seen.add(entry['id'])
        kind = entry['variant'] if is_players else entry['kind']
        origin_attribute = f' data-origin="{esc(entry.get("origin", "base"), quote=True)}"'
        tag = ({'base': '기본', 'mod': '모드'}[entry['origin']] + ' · ' + kinds[kind]) if is_players else kinds[kind] + ' · ' + entry['tag']
        detail_entry = {**catalog_details(entry)}
        # Basic EID effects stay visible; details contain additional conditions.
        detail_entry['eidEffects'] = []
        has_details = any(detail_entry.get(key) for key in ['rules', 'effectGroups', 'rewardTable', 'poolTable', 'watch', 'caution', 'restrictions', 'restrictionNote', 'related', 'relatedLinks'])
        details = source_comment(detail_entry)
        if has_details:
            details = f'<details class="catalog-details"><summary>{"고유 규칙 및 추가 금지" if is_players else "세부 조건 보기"}</summary><div class="entry-body">{body(detail_entry, False, include_facts=False)}</div></details>'
            if not is_players:
                detail_label = esc(entry['title'] + ' 세부 조건 보기', quote=True)
                details = f'<button type="button" class="catalog-detail-trigger" aria-haspopup="dialog" aria-controls="catalog-detail-dialog" aria-label="{detail_label}" hidden>세부 조건 보기</button>' + details
        scene = f'<p class="catalog-scene">{esc(entry["scene"])}</p>' if entry.get('scene') else ''
        description = catalog_description(entry) if not is_players else (f'<p class="catalog-description">{esc(entry["body"])}</p>' if entry.get('body') else '')
        effects = eid_effects(entry.get('eidEffects', []), preview=True)
        image_label = entry['title'] + (' 캐릭터' if is_players else ' 원본 이미지 미등록' if entry.get('imagePlaceholder') else ' 아이콘')
        cards.append(f'''<article class="catalog-card{' player-card' if is_players else ''}" id="{entry['id']}" data-kind="{kind}"{origin_attribute} data-changes="{esc(' '.join(entry.get('changeKinds', ['effect'])), quote=True)}" data-keywords="{esc(entry.get('keywords',''), quote=True)}"><div class="catalog-card-heading"><div class="catalog-icon"><img src="./{esc(entry['image'])}" alt="{esc(image_label, quote=True)}" width="80" height="80" loading="lazy" decoding="async"></div><div><span class="catalog-kind">{esc(tag)}</span><h2 class="catalog-title-row"><span>{esc(entry['title'])}</span>{permalink(entry)}</h2><p class="english-name">{esc(entry['name'])}</p></div></div>{scene}{description}{upgrade_notes(entry)}{effects}{catalog_facts(entry)}{details}</article>''')
    buttons = [f'<button type="button" data-kind="all" aria-pressed="true">전체 <span>{len(entries)}</span></button>']
    for key, label in kinds.items():
        count = sum((entry['variant'] if is_players else entry['kind']) == key for entry in entries)
        buttons.append(f'<button type="button" data-kind="{key}" aria-pressed="false">{label} <span>{count}</span></button>')
    origins = [('all', '전체'), ('base', '기본 캐릭터' if is_players else '기존 아이템 변경'), ('mod', '모드 캐릭터' if is_players else 'Astro-Items 추가')]
    origin_buttons = ''.join(
        f'<button type="button" data-origin="{key}" aria-pressed="{str(key == "all").lower()}">{label} <span>{sum(key == "all" or entry.get("origin", "base") == key for entry in entries)}</span></button>'
        for key, label in origins)
    filters = '<div class="item-filters"><div class="item-filter-group" role="group" aria-label="아이템 출처"><span class="item-filter-label">출처</span><div class="catalog-filters">' + origin_buttons + '</div></div><div class="item-filter-group" role="group" aria-label="아이템 분류"><span class="item-filter-label">종류</span><div class="catalog-filters">' + ''.join(buttons) + '</div></div></div>'
    if is_players:
        filters = '<div class="player-filters"><div class="player-filter-group" role="group" aria-label="캐릭터 구분"><span class="player-filter-label">구분</span><div class="catalog-filters">' + origin_buttons + '</div></div><div class="player-filter-group" role="group" aria-label="캐릭터 형태"><span class="player-filter-label">형태</span><div class="catalog-filters">' + ''.join(buttons) + '</div></div></div>'
    change_filters = '' if is_players else '<div class="change-filters" role="group" aria-label="변경 분야">' + ''.join(f'<button type="button" data-change="{key}" aria-pressed="{str(key == "all").lower()}">{label}</button>' for key, label in [('all', '전체 안내'), ('effect', '효과'), ('config', '가격·퀄리티·충전')]) + '</div>'
    common = '<div class="player-common"><a href="./index.html#no-hit"><span>핵심 규칙</span><strong>노피격과 에이플 ↗</strong><p>올백·낙제 유지에 따라 추가 보상이 달라집니다.</p></a><a href="./index.html#health-limit"><span>후반 생존</span><strong>체력 상한 제한 ↗</strong><p>일부 캐릭터는 적용 방식과 예외가 다릅니다.</p></a><a href="./index.html#lost-shield"><span>로스트 계열</span><strong>보호막 손실 패널티 ↗</strong><p>보호막만 깨져도 능력치가 내려갑니다.</p></a></div>' if is_players else ''
    common += ''.join('<aside class="catalog-note" id="' + esc(note['id'], quote=True) + '"><strong>' + esc(note['title']) + '</strong><div class="entry-body">' + body(note) + '</div></aside>' for note in catalog.get('sharedNotes', []))
    detail_dialog = '' if is_players else '<dialog id="catalog-detail-dialog" class="catalog-detail-dialog" aria-labelledby="catalog-detail-title"><div class="catalog-dialog-heading"><h2 id="catalog-detail-title"></h2><button type="button" class="catalog-dialog-close" aria-label="세부 조건 닫기">×</button></div><div class="catalog-dialog-content"></div></dialog>'
    content = f'''<section class="hero catalog-hero" id="overview" aria-labelledby="page-title"><div><p class="eyebrow">Astrobirth · {'캐릭터' if is_players else '아이템'}</p><h1 id="page-title">{title}</h1><p class="hero-copy">{esc(catalog['intro'])}</p></div></section>{common}
<section class="catalog" id="catalog" aria-labelledby="catalog-title"><div class="guide-toolbar"><div><h2 id="catalog-title">{subtitle}</h2><p id="catalog-status" role="status" aria-live="polite">전체 {len(entries)}{unit}</p></div></div>{filters}{change_filters}<noscript><p class="no-script">전체 목록을 읽을 수 있습니다. 분류는 자바스크립트가 활성화된 경우 사용할 수 있습니다.</p></noscript>{empty_state()}<div class="catalog-grid">{''.join(cards)}</div></section>
<aside class="catalog-end"><p>설명 기준 Astrobirth v{data['version']} · 확인 {data['reviewed']}</p><a href="./index.html">입문 Q&amp;A로 돌아가기 ↗</a></aside>{detail_dialog}'''
    write_page(page, '캐릭터 가이드' if is_players else '아이템 가이드', catalog['intro'], content, 'catalog.js')
    print(f'Generated {page}.html: {len(entries)} cards.')


def render_rooms():
    content = (ROOT / 'scripts/guide-rooms.html').read_text(encoding='utf-8')
    content = content.replace('{{ROOM_INTRO}}', esc(room_data['intro']['body']))
    write_page('rooms', '방 변경사항', '기본 게임과 Astrobirth의 방 프리셋을 비교합니다. 위치별 스폰 후보와 문, 가중치, 변경·추가·제거된 방을 확인할 수 있습니다.', content, 'rooms.js')
    print('Generated rooms.html: 52 room file comparisons.')


def render_upgrades():
    automatic = sum(pattern['chance'] > 0 for pattern in upgrades['patterns'])
    direct = len(upgrades['patterns']) - automatic
    sections, count, chapter_links = render_sections([{
        'id': 'upgrade-probabilities', 'title': '업그레이드 전체 목록',
        'subtitle': f'자동 대체 {automatic}종 · 직접 변환 전용 {direct}종', 'entries': upgrades['entries']}])
    content = f'''<section class="hero" id="overview" aria-labelledby="page-title"><p class="eyebrow">Astro-Items · 아이템 강화</p><h1 id="page-title">업그레이드 확률</h1><p class="hero-copy">{esc(upgrades['intro'])}</p><p class="hero-detail-link"><a href="./index.html#item-upgrades">입문 가이드에서 업그레이드 사용 방법 읽기 ↗</a></p></section>
<aside class="catalog-note"><strong>확률을 읽는 방법</strong><div class="entry-body"><p>각 확률은 원본 아이템이 새로 결정될 때의 조건부 대체 확률입니다. 전체 아이템 중 강화 아이템이 등장하는 비율이나 원본의 등장 확률을 뜻하지 않습니다. 행운 보정은 없으며, 이미 나온 아이템을 줍거나 방에 재입장해도 재판정하지 않습니다.</p><p>리롤로 새 아이템을 뽑을 때도 적용합니다. 알비레오·Ctrl 조합 등 직접 변환은 별도의 조건을 확인합니다.</p></div></aside>
{''.join(sections)}'''
    write_page('upgrades', '업그레이드 확률', upgrades['intro'], content, 'guide.js')
    print(f'Generated upgrades.html: {len(upgrades["patterns"])} patterns.')


build_search_index()
render_qa()
render_rules()
render_catalog('items', items, {'passive': '패시브', 'active': '액티브', 'trinket': '장신구', 'card': '카드'}, '아이템 가이드', '아이템 목록')
render_catalog('players', players, {'normal': '일반', 'tainted': '더럽혀진'}, '캐릭터 가이드', '캐릭터 목록')
render_rooms()
render_upgrades()
