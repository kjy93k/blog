Next.js 15에서는 **App Router, React Server Components(RSC), Server Actions** 등의 변화로 인해

기존의 **클라이언트 상태 관리 라이브러리(Zustand, Redux, React Query)**를 어떻게 선택해야 할지 고민이 많아졌다.

  

이 글에서는 **Zustand, Redux, React Query 각각의 특징과 Next.js 15에서의 적합성을 비교**하고,

**React Query의 적절한 사용 시점**까지 추가로 설명해보자.

---

## **1. 상태 관리 라이브러리의 역할과 필요성**

  

Next.js 15에서는 **React Server Components(RSC)와 Server Actions**가 도입되면서

**클라이언트 상태 관리의 역할이 예전과 달라졌다.**

  

✅ **서버 상태 관리(Server State)** → **React Query, SWR**

✅ **클라이언트 전역 상태 관리(Client State)** → **Zustand, Redux, Context API**

✅ **서버에서 직접 데이터 조작 (Mutations)** → **Server Actions**

  

이제 **클라이언트에서 직접 서버 데이터를 가져올 필요가 줄어들었기 때문에**

**어떤 상태 관리 라이브러리를 선택하는지가 더 중요해졌다.**

---

## **2. Zustand, Redux, React Query의 차이점**

| |**Zustand**|**Redux**|**React Query**|
|---|---|---|---|
|**주 사용 목적**|클라이언트 전역 상태 관리|클라이언트 전역 상태 관리|서버 상태 관리 (데이터 패칭, 캐싱)|
|**설치 및 설정**|✅ 간단함|❌ 복잡함 (보일러플레이트 많음)|✅ 간단함|
|**RSC에서 사용 가능 여부**|✅ 가능|✅ 가능|❌ 서버에서 직접 호출 불가능|
|**비동기 상태 관리**|✅ 지원 (middleware 필요)|✅ 지원 (Thunk, Saga 필요)|✅ 내장 (useQuery)|
|**리렌더링 성능 최적화**|✅ 강력함|❌ 리렌더링 많이 발생|✅ 기본적으로 최적화됨|
|**Next.js 15에서 적합한 용도**|클라이언트 UI 상태 관리 (모달, 필터 등)|복잡한 글로벌 상태 관리 (대규모 프로젝트)|서버 데이터 패칭 및 캐싱 (CSR에서 유용)|
  

---

## **3. Next.js 15에서 각 라이브러리를 어떻게 활용할 수 있을까?**

  

### **📌 Zustand – 간단하고 가벼운 상태 관리**

  

Zustand는 **Context API보다 강력하고 Redux보다 간단한 상태 관리 라이브러리**이다.

Next.js 15에서도 **클라이언트 전역 상태 관리(UI 상태, 필터 등)에 적합**하다.

```
import { create } from "zustand";

// Zustand 스토어 정의
const useStore = create((set) => ({
  count: 0,
  increase: () => set((state) => ({ count: state.count + 1 })),
}));

// Next.js 클라이언트 컴포넌트에서 사용
export default function Counter() {
  const { count, increase } = useStore();
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={increase}>증가</button>
    </div>
  );
}
```

✅ **Next.js 15에서도 문제없이 사용할 수 있음**

✅ **클라이언트 상태(UI 상태, 모달 상태, 필터 상태 등)에 적합**

❌ **서버 상태 관리(데이터 패칭)에는 적합하지 않음**

---

### **📌 Redux – 대규모 프로젝트에서 복잡한 상태 관리**

  

Redux는 **전역 상태를 정형화된 방식으로 관리할 때 적합**하지만,

Next.js 15에서는 **불필요한 보일러플레이트 코드가 많아서 부담이 될 수 있음**

```
import { createSlice, configureStore } from "@reduxjs/toolkit";
import { Provider, useSelector, useDispatch } from "react-redux";

// Redux Slice
const counterSlice = createSlice({
  name: "counter",
  initialState: { count: 0 },
  reducers: {
    increment: (state) => { state.count += 1; },
  },
});

// Redux Store
const store = configureStore({ reducer: { counter: counterSlice.reducer } });

// Next.js 클라이언트 컴포넌트에서 사용
function Counter() {
  const count = useSelector((state) => state.counter.count);
  const dispatch = useDispatch();

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => dispatch(counterSlice.actions.increment())}>증가</button>
    </div>
  );
}

// Next.js App에 Provider 적용
export default function App() {
  return (
    <Provider store={store}>
      <Counter />
    </Provider>
  );
}
```

✅ **복잡한 전역 상태 관리에 유용함 (대규모 프로젝트에서 활용 가능)**

❌ **보일러플레이트 코드가 많고 설정이 번거로움**

❌ **Zustand에 비해 불필요한 리렌더링이 많이 발생할 수 있음**

---

### **📌 React Query – 서버 데이터 패칭 및 캐싱 (CSR 전용)**

  

Next.js 15에서는 **React Query를 사용하면 fetch()를 직접 호출할 필요 없이 데이터 패칭을 최적화할 수 있음**

그러나 **서버 컴포넌트(RSC)에서는 React Query를 사용할 수 없으며, CSR(Client-Side Rendering) 전용**

```
import { useQuery } from "@tanstack/react-query";

const fetchPosts = async () => {
  const res = await fetch("/api/posts");
  return res.json();
};

// 클라이언트에서 서버 데이터를 가져올 때
export default function Posts() {
  const { data, error, isLoading } = useQuery(["posts"], fetchPosts);

  if (isLoading) return <p>Loading...</p>;
  if (error) return <p>Error loading posts</p>;

  return (
    <ul>
      {data.map((post) => (
        <li key={post.id}>{post.title}</li>
      ))}
    </ul>
  );
}
```

✅ **자동 캐싱 및 데이터 동기화 기능이 필요할 때 유용**

✅ **데이터가 변경되면 자동으로 UI 업데이트 가능**

❌ **서버 컴포넌트(RSC)에서는 사용할 수 없음 (useQuery는 클라이언트 전용)**

---

## **4. Next.js 15에서 상태 관리 라이브러리 선택 기준**

|**사용 사례**|**Zustand**|**Redux**|**React Query**|
|---|---|---|---|
|**UI 상태 (모달, 필터, 토글 등)**|✅ 적합|❌ 불필요하게 복잡함|❌ 적합하지 않음|
|**대규모 프로젝트의 글로벌 상태 관리**|❌ 너무 단순함|✅ 적합|❌ 적합하지 않음|
|**서버 데이터 패칭 및 캐싱**|❌ 적합하지 않음|❌ 적합하지 않음|✅ 적합 (CSR에서만 가능)|
|**RSC에서 사용 가능 여부**|✅ 가능|✅ 가능|❌ 불가능 (클라이언트 전용)|
✅ **“UI 상태 관리(모달, 필터, 토글 등)”** → Zustand 사용

✅ **“복잡한 글로벌 상태 관리가 필요하다”** → Redux 사용

✅ **“서버 데이터를 가져오고 캐싱해야 한다 (CSR에서만 가능)”** → React Query 사용