# 다음쌤의 모먹교실

React + Vite + Tailwind CSS + Lucide React로 만든 반응형 도덕 수업 아카이브입니다.

GitHub 저장소: https://github.com/DamT310/momuk

## 소스 내려받기

```sh
git clone https://github.com/DamT310/momuk.git
cd momuk
```

## 실행

Node.js 20.19 이상에서 다음 명령을 실행하세요.

```sh
npm install
npm run dev
```

배포용 빌드는 `npm run build`, 빌드 미리보기는 `npm run preview`로 실행합니다.

## 주요 기능

- 사이트 첫 진입 시 열리는 방명록과 최근 메시지
- Web Audio로 생성되는 저작권 걱정 없는 귀여운 BGM 켜기·끄기
- PPT와 학습지로 분리된 교사용 자료실
- 파일(최대 20MB) 또는 외부 링크 형태의 학습 자료 등록
- 4개 단원, 8개 예시 학습 활동과 생각 남기기
- 학년·학급 필터, 결과물 검색, 이미지·링크 등록과 좋아요
- 키보드 접근이 가능한 모달과 모바일 반응형 레이아웃

## 데이터 저장 방식

학생 결과물, 좋아요, 방명록, 자료 정보는 현재 브라우저에 저장됩니다. 첨부한 PPT와 학습지는 IndexedDB에 저장되며 다른 기기나 학생에게 자동으로 공유되지 않습니다. 학생 전체에게 배포할 자료는 외부 공개 링크로 등록해 주세요.

`.env` 파일, 설치 패키지, 빌드 결과물과 로컬 배포 설정은 저장소에서 제외됩니다.
