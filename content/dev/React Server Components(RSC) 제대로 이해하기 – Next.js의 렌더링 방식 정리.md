Next.js 15에서는 **React Server Components(RSC)**가 기본적으로 사용되며,

이는 기존의 **CSR(Client-Side Rendering), SSR(Server-Side Rendering), SSG(Static Site Generation), ISR(Incremental Static Regeneration)** 방식과 함께 사용할 수 있다.

  

즉, **App Router에서 기본적으로 RSC를 활용하지만, 필요에 따라 기존 CSR 방식도 그대로 유지할 수 있다.**

그렇다면 **RSC는 기존 CSR/SSR과 어떻게 다르고, 실무에서는 어떻게 조합해서 활용하면 좋을까?**

  

이 글에서는 **Next.js에서 제공하는 모든 렌더링 방식(CSR, SSR, SSG, ISR, RSC)을 정리하고, 실무에서 어떻게 선택해야 하는지**를 정리한다.

---

**1. Next.js에서 제공하는 렌더링 방식 총정리**

  

Next.js에서는 아래 **5가지 렌더링 방식**을 제공한다.

| |**CSR**|**SSR**|**SSG**|**ISR**|**RSC** **(App Router)**|
|---|---|---|---|---|---|
|**렌더링 위치**|클라이언트에서 실행|서버에서 실행 후 HTML 반환|빌드 시 정적 HTML 생성|일정 주기로 HTML 업데이트|서버에서 렌더링 후 클라이언트 전송|
|**초기 로딩 속도**|느림|빠름|매우 빠름|빠름 (재생성)|빠름 (서버에서 데이터 포함)|
|**데이터 패칭 시점**|클라이언트 요청 시|요청 시 서버에서 가져옴|빌드 타임에 미리 생성|빌드 후 재생성 가능|서버에서 직접 가져옴|
|**SEO 최적화**|어려움|가능|가능|가능|가능|
|**페이지 업데이트**|즉시 가능|새 요청마다 서버에서 새로 생성|빌드 시 업데이트|설정된 주기로 재생성|서버에서 동적으로 가져옴|

---

**2. 각 렌더링 방식의 개념과 코드 예제**

  

**📌 1) CSR (Client-Side Rendering, 클라이언트 사이드 렌더링)**

  

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

**📌 2) SSR (Server-Side Rendering, 서버 사이드 렌더링)**

  

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

**📌 3) SSG (Static Site Generation, 정적 사이트 생성)**

  

**빌드 타임에 미리 HTML을 생성하여 저장하는 방식.**

모든 요청은 미리 만들어진 HTML을 반환하므로 **최고의 속도를 제공한다.**