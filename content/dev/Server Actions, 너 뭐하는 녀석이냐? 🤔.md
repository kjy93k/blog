Next.js 15에서는 **Server Actions**라는 친구가 등장했다.

이 친구의 특징은 뭐냐 하면,

✅ **API 엔드포인트 없이 서버에서 데이터를 바로 수정할 수 있다!**

✅ **클라이언트에서 fetch() 안 써도 된다!**

✅ **“서버야, 이거 해줘~” 하면 바로 서버에서 실행된다!**

  

그렇다면 이 녀석이 **기존 API 방식(fetch, React Query)과 어떻게 다르고, 언제 써야 하는지** 알아보자!

---

**1. Server Actions vs 기존 방식 (이래서 혁명이라 불린다?!)**

  

🚨 **기존 방식 (API 요청)**

```
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

⚡ **Server Actions 방식**

```
"use server";

export async function submitForm(formData) {
  console.log("서버에서 실행됨:", formData);
  return { success: true, message: "폼 제출 완료" };
}
```

```
const handleSubmit = async (formData) => {
  const response = await submitForm(formData);
  console.log(response);
};
```

😲 **뭐야?! API 엔드포인트를 따로 만들 필요가 없잖아?!**

✅ **fetch() 없이 서버에서 실행 가능**

✅ **프론트에서 백엔드로 데이터 보내는 과정이 줄어듦**

---

**2. Server Actions는 언제 써야 할까? (그리고 언제 쓰면 망하는가?)**

|**상황**|**Server Actions**|**fetchServer (API 요청)**|
|---|---|---|
|**데이터 조회 (GET 요청)**|❌ 비효율적|✅ 적합|
|**데이터 수정 (POST, PUT, DELETE)**|✅ 서버에서 직접 실행 가능|✅ 가능|
|**CSR 환경 (클라이언트에서 실행)**|❌ 불가능 (use server 제한)|✅ 가능|
|**외부 API 요청**|❌ 비효율적|✅ 적합|
💡 **즉, 이런 느낌이다!**

• **“서버에서 직접 실행해야 한다”** → **Server Actions를 쓰자!**

• **“클라이언트에서 데이터를 가져와야 한다”** → **fetch()나 React Query를 쓰자!**

---

**3. Server Actions, 이렇게 써야 한다!**

  

🚀 **폼 데이터 처리 예제**
```
"use server";

export async function saveUserData(userData) {
  console.log("서버에서 실행됨:", userData);
  return { success: true, message: "저장 완료!" };
}
```

```
// 클라이언트에서 사용
const handleSubmit = async () => {
  const response = await saveUserData({ name: "Alice", age: 25 });
  console.log(response);
};
```

✅ **API 엔드포인트 없이 서버에서 데이터 처리 가능!**

✅ **서버에서만 실행되므로 보안적으로도 안정적!**

---

**4. Server Actions, 이럴 때 쓰면 망한다?! 🚨**

  

😵 **1) “데이터 조회에도 써야겠다!” → 망함**

• **Server Actions는 데이터를 수정할 때만 유용하고, GET 요청에는 비효율적이다.**

• 🔥 **데이터 조회(GET 요청)는 fetch()나 React Query를 사용하자.**

  

😵 **2) “CSR에서도 써야겠다!” → 망함**

• **Server Actions는 use server이므로 CSR(Client-Side Rendering)에서는 사용 불가능.**

• 🔥 **클라이언트에서 실행해야 한다면 기존 방식(fetch, React Query) 사용하자.**

  

😵 **3) “외부 API 요청도 Server Actions로 처리하자!” → 망함**

• **Server Actions는 Next.js 내부에서 실행되므로 외부 API 요청을 직접 처리하는 데 비효율적이다.**

• 🔥 **외부 API 요청은 fetchServer 또는 fetch()를 사용하자.**

---

**5. 결론 – Server Actions를 어떻게 활용해야 할까?**

  

✔ **API 엔드포인트 없이 서버에서 직접 데이터를 수정할 때 유용하다.**

✔ **RSC(Server Component)와 함께 사용하면 서버에서 바로 데이터를 다룰 수 있다.**

✔ **데이터 조회(GET 요청), CSR, 외부 API 요청에는 사용하지 말 것!**

---

**🚀 최종 정리 – 요약하면?**

  

✅ **“서버에서 실행해야 한다!”** → **Server Actions**

✅ **“데이터를 가져와야 한다!”** → **fetch() / React Query**

✅ **“클라이언트에서 실행해야 한다!”** → **Server Actions ❌, 기존 API 요청 방식 사용**