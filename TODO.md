# 📋 할 일 목록: Custom Desktop Icons 프로젝트

> **프로젝트 상태**: 기본 템플릿 구조 완성 ✅  
> **마지막 업데이트**: 2025-06-16  
> **현재 커밋**: `b9ad5ff` - init: create project template structure

## 🎯 프로젝트 개요

**목표**: Steam 연동에 최적화된 현대적이고 크로스 플랫폼 데스크톱 아이콘 관리 앱 구축 (Decent Icons2의 후속작, Steam 출시 예정)

**기술 스택**: React 19 + TypeScript + Electron 36 + Vite 6 + npm

---

## ✅ 완료된 작업

### 1. **개발 환경 설정** (2025-06-16)
- [x] React 19 + TypeScript + Vite + Electron 36 구성
- [x] npm 패키지 매니저 설정 (pnpm에서 전환, Electron 호환성 문제로 인해)
- [x] 핫 리로드가 포함된 개발 스크립트 (`npm run dev`)
- [x] 빌드 시스템 구성 (`npm run build`)
- [x] TypeScript strict 모드 설정

### 2. **프로젝트 구조** (2025-06-16)
- [x] 깔끔한 프로젝트 디렉토리 구조
- [x] `electron/`과 `src/` 디렉토리 분리
- [x] 적절한 `tsconfig.json` 설정
- [x] Electron + React 프로젝트용 `.gitignore` 설정
- [x] Vite용으로 `index.html`을 루트 디렉토리로 이동

### 3. **핵심 컴포넌트** (2025-06-16)
- [x] Electron 메인 프로세스 (`electron/main.ts`)
- [x] Electron preload 스크립트 (`electron/preload.ts`)
- [x] TypeScript 타입이 적용된 React App 컴포넌트
- [x] 애니메이션과 글래스모피즘 효과가 포함된 현대적인 CSS
- [x] 반응형 디자인 및 접근성 기능 (ARIA)

### 4. **성능 최적화** (2025-06-16)
- [x] 컴포넌트 최적화를 위한 React.memo
- [x] 데이터 메모이제이션을 위한 useMemo
- [x] 유지보수성 향상을 위한 컴포넌트 분리
- [x] TypeScript 인터페이스 및 타입 안전성

### 5. **문서화** (2025-06-16)
- [x] 프로젝트 정보가 포함된 기본 README.md
- [x] Git 저장소 초기화
- [x] 상세한 커밋 메시지와 함께 첫 번째 커밋
- [x] 프로젝트 정리 (불필요한 파일 제거)

---

## 🚀 다음 단계 (우선순위별)

### **1단계: 개발 환경 완성**

#### 1. **코드 품질 도구** (높은 우선순위)
- [ ] ESLint 설정
  - [ ] `@typescript-eslint/parser`와 `@typescript-eslint/eslint-plugin` 설치
  - [ ] React + TypeScript용 규칙 설정
  - [ ] Electron 전용 린팅 규칙 추가
- [ ] Prettier 설정
  - [ ] Prettier 설치 및 설정
  - [ ] 일관된 포맷팅 규칙으로 `.prettierrc` 추가
  - [ ] VS Code 통합 설정
- [ ] EditorConfig 설정
  - [ ] 일관된 코딩 스타일을 위한 `.editorconfig` 생성
- [ ] Husky + lint-staged (선택사항)
  - [ ] 코드 품질을 위한 pre-commit 훅

#### 2. **README 문서 개선** (중간 우선순위)
- [ ] 완전한 프로젝트 설명 및 목표
- [ ] 상세한 기능 명세 추가
- [ ] 스크린샷/목업 포함 (UI 준비되면)
- [ ] 기여 가이드라인 추가
- [ ] 로드맵 및 마일스톤 포함
- [ ] 배지 시스템 추가 (빌드 상태, 버전 등)

#### 3. **개발 워크플로우** (중간 우선순위)
- [ ] 테스팅 프레임워크 추가 (Jest + React Testing Library)
- [ ] Electron + React 디버깅 설정
- [ ] 개발용 로깅 시스템 추가
- [ ] 컴포넌트 문서화 생성

### **2단계: 핵심 애플리케이션 기능**

