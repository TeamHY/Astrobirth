#!/usr/bin/env python3
"""Generate the static Q&A, item catalog and player catalog."""
import html
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / 'docs'
data = json.loads((DOCS / 'guide-content.json').read_text(encoding='utf-8'))
items = json.loads((DOCS / 'items-content.json').read_text(encoding='utf-8'))
players = json.loads((DOCS / 'players-content.json').read_text(encoding='utf-8'))
layout = (ROOT / 'scripts/guide-layout.html').read_text(encoding='utf-8')
esc = html.escape


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
    if references:
        material['references'] = references
    reference = json.dumps(material, ensure_ascii=False, indent=2)
    reference = reference.replace('--', '\\u002d\\u002d')
    return '\n<!-- Agent reference material\n' + reference + '\n-->\n'


def permalink(entry):
    label = esc(entry['title'] + ' 고유 링크', quote=True)
    return f'''<a class="permalink" href="#{entry['id']}" aria-label="{label}" title="이 설명의 고유 링크"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M10 13a5 5 0 0 0 7.1 0l3-3a5 5 0 0 0-7.1-7.1l-1.7 1.7M14 11a5 5 0 0 0-7.1 0l-3 3a5 5 0 0 0 7.1 7.1l1.7-1.7"/></svg></a>'''


def body(entry, include_body=True):
    parts = [f'<p>{esc(entry["body"])}</p>'] if include_body else []
    if entry.get('rules'):
        parts.append('<ul class="rule-list">' + ''.join(f'<li>{esc(rule)}</li>' for rule in entry['rules']) + '</ul>')
    groups = ''.join(f'<section class="effect-group"><h3>{esc(group["title"])}</h3><ul class="rule-list">' + ''.join(f'<li>{esc(rule)}</li>' for rule in group['items']) + '</ul></section>' for group in entry.get('effectGroups', []))
    if not entry.get('tableFirst'):
        parts.append(groups)
    if entry.get('rewardTable'):
        table = entry['rewardTable']
        headers = ''.join(f'<th scope="col">{esc(column)}</th>' for column in table['columns'])
        rows = ''.join('<tr><th scope="row">' + esc(row[0]) + '</th>' + ''.join(f'<td>{esc(cell)}</td>' for cell in row[1:]) + '</tr>' for row in table['rows'])
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
            parts.append(f'<p><strong>{esc(category["label"])}</strong> {esc(", ".join(category["items"]))}</p>')
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
    prefix = '' if page == 'index' else './index.html'
    navigation = [f'<a href="{prefix}#overview"><span class="nav-number">00</span> 먼저 읽어보기</a>']
    for number, section in enumerate(data['sections'], 1):
        navigation.append(f'<a href="{prefix}#{section["id"]}"><span class="nav-number">{number:02}</span> {esc(section["title"])}</a>')
    tabs = '<nav class="page-tabs" aria-label="가이드 탭">' + ''.join(
        f'<a href="./{key}.html"' + (' aria-current="page"' if key == page else '') + f'>{esc(label)}</a>'
        for key, label in [('index', '입문 Q&A'), ('items', '아이템 변경사항'), ('players', '플레이어 변경사항')]) + '</nav>'
    replacements = {'PAGE_TITLE': esc(title), 'DESCRIPTION': esc(description, quote=True),
                    'NAV': ''.join(navigation), 'TABS': tabs, 'CONTENT': content,
                    'REVIEWED': data['reviewed'], 'VERSION': data['version'],
                    'SHA': data['sources']['Astrobirth'], 'SCRIPT': script}
    output = layout
    for key, value in replacements.items():
        output = output.replace('{{' + key + '}}', value)
    assert '{{' not in output, 'Unresolved template value'
    output = '\n'.join(line.rstrip() for line in output.splitlines()) + '\n'
    (DOCS / (page + '.html')).write_text(output, encoding='utf-8')


