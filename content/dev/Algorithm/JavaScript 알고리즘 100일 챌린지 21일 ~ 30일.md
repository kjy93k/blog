---
tags:
  - 개발
  - 알고리즘
  - 제주코딩베이스캠프
date: 2025-07-04T21:53:00
---
##  제주코딩베이스캠프 유튜브 - JavaScript 알고리즘 100일 챌린지


### 팩토리얼
i팩토리얼 (i!)은 1부터 i까지 정수의 곱
ex) 5! = 5 * 4 * 3 * 2 * 1 = 120 

정수 n이 주어질 때 다음 조건을 만족하는 가장 큰 정수 i를 구하기


```js
function solution(n) {
	let i = 1;
	let factorial = 1;
	while (factorial <= n) {
		i += 1;
		factorial *= i;
	} 
	// factorial === n일경우도 실행되기때문에 i-1 리턴
	return i -  1; 
}
```



---

### k의 개수
정수 i, j, k가 매개변수로 주어질 때, i부터 j까지 k가 몇 번 등장하는지 구하기
ex)k = 1 일때 10에서 1개, 11에서 2개, 12에서 1개, 13에서 1개 총 6번


```js
function solution(i, j, k) {
	//i = 1, j = 13, k = 1
	let s = '';
	for(i; i <= j; i++) {
			s+=i
	}
	
	return s
	// 12345678910111213
	.split(k)
	//["","23456789","0","","","2","3"] 
	.length // 7
	.length - 1; // 6
}
```

또는 

```js
function solution(i, j, k) {
	//i = 1, j = 13, k = 1
	return Array(j - i + 1)
	// i부터 j까지 갯수의 empty Array 생성
	.fill(i) // [1, ..., 1]
	.map((v, idx) => v + idx) // [1, ..., 13]
	.join('') // "12345678910111213"
	.split(k) // filter or split
	.length - 1; // 6
}
```


---

### 가까운 수
정수 배열 array와 정수 n이 매개변수로 주어질 때, 
array에 들어있는 정수 중 n과 가장 가까운 수 구하기

단, 가장 가까운 수가 여러개일 경우 더 작은 수 return

```js
function solution(array, n) { 
	let min = Infinity;
	let result = 0;
	for (let i of array.sort()) { 
	// 
	if (Math.abs(n - i) < min) { 
		 min = Math.abs(n - i) result = i; 
		}
	}
	return result; 
 }
```



---

### 
.


```js

```



---

### 
.


```js

```



---

### 
.


```js

```



---

### 
.


```js

```



---

### 
.


```js

```



---

### 
.


```js

```



---

### 
.


```js

```



---
