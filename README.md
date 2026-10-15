# 다음쌤의 모먹교실

React, Vite, Tailwind CSS, Lucide React로 만든 반응형 도덕 수업 아카이브입니다.

GitHub 저장소: https://github.com/DamT310/momuk

## 실행

Node.js 20.19 이상에서 실행하세요.

```sh
npm install
npm run dev
```

배포용 빌드는 `npm run build`, 빌드 미리보기는 `npm run preview`로 실행합니다.

## 주요 기능

- 사이트 첫 진입 시 열리는 방명록과 최근 메시지
- Web Audio로 생성되는 귀여운 BGM 켜기·끄기
- PPT와 학습지로 나뉜 교사용 학습자료실
- Supabase Storage 파일 업로드와 모든 기기에서 공유되는 자료 목록
- 이메일 매직 링크를 이용한 교사 전용 업로드·삭제
- 4개 단원, 8개 예시 학습 활동과 생각 남기기
- 학년·학급 필터, 학생 결과물 검색·이미지·링크 등록과 좋아요

## Supabase 구성

기본 프로젝트는 `momuk-classroom`에 연결되어 있습니다. 브라우저에서 사용하도록 설계된 Supabase publishable key만 소스에 포함되어 있으며, 업로드·수정·삭제 권한은 RLS로 `daamt10@gmail.com` 교사 계정에만 허용됩니다. secret key와 데이터베이스 비밀번호는 코드에 저장하지 않습니다.

다른 Supabase 프로젝트로 바꾸려면 `.env.example`을 복사해 `.env`를 만들고 값을 덮어쓰세요.

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_your_key
```

새 프로젝트에는 Supabase SQL Editor에서 `supabase/schema.sql`을 한 번 실행해야 합니다. 이 스키마는 다음 항목을 만듭니다.

- `learning_resources` 자료 메타데이터 테이블
- `learning-materials` 공개 다운로드용 Storage 버킷
- 공개 읽기 및 허용된 교사만 쓰기 가능한 RLS 정책
- 교사 이메일 허용 목록

PPT·학습지 파일은 최대 20MB까지 업로드할 수 있습니다. 수업자료실은 학생에게 공개되는 공간이므로 개인정보나 배포 권한이 없는 파일은 올리지 마세요.

학생 결과물, 좋아요, 방명록은 현재 브라우저 로컬 저장소를 사용합니다. 학습자료만 Supabase를 통해 모든 기기에서 공유됩니다.