def search_box(id, label, placeholder):
    return f'<div class="searchbox"><label for="{id}" class="sr-only">{label}</label><span class="search-icon" aria-hidden="true"></span><input type="search" id="{id}" placeholder="{placeholder}" autocomplete="off"><button id="clear-search" type="button" aria-label="검색어 지우기" hidden>×</button></div>'


def empty_state(label):
    hint = '이름이나 효과로 검색할 수 있습니다. 분류를 ‘전체’로 설정하면 모든 항목을 검색할 수 있습니다.'
    if label == '전체 Q&A 보기':
        hint = '‘에이플’, ‘노피격’ 등의 키워드로 검색할 수 있습니다. 개별 아이템과 캐릭터는 변경사항 탭에서 확인할 수 있습니다.'
    return f'<div class="empty-state" id="empty-state" hidden><h3>일치하는 설명이 없습니다.</h3><p>{hint}</p><button type="button" id="reset-search">{label}</button></div>'


def render_qa():
    seen, sections, count = set(), [], 0
    for number, section in enumerate(data['sections'], 1):
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
    content = f'''
<section class="hero" id="overview" aria-labelledby="page-title">
<div><p class="eyebrow">입문 안내</p><h1 id="page-title">Astrobirth 대결<br><span>시청자 가이드</span></h1><p class="hero-copy">헌영의 아이작 대결에 사용되는 Astrobirth의 주요 변경사항을 설명합니다.<br>노피격으로 에이플을 확보·유지하는 과정과 보상 변화를 중심으로 정리했습니다.<br>세부 아이템 및 플레이어 변경사항은 각 탭에서 확인할 수 있습니다.</p></div>
<div class="hero-art" aria-hidden="true"><div class="artifact-disc"><img src="./assets/items/perfection.png" alt="" width="112" height="112"></div><span class="artifact-label">A+ / PERFECTION</span></div></section>
<section class="quickstart" aria-labelledby="quickstart-title"><div class="quickstart-heading"><h2 id="quickstart-title">대결 관전에 필요한 주요 변경사항</h2><span class="pill">입문 안내</span></div><div class="quick-grid">
<div class="quick-step"><span class="quick-num">01<span class="quick-label"> / NO HIT</span></span><h3>노피격으로 에이플을 확보합니다.</h3><p>올백은 방송에서 에이플이라고 부릅니다. 연속 노피격으로 획득하며, 이후에도 피격을 피해야 유지할 수 있습니다.</p><a href="#perfection-basics">노피격과 에이플 안내</a></div>
<div class="quick-step"><span class="quick-num">02<span class="quick-label"> / REWARD</span></span><h3>에이플을 유지하면 보상이 늘어납니다.</h3><p>보스 추가 보상, 장신구 강화와 저주 제거 조건을 충족합니다. 보스 처치 시점의 에이플·낙제 소지가 중요합니다.</p><a href="#perfection">구간별 추가 보상</a></div>
<div class="quick-step"><span class="quick-num">03<span class="quick-label"> / PENALTY</span></span><h3>피격으로 이후 보상도 달라집니다.</h3><p>에이플을 잃은 뒤 낙제를 주우면 보상 조건을 이어 갈 수 있습니다. 낙제마저 잃으면 이후 추가 보상이 줄어듭니다.</p><a href="#perfection-loss">에이플과 낙제의 변화</a></div></div></section>
<div class="collection-links" aria-label="변경사항 찾아보기">
<a href="./items.html"><span class="collection-preview" aria-hidden="true"><img src="./assets/items/guppy-head.png" alt=""><img src="./assets/items/the-wiz.png" alt=""><img src="./assets/items/technology.png" alt=""></span><span><strong>아이템 변경사항 ↗</strong><small>원본 아이콘과 {len(items['entries'])}개 아이템의 변경 효과</small></span></a>
<a href="./players.html"><span class="collection-preview player-preview" aria-hidden="true"><img src="./assets/players/isaac.svg" alt=""><img src="./assets/players/magdalene.svg" alt=""></span><span><strong>플레이어 변경사항 ↗</strong><small>시작 세팅 · 고유 규칙 · 캐릭터별 금지</small></span></a></div>
<section id="guide" aria-labelledby="guide-title"><div class="guide-toolbar"><div><h2 id="guide-title">주요 규칙 Q&A</h2><p id="search-status" role="status" aria-live="polite">전체 {count}개</p></div>{search_box('guide-search','Q&A 검색','에이플, 노피격, 낙제…')}</div>
<noscript><p class="no-script">목차와 모든 설명을 그대로 읽을 수 있습니다. 검색은 자바스크립트가 활성화된 경우 사용할 수 있습니다.</p></noscript>{empty_state('전체 Q&A 보기')}{''.join(sections)}</section>
<aside class="scope-note" aria-labelledby="scope-title"><span class="scope-icon" aria-hidden="true">i</span><div><h2 id="scope-title">모드 기능과 경기 운영 규칙</h2><p>Astrobirth와 기반 모드 Astro-Items의 기능을 설명합니다. 경기 목표, 허용 아이템, 보조 모드와 밴 해제 여부는 해당 방송의 공지가 우선입니다. 업데이트 후 실제 게임과 다를 수 있습니다.<br>직접 플레이하는 경우 <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=3260980911" target="_blank" rel="noopener noreferrer">Astro-Items</a>와 <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=1630138997" target="_blank" rel="noopener noreferrer">한국어 아이템 설명 모드</a>도 참고할 수 있습니다.</p></div></aside>'''
    write_page('index', '입문 Q&A', '헌영의 아이작 대결을 처음 보는 시청자를 위한 입문 Q&A입니다. 아이템 및 플레이어 변경사항을 함께 설명합니다.', content, 'guide.js')
    print(f'Generated index.html: {len(sections)} sections, {count} entries.')


