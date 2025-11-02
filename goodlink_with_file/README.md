# GoodLinks .webloc Importer

macOS에서 .webloc 파일을 GoodLinks 앱에 추가하는 Quick Action입니다.

## 기능

- ✅ 여러 .webloc 파일을 한번에 처리
- ✅ Finder 컨텍스트 메뉴에서 바로 실행
- ✅ 성공/실패 여부를 팝업으로 표시
- ✅ 실패한 파일과 사유를 상세히 보고

## 설치 방법

### 1단계: Automator Quick Action 만들기

1. **Automator 앱 실행** (Spotlight에서 "Automator" 검색)

2. **새로운 문서 생성**
   - "빠른 동작(Quick Action)" 선택

3. **워크플로우 설정**
   - 상단 설정:
     - "워크플로우가 받는 항목": **파일 또는 폴더**
     - 검색 위치: **Finder.app**
     - 이미지: 원하는 아이콘 선택 (기본값 사용 가능)
     - 색상: 원하는 색상 선택 (기본값 사용 가능)

4. **액션 추가**
   - 왼쪽 검색창에서 "셸 스크립트 실행" 검색
   - "Run Shell Script" 또는 "셸 스크립트 실행"을 더블클릭하여 추가

5. **스크립트 설정**
   - 셸: `/bin/bash`
   - 전달 방법: **인수로(as arguments)**
   - 스크립트 내용을 다음으로 교체:
     ```bash
     /Users/gon/_ai/goodlink_with_file/add-to-goodlinks.sh "$@"
     ```

6. **저장**
   - `Cmd + S` 또는 파일 > 저장
   - 이름: **"Add to GoodLinks"** (또는 원하는 이름)
   - 저장 위치는 자동으로 `~/Library/Services/`로 설정됨

### 2단계: Quick Action 활성화 확인

1. **시스템 설정** 열기
2. **개인 정보 보호 및 보안** > **확장 프로그램** > **Finder 확장**
3. 방금 만든 Quick Action이 활성화되어 있는지 확인

## 사용 방법

1. Finder에서 .webloc 파일 선택 (여러 개 선택 가능)
2. 마우스 오른쪽 클릭
3. **빠른 동작(Quick Actions)** > **"Add to GoodLinks"** 선택
4. 결과 팝업 확인

## 결과 예시

성공 시:
```
GoodLinks Import Complete

Total files: 5
✅ Successfully added: 5
❌ Failed: 0
```

일부 실패 시:
```
GoodLinks Import Complete

Total files: 5
✅ Successfully added: 3
❌ Failed: 2

Failed files:
- invalid.webloc: Could not extract URL
- test.txt: Not a .webloc file
```

## 문제 해결

### Quick Action이 나타나지 않는 경우

1. Finder를 재시작: `Option + 마우스 오른쪽 클릭`으로 Finder를 강제 종료 후 재실행
2. 시스템 재시작
3. 시스템 설정에서 Finder 확장 프로그램 확인

### GoodLinks가 열리지 않는 경우

- GoodLinks 앱이 설치되어 있는지 확인
- GoodLinks 앱을 한 번 실행하여 URL Scheme 등록 확인

### 권한 오류가 발생하는 경우

스크립트 실행 권한 확인:
```bash
chmod +x /Users/gon/_ai/goodlink_with_file/add-to-goodlinks.sh
```

## 기술 정보

- .webloc 파일에서 URL을 추출하기 위해 `PlistBuddy` 사용
- GoodLinks URL Scheme: `goodlinks://x-callback-url/add?url=ENCODED_URL`
- URL 인코딩에 Python3 사용
- 결과 표시에 `osascript` (AppleScript) 사용

## 라이선스

MIT License
