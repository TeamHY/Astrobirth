"""Import all committed Astro-Items definitions, EID effects and original icons.

Local maintenance requires Lupa (Lua interpreter), extracted game resources and
installed EID names. Pages builds use saved JSON and PNG/SVG files only.
Game logic callbacks are never run; only description registration is evaluated.
"""
import sys,json,re,subprocess,argparse,hashlib,base64,struct

from pathlib import Path
from xml.etree import ElementTree as ET
ROOT=Path(__file__).resolve().parents[1]
DOCS=ROOT/'docs'
parser=argparse.ArgumentParser()
parser.add_argument('--base-mod',type=Path,required=True)
parser.add_argument('--eid',type=Path,required=True)
parser.add_argument('--baseline',type=Path,required=True)
parser.add_argument('--lua-path',type=Path)
args=parser.parse_args()
if args.lua_path:sys.path.insert(0,str(args.lua_path))
from lupa import LuaRuntime
MOD=args.base_mod
GUIDE=json.loads((DOCS/'guide-content.json').read_text())
SHA=GUIDE['sources']['Astro-Items']
REVIEW=json.loads((DOCS/'astro-item-review.json').read_text())
assert REVIEW['commit']==SHA, 'Re-review additional conditions for the new source commit'

def committed(file):return subprocess.check_output(['git','-C',str(MOD),'show',SHA+':'+file]).decode()
definitions=ET.fromstring(committed('content/items.xml'))
ids={d.get('name').casefold():(200000 if d.tag=='trinket' else 100000)+int(d.get('id')) for d in definitions}
lua=LuaRuntime(register_eval=False,register_builtins=False,unpack_returned_tuples=True)
g=lua.globals()
base=(args.eid/'descriptions/names/en_us.lua').read_text()
base_ids={}
for group,number,name in re.findall(r'\[(C_ID|T_ID|Card_ID|Pill_ID)\s*\.\.\s*(\d+)\]\s*=\s*"((?:[^"\\]|\\.)*)"',base):
 key=re.sub('[^A-Z0-9]+','_',name.upper().replace("'","").replace("\\","")).strip('_')
 for candidate in {key,key.removeprefix('THE_')}:
  base_ids[(group,candidate)]=int(number)
unknown={}
def enum_id(group,name):
 key=name.removeprefix({'C_ID':'COLLECTIBLE_','T_ID':'TRINKET_','Card_ID':'CARD_','Pill_ID':'PILLEFFECT_'}.get(group,''))
 if (group,key) in base_ids:return base_ids[(group,key)]
 token=group+':'+name
 if token not in unknown:unknown[token]=900000+len(unknown)
 return unknown[token]
