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
    console.log("복잡한 계산 실행");
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

• useMemo는 결과값을 기억한다.

• 의존성 배열이 바뀌지 않으면 **이전 결과를 그대로 반환**한다.

---

**useContext – 컴포넌트 트리 전역으로 데이터 전달**

  

React에서는 props를 계속 아래로 넘기지 않고,

**공통 데이터나 상태를 Context로 공유**할 수 있다.

```
import { createContext, useContext } from "react";

const ThemeContext = createContext("light");

function Child() {
  const theme = useContext(ThemeContext);
  return <div>현재 테마: {theme}</div>;
}

export default function App() {
  return (
    <ThemeContext.Provider value="dark">
      <Child />
    </ThemeContext.Provider>
  );
}
```

전역 테마나 사용자 정보처럼,

여러 컴포넌트가 동일한 값을 사용해야 할 때 자주 활용된다.

---

하지만 실무에서는 이보다 더 복잡한 구조에서 유용하게 쓰이는 경우가 많다.

대표적으로 **Compound Component 패턴**에서 내부 구성 요소들끼리 상태를 공유할 때,

context는 거의 필수처럼 사용된다.

  

지금은 App Router 환경에서 use client가 필요한 컴포넌트에만 context 사용이 권장된다.

사용 전, 정말 이곳에서 context를 써야 하는지 고민이 필요한 시점이다.

하지만 Page Router에서 개발할 때는 정말 애정하던 Hook이었다.

Compound 구조를 만들면서 자식 컴포넌트들끼리 상태를 나눌 수 있다는 점이 가장 큰 장점이었다.

---

**예: Compound Component 형태의 Counter**

```
<Counter initialValue={1}>
  <Counter.Decrement />
  <Counter.Count />
  <Counter.Increment />
  <Counter.Description />
</Counter>
```

```
const CounterContext = createContext(null);

export const useCounterContext = () => {
  const context = useContext(CounterContext);
  if (!context) throw new Error("Counter 컴포넌트 내부에서만 사용할 수 있습니다.");
  return context;
};

const Counter = ({ children, initialValue = 0 }) => {
  const [count, setCount] = useState(initialValue);
  const increment = () => setCount(c => c + 1);
  const decrement = () => setCount(c => Math.max(0, c - 1));

  return (
    <CounterContext.Provider value={{ count, increment, decrement }}>
      <div>{children}</div>
    </CounterContext.Provider>
  );
};

Counter.Count = () => {
  const { count } = useCounterContext();
  return <span>{count}</span>;
};

Counter.Increment = () => {
  const { increment } = useCounterContext();
  return <button onClick={increment}>+</button>;
};

Counter.Decrement = () => {
  const { decrement } = useCounterContext();
  return <button onClick={decrement}>-</button>;
};

Counter.Description = () => {
  const { count } = useCounterContext();
  return <p>현재 카운트는 {count}입니다.</p>;
};
```