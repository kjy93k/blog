---
created: 2025-03-31T15:41:00
tags:
  - React18
  - useTransition
  - useDeferredValue
  - useId
  - 성능최적화
  - UI반응성
  - 리액트훅
  - Hooks
---
  

React 18이 나오면서 새롭게 추가된 훅들이 있다. useTransition, useDeferredValue, useId 같은 것들인데, 이들은 UI 반응성과 성능 최적화에 많은 도움이 된다. 그전에 이미 여러 훅들이 있긴 했지만, 이 훅들은 특히 **비동기 작업을 다룰 때**나 **렌더링 성능을 최적화**하고 싶은 경우에 유용하다.

---

## **useTransition** – 비동기 작업의 우선순위 조정

  

일단 useTransition부터 보면, 이 훅은 비동기 작업의 **우선순위**를 조정할 수 있게 해준다. 예를 들어, 리스트가 엄청나게 길거나 복잡한 UI가 있을 때, 사용자가 입력을 했다고 해서 그것을 즉시 반영하는 대신, **UI 업데이트가 더 중요할 경우** 우선적으로 그걸 처리하고 비동기 작업은 뒤로 미룰 수 있는 거다.

```
import { useState, useTransition } from "react";

function MyComponent() {
  const [isPending, startTransition] = useTransition();
  const [value, setValue] = useState("");

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = event.target.value;
    startTransition(() => {
      setValue(newValue);
    });
  };

  return (
    <div>
      <input type="text" onChange={handleChange} />
      {isPending ? <p>Loading...</p> : <p>{value}</p>}
    </div>
  );
}
```

이렇게 작성하면, 비동기 작업이 백그라운드에서 처리되면서도, 중요한 UI 업데이트는 먼저 반영된다. 물론, UI가 최우선으로 반영되기 때문에 사용자 경험이 더 좋아진다.

---

## **useDeferredValue** – 렌더링 지연시키기

  

useDeferredValue는 말 그대로 **렌더링을 지연시키는** 용도로 쓰인다. 예를 들어, 사용자가 검색어를 입력할 때마다 바로 렌더링을 하지 않고, 입력이 멈춘 후에 반영하고 싶은 경우에 유용하다. 이 훅을 쓰면, 불필요하게 계속 렌더링되는 걸 막고, 성능을 좀 더 최적화할 수 있다.

```
import { useState, useDeferredValue } from "react";

function Search() {
  const [query, setQuery] = useState("");
  const deferredQuery = useDeferredValue(query);

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setQuery(event.target.value);
  };

  return (
    <div>
      <input type="text" onChange={handleChange} />
      <p>검색어: {deferredQuery}</p>
    </div>
  );
}
```

이렇게 작성하면, query가 실시간으로 바뀌지 않고, 일정 시간 후에 deferredQuery 값만 업데이트된다. 그러면 UI가 과도하게 렌더링되지 않고 더 부드럽게 처리된다.

---

## **useId** – 고유 ID 생성

  

마지막으로 useId는 **고유 ID를 생성**하는 훅이다. 이 훅의 핵심은 **서버와 클라이언트에서 동일한 ID를 생성**할 수 있다는 점이다. 특히 서버 사이드 렌더링(SSR) 환경에서 유용하다. useId를 사용하면, 클라이언트에서 렌더링되는 값과 서버에서 렌더링되는 값이 일치하게 된다.

```
import { useId } from "react";

function MyComponent() {
  const id = useId();
  return <input id={id} />;
}
```

이 코드처럼, 각각의 컴포넌트가 **고유한 ID**를 가지도록 보장해준다. 서버 측과 클라이언트 측에서의 ID 불일치를 막아주는 훅이기 때문에 SSR에서 특히 중요한 역할을 한다.

---

## **정리**

| **Hook**         | **언제 사용하나**               | **특징**                     |
| ---------------- | ------------------------- | -------------------------- |
| useTransition    | 비동기 작업의 우선순위를 지정할 때       | 중요 UI 우선 렌더링, 비동기 작업 지연 처리 |
| useDeferredValue | 입력값을 실시간으로 반영하지 않고 지연시킬 때 | 렌더링 지연, 불필요한 렌더링 방지        |
|useId|서버/클라이언트에서 동일한 ID가 필요할 때|고유 ID 생성, SSR에서 유용|

---

이제 **React 18에서 새로 등장한** 훅들을 잘 활용하면, 성능 최적화나 UI 반응성을 크게 개선할 수 있다. 이 훅들을 적절히 사용해서, React 애플리케이션을 더 효율적으로 만들자.


다음 글에서는 **useRouter, usePathname, useSearchParams**와 같은 **Next.js 15 Navigation Hook**을 정리할 예정이다.