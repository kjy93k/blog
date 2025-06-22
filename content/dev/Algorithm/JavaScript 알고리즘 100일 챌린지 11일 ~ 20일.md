---
tags:
  - 개발
  - 알고리즘
  - 제주코딩베이스캠프
date: 2025-06-22T21:53:00
---
##  제주코딩베이스캠프 유튜브 - JavaScript 알고리즘 100일 챌린지


### 배열 두배 만들기
정수 배열 numbers의 각 원소에 두배를 곱한 배열을 구하기


```js
function solution(numbers) {
    return numbers.map(v => v * 2);
}
```

사이트 추천: [쉽고 편하게 Mock 데이터 생성](https://generatedata.com/)

---
### 문자열 뒤집기

문자열 my_string을 거꾸로 뒤집은 문자열 구하기

```js
function solution(my_string) { 
	//return my_string.split('').reverse().join('');
	return Array.from(my_string).reverse().join(''); 
}
```

---
### 특정 문자 제거하기

my_string에서 letter를 제거한 문자열 구하기

```js
function solution(my_string, letter) { 
	// return my_string.replaceAll(letter, '');
	let reg = new RegExp(letter, 'g') // 'g': 전역에서 검사 
	return my_string.replace(reg, '') 
}
```

정규 표현식을 쓰면 좋은점
ex. 문자열에서 1, 2, 3을 지우고 싶을때
 
```js
'BCBdbe123094dr12of1j423'.replace(/[123]/g, '') 
//'BCBdbe094drofj4'
```

- /[1-9]/g : 1~9
- /[a-z]/g : a~z
- /[A-Z]/g : A~Z

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
