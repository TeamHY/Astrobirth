(() => {
  'use strict';
  const status = document.querySelector('#catalog-status');
  const empty = document.querySelector('#empty-state');
  const cards = [...document.querySelectorAll('.catalog-card')];
  const buttons = [...document.querySelectorAll('.catalog-filters button[data-kind]')];
  const originButtons = [...document.querySelectorAll('.catalog-filters button[data-origin]')];
  const changeButtons = [...document.querySelectorAll('.change-filters button')];
  const playerCatalog = cards.some(card => card.classList.contains('player-card'));
  let kind = 'all';
  let origin = 'all';
  let change = 'all';

  function itemDetails() {
    const dialog = document.querySelector('#catalog-detail-dialog');
    if (playerCatalog || !dialog || typeof dialog.showModal !== 'function') return null;
    const heading = dialog.querySelector('#catalog-detail-title');
    const content = dialog.querySelector('.catalog-dialog-content');
    const closeButton = dialog.querySelector('.catalog-dialog-close');
    let active = null;
    let backdropPressed = false;

    function restore() {
      if (!active) return;
      const previous = active;
      active = null;
      previous.parent.insertBefore(previous.body, previous.next);
      document.body.style.overflow = previous.overflow;
      document.body.style.paddingRight = previous.padding;
      delete dialog.dataset.itemId;
      if (previous.restoreFocus && previous.trigger.isConnected) previous.trigger.focus({preventScroll: true});
    }

    function close(restoreFocus = true) {
      if (!active) return;
      active.restoreFocus = restoreFocus;
      if (dialog.open) dialog.close();
      restore();
    }

    function open(card, trigger, details) {
      const body = details.querySelector('.entry-body');
      if (!body) return;
      close(false);
      const gutter = Math.max(0, window.innerWidth - document.documentElement.clientWidth);
      active = {body, parent: body.parentNode, next: body.nextSibling, trigger,
        overflow: document.body.style.overflow, padding: document.body.style.paddingRight, restoreFocus: true};
      heading.textContent = card.querySelector('.catalog-title-row > span').textContent;
      dialog.dataset.itemId = card.id;
      content.append(body);
      document.body.style.overflow = 'hidden';
      if (gutter) document.body.style.paddingRight = `${(parseFloat(getComputedStyle(document.body).paddingRight) || 0) + gutter}px`;
      try { dialog.showModal(); } catch { restore(); return; }
      content.scrollTop = 0;
      closeButton.focus({preventScroll: true});
    }

    cards.forEach(card => {
      const trigger = card.querySelector('.catalog-detail-trigger');
      const details = card.querySelector('.catalog-details');
      if (!trigger || !details || !details.querySelector('.entry-body')) return;
      trigger.hidden = false;
      details.hidden = true;
      trigger.addEventListener('click', () => open(card, trigger, details));
    });
    const outside = event => {
      const rect = dialog.getBoundingClientRect();
      return event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom;
    };
    closeButton.addEventListener('click', () => close());
    dialog.addEventListener('cancel', event => { event.preventDefault(); close(); });
    dialog.addEventListener('close', () => { if (!dialog.open) restore(); });
    dialog.addEventListener('pointerdown', event => { backdropPressed = event.target === dialog && outside(event); });
    dialog.addEventListener('click', event => { if (backdropPressed && event.target === dialog && outside(event)) close(); });
    window.addEventListener('beforeprint', () => close(false));
    return {close, contains: node => dialog.contains(node)};
  }

  const detailPopup = itemDetails();

  function itemMasonry() {
    const grid = document.querySelector('.catalog-grid');
    if (playerCatalog || !grid || !window.ResizeObserver) return null;
    let frame = 0;
    let width = -1;
    let columns = 0;
    let resizeTimer = 0;
    let lockedStyles = null;
    let tracks = '';
    let gap = 18;
    const waiting = [];
    const positions = new WeakMap();
    const measuredHeights = new WeakMap();
    const animations = new Map();
    const tableCards = detailPopup ? new Set() : new Set(cards.filter(card => card.querySelector('.reward-table')));
    grid.classList.add('is-masonry');

    function cancelAnimations() {
      animations.forEach(animation => animation.cancel());
      animations.clear();
    }

    function snapshot() {
      if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return null;
      const top = grid.getBoundingClientRect().top;
      const margin = window.innerHeight * 0.75;
      const result = new Map();
      cards.forEach(card => {
        const previous = positions.get(card);
        if (card.hidden || !previous || top + previous.top + previous.height < -margin || top + previous.top > window.innerHeight + margin) return;
        result.set(card, card.getBoundingClientRect());
      });
      return result;
    }

    function layout(previous = null) {
      const nextWidth = grid.getBoundingClientRect().width;
      if (!nextWidth || getComputedStyle(grid).display !== 'grid') return;
      const resized = Math.abs(nextWidth - width) > 0.01;
      const visible = cards.filter(card => !card.hidden);
      cancelAnimations();
      // Clear old column numbers before a breakpoint removes columns. Auto-fill
      // keeps the available tracks even while every card is measured in column 1.
      if (resized || !columns) {
        cards.forEach(card => { card.style.gridColumn = '1'; });
        width = nextWidth;
      }
      visible.forEach(card => {
        const wide = tableCards.has(card) && card.querySelector('.catalog-details[open]');
        if (wide) card.style.gridColumn = '1 / -1';
        else if (card.style.gridColumn.includes('/')) card.style.gridColumn = '1';
      });
      const styles = getComputedStyle(grid);
      tracks = styles.gridTemplateColumns;
      if (!tracks || tracks === 'none') return;
      columns = tracks.trim().split(/\s+/).length;
      gap = parseFloat(styles.columnGap) || 0;
      const heights = visible.map(card => card.getBoundingClientRect().height);
      const bottoms = Array(columns).fill(0);
      visible.forEach((card, index) => {
        const wide = tableCards.has(card) && card.querySelector('.catalog-details[open]');
        const column = wide ? 0 : bottoms.indexOf(Math.min(...bottoms));
        const top = wide ? Math.max(...bottoms) : bottoms[column];
        const placement = wide ? '1 / -1' : String(column + 1);
        const offset = `${Math.round(top * 1000) / 1000}px`;
        if (card.style.gridColumn !== placement) card.style.gridColumn = placement;
        if (card.style.getPropertyValue('--card-offset') !== offset) {
          card.style.setProperty('--card-offset', offset);
        }
        measuredHeights.set(card, heights[index]);
        positions.set(card, {top, height: heights[index]});
        const bottom = top + heights[index] + gap;
        if (wide) bottoms.fill(bottom);
        else bottoms[column] = bottom;
      });
      if (!previous) return;
      // Read the final positions together, then animate only the nearby cards.
      const moves = [...previous].filter(([card]) => !card.hidden && typeof card.animate === 'function')
        .map(([card, before]) => ({card, before, after: card.getBoundingClientRect()}));
      moves.forEach(({card, before, after}) => {
        const x = before.left - after.left;
        const y = before.top - after.top;
        if (Math.abs(x) < 0.5 && Math.abs(y) < 0.5) return;
        const animation = card.animate([{transform: `translate(${x}px,${y}px)`}, {transform: 'translate(0,0)'}],
          {duration: 260, easing: 'cubic-bezier(.2,.7,.2,1)'});
        animations.set(card, animation);
        animation.finished.then(() => { if (animations.get(card) === animation) animations.delete(card); }).catch(() => {});
      });
    }

    function schedule() {
      if (frame || resizeTimer) return;
      frame = requestAnimationFrame(() => { frame = 0; layout(); });
    }

    function refresh() {
      if (resizeTimer) return;
      if (frame) cancelAnimationFrame(frame);
      frame = 0;
      layout();
    }

    function settle(callback) {
      if (resizeTimer) waiting.push(callback);
      else { refresh(); callback(); }
    }

    function unlock() {
      if (!lockedStyles) return;
      grid.style.width = lockedStyles.width;
      grid.style.gridTemplateColumns = lockedStyles.columns;
      grid.style.columnGap = lockedStyles.gap;
      lockedStyles = null;
    }

    function resize() {
      if (width < 0 || getComputedStyle(grid).display !== 'grid') { schedule(); return; }
      if (frame) cancelAnimationFrame(frame);
      frame = 0;
      if (!lockedStyles) {
        lockedStyles = {width: grid.style.width, columns: grid.style.gridTemplateColumns, gap: grid.style.columnGap};
        // Keep card widths and offsets stable during a drag. Reflow once it ends.
        grid.style.width = `${width}px`;
        grid.style.gridTemplateColumns = tracks;
        grid.style.columnGap = `${gap}px`;
      }
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(() => {
        resizeTimer = 0;
        const previous = snapshot();
        unlock();
        layout(previous);
        const callbacks = waiting.splice(0);
        Promise.allSettled([...animations.values()].map(animation => animation.finished))
          .then(() => callbacks.forEach(callback => settle(callback)));
      }, 200);
    }

    const observer = new ResizeObserver(entries => {
      if (resizeTimer) return;
      if (entries.some(entry => entry.target === grid && Math.abs(entry.contentRect.width - width) > 0.01)) resize();
      else if (entries.some(entry => entry.target !== grid && Math.abs(entry.target.getBoundingClientRect().height - (measuredHeights.get(entry.target) || 0)) > 0.1)) schedule();
    });
    observer.observe(grid);
    // Popup details leave card heights unchanged. Observe cards only for the
    // native-details fallback in browsers without dialog support.
    if (!detailPopup) {
      cards.forEach(card => observer.observe(card));
      grid.addEventListener('toggle', schedule, true);
    }
    // Item and inline icons reserve their dimensions, so lazy image loading
    // cannot change card heights and does not need a catalog-wide reflow.
    window.addEventListener('resize', resize);
    window.addEventListener('beforeprint', () => {
      clearTimeout(resizeTimer);
      resizeTimer = 0;
      if (frame) cancelAnimationFrame(frame);
      frame = 0;
      unlock();
      cancelAnimations();
    });
    window.addEventListener('afterprint', () => { schedule(); waiting.splice(0).forEach(callback => settle(callback)); });
    document.fonts?.ready.then(schedule);
    document.fonts?.addEventListener('loadingdone', schedule);
    return {schedule, refresh, settle};
  }

  const masonry = itemMasonry();

  function matches(card, selectedKind = kind, selectedOrigin = origin, selectedChange = change) {
    return (selectedKind === 'all' || card.dataset.kind === selectedKind) &&
      (selectedOrigin === 'all' || card.dataset.origin === selectedOrigin) &&
      (selectedChange === 'all' || card.dataset.changes.split(' ').includes(selectedChange));
  }

  function filter() {
    let count = 0;
    cards.forEach(card => {
      const match = matches(card);
      card.hidden = !match;
      if (match) count++;
    });
    buttons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.kind === kind)));
    originButtons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.origin === origin)));
    changeButtons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.change === change)));
    buttons.forEach(button => {
      button.querySelector('span').textContent = cards.filter(card => matches(card, button.dataset.kind)).length;
    });
    originButtons.forEach(button => {
      button.querySelector('span').textContent = cards.filter(card => matches(card, kind, button.dataset.origin)).length;
    });
    empty.hidden = count > 0;
    if (playerCatalog) {
      const labels = [
        {base: '기본 캐릭터', mod: '모드 캐릭터'}[origin],
        {normal: '일반', tainted: '더럽혀진'}[kind]
      ].filter(Boolean);
      status.textContent = labels.length ? `${labels.join(' · ')} ${count}명 · 전체 ${cards.length}명` : `전체 ${cards.length}명`;
    } else {
      const labels = [
        {base: '기존 아이템 변경', mod: 'Astro-Items 추가'}[origin],
        {passive: '패시브', active: '액티브', trinket: '장신구', card: '카드'}[kind],
        {effect: '효과', config: '가격·퀄리티·충전'}[change]
      ].filter(Boolean);
      status.textContent = labels.length ? `${labels.join(' · ')} ${count}개 · 전체 ${cards.length}개` : `전체 ${cards.length}개`;
    }
    masonry?.schedule();
  }

  function reset() {
    kind = 'all';
    origin = 'all';
    change = 'all';
    filter();
  }

  function openHash() {
    detailPopup?.close(false);
    let id;
    try { id = decodeURIComponent(location.hash.slice(1)); } catch { return; }
    const target = document.getElementById(id);
    if (!target?.classList.contains('catalog-card')) return;
    reset();
    const details = target.querySelector('details');
    if ((playerCatalog || !detailPopup) && details) details.open = true;
    requestAnimationFrame(() => {
      const scroll = () => target.scrollIntoView({block: 'start'});
      if (masonry) masonry.settle(scroll);
      else scroll();
    });
  }

  buttons.forEach(button => button.addEventListener('click', () => { kind = button.dataset.kind; filter(); }));
  originButtons.forEach(button => button.addEventListener('click', () => { origin = button.dataset.origin; filter(); }));
  changeButtons.forEach(button => button.addEventListener('click', () => { change = button.dataset.change; filter(); }));
  document.querySelector('#reset-filters').addEventListener('click', reset);
  document.addEventListener('click', event => {
    const link = event.target.closest('a[href]');
    if (event.defaultPrevented || event.button || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    if (link && detailPopup?.contains(link)) detailPopup.close(false);
    if (!link || link.origin !== location.origin || link.pathname !== location.pathname || !link.hash) return;
    let id;
    try { id = decodeURIComponent(link.hash.slice(1)); } catch { return; }
    const target = document.getElementById(id);
    if (!target?.classList.contains('catalog-card')) return;
    event.preventDefault();
    if (location.hash !== link.hash) history.pushState(null, '', link.hash);
    openHash();
  });
  window.addEventListener('hashchange', openHash);
  window.addEventListener('pageshow', openHash);
  filter();
  openHash();
})();
