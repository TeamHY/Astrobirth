/*
 * 방 비교 schema 1. Manifest에는 52개 공식 파일의 통계만 두고, 선택한 층을
 * fetch합니다. before/after가 null이면 없는 프리셋이고, spawns=[]이면 빈 방입니다.
 * spawns=[x,y,[[type,variant,subtype,weight],…]]는 위치별 선택 후보입니다.
 * 후보의 중복과 가중치를 유지하며 tuple 개수를 동시 스폰 수로 해석하지 않습니다.
 * 원본 delta는 changedFields와 before/after로 재구성합니다. 출처는 comment 전용입니다.
 */
(() => {
  'use strict';
  const root = document.getElementById('room-viewer');
  if (!root) return;
  const $ = (name) => root.querySelector(`[data-room-${name}]`);
  const controls = {floor: $('floor'), change: $('change'), search: $('search'), preset: $('preset'), position: $('position')};
  const status = $('status'), details = $('details'), result = $('result');
  const changes = {changed: '변경', added: '추가', removed: '제거'};
  const fields = {name:'이름', difficulty:'난이도', weight:'방 가중치', width:'가로 크기', height:'세로 크기', shape:'방 모양', doors:'문', spawns:'스폰 후보', type:'방 종류', variant:'프리셋 번호', subtype:'세부형'};
  const types = ['없음','일반방','상점','오류방','보물방','보스방','미니 보스방','비밀방','일급 비밀방','오락실','저주방','도전방','책방','희생방','악마방','천사방','크롤 스페이스','보스 러시','깨끗한 침실','더러운 침실','상자방','주사위방','블랙 마켓','탐욕 출구','천체관','순간이동방','순간이동 출구','대체 루트 출구','파란 방','울트라 비밀방'];
  const shapes = {1:'1 × 1',2:'가로로 좁은 방',3:'세로로 좁은 방',4:'1 × 2',5:'세로로 긴 좁은 방',6:'2 × 1',7:'가로로 긴 좁은 방',8:'2 × 2',9:'L자 · 왼쪽 위가 빈 방',10:'L자 · 오른쪽 위가 빈 방',11:'L자 · 왼쪽 아래가 빈 방',12:'L자 · 오른쪽 아래가 빈 방'};
  const kinds = {enemy:'적',pickup:'픽업',grid:'장애물',machine:'기계·거지',effect:'효과',other:'기타',unknown:'확인되지 않음'};
  const cache = new Map();
  const state = {manifest:null,floor:null,data:null,preset:null,filtered:[],position:null,request:0};
  let controller, searchTimer;
  const number = (value) => Number(value).toLocaleString('ko-KR', {maximumFractionDigits:8});
  const el = (tag, className, text) => {
    const node=document.createElement(tag);
    if (className) node.className=className;
    if (text!==undefined) node.textContent=text;
    return node;
  };
  const svgNode = (tag, attributes={}) => {
    const node=document.createElementNS('http://www.w3.org/2000/svg',tag);
    Object.entries(attributes).forEach(([key,value])=>node.setAttribute(key,String(value)));
    return node;
  };
  const entityKey = (candidate) => candidate.slice(0,3).join('.');
  const positionKey = (x,y) => `${x},${y}`;
  const positionMap = (room) => new Map((room?.spawns || []).map(([x,y,candidates])=>[positionKey(x,y),candidates]));
  const info = (candidate, side) => state.data?.entities?.[side]?.[entityKey(candidate)] || {name:'확인되지 않은 개체',kind:'unknown',verified:false};
  const typeName = (value) => types[value] || `확인되지 않은 방 종류 (${value})`;
  const roomName = (room) => room?.name || '이름 없는 방';
  const presetName = (preset) => preset.after?.name || preset.before?.name || `${typeName((preset.after||preset.before).type)} 프리셋`;
  const equal = (a,b) => JSON.stringify(a)===JSON.stringify(b);
  const setStatus = (text, error=false) => {
    status.textContent=text;
    status.classList.toggle('is-error',error);
    status.hidden=!text;
  };
  const hiddenReference = (metadata) => {
    root.querySelectorAll('[data-room-reference]').forEach(node=>node.remove());
    // Sources, commits, local baseline paths and decoder references never enter text/UI.
    const marker=el('span'); marker.hidden=true; marker.dataset.roomReference='';
    marker.append(document.createComment(' Agent reference material\n'+JSON.stringify(metadata,null,2).replace(/--/g,'\\u002d\\u002d')+'\n'));
    root.append(marker);
  };
  const urlState = () => {
    const fragment=location.hash.startsWith('#rooms?') ? location.hash.slice(7) : '';
    return new URLSearchParams(fragment);
  };
  const updateURL = () => {
    if (!state.floor || !state.preset) return;
    const query=new URLSearchParams({floor:state.floor.id,room:state.preset.id});
    if (controls.change.value!=='all') query.set('change',controls.change.value);
    if (controls.search.value) query.set('q',controls.search.value);
    if (state.position) query.set('position',state.position);
    history.replaceState(null,'',`#rooms?${query}`);
  };
  const summarize = (counts) => `${number(counts.changed)}개 변경 · ${number(counts.added)}개 추가 · ${number(counts.removed)}개 제거`;

  async function loadFloor(id, preferredRoom, preferredPosition) {
    const floor=state.manifest.floors.find(row=>row.id===id);
    if (!floor) return;
    const request=++state.request;
    controller?.abort(); controller=new AbortController();
    state.floor=floor; state.data=null; state.preset=null;
    controls.floor.value=id; controls.preset.disabled=true; controls.position.disabled=true;
    controls.preset.replaceChildren(el('option','','불러오는 중…'));
    controls.position.replaceChildren(el('option','','방을 고르면 표시합니다'));
    details.hidden=true; result.textContent='';
    $('floor-summary').textContent=`${floor.mode==='greed'?'탐욕 모드 · ':''}${floor.title} · ${summarize(floor.statistics)}`;
    root.setAttribute('aria-busy','true'); setStatus('선택한 층의 방 배치를 불러오고 있습니다.');
    try {
      let data=cache.get(id);
      if (!data) {
        const response=await fetch(new URL(floor.path, new URL(root.dataset.manifest || './rooms-content.json',document.baseURI)),{signal:controller.signal});
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        data=await response.json();
        if (data.schema!==1 || !Array.isArray(data.rooms)) throw new Error('Invalid room schema');
        cache.set(id,data);
        while (cache.size>3) cache.delete(cache.keys().next().value);
      }
      if (request!==state.request) return;
      state.data=data;
      hiddenReference({manifest:state.manifest.metadata,floor:data.metadata});
      controls.preset.disabled=false;
      setStatus(''); filterRooms(preferredRoom,preferredPosition);
    } catch (error) {
      if (error.name==='AbortError' || request!==state.request) return;
      setStatus('방 배치를 불러오지 못했습니다. 아래 버튼으로 다시 시도할 수 있습니다.',true);
      $('retry').hidden=false;
      controls.preset.replaceChildren(el('option','','불러오지 못했습니다'));
    } finally {
      if (request===state.request) root.setAttribute('aria-busy','false');
    }
  }

  function filterRooms(preferredRoom, preferredPosition) {
    if (!state.data) return;
    const q=controls.search.value.trim().toLocaleLowerCase();
    const change=controls.change.value;
    state.filtered=state.data.rooms.filter(preset=> {
      if (change!=='all' && preset.change!==change) return false;
      if (!q) return true;
      if (!preset.searchText) {
        const terms=[presetName(preset),...preset.key,changes[preset.change]];
        for (const side of ['before','after']) {
          const room=preset[side]; if (!room) continue;
          terms.push(room.name,typeName(room.type),shapes[room.shape]||room.shape);
          for (const [x,y,candidates] of room.spawns) for (const candidate of candidates) terms.push(info(candidate,side).name,entityKey(candidate));
        }
        // Index visible names/identifiers only; metadata paths are deliberately excluded.
        preset.searchText=terms.join(' ').toLocaleLowerCase();
      }
      return preset.searchText.includes(q);
    });
    controls.preset.replaceChildren();
    if (!state.filtered.length) {
      const text=state.data.rooms.length ? '조건에 맞는 방이 없습니다.' : '이 층에는 변경·추가·제거된 방이 없습니다.';
      controls.preset.append(el('option','',text)); controls.preset.disabled=true;
      details.hidden=true; result.textContent=text; $('selection-count').textContent='';
      state.preset=null; controls.position.disabled=true;
      $('previous').disabled=true; $('next').disabled=true; return;
    }
    controls.preset.disabled=false;
    const fragment=document.createDocumentFragment();
    for (const preset of state.filtered) {
      const option=el('option','',`[${changes[preset.change]}] ${presetName(preset)} · ${preset.key[1]} / ${preset.key[2]}`);
      option.value=preset.id; fragment.append(option);
    }
    controls.preset.append(fragment);
    const selected=state.filtered.find(preset=>preset.id===(preferredRoom||state.preset?.id)) || state.filtered[0];
    controls.preset.value=selected.id; result.textContent=''; selectRoom(selected.id,preferredPosition);
  }

  function shapeContains(room,x,y) {
    const w=room.width,h=room.height;
    if (x<0 || y<0 || x>=w || y>=h) return false;
    // Narrow shapes keep the same STB dimensions; only their central corridor is floor.
    if (room.shape===2 || room.shape===7) return y>=2 && y<=4;
    if (room.shape===3 || room.shape===5) return x>=4 && x<=8;
    if (room.shape===9) return !(x<13 && y<7);
    if (room.shape===10) return !(x>=13 && y<7);
    if (room.shape===11) return !(x<13 && y>=7);
    if (room.shape===12) return !(x>=13 && y>=7);
    return true;
  }

  function diagram(room, other, side, bounds) {
    const wrap=el('div','room-diagram');
    if (!room) {
      const empty=el('div','room-absent');
      empty.append(el('span','room-absent-symbol','—'),el('p','','이 프리셋은 없습니다.'));
      wrap.append(empty); return wrap;
    }
    const cell=24, margin=30;
    const svg=svgNode('svg',{viewBox:`0 0 ${bounds.width*cell+margin*2} ${bounds.height*cell+margin*2}`,role:'group','aria-label':`${side==='before'?'기본 게임':'대결 모드'} 방 배치. 스폰 표시를 선택하면 후보 목록을 확인합니다.`});
    const grid=svgNode('g',{'class':'room-grid'});
    for (let y=0;y<room.height;y++) for (let x=0;x<room.width;x++) {
      if (shapeContains(room,x,y)) grid.append(svgNode('rect',{x:margin+x*cell,y:margin+y*cell,width:cell,height:cell,'class':'room-tile'}));
    }
    svg.append(grid);
    for (const [x,y,exists] of room.doors) {
      const g=svgNode('g',{'class':`room-door ${exists?'is-open':'is-closed'}`});
      const title=svgNode('title'); title.textContent=`문 (${x}, ${y}) · ${exists?'있음':'없음'}`; g.append(title);
      const vertical=x===-1 || x===room.width || (room.shape>=9 && [12,13].includes(x));
      g.append(svgNode('rect',{x:margin+(x+.5)*cell-(vertical?4:9),y:margin+(y+.5)*cell-(vertical?9:4),width:vertical?8:18,height:vertical?18:8,rx:2}));
      if (!exists) g.append(svgNode('path',{d:`M${margin+(x+.5)*cell-4},${margin+(y+.5)*cell-4}l8,8m0,-8l-8,8`}));
      svg.append(g);
    }
    const own=positionMap(room), otherMap=positionMap(other);
    const markers=[];
    for (const [x,y,candidates] of room.spawns) {
      const key=positionKey(x,y), cx=margin+(x+.5)*cell, cy=margin+(y+.5)*cell;
      const candidateInfo=candidates.map(candidate=>info(candidate,side));
      const categories=new Set(candidateInfo.map(row=>row.kind));
      const kind=categories.size===1 ? candidateInfo[0].kind : 'mixed';
      const changed=!equal(candidates,otherMap.get(key));
      const g=svgNode('g',{'class':`room-spawn room-kind-${kind}${changed?' is-changed':''}`,transform:`translate(${cx},${cy})`,role:'button',tabindex:markers.length===0?0:-1,'data-pos':key,'data-side':side,'aria-pressed':'false','aria-label':`위치 ${x}, ${y} · 후보 ${candidates.length}개 · ${candidateInfo.map(row=>row.name).join(', ')}`});
      const title=svgNode('title'); title.textContent=`(${x}, ${y}) · ${candidateInfo.map(row=>row.name).join(', ')} · 후보 ${candidates.length}개`; g.append(title);
      g.append(svgNode('rect',{x:-11,y:-11,width:22,height:22,rx:4,'class':'room-hit'}));
      if (kind==='grid') g.append(svgNode('rect',{x:-7,y:-7,width:14,height:14,rx:2,'class':'room-glyph'}));
      else if (kind==='pickup') g.append(svgNode('path',{d:'M0,-9L9,0L0,9L-9,0Z','class':'room-glyph'}));
      else g.append(svgNode('circle',{cx:0,cy:0,r:8,'class':'room-glyph'}));
      const label=svgNode('text',{'text-anchor':'middle',y:4,'class':'room-marker-label'});
      label.textContent=candidates.length>1?candidates.length:kind==='unknown'?'?':kind==='enemy'?'●':kind==='machine'?'M':kind==='other'?'·':'';
      g.append(label); svg.append(g); markers.push(g);
    }
    // Include a thin ghost marker for positions present only on the other side.
    for (const [key] of otherMap) if (!own.has(key)) {
      const [x,y]=key.split(',').map(Number);
      const g=svgNode('g',{'class':'room-ghost',role:'button',tabindex:-1,'data-pos':key,'aria-label':`위치 ${x}, ${y} · 이쪽에는 스폰 후보가 없습니다.`});
      g.append(svgNode('rect',{x:margin+x*cell+3,y:margin+y*cell+3,width:cell-6,height:cell-6,rx:3})); svg.append(g);
    }
    wrap.append(svg); return wrap;
  }

  function selectRoom(id, preferredPosition) {
    const preset=state.filtered.find(row=>row.id===id);
    if (!preset) return;
    state.preset=preset; controls.preset.value=id; details.hidden=false;
    const index=state.filtered.indexOf(preset);
    $('selection-count').textContent=`${number(index+1)} / ${number(state.filtered.length)}개 프리셋`;
    $('previous').disabled=index===0; $('next').disabled=index===state.filtered.length-1;
    $('title').textContent=presetName(preset);
    const badge=$('badge'); badge.textContent=changes[preset.change]; badge.className=`room-change room-change-${preset.change}`;
    $('identifier').textContent=`프리셋 ${preset.key[1]} · 세부형 ${preset.key[2]}`;
    $('changed-fields').textContent=preset.change==='changed' ? `변경된 설정: ${preset.changedFields.map(key=>fields[key]||key).join(' · ')}` : preset.change==='added' ? '대결 모드에서 추가한 프리셋입니다.' : '대결 모드의 방 목록에서 제거한 프리셋입니다.';
    const allPositions=new Map();
    for (const side of ['before','after']) for (const [x,y,candidates] of preset[side]?.spawns || []) allPositions.set(positionKey(x,y),[x,y]);
    const positions=[...allPositions].sort((a,b)=>a[1][1]-b[1][1] || a[1][0]-b[1][0]);
    controls.position.replaceChildren();
    for (const [key,[x,y]] of positions) {
      const changed=!equal(positionMap(preset.before).get(key),positionMap(preset.after).get(key));
      const option=el('option','',`(${x}, ${y})${changed?' · 변경된 위치':''}`); option.value=key; controls.position.append(option);
    }
    controls.position.disabled=!positions.length;
    if (!positions.length) controls.position.append(el('option','','스폰 후보가 없는 방입니다'));
    const rooms=[preset.before,preset.after].filter(Boolean);
    const bounds={width:Math.max(...rooms.map(r=>r.width)),height:Math.max(...rooms.map(r=>r.height))};
    for (const [key,[x,y]] of positions) {bounds.width=Math.max(bounds.width,x+1);bounds.height=Math.max(bounds.height,y+1);}
    $('panels').replaceChildren();
    for (const side of ['before','after']) {
      const room=preset[side], card=el('section',`room-panel room-panel-${side}`);
      card.append(el('h3','',side==='before'?'기본 게임':'대결 모드'));
      card.append(el('p','room-preset-name',room?roomName(room):'프리셋 없음'));
      card.append(diagram(room,preset[side==='before'?'after':'before'],side,bounds));
      if (room) {
        const stats=el('p','room-placement-count');
        stats.textContent=`스폰 위치 ${number(room.spawns.length)}곳 · 문 ${room.doors.filter(door=>door[2]).length}개`;
        card.append(stats);
      }
      $('panels').append(card);
    }
    renderProperties(preset); renderDoors(preset);
    const chosen=positions.find(row=>row[0]===preferredPosition) || positions.find(row=>!equal(positionMap(preset.before).get(row[0]),positionMap(preset.after).get(row[0]))) || positions[0];
    selectPosition(chosen?.[0] || null);
    hiddenReference({manifest:state.manifest.metadata,floor:state.data.metadata,preset:preset.metadata,identity:preset.key,changedFields:preset.changedFields});
    updateURL();
  }

  function renderProperties(preset) {
    const body=$('properties'); body.replaceChildren();
    const rows=[['방 종류',r=>`${typeName(r.type)} (${r.type})`,'type'],['방 모양',r=>`${shapes[r.shape]||'확인되지 않은 모양'} (${r.shape})`,'shape'],['격자 크기',r=>`${r.width} × ${r.height}`,'size'],['난이도',r=>number(r.difficulty),'difficulty'],['방 가중치',r=>number(r.weight),'weight']];
    for (const [label,display,field] of rows) {
      const tr=el('tr'); tr.append(el('th','',label));
      for (const side of ['before','after']) {
        const room=preset[side], td=el('td','',room?display(room):'없음');
        if (preset.changedFields.includes(field) || field==='size' && preset.changedFields.some(key=>['width','height'].includes(key))) td.classList.add('room-property-changed');
        tr.append(td);
      }
      body.append(tr);
    }
  }

  function renderDoors(preset) {
    const container=$('doors'); container.replaceChildren();
    const positions=new Map();
    for (const side of ['before','after']) for (const [x,y] of preset[side]?.doors||[]) positions.set(positionKey(x,y),[x,y]);
    if (!positions.size) {container.append(el('p','room-muted','문 설정이 없습니다.'));return;}
    const table=el('table','room-table');
    const head=el('thead'), tr=el('tr'); ['문 위치','기본 게임','대결 모드'].forEach(text=>tr.append(el('th','',text))); head.append(tr);table.append(head);
    const body=el('tbody');
    for (const [key,[x,y]] of positions) {
      const row=el('tr'); row.append(el('th','',`(${x}, ${y})`));
      const values=['before','after'].map(side=> {
        if (!preset[side]) return '프리셋 없음';
        const door=preset[side].doors.find(d=>d[0]===x && d[1]===y);
        return door?door[2]?'있음':'없음':'문 기록 없음';
      });
      for (const value of values) row.append(el('td',values[0]!==values[1]?'room-property-changed':'',value));
      body.append(row);
    }
    table.append(body); container.append(table);
  }

  function selectPosition(key) {
    state.position=key; controls.position.value=key||'';
    for (const marker of root.querySelectorAll('[data-pos]')) {
      const active=marker.dataset.pos===key;
      marker.classList.toggle('is-selected',active);
      marker.setAttribute('aria-pressed',String(active));
      if (marker.classList.contains('room-spawn')) marker.setAttribute('tabindex',active?'0':'-1');
    }
    $('position-title').textContent=key?`위치 (${key.replace(',',', ')})의 스폰 후보`:'스폰 후보';
    const columns=$('candidates'); columns.replaceChildren();
    for (const side of ['before','after']) {
      const section=el('section','room-candidate-side');section.append(el('h4','',side==='before'?'기본 게임':'대결 모드'));
      const room=state.preset[side], candidates=key?positionMap(room).get(key):null;
      if (!room) section.append(el('p','room-muted','이 프리셋은 없습니다.'));
      else if (!candidates?.length) section.append(el('p','room-muted',key?'이 위치에는 스폰 후보가 없습니다.':'이 방에는 스폰 후보가 없습니다.'));
      else {
        const list=el('ul','room-candidate-list');
        candidates.forEach((candidate,index)=> {
          const entry=info(candidate,side), item=el('li','room-candidate');
          if (entry.image) {const img=el('img','room-item-image');img.src=new URL(entry.image,document.baseURI).href;img.alt='';img.loading='lazy';img.width=32;img.height=32;img.addEventListener('error',()=>img.remove(),{once:true});item.append(img);}
          const text=el('div','room-candidate-text');
          text.append(el('strong','',`${candidates.length>1?`${index+1}. `:''}${entry.name}`));
          text.append(el('span','room-candidate-meta',`${kinds[entry.kind]||'기타'} · ID ${entityKey(candidate)} · 가중치 ${number(candidate[3])}`));
          if (!entry.verified) text.append(el('span','room-unknown-note','이 ID의 개체 정의를 확인하지 못했습니다. 실제 생성 여부도 확인되지 않았습니다.'));
          item.append(text);list.append(item);
        }); section.append(list);
      }
      columns.append(section);
    }
    updateURL();
  }

  controls.floor.addEventListener('change',()=>{ $('retry').hidden=true; loadFloor(controls.floor.value); });
  controls.change.addEventListener('change',()=>filterRooms());
  controls.search.addEventListener('input',()=>{clearTimeout(searchTimer);searchTimer=setTimeout(()=>filterRooms(),140);});
  $('clear').addEventListener('click',()=>{controls.search.value='';clearTimeout(searchTimer);filterRooms();controls.search.focus();});
  controls.preset.addEventListener('change',()=>selectRoom(controls.preset.value));
  controls.position.addEventListener('change',()=>selectPosition(controls.position.value));
  for (const [name,direction] of [['previous',-1],['next',1]]) $(name).addEventListener('click',()=>{
    const index=state.filtered.indexOf(state.preset);if (state.filtered[index+direction]) selectRoom(state.filtered[index+direction].id);
  });
  $('retry').addEventListener('click',()=>{ $('retry').hidden=true; if(state.manifest) loadFloor(controls.floor.value);else initialize(); });
  root.addEventListener('click',event=>{const marker=event.target.closest('[data-pos]');if(marker) selectPosition(marker.dataset.pos);});
  root.addEventListener('keydown',event=> {
    const marker=event.target.closest('[data-pos]');if(!marker)return;
    if (event.key==='Enter'||event.key===' ') {event.preventDefault();selectPosition(marker.dataset.pos);return;}
    if (!['ArrowLeft','ArrowRight','ArrowUp','ArrowDown','Home','End'].includes(event.key))return;
    const group=marker.closest('svg'),markers=[...group.querySelectorAll('.room-spawn')];
    if (!markers.length)return;
    const index=markers.indexOf(marker);
    let target;
    if(event.key==='Home')target=markers[0];else if(event.key==='End')target=markers.at(-1);
    else {
      const [x,y]=marker.dataset.pos.split(',').map(Number),horizontal=event.key==='ArrowLeft'||event.key==='ArrowRight',direction=['ArrowLeft','ArrowUp'].includes(event.key)?-1:1;
      target=markers.map(node=>{const [nx,ny]=node.dataset.pos.split(',').map(Number);return {node,along:(horizontal?nx-x:ny-y)*direction,across:Math.abs(horizontal?ny-y:nx-x)};}).filter(row=>row.along>0).sort((a,b)=>(a.across*10+a.along)-(b.across*10+b.along))[0]?.node;
      target ||= markers[Math.min(markers.length-1,Math.max(0,index+direction))];
    }
    event.preventDefault();selectPosition(target.dataset.pos);target.focus();
  });
  window.addEventListener('hashchange',()=> {
    if (!state.manifest) return;
    const query=urlState(),floor=query.get('floor');
    if (!floor) return;
    controls.change.value=Object.hasOwn(changes,query.get('change'))?query.get('change'):'all';controls.search.value=query.get('q')||'';
    if (floor!==state.floor?.id) loadFloor(floor,query.get('room'),query.get('position'));
    else filterRooms(query.get('room'),query.get('position'));
  });

  async function initialize() {
    root.setAttribute('aria-busy','true');setStatus('방 목록을 불러오고 있습니다.');
    try {
      const response=await fetch(root.dataset.manifest || './rooms-content.json');
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const manifest=await response.json();
      if (manifest.schema!==1 || !Array.isArray(manifest.floors)) throw new Error('Invalid manifest');
      state.manifest=manifest;
      const groups={normal:el('optgroup'),greed:el('optgroup')}; groups.normal.label='일반 모드';groups.greed.label='탐욕 모드';
      for (const floor of manifest.floors) {
        const count=floor.statistics.changed+floor.statistics.added+floor.statistics.removed;
        const option=el('option','',`${floor.title} · ${number(count)}개${count===0?' (변경 없음)':''}`);option.value=floor.id;groups[floor.mode].append(option);
      }
      controls.floor.replaceChildren(groups.normal,groups.greed); controls.floor.disabled=false;
      const counts=manifest.statistics;
      $('statistics').textContent=`${counts.files}개 방 목록 · ${summarize(counts)}`;
      const query=urlState();controls.change.value=Object.hasOwn(changes,query.get('change'))?query.get('change'):'all';controls.search.value=query.get('q')||'';
      const floor=manifest.floors.find(row=>row.id===query.get('floor')) || manifest.floors.find(row=>row.id==='normal-01-basement') || manifest.floors[0];
      await loadFloor(floor.id,query.get('room'),query.get('position'));
    } catch(error) {
      root.setAttribute('aria-busy','false');setStatus('방 목록을 불러오지 못했습니다. 아래 버튼으로 다시 시도할 수 있습니다.',true);$('retry').hidden=false;
    }
  }
  initialize();
})();
