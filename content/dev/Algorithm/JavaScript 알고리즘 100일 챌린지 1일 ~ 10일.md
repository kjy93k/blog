---
tags:
  - 개발
  - 알고리즘
  - 제주코딩베이스캠프
date: 2025-06-21T21:53:00
---
##  제주코딩베이스캠프 유튜브 - JavaScript 알고리즘 100일 챌린지


### 몫 구하기

정수 num1, num2가 주어질 때 몫 구하기
Math.floor 또는 ~~ 비트 연산 사용하여 실수가 나오지 않도록 함

```js
function solution(num1, num2) {
  return ~~(num1 / num2);
  // return Math.floor(num1 / num2);

}
```

---
### 두 수 비교하기

num1과 num2가 같으면 1, 아니면 -1 반환
```js
function solution(num1, num2) {

  return num1 === num2 ? 1 : -1;

}
```

---
### 나이 계산

2022를 기준으로 age가 주어졌을 때 출생 연도 구하기

```js
function solution(age) {

  return 2023 - age;

}
```

---

### 각도기
각도 angle에 따라 1(예각), 2(직각), 3(둔각), 4(평각) 반환

```js

function solution(angle) {

  if (angle < 90) return 1;

  else if (angle === 90) return 2;

  else if (angle < 180) return 3;

  else return 4;

}
```

---

### 양꼬치

양꼬치 10개당 음료 1개 서비스
총 가격 구하기

양꼬치 = 12,000원
음료 = 2,000원

```js
function solution(n, k) {
	if (n >= 10) {
		k -= ~~(n / 10)
	}
  return 12000 * n  + 2000 * k;
}
```

---

### 짝수의 합

1부터 n까지 짝수만 더하기
```js
function solution(n) { 
	return Array(n).fill().map((_, index) => index + 1).filter(v => v % 2 === 0).reduce((a, c) => a + c, 0);
}
```

---
### 배열의 평균값

numbers의 원소의 평균값을 구하기

```js
function solution(numbers) { 
	return numbers.reduce((a,c)=> a + c, 0) / numbers.length; 
}
```

---

### 머쓱이보다 키 큰 사람

머쓱이네 반 친구들의 키가 담긴 정수 배열 array와 머쓱이의 키 height가 매개변수로 주어질 때, 
머쓱이보다 키 큰 사람 수 구하기

```js
function solution(array, height) {    
    return array.filter( v => v > height).length;
}
```

---

### 중복된 숫자 개수

정수가 담긴 배열 array와 정수 n이 매개변수로 주어질 때, 
array에 n이 몇 개 있는 지 구하기

```js
function solution(array, n) { 
	return array.filter( v => v === n).length; 
}
```

---

### 피자 나눠먹기(1)

7조각으로 나누어진 피자
피자를 나눠먹을 사람의 수 n이 주어질 때, 모든 사람이 피자를 한 조각 이상 먹기 위해 필요한 피자의 수 구하기

```js
function solution(n) { 
if(n / 7 === ~~(n / 7)) { 
	return n / 7; 
	} 
return ~~(n / 7) + 1;
}
```

```js
function solution(n) { 
	return Math.ceil(n / 7); 
}
```

---

### 짝수 홀수 개수

정수가 담긴 리스트 num_list가 주어질 때, 
num_list의 원소 중 짝수와 홀수의 개수를 담은 배열 구하기

```js
function solution(num_list) { 
	var answer = [0, 0]; 
	for (let item of num_list) { 
		// if (item % 2 == 0) { 
		// answer[0] += 1; 
		// } else { 
		// answer[1] += 1; 
		// } 
		answer[item % 2] += 1;
	} 
	return answer; 
}
```