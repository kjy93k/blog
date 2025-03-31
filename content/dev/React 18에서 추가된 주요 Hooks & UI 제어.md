---
created: 2025-03-31T15:41:00
---
  

React 18이 나오면서, useTransition, useDeferredValue, useId 같은 새로운 훅들이 추가됐다. 그전에도 많은 훅들이 있었지만, 이번에 새롭게 추가된 것들은 UI 반응성과 성능 최적화에 좀 더 집중된 부분들이라서 꽤나 유용하게 사용될 수 있을 것 같다. 일단 이 훅들에 대해 한 번 정리해보자.

---

**useTransition** – 비동기 작업의 우선순위 조정

  

useTransition은 비동기 작업을 **우선순위**를 두고 처리할 수 있게 해주는 훅이다. 비동기 작업을 백그라운드에서 처리하면서, 중요한 UI 업데이트는 먼저 하게 할 수 있다. 예를 들어, 긴 리스트를 렌더링할 때, 사용자가 인터랙션을 했을 때 그 반응이 느리다면, 우선 중요한 UI는 렌더링하고 나중에 비동기 작업을 처리하는 방식으로 동작한다.
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

이 훅을 사용하면, **UI 업데이트가 중요한 것과 덜 중요한 것을 구분**해서 더 빠르고 쾌적하게 렌더링할 수 있다.

---

**useDeferredValue** – 렌더링 지연시키기

  

useDeferredValue는 **입력값을 실시간으로 반영하지 않고**, 일정 시간 후에 반영하고 싶은 경우에 유용하다. 예를 들어, 사용자가 검색어를 입력할 때마다 **즉시 렌더링하는 것을 막고**, 일정 시간 뒤에 렌더링하여 성능을 최적화할 수 있다.

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

이 훅을 사용하면 UI가 과도하게 렌더링되는 것을 막고, 좀 더 부드럽게 처리할 수 있다.

---

**useId** – 고유 ID 생성

  

useId는 **서버와 클라이언트에서 동일한 고유 ID를 생성**할 수 있게 해주는 훅이다. 서버 측에서 렌더링할 때와 클라이언트 측에서 렌더링할 때 동일한 ID 값을 보장해주기 때문에, 주로 **서버 사이드 렌더링(SSR)** 환경에서 유용하다.

```
import { useId } from "react";

function MyComponent() {
  const id = useId();
  return <input id={id} />;
}
```

이 훅을 사용하면, **각각의 컴포넌트가 고유한 ID를 가지도록** 보장할 수 있다.

---

**정리**

  

새로 추가된 훅들은 UI의 반응성을 높이고 성능 최적화에 중요한 역할을 한다. useTransition은 비동기 작업의 우선순위를 처리하고, useDeferredValue는 렌더링 지연을 통해 불필요한 연산을 줄이며, useId는 고유한 ID 값을 쉽게 생성할 수 있게 해준다.

  

이 훅들을 적절히 활용하면, React 애플리케이션의 성능을 더 효율적으로 최적화할 수 있을 것이다.