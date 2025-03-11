Next.js는 13버전부터 **App Router**를 도입하며 기존의 **Page Router** 방식에서 점진적으로 변화하고 있다.

App Router는 **React Server Components(RSC), Server Actions, Streaming 등 다양한 기능**을 제공하며,

Next.js 공식 문서에서도 **App Router를 기본 방식으로 추천**하고 있다.

  

그러나 Page Router도 여전히 지원되며,

모든 프로젝트에서 반드시 App Router로 전환해야 하는 것은 아니다.

이 글에서는 **Page Router와 App Router의 차이, 그리고 실무에서 고려해야 할 점**을 분석한다.

---

**1. Page Router – 기존 Next.js의 파일 기반 라우팅 방식**

  

Page Router는 Next.js가 처음부터 제공하던 방식으로,

**pages/ 디렉터리를 기반으로 파일이 라우트가 되는 구조**다.

  

**Page Router 디렉터리 구조 예시**
```
/pages
  ├── index.tsx  # '/'
  ├── about.tsx  # '/about'
  ├── blog
  │   ├── index.tsx  # '/blog'
  │   ├── [id].tsx  # '/blog/:id'
```

위와 같이 파일을 생성하면, 자동으로 해당 파일이 URL에 매핑된다.

  

**Page Router의 주요 특징**

• **파일 기반 라우팅** → 파일 및 폴더 구조만 보면 라우팅을 직관적으로 이해할 수 있다.

• **기존 React 방식과 유사한 라우팅 방식** → React에서 사용하던 CSR 방식과 크게 다르지 않음.

• **데이터 패칭을 위한 getServerSideProps, getStaticProps 지원** → API 호출 방식이 명확하게 정해져 있음.

• **커스텀 서버 (Express 등)와의 연동이 가능** → next.config.js에서 API 라우트를 설정하는 방식 사용.

---

**2. App Router – React Server Components 기반의 새로운 방식**

  

App Router는 Next.js 13부터 도입된 방식으로,

**기존의 Page Router와 다르게 React Server Components(RSC)를 기본으로 활용**한다.

  

**App Router 디렉터리 구조 예시**
```
/app
  ├── layout.tsx  # 전체 레이아웃
  ├── page.tsx  # '/'
  ├── about
  │   ├── page.tsx  # '/about'
  │   ├── layout.tsx  # '/about' 페이지의 레이아웃
  ├── blog
  │   ├── page.tsx  # '/blog'
  │   ├── [id]
  │   │   ├── page.tsx  # '/blog/:id'
```

App Router에서는 page.tsx가 각각의 라우트가 된다.

layout.tsx를 활용해 특정 페이지에 대한 레이아웃을 따로 관리할 수도 있다.

  

**App Router의 주요 특징**

• **React Server Components(RSC)를 기본으로 지원** → 클라이언트 번들 크기를 줄일 수 있음.

• **서버에서 데이터를 직접 가져와 렌더링 가능** → API 라우트를 직접 호출할 필요 없이 서버에서 fetch() 실행 가능.

• **Server Actions 기능 지원** → API 요청 없이 서버에서 직접 데이터를 처리할 수 있음.

• **Streaming 및 Suspense 지원** → 초기 페이지 로드 속도를 최적화할 수 있음.

---

**3. Page Router vs App Router – 핵심 차이점**

| |**Page Router**|**App Router**|
|---|---|---|
|**디렉터리 구조**|/pages/ 디렉터리 사용|/app/ 디렉터리 사용|
|**라우팅 방식**|파일 기반 라우팅|파일 기반 라우팅 + 서버 컴포넌트 지원|
|**동적 라우팅**|[id].tsx → /blog/:id|[id]/page.tsx → /blog/:id|
|**데이터 패칭 방식**|getServerSideProps, getStaticProps 사용|fetch()를 서버에서 직접 호출|
|**서버와 클라이언트 분리**|명확하지 않음|Server Component와 Client Component 명확하게 구분|
|**렌더링 방식**|기본적으로 CSR, SSR, SSG 지원|Server Component를 활용한 최적화 가능|
|**API 요청 방식**|클라이언트에서 fetch() 사용|서버에서 fetch() 직접 실행 가능|
|**SEO 최적화**|가능하지만 SSR을 활용해야 함|기본적으로 SEO 최적화에 유리|
App Router는 **서버와 클라이언트를 명확하게 분리하고, 서버에서 데이터를 직접 가져올 수 있다는 점이 가장 큰 차이점**이다.

---

**4. Server Component와 Client Component의 차이**

  

App Router에서 가장 중요한 개념은 **Server Component와 Client Component의 구분**이다.

  

**Server Component (기본값)**

• 기본적으로 모든 컴포넌트는 **서버에서 실행**됨.

• 클라이언트에 불필요한 JavaScript 번들이 전달되지 않아 최적화 가능.

• 서버에서 fetch()를 실행해 데이터를 가져올 수 있음.

• 예제:
```
export default async function Page() {
  const res = await fetch('https://api.example.com/data');
  const data = await res.json();

  return <div>{data.title}</div>;
}
```

→ API 요청을 서버에서 실행하므로 클라이언트에서 추가적인 데이터 요청이 필요 없음.

  

**Client Component ("use client" 추가 필요)**

• useState, useEffect 등 클라이언트 사이드 상태 관리가 필요한 경우 사용.

• Server Component 내부에서 Client Component를 포함할 수 있음.

• 예제:
```
"use client";

import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);
  
  return <button onClick={() => setCount(count + 1)}>Count: {count}</button>;
}
```