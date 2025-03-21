
**useState, useEffect, useRef**

  

App Router가 React의 흐름이 되면서

Navigation, Form, UI 관련해서 새로운 Hook들이 추가되었다.

  

그전에 React에서 많이 쓰이는 Hook들을 정리해보려고 한다.

useState, useEffect, useRef부터 자주 쓰이는 Hook들을 확인하고,

사용 중 실수할 수 있는 부분도 함께 정리해보려고 한다.

---

**useState – 상태 값을 저장할 때**

  

사용자 입력, 버튼 클릭, 토글처럼 변하는 데이터를 화면에 반영할 때 가장 자주 쓰이는 Hook이다.

```

import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>현재 카운트: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
```

useState는 [값, 값을 업데이트하는 함수] 형태의 배열을 반환한다.

상태가 바뀌면 컴포넌트는 다시 렌더링된다.

  

**상태 업데이트 방식에서 실수하기 쉬운 부분**

```
setCount(count + 1);
setCount(count + 1);
```
이렇게 작성하면 두 번 더해질 것 같지만 실제로는 한 번만 반영된다.

React의 상태 업데이트는 비동기로 처리되기 때문에, 위 코드는 이전 값 기준이 아니라 **현재 렌더링 시점의 값만 참조**하기 때문이다.

```
setCount(prev => prev + 1);
setCount(prev => prev + 1); // 이건 실제로 +2가 된다
```
  
---

**useEffect – 렌더링 이후 무언가를 처리할 때**

  

API 요청, 타이머 설정, 이벤트 리스너 등록 등

화면이 그려진 뒤에 처리해야 하는 작업들을 수행할 때 사용한다.

```
import { useEffect, useState } from "react";

export default function Timer() {
  const [seconds, setSeconds] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setSeconds(prev => prev + 1);
    }, 1000);

    return () => clearInterval(timer);
  }, []);
  
  return <p>{seconds}초가 지났습니다.</p>;
}
```

두 번째 인자인 **의존성 배열**([])에 어떤 값이 들어가느냐에 따라 실행 조건이 달라진다.

|**의존성 배열**|**실행 시점**|
|---|---|
|없음|매번 렌더링될 때마다 실행됨|
|[]|마운트 시 한 번만 실행됨|
|[count]|count가 변경될 때마다 실행됨|
cleanup 함수를 리턴하지 않으면, 타이머나 이벤트 리스너가 쌓여서 **메모리 누수**가 발생할 수 있다.

---

**useRef – 값은 유지하지만 렌더링에는 영향을 주지 않을 때**

```
import { useRef } from "react";

export default function FocusInput() {
  const inputRef = useRef<HTMLInputElement>(null);

  const handleClick = () => {
    inputRef.current?.focus();
  };

  return (
    <>
      <input ref={inputRef} type="text" />
      <button onClick={handleClick}>포커스 이동</button>
    </>
  );
}
```

useRef는 .current를 통해 DOM에 직접 접근할 수 있다.

리렌더링 없이도 값을 저장하고 유지할 수 있어서, **상태처럼 쓰이지만 렌더링을 유발하지는 않는다.**

```
const prevCount = useRef(count);

useEffect(() => {
  prevCount.current = count;
}, [count]);
```

위처럼 이전 값을 기억해야 할 때도 유용하다.

---

**간단 정리**