g.enum_id=enum_id
g.get_item=lambda name:ids.get(str(name).casefold(),0)
lua.execute('''
io=nil;os=nil;package=nil;python=nil;dofile=nil;loadfile=nil
local stub={}
local meta={__index=function(t,k)return stub end,__call=function()return stub end,
__add=function()return 0 end,__sub=function()return 0 end,__mul=function()return 0 end,__div=function()return 0 end,
__band=function()return 0 end,__bor=function()return 0 end,__shl=function()return 0 end,__unm=function()return 0 end,
__concat=function(a,b)return tostring(a)..tostring(b) end,__tostring=function()return "STUB" end}
setmetatable(stub,meta)
setmetatable(_G,{__index=function(t,k)return stub end})
function enum(group)return setmetatable({},{__index=function(t,k)local n=enum_id(group,k);rawset(t,k,n);return n end})end
CollectibleType=enum('C_ID');TrinketType=enum('T_ID');Card=enum('Card_ID');PillEffect=enum('Pill_ID')
Keyboard={};ModCallbacks=enum('Callbacks');CacheFlag=enum('Cache');PlayerType=enum('Player');EntityType=enum('Entity');ItemPoolType=enum('Pool')
REPENTOGON=false;REPENTANCE=true
function require(path)return stub end
Isaac=setmetatable({GetItemIdByName=get_item,GetTrinketIdByName=get_item},meta)
EID=setmetatable({Config={SpindownDiceResults=0},LuckFormulas={},BloodUpData={},HealthUpData={},GoldenTrinketData={}},meta)
records={};inits={};conditions={};errors={}
Astro=setmetatable({Collectible={},Trinket={},Callbacks={MOD_INIT=-1},EID={},Data={},Players=enum('Player'),Entity=stub},meta)
Astro.EID=setmetatable({Config={SpindownDiceResults=0},LuckFormulas={}},meta)
function Astro:AddCallback(kind,callback,...)if kind==-1 or (current_source=='astro/collectibles/customs/very-ez-mode.lua' and kind==ModCallbacks.MC_POST_GAME_STARTED) then table.insert(inits,{fn=callback,file=current_source})end end
function Astro:AddCallbackCustom(...)end
function Astro:GetMaxCollectibleID()return 0 end
Astro.MAX_ORIGINAL_COLLECTIBLE_ID=733;Astro.IsFight=true
Isaac.GetItemConfig=function()return {GetCollectible=function()return nil end}end
function Astro.EID:AddCollectible(id,name,flavor,description,copied,language)
 language=language or 'ko_kr';records[tostring(id)..':'..language]={id=id,name=name,flavor=flavor,description=description,copied=copied,file=current_source}
end
function Astro.EID:AddTrinket(id,name,flavor,description,golden,language)
 language=language or 'ko_kr';records[tostring(id)..':'..language]={id=id,name=name,flavor=flavor,description=description,golden=golden,file=current_source}
end
function Astro:AddGoldenTrinketDescription(...)end
function Astro.EID:RegisterAlternativeText(...)end
function EID:addCondition(...)end
function EID:addPlayerCondition(...)end
''')
# Define all custom IDs before evaluating any module's initialization callback.
module_files=subprocess.check_output(['git','-C',str(MOD),'ls-tree','-r','--name-only',SHA,'astro']).decode().splitlines()
module_files=[file for file in module_files if file.endswith('.lua')]
for file in sorted(module_files):
 text=committed(file)
 for typ,symbol,name in re.findall(r'Astro\.(Collectible|Trinket)\.(\w+)\s*=\s*Isaac.Get(?:Item|Trinket)IdByName\("([^"]+)"\)',text):
  g.Astro[typ][symbol]=ids.get(name.casefold(),0)
load_errors=[]
for folder in ['collectibles/customs','trinkets/customs']:
 for file in sorted(file for file in module_files if file.startswith('astro/'+folder+'/')):
  g.current_source=file
  try:lua.execute(committed(file),name=file)
  except Exception as e:load_errors.append((file,str(e).split('\n')[0]))
init_errors=[]
for _,cb in g.inits.items():
 g.current_source=cb['file']
 try:cb['fn'](g.Astro)
 except Exception as e:init_errors.append((cb['file'],str(e).split('\n')[0]))
result={}
for d in definitions:
 key=str(ids[d.get('name').casefold()])+':ko_kr'
 record=g.records[key]
 if record is not None:
  result[str(ids[d.get('name').casefold()])] = {k:v for k,v in record.items() if isinstance(v,(str,int,float,bool))}
missing=[d.get('name') for d in definitions if str(ids[d.get('name').casefold()]) not in result]
assert not missing and not load_errors and not init_errors, (missing,load_errors,init_errors)

def digest(data):return hashlib.sha256(data).hexdigest()
def blob(file):return subprocess.check_output(['git','-C',str(MOD),'show',SHA+':'+file])
def names(language):
    text=(args.eid/'descriptions/names'/f'{language}.lua').read_text()
    return {(group,int(number)):re.sub(r'\\(.)',lambda m:{'n':'\n','t':'\t','r':'\r'}.get(m[1],m[1]),name)
            for group,number,name in re.findall(r'\[(C_ID|T_ID|Card_ID|Pill_ID)\s*\.\.\s*(\d+)\]\s*=\s*"((?:[^"\\]|\\.)*)"',text)}
KOREAN=names('ko_kr');ENGLISH=names('en_us')
registry=json.loads((DOCS/'guide-icons.json').read_text())
catalog=json.loads((DOCS/'items-content.json').read_text())
assets=DOCS/'assets/astro-items';assets.mkdir(exist_ok=True)
sources={}
def register(file):
    data=blob(file)
    sources[file]={'project':'Astro-Items','file':file,'sha256':digest(data),'commit':SHA}
    return data
