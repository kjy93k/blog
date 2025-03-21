---
date: 2025-03-12T21:00:24+09:00
tags:
  - NextJS15
  - ReactServerComponents
  - RSC
  - SSR
  - CSR
  - React
  - ServerSideRendering
  - Frontend
---
date: 2025-03-12T21:00:24+09:00
Next.js 15에서는 **React Server Components(RSC)**가 기본적으로 사용되며,

이는 기존의 **CSR(Client-Side Rendering), SSR(Server-Side Rendering), SSG(Static Site Generation), ISR(Incremental Static Regeneration)** 방식과 함께 사용할 수 있다.

  

기존 **SSR은 페이지 단위에서만 적용할 수 있었기 때문에 CSR과 함께 사용하기 어려웠지만,**

RSC는 **컴포넌트 단위에서 서버에서 실행될지, 클라이언트에서 실행될지를 결정할 수 있기 때문에 같은 페이지 내에서 SSR과 CSR이 공존할 수 있다.**

  

이 글에서는 **Next.js에서 제공하는 모든 렌더링 방식(CSR, SSR, SSG, ISR, RSC)을 정리하고, 실무에서 어떻게 선택해야 하는지**를 설명한다.

---
date: 2025-03-12T21:00:24+09:00
## **1. Next.js에서 제공하는 렌더링 방식 총정리**

  

Next.js에서는 아래 **5가지 렌더링 방식**을 제공한다.

| |**CSR**|**SSR**|**SSG**|**ISR**|**RSC** **(App Router)**|
|---|---|---|---|---|---|
|**렌더링 위치**|클라이언트에서 실행|서버에서 실행 후 HTML 반환|빌드 시 정적 HTML 생성|일정 주기로 HTML 업데이트|서버에서 렌더링 후 클라이언트 전송|
|**초기 로딩 속도**|느림|빠름|매우 빠름|빠름 (재생성)|빠름 (서버에서 데이터 포함)|
|**데이터 패칭 시점**|클라이언트 요청 시|요청 시 서버에서 가져옴|빌드 타임에 미리 생성|빌드 후 재생성 가능|서버에서 직접 가져옴|
|**SEO 최적화**|어려움|가능|가능|가능|가능|
|**페이지 업데이트**|즉시 가능|새 요청마다 서버에서 새로 생성|빌드 시 업데이트|설정된 주기로 재생성|서버에서 동적으로 가져옴|

---
date: 2025-03-12T21:00:24+09:00
## **2. 각 렌더링 방식의 개념과 코드 예제**

  

### **📌 1) CSR (Client-Side Rendering, 클라이언트 사이드 렌더링)**

  

**클라이언트에서 JavaScript를 실행하여 UI를 렌더링하는 방식.**

데이터는 useEffect로 가져오며, 초기 HTML은 비어 있는 상태로 전달됨.

```
import { useEffect, useState } from "react";

export default function Page() {
  const [data, setData] = useState(null);

  useEffect(() => {
    fetch("https://api.example.com/data")
      .then((res) => res.json())
      .then((data) => setData(data));
  }, []);

  return <div>{data ? data.title : "Loading..."}</div>;
}
```

✅ **장점**

• 빠른 인터랙션 가능 (사용자가 직접 데이터를 요청)

• Next.js가 아닌 일반 React 프로젝트에서도 동일한 방식 적용 가능

  

❌ **단점**

• 초기 로딩이 느림 (HTML이 비어 있어서, 데이터 패칭 후 렌더링됨)

• SEO에 불리함 (초기 HTML이 거의 비어 있음)

---
date: 2025-03-12T21:00:24+09:00
### **📌 2) SSR (Server-Side Rendering, 서버 사이드 렌더링)**

  

**서버에서 HTML을 완성한 후 클라이언트로 전달하는 방식.**

클라이언트가 요청을 보낼 때마다 **서버에서 데이터를 가져와 페이지를 렌더링**한다.

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

✅ **장점**

• SEO 최적화에 유리 (서버에서 미리 HTML 생성)

• 초기 렌더링 속도가 빠름

  

❌ **단점**

• 요청이 올 때마다 서버에서 다시 렌더링해야 하므로 서버 부하 증가

• 캐싱을 활용하지 않으면 성능 저하 가능

---
date: 2025-03-12T21:00:24+09:00
### **📌 3) SSG (Static Site Generation, 정적 사이트 생성)**

  

**빌드 타임에 미리 HTML을 생성하여 저장하는 방식.**

모든 요청은 미리 만들어진 HTML을 반환하므로 **최고의 속도를 제공한다.**

```
export async function getStaticProps() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return { props: { data } };
}

export default function Page({ data }) {
  return <div>{data.title}</div>;
}
```

✅ **장점**

• 정적 페이지라서 속도가 가장 빠름

• SEO 최적화에 유리

  

❌ **단점**

• 데이터를 업데이트하려면 페이지를 다시 빌드해야 함

---
date: 2025-03-12T21:00:24+09:00
### **📌 4) ISR (Incremental Static Regeneration, 점진적 정적 재생성)**

  

**SSG와 SSR의 중간 형태.**

빌드 시 정적 HTML을 생성하지만, 일정 주기마다 새로운 데이터를 가져와 HTML을 업데이트할 수 있다.

