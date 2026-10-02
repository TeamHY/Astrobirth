#!/usr/bin/env python3
"""Refresh the review manifest against committed Lua and extracted game data.

This local maintenance step requires the matching Astro-Items checkout and the
unmodified extracted resources. Pages builds only validate its saved manifest.
References prove where a feature was reviewed; they do not prove prose accuracy.
"""
import argparse
import hashlib
import json
import re
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / 'docs'
parser = argparse.ArgumentParser()
parser.add_argument('--baseline', type=Path, required=True)
parser.add_argument('--base-mod', type=Path, required=True)
parser.add_argument('--feature-review', type=Path, help='JSON containing reviewed functional records')
args = parser.parse_args()
qa = json.loads((DOCS / 'guide-content.json').read_text())
sources = qa['sources']
projects = {'Astrobirth': ROOT, 'Astro-Items': args.base_mod}


def committed(project, path):
    return subprocess.check_output(['git', '-C', str(projects[project]), 'show',
                                    sources[project] + ':' + path])


def digest(value):
    return hashlib.sha256(value).hexdigest()


refs = {'Astrobirth': {}, 'Astro-Items': {}}
for page, filename in [('index', 'guide'), ('rules', 'rules'), ('items', 'items'), ('players', 'players')]:
    data = json.loads((DOCS / (filename + '-content.json')).read_text())
    entries = data.get('entries') or [e for s in data['sections'] for e in s['entries']]
    for entry in entries:
        for project, paths in [('Astrobirth', ([entry['source']] if entry.get('source') else []) + entry.get('extraSources', [])),
                               ('Astro-Items', entry.get('itemSources', []))]:
            for path in paths:
                refs[project].setdefault(path, set()).add(page + '.html#' + entry['id'])

# Walk only uncommented require statements reachable from the published main.
active, pending = set(), ['main.lua']
while pending:
    path = pending.pop()
    if path in active:
        continue
    active.add(path)
    text = committed('Astrobirth', path).decode()
    text = re.sub(r'--\[\[.*?\]\]', '', text, flags=re.S)
    text = '\n'.join(line.split('--', 1)[0] for line in text.splitlines())
    for module in re.findall(r'\brequire\s*(?:\(\s*)?[\"\']([^\"\']+)[\"\']', text):
        candidate = module.replace('.', '/') + '.lua'
        if (ROOT / candidate).is_file():
            pending.append(candidate)
refs['Astrobirth'].setdefault('main.lua', set()).add('rules.html#overview')
refs['Astrobirth'].setdefault('astro-fight/trinkets/init.lua', set()).add('items.html#perfection')
base_fight = []
for path in sorted((args.base_mod / 'astro').rglob('*.lua')):
    relative = path.relative_to(args.base_mod).as_posix()
    if re.search(r'Astro\.(?:IsFight|Fight)\b', committed('Astro-Items', relative).decode()):
        base_fight.append(relative)
assert not active - refs['Astrobirth'].keys(), 'Active module without a guide reference'
assert not set(base_fight) - refs['Astro-Items'].keys(), 'Base fight branch without a guide reference'

file_records = []
for project, mapping in refs.items():
    for path, targets in sorted(mapping.items()):
        file_records.append({'project': project, 'file': path, 'sha256': digest(committed(project, path)),
                             'refs': sorted(targets), 'activeModule': project == 'Astrobirth' and path in active,
                             'baseFightBranch': project == 'Astro-Items' and path in base_fight})


def xml(text):
    # The released players.xml repeats the identical bombs="2" attribute on id34.
    text = re.sub(r'(<player\b[^<>]*)', lambda m: re.sub(r' bombs="2"(?=[^<>]* bombs="2")', '', m[1]), text)
    return ET.fromstring(text)


def normalized(element):
    return {'tag': element.tag, 'attributes': dict(sorted(element.attrib.items())),
            'children': [normalized(child) for child in element]}


xml_records = []
targets = {'players.xml': 'players.html', 'pocketitems.xml': 'rules.html#pocket-item-settings',
           'cutscenes.xml': 'rules.html#presentation-changes', 'giantbook.xml': 'rules.html#presentation-changes'}
for filename, target in targets.items():
    original = (args.baseline / filename).read_bytes()
    modified = committed('Astrobirth', 'resources/' + filename)
    before, after = xml(original.decode()), xml(modified.decode())
    key = lambda e: (e.tag, e.get('id', e.get('name', '')))
    a, b = {key(e): normalized(e) for e in before}, {key(e): normalized(e) for e in after}
    differences = [{'key': list(k), 'before': a.get(k), 'after': b.get(k)}
                   for k in sorted(a.keys() | b.keys()) if a.get(k) != b.get(k)]
    xml_records.append({'file': 'resources/' + filename, 'originalSHA256': digest(original),
                        'modSHA256': digest(modified), 'rootBefore': before.attrib, 'rootAfter': after.attrib,
                        'changes': differences, 'refs': [target]})
rooms = json.loads((DOCS / 'rooms-content.json').read_text())
for floor in rooms['floors']:
    file_records.append({'project': 'Astrobirth', 'file': floor['metadata']['sourceFile'],
                         'sha256': floor['metadata']['sha256'], 'refs': ['rooms.html'], 'activeModule': False})
saved_manifest = ROOT / 'scripts/guide-coverage.json'
if args.feature_review:
    reviewed_groups = json.loads(args.feature_review.read_text())['records']
else:
    reviewed_groups = json.loads(saved_manifest.read_text())['featureGroups']
manifest = {'schemaVersion': 1, 'reviewed': qa['reviewed'], 'sources': sources,
            'reviewMethod': 'Reachable released Lua reviewed by functional groups; XML semantic differences; STB tuple comparisons with XML parity; EID name comparison.',
            'limits': ['File references check coverage placement, not the correctness of every sentence.',
                       'Uncommitted game debugging changes are excluded from the released guide.',
                       'Presets and entity definitions describe available data; spawn conditions are stated separately.'],
            'counts': {'activeLuaModules': len(active), 'baseFightModules': len(base_fight),
                       'qa': sum(len(s['entries']) for s in qa['sections']),
                       'items': len(json.loads((DOCS / 'items-content.json').read_text())['entries']),
                       'players': len(json.loads((DOCS / 'players-content.json').read_text())['entries']),
                       'roomFiles': len(rooms['floors'])},
            'files': file_records, 'featureGroups': [{k: v for k, v in r.items() if k != 'lines'} for r in reviewed_groups],
            'resourceDifferences': xml_records,
            'excluded': [{'file': 'resources/rooms/임시/33.corpse.stb', 'reason': 'Temporary directory; not loaded by the game.'},
                         {'file': 'resources/rooms/임시/33.corpse.xml', 'reason': 'Temporary editor source; not loaded.'},
                         {'file': 'content/sounds.xml', 'reason': 'Epic sound registration has no call in the active module graph.'}]}
(ROOT / 'scripts/guide-coverage.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
print('Coverage:', manifest['counts'])
