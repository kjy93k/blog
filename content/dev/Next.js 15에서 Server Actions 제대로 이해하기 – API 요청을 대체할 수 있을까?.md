---
date: 2025-03-20T15:46:41+09:00
tags:
  - NextJS15
  - ServerActions
  - APIless
  - ReactServerComponents
  - ServerSideRendering
  - 웹개발
  - React
  - Frontend
---
Next.js 15에서는 **Server Actions**가 추가되면서 기존의 API 요청 방식(fetch, API Routes, React Query 등)과는 다른 **새로운 서버 데이터 조작 방식**이 가능해졌다.

  

그렇다면 **Server Actions는 기존 방식과 어떻게 다르고, 언제 사용해야 할까?**

이 글에서는 **Server Actions의 개념, 기존 방식과의 차이점, 실무에서의 적절한 활용법**을 정리한다.

---
date: 2025-03-20T15:46:41+09:00

**1. Server Actions란?**

  

Server Actions는 **서버에서 실행되는 비동기 함수**로,

기존처럼 API 엔드포인트를 따로 만들지 않고 **클라이언트에서 직접 서버의 함수를 호출할 수 있다.**

  

즉, **클라이언트에서 fetch() 없이도 서버에서 실행되는 함수를 바로 호출할 수 있는 방식이다.**

  

**기존 방식 (API 요청)**

```
// 클라이언트에서 fetch() 사용
const handleSubmit = async (formData) => {
  const res = await fetch("/api/submit", {
    method: "POST",
    body: JSON.stringify(formData),
    headers: { "Content-Type": "application/json" },
  });
  const data = await res.json();
  console.log(data);
};
```

**단점:**

• /api/submit 같은 API 엔드포인트를 별도로 만들어야 한다.

• fetch()를 호출하는 과정이 필요하다.

---

**Server Actions 방식**

```
"use server";

export async function submitForm(formData) {
  console.log("서버에서 실행됨:", formData);
  return { success: true, message: "폼 제출 완료" };
}
```

```
// 클라이언트에서 직접 실행
const handleSubmit = async (formData) => {
  const response = await submitForm(formData);
  console.log(response);
};
```

**장점:**

• **API 엔드포인트 없이 서버의 함수를 직접 실행할 수 있다.**

• **fetch() 없이 서버 데이터를 수정할 수 있다.**

• **클라이언트와 서버 간 통신 과정이 단순해진다.**

---
date: 2025-03-20T15:46:41+09:00

**2. Server Actions vs 기존 fetch() 요청**

| |**Server Actions**|**기존 API 요청 (fetchServer)**|
|---|---|---|
|**API 엔드포인트 필요 여부**|❌ 필요 없음|✅ 필요함 (/api/...)|
|**클라이언트에서의 동작 방식**|서버의 함수를 직접 호출|fetch()를 사용하여 요청|
|**데이터 수정 (POST 등)**|✅ 가능|✅ 가능|
|**데이터 조회 (GET 요청)**|❌ 비효율적 (사용 불가)|✅ 가능|
|**외부 API 요청**|❌ 비효율적|✅ 적합|
**결론**

• **데이터를 수정할 때 (POST, PUT, DELETE) → Server Actions가 유용하다.**

• **데이터를 조회할 때 (GET 요청) → fetch() 또는 React Query가 더 적합하다.**

---

**3. Server Actions의 사용 예제**

  

**기본 사용법**

```
"use server";

export async function submitData(formData: { name: string; email: string }) {
  console.log("서버에서 실행됨:", formData);
  return { success: true, message: "데이터 저장 완료" };
}
```

```
// 클라이언트에서 직접 실행
const handleSubmit = async () => {
  const response = await submitData({ name: "John Doe", email: "john@example.com" });
  console.log(response);
};
```

**API 엔드포인트 없이 서버에서 데이터 처리 가능하다.**

---
date: 2025-03-20T15:46:41+09:00

**폼 데이터 처리 예제**

```
"use client";
import { useState } from "react";
import { submitData } from "./actions"; // Server Actions 함수 불러오기

export default function Form() {
  const [formData, setFormData] = useState({ name: "", email: "" });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const response = await submitData(formData);
    console.log(response);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" name="name" value={formData.name} onChange={handleChange} />
      <input type="email" name="email" value={formData.email} onChange={handleChange} />
      <button type="submit">제출</button>
    </form>
  );
}
```
**클라이언트에서 직접 Server Actions를 실행할 수 있으며, 별도의 API 엔드포인트 없이 서버에서 데이터 처리 가능하다.**

---

**4. Server Actions의 한계점**

  

하지만 **Server Actions가 항상 최선의 선택은 아니다.**

• **데이터 조회(GET 요청)에는 적합하지 않다.**

• **Client-Side Rendering(CSR) 환경에서는 사용할 수 없다.** (use server이므로 서버 컴포넌트 전용)

• **클라이언트에서 즉시 응답을 받아야 하는 경우 느릴 수 있다.** (네트워크 요청이 항상 필요함)

• **외부 API 요청을 직접 수행하기 어렵다.** (서버 내부 로직에 더 적합함)

---
date: 2025-03-20T15:46:41+09:00

**5. Server Actions vs 기존 방식 – 언제 어떤 걸 선택해야 할까?**

| **상황**                         | **Server Actions**    | **fetchServer (기존 API 요청)** |
| ------------------------------ | --------------------- | --------------------------- |
| **데이터 조회 (GET 요청)**            | ❌ 적합하지 않음             | ✅ 적합                        |
| **데이터 수정 (POST, PUT, DELETE)** | ✅ 서버에서 직접 실행 가능       | ✅ 가능                        |
| **CSR 환경 (클라이언트에서 실행)**        | ❌ 불가능 (use server 제한) | ✅ 가능                        |
| **폼 제출, 로그인 처리**               | ✅ 적합                  | ✅ 가능                        |
| **외부 API 요청**                  | ❌ 비효율적                | ✅ 적합                        |

**서버에서 직접 데이터를 수정해야 한다면 Server Actions를 사용하고,**

**클라이언트에서 데이터를 가져오거나 외부 API 요청이 필요하면 기존 API 요청 방식을 사용한다.**

---

**6. 결론 – Server Actions를 언제 사용해야 할까?**

  

✔ **API 엔드포인트 없이 서버에서 직접 데이터를 처리할 수 있다.**

✔ **데이터 수정(POST, PUT, DELETE)에는 유용하지만, 데이터 조회(GET)에는 적합하지 않다.**

✔ **CSR(Client-Side Rendering) 환경에서는 사용할 수 없다.** (use server 제한됨)

✔ **외부 API 요청을 직접 수행하기보다는 내부 데이터 수정에 더 적합하다.**

✔ **Next.js의 App Router와 함께 사용하면 더욱 직관적인 데이터 처리가 가능하다.**

---
date: 2025-03-20T15:46:41+09:00

**최종 정리**

  

✅ **“서버에서 직접 실행해야 하는 작업(데이터 저장, 폼 처리 등)”** → Server Actions

✅ **“클라이언트에서 데이터를 가져오거나, 외부 API 요청이 필요한 경우”** → Route Handlers (/app/api/.../route.ts)

✅ **“기존 Next.js Page Router 프로젝트 유지보수 중”** → API Routes (/pages/api/...)