register('content/items.xml')
mod_defs={ids[d.get('name').casefold()]:d for d in definitions}
mod_images={}
placeholder_ids=set()
for key,definition in mod_defs.items():
    gfx='resources/'+definitions.get('gfxroot')+definition.get('gfx')
    # Windows game paths have case-insensitive file names; store real Git paths.
    candidates=subprocess.check_output(['git','-C',str(MOD),'ls-tree','-r','--name-only',SHA,'resources/gfx/items']).decode().splitlines() if not mod_images else []
    if candidates:mod_images={p.casefold():p for p in candidates}
    source=mod_images.get(gfx.casefold()) or next((path for path in mod_images.values() if Path(path).name.casefold()==Path(gfx).name.casefold()),None)
    filename=('t' if definition.tag=='trinket' else 'c')+'-'+definition.get('id')+'.png'
    if source:
        data=register(source)
    else:
        original=next((p for p in (args.baseline/'gfx/items').rglob('*.png') if p.name.casefold()==Path(gfx).name.casefold()),None)
        if original is None:
            original=args.baseline/'gfx/items/collectibles/questionmark.png'
            assert original.is_file(),'Missing fallback item image'
            placeholder_ids.add(key)
        source=original.relative_to(args.baseline).as_posix();data=original.read_bytes()
        sources['Game:'+source]={'project':'Game','file':source,'sha256':digest(data)}
    target=assets/filename;target.write_bytes(data)
    record=result[str(key)]
    registry['names'][record['name']]={'image':target.relative_to(DOCS).as_posix(),'name':definition.get('name'),'source':source,'sourceSHA256':digest(data)}
    register(record['file'])

# Extended quality icons are registered by Astro-Items, not the base EID sheet.
quality_actor=ET.fromstring(register('resources/gfx/ui/eid/quality.anm2'))
quality_png=register('resources/gfx/ui/eid/quality.png')
width,height=struct.unpack('>II',quality_png[16:24])
for quality in [5,6]:
    name='Quality'+str(quality)
    frame=quality_actor.find('./Animations/Animation[@Name="'+name+'"]/LayerAnimations/LayerAnimation/Frame')
    bounds=[int(frame.get(k)) for k in ['XCrop','YCrop','Width','Height']]
    x,y,w,h=bounds;assert 0<=x<x+w<=width and 0<=y<y+h<=height
    target=assets/(name+'.svg')
    target.write_text(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x} {y} {w} {h}"><image width="{width}" height="{height}" href="data:image/png;base64,{base64.b64encode(quality_png).decode()}" style="image-rendering:pixelated"/></svg>\n')
    registry['sprites'][name]={'image':target.relative_to(DOCS).as_posix(),'sheet':'Astro-Items/quality','animation':name,'frame':0,'crop':bounds,'sourceSHA256':digest(quality_png)}

# Pickup decorations remain icons, so their names do not become sentence subjects.
eid_actor=ET.parse(args.eid/'resources/gfx/eid_inline_icons.anm2').getroot()
eid_png=(args.eid/'resources/gfx/eid_inline_icons.png').read_bytes()
width,height=struct.unpack('>II',eid_png[16:24])
crafting=eid_actor.findall('./Animations/Animation[@Name="Crafting"]/LayerAnimations/LayerAnimation[@LayerId="0"]/Frame')
for number in [11,17,18,19]:
    name='Crafting'+str(number);frame=crafting[number]
    bounds=[int(frame.get(k)) for k in ['XCrop','YCrop','Width','Height']]
    x,y,w,h=bounds;assert 0<=x<x+w<=width and 0<=y<y+h<=height
    target=assets/(name+'.svg')
    target.write_text(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x} {y} {w} {h}"><image width="{width}" height="{height}" href="data:image/png;base64,{base64.b64encode(eid_png).decode()}" style="image-rendering:pixelated"/></svg>\n')
    registry['sprites'][name]={'image':target.relative_to(DOCS).as_posix(),'sheet':'eid_inline_icons','animation':'Crafting','frame':number,'crop':bounds,'sourceSHA256':digest(eid_png)}

# Save missing referenced base icons without requiring game/EID at build time.
base_defs={('T_ID' if e.tag=='trinket' else 'C_ID',int(e.get('id'))):e
           for e in ET.parse(args.baseline/'items.xml').getroot() if e.get('id') and e.tag!='null'}
