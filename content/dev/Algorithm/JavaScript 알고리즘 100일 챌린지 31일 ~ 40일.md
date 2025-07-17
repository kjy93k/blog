---
tags:
  - 개발
  - 알고리즘
  - 제주코딩베이스캠프
date: 2025-07-17T14:51:00
---
##  제주코딩베이스캠프 유튜브 - JavaScript 알고리즘 100일 챌린지


### 등수 매기기

영어 점수와 수학 점수를 담은 2차원 정수 배열 score가 주어질 때, 영어 점수와 수학 점수의 평균을 기준으로 매긴 등수를 담은 배열 구하기

```js
function solution(score) {
	let sum = score.map(v => v[0] + v[1]);
	// sort는 원본배열을 수정
	let sortedArray = sum.slice().sort((a, b) => b - a);
	return sum.map(v => sortedArray.indexOf(v) + 1); // 등수는 1부터
}
```



---
### 저주의 숫자 3

정수 n이 매개변수로 주어질 때, n을 3x마을에서 사용하는 숫자로 바꿔 return하기

```js

```



---
### 


```js

```



---
### 


```js

```



---
### 


```js

```



---
### 


```js

```



---
### 


```js

```



---
### 


```js

```



---
### 


```js

```



---
### 


```js

```



---

