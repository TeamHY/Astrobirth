#!/usr/bin/env python3
"""Check the generated guide with Python's standard library.

Run after build-guide.py. Content, links, shared Perfection details and the
ce55086 question titles are checked independently of the renderer. Room data
is read once per file; unchanged presets are intentionally absent from it.
"""

import json
import hashlib
import math
import re
import subprocess
import sys
from collections import Counter, defaultdict
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit
from xml.etree import ElementTree


ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"
QA_REVISION = "ce55086"
# Reviewed question titles from ce55086. This also works in shallow checkouts.
QA_TITLES = {
    "perfection-basics": "왜 노피격과 에이플이 대결의 핵심인가요?",
    "perfection-get": "에이플은 어떻게 얻고 유지하나요?",
    "perfection": "올백 장신구를 가지고 있으면 보상이 달라지나요?",
    "perfection-loss": "에이플을 잃으면 낙제로 보상을 이어 갈 수 있나요?",
    "perfection-damage": "보호막만 깨져도 에이플이 사라지나요?",
    "loadout": "왜 시작방에 아이템과 카드가 놓여 있나요?",
    "player-guide": "캐릭터별 변경사항은 어디에서 확인하나요?",
    "choice": "아이템 하나를 먹었는데 나머지가 사라졌어요",
    "first-treasure": "첫 보물방에서 좋은 아이템이 자주 보이는 이유",
    "next-ban": "이전 판에서 먹은 아이템이 다음 판에는 안 나와요",
    "ez-mode": "시작방의 ‘쉬움 모드’는 무엇인가요?",
    "item-guide": "아이템별 변경사항은 어디에서 확인하나요?",
    "portals": "보스방을 깼더니 방 사이에 포탈이 생겼어요",
    "machine": "초반 보스방에 낯선 기계가 있어요",
    "route-rewards": "칼 조각과 열쇠 조각을 따로 모으지 않나요?",
    "void": "메가 사탄 뒤에는 보이드로 갈 수 있나요?",
    "health-limit": "하트가 많았는데 갑자기 체력 칸이 줄었어요",
    "damage-penalty": "한 대 맞았는데 지도와 아이템까지 없어졌어요",
    "lost-shield": "로스트는 보호막만 깨져도 능력치가 떨어지나요?",
    "champions": "왜 색이 다른 적들이 이렇게 많나요?",
    "pause": "중요한 보스전에서 일시정지가 제한되는 이유",
}
CODE_URL = re.compile(
    r"https?://(?:github\.com/[^/\s\"<>]+/[^/\s\"<>]+/(?:blob|tree)/"
    r"|raw\.githubusercontent\.com/)", re.I
)
CSS_URL = re.compile(r"url\(\s*['\"]?([^)'\"\s]+)['\"]?\s*\)", re.I)
VOID_TAGS = set("area base br col embed hr img input link meta param source track wbr".split())


def normalized(value):
    return " ".join(str(value).split())


class Node:
    def __init__(self, tag, attrs=()):
        self.tag = tag
        self.attrs = dict(attrs)
        self.children = []
        self._text = None

    def has_class(self, name):
        return name in self.attrs.get("class", "").split()

    def nodes(self, tag=None):
        for child in self.children:
            if isinstance(child, Node):
                if tag is None or child.tag == tag:
                    yield child
                yield from child.nodes(tag)

    def text(self):
        if self._text is None:
            self._text = "" if self.tag in {"script", "style"} else normalized(
                " ".join(c.text() if isinstance(c, Node) else c for c in self.children)
            )
        return self._text


