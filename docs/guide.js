(() => {
  'use strict';
  const moved = {
    items: '', 'guppy-head': 'guppy-head', 'eternal-d6': 'eternal-d6',
    'vanishing-twin': 'vanishing-twin', 'the-wiz': 'the-wiz',
    technology: 'technology', 'blood-oath': 'blood-oath', 'auto-smelt': 'silver-dollar'
  };
  const oldId = location.hash.slice(1);
  if (document.body.dataset.page === 'index' && Object.hasOwn(moved, oldId)) {
    location.replace('./items.html' + (moved[oldId] ? '#' + moved[oldId] : ''));
    return;
  }
  const sections = [...document.querySelectorAll('.guide-section')];
  const navLinks = [...document.querySelectorAll('.section-nav a')];

  function openHash() {
    let id;
    try { id = decodeURIComponent(location.hash.slice(1)); } catch { return; }
    const target = document.getElementById(id);
    if (!target) return;
    if (target.classList.contains('entry')) {
      target.open = true;
      requestAnimationFrame(() => target.scrollIntoView({block: 'start'}));
    }
  }

  document.addEventListener('click', event => {
    const link = event.target.closest('a[href]');
    if (!link || link.origin !== location.origin || link.pathname !== location.pathname) return;
    const target = document.getElementById(link.hash.slice(1));
    if (target?.classList.contains('entry')) target.open = true;
  });

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
})();
