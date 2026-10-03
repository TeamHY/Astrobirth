"""Crop the same original emotion frame for every guide character.

Local maintenance tool requiring Pillow. Pages builds use the saved PNGs and
manifest and do not need Pillow or an installed copy of the game.
"""
import argparse
import hashlib
import json
import re
from pathlib import Path
from xml.etree import ElementTree as ET
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / 'docs'
CROP = [0, 192, 64, 64]
PADDING = 2
BASE_IDS = dict(zip(
    ['isaac', 'magdalene', 'cain', 'judas', 'bluebaby', 'eve', 'samson',
     'azazel', 'lazarus', 'eden', 'thelost', 'lilith', 'keeper', 'apollyon',
     'theforgotten', 'bethany', 'jacob'],
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 14, 15, 16, 18, 19]))
BASE_IDS.update({slug + '_b': 21 + index for index, slug in enumerate(list(BASE_IDS))})
parser = argparse.ArgumentParser()
parser.add_argument('--baseline', type=Path, required=True)
parser.add_argument('--base-mod', type=Path, required=True)
args = parser.parse_args()
guide = json.loads((DOCS / 'guide-content.json').read_text())
catalog = json.loads((DOCS / 'players-content.json').read_text())
base_definitions = args.baseline / 'players.xml'
mod_definitions = args.base_mod / 'content/players.xml'
base_players = ET.parse(base_definitions).getroot()
mod_players = ET.parse(mod_definitions).getroot()
base_by_id = {int(player.get('id')): player for player in base_players}
mod_by_slug = {}
for player in mod_players:
    name = player.get('bSkinParent') or player.get('name')
    slug = re.sub(r'[^a-z0-9]+', '-', name.lower()).strip('-')
    if player.get('bSkinParent'):
        slug += '_b'
    mod_by_slug[slug] = player
base_images = {path.name.casefold(): path for path in (args.baseline / base_players.get('root')).glob('*.png')}
animation_file = args.baseline / 'gfx/001.000_player.anm2'
actor = ET.parse(animation_file).getroot()
frame = actor.find('./Animations/Animation[@Name="Pickup"]/LayerAnimations/LayerAnimation[@LayerId="12"]/Frame')
assert frame is not None and frame.get('Visible') == 'true'
assert [int(frame.get(key)) for key in ['XCrop', 'YCrop', 'Width', 'Height']] == CROP
sources = {}


def source(path, project):
    relative = path.relative_to(args.base_mod if project == 'Astro-Items' else args.baseline).as_posix()
    record = {'project': project, 'file': relative, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
    if project == 'Astro-Items':
        record['commit'] = guide['sources']['Astro-Items']
    sources[project + ':' + relative] = record
    return relative


source(base_definitions, 'Game')
source(mod_definitions, 'Astro-Items')
manifest = {'schema': 2, 'pose': 'Leftmost middle emotion frame',
            'frame': {'project': 'Game', 'file': source(animation_file, 'Game'),
                      'animation': 'Pickup', 'layerId': '12', 'index': 0, 'crop': CROP},
            'sources': [], 'entries': []}
for entry in catalog['entries']:
    slug = entry['id']
    if entry['kind'] == 'custom':
        definition = mod_by_slug[slug]
        image_path = args.base_mod / 'resources' / mod_players.get('root') / definition.get('skin')
        project = 'Astro-Items'
    else:
        definition = base_by_id[BASE_IDS[slug]]
        image_path = base_images[definition.get('skin').casefold()]
        project = 'Game'
    entry['origin'] = 'mod' if project == 'Astro-Items' else 'base'
    is_tainted = bool(definition.get('bSkinParent')) if project == 'Astro-Items' else BASE_IDS[slug] >= 21
    entry['variant'] = 'tainted' if is_tainted else 'normal'
    image = Image.open(image_path).convert('RGBA')
    x, y, w, h = CROP
    assert 0 <= x < x + w <= image.width and 0 <= y < y + h <= image.height
    emotion = image.crop((x, y, x + w, y + h))
    bounds = emotion.getchannel('A').getbbox()
    assert bounds is not None, 'Empty emotion frame: ' + slug
    trimmed = emotion.crop(bounds)
    padded = Image.new('RGBA', (trimmed.width + PADDING * 2, trimmed.height + PADDING * 2))
    padded.paste(trimmed, (PADDING, PADDING))
    target = DOCS / 'assets/players' / (slug + '-emotion.png')
    padded.save(target, optimize=True)
    relative = source(image_path, project)
    entry['image'] = target.relative_to(DOCS).as_posix()
    if project == 'Astro-Items':
        # Remove source links for the abandoned, separately composed hair layers.
        entry['itemSources'] = [path for path in entry.get('itemSources', [])
                                if not path.startswith('resources/gfx/characters/') or '_hair.' not in path]
        if relative not in entry['itemSources']:
            entry['itemSources'].append(relative)
    record = {'id': slug, 'playerName': definition.get('name'),
              'image': entry['image'], 'source': {'project': project, 'file': relative},
              'sourceSize': list(image.size), 'crop': CROP, 'trim': list(bounds), 'padding': PADDING,
              'size': list(padded.size), 'sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
              'framePixelSHA256': hashlib.sha256(emotion.tobytes()).hexdigest(),
              'pixelSHA256': hashlib.sha256(padded.tobytes()).hexdigest()}
    if project == 'Game':
        record['playerId'] = BASE_IDS[slug]
    manifest['entries'].append(record)
manifest['sources'] = list(sources.values())
assert len(manifest['entries']) == 46
custom = [record for record in manifest['entries'] if record['source']['project'] == 'Astro-Items']
assert len(custom) == 12 and len({record['pixelSHA256'] for record in custom}) == 12, 'Duplicate custom emotion frame'
(DOCS / 'player-sprites.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
(DOCS / 'players-content.json').write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + '\n')
print('Cropped original emotion frames for 34 base and 12 custom characters.')