class Page(HTMLParser):
    def __init__(self, path):
        super().__init__(convert_charrefs=True)
        self.path = path
        self.root = Node("document")
        self.stack = [self.root]
        self.ids = defaultdict(list)
        self.urls = []
        self.comments = []
        self.references = defaultdict(list)
        self.reference_errors = []
        self.raw = path.read_text(encoding="utf-8")
        self.outside_comments = re.sub(r"<!--.*?-->", "", self.raw, flags=re.S)
        self.feed(self.raw)
        self.close()

    def handle_starttag(self, tag, attrs):
        node = Node(tag, attrs)
        self.stack[-1].children.append(node)
        if node.attrs.get("id"):
            self.ids[node.attrs["id"]].append(node)
        for key in ["href", "src", "poster", "data-src", "data-json", "xlink:href"]:
            if node.attrs.get(key):
                self.urls.append((node.attrs[key], key in {"href", "xlink:href"}))
        srcset = node.attrs.get("srcset", "")
        if srcset and not srcset.lstrip().startswith("data:"):
            self.urls.extend((part.strip().split()[0], False) for part in srcset.split(",") if part.strip())
        self.urls.extend((url, False) for url in CSS_URL.findall(node.attrs.get("style", "")))
        if tag not in VOID_TAGS:
            self.stack.append(node)

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag, attrs)
        if tag not in VOID_TAGS:
            self.handle_endtag(tag)

    def handle_endtag(self, tag):
        for index in range(len(self.stack) - 1, 0, -1):
            if self.stack[index].tag == tag:
                del self.stack[index:]
                return

    def handle_data(self, text):
        self.stack[-1].children.append(text)

    def handle_comment(self, text):
        self.comments.append(text)
        prefix = "Agent reference material"
        if text.strip().startswith(prefix):
            try:
                reference = json.loads(text.strip()[len(prefix):].strip())
                self.references[reference["entry"]].append(reference)
            except (ValueError, KeyError, TypeError) as error:
                self.reference_errors.append(str(error))