base_images={p.name.casefold():p for p in (args.baseline/'gfx/items').rglob('*.png')}
def save_base_icon(group,number,name):
    if name in registry['names']:return
    if group in ['C_ID','T_ID']:
        definition=base_defs[(group,number)]
        image=base_images[Path(definition.get('gfx')).name.casefold()].read_bytes()
        target=assets/(group.lower()+'-'+str(number)+'.png');target.write_bytes(image)
        registry['names'][name]={'image':target.relative_to(DOCS).as_posix(),'eid':group+str(number),'sourceSHA256':digest(image)}
    elif group=='Card_ID':
        actor=ET.parse(args.eid/'resources/gfx/eid_cardspills.anm2').getroot()
        frame=actor.findall('./Animations/Animation[@Name="Cards"]/LayerAnimations/LayerAnimation[@LayerId="0"]/Frame')[number-1]
        crop=[int(frame.get(k)) for k in ['XCrop','YCrop','Width','Height']]
        png=(args.eid/'resources/gfx/eid_cardspills.png').read_bytes();width,height=struct.unpack('>II',png[16:24])
        x,y,w,h=crop;target=assets/('Card'+str(number)+'.svg')
        target.write_text(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x} {y} {w} {h}"><image width="{width}" height="{height}" href="data:image/png;base64,{base64.b64encode(png).decode()}" style="image-rendering:pixelated"/></svg>\n')
        registry['names'][name]={'image':target.relative_to(DOCS).as_posix(),'eid':'Card'+str(number)}
LABELS={'Crafting11':'행운 동전','Crafting17':'기가 폭탄','Crafting18':'마이크로 배터리','Crafting19':'배터리',
        'Player0':'아이작','Player10':'로스트','Player21':'더럽혀진 아이작','Player31':'더럽혀진 로스트',
        'Player900130':'디아벨스타','TreasureRoom':'보물방','Planetarium':'천체관','DevilRoom':'악마방','AngelRoom':'천사방',
        'Shop':'상점','BossRoom':'보스방','SecretRoom':'비밀방','SuperSecretRoom':'일급비밀방','UltraSecretRoom':'특급비밀방',
        'CursedRoom':'저주방','ArcadeRoom':'오락실','ErrorRoom':'에러방','IsaacsRoom':'방','LadderRoom':'계단방',
        'EternalHeart':'이터널 하트','BoneHeart':'뼈 하트','BrokenHeart':'부서진 하트','HalfSoulHeart':'소울 하트 반 칸'}

def effects(description):
    description=description.replace('{taurusKeySet}','설정한 돌진 입력으로').replace('{wakaba_md1}','8')
    description=description.replace('품질','퀄리티').replace('등급','퀄리티')
    assert 'STUB' not in description and not re.search(r'(?<!{){[^{}]+}(?!})',description),description
    lines=[]
    for raw in description.split('#'):
        pieces=re.split(r'({{[^{}]+}})',raw);segments=[]
        for i,piece in enumerate(pieces):
            if piece.startswith('{{'):
                token=piece[2:-2]
                match=re.fullmatch(r'(Collectible|Trinket|Card)(\d+)',token)
                if match:
                    kind,number=match[1],int(match[2]);group={'Collectible':'C_ID','Trinket':'T_ID','Card':'Card_ID'}[kind]
                    if number in mod_defs:
                        record=result[str(number)];name=record['name'];english=mod_defs[number].get('name')
                    else:
                        assert (group,number) in KOREAN,(token,raw)
                        name=KOREAN[(group,number)];english=ENGLISH.get((group,number),'')
                        save_base_icon(group,number,name)
                    segments.append({'item':name})
                    if i+1<len(pieces):
                        for label in [english,name]:
                            if label:pieces[i+1]=re.sub(r'^\s*'+re.escape(label)+r'(?![\w])',' ',pieces[i+1],flags=re.I)
                elif token in registry['sprites']:
                    segments.append({'icon':token})
                elif token.startswith('Player'):
                    players={'Player0':('Isaac','아이작'),'Player10':('The Lost','로스트'),
                             'Player21':('Tainted Isaac','더럽혀진 아이작'),'Player31':('Tainted Lost','더럽혀진 로스트')}
                    if token in players:
                        english,korean=players[token]
                        if i+1<len(pieces):pieces[i+1]=pieces[i+1].replace(english,korean)
                    else:
                        key=next((k for k,v in unknown.items() if str(v)==token[6:]),'')
                        assert key=='Player:DIABELLSTAR',(token,key)
                        if i+1<len(pieces):pieces[i+1]=pieces[i+1].replace('Diabellstar','디아벨스타')
                elif token in LABELS:
                    label=LABELS[token]
                    next_text=pieces[i+1].lstrip() if i+1<len(pieces) else ''
                    if not next_text.startswith(label):segments.append({'text':label+' '})
                elif token=='Pill1':segments.append({'icon':'Pill'})
            else:
                piece=re.sub(r'\s+',' ',piece)
                if piece.strip():segments.append({'text':piece})
        if segments:
            if 'text' in segments[0]:segments[0]['text']=segments[0]['text'].lstrip()
            if 'text' in segments[-1]:segments[-1]['text']=segments[-1]['text'].rstrip()
            lines.append(segments)
    return lines

