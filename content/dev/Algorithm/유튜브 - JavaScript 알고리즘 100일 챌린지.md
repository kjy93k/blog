---
tags:
  - 개발
  - 알고리즘
---
## 1일차

### 몫 구하기

정수 num1, num2가 주어질 때 몫만 반환

실수 나오는 것을 방지하려 Math.floor 또는 ~~ 비트 연산 사용

```js
function solution(num1, num2) {
  return ~~(num1 / num2);
  // return Math.floor(num1 / num2);

}
```

### 두 수 비교하기

num1 === num2이면 1, 아니면 -1 반환
```js
function solution(num1, num2) {

  return num1 === num2 ? 1 : -1;

}
```

---
## 2일차
### 나이 계산

2022를 기준으로 age가 주어졌을 때 출생 연도 구하기

```js
function solution(age) {

  return 2023 - age;

}
```