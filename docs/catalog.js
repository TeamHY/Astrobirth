(() => {
  'use strict';
  const search = document.querySelector('#catalog-search');
  const clear = document.querySelector('#clear-search');
  const status = document.querySelector('#search-status');
  const empty = document.querySelector('#empty-state');
  const cards = [...document.querySelectorAll('.catalog-card')];
  const buttons = [...document.querySelectorAll('.catalog-filters button')];
  const changeButtons = [...document.querySelectorAll('.change-filters button')];
  const normalize = value => value.normalize('NFKC').toLocaleLowerCase('ko')
    .replace(/[’']/g, '').replace(/\s+/g, ' ').trim();
  const searchable = '.catalog-kind, h2, .english-name, .catalog-scene, .catalog-description, .effect-group h3, .rule-list li, .reward-table th, .reward-table td, .watch-note, .detail-caution, .restriction-list p, .restriction-note, .entry-links a';
  const index = new Map(cards.map(card => [card, normalize(
    [...card.querySelectorAll(searchable)].map(part => part.textContent).join(' ') + ' ' + card.dataset.keywords
  )]));
  let kind = 'all';
  let change = 'all';

  function filter() {
    const words = normalize(search.value).split(' ').filter(Boolean);
    let count = 0;
    cards.forEach(card => {
      const match = (kind === 'all' || card.dataset.kind === kind) &&
        (change === 'all' || card.dataset.changes.split(' ').includes(change)) &&
        words.every(word => index.get(card).includes(word));
      card.hidden = !match;
      if (match) count++;
    });
    buttons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.kind === kind)));
    changeButtons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.change === change)));
    clear.hidden = !search.value;
    empty.hidden = count > 0;
    status.textContent = !words.length && kind === 'all' && change === 'all' ? `전체 ${cards.length}개` : `찾은 변경사항 ${count}개 · 전체 ${cards.length}개`;
  }

  function reset() {
    kind = 'all';
    change = 'all';
    search.value = '';
    filter();
  }

  function openHash() {
    let id;
    try { id = decodeURIComponent(location.hash.slice(1)); } catch { return; }
    const target = document.getElementById(id);
    if (!target?.classList.contains('catalog-card')) return;
    reset();
    const details = target.querySelector('details');
    if (details) details.open = true;
    requestAnimationFrame(() => target.scrollIntoView({block: 'start'}));
  }

  search.addEventListener('input', filter);
  clear.addEventListener('click', () => { search.value = ''; filter(); search.focus(); });
  buttons.forEach(button => button.addEventListener('click', () => { kind = button.dataset.kind; filter(); }));
  changeButtons.forEach(button => button.addEventListener('click', () => { change = button.dataset.change; filter(); }));
  document.querySelector('#reset-search').addEventListener('click', () => { reset(); search.focus(); });
  document.querySelectorAll('.catalog-card a[href^="#"]').forEach(link => link.addEventListener('click', () => {
    reset();
    document.getElementById(link.hash.slice(1))?.querySelector('details')?.setAttribute('open', '');
  }));
  document.addEventListener('keydown', event => {
    if (event.key === '/' && !event.ctrlKey && !event.metaKey && !event.altKey &&
        !['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement.tagName) && !document.activeElement.isContentEditable) {
      event.preventDefault(); search.focus();
    }
    if (event.key === 'Escape' && document.activeElement === search) { search.value = ''; filter(); }
  });
  window.addEventListener('hashchange', openHash);
  filter();
  openHash();
})();
