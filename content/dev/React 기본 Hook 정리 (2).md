**useCallback, useMemo, useContext, useReducer, useLayoutEffect**

  

앞선 글에서는 useState, useEffect, useRef처럼

리액트를 처음 시작할 때 마주치는 기본적인 Hook들을 정리했다.

  

이번에는 조금 더 **구조적인 관리나 퍼포먼스, 렌더링 시점 제어**에 관련된 Hook들을 모아봤다.

---

**useCallback – 함수를 기억하고 싶을 때**

  

컴포넌트가 리렌더링될 때마다 내부에 있는 함수도 새로 만들어진다.

대부분의 경우엔 큰 문제가 없지만, 그 함수를 **props로 자식 컴포넌트에 넘기는 경우**에는 문제가 생길 수 있다.

```
import { useCallback, useState } from "react";

function Child({ onClick }: { onClick: () => void }) {
  console.log("Child 렌더링");
  return <button onClick={onClick}>클릭</button>;
}

export default function Parent() {
  const [count, setCount] = useState(0);

  const handleClick = useCallback(() => {
    console.log("Clicked!");
  }, []); // 의존성 배열이 없으면 한 번만 만들어짐

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
      <Child onClick={handleClick} />
    </div>
  );
}
```

• useCallback은 함수가 **의존성 배열이 바뀌지 않는 한 재사용**되도록 만든다.

• 자식 컴포넌트가 React.memo로 감싸져 있을 때 유용하다.

---

**useMemo – 값을 기억하고 싶을 때**

  

리렌더링될 때마다 다시 계산되는 값이 있을 때,

**계산 비용이 크거나, 이전 값으로 재활용할 수 있다면 useMemo를 쓴다.**

```
import { useMemo, useState } from "react";

export default function ExpensiveCalc() {
  const [count, setCount] = useState(0);
  const [toggle, setToggle] = useState(false);

  const expensiveValue = useMemo(() => {
    console.log("🧮 복잡한 계산 실행");
    return count * 2;
  }, [count]);

  return (
    <div>
      <p>계산된 값: {expensiveValue}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
      <button onClick={() => setToggle(prev => !prev)}>토글</button>
    </div>
  );
}
```