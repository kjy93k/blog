---
date: 2025-03-20T16:01:44+09:00
tags:
  - NextJS15
  - PartialPrerendering
  - PPR
  - SSG
  - SSR
  - 프리렌더링
  - React
  - 웹개발
  - Frontend
---
Next.js 15에서는 **Partial Prerendering (PPR)** 이라는 새로운 렌더링 방식이 도입되었다.

PPR은 기존의 **Static Site Generation (SSG)** 과 **Server-Side Rendering (SSR)** 의 장점을 결합하여,

“가능한 부분은 정적으로 미리 렌더링하고, 나머지는 서버에서 동적으로 제공하는 방식”을 지원한다.

  

그렇다면 **PPR이 기존 SSG, SSR과 어떻게 다른지**, 그리고 **실무에서 어떻게 활용할 수 있는지** 살펴보자.

---
date: 2025-03-20T16:01:44+09:00

**1. 기존 SSG vs SSR의 한계**

  

Next.js는 기존에 **SSG(Static Site Generation)** 또는 **SSR(Server-Side Rendering)** 중 하나를 선택해야 했다.

  

**SSG (Static Site Generation)**

• **페이지를 빌드 시점에 정적으로 생성**

• **빠른 로딩 속도 제공 (CDN 활용 가능)**

• **단점:** 실시간 데이터를 반영하기 어렵고, 업데이트가 필요한 경우 전체 페이지를 다시 빌드해야 함

```
export async function getStaticProps() {
  const data = await fetch("https://api.example.com/data").then((res) => res.json());

  return { props: { data } };
}
```
  

---

**SSR (Server-Side Rendering)**

• **페이지 요청 시마다 서버에서 데이터를 가져와 렌더링**

• **최신 데이터를 항상 반영할 수 있음**

• **단점:** 매 요청마다 서버에서 페이지를 생성해야 하므로 속도가 느려질 수 있음

```
export async function getServerSideProps() {
  const data = await fetch("https://api.example.com/data").then((res) => res.json());

  return { props: { data } };
}
```

  

---
date: 2025-03-20T16:01:44+09:00

**2. PPR(Partial Prerendering)이란?**

  

PPR은 **SSG와 SSR을 혼합하는 새로운 방식**이다.

즉, **가능한 부분은 미리 렌더링하고, 실시간 데이터가 필요한 부분만 동적으로 제공**하는 방식이다.

  

**PPR의 핵심 개념**

  

✅ **정적인 부분은 미리 생성 (SSG 방식 유지)**

✅ **동적인 데이터는 서버에서 제공 (SSR처럼 실시간 처리 가능)**

✅ **요청할 때마다 전체 페이지를 새로 생성할 필요 없음**

✅ **빠른 로딩 속도를 유지하면서도 최신 데이터 반영 가능**

---

**3. PPR 적용 방식 (App Router vs Page Router)**

  

PPR은 **App Router와 Page Router 모두에서 사용할 수 있지만, 적용 방식이 다르다.**

  

**📌 App Router에서 PPR 적용 예제**

```
export const dynamic = "auto"; // PPR 활성화

export default async function Page() {
  const staticData = await fetch("https://api.example.com/static-data", { cache: "force-cache" }).then((res) => res.json());
  const dynamicData = await fetch("https://api.example.com/dynamic-data", { cache: "no-store" }).then((res) => res.json());

  return (
    <div>
      <h1>정적 데이터: {staticData.title}</h1>
      <h2>실시간 데이터: {dynamicData.value}</h2>
    </div>
  );
}
```

**📌 코드 설명**

• staticData: cache: "force-cache" → **빌드 시 캐싱된 데이터를 반환 (정적 콘텐츠)**

• dynamicData: cache: "no-store" → **매 요청마다 새 데이터를 가져옴 (동적 콘텐츠)**

• export const dynamic = "auto"; → **PPR을 활성화하여 필요한 경우만 동적 데이터 요청**

  

💡 **이제 fetch()만으로도 PPR을 쉽게 구현할 수 있다.**

---
date: 2025-03-20T16:01:44+09:00

