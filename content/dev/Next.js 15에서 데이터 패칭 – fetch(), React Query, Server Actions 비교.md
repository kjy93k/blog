---
tags:
  - NextJS15
  - DataFetching
  - fetch
  - ReactQuery
  - ServerActions
  - AppRouter
  - CSR
  - SSR
  - 웹개발
---
Next.js 15에서는 **App Router의 도입으로 데이터 패칭 방식이 여러 가지로 나뉘게 되었다.**

기존 Page Router에서는 getServerSideProps, getStaticProps, getInitialProps를 사용했지만,

App Router에서는 **Server Component, Client Component, Server Actions 등의 개념이 도입되면서 데이터 패칭 방식이 더욱 유연해졌다.**

  

**📌 App Router에서의 데이터 패칭 변화**

1. **서버에서 직접 데이터를 가져올 수 있는 Server Component (fetch() 사용)**

2. **클라이언트 상태 관리 및 비동기 요청을 위한 React Query**

3. **API 없이 서버에서 데이터를 수정할 수 있는 Server Actions**

4. **Next.js의 자동 캐싱과 Request Deduplication 활용 (동일한 요청은 한 번만 실행됨)**

  

즉, **App Router에서는 같은 데이터 요청이 여러 곳에서 실행되더라도 Next.js가 이를 감지하여 중복 요청을 방지한다.**

이 기능을 **Request Deduplication(요청 중복 제거)**이라고 하며,

Next.js가 같은 API 요청을 한 번만 실행한 후, 모든 컴포넌트가 해당 데이터를 공유하도록 최적화한다.

  

또한, **Next.js의 자동 캐싱(Cache)은 GET 요청만을 대상으로 하며,**

**React 컴포넌트 트리 내에서 실행된 fetch() 요청만 캐싱 및 메모이제이션이 적용된다.**

즉, **라우트 핸들러 (app/api/.../route.ts)에서 실행된 fetch() 요청은 캐싱되지 않는다.**

  

그렇다면 **각각의 방식이 어떤 역할을 하고, 언제 사용해야 하는지** 비교해보자.

---

## **1. Next.js 15에서 데이터 패칭 방식 총정리**

| |**Server Component (서버에서 실행)**|**Client Component (클라이언트에서 실행)**|
|---|---|---|
|**fetch() 사용**|✅ 가능 (fetch()를 직접 실행)|❌ 불가능 (useEffect에서 fetch() 사용해야 함)|
|**React Query 사용**|❌ 불필요 (서버에서 직접 패칭 가능)|✅ 가능 (클라이언트에서 상태 기반 데이터 요청 가능)|
|**Server Actions 사용**|✅ 가능 (서버에서 직접 데이터 수정)|✅ 가능 (클라이언트에서 서버 액션 실행)|
  
---

## **2. fetch()를 활용한 서버 데이터 패칭 (Server Component에서 실행)**

  

Server Component에서는 **fetch()를 직접 호출할 수 있기 때문에,**

**기존 SSR 방식보다 더 직관적으로 서버에서 데이터를 가져올 수 있다.**

  

**📌 Server Component에서 fetch() 사용 예제**
```
export default async function Page() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return <div>{data.title}</div>;
}
```

✅ **장점**

• 클라이언트에서 API 요청을 하지 않아도 됨 (불필요한 네트워크 요청 감소)

• SEO 최적화가 가능 (서버에서 데이터를 가져온 후 HTML을 렌더링)

• **Request Deduplication이 적용되어 동일한 요청이 여러 곳에서 호출되더라도 한 번만 실행됨**

  

❌ **단점**

• **사용자 상호작용으로 데이터를 변경해야 하는 경우에는 적절하지 않음**

• **실시간 데이터 업데이트에는 적합하지 않음**

---

## **3. Next.js fetch()와 React Query 캐싱 비교**

| |**Next.js fetch() 캐싱**|**React Query 캐싱**|
|---|---|---|
|**캐싱 위치**|서버 (Server Component에서 캐싱)|클라이언트 (브라우저 메모리에서 캐싱)|
|**캐싱 적용 대상**|GET 요청만 캐싱 가능|모든 요청 가능 (GET, POST 포함)|
|**자동 요청 중복 제거**|✅ 가능 (Request Deduplication 적용)|✅ 가능 (React Query 캐싱 및 동기화)|
|**데이터 갱신 방식**|cache: "no-store", revalidate 등으로 제어|staleTime, cacheTime, refetchOnWindowFocus 등으로 제어|
|**SEO 최적화**|✅ 가능 (서버에서 데이터를 가져오므로 SEO에 유리)|❌ 어려움 (클라이언트에서 데이터를 가져오기 때문에 SEO가 불리함)|
|**사용 사례**|초기 데이터를 서버에서 가져와야 할 때|사용자의 상호작용에 따라 데이터를 가져와야 할 때|
  

---

## **4. React Query를 활용한 클라이언트 사이드 데이터 패칭**

  

React Query는 **클라이언트에서 데이터를 가져오고 관리하는 라이브러리**로,

서버에서 데이터를 가져오는 것뿐만 아니라 **클라이언트에서 캐싱하고, 필요할 때만 갱신하는 기능**을 제공한다.

  

**📌 React Query 기본 사용 예제**
```
"use client";

import { useQuery } from "@tanstack/react-query";

export default function Page() {
  const { data, isLoading } = useQuery({
    queryKey: ["data"],
    queryFn: () => fetch("https://api.example.com/data").then((res) => res.json()),
    staleTime: 5000, // 5초 동안은 데이터를 캐싱하여 사용
  });

  if (isLoading) return <div>Loading...</div>;

  return <div>{data.title}</div>;
}
```

✅ **클라이언트에서 데이터를 가져오고, 상태를 관리하며, 불필요한 요청을 방지**

✅ **데이터가 변경될 가능성이 낮으면 캐싱된 데이터를 사용하고, 일정 시간이 지나면 자동으로 새로운 데이터를 가져옴**

---

## **5. Server Actions를 활용한 데이터 수정 및 저장**

  

기존에는 데이터를 변경하려면 API 라우트를 따로 만들어야 했지만,

Next.js 15에서는 **Server Actions를 활용하면 API 없이 서버에서 데이터를 직접 수정할 수 있다.**

  

**📌 Server Actions 사용 예제**
```
"use server";

export async function createPost(title: string, content: string) {
  const res = await fetch("https://api.example.com/posts", {
    method: "POST",
    body: JSON.stringify({ title, content }),
  });

  return res.json();
}
```

✅ **장점**

• 기존 API 라우트 없이 서버에서 직접 데이터 저장 가능

• 클라이언트와 서버의 경계를 최소화하여 간결한 코드 작성 가능

  

❌ **단점**

• Server Actions는 **실험적인 기능이므로** 아직 안정적이지 않을 수 있음

• 서버에서 실행되기 때문에 **데이터 패칭보다는 데이터 수정 및 저장에 적합**

---

## **6. 결론 – Next.js 15에서 데이터 패칭은 어떻게 해야 할까?**

  

✔ **서버에서 미리 데이터를 렌더링해야 한다면 fetch()를 Server Component에서 직접 실행하는 것이 적절하다.**

✔ **사용자의 입력에 따라 데이터를 가져와야 한다면 React Query를 활용하는 것이 좋다.**

✔ **API 없이 서버에서 데이터를 수정해야 한다면 Server Actions을 활용할 수 있다.**

✔ **Request Deduplication을 활용하면 동일한 fetch() 요청이 여러 곳에서 호출되더라도 한 번만 실행되어 최적화된다.**