```
export async function getStaticProps() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return { props: { data }, revalidate: 60 }; // 60초마다 데이터 갱신
}

export default function Page({ data }) {
  return <div>{data.title}</div>;
}
```

✅ **장점**

• 정적 사이트의 속도를 유지하면서도 데이터 갱신 가능

• 서버 부하가 적음

  

❌ **단점**

• 실시간 데이터 반영이 어려울 수 있음

---
date: 2025-03-12T21:00:24+09:00
### **📌 5) RSC (React Server Components, App Router 전용)**

  

**서버에서 실행되는 React 컴포넌트로, 클라이언트에서 불필요한 JavaScript를 최소화하는 방식.**

Next.js 15에서는 **기본적으로 RSC를 사용하도록 설계**되었다.

```
export default async function Page() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return <div>{data.title}</div>;
}
```

✅ **장점**

• 클라이언트에서 불필요한 JS 번들 제거 → 성능 최적화

• API 요청을 서버에서 처리하여 클라이언트 부하 감소

• SEO 최적화 가능 (서버에서 HTML 생성 후 전달)

  

❌ **단점**

• Server Component에서는 useState, useEffect 사용 불가능

• 클라이언트 상호작용이 필요한 경우 "use client" 선언 필요

---
date: 2025-03-12T21:00:24+09:00
## **3. 기존 SSR과 RSC의 차이 – 같은 페이지에서 CSR과 SSR을 공존할 수 있음**

  

기존 SSR은 **페이지 단위에서 선언되었기 때문에 CSR과 함께 사용하기 어려웠지만**,

RSC는 **컴포넌트 단위에서 서버에서 실행될지, 클라이언트에서 실행될지를 결정할 수 있기 때문에 같은 페이지 내에서 SSR과 CSR이 공존할 수 있다.**

```
export default async function Page() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return (
    <div>
      <h1>{data.title}</h1>
      <ClientComponent />
    </div>
  );
}
```

```
"use client";

function ClientComponent() {
  return <button>클라이언트에서 동작하는 버튼</button>;
}
```

---
date: 2025-03-12T21:00:24+09:00
## **4. 결론 – Next.js에서 어떤 렌더링 방식을 선택해야 할까?**

Next.js 15에서는 **기존의 CSR, SSR, SSG, ISR 방식이 여전히 존재하지만,**

**React Server Components(RSC)를 활용하여 더 유연한 렌더링이 가능해졌다.**

  

기존 SSR 방식은 **페이지 단위에서 선언되었기 때문에 CSR과 함께 사용하기 어려웠지만**,

RSC는 **컴포넌트 단위에서 서버에서 실행될지, 클라이언트에서 실행될지를 결정할 수 있기 때문에 같은 페이지 내에서도 SSR과 CSR이 공존할 수 있다.**

  

하지만 **RSC가 무조건 더 좋은 방식은 아니며, 기존 CSR/SSR 방식이 익숙한 개발자들에게는 다소 생소할 수 있다.**

특히, **컴포넌트를 어떻게 쪼개야 할지, 클라이언트에서 필요한 상태 관리를 어떻게 할지 등 새로운 패턴을 익히는 과정이 필요하다.**

---
date: 2025-03-12T21:00:24+09:00

### **📌 렌더링 방식 선택 기준**

| |**적합한 경우**|
|---|---|
|**CSR (클라이언트 사이드 렌더링)**|빠른 인터랙션이 필요한 SPA(단일 페이지 애플리케이션)|
|**SSR (서버 사이드 렌더링)**|SEO가 중요한 페이지, 데이터가 자주 변경되는 페이지|
|**SSG (정적 사이트 생성)**|콘텐츠가 자주 변하지 않는 정적 웹사이트|
|**ISR (점진적 정적 재생성)**|SEO가 중요하면서도 정적 페이지를 주기적으로 갱신해야 하는 경우|
|**RSC (React Server Components)**|클라이언트 JS 번들을 줄이고, 서버 렌더링을 최적화하고 싶은 경우|

---
date: 2025-03-12T21:00:24+09:00

### **📌 최종 결론**

  

✔ **기존 CSR/SSR 방식이 익숙하다면, 당장 RSC로 전환할 필요는 없다.**

✔ **하지만 React가 RSC를 도입하면서, Next.js도 이를 적극적으로 활용하는 방향으로 발전하고 있다.**

✔ **새로운 프로젝트를 시작한다면 App Router와 RSC를 적극적으로 고려해볼 만하다.**

✔ **각 프로젝트의 요구 사항에 따라 가장 적절한 렌더링 방식을 선택하는 것이 중요하다.**

  

RSC는 **React가 새로운 렌더링 방식으로 제시한 개념이며, Next.js는 이를 적극적으로 도입했다.**

아직 RSC가 어색하거나 익숙하지 않다면, 기존 CSR/SSR 방식으로 개발을 이어가도 문제는 없다.

다만, **React 생태계가 점점 RSC 중심으로 변해갈 가능성이 높기 때문에,**

**한 번쯤 RSC를 적용해 보고, 기존 방식과 어떻게 다른지 직접 경험해보는 것도 좋은 선택이 될 수 있다.**