**📌 Page Router에서 PPR 적용 예제**

  

Page Router에서는 **초기 페이지를 SSG로 미리 렌더링한 후, 클라이언트 측에서 데이터를 가져오는 방식**을 사용해야 한다.

```
import useSWR from "swr";

const fetcher = (url) => fetch(url).then((res) => res.json());

export async function getStaticProps() {
  const staticData = await fetcher("https://api.example.com/static-data");

  return { props: { staticData } };
}

export default function Page({ staticData }) {
  const { data: dynamicData } = useSWR("/api/dynamic-data", fetcher, { refreshInterval: 5000 });

  return (
    <div>
      <h1>정적 데이터: {staticData.title}</h1>
      <h2>실시간 데이터: {dynamicData ? dynamicData.value : "불러오는 중..."}</h2>
    </div>
  );
}
```

**📌 코드 설명**

• getStaticProps() → **정적 데이터를 빌드 시점에 미리 가져옴 (SSG)**

• useSWR() → **클라이언트 측에서 주기적으로 새로운 데이터를 가져옴**

  

💡 **즉, Page Router에서 PPR과 같은 효과를 내려면 SSR을 혼합하는 것이 아니라, 클라이언트에서 데이터를 주기적으로 갱신해야 한다.**

---

**4. 기존 SSG, SSR과의 차이점**

| |**SSG (Static)**|**SSR (Dynamic)**|**PPR (Hybrid)**|
|---|---|---|---|
|**빌드 시 정적 페이지 생성**|✅ 가능|❌ 불가능|✅ 부분적으로 가능|
|**실시간 데이터 반영**|❌ 불가능|✅ 가능|✅ 가능 (필요한 부분만)|
|**초기 로딩 속도**|✅ 매우 빠름|❌ 상대적으로 느림|✅ 빠름 (정적 데이터 활용)|
|**CDN 캐싱 활용**|✅ 가능|❌ 불가능|✅ 가능 (정적 부분)|
|**서버 부하**|✅ 낮음|❌ 높음|🔄 중간 (정적 + 동적 조합)|
💡 **PPR을 활용하면, 초기 로딩 속도를 유지하면서도 SSR처럼 최신 데이터를 반영할 수 있다.**

---
date: 2025-03-20T16:01:44+09:00

**5. PPR을 사용해야 하는 경우**

  

✅ **정적인 콘텐츠(예: 블로그, 문서)는 빠르게 로딩하면서, 최신 데이터(예: 댓글, 조회수)는 실시간으로 반영하고 싶을 때**

✅ **SEO가 중요한 페이지지만, 일부 동적 콘텐츠가 필요할 때**

✅ **SSR을 사용하면 속도가 너무 느려지고, SSG만 사용하면 최신 데이터를 반영하기 어려울 때**

  

**PPR을 고려하지 않아도 되는 경우**

  

❌ **완전히 정적인 사이트 (정적 사이트 생성만으로 충분한 경우)**

❌ **실시간 데이터가 필요 없는 페이지**

---

**6. 결론 – PPR을 어떻게 활용해야 할까?**

  

✔ **정적 페이지(SSG)와 동적 데이터(SSR)를 조합할 수 있다.**

✔ **초기 로딩 속도를 빠르게 유지하면서도, 최신 데이터 반영이 가능하다.**

✔ **CDN 캐싱을 활용할 수 있어 서버 부하를 줄일 수 있다.**

✔ **Next.js 15 이후로 점점 더 많이 활용될 가능성이 크다.**

  

PPR을 잘 활용하면 **SSR의 단점(느린 속도)과 SSG의 단점(데이터 갱신 어려움)을 동시에 해결할 수 있다.**

---
date: 2025-03-20T16:01:44+09:00

**최종 정리**

  

✅ **“초기 로딩 속도는 유지하면서, 일부 데이터는 최신 상태로 유지하고 싶다”** → **PPR 사용**

✅ **“완전히 정적인 사이트를 만들고 싶다”** → **기존 SSG 유지**

✅ **“실시간 데이터가 중요한 페이지다”** → **SSR 또는 React Query 사용**