#### 4. **UI/UX 기반** (높은 우선순위)
- [ ] 디자인 시스템 설정 (색상, 타이포그래피, 간격)
- [ ] 컴포넌트 라이브러리 구조
- [ ] 네비게이션/라우팅 시스템 (필요시)
- [ ] 로딩 상태 및 에러 바운더리
- [ ] 테마 시스템 (라이트/다크 모드)

#### 5. **Steam 연동 연구** (높은 우선순위)
- [ ] Steam API 기능 연구
- [ ] Steam 게임 아이콘 위치 조사
- [ ] Steam 라이브러리 연동 방법 계획
- [ ] 아이콘 관리 데이터 구조 설계

#### 6. **핵심 아이콘 관리 기능** (중간 우선순위)
- [ ] 아이콘 발견을 위한 파일 시스템 연동
- [ ] 아이콘 미리보기 및 썸네일 생성
- [ ] 아이콘 분류 시스템
- [ ] 검색 및 필터 기능
- [ ] 아이콘 백업 및 복원 기능

### **3단계: 고급 기능**

#### 7. **크로스 플랫폼 지원** (중간 우선순위)
- [ ] Windows 전용 기능
- [ ] macOS 지원 테스트
- [ ] Linux 호환성
- [ ] 플랫폼별 아이콘 처리

#### 8. **애플리케이션 패키징** (낮은 우선순위)
- [ ] Electron Builder 설정
- [ ] 코드 서명 설정
- [ ] 자동 업데이터 구현
- [ ] Steam 배포 준비

---

## 🔧 기술적 결정사항

### **패키지 매니저**: npm (pnpm 아님)
- **이유**: pnpm의 하드 링크 시스템이 Electron 바이너리 문제 발생
- **해결책**: 더 나은 Electron 호환성을 위해 npm으로 전환

### **빌드 시스템**: Vite (Webpack 아님)
- **이유**: 더 빠른 개발 경험과 현대적인 도구
- **장점**: 핫 리로드, TypeScript 지원, 최적화된 빌드

### **TypeScript 설정**: Strict 모드 활성화
- **장점**: 더 나은 타입 안전성과 코드 품질
- **설정**: React JSX 변환, ES2020 타겟

---

## 💡 개발 노트

### **주요 명령어**
```bash
# 개발 (React + Electron, 핫 리로드 포함)
npm run dev

# 전체 프로젝트 빌드
npm run build

# 컴포넌트별 빌드
npm run build:vite    # React 앱
npm run build:electron # Electron 메인 프로세스
```

### **프로젝트 구조**
```
custom_desktop/
├── electron/          # Electron 메인 프로세스
├── src/               # React 애플리케이션
├── index.html         # HTML 템플릿
├── package.json       # 의존성 및 스크립트
├── tsconfig.json      # TypeScript 설정
└── vite.config.ts     # Vite 설정
```

### **모니터링해야 할 중요한 파일들**
- `package.json` - 의존성 및 스크립트
- `electron/main.ts` - Electron 메인 프로세스
- `src/App.tsx` - 메인 React 컴포넌트
- `vite.config.ts` - 빌드 설정

---

## 🏠 집에서 작업 이어가기

### **빠른 시작 명령어**
```bash
# 집에서 프로젝트를 열 때:
cd custom_desktop
npm install          # 의존성 설치
npm run dev         # 개발 서버 시작
```

### **코파일럿용 컨텍스트**
```
"Steam 연동이 포함된 아이콘 관리용 React + TypeScript + Electron 데스크톱 앱 프로젝트입니다. 
현재 진행 상황과 다음 단계는 TODO.md를 확인해주세요. 
기본 템플릿이 완성되어 git에 커밋되었습니다."
```

### **즉시 해야 할 다음 작업**
**ESLint + Prettier 설정**으로 코드 품질을 먼저 확보한 후, README 문서를 개선하세요.

---

## 📚 참고 자료

- [Electron 문서](https://www.electronjs.org/docs)
- [React 19 문서](https://react.dev)
- [Vite 문서](https://vitejs.dev)
- [TypeScript 핸드북](https://www.typescriptlang.org/docs)
- [Steam API 문서](https://partner.steamgames.com/doc/webapi_overview)

---

*이 TODO는 기본 프로젝트 템플릿 구조 완성 후 생성되었습니다. 진행 상황에 따라 이 파일을 업데이트하세요.*
