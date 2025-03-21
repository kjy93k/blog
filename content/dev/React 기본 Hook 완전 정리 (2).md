---
tags:
  - React
  - Hooks
  - useCallback
  - useMemo
  - useContext
  - CompoundComponent
  - useReducer
  - useLayoutEffect
  - 리액트성능최적화
  - 리액트구조
  - ContextAPI
  - 리액트컴포넌트패턴
date: 2025-03-21T18:41:31+09:00
---

**useCallback, useMemo, useContext, useReducer, useLayoutEffect**

앞선 글에서는 useState, useEffect, useRef처럼

리액트를 처음 시작할 때 마주치는 기본적인 Hook들을 정리했다.

이번에는 조금 더 **구조적인 관리나 퍼포먼스, 렌더링 시점 제어**에 관련된 Hook들을 모아봤다.

---

## **useCallback – 함수를 기억하고 싶을 때**

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

## **useMemo – 값을 기억하고 싶을 때**

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

## **useContext – 컴포넌트 트리 전역으로 데이터 전달**

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

App Router 환경에서는 use client가 필요한 컴포넌트에만 context 사용이 권장되지만,

리렌더링이 많지 않거나 구조적으로 context가 더 적합한 경우에는 여전히 사용하기 좋은 친구다.

굉장히 애정하는 Hook이라 자세히 다뤄보자면..!

---

### **예: Compound Component 형태의 Counter**

```
<Counter initialValue={1} min={0} max={10000}>
  <Counter.Decrement />
  <Counter.Count />
  <Counter.Increment />
  <Counter.Description />
</Counter>
```

각 버튼과 텍스트가 분리되어 있음에도,

내부적으로는 하나의 context를 통해 상태와 핸들러를 공유한다.

```
const CounterContext = createContext(null);

export const useCounterContext = () => {
  const context = useContext(CounterContext);
  if (!context) throw new Error("Counter 컴포넌트 내부에서만 사용할 수 있습니다.");
  return context;
};

const Counter = ({ children, initialValue = 0, min = 0, max = 10000 }) => {
  const [count, setCount] = useState(() => {
    if (initialValue < min) return min;
    if (initialValue > max) return max;
    return initialValue;
  });

  const increment = () => setCount(prev => (prev + 1 > max ? prev : prev + 1));
  const decrement = () => setCount(prev => (prev - 1 < min ? prev : prev - 1));

  return (
    <CounterContext.Provider value={{ count, increment, decrement, min, max }}>
      <div>{children}</div>
    </CounterContext.Provider>
  );
};

Counter.Count = () => {
  const { count } = useCounterContext();
  return <span>{count}</span>;
};

Counter.Increment = () => {
  const { increment, count, max } = useCounterContext();
  return (
    <button onClick={increment} disabled={count >= max}>
      +
    </button>
  );
};

Counter.Decrement = () => {
  const { decrement, count, min } = useCounterContext();
  return (
    <button onClick={decrement} disabled={count <= min}>
      -
    </button>
  );
};

Counter.Description = () => {
  const { count, min, max } = useCounterContext();
  return <p>{min}부터 {max}까지, 현재 값은 {count}입니다.</p>;
};
```

이 구조는 UI 요소들을 독립적으로 정의하면서도

중앙 상태(count, min, max)를 쉽게 공유할 수 있게 해준다.

복잡한 props 전달 없이도 구조를 깔끔하게 유지할 수 있다는 점에서,

Compound Component 패턴과 context의 조합은 여전히 유효하다.

---

## **useReducer – 상태가 복잡할 때 쓰는 useState**

useState는 단순한 값 관리에는 편리하지만,

여러 상태가 함께 엮여 있거나, 상태 업데이트 로직이 복잡한 경우에는 useReducer가 더 적합하다.

```
import { useReducer } from "react";

function reducer(state: number, action: "increment" | "decrement") {
  switch (action) {
    case "increment":
      return state + 1;
    case "decrement":
      return state - 1;
    default:
      return state;
  }
}

export default function Counter() {
  const [count, dispatch] = useReducer(reducer, 0);

  return (
    <>
      <p>{count}</p>
      <button onClick={() => dispatch("increment")}>+1</button>
      <button onClick={() => dispatch("decrement")}>-1</button>
    </>
  );
}
```

• dispatch(action)을 통해 상태를 업데이트

• switch 문이 많아지면 번거롭지만, 상태가 구조화되어 있는 경우에는 훨씬 명확하다

---

## **useLayoutEffect – 화면에 그려지기 전에 미리 처리해야 할 일이 있을 때**

useEffect는 렌더링이 끝난 후 실행되지만,

**화면에 보이기 전에 꼭 처리해야 하는 작업**이라면 useLayoutEffect를 써야 한다.

예를 들어, 다음과 같은 경우에 유용하다:

• **input 자동 포커스**: 화면이 깜빡이기 전에 포커스를 맞춰야 할 때

• **스크롤 위치 고정**: 모달을 띄우면서 배경 스크롤을 잠가야 할 때

• **위치 기반 UI 조정**: 드롭다운이나 툴팁의 위치를 버튼 기준으로 계산할 때

```
useLayoutEffect(() => {
  inputRef.current?.focus();
}, []);
```

```
useLayoutEffect(() => {
  const scrollY = window.scrollY;
  document.body.style.position = "fixed";
  document.body.style.top = `-${scrollY}px`;

  return () => {
    document.body.style.position = "";
    document.body.style.top = "";
    window.scrollTo(0, scrollY);
  };
}, []);
```

이런 작업들은

렌더링이 끝난 뒤에 처리하면 **깜빡임이 생기거나 순간적으로 이상한 위치에 렌더링**되기 때문에

useLayoutEffect처럼 **렌더 직전에 실행되는 Hook**이 더 적합하다.

---

## **정리**

| **Hook**        | **언제 쓰나**                                     | **특징**                        |
| --------------- | ------------------------------------------------- | ------------------------------- |
| useCallback     | 함수 재생성을 피하고 싶을 때                      | 의존성 배열 기준으로 기억       |
| useMemo         | 계산 결과를 기억하고 싶을 때                      | 렌더링 최적화                   |
| useContext      | 트리 내부 컴포넌트끼리 상태를 공유하고 싶을 때    | props 없이 자연스럽게 연결 가능 |
| useReducer      | 복잡한 상태 관리                                  | 액션 기반으로 분리된 상태 처리  |
| useLayoutEffect | 화면 그리기 전에 DOM 정보를 쓰거나 조작해야 할 때 | useEffect보다 빠름              |

---

다음 글에서는

**React 18에서 추가된 Hook들과 UI 제어**에 대한 내용을 이어서 정리할 예정입니다.

(useTransition, useDeferredValue, useId 등)
