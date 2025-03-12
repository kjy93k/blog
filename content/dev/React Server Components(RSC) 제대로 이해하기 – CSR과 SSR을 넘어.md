Next.js 15에서는 **React Server Components(RSC)**를 기본적으로 사용하도록 설계되었다.

이는 기존의 **CSR(Client-Side Rendering), SSR(Server-Side Rendering)과는 완전히 다른 렌더링 방식**이며,

Next.js가 **서버와 클라이언트를 자연스럽게 연결하는 풀스택 프레임워크로 발전**할 수 있게 해준다.

  

그렇다면 **React Server Components란 무엇이며, 기존 CSR/SSR과 어떻게 다를까?**

이 글에서는 **RSC의 개념, 동작 방식, 기존 방식과의 차이, 그리고 실무에서 어떻게 활용해야 하는지**를 정리한다.

---

**1. React Server Components(RSC)란?**

  

**📌 기존 CSR(클라이언트 사이드 렌더링) 방식**

  

기존 CSR 방식에서는 **React가 클라이언트에서 실행되며, 모든 UI를 브라우저에서 렌더링**했다.
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

• 빠른 인터랙션 지원 (클라이언트에서 즉시 업데이트 가능)

• 동적인 상태 관리 가능 (useState, useEffect 활용)

  

❌ **단점**

• **초기 로딩 속도가 느려짐** (데이터를 클라이언트에서 가져와야 함)

• **SEO 최적화가 어려움** (초기 로딩 시 HTML이 거의 비어 있음)

• **API 요청이 많아질수록 성능 저하**

---

**📌 기존 SSR(서버 사이드 렌더링) 방식**

  

SSR은 **서버에서 HTML을 생성한 후 클라이언트로 전달하는 방식**이다.

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

• **SEO 최적화에 유리** (서버에서 HTML을 미리 생성)

• **초기 로딩 속도가 빠름** (클라이언트에서 추가 API 요청 없이 렌더링 가능)

  

❌ **단점**

• **매 요청마다 서버에서 페이지를 다시 생성해야 함**

• **서버 부하가 증가할 수 있음**

---

**📌 React Server Components(RSC) 방식**

  

RSC는 **서버에서 실행되는 React 컴포넌트로, 클라이언트에서 불필요한 JavaScript를 최소화**하는 방식이다.

```
export default async function Page() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return <div>{data.title}</div>;
}
```

✅ **장점**

• **클라이언트에서 불필요한 JS 번들 제거 → 성능 최적화**

• **API 요청을 서버에서 처리하여 클라이언트 부하 감소**

• **SEO 최적화 가능 (서버에서 HTML 생성 후 전달)**

  

❌ **단점**

• **클라이언트에서 상태(useState, useEffect)를 직접 관리할 수 없음**

• **클라이언트와 서버 컴포넌트를 구분해야 함**

---

**2. React Server Components(RSC) vs CSR vs SSR – 차이점 정리**

| |**CSR**|**SSR**|**RSC (Next.js 15)**|
|---|---|---|---|
|**렌더링 위치**|클라이언트에서 렌더링|서버에서 렌더링 후 HTML 반환|서버에서 렌더링 후 클라이언트로 전송|
|**초기 로딩 속도**|느림 (데이터 패칭 후 렌더링)|빠름 (서버에서 HTML 미리 생성)|빠름 (서버에서 데이터를 포함한 HTML 제공)|
|**SEO 최적화**|어려움 (초기 HTML이 비어 있음)|가능 (완전한 HTML 제공)|가능 (서버에서 HTML 생성)|
|**클라이언트 JS 번들 크기**|큼|중간|작음 (서버에서 필요한 것만 전송)|
RSC의 핵심은 **서버에서 실행할 수 있는 컴포넌트와 클라이언트에서 실행해야 하는 컴포넌트를 구분하여 최적화하는 것**이다.

---

**3. Server Component와 Client Component 구분하기**

  

**📌 기본적으로 모든 컴포넌트는 Server Component이다.**

  

App Router에서는 **기본적으로 모든 컴포넌트가 서버에서 실행된다.**

따라서, useState, useEffect 같은 훅을 사용할 수 없다.

```
export default async function Page() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return <div>{data.title}</div>;
}
```

✅ **서버에서 데이터를 가져와 렌더링 → 클라이언트에서 API 요청 필요 없음**

---

**📌 Client Component가 필요한 경우 ("use client")**

  

useState, useEffect 같은 클라이언트 기능을 사용하려면 "use client"를 명시해야 한다.

```
"use client";

import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);

  return <button onClick={() => setCount(count + 1)}>Count: {count}</button>;
}
```

✅ **클라이언트에서 실행해야 하는 경우 "use client"를 추가해야 한다.**

---

**4. 실무에서 React Server Components(RSC)를 활용하는 방법**

  

✅ **서버에서 데이터를 가져올 수 있는 경우 → RSC를 활용하여 서버에서 패칭**

✅ **사용자 인터랙션이 필요한 경우 → Client Component에서 관리**

✅ **동적인 데이터 업데이트가 필요한 경우 → React Query와 결합해서 사용**

---

**5. 결론 – React Server Components(RSC)를 선택해야 할까?**

  

✔ **새로운 Next.js 프로젝트를 시작한다면 RSC를 활용하는 것이 유리하다.**

✔ **클라이언트 JS 번들을 줄이고 서버 렌더링을 최적화할 수 있다.**

✔ **하지만 모든 컴포넌트가 RSC로 대체될 수는 없으며, Client Component와 함께 사용해야 한다.**

  

결국 **React Server Components는 기존 CSR/SSR 방식과 경쟁하는 것이 아니라, 이를 보완하는 방식으로 활용하는 것이 중요하다.**