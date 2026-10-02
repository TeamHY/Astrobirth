# Astrobirth 시청자 가이드

헌영의 아이작 대결을 처음 보는 시청자에게 변경 기능과 관전 포인트를 설명하는 한국어 정적 사이트입니다. 모드 실행 코드는 변경하지 않습니다.

## 미리보기

저장소 루트에서 아래 명령을 실행한 뒤 `http://localhost:4173/`를 엽니다.

```sh
python3 scripts/build-guide.py
python3 -m http.server 4173 --directory docs --bind 127.0.0.1
```

Node.js나 외부 패키지가 필요하지 않습니다. 자바스크립트를 꺼도 모든 가이드 내용을 읽을 수 있습니다. 검색, 분류와 고유 링크 자동 펼치기는 자바스크립트로 동작합니다.

사이트는 `index.html`(입문 Q&A), `items.html`(아이템 변경사항), `players.html`(플레이어 변경사항)의 세 페이지로 구성합니다. 사이드바는 페이지 이동 메뉴이며, Q&A 챕터 목차는 입문 Q&A 본문에만 표시합니다. 작은 화면에서는 같은 페이지 메뉴를 상단에 표시합니다. 페이지 소개의 장식 이미지와 요약 카드는 사용하지 않습니다. 개별 아이템·플레이어의 원본 이미지는 유지합니다. Q&A의 관련 링크는 해당 아이템·플레이어 카드로 바로 연결됩니다. 기존 아이템 설명의 고유 링크도 아이템 페이지로 이동합니다.

## 내용 수정

1. Q&A는 `guide-content.json`, 아이템은 `items-content.json`, 플레이어는 `players-content.json`에서 설명과 근거 파일 경로를 수정합니다.
2. 실제 변경을 확인한 커밋 SHA, 버전과 확인 날짜를 함께 갱신합니다. Astrobirth와 Astro-Items의 근거를 따로 관리합니다.
3. `python3 scripts/build-guide.py`를 실행해 세 HTML 파일을 갱신합니다. 공통 화면은 `scripts/guide-layout.html`에서 관리합니다.
4. 작은 화면과 넓은 화면에서 페이지·목차 이동, 검색·분류, 펼치기, 이미지와 고유 링크를 확인합니다.

입문 Q&A의 첫 챕터는 노피격·올백(방송 명칭 에이플)입니다. 전체 기능과 구간별 추가 보상, 올백과 무관한 공통 보상을 별도로 설명합니다. `effectGroups`는 기능별 목록, `rewardTable`은 조건·보상 표입니다. 아이템 카드의 `detailsFrom`은 같은 ID의 Q&A 상세 내용을 공유하여 조건이 어긋나지 않게 합니다.

아이템·플레이어 카드의 `kind`는 분류 버튼에 대응합니다. `image`는 `docs` 기준 상대 경로이며, `relatedLinks`에 다른 페이지의 카드나 Q&A 링크를 추가할 수 있습니다. HTML과 이미지 경로는 생성 과정에서 중복 ID·이미지 존재 여부를 검사합니다.

테마는 Astrobirth 대표 썸네일의 남색·파랑을 기본으로 사용하며, 보라색을 보조 강조색으로 사용합니다.

고유 링크는 각 제목 옆의 링크 아이콘으로 표시합니다. 근거 코드 링크는 화면에 표시하지 않고, 해당 설명의 HTML 주석 `Agent reference material`에 항목 ID·저장소·커밋·파일 경로·URL과 외부 참고 자료(`references`)를 JSON으로 보존합니다. 이후 내용 검토 시 JSON 원본 또는 생성된 HTML 주석을 참고할 수 있습니다. 사람을 위한 관련 Q&A·아이템·플레이어 링크는 그대로 표시합니다.

Q&A 제목은 자연스러운 ‘~나요?·~인가요?’ 질문형으로 통일합니다. 그 외 제목은 간결한 명사형을 사용하며, 설명문은 ‘입니다·합니다’체로 통일합니다. 설명에는 확인한 기능만 적습니다. 방송별 목표나 밴 해제 허용 같은 운영 규칙은 별도로 확인해야 합니다. ‘엄청 쉬움 모드’의 체력 상한은 EID 문구와 현재 실행 코드가 다르므로, 실행 코드를 근거로 설명합니다.

`assets/items`는 게임 원본 아이템·장신구 아이콘이며, `assets/players`는 게임과 Astro-Items의 캐릭터 원본 초상화·스프라이트를 사용합니다. 플레이어 SVG는 원본 PNG를 포함하고 `viewBox`로 빈 여백 또는 해당 스프라이트 영역만 잘라 보여줍니다. 원본 픽셀을 다시 그리거나 변형하지 않습니다. 아이템의 한글·영문 이름은 설치된 External Item Descriptions의 이름 표를 기준으로 했습니다. 모드 아이템·캐릭터의 한국어 이름은 Astro-Items의 EID 등록값을 사용하며, 방송 별칭은 검색어로 유지합니다. 게임 이미지의 권리는 원 제작자에게 있으며, 모드 이미지는 TeamHY/Astro-Items의 원본입니다.

## GitHub Pages

- 게임 코드의 `main` 브랜치와 문서 배포를 분리합니다. 문서 커밋에는 `docs/**`, 가이드 생성기·공통 템플릿과 배포 작업만 포함합니다.
- 배포 대상: `TeamHY/Astrobirth`의 `docs` 폴더만 업로드합니다.
- 배포 주소: `https://teamhy.github.io/Astrobirth/`
- 저장소의 **Settings → Pages → Build and deployment → Source**를 **GitHub Actions**로 설정합니다.
- 문서 전용 `gh-pages` 브랜치에 가이드 파일이 변경되면 `Publish viewer guide` 작업이 생성·배포합니다. 수동 실행도 가능합니다.
- 스타일, 스크립트, 이미지에 상대 경로를 사용하여 저장소 하위 경로에서도 동작합니다.
- 빌드 도구나 서버 실행 없이 `index.html`을 직접 열어 읽을 수도 있습니다.

작업 구성은 [GitHub Pages 공식 문서](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)를 기준으로 합니다.
