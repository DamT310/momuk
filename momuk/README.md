# 다음쌤의 모먹교실

React + Vite + Tailwind CSS + Lucide React로 만든 반응형 도덕 수업 아카이브입니다.

## 실행

Node.js 20.19 이상에서 다음 명령을 실행하세요.

```sh
npm install
npm run dev
```

배포용 빌드: `npm run build` / 빌드 미리보기: `npm run preview`

## 기능

- 4개 단원, 8개 예시 학습 활동과 생각 남기기
- 1학년 4개 반, 2·3학년 각 3개 반 필터와 결과물 검색
- 글·이미지(2MB 이하)·HTTP/HTTPS 링크 등록
- 결과물과 좋아요를 LocalStorage에 저장
- 모달 키보드 이동, Escape 닫기, 모바일 반응형 레이아웃

학생 결과물은 현재 브라우저에만 저장됩니다. 다른 기기나 학생 사이에 공유되지 않습니다. 실제 외부 수업 웹앱 URL은 제공되지 않아 내부 체험으로 구현했습니다. 단원 예시 데이터는 `src/main.jsx`의 `units`에 있습니다.