def plain(lines):return ' '.join(s.get('text',s.get('item','')) for line in lines for s in line).strip()
manifest={'schema':1,'reviewed':REVIEW['reviewed'],'sources':[],'commit':SHA,'registrationCount':len(definitions),'entries':[]}
seen={e['id'] for e in catalog['entries']};new=0
for entry in catalog['entries']:entry.setdefault('origin','base')
for definition in definitions:
    key=ids[definition.get('name').casefold()];captured=result[str(key)];name=definition.get('name')
    existing=next((e for e in catalog['entries'] if e['name'].casefold()==name.casefold() or e['title']==captured['name']),None)
    if existing is None:
        slug='astro-'+re.sub(r'[^a-z0-9]+','-',name.lower()).strip('-')
        assert slug not in seen,slug
        seen.add(slug)
        existing={'id':slug,'title':captured['name'],'name':name,'kind':'passive' if definition.tag=='familiar' else definition.tag,
                  'scene':'','body':'','tag':'Astro-Items 추가','keywords':name+' '+captured['name'],
                  'rules':[],'effectGroups':[],'changeKinds':['effect']}
        catalog['entries'].append(existing);new+=1
    existing['origin']='mod';existing['title']=captured['name']
    existing['modItem']={k:v for k,v in definition.attrib.items() if k in ['id','quality','maxcharges','chargetype','hidden']}
    existing['modItem']['type']=definition.tag
    if definition.tag=='active':
        existing['modItem']['chargeLabel']=REVIEW['chargeLabels'][name]
    existing['image']=registry['names'][captured['name']]['image']
    if key in placeholder_ids:existing['imagePlaceholder']=True
    else:existing.pop('imagePlaceholder',None)
    description=captured['description']
    correction=REVIEW['corrections'].get(name,{})
    for change in correction.get('replace',[]):
        assert description.count(change['before'])==1,(name,change['before'])
        description=description.replace(change['before'],change['after'])
    for file in correction.get('extraSources',[]):
        if file not in existing.setdefault('extraSources',[]):existing['extraSources'].append(file)
    for link in correction.get('relatedLinks',[]):
        if link not in existing.setdefault('relatedLinks',[]):existing['relatedLinks'].append(link)
    existing['eidEffects']=effects(description)
    groups=[group for group in existing.get('effectGroups',[]) if group.get('generatedBy')!='astro-items']
    for field,label in [('copied','중첩 효과'),('golden','황금 장신구 효과')]:
        if captured.get(field):groups.append({'title':label,'items':[plain(line) for line in [[row] for row in effects(captured[field])]],'generatedBy':'astro-items'})
    for group in REVIEW['conditions'].get(name,[]):groups.append({**group,'generatedBy':'astro-items'})
    existing['effectGroups']=groups
    existing.setdefault('itemSources',[])
    for file in ['content/items.xml',captured['file']]+correction.get('sources',[]):
        register(file)
        if file not in existing['itemSources']:existing['itemSources'].append(file)
    notes=correction.get('notes',[])
    if notes:existing['agentNotes']=list(dict.fromkeys(existing.get('agentNotes',[])+notes))
    manifest['entries'].append({'id':existing['id'],'definition':dict(definition.attrib),'type':definition.tag,
                                'name':name,'eidName':captured['name'],'eidDescription':captured['description'],
                                'copied':captured.get('copied'),'golden':captured.get('golden'),
                                'eidEffects':existing['eidEffects'],'source':captured['file'],
                                'imagePlaceholder':key in placeholder_ids,
                                'image':existing['image'],'imageSHA256':digest((DOCS/existing['image']).read_bytes())})
assert len(manifest['entries'])==264
manifest['sources']=list(sources.values())
catalog['intro']='기존 아이템의 변경사항과 Astro-Items가 추가한 아이템·장신구의 효과를 확인할 수 있습니다. 출처와 종류를 선택하거나 통합 검색으로 이름과 효과를 찾을 수 있습니다.'
for file,data in [('items-content.json',catalog),('guide-icons.json',registry),('astro-items.json',manifest)]:
    (DOCS/file).write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
print('Astro-Items 등록 264종 반영:',new,'개 신규 카드,',264-new,'개 기존 카드에 효과 병합.')
