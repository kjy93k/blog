Next.js 13부터 **App Router가 도입**되었고,

이제 Next.js 15에서는 App Router가 **기본 방식으로 권장**되고 있다.

하지만 기존의 **Page Router도 여전히 지원**되며,

실무에서는 **어떤 방식을 선택하는 것이 적절한지 고민이 필요하다.**

  

이 글에서는 **App Router와 Page Router의 차이점, 각 방식의 장단점, 그리고 실무에서의 선택 기준**을 정리한다.

---

**1. Next.js App Router와 Page Router의 개념적 차이**

| |**Page Router (기존 방식)**|**App Router (새로운 방식)**|
|---|---|---|
|**라우팅 방식**|pages/ 디렉터리 사용|app/ 디렉터리 사용|
|**파일 구조**|index.tsx, [id].tsx 같은 파일이 자동으로 URL에 매핑됨|page.tsx, [id]/page.tsx 사용|
|**데이터 패칭**|getServerSideProps, getStaticProps 사용|서버 컴포넌트에서 fetch() 직접 사용|
|**서버/클라이언트 구분**|SSR, CSR 방식 혼합|React Server Component(RSC) 활용하여 자동 최적화|
|**SEO 최적화**|SSR을 활용해 가능하지만 API 호출 필요|서버에서 HTML을 직접 렌더링하여 더 유리|
|**스타일링**|Emotion, Styled-components 등 사용 가능|Emotion 사용이 어려움 (SSR 관련 문제)|
|**API 라우팅**|pages/api/를 활용한 API 요청|Server Actions 활용 가능 ("use server")|

기본적으로 **Page Router는 기존 React 방식과 유사한 CSR(클라이언트 렌더링) 중심**이고,

**App Router는 서버 중심의 렌더링 방식(RSC)으로 최적화**되었다.

---

**2. Page Router vs App Router – 기능별 차이점 분석**

  

**📌 1. 라우팅 방식**

  

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

**📌 2. 데이터 패칭 방식**

  

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

