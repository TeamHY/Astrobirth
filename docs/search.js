(() => {
  'use strict';
  const trigger = document.getElementById('open-global-search');
  const dialog = document.getElementById('global-search-dialog');
  const input = document.getElementById('global-search-input');
  const results = document.getElementById('global-search-results');
  const status = document.getElementById('global-search-status');
  const clear = document.getElementById('clear-global-search');
  const more = document.getElementById('more-search-results');
  const retry = document.getElementById('retry-global-search');
  const pages = {index: '입문 Q&A', rules: '전체 규칙', items: '아이템 가이드', upgrades: '업그레이드 확률', players: '캐릭터 가이드'};
  const normalize = value => value.normalize('NFKC').toLocaleLowerCase('ko')
    .replace(/[’']/g, '').replace(/\s+/g, ' ').trim();
  let indexPromise, records, matches = [], shown = 0, request = 0, previousFocus;

  async function loadIndex() {
    if (!indexPromise) {
      indexPromise = fetch(dialog.dataset.index).then(response => {
        if (!response.ok) throw new Error('Search index unavailable');
        return response.json();
      }).then(data => {
        if (data.schema !== 1 || !Array.isArray(data.entries)) throw new Error('Invalid search index');
        records = data.entries.map((entry, order) => ({
          ...entry, order, titleKey: normalize(entry.title), nameKey: normalize(entry.name || ''),
          searchKey: normalize([entry.title, entry.name, entry.keywords, entry.text, entry.description, pages[entry.page]].join(' '))
        }));
        return records;
      }).catch(error => { indexPromise = null; throw error; });
    }
    return indexPromise;
  }

  function message(text) {
    const node = document.createElement('p');
    node.className = 'search-message';
    node.textContent = text;
    results.replaceChildren(node);
  }

  function excerpt(entry, words) {
    if (words.some(word => [entry.description, entry.title, entry.name || ''].some(value => normalize(value).includes(word)))) return entry.description.slice(0, 150) + (entry.description.length > 150 ? '…' : '');
    const text = entry.text || entry.description;
    const start = Math.min(...words.map(word => text.toLocaleLowerCase('ko').indexOf(word)).filter(position => position >= 0));
    const from = Number.isFinite(start) ? Math.max(0, start - 35) : 0;
    return (from ? '…' : '') + text.slice(from, from + 150) + (text.length > from + 150 ? '…' : '');
  }

  function renderMatches(append = false) {
    const start = append ? shown : 0;
    shown = Math.min(matches.length, start + 40);
    const fragment = document.createDocumentFragment();
    const words = normalize(input.value).split(' ').filter(Boolean);
    for (const entry of matches.slice(start, shown)) {
      const link = document.createElement('a');
      link.className = 'search-result';
      link.href = entry.href;
      if (entry.image) {
        const image = document.createElement('img');
        image.className = 'search-result-image';
        image.src = entry.image;
        image.alt = '';
        image.loading = 'lazy';
        image.width = image.height = 36;
        link.append(image);
      }
      const content = document.createElement('span');
      content.className = 'search-result-content';
      for (const [className, text] of [
        ['search-result-page', pages[entry.page]],
        ['search-result-title', entry.title],
        ['search-result-description', excerpt(entry, words)]
      ]) {
        const part = document.createElement('span');
        part.className = className;
        part.textContent = text;
        content.append(part);
      }
      link.append(content);
      fragment.append(link);
    }
    if (append) results.append(fragment);
    else { results.replaceChildren(fragment); results.scrollTop = 0; }
    more.hidden = shown >= matches.length;
    status.textContent = '검색 결과 ' + matches.length.toLocaleString('ko-KR') + '개' + (shown < matches.length ? ' · ' + shown + '개 표시' : '');
  }

  async function search() {
    const current = ++request;
    const query = normalize(input.value);
    clear.hidden = !input.value;
    more.hidden = retry.hidden = true;
    if (!query) {
      matches = [];
      status.textContent = 'Q&A·전체 규칙·아이템·캐릭터·업그레이드를 검색합니다.';
      message('이름이나 궁금한 규칙을 입력해 주세요.');
      return false;
    }
    if (!records) {
      status.textContent = '검색 자료를 불러오는 중입니다.';
      message('잠시만 기다려 주세요.');
    }
    try {
      const index = await loadIndex();
      if (current !== request || !dialog.open) return false;
      const words = query.split(' ');
      matches = index.filter(entry => words.every(word => entry.searchKey.includes(word))).map(entry => ({
        ...entry,
        score: (entry.titleKey === query || entry.nameKey === query ? 180 : entry.titleKey.includes(query) || entry.nameKey.includes(query) ? 100 : 0)
          + words.filter(word => entry.titleKey.includes(word)).length * 15
      })).sort((a, b) => b.score - a.score || a.order - b.order);
      if (matches.length) renderMatches();
      else {
        status.textContent = '검색 결과 0개';
        message('일치하는 설명이 없습니다. 다른 이름이나 규칙으로 검색해 보세요.');
      }
      return true;
    } catch {
      if (current !== request || !dialog.open) return;
      status.textContent = '검색 자료를 불러오지 못했습니다.';
      message('연결을 확인한 뒤 다시 불러올 수 있습니다.');
      retry.hidden = false;
      return false;
    }
  }

  function openSearch() {
    if (!dialog.open) {
      previousFocus = document.activeElement;
      dialog.showModal();
    }
    input.focus();
    input.select();
    search();
  }

  trigger.addEventListener('click', openSearch);
  document.getElementById('close-global-search').addEventListener('click', () => dialog.close());
  dialog.addEventListener('close', () => {
    ++request;
    if (previousFocus?.isConnected) previousFocus.focus({preventScroll: true});
  });
  dialog.addEventListener('click', event => {
    if (event.target !== dialog) return;
    const rect = dialog.getBoundingClientRect();
    if (event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom) dialog.close();
  });
  input.addEventListener('input', search);
  input.addEventListener('keydown', event => {
    if (event.key === 'ArrowDown') {
      event.preventDefault();
      results.querySelector('a')?.focus();
    }
  });
  document.getElementById('global-search-form').addEventListener('submit', async event => {
    event.preventDefault();
    if (await search()) results.querySelector('a')?.click();
  });
  clear.addEventListener('click', () => { input.value = ''; search(); input.focus(); });
  more.addEventListener('click', () => renderMatches(true));
  retry.addEventListener('click', search);
  results.addEventListener('click', event => {
    if (event.target.closest('a') && !event.ctrlKey && !event.metaKey && !event.shiftKey && !event.altKey) dialog.close();
  });
  results.addEventListener('keydown', event => {
    if (!['ArrowDown', 'ArrowUp', 'Home', 'End'].includes(event.key)) return;
    const links = [...results.querySelectorAll('a')];
    const current = links.indexOf(event.target.closest('a'));
    if (current < 0) return;
    event.preventDefault();
    if (event.key === 'ArrowUp' && current === 0) input.focus();
    else links[event.key === 'Home' ? 0 : event.key === 'End' ? links.length - 1 : Math.max(0, Math.min(links.length - 1, current + (event.key === 'ArrowDown' ? 1 : -1)))]?.focus();
  });
  document.addEventListener('keydown', event => {
    if (event.key === '/' && !event.ctrlKey && !event.metaKey && !event.altKey &&
        !['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement.tagName) && !document.activeElement.isContentEditable) {
      event.preventDefault();
      openSearch();
    }
  });
  trigger.hidden = false;
})();