class Verification:
    def __init__(self):
        self.errors = []
        self.json_cache = {}
        self.pages = {}
        self.svg_cache = {}
        self.links_checked = set()
        self.entry_count = 0
        self.table_count = 0
        self.room_count = 0
        self.source_hash_count = 0

    def require(self, condition, message):
        if not condition:
            self.errors.append(message)
        return condition

    def load_json(self, path):
        path = path.resolve()
        if path not in self.json_cache:
            self.json_cache[path] = json.loads(path.read_text(encoding="utf-8"))
        return self.json_cache[path]

    def local_url(self, source, value, check_hash=True):
        key = (source, value, check_hash)
        if key in self.links_checked:
            return
        self.links_checked.add(key)
        parts = urlsplit(value)
        if parts.scheme or parts.netloc:
            return
        path = unquote(parts.path)
        if path.startswith("/"):
            path = path.lstrip("/")
            if path.startswith(ROOT.name + "/"):
                path = path[len(ROOT.name) + 1:]
            target = DOCS / path
        else:
            target = source.parent / path if path else source
        target = target.resolve()
        if target.is_dir():
            target = target / "index.html"
        label = f"{source.relative_to(DOCS)}: {value}"
        if not self.require(target.is_relative_to(DOCS), f"배포 폴더 밖의 로컬 링크: {label}"):
            return
        if not self.require(target.is_file(), f"누락된 로컬 파일: {label}"):
            return
        fragment = unquote(parts.fragment)
        if not check_hash or not fragment:
            return
        if target in self.pages:
            found = fragment in self.pages[target].ids
        elif target.suffix.lower() == ".svg":
            if target not in self.svg_cache:
                self.svg_cache[target] = {e.get("id") for e in ElementTree.parse(target).iter() if e.get("id")}
            found = fragment in self.svg_cache[target]
        else:
            self.require(False, f"고유 링크를 검사할 수 없는 파일 형식: {label}")
            return
        self.require(found, f"누락된 고유 링크 대상: {label}")

    def page_checks(self):
        for path in sorted(DOCS.rglob("*.html")):
            self.pages[path.resolve()] = Page(path)
        self.require(bool(self.pages), "생성된 HTML 페이지가 없습니다.")
        for path, page in self.pages.items():
            for key, nodes in page.ids.items():
                self.require(len(nodes) == 1, f"{path.name}: 중복 HTML ID {key}")
            for error in page.reference_errors:
                self.require(False, f"{path.name}: 근거 주석 JSON 오류 {error}")
            self.require(not CODE_URL.search(page.outside_comments), f"{path.name}: 코드 출처 URL이 HTML 주석 밖에 있습니다.")
            for url, check_hash in page.urls:
                self.local_url(path, url, check_hash)
            for node in page.root.nodes("style"):
                for text in node.children:
                    if isinstance(text, str):
                        for url in CSS_URL.findall(text):
                            self.local_url(path, url, False)
        for path in sorted(DOCS.rglob("*.css")):
            text = re.sub(r"/\*.*?\*/", "", path.read_text(encoding="utf-8"), flags=re.S)
            urls = CSS_URL.findall(text) + re.findall(r"@import\s+['\"]([^'\"]+)['\"]", text)
            for url in urls:
                if not url.startswith("#"):
                    self.local_url(path, url, False)
        for path in sorted(DOCS.rglob("*.js")):
            text = path.read_text(encoding="utf-8")
            for match in re.finditer(r"\b(?:fetch|import)\s*\(\s*(['\"])(.*?)\1", text):
                self.local_url(path, match.group(2), False)
            for match in re.finditer(r"\b(?:from|import)\s+(['\"])(\.{1,2}/.*?)\1", text):
                self.local_url(path, match.group(2), False)
            for match in re.finditer(r"(['\"])(\.{1,2}/[^'\"\n]+\.(?:html|json|png|svg|webp|jpg|css|js))\1", text):
                self.local_url(path, match.group(2), False)

    def check_sources(self, page, entry, guide):
        expected = set()
        for repository, paths in [
            ("Astrobirth", ([entry["source"]] if entry.get("source") else []) + entry.get("extraSources", [])),
            ("Astro-Items", entry.get("itemSources", [])),
        ]:
            for path in paths:
                expected.add((repository, guide["sources"][repository], path))
        references = entry.get("references", [])
        if not expected and not references:
            return
        comments = page.references.get(entry["id"], [])
        label = f"{page.path.name}#{entry['id']}"
        self.require(len(comments) == 1, f"{label}: 근거 주석이 정확히 하나 있어야 합니다.")
        if not comments:
            return
        material = comments[0]
        actual = {(s.get("repository"), s.get("commit"), s.get("path")) for s in material.get("sources", [])}
        self.require(actual == expected, f"{label}: JSON과 근거 주석의 코드 출처가 다릅니다.")
        for source in material.get("sources", []):
            url = f"https://github.com/TeamHY/{source.get('repository')}/blob/{source.get('commit')}/{source.get('path')}"
            self.require(source.get("url") == url, f"{label}: 코드 출처 URL이 경로와 일치하지 않습니다.")
        self.require(material.get("references", []) == references, f"{label}: 추가 참고자료가 근거 주석에서 누락되었습니다.")
        for reference in references:
            url = reference.get("url")
            if url:
                self.require(url not in page.outside_comments, f"{label}: 참고자료 URL이 HTML 주석 밖에 있습니다.")

    def check_entry(self, page, original, guide, qa_by_id):
        entry = original
        if original.get("detailsFrom"):
            shared = qa_by_id.get(original["detailsFrom"])
            if not self.require(shared is not None, f"{page.path.name}: 공유 설명이 없습니다: {original['detailsFrom']}"):
                return
            entry = {**shared, **original}
            for key in ["rules", "effectGroups"]:
                entry[key] = shared.get(key, []) + original.get(key, [])
        label = f"{page.path.name}#{entry['id']}"
        nodes = page.ids.get(entry["id"], [])
        if not self.require(len(nodes) == 1, f"{label}: JSON 항목의 HTML이 없습니다."):
            return
        node = nodes[0]
        self.entry_count += 1
        for key in ["title", "name", "scene", "body", "watch", "caution", "restrictionNote"]:
            if entry.get(key):
                self.require(normalized(entry[key]) in node.text(), f"{label}: {key} 문구가 반영되지 않았습니다.")
        titles = [n.text() for n in node.nodes() if n.has_class("entry-title")]
        if titles:
            self.require(titles == [normalized(entry["title"])], f"{label}: 질문 제목이 JSON과 다릅니다.")
        expected_groups = entry.get("effectGroups", [])
        groups = [n for n in node.nodes() if n.has_class("effect-group")]
        self.require(len(groups) == len(expected_groups), f"{label}: 효과 그룹 수가 다릅니다.")
        for actual, expected in zip(groups, expected_groups):
            self.require([n.text() for n in actual.nodes("h3")] == [normalized(expected["title"])], f"{label}: 효과 그룹 제목이 다릅니다.")
            self.require([n.text() for n in actual.nodes("li")] == [normalized(t) for t in expected["items"]], f"{label}: 효과 그룹의 세부 조건이 다릅니다.")
        bodies = [n for n in node.nodes() if n.has_class("entry-body")]
        rendered_rules = []
        for body in bodies:
            for child in body.children:
                if isinstance(child, Node) and child.tag == "ul" and child.has_class("rule-list"):
                    rendered_rules.extend(n.text() for n in child.nodes("li"))
        self.require(rendered_rules == [normalized(t) for t in entry.get("rules", [])], f"{label}: 규칙 목록이 다릅니다.")
        expected_tables = [entry[key] for key in ["rewardTable", "poolTable"] if entry.get(key)]
        tables = list(node.nodes("table"))
        self.require(len(tables) == len(expected_tables), f"{label}: 표 수가 다릅니다.")
        for actual, expected in zip(tables, expected_tables):
            self.table_count += 1
            self.require([n.text() for n in actual.nodes("caption")] == [normalized(expected["caption"])], f"{label}: 표 제목이 다릅니다.")
            rows = [[n.text() for n in row.children if isinstance(n, Node) and n.tag in {"th", "td"}] for row in actual.nodes("tr")]
            expected_rows = [expected["columns"]] + expected["rows"]
            self.require(rows == [[normalized(cell) for cell in row] for row in expected_rows], f"{label}: 표의 열 또는 행이 다릅니다.")
            self.require(all(len(row) == len(expected["columns"]) for row in expected["rows"]), f"{label}: JSON 표의 열 수가 일정하지 않습니다.")
            if expected.get("note"):
                self.require(normalized(expected["note"]) in node.text(), f"{label}: 표 주석이 없습니다.")
        for restriction in entry.get("restrictions", []):
            expected = normalized(restriction["label"] + " " + ", ".join(restriction["items"]))
            self.require(expected in node.text(), f"{label}: 캐릭터 금지 목록이 다릅니다.")
        actual_links = {(n.attrs.get("href"), n.text()) for n in node.nodes("a")}
        for link in entry.get("relatedLinks", []):
            self.require(any(href == link["href"] and normalized(link["label"]) in text for href, text in actual_links), f"{label}: 관련 설명 링크가 없습니다: {link['href']}")
        if entry.get("related"):
            self.require(any(href == "#" + entry["related"] for href, _ in actual_links), f"{label}: 관련 설명 고유 링크가 없습니다.")
        if entry.get("image"):
            self.local_url(page.path, entry["image"], False)
            self.require(any(n.attrs.get("src", "").removeprefix("./") == entry["image"] for n in node.nodes("img")), f"{label}: JSON 이미지가 표시되지 않습니다.")
        self.check_sources(page, entry, guide)

    def content_checks(self):
        guide = self.load_json(DOCS / "guide-content.json")
        qa = [e for s in guide["sections"] for e in s["entries"]]
        qa_by_id = {e["id"]: e for e in qa}
        self.require(len(qa) == 21, "입문 Q&A는 21개를 유지해야 합니다.")
        self.require({e["id"]: e["title"] for e in qa} == QA_TITLES, "입문 Q&A 제목 또는 항목이 ce55086 복원 기준과 다릅니다.")
        baseline = subprocess.run(["git", "show", f"{QA_REVISION}:docs/guide-content.json"], cwd=ROOT, capture_output=True, text=True)
        if baseline.returncode == 0:
            historical = json.loads(baseline.stdout)
            historical_titles = {e["id"]: e["title"] for s in historical["sections"] for e in s["entries"]}
            self.require(historical_titles == QA_TITLES, "검증기의 질문 기준이 ce55086과 다릅니다.")
        for path in sorted(DOCS.glob("*-content.json")):
            data = self.load_json(path)
            if "sections" not in data and "entries" not in data:
                continue
            page_name = "index" if path.stem == "guide-content" else path.stem.removesuffix("-content")
            page = self.pages.get((DOCS / f"{page_name}.html").resolve())
            if not self.require(page is not None, f"{path.name}: 생성 HTML 페이지가 없습니다."):
                continue
            entries = data.get("entries", []) or [e for s in data.get("sections", []) for e in s["entries"]]
            ids = [e["id"] for e in entries] + [s["id"] for s in data.get("sections", [])]
            self.require(len(ids) == len(set(ids)), f"{path.name}: JSON 항목 또는 섹션 ID가 중복됩니다.")
            cards = [n for n in page.root.nodes() if n.has_class("entry") or n.has_class("catalog-card")]
            self.require(Counter(n.attrs.get("id") for n in cards) == Counter(e["id"] for e in entries), f"{page.path.name}: JSON과 생성된 항목 목록이 다릅니다.")
            for section in data.get("sections", []):
                nodes = page.ids.get(section["id"], [])
                self.require(len(nodes) == 1 and normalized(section["title"]) in nodes[0].text(), f"{page.path.name}: 섹션이 없습니다: {section['id']}")
                if nodes and section.get("subtitle"):
                    self.require(normalized(section["subtitle"]) in nodes[0].text(), f"{page.path.name}: 섹션 부제가 없습니다: {section['id']}")
            if isinstance(data.get("intro"), str):
                self.require(normalized(data["intro"]) in page.root.text(), f"{page.path.name}: 소개 문구가 반영되지 않았습니다.")
            for entry in entries:
                self.check_entry(page, entry, guide, qa_by_id)
        perfection = qa_by_id.get("perfection", {})
        self.require(len(perfection.get("effectGroups", [])) == 6, "Perfection의 공유 효과 그룹은 6개를 유지해야 합니다.")
        self.require(len(perfection.get("rewardTable", {}).get("rows", [])) == 9, "Perfection의 보상 표는 9행을 유지해야 합니다.")
        items = self.load_json(DOCS / "items-content.json")
        item = next((e for e in items["entries"] if e["id"] == "perfection"), {})
        self.require(item.get("detailsFrom") == "perfection", "올백 아이템 카드는 Q&A의 Perfection 상세를 공유해야 합니다.")
        self.require(not item.get("rewardTable") or item["rewardTable"] == perfection.get("rewardTable"), "올백 아이템 카드가 공유 보상 표를 다른 내용으로 덮어씁니다.")

    def room_checks(self):
        path = DOCS / "rooms-content.json"
        if not path.exists():
            return
        index = self.load_json(path)
        floors = index.get("floors", [])
        self.require(len(floors) == len({f["id"] for f in floors}), "방 비교 층 ID가 중복됩니다.")
        self.require(index["statistics"]["files"] == len(floors), "방 비교 파일 합계가 층 목록과 다릅니다.")
        page = self.pages.get((DOCS / "rooms.html").resolve())
        self.require(page is not None, "방 비교 JSON의 rooms.html 페이지가 없습니다.")
        if page:
            intro = index.get("intro", {})
            for key in ["title", "body"]:
                if intro.get(key):
                    self.require(normalized(intro[key]) in page.root.text(), f"rooms.html: {key} 소개 문구가 없습니다.")
        totals = Counter()
        for floor in floors:
            self.local_url(path, floor["path"], False)
            asset = DOCS / floor["path"]
            if not asset.is_file():
                continue
            data = self.load_json(asset)
            self.require(data["id"] == floor["id"], f"{asset.name}: 방 파일 ID가 색인과 다릅니다.")
            self.require(data["statistics"] == floor["statistics"], f"{asset.name}: 방 파일 통계가 색인과 다릅니다.")
            if floor.get("bytes") is not None:
                self.require(asset.stat().st_size == floor["bytes"], f"{asset.name}: 색인의 파일 크기가 다릅니다.")
            stats = data["statistics"]
            totals.update(stats)
            self.require(stats["before"] == stats["same"] + stats["changed"] + stats["removed"], f"{asset.name}: 변경 전 방 개수가 맞지 않습니다.")
            self.require(stats["after"] == stats["same"] + stats["changed"] + stats["added"], f"{asset.name}: 변경 후 방 개수가 맞지 않습니다.")
            rooms = data["rooms"]
            self.room_count += len(rooms)
            self.require(len(rooms) == len({r["id"] for r in rooms}), f"{asset.name}: 방 프리셋 ID가 중복됩니다.")
            kinds = Counter(r["change"] for r in rooms)
            for kind in ["changed", "added", "removed"]:
                self.require(kinds[kind] == stats[kind], f"{asset.name}: {kind} 프리셋 수가 통계와 다릅니다.")
            for room in rooms:
                label = f"{asset.name}#{room['id']}"
                expected_sides = {"changed": (True, True), "added": (False, True), "removed": (True, False)}.get(room["change"])
                self.require(expected_sides == (room["before"] is not None, room["after"] is not None), f"{label}: 방 추가·제거 상태가 올바르지 않습니다.")
                for side in ["before", "after"]:
                    preset = room[side]
                    if preset is None:
                        continue
                    self.require([preset[k] for k in ["type", "variant", "subtype"]] == room["key"], f"{label}: {side} 방 식별자가 다릅니다.")
                    for spawn in preset["spawns"]:
                        self.require(len(spawn) == 3 and bool(spawn[2]), f"{label}: {side} 스폰 후보 묶음이 올바르지 않습니다.")
                        for candidate in spawn[2]:
                            self.require(len(candidate) == 4 and isinstance(candidate[3], (int, float)) and math.isfinite(candidate[3]) and candidate[3] >= 0, f"{label}: {side} 스폰 후보 가중치가 올바르지 않습니다.")
                            entity_id = ".".join(str(x) for x in candidate[:3])
                            self.require(entity_id in data["entities"][side], f"{label}: {side} 스폰 후보 표시 자료가 없습니다: {entity_id}")
        for key, value in totals.items():
            self.require(index["statistics"][key] == value, f"방 비교 색인의 {key} 합계가 파일별 통계와 다릅니다.")

    def snapshot_checks(self):
        items = self.load_json(DOCS / "items-content.json")
        entries = {e["id"]: e for e in items["entries"]}
        path = DOCS / "resource-changes.json"
        if path.exists():
            data = self.load_json(path)
            for category in ["itemAttributes", "metadata", "pools"]:
                for record in data.get(category, []):
                    entry = entries.get(record.get("entry"))
                    label = f"{path.name}/{category}: {record.get('entry')}"
                    if not self.require(entry is not None, f"{label}: 아이템 항목이 없습니다."):
                        continue
                    self.require(entry.get("number") == record["number"], f"{label}: 아이템 번호가 다릅니다.")
                    kind = record.get("kind")
                    if kind == "familiar":
                        kind = "passive"
                    if kind in {"passive", "active", "trinket"}:
                        self.require(entry["kind"] == kind, f"{label}: 아이템 종류가 다릅니다.")
                    expected_change = "pool" if category == "pools" else "config"
                    self.require(expected_change in entry.get("changeKinds", []), f"{label}: 변경 분야 필터에서 누락됩니다.")
                    if category == "pools":
                        self.require(bool(entry.get("poolTable", {}).get("rows")), f"{label}: 배열 변경 표가 없습니다.")
        path = DOCS / "entity-changes.json"
        if not path.exists():
            return
        data = self.load_json(path)
        records = data.get("records", [])
        self.require(len(records) == data["changedEntities"], "개체 변경 스냅샷의 항목 수가 맞지 않습니다.")
        self.require(len(records) == len({tuple(r["key"]) for r in records}), "개체 변경 스냅샷의 식별자가 중복됩니다.")
        self.require(sum(len(r.get("attributes", {})) for r in records) == data["changedAttributeCount"], "개체 변경 스냅샷의 속성 변경 수가 맞지 않습니다.")
        for record in records:
            label = ".".join(record["key"])
            self.require(bool(record.get("documents")), f"개체 {label}: 변경 설명 항목이 없습니다.")
            refs = record.get("documents", []) + record.get("nestedDocuments", [])
            attribute_docs = record.get("attributeDocuments", {})
            self.require(set(record.get("attributes", {})) <= set(attribute_docs), f"개체 {label}: 속성별 설명 항목이 누락됩니다.")
            for documents in attribute_docs.values():
                self.require(bool(documents), f"개체 {label}: 속성 변경 설명 항목이 비어 있습니다.")
                refs += documents
            if record.get("childrenChanged"):
                self.require(bool(record.get("nestedDocuments")), f"개체 {label}: 중첩 설정의 설명 항목이 없습니다.")
            for ref in set(refs):
                self.local_url(DOCS / "index.html", "rules.html#" + ref)

    def committed_hashes(self, records, sources):
        for project in ["Astrobirth", "Astro-Items"]:
            checkout = ROOT if project == "Astrobirth" else ROOT.parent / "Astro-Items"
            sha = sources.get(project)
            if not sha or not checkout.is_dir():
                continue
            available = subprocess.run(["git", "-C", str(checkout), "cat-file", "-e", sha + "^{commit}"], capture_output=True)
            if available.returncode:
                continue
            files = {}
            for record in records:
                if record.get("project") != project or not record.get("sha256"):
                    continue
                path, digest = record["file"], record["sha256"]
                self.require(path not in files or files[path] == digest, f"{project}/{path}: 검토 자료 사이에 출처 해시가 서로 다릅니다.")
                files.setdefault(path, digest)
            if not files:
                continue
            requests = "".join(f"{sha}:{path}\n" for path in files).encode()
            batch = subprocess.run(["git", "-C", str(checkout), "cat-file", "--batch"], input=requests, capture_output=True)
            if not self.require(batch.returncode == 0, f"{project}: 커밋된 근거 파일의 해시를 읽을 수 없습니다."):
                continue
            offset = 0
            for path, expected in files.items():
                end = batch.stdout.index(b"\n", offset)
                header = batch.stdout[offset:end].decode()
                offset = end + 1
                if header.endswith(" missing"):
                    self.require(False, f"{project}: 출처 커밋에 근거 파일이 없습니다: {path}")
                    continue
                _, kind, size = header.split()
                size = int(size)
                content = batch.stdout[offset:offset + size]
                offset += size + 1
                self.require(kind == "blob" and hashlib.sha256(content).hexdigest() == expected, f"{project}/{path}: 기록된 해시가 출처 커밋과 다릅니다.")
                self.source_hash_count += 1

    def coverage_checks(self):
        path = ROOT / "scripts/guide-coverage.json"
        if not self.require(path.is_file(), "scripts/guide-coverage.json 검토 목록이 없습니다."):
            return
        data = self.load_json(path)
        guide = self.load_json(DOCS / "guide-content.json")
        self.require(data["sources"] == guide["sources"], "검토 목록과 가이드 JSON의 출처 커밋이 다릅니다.")
        for category in ["files", "featureGroups", "resourceDifferences"]:
            for record in data.get(category, []):
                refs = record.get("refs", [])
                self.require(bool(refs) or bool(record.get("disposition")), f"검토 목록 {category}/{record.get('file')}: 설명 연결 또는 제외 근거가 없습니다.")
                for ref in refs:
                    self.local_url(DOCS / "index.html", ref)
        counts = data["counts"]
        expected_counts = {
            "qa": sum(len(s["entries"]) for s in guide["sections"]),
            "items": len(self.load_json(DOCS / "items-content.json")["entries"]),
            "players": len(self.load_json(DOCS / "players-content.json")["entries"]),
            "activeLuaModules": sum(bool(r.get("activeModule")) for r in data["files"]),
            "baseFightModules": sum(bool(r.get("baseFightBranch")) for r in data["files"]),
        }
        rooms = DOCS / "rooms-content.json"
        if rooms.exists():
            expected_counts["roomFiles"] = len(self.load_json(rooms)["floors"])
        for key, count in expected_counts.items():
            self.require(counts.get(key) == count, f"검토 목록의 {key} 개수가 현재 자료와 다릅니다.")
        hash_records = list(data["files"])
        hash_records.extend({"project": "Astrobirth", "file": r["file"], "sha256": r["modSHA256"]} for r in data.get("resourceDifferences", []))
        entities = DOCS / "entity-changes.json"
        if entities.exists():
            snapshot = self.load_json(entities)
            hash_records.append({"project": "Astrobirth", "file": snapshot["source"], "sha256": snapshot["modSHA256"]})
        self.committed_hashes(hash_records, data["sources"])

    def run(self):
        self.page_checks()
        self.content_checks()
        self.room_checks()
        self.snapshot_checks()
        self.coverage_checks()
        if self.errors:
            print(f"가이드 검증 실패: {len(self.errors)}개 오류", file=sys.stderr)
            for error in self.errors[:60]:
                print(f"- {error}", file=sys.stderr)
            if len(self.errors) > 60:
                print(f"- 나머지 {len(self.errors) - 60}개 오류는 생략했습니다.", file=sys.stderr)
            return 1
        print(f"가이드 검증 통과: HTML {len(self.pages)}개, 항목 {self.entry_count}개, 표 {self.table_count}개, 방 프리셋 {self.room_count}개")
        print(f"Q&A 21개 제목({QA_REVISION}), Perfection 공유 6그룹·보상 9행, 로컬 링크·이미지·근거 주석 확인")
        print(f"검토 목록 연결·수치 및 출처 커밋의 파일 해시 {self.source_hash_count}개 확인")
        return 0


if __name__ == "__main__":
    try:
        sys.exit(Verification().run())
    except (OSError, ValueError, KeyError, TypeError, ElementTree.ParseError) as error:
        print(f"가이드 검증을 완료할 수 없습니다: {error}", file=sys.stderr)
        sys.exit(1)
