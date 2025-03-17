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

**1. Next.js 15에서 데이터 패칭 방식 총정리**

| |**Server Component (서버에서 실행)**|**Client Component (클라이언트에서 실행)**|
|---|---|---|
|**fetch() 사용**|✅ 가능 (fetch()를 직접 실행)|❌ 불가능 (useEffect에서 fetch() 사용해야 함)|
|**React Query 사용**|❌ 불필요 (서버에서 직접 패칭 가능)|✅ 가능 (클라이언트에서 상태 기반 데이터 요청 가능)|
|**Server Actions 사용**|✅ 가능 (서버에서 직접 데이터 수정)|✅ 가능 (클라이언트에서 서버 액션 실행)|