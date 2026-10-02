# Astrobirth 시청자 가이드

헌영의 아이작 대결을 처음 보는 시청자에게 변경 기능과 관전 포인트를 설명하는 한국어 정적 사이트입니다. 모드 실행 코드는 변경하지 않습니다.

## 미리보기

저장소 루트에서 아래 명령을 실행한 뒤 `http://localhost:4173/`를 엽니다.

```sh
python3 scripts/build-guide.py
python3 -m http.server 4173 --directory docs --bind 127.0.0.1
```

Node.js나 외부 패키지가 필요하지 않습니다. 자바스크립트를 꺼도 모든 가이드 내용을 읽을 수 있습니다. 검색과 고유 링크 자동 펼치기는 자바스크립트로 동작합니다.

## 내용 수정

1. `guide-content.json`의 해당 설명과 근거 파일 경로를 수정합니다.
2. 실제 변경을 확인한 커밋 SHA, 버전과 확인 날짜를 함께 갱신합니다. Astrobirth와 Astro-Items의 근거를 따로 관리합니다.
3. `python3 scripts/build-guide.py`를 실행해 `index.html`을 갱신합니다.
4. 작은 화면과 넓은 화면에서 검색, 목차 이동, 펼치기와 원문 링크를 확인합니다.

설명에는 확인한 기능만 적습니다. 방송별 목표나 밴 해제 허용 같은 운영 규칙은 별도로 확인해야 합니다. ‘엄청 쉬움 모드’의 체력 상한은 EID 문구와 현재 실행 코드가 다르므로, 실행 코드를 근거로 설명합니다.

`assets`의 이미지는 TeamHY/Astro-Items의 원본 아이템 도트입니다. 다른 용도로 사용하기 전에는 원 제작자의 권리를 확인하세요.

## GitHub Pages

- 배포 대상: `TeamHY/Astrobirth`의 `docs` 폴더만 업로드합니다.
- 배포 주소: `https://teamhy.github.io/Astrobirth/`
- 저장소의 **Settings → Pages → Build and deployment → Source**를 **GitHub Actions**로 설정합니다.
- `main`에 가이드 파일이 변경되면 `Publish viewer guide` 작업이 생성·배포합니다. 수동 실행도 가능합니다.
- 스타일, 스크립트, 이미지에 상대 경로를 사용하여 저장소 하위 경로에서도 동작합니다.
- 빌드 도구나 서버 실행 없이 `index.html`을 직접 열어 읽을 수도 있습니다.

작업 구성은 [GitHub Pages 공식 문서](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)를 기준으로 합니다.