def render_catalog(page, catalog, kinds, title, subtitle):
    entries, cards, seen = catalog['entries'], [], set()
    is_players = page == 'players'
    for entry in entries:
        assert entry['id'] not in seen, 'Duplicate catalog ID'
        assert (DOCS / entry['image']).is_file(), 'Missing image: ' + entry['image']
        seen.add(entry['id'])
        tag = kinds[entry['kind']] + ('' if is_players else ' · ' + entry['tag'])
        detail_entry = entry
        if entry.get('detailsFrom'):
            shared = next((qa for section in data['sections'] for qa in section['entries'] if qa['id'] == entry['detailsFrom']), None)
            assert shared is not None, 'Missing shared details: ' + entry['detailsFrom']
            detail_entry = {**shared, **entry}
        has_details = any(detail_entry.get(key) for key in ['rules', 'effectGroups', 'rewardTable', 'watch', 'caution', 'restrictions', 'restrictionNote', 'related', 'relatedLinks'])
        details = source_comment(detail_entry)
        if has_details:
            details = f'<details class="catalog-details"><summary>{"시작 세팅 및 금지 목록" if is_players else "세부 조건 보기"}</summary><div class="entry-body">{body(detail_entry, False)}</div></details>'
        cards.append(f'''<article class="catalog-card{' player-card' if is_players else ''}" id="{entry['id']}" data-kind="{entry['kind']}" data-keywords="{esc(entry.get('keywords',''), quote=True)}"><div class="catalog-card-heading"><div class="catalog-icon"><img src="./{esc(entry['image'])}" alt="{esc(entry['title'], quote=True)} {'캐릭터' if is_players else '아이콘'}" width="80" height="80" loading="lazy" decoding="async"></div><div><span class="catalog-kind">{esc(tag)}</span><h2 class="catalog-title-row"><span>{esc(entry['title'])}</span>{permalink(entry)}</h2><p class="english-name">{esc(entry['name'])}</p></div></div><p class="catalog-scene">{esc(entry['scene'])}</p><p class="catalog-description">{esc(entry['body'])}</p>{details}</article>''')
    buttons = [f'<button type="button" data-kind="all" aria-pressed="true">전체 <span>{len(entries)}</span></button>']
    for key, label in kinds.items():
        count = sum(entry['kind'] == key for entry in entries)
        buttons.append(f'<button type="button" data-kind="{key}" aria-pressed="false">{label} <span>{count}</span></button>')
    art = '<img src="./assets/players/isaac.svg" alt=""><img src="./assets/players/thelost_b.svg" alt="">' if is_players else '<img src="./assets/items/guppy-head.png" alt=""><img src="./assets/items/technology.png" alt=""><img src="./assets/items/vanishing-twin.png" alt="">'
    common = '<div class="player-common"><a href="./index.html#no-hit"><span>핵심 규칙</span><strong>노피격과 에이플 ↗</strong><p>올백·낙제 유지에 따라 추가 보상이 달라집니다.</p></a><a href="./index.html#health-limit"><span>후반 생존</span><strong>체력 상한 제한 ↗</strong><p>일부 캐릭터는 적용 방식과 예외가 다릅니다.</p></a><a href="./index.html#lost-shield"><span>로스트 계열</span><strong>보호막 손실 패널티 ↗</strong><p>보호막만 깨져도 능력치가 내려갑니다.</p></a></div>' if is_players else '<p class="catalog-note"><strong>기본 효과 대비 변경사항을 설명합니다.</strong> 기본 아이템 설명에 더해지는 변경사항입니다. 황금·강화 장신구는 해당 조건을 충족해야 추가 효과가 적용됩니다.</p>'
    content = f'''<section class="hero catalog-hero" id="overview" aria-labelledby="page-title"><div><p class="eyebrow">{'플레이어' if is_players else '아이템'} 변경사항</p><h1 id="page-title">{title}</h1><p class="hero-copy">{esc(catalog['intro'])}</p></div><div class="catalog-hero-art{' portraits' if is_players else ''}" aria-hidden="true">{art}<span>{len(entries)} {'CHARACTERS' if is_players else 'ITEMS'}</span></div></section>{common}
<section class="catalog" id="catalog" aria-labelledby="catalog-title"><div class="guide-toolbar"><div><h2 id="catalog-title">{subtitle}</h2><p id="search-status" role="status" aria-live="polite">전체 {len(entries)}개</p></div>{search_box('catalog-search','플레이어 이름·변경사항 검색' if is_players else '아이템 이름·변경 효과 검색','아이작, 로스트, 시작 아이템…' if is_players else '구피, 연사, 황금 장신구…')}</div><div class="catalog-filters" role="group" aria-label="{'플레이어' if is_players else '아이템'} 분류">{''.join(buttons)}</div><noscript><p class="no-script">모든 변경사항을 읽을 수 있습니다. 검색과 분류는 자바스크립트가 활성화된 경우 사용할 수 있습니다.</p></noscript>{empty_state('전체 변경사항 보기')}<div class="catalog-grid">{''.join(cards)}</div></section>
<aside class="catalog-end"><p>설명 기준 Astrobirth v{data['version']} · 확인 {data['reviewed']}</p><a href="./index.html">입문 Q&amp;A로 돌아가기 ↗</a></aside>'''
    write_page(page, '플레이어 변경사항' if is_players else '아이템 변경사항', catalog['intro'], content, 'catalog.js')
    print(f'Generated {page}.html: {len(entries)} cards.')


render_qa()
render_catalog('items', items, {'passive': '패시브', 'active': '액티브', 'trinket': '장신구'}, '아이템<br><span>변경사항</span>', '아이템별 변경사항')
render_catalog('players', players, {'normal': '일반', 'tainted': '더럽혀진', 'custom': '모드 캐릭터'}, '플레이어별<br><span>변경사항</span>', '플레이어별 변경사항')
