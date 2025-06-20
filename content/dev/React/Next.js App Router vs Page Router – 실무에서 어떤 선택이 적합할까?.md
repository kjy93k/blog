---
tags:
  - NextJS15
  - AppRouter
  - PageRouter
  - CSR
  - SSR
  - SSG
  - React
  - 웹개발
  - Frontend
date: 2025-03-12T20:50:22
---

Next.js 13부터 **App Router가 도입**되었고,

이제 Next.js 15에서는 App Router가 **기본 방식으로 권장**되고 있다.

하지만 기존의 **Page Router도 여전히 지원**되며,

실무에서는 **어떤 방식을 선택하는 것이 적절한지 고민이 필요하다.**

이 글에서는 **App Router와 Page Router의 차이점, 각 방식의 장단점, 그리고 실무에서의 선택 기준**을 정리한다.

---

## **1. Next.js App Router와 Page Router의 개념적 차이**

|                          | **Page Router (기존 방식)**                           | **App Router (새로운 방식)**                     |
| ------------------------ | ----------------------------------------------------- | ------------------------------------------------ |
| **라우팅 방식**          | pages/ 디렉터리 사용                                  | app/ 디렉터리 사용                               |
| **파일 구조**            | index.tsx, [id].tsx 같은 파일이 자동으로 URL에 매핑됨 | page.tsx, [id]/page.tsx 사용                     |
| **데이터 패칭**          | getServerSideProps, getStaticProps 사용               | 서버 컴포넌트에서 fetch() 직접 사용              |
| **서버/클라이언트 구분** | SSR, CSR 방식 혼합                                    | React Server Component(RSC) 활용하여 자동 최적화 |
| **SEO 최적화**           | SSR을 활용해 가능하지만 API 호출 필요                 | 서버에서 HTML을 직접 렌더링하여 더 유리          |
| **스타일링**             | Emotion, Styled-components 등 사용 가능               | Emotion 사용이 어려움 (SSR 관련 문제)            |
| **API 라우팅**           | pages/api/를 활용한 API 요청                          | Server Actions 활용 가능 ("use server")          |

기본적으로 **Page Router는 기존 React 방식과 유사한 CSR(클라이언트 렌더링) 중심**이고,

**App Router는 서버 중심의 렌더링 방식(RSC)으로 최적화**되었다.

---

## **2. Page Router vs App Router – 기능별 차이점 분석**

### **📌 1. 라우팅 방식**

Page Router는 **파일 기반 라우팅**이지만,

App Router는 **파일 기반 라우팅 + React Server Component(RSC)를 결합**한 방식이다.

**Page Router 예제 (pages/ 기반)**

```
// /pages/index.tsx
export default function Home() {
  return <h1>Welcome to Next.js</h1>;
}
```

이 방식에서는 **파일이 곧 URL과 연결**된다.

**App Router 예제 (app/ 기반)**

```
// /app/page.tsx
export default function Page() {
  return <h1>Welcome to App Router</h1>;
}
```

App Router에서는 page.tsx 파일이 각 경로의 루트 컴포넌트가 된다.

---

### **📌 2. 데이터 패칭 방식**

Page Router에서는 getServerSideProps, getStaticProps를 활용해 데이터를 가져왔다.

**Page Router에서 데이터 패칭 (getServerSideProps)**

```
export async function getServerSideProps() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return { props: { data } };
}

export default function Page({ data }) {
  return <div>{data.title}</div>;
}
```

이 방식에서는 서버에서 데이터를 가져와 props로 전달하지만,

**App Router에서는 getServerSideProps가 제거**되었고,

대신 **서버에서 직접 데이터를 가져오는 방식**을 사용해야 한다.

**App Router에서 데이터 패칭 (React Server Component 활용)**

```
export default async function Page() {
  const res = await fetch("https://api.example.com/data", { cache: "no-store" });
  const data = await res.json();

  return <div>{data.title}</div>;
}
```

✅ **별도의 API 호출 없이 서버에서 데이터를 직접 가져올 수 있다.**

✅ **SEO 최적화에 유리하며, 클라이언트에서 불필요한 API 요청을 줄일 수 있다.**

