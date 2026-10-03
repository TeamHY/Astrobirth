#!/usr/bin/env python3
"""Add EID stat sprites without replacing the existing guide icon registry."""
import argparse
import base64
import hashlib
import json
import re
import struct
from pathlib import Path
from xml.etree import ElementTree as ET


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--eid', type=Path, required=True)
    args = parser.parse_args()
    docs = Path(__file__).resolve().parents[1] / 'docs'
    registry_file = docs / 'guide-icons.json'
    registry = json.loads(registry_file.read_text(encoding='utf-8'))
    definitions = (args.eid / 'features/eid_data.lua').read_text(encoding='utf-8')
    sheet = 'eid_inline_icons'
    actor = ET.parse(args.eid / 'resources/gfx' / (sheet + '.anm2')).getroot()
    image = (args.eid / 'resources/gfx' / (sheet + '.png')).read_bytes()
    assert image[:8] == b'\x89PNG\r\n\x1a\n', 'EID icon source must be PNG'
    width, height = struct.unpack('>II', image[16:24])
    encoded = base64.b64encode(image).decode('ascii')
    source_hash = hashlib.sha256(image).hexdigest()
    assets = docs / 'assets/eid'
    assets.mkdir(parents=True, exist_ok=True)
    names = ['DamageSmall', 'SpeedSmall', 'TearsSmall', 'RangeSmall', 'ShotspeedSmall', 'LuckSmall']
    for name in names:
        definition = re.search(r'\["' + name + r'"\]\s*=\s*\{\s*"([^"]+)",\s*(\d+)', definitions)
        assert definition is not None, 'Missing EID definition: ' + name
        animation, frame = definition[1], int(definition[2])
        assert animation == 'Stats', 'Unexpected EID animation: ' + name
        frames = actor.find('./Animations/Animation[@Name="' + animation + '"]').findall('./LayerAnimations/LayerAnimation[@LayerId="0"]/Frame')
        crop = [int(frames[frame].get(key)) for key in ['XCrop', 'YCrop', 'Width', 'Height']]
        x, y, w, h = crop
        assert 0 <= x < x + w <= width and 0 <= y < y + h <= height, 'Invalid EID crop: ' + name
        target = assets / (name + '.svg')
        target.write_text(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x} {y} {w} {h}"><image width="{width}" height="{height}" href="data:image/png;base64,{encoded}" style="image-rendering:pixelated"/></svg>\n', encoding='utf-8')
        registry['sprites'][name] = {
            'image': target.relative_to(docs).as_posix(), 'sheet': sheet,
            'animation': animation, 'frame': frame, 'crop': crop,
            'sourceSHA256': source_hash,
        }
    registry_file.write_text(json.dumps(registry, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('Saved', len(names), 'EID stat icon frames; existing registry entries preserved.')


if __name__ == '__main__':
    main()
