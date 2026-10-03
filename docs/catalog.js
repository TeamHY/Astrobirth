(() => {
  'use strict';
  const status = document.querySelector('#catalog-status');
  const empty = document.querySelector('#empty-state');
  const cards = [...document.querySelectorAll('.catalog-card')];
  const buttons = [...document.querySelectorAll('.catalog-filters button[data-kind]')];
  const originButtons = [...document.querySelectorAll('.catalog-filters button[data-origin]')];
  const changeButtons = [...document.querySelectorAll('.change-filters button')];
  const playerCatalog = originButtons.length > 0;
  let kind = 'all';
  let origin = 'all';
  let change = 'all';

  function filter() {
    let count = 0;
    cards.forEach(card => {
      const match = (kind === 'all' || card.dataset.kind === kind) &&
        (origin === 'all' || card.dataset.origin === origin) &&
        (change === 'all' || card.dataset.changes.split(' ').includes(change));
      card.hidden = !match;
      if (match) count++;
    });
    buttons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.kind === kind)));
    originButtons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.origin === origin)));
    changeButtons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.change === change)));
    if (playerCatalog) {
      buttons.forEach(button => {
        button.querySelector('span').textContent = cards.filter(card =>
          (origin === 'all' || card.dataset.origin === origin) &&
          (button.dataset.kind === 'all' || card.dataset.kind === button.dataset.kind)).length;
      });
      originButtons.forEach(button => {
        button.querySelector('span').textContent = cards.filter(card =>
          (kind === 'all' || card.dataset.kind === kind) &&
          (button.dataset.origin === 'all' || card.dataset.origin === button.dataset.origin)).length;
      });
    }
    empty.hidden = count > 0;
    if (playerCatalog) {
      const labels = [
        {base: '기본 캐릭터', mod: '모드 캐릭터'}[origin],
        {normal: '일반', tainted: '더럽혀진'}[kind]
      ].filter(Boolean);
      status.textContent = labels.length ? `${labels.join(' · ')} ${count}명 · 전체 ${cards.length}명` : `전체 ${cards.length}명`;
    } else {
      status.textContent = kind === 'all' && change === 'all' ? `전체 ${cards.length}개` : `분류된 변경사항 ${count}개 · 전체 ${cards.length}개`;
    }
  }

  function reset() {
    kind = 'all';
    origin = 'all';
    change = 'all';
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

  buttons.forEach(button => button.addEventListener('click', () => { kind = button.dataset.kind; filter(); }));
  originButtons.forEach(button => button.addEventListener('click', () => { origin = button.dataset.origin; filter(); }));
  changeButtons.forEach(button => button.addEventListener('click', () => { change = button.dataset.change; filter(); }));
  document.querySelector('#reset-filters').addEventListener('click', reset);
  document.addEventListener('click', event => {
    const link = event.target.closest('a[href]');
    if (!link || link.origin !== location.origin || link.pathname !== location.pathname || !link.hash) return;
    const target = document.getElementById(link.hash.slice(1));
    if (!target?.classList.contains('catalog-card')) return;
    reset();
    target.querySelector('details')?.setAttribute('open', '');
  });
  window.addEventListener('hashchange', openHash);
  filter();
  openHash();
})();
