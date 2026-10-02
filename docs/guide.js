(() => {
  'use strict';
  const moved = {
    items: '', 'guppy-head': 'guppy-head', 'eternal-d6': 'eternal-d6',
    'vanishing-twin': 'vanishing-twin', 'the-wiz': 'the-wiz',
    technology: 'technology', 'blood-oath': 'blood-oath', 'auto-smelt': 'silver-dollar'
  };
  const oldId = location.hash.slice(1);
  if (Object.hasOwn(moved, oldId)) {
    location.replace('./items.html' + (moved[oldId] ? '#' + moved[oldId] : ''));
    return;
  }
  const search = document.querySelector('#guide-search');
  const clear = document.querySelector('#clear-search');
  const status = document.querySelector('#search-status');
  const empty = document.querySelector('#empty-state');
  const entries = [...document.querySelectorAll('.entry')];
  const sections = [...document.querySelectorAll('.guide-section')];
  const navLinks = [...document.querySelectorAll('.section-nav a')];
  const normalize = value => value.normalize('NFKC').toLocaleLowerCase('ko').replace(/\s+/g, ' ').trim();
  const index = new Map(entries.map(entry => [entry, normalize(
    [...entry.querySelectorAll('.entry-title, .entry-body p, .effect-group h3, .rule-list li, .reward-table th, .reward-table td, .watch-note, .entry-links a')]
      .map(part => part.textContent).join(' ') + ' ' + (entry.dataset.keywords || '')
  )]));
  let savedOpen = null;

  function filter() {
    const words = normalize(search.value).split(' ').filter(Boolean);
    if (words.length && savedOpen === null) savedOpen = new Set(entries.filter(e => e.open));
    let count = 0;
    for (const entry of entries) {
      const match = words.every(word => index.get(entry).includes(word));
      entry.hidden = !match;
      if (words.length) entry.open = match;
      else if (savedOpen !== null) entry.open = savedOpen.has(entry);
      if (match) count++;
    }
    if (!words.length) savedOpen = null;
    for (const section of sections) section.hidden = !section.querySelector('.entry:not([hidden])');
    empty.hidden = count > 0;
    clear.hidden = words.length === 0;
    status.textContent = words.length ? `검색 결과 ${count}개` : `전체 ${entries.length}개`;
  }

  function resetSearch() {
    search.value = '';
    filter();
  }

  function openHash() {
    let id;
    try { id = decodeURIComponent(location.hash.slice(1)); } catch { return; }
    const target = document.getElementById(id);
    if (!target) return;
    if (target.classList.contains('entry')) {
      resetSearch();
      target.open = true;
      requestAnimationFrame(() => target.scrollIntoView({block: 'start'}));
    }
  }

  search.addEventListener('input', filter);
  clear.addEventListener('click', () => { resetSearch(); search.focus(); });
  document.querySelector('#reset-search').addEventListener('click', () => { resetSearch(); search.focus(); });
  document.addEventListener('keydown', event => {
    if (event.key === '/' && !event.ctrlKey && !event.metaKey && !event.altKey &&
        !['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement.tagName) && !document.activeElement.isContentEditable) {
      event.preventDefault(); search.focus();
    }
    if (event.key === 'Escape' && document.activeElement === search) resetSearch();
  });
  document.querySelectorAll('a[href^="#"]').forEach(link => link.addEventListener('click', () => {
    resetSearch();
    const target = document.getElementById(link.getAttribute('href').slice(1));
    if (target?.classList.contains('entry')) target.open = true;
  }));

  if ('IntersectionObserver' in window) {
    const visible = new Map();
    const observer = new IntersectionObserver(changes => {
      changes.forEach(change => visible.set(change.target.id, change.isIntersecting));
      const current = ['overview', ...sections.map(section => section.id)].find(id => visible.get(id));
      if (!current) return;
      navLinks.forEach(link => {
        if (link.hash === '#' + current) link.setAttribute('aria-current', 'location');
        else link.removeAttribute('aria-current');
      });
    }, {rootMargin: '-10% 0px -60% 0px'});
    [document.querySelector('#overview'), ...sections].forEach(section => observer.observe(section));
  }
  window.addEventListener('hashchange', openHash);
  openHash();
  filter();
})();
