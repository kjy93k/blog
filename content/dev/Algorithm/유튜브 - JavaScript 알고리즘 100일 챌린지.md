---
tags:
  - 개발
  - 알고리즘
---
## 1일차
정수 num1, num2가 주어질 때 몫만 반환.
실수 나오는 것을 방지하려 Math.floor 또는 ~~ 비트 연산 사용

```js
function solution(num1, num2) {
  return ~~(num1 / num2);
  // return Math.floor(num1 / num2);

}
```
