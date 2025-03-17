Next.js 15에서는 **App Router가 도입되면서 fetch()가 기본적인 데이터 패칭 방식**으로 자리 잡았다.

특히 **자동 캐싱, Request Deduplication, Server Component에서의 직접 호출 등 강력한 기능**이 추가되면서,

기존에 사용하던 axios보다 fetch()를 사용하는 것이 더 유리한 상황이 많아졌다.

  

이 글에서는 **Next.js 15에서 fetch()를 최적화하는 방법**을 정리하고,

• **자동 캐싱 및 Request Deduplication 활용 방법**

• **캐싱 전략 (cache: "no-store", revalidate)**

• **왜 axios를 사용하지 않는지?**

• **axios 대신 fetch()를 활용한 커스텀 API 헬퍼 만들기**

• **Zod를 활용한 TypeScript 기반 데이터 검증 방법**
  

를 다룬다.

---

**1. Next.js 15에서 fetch()의 역할**

  

Next.js 15에서는 **Server Component에서 fetch()를 직접 실행할 수 있으며,**

**자동으로 캐싱 및 요청 중복 제거 기능이 적용된다.**

```
export default async function Page() {
  const res = await fetch("https://api.example.com/data");
  const data = await res.json();

  return <div>{data.title}</div>;
}
```

✅ **서버에서 데이터를 가져온 후 HTML과 함께 렌더링 → SEO 최적화 가능**

✅ **Request Deduplication으로 동일한 요청이 여러 번 실행되더라도 한 번만 호출됨**

✅ **자동 캐싱으로 네트워크 요청을 줄여 성능 최적화 가능**

---

**2. Next.js fetch()의 캐싱 전략**

  

**📌 기본적으로 GET 요청은 자동으로 캐싱됨**

  

Next.js는 fetch()를 실행할 때 **GET 요청이면 기본적으로 캐싱을 수행**한다.

이는 **불필요한 네트워크 요청을 방지하고 성능을 최적화하는 역할**을 한다.

  

하지만, **항상 최신 데이터를 가져와야 하는 경우**에는 **캐싱을 비활성화해야 한다.**

---

**📌 캐싱 전략 설정 방법**

  

**1️⃣ 기본 캐싱 (cache: "force-cache", 기본값)**
```
const res = await fetch("https://api.example.com/data", { cache: "force-cache" });
```

• **서버가 요청을 한 번 수행한 후, 동일한 데이터 요청 시 캐싱된 데이터를 재사용**

• **기본적으로 Next.js는 GET 요청을 자동으로 캐싱하므로, 별도 설정이 필요 없음**

  

**2️⃣ 캐싱 없이 항상 최신 데이터 가져오기 (cache: "no-store")**
```
const res = await fetch("https://api.example.com/data", { cache: "no-store" });
```

• **매번 새로운 요청을 수행하며, 캐싱을 하지 않음**

• **실시간 데이터가 필요한 경우 사용**

  

**3️⃣ 특정 주기로 데이터 갱신 (next: { revalidate: X })**
```
const res = await fetch("https://api.example.com/data", { next: { revalidate: 60 } });
```

• **캐싱된 데이터를 사용하되, 60초마다 새로운 데이터를 가져옴**

• **ISR(Incremental Static Regeneration)과 유사한 방식으로 동작**

---

**3. Request Deduplication – 중복 요청 제거**

  

Next.js 15에서는 **동일한 fetch() 요청이 여러 곳에서 실행되더라도 중복 요청이 발생하지 않는다.**

즉, 같은 페이지 내에서 **여러 개의 Server Component가 동일한 데이터를 요청해도 하나의 요청으로 최적화된다.**

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

**4. axios를 사용하지 않는 이유?**

  

기존 Next.js 프로젝트에서는 axios를 사용하여 API 요청을 관리하는 경우가 많았지만,

Next.js 15에서는 fetch()를 사용하는 것이 더 유리하다.

| |**fetch()**|**axios**|
|---|---|---|
|**자동 캐싱 지원**|✅ 가능 (cache 옵션 지원)|❌ 지원되지 않음|
|**Request Deduplication**|✅ 지원됨|❌ 지원되지 않음|
|**브라우저/Node.js 환경 차이**|✅ 동일한 API 사용|❌ 동작 방식이 다를 수 있음|
|**인터셉터 지원**|❌ 직접 구현해야 함|✅ 요청/응답 인터셉터 지원|
|**설정 편의성**|❌ 옵션이 많고 설정이 필요|✅ 기본 설정을 인스턴스로 재사용 가능|
|**추천 사용 환경**|서버 데이터 패칭 (Server Component)|클라이언트 API 요청 관리 (Client Component)|

🚨 **즉, Next.js 15에서는 서버에서 데이터를 가져올 때 fetch()를 사용해야**

**자동 캐싱 및 Request Deduplication 기능을 활용할 수 있다.**

하지만 **클라이언트에서 API 요청을 체계적으로 관리하고, 인터셉터를 활용하려면 axios가 유리하다.**

---

**5. axios 대신 fetch()로 커스텀 API 헬퍼 만들기**

  

Next.js 15에서는 fetch()의 자동 캐싱을 유지하면서 **axios처럼 사용할 수 있는 API 헬퍼를 만들 수도 있다.**

```
const request = async (endpoint, options = {}) => {
  const res = await fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}${endpoint}`, {
    headers: {
      "Content-Type": "application/json",
    },
    ...options,
  });

  if (!res.ok) throw new Error(`Failed to fetch: ${res.status}`);

  return res.json();
};
```

✅ **자동 캐싱 기능 유지 (fetch()의 기본 동작 활용)**

✅ **API 요청을 한 곳에서 관리 가능**

  

혹은, **return-fetch** 같은 라이브러리를 활용하여 직접 fetch()의 기능을 확장할 수도 있다.

---

**6. 결론 – Next.js 15에서 fetch()를 어떻게 최적화할까?**

  

✔ **서버에서 데이터를 가져올 때는 fetch()를 사용해야 자동 캐싱 및 Request Deduplication을 활용할 수 있다.**

✔ **항상 최신 데이터를 가져와야 하면 cache: "no-store", 주기적으로 갱신하려면 next: { revalidate: X }을 사용한다.**

✔ **axios는 자동 캐싱 및 Request Deduplication 기능을 지원하지 않으므로, 서버에서는 fetch()를 사용하는 것이 더 적절하다.**

✔ **클라이언트에서 API 요청을 관리하고, 인터셉터를 활용하려면 axios를 사용할 수 있다.**

✔ **fetch()를 커스텀하여 axios처럼 활용할 수도 있으며, return-fetch 같은 라이브러리를 고려할 수도 있다.**