하지만 **모든 경우에 App Router의 데이터 패칭 방식이 더 좋은 것은 아니다.**

• **사용자가 직접 트리거하는 데이터 요청 (예: 검색, 필터, 대화형 UI)** → **React Query 같은 클라이언트 상태 관리 라이브러리가 더 적합**

• **빠른 클라이언트 렌더링이 중요한 경우** → **서버에서 가져오지 않고 클라이언트에서 데이터 요청하는 것이 더 유리할 수도 있음**

_(이 부분에 대한 상세한 내용은 별도의 React Query 관련 글에서 다룰 예정이다.)_

---

### **📌 3. 서버와 클라이언트의 역할 분리**

App Router의 가장 큰 변화 중 하나는 **Server Component와 Client Component의 명확한 구분**이다.

**서버 컴포넌트 예제 (기본값)**

```
export default async function Page() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return <div>{data.title}</div>;
}
```

✅ **서버에서 데이터를 가져와 직접 렌더링하므로, 클라이언트에서 API 요청이 필요 없음.**

**클라이언트 컴포넌트 예제 ("use client")**

```
"use client";

import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);

  return <button onClick={() => setCount(count + 1)}>Count: {count}</button>;
}
```

✅ **클라이언트에서 실행해야 하는 경우 "use client"를 명시해야 한다.**

---

### **📌 4. 스타일링 방식**

App Router에서는 기존 Page Router에서 사용하던 **Emotion, Styled-components 같은 CSS-in-JS 라이브러리 사용이 어렵다.**

(SSR 관련 문제로 인해, App Router에서는 Emotion을 추천하지 않는다.)

📌 **대체 스타일링 방법**

✅ Vanilla Extract → 정적 스타일을 빌드 타임에 생성, 성능 최적화 가능

✅ Tailwind CSS → 클래스 기반 스타일 적용, 빠른 스타일링 가능

✅ .module.scss → Next.js 기본 지원

_(Vanilla Extract의 장단점 및 사용법은 별도의 글에서 더 자세히 다룰 예정이다.)_

---

## **3. 실무에서의 선택 기준 – 언제 Page Router, 언제 App Router?**

|                                            | **Page Router**                               | **App Router**                                       |
| ------------------------------------------ | --------------------------------------------- | ---------------------------------------------------- |
| **기존 프로젝트 유지보수**                 | ✅ 유지보수 및 기존 코드 재사용이 용이        | ❌ 기존 코드와 호환되지 않음                         |
| **서버 렌더링 최적화**                     | ❌ 클라이언트에서 불필요한 API 요청 발생 가능 | ✅ 서버에서 직접 데이터 렌더링 가능                  |
| **SEO 최적화**                             | ✅ 가능하지만 getServerSideProps 필요         | ✅ 기본적으로 서버에서 HTML을 렌더링                 |
| **상태 관리 방식**                         | React Query, Redux 등 클라이언트 상태 중심    | 서버에서 데이터 패칭 후 필요한 경우 React Query 활용 |
| **스타일링**                               | ✅ Emotion, Styled-components 사용 가능       | ❌ Emotion 사용이 어려움, Vanilla Extract 등 추천    |
| **새로운 기능 적용 (PPR, Server Actions)** | ❌ 사용 불가능                                | ✅ 지원 가능                                         |

---

## **4. 결론 – 실무에서 App Router vs Page Router, 어떤 선택이 맞을까?**

✔ **기존 Page Router 프로젝트를 유지보수하는 경우 → Page Router 유지가 더 적절**

✔ **새로운 프로젝트를 시작하는 경우 → App Router를 선택하는 것이 유리**

✔ **SEO 최적화 및 서버 렌더링이 중요한 경우 → App Router가 더 적합**

✔ **스타일링 라이브러리를 Emotion으로 유지해야 하는 경우 → Page Router가 더 나을 수도 있음**

결론적으로, **Next.js 15에서는 App Router를 기본값으로 사용하지만,**

**모든 프로젝트에서 반드시 App Router를 선택해야 하는 것은 아니다.**

각 프로젝트의 **요구 사항에 맞춰 Page Router와 App Router 중 적절한 방식을 선택하는 것이 중요하다.**
