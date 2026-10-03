"""Save the installed EID sprites and original item icons for offline Pages builds."""
import argparse
import base64
import hashlib
import json
import re
import shutil
import struct
from pathlib import Path
from xml.etree import ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / 'docs'
parser = argparse.ArgumentParser()
parser.add_argument('--baseline', type=Path, required=True)
parser.add_argument('--eid', type=Path, required=True)
parser.add_argument('--base-mod', type=Path, required=True)
args = parser.parse_args()
assets = DOCS / 'assets/eid'
assets.mkdir(exist_ok=True)
sprites = {}


def sprite(sheet, animation, frame, name):
    actor = ET.parse(args.eid / 'resources/gfx' / (sheet + '.anm2')).getroot()
    frames = actor.find('./Animations/Animation[@Name="' + animation + '"]').findall('./LayerAnimations/LayerAnimation[@LayerId="0"]/Frame')
    crop = frames[frame]
    image = (args.eid / 'resources/gfx' / (sheet + '.png')).read_bytes()
    width, height = struct.unpack('>II', image[16:24])
    bounds = [int(crop.get(key)) for key in ['XCrop', 'YCrop', 'Width', 'Height']]
    x, y, w, h = bounds
    assert 0 <= x < x + w <= width and 0 <= y < y + h <= height
    encoded = base64.b64encode(image).decode()
    target = assets / (name + '.svg')
    target.write_text(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x} {y} {w} {h}"><image width="{width}" height="{height}" href="data:image/png;base64,{encoded}" style="image-rendering:pixelated"/></svg>\n')
    sprites[name] = {'image': target.relative_to(DOCS).as_posix(), 'sheet': sheet,
                     'animation': animation, 'frame': frame, 'crop': bounds,
                     'sourceSHA256': hashlib.sha256(image).hexdigest()}
    return sprites[name]['image']


for number in range(5):
    sprite('eid_inline_icons', 'Quality', number, 'Quality' + str(number))
for name, animation, frame in [('Heart', 'hearts', 0), ('SoulHeart', 'hearts', 8),
                                ('BlackHeart', 'hearts', 10), ('Coin', 'pickups', 4),
                                ('Bomb', 'pickups', 2), ('Key', 'pickups', 0),
                                ('Battery', 'pickups', 9), ('Pill', 'pickups', 8)]:
    sprite('eid_inline_icons', animation, frame, name)

catalog = json.loads((DOCS / 'items-content.json').read_text())['entries']
players = json.loads((DOCS / 'players-content.json').read_text())['entries']
registry = {entry['title']: {'image': entry['image']} for entry in catalog}
used = json.dumps(players, ensure_ascii=False)
name_file = args.eid / 'descriptions/names/ko_kr.lua'
names = re.findall(r'\[(C_ID|T_ID|Card_ID|Pill_ID)\s*\.\.\s*(\d+)\]\s*=\s*"((?:[^"\\]|\\.)*)"', name_file.read_text())
base_items = ET.parse(args.baseline / 'items.xml').getroot()
definitions = {('T_ID' if item.tag == 'trinket' else 'C_ID', int(item.get('id'))): item
               for item in base_items if item.get('id') and item.tag != 'null'}
originals = {path.name.casefold(): path for path in (args.baseline / 'gfx/items').rglob('*.png')}
for group, number, name in names:
    if name in registry or name not in used:
        continue
    if group in ('C_ID', 'T_ID'):
        definition = definitions.get((group, int(number)))
        if definition is None:
            continue
        original = originals[definition.get('gfx').casefold()]
        target = assets / (group.lower() + '-' + number + '.png')
        shutil.copyfile(original, target)
        registry[name] = {'image': target.relative_to(DOCS).as_posix(), 'eid': group + number,
                          'sourceSHA256': hashlib.sha256(original.read_bytes()).hexdigest()}
    elif group == 'Card_ID':
        key = 'Card' + number
        registry[name] = {'image': sprite('eid_cardspills', 'Cards', int(number) - 1, key), 'eid': key}
    else:
        # A pill effect does not have a fixed bottle color.
        registry[name] = {'image': sprites['Pill']['image'], 'eid': 'Pill'}

mod_items = ET.parse(args.base_mod / 'content/items.xml').getroot()
mod_definitions = {item.get('name'): item for item in mod_items}
mod_originals = {path.name.casefold(): path for path in (args.base_mod / 'resources/gfx/items').rglob('*.png')}
for directory, method, lookup in [('collectibles', 'Collectible', 'Item'), ('trinkets', 'Trinket', 'Trinket')]:
    for path in sorted((args.base_mod / 'astro' / directory).rglob('*.lua')):
        text = path.read_text()
        english = re.search(r'Isaac.Get' + lookup + r'IdByName\("([^"]+)"\)', text)
        korean = re.search(r'EID:Add' + method + r'\(\s*[^,]+,\s*"([^"]*[가-힣][^"]*)"', text)
        if not english or not korean or korean[1] in registry or korean[1] not in used:
            continue
        definition = mod_definitions.get(english[1])
        if definition is None:
            continue
        original = mod_originals[Path(definition.get('gfx')).name.casefold()]
        slug = re.sub(r'[^a-z0-9]+', '-', english[1].lower()).strip('-')
        target = assets / ('mod-' + slug + '.png')
        shutil.copyfile(original, target)
        registry[korean[1]] = {'image': target.relative_to(DOCS).as_posix(),
                              'name': english[1], 'source': path.relative_to(args.base_mod).as_posix(),
                              'sourceSHA256': hashlib.sha256(original.read_bytes()).hexdigest()}

required = set()
for entry in players:
    for category in entry.get('restrictions', []):
        required.update(category['items'])
    start = entry['rules'][0]
    if start.startswith('시작방에 추가 등장: '):
        required.update(start.removeprefix('시작방에 추가 등장: ').removesuffix('.').split(', '))
missing = required - registry.keys()
assert not missing, 'Missing starting/restricted item icons: ' + repr(sorted(missing))
payload = {'schema': 1, 'names': registry, 'sprites': sprites,
           'nameSourceSHA256': hashlib.sha256(name_file.read_bytes()).hexdigest()}
(DOCS / 'guide-icons.json').write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n')
print('Saved', len(sprites), 'EID sprite frames and', len(registry), 'named icons; all', len(required), 'starting/restricted names resolved.')
