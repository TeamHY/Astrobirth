#!/usr/bin/env python3
"""Generate the buildless Pages guide from reviewed, source-linked content."""
import html
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / 'docs'
data = json.loads((DOCS / 'guide-content.json').read_text(encoding='utf-8'))
esc = html.escape
seen = {'main', 'overview', 'guide', 'guide-search', 'search-status', 'empty-state', 'clear-search', 'reset-search'}

def source_link(repo, path):
    sha = data['sources'][repo]
    return f'<a href="https://github.com/TeamHY/{repo}/blob/{sha}/{esc(path, quote=True)}" target="_blank" rel="noopener noreferrer">{esc(repo)} 근거</a>'

sections = []
navigation = ['<a href="#overview" aria-current="location"><span class="nav-number">00</span> 먼저 읽어보기</a>']
count = 0
for number, section in enumerate(data['sections'], 1):
    assert section['id'] not in seen, 'Duplicate section ID'
    seen.add(section['id'])
    navigation.append(f'<a href="#{section["id"]}"><span class="nav-number">{number:02}</span> {esc(section["title"])}</a>')
    entries = []
    for entry in section['entries']:
        assert entry['id'] not in seen, 'Duplicate entry ID'
        seen.add(entry['id'])
        count += 1
        parts = [f'<p>{esc(entry["body"])}</p>']
        if entry.get('rules'):
            parts.append('<ul class="rule-list">' + ''.join(f'<li>{esc(rule)}</li>' for rule in entry['rules']) + '</ul>')
        if entry.get('watch'):
            parts.append(f'<div class="watch-note"><strong>이 장면을 볼 때</strong>{esc(entry["watch"])}</div>')
        if entry.get('caution'):
            parts.append(f'<p class="detail-caution">{esc(entry["caution"])}</p>')
        links = [f'<a href="#{entry["id"]}">이 설명의 고유 링크</a>']
        if entry.get('source'):
            links.append(source_link('Astrobirth', entry['source']))
        for path in entry.get('extraSources', []):
            links.append(source_link('Astrobirth', path))
        for path in entry.get('itemSources', []):
            links.append(source_link('Astro-Items', path))
        if entry.get('related'):
            links.append(f'<a href="#{esc(entry["related"])}">관련 설명 읽기</a>')
        parts.append('<div class="entry-links">' + ''.join(links) + '</div>')
        opened = ' open' if entry.get('open') else ''
        keywords = esc(entry.get('keywords', ''), quote=True)
        entries.append(f'''<details class="entry" id="{entry['id']}" data-keywords="{keywords}"{opened}>
<summary><span><span class="entry-title">{esc(entry['title'])}</span><span class="entry-scene">{esc(entry['scene'])}</span></span><span class="entry-tag">{esc(entry['tag'])}</span></summary>
<div class="entry-body">{''.join(parts)}</div></details>''')
    extra = ' terms-section' if section['id'] == 'terms' else ''
    sections.append(f'''<section class="guide-section{extra}" id="{section['id']}" aria-labelledby="heading-{section['id']}">
<div class="section-heading"><span class="section-index">{number:02}</span><h2 id="heading-{section['id']}">{esc(section['title'])}</h2><p>{esc(section['subtitle'])}</p></div>
{''.join(entries)}</section>''')

