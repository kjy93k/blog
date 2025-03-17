Next.js 15에서는 **App Router의 도입으로 데이터 패칭 방식이 여러 가지로 나뉘게 되었다.**

기존 Page Router에서는 getServerSideProps, getStaticProps, getInitialProps를 사용했지만,

App Router에서는 **Server Component, Client Component, Server Actions 등의 개념이 도입되면서 데이터 패칭 방식이 더욱 유연해졌다.**

  

**📌 App Router에서의 데이터 패칭 변화**

1. **서버에서 직접 데이터를 가져올 수 있는 Server Component (fetch() 사용)**

2. **클라이언트 상태 관리 및 비동기 요청을 위한 React Query**

3. **API 없이 서버에서 데이터를 수정할 수 있는 Server Actions**

4. **Next.js의 자동 캐싱과 Request Deduplication 활용 (동일한 요청은 한 번만 실행됨)**

  

즉, **App Router에서는 같은 데이터 요청이 여러 곳에서 실행되더라도 Next.js가 이를 감지하여 중복 요청을 방지한다.**

이 기능을 **Request Deduplication(요청 중복 제거)** 이라고 하며,

Next.js가 같은 API 요청을 한 번만 실행한 후, 모든 컴포넌트가 해당 데이터를 공유하도록 최적화한다.

  

또한, **Next.js의 자동 캐싱(Cache)은 GET 요청만을 대상으로 하며,**

**React 컴포넌트 트리 내에서 실행된 fetch() 요청만 캐싱 및 메모이제이션이 적용된다.**

즉, **라우트 핸들러 (app/api/.../route.ts)에서 실행된 fetch() 요청은 캐싱되지 않는다.**

  

그렇다면 **각각의 방식이 어떤 역할을 하고, 언제 사용해야 하는지** 비교해보자.

---

**1. Next.js 15에서 데이터 패칭 방식 총정리**

| |**Server Component (서버에서 실행)**|**Client Component (클라이언트에서 실행)**|
|---|---|---|
|**fetch() 사용**|✅ 가능 (fetch()를 직접 실행)|❌ 불가능 (useEffect에서 fetch() 사용해야 함)|
|**React Query 사용**|❌ 불필요 (서버에서 직접 패칭 가능)|✅ 가능 (클라이언트에서 상태 기반 데이터 요청 가능)|
|**Server Actions 사용**|✅ 가능 (서버에서 직접 데이터 수정)|✅ 가능 (클라이언트에서 서버 액션 실행)|

---

**2. fetch()를 활용한 데이터 패칭 (Server Component에서 실행)**

  

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

**3. Next.js의 자동 캐싱과 Request Deduplication**

  

**📌 캐싱 기본 동작**

  

Next.js에서는 기본적으로 fetch()를 실행하면 **자동으로 데이터를 캐싱**한다.

즉, 같은 API 요청이 여러 곳에서 실행되더라도, **Next.js가 한 번만 요청하고 결과를 공유**한다.

  

**📌 Request Deduplication 예제**
```
export async function getData() {
  return fetch("https://api.example.com/data").then((res) => res.json());
}

export default async function Page() {
  const data1 = await getData();
  const data2 = await getData();

  return (
    <div>
      <h1>{data1.title}</h1>
      <p>{data2.content}</p>
    </div>
  );
}
```
✅ **위 코드에서 getData()를 두 번 호출했지만, Next.js는 이를 감지하고 하나의 요청만 실행한다.**

✅ **즉, 여러 컴포넌트에서 같은 데이터를 가져와도 Next.js는 중복 요청을 막아 네트워크 비용을 절감한다.**

---

**📌 자동 캐싱이 적용되지 않는 경우**

1. **GET 요청이 아닌 경우 (POST, PUT, DELETE)**

• Next.js의 자동 캐싱은 **GET 요청만을 대상으로 한다.**

• 데이터를 변경하는 요청(POST, PUT, DELETE)은 자동 캐싱되지 않는다.

2. **라우트 핸들러에서 실행된 fetch()**
```
// app/api/data/route.ts
export async function GET() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();
  return Response.json(data);
}
```
• **라우트 핸들러는 React 컴포넌트 트리에 속하지 않기 때문에 자동 캐싱이 되지 않는다.**

• 따라서, API 엔드포인트에서 실행되는 fetch() 요청은 **Request Deduplication이 적용되지 않는다.**

---

**4. 실무에서 데이터 패칭 방식 선택 기준**

| |**적합한 경우**|
|---|---|
|**Server Component에서 fetch()**|초기 데이터를 서버에서 가져와야 할 때, SEO 최적화가 필요할 때|
|**Client Component에서 React Query**|사용자 인터랙션에 따라 데이터를 가져와야 할 때, 실시간 데이터가 필요할 때|
|**Server Actions 사용**|API 없이 서버에서 데이터를 직접 수정해야 할 때|
**즉, Next.js 15에서는 하나의 방식만 선택하는 것이 아니라,**

**필요에 따라 fetch(), React Query, Server Actions를 조합해서 사용하는 것이 중요하다.**

---

**5. 결론 – Next.js 15에서 데이터 패칭은 어떻게 해야 할까?**

  

✔ **서버에서 미리 데이터를 렌더링해야 한다면 fetch()를 Server Component에서 직접 실행하는 것이 적절하다.**

✔ **사용자의 입력에 따라 데이터를 가져와야 한다면 React Query를 활용하는 것이 좋다.**

✔ **API 없이 서버에서 데이터를 수정해야 한다면 Server Actions을 활용할 수 있다.**

✔ **Request Deduplication을 활용하면 동일한 fetch() 요청이 여러 곳에서 호출되더라도 한 번만 실행되어 최적화된다.**

✔ **Next.js의 자동 캐싱은 GET 요청에서만 적용되며, React 컴포넌트 트리 내에서 실행된 fetch()만 캐싱된다.**

✔ **라우트 핸들러에서 실행된 fetch() 요청은 캐싱되지 않으므로, API 핸들러에서는 별도로 최적화가 필요하다.**