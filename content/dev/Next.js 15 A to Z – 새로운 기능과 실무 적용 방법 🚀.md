Next.js 15가 나왔다! 🎉

이제 우리가 할 일은? **“뭐가 바뀌었고, 실무에서 어떻게 써야 하는지”** 제대로 이해하는 것!

  

이번 버전에서는 **App Router** 중심으로 많은 변화가 있었고,

특히 **React Server Components(RSC), Server Actions, 새로운 데이터 패칭 방식** 등

이전과는 **완전히 다른 패러다임**을 가져왔다.

  

그럼, 하나씩 알아보자! 🕵️‍♂️

---

## **1. Next.js 15에서 바뀐 핵심 개념**

  

✅ **App Router가 중심이 된다**

✅ **React Server Components(RSC) 기본 활성화**

✅ **Server Actions 도입 (API 없이 서버에서 실행 가능)**

✅ **데이터 패칭 방식 변화 – fetch(), React Query, Server Actions 선택이 중요해짐**

✅ **Turbopack이 더욱 안정화됨 (Webpack보다 빠름!)**

  

즉, **Next.js 15는 App Router + Server Actions + RSC 중심으로 재편되었다**는 것!

이제 하나씩 자세히 살펴보자. 👀

---

## **2. App Router vs Page Router – 이제 App Router로 가야 할까?**

  

Next.js 15에서는 **App Router를 중심으로 한 기능들이 강화**되었고,

이제 Page Router(pages/)는 **유지보수 모드**에 들어갔다.

  

**🔹 Page Router vs App Router 비교**

| |**Page Router (기존)**|**App Router (Next.js 15)**|
|---|---|---|
|**폴더 구조**|/pages/ 사용|/app/ 사용|
|**렌더링 방식**|CSR, SSR, SSG|React Server Components(RSC) 기본 적용|
|**데이터 패칭**|getServerSideProps, getStaticProps|fetch(), Server Actions 사용 가능|
|**API 요청 방식**|/pages/api/... API Routes|/app/api/... Route Handlers|
💡 **결론:** 앞으로는 **App Router가 Next.js의 기본 방향**이므로, **새 프로젝트는 App Router로 가는 게 맞다!**

하지만 기존 프로젝트라면 **굳이 Page Router를 App Router로 강제 마이그레이션할 필요는 없다.**

---

**3. React Server Components(RSC) – CSR, SSR을 넘어서는 새로운 렌더링 방식**

  

Next.js 15에서는 **React Server Components(RSC)가 기본 활성화**되었다.

즉, **이제 기본적으로 모든 컴포넌트가 서버에서 실행된다는 것!** 😲

  

**🔹 RSC와 기존 CSR/SSR의 차이점**

| |**CSR (Client-Side Rendering)**|**SSR (Server-Side Rendering)**|**RSC (React Server Components)**|
|---|---|---|---|
|**렌더링 위치**|클라이언트에서 렌더링|서버에서 HTML을 생성|서버에서 React 컴포넌트를 실행|
|**데이터 요청 방식**|클라이언트에서 fetch()|서버에서 fetch() 후 HTML 반환|서버에서 fetch() 후 React 트리 반환|
|**SEO 최적화**|❌ 불리함|✅ 가능|✅ 가능|
|**클라이언트 JS 번들 크기**|🚨 크다|🚨 크다|✅ 줄어듦|
💡 **즉, RSC 덕분에 클라이언트에서 불필요한 JS 번들을 줄이고, SEO 최적화도 가능해졌다!**

하지만 **클라이언트 인터랙션이 많은 컴포넌트는 use client를 명시해야 한다.**
```
"use client"; // 명시적으로 CSR 적용

import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);
  
  return (
    <button onClick={() => setCount(count + 1)}>
      Clicked {count} times
    </button>
  );
}
```

**✅ 핵심:** **서버에서 렌더링할 수 있는 건 RSC로 하고, 클라이언트에서만 필요한 기능만 use client로 선언!**

---

**4. Next.js 15에서 데이터 패칭 – fetch(), React Query, Server Actions 비교**

  

Next.js 15에서는 데이터 패칭 방식이 확 바뀌었다.

이제 **“언제 fetch()를 쓰고, 언제 React Query를 쓰고, 언제 Server Actions를 써야 할까?”**

  

**🔹 데이터 패칭 방식 비교**

| |**fetch()**|**React Query**|**Server Actions**|
|---|---|---|---|
|**사용 위치**|서버 컴포넌트(RSC)|클라이언트 컴포넌트|서버에서 직접 실행|
|**캐싱 지원**|✅ 기본 제공|✅ 자동 캐싱|❌ 없음|
|**데이터 변경(POST, PUT, DELETE)**|✅ 가능|✅ 가능|✅ 가능 (API 없이 서버에서 실행)|
|**SEO 최적화**|✅ 가능|❌ 불가능 (CSR 방식)|❌ 불가능|
**✅ 데이터 조회(GET 요청)** → fetch()

**✅ 클라이언트에서 상태 기반 데이터 패칭** → React Query

**✅ 서버에서 직접 실행해야 하는 데이터 조작 (POST, DELETE 등)** → Server Actions
```
// 서버에서 fetch() 사용 (Next.js 15 권장 방식)
export default async function Page() {
  const res = await fetch("https://api.example.com/data", { cache: "force-cache" });
  const data = await res.json();
  
  return <div>{data.title}</div>;
}
```

```
// 클라이언트에서 React Query 사용
import { useQuery } from "@tanstack/react-query";

const fetchPosts = async () => {
  const res = await fetch("/api/posts");
  return res.json();
};

export default function Posts() {
  const { data, isLoading } = useQuery(["posts"], fetchPosts);

  if (isLoading) return <p>Loading...</p>;

  return (
    <ul>
      {data.map((post) => (
        <li key={post.id}>{post.title}</li>
      ))}
    </ul>
  );
}
```

✅ **즉, Next.js 15에서는 데이터 패칭 방식도 상황에 따라 다르게 사용해야 한다!**

---

**🚀 결론 – Next.js 15에서 달라진 핵심 개념들**
  

✔ **Page Router → App Router 중심으로 전환**

✔ **React Server Components(RSC) 기본 활성화 → 클라이언트에서 불필요한 JS 제거 가능**

✔ **Server Actions 도입 → API 없이 서버에서 직접 데이터 수정 가능**

✔ **데이터 패칭 방식 변화 → fetch() / React Query / Server Actions를 상황에 맞게 선택해야 함**

---

**✅ 최종 정리 – “Next.js 15, 어떻게 사용해야 할까?”**

  

✅ **“서버에서 렌더링하고 싶다”** → **App Router + React Server Components(RSC)**

✅ **“데이터를 가져오고 싶다”** → **서버에서는 fetch(), 클라이언트에서는 React Query**

✅ **“API 없이 서버에서 데이터를 수정하고 싶다”** → **Server Actions**