template = '''<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="theme-color" content="#172726">
<title>Astrobirth 가이드 | 헌영의 아이작 대결, 처음부터 함께 보기</title>
<meta name="description" content="헌영의 아이작 대결을 처음 보는 시청자를 위한 Astrobirth 가이드. 시작 아이템, 이동 포탈, 피격 패널티, 체력 제한, 다음 런 밴과 달라진 아이템 효과를 쉽게 설명합니다.">
<link rel="icon" type="image/svg+xml" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Crect width='32' height='32' rx='8' fill='%23172726'/%3E%3Cpath d='M16 4l3.4 8.6L28 16l-8.6 3.4L16 28l-3.4-8.6L4 16l8.6-3.4z' fill='%23d7f98b'/%3E%3C/svg%3E">
<link rel="stylesheet" href="./guide.css">
<script src="./guide.js" defer></script>
</head>
<body>
<a class="skip-link" href="#main">본문으로 이동</a>
<aside class="sidebar" aria-label="가이드 탐색">
  <a class="brand" href="#overview" aria-label="Astrobirth 가이드 처음으로"><span class="brand-mark" aria-hidden="true">✦</span><span><span class="brand-name">Astrobirth</span><span class="brand-caption" style="display:block">VIEWER’S GUIDE</span></span></a>
  <p class="sidebar-intro">헌영의 아이작 대결을<br>처음 보는 당신을 위해.</p>
  <p class="nav-label">가이드 목차</p>
  <nav class="section-nav" aria-label="주제별 목차">{{NAV}}</nav>
  <div class="sidebar-bottom">
    <a href="https://www.youtube.com/user/afreecaBJHY/" target="_blank" rel="noopener noreferrer">헌영 유튜브</a>
    <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=2492350811" target="_blank" rel="noopener noreferrer">대결 모드 워크숍</a>
    <div class="version"><strong>Astrobirth v{{VERSION}}</strong><br>설명 확인 {{REVIEWED}}<br>Astro-Items 변경 사항 포함</div>
  </div>
</aside>
<div class="shell">
  <header class="topbar"><span>헌영의 아이작 대결 / 시청자 가이드</span><a href="https://github.com/TeamHY/Astrobirth" target="_blank" rel="noopener noreferrer"><span class="mini-dot" aria-hidden="true"></span> 모드 저장소</a></header>
  <main id="main">
    <section class="hero" id="overview" aria-labelledby="page-title">
      <div><p class="eyebrow">대결을 처음 본다면</p><h1 id="page-title">아이작은 익숙한데,<br><span>대결은 처음이라면.</span></h1>
      <p class="hero-copy">왜 아이템이 사라졌지? 저 포탈은 뭐지?<br>평소 아이작과 다른 장면들을 하나씩 풀어 봅니다.<br>모든 변경 사항을 외우지 않아도, 대결의 흐름은 따라갈 수 있어요.</p></div>
      <div class="hero-art" aria-hidden="true"><div class="artifact-disc"><img src="./assets/spinup-dice.png" alt="" width="112" height="112"></div><span class="artifact-label">A DIFFERENT RUN.</span></div>
    </section>
    <section class="quickstart" aria-labelledby="quickstart-title">
      <div class="quickstart-heading"><h2 id="quickstart-title">이 세 가지만 먼저 알고 보세요</h2><span class="pill">처음 보는 분께</span></div>
      <div class="quick-grid">
        <div class="quick-step"><span class="quick-num">01<span class="quick-label"> / START</span></span><h3>출발부터 조금 달라요</h3><p>캐릭터별 시작 세팅과 아이템 선택 규칙이 달라집니다. 여러 개가 보여도 전부 먹을 수는 없어요.</p><a href="#start">시작방 이해하기</a></div>
        <div class="quick-step"><span class="quick-num">02<span class="quick-label"> / ROUTE</span></span><h3>왕복 시간을 줄여요</h3><p>초반 보스를 잡으면 주요 방을 잇는 포탈이 열립니다. 루트 진행에 필요한 조각도 추가로 받아요.</p><a href="#travel">이동 변화 알아보기</a></div>
        <div class="quick-step"><span class="quick-num">03<span class="quick-label"> / SURVIVE</span></span><h3>한 대의 무게가 커져요</h3><p>맞으면 체력 외에 지정 아이템도 잃을 수 있습니다. 후반에는 체력을 담을 수 있는 칸도 줄어들어요.</p><a href="#combat">피격 패널티 읽기</a></div>
      </div>
    </section>
    <section id="guide" aria-labelledby="guide-title">
      <div class="guide-toolbar"><div><h2 id="guide-title">방송 속 궁금한 장면 찾기</h2><p id="search-status" role="status" aria-live="polite">{{COUNT}}개의 이야기</p></div>
        <div class="searchbox"><label for="guide-search" class="sr-only" style="position:absolute;width:1px;height:1px;padding:0;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap">기능, 아이템, 방송 용어 검색</label><span class="search-icon" aria-hidden="true"></span><input type="search" id="guide-search" placeholder="포탈, 밴, 로스트, 구피…" autocomplete="off"><button id="clear-search" type="button" aria-label="검색어 지우기" hidden>×</button></div>
      </div>
      <noscript><p class="no-script">아래 목차와 설명은 그대로 읽을 수 있습니다. 검색 기능은 자바스크립트를 켜면 사용할 수 있어요.</p></noscript>
      <div class="empty-state" id="empty-state" hidden><h3>아직 이 단어의 설명은 없어요</h3><p>‘포탈’, ‘밴’, ‘로스트’처럼 짧은 단어로 다시 찾아보세요.</p><button type="button" id="reset-search">전체 가이드 보기</button></div>
      {{SECTIONS}}
    </section>
    <aside class="scope-note" aria-labelledby="scope-title"><span class="scope-icon" aria-hidden="true">i</span><div><h2 id="scope-title">모드의 기능과 경기 규칙은 구분해서 봐 주세요</h2>
      <p>이 가이드는 Astrobirth와 기반 모드 Astro-Items에서 확인한 기능을 입문자 관점으로 설명합니다. 경기 목표, 허용 아이템, 보조 모드와 밴 해제 여부는 해당 방송의 공지가 우선입니다. 모든 아이템 변경을 다룬 사전은 아니며, 업데이트 후에는 실제 게임의 설명과 다를 수 있습니다.<br>직접 플레이한다면 <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=3260980911" target="_blank" rel="noopener noreferrer">Astro-Items</a>와 <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=1630138997" target="_blank" rel="noopener noreferrer">한국어 아이템 설명 모드</a>도 확인하세요.</p></div>
    </aside>
  </main>
  <footer><span>Astrobirth · 처음 보는 시청자를 위한 가이드</span><span>설명 확인 {{REVIEWED}} · <a href="https://github.com/TeamHY/Astrobirth/commit/{{SHA}}" target="_blank" rel="noopener noreferrer">설명 기준 버전</a> · <a href="https://github.com/TeamHY/Astrobirth/issues" target="_blank" rel="noopener noreferrer">내용 오류 제보</a></span></footer>
</div>
</body>
</html>
'''
for key, value in {
    'NAV': ''.join(navigation), 'SECTIONS': '\n'.join(sections),
    'COUNT': str(count), 'REVIEWED': data['reviewed'], 'VERSION': data['version'],
    'SHA': data['sources']['Astrobirth']
}.items():
    template = template.replace('{{' + key + '}}', value)
assert '{{' not in template, 'Unresolved template value'
(DOCS / 'index.html').write_text(template, encoding='utf-8')
print(f'Generated docs/index.html: {len(data["sections"])} sections, {count} entries.')
