---
tags:
  - NextJS15
  - React
  - AppRouter
  - PageRouter
  - ServerActions
  - ReactServerComponents
  - Frontend
  - 웹개발
date: 2025-03-20T15:31:36+09:00
---

Next.js 15은 기존 Page Router에서 **App Router 중심의 아키텍처로 전환**하면서,

React Server Components(RSC), Server Actions, Partial Prerendering(PPR) 등의 기능을 도입했다.

이제 Next.js는 단순한 React 프레임워크를 넘어

**서버와 클라이언트를 자연스럽게 연결하는 풀스택 프레임워크**로 자리 잡았다.

그렇다면 Next.js 15에서 **어떤 변화가 있었고**,

실제 프로젝트에서는 **이걸 어떻게 적용해야 할까?**

이 글에서 **핵심 기능과 실무 적용 방법을 정리**한다.

---

## **1. Next.js 15의 주요 변화 – 뭐가 달라졌을까?**

| **기능**                          | **설명**                             | **기존 방식 (Page Router)**             | **Next.js 15 (App Router)**                                |
| --------------------------------- | ------------------------------------ | --------------------------------------- | ---------------------------------------------------------- |
| **라우팅 방식**                   | 파일 기반 라우팅                     | pages/ 디렉터리                         | app/ 디렉터리                                              |
| **데이터 패칭**                   | 서버 요청 처리 방식                  | getServerSideProps, getStaticProps 사용 | fetch()를 Server Component에서 직접 실행 가능              |
| **React Server Components (RSC)** | 서버와 클라이언트의 분리             | 클라이언트에서 데이터 요청 후 렌더링    | 서버에서 데이터를 렌더링 후 클라이언트로 전송              |
| **Partial Prerendering (PPR)**    | 정적 + 동적 조합 가능                | ISR 기반 정적 생성                      | 일부 페이지는 즉시 렌더링, 일부는 클라이언트에서 동적 로드 |
| **Server Actions**                | API 라우트 없이 서버에서 데이터 처리 | pages/api/를 활용한 API 요청            | async function을 서버에서 직접 실행 가능                   |
| **빌드 시스템**                   | Webpack & Vite                       | Turbopack 적용 (더 빠른 빌드 속도)      |                                                            |

---

## **2. App Router로의 전환 – “App Router를 써야 하는 이유가 있나요?”**

Next.js 15에서는 기본적으로 **App Router를 권장**하지만,

그렇다고 Page Router가 사라진 것은 아니다.

_“그럼 App Router를 써야 하는 이유가 있나요?”_ 라는 질문을 한다면,

대답은 **“케이스 바이 케이스”** 다.

이론적으로는 App Router가 더 나은 방식이지만, **모든 프로젝트가 무조건 App Router로 가야 하는 것은 아니다.**

### **📌 App Router의 장점 (언제 사용하면 좋을까?)**

✅ **React Server Components(RSC)를 활용해 성능 최적화가 필요할 때**

✅ **서버와 클라이언트를 명확하게 분리하고 싶을 때**

✅ **SSR(서버 사이드 렌더링)에서 API 요청을 줄이고 싶을 때**

✅ **새로운 Next.js 기능 (PPR, Server Actions 등)을 적극 활용하고 싶을 때**

### **📌 Page Router를 유지하는 것이 좋은 경우**

✅ **기존 Page Router 기반 프로젝트를 유지보수해야 할 때**

✅ **현재 App Router로 전환할 필요 없이, 기존 방식이 더 익숙한 경우**

✅ **SSG(정적 사이트 생성) 중심의 프로젝트일 때 (App Router에서는 getStaticProps가 사라짐)**

결론적으로, **새 프로젝트라면 App Router를 선택하는 것이 더 나은 선택이지만,**

**기존 Page Router 프로젝트를 당장 전환할 필요는 없다.**

---

## **3. 데이터 패칭 – Page Router vs App Router에서의 차이**

Next.js에서 데이터를 불러오는 방식은 Page Router와 App Router에서 다르게 동작한다.

### **📌 Page Router에서의 데이터 패칭**

기존 Page Router에서는 **getServerSideProps, getStaticProps를 사용해서 서버에서 데이터를 불러왔다.**

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

**Page가 로드될 때 서버에서 데이터를 가져와 props로 전달하는 방식.**

이제 Next.js 15에서는 이 방식이 **더 이상 지원되지 않는다.**

---

### **📌 App Router에서의 데이터 패칭 (React Server Components 활용)**

App Router에서는 **서버에서 직접 데이터를 가져올 수 있다.**

```
export default async function Page() {
  const res = await fetch("https://api.example.com/data", { cache: "no-store" });
  const data = await res.json();

  return <div>{data.title}</div>;
}
```

✅ **별도의 API 요청 없이 서버에서 데이터를 가져옴**

✅ **불필요한 클라이언트 사이드 데이터 요청을 줄일 수 있음**

✅ **SEO에 유리한 구조 (서버에서 HTML을 완성해서 내려줌)**

이 방식은 기존 Page Router에서 getServerSideProps를 사용하던 방식과 비슷하지만,

**페이지가 서버에서 먼저 렌더링되며, API 호출을 별도로 하지 않아도 된다는 점이 다르다.**

---

## **4. React Query – App Router에서도 필요할까?**

App Router에서 데이터를 서버에서 직접 가져올 수 있지만,

**클라이언트에서 데이터를 다룰 때 React Query는 여전히 유용하다.**

### **📌 React Query가 필요한 경우**

✅ **사용자 상호작용에 따라 데이터를 가져와야 할 때**

✅ **실시간 데이터가 필요한 경우 (예: 채팅, 알림, 대시보드 등)**

✅ **서버 컴포넌트만으로는 해결할 수 없는 경우 (클라이언트 사이드 업데이트 필요)**

```
"use client";

import { useQuery } from "@tanstack/react-query";

export default function Page() {
  const { data, isLoading } = useQuery({
    queryKey: ["data"],
    queryFn: () => fetch("https://api.example.com/data").then((res) => res.json()),
  });

  if (isLoading) return <div>Loading...</div>;

  return <div>{data.title}</div>;
}
```

이 방식은 **클라이언트에서 데이터 요청을 관리해야 할 때 여전히 필요하다.**

특히 **사용자가 데이터를 갱신해야 하는 경우**에는 React Query를 활용하는 것이 더 효율적이다.

_(React Query 사용법 및 선택 기준에 대한 자세한 내용은 별도의 글에서 다룰 예정이다.)_

---

## **5. Partial Prerendering (PPR) – SSG와 SSR의 결합**

Next.js 15에서 가장 강력한 기능 중 하나는 **Partial Prerendering (PPR)**이다.

PPR은 기존 ISR(Incremental Static Regeneration) 방식과 다르게,

**페이지의 일부는 정적으로 프리렌더링하고, 일부는 클라이언트에서 동적으로 가져올 수 있다.**

이 기능은 아직 **실험적인 기능**이므로, 실무에서 바로 적용하기에는 시간이 필요할 수도 있다.

---

## **6. 결론 – Next.js 15, 당장 전환해야 할까?**

Next.js 15는 서버 중심의 렌더링을 더욱 강화하고,

프레임워크 자체를 최적화하는 방향으로 발전하고 있다.

하지만 기존 Page Router 프로젝트에서 즉시 전환할 필요는 없다.

✔ **새로운 프로젝트라면 App Router를 선택하는 것이 유리**

✔ **기존 Page Router 프로젝트라면 점진적인 전환을 고려**

✔ **새로운 기능들이 많지만, 일부는 실험적인 상태이므로 신중한 접근이 필요**
