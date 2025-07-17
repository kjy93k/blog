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

| 10진법   | 3x 마을에서 쓰는 숫자       |
| ------ | ------------------- |
| 1      | 1                   |
| 2      | 2                   |
| 3      | 4                   |
| 4      | 5                   |
| 5      | 7                   |
| 6      | 8                   |
| 7      | 10                  |
| 8      | 11                  |
| 9      | 14                  |
| 10     | 16                  |


```js
function solution(n) { 
	let answer = 0; 
	for(let _ = 0; _ < n; _++) { 
		answer += 1;
		while(answer % 3 == 0 || answer.toString().split('').includes('3')) {
			answer += 1 
		} 
	} 
	return answer; 
}
```

```js
function solution(n) { 
	let arr = []; 
	for(let i = 1; i < 1000; i++) { // i < n의 범위보다 큰 수
		if(i % 3 !== 0 && !i.toString().split('').includes('3')) {
			arr.push(i) 
		} 
	} 
	return arr[n - 1]; 
}
```



---
### 다항식 더하기

한 개 이상의 항의 합으로 이루어진 다항식을 동류항끼리 계산해 정리.
덧셈으로 이루어진 다항식이 매개변수로 주어질 때, 동류항끼리 더한 결과값을 문자열로 구하기

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

