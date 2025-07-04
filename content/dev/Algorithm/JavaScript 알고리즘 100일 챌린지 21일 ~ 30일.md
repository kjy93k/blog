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
	let minDiff = Infinity;
	let result = 0;
	
	array.sort((a, b) => a - b);
	
	for (let i of array) { 
	// 음수는 거리 비교를 할 수 없기때문에 절대값으로 구해야 함
	if (Math.abs(n - i) < minDiff) { 
		 minDiff = Math.abs(n - i); 
		 result = i; 
		}
	}
	return result; 
 }
```



---

### 한번만 등장한 문자
s에서 한 번만 등장하는 문자를 구하고 사전 순으로 정렬하기


```js
// split
function solution(s) {
	return [...s]
	.filter(char => s.split(char).length === 2)
	.sort()
	.join('');
}
```

```js
// 정규표현식, match
function solution(s) {    
	return [...s]
	.filter(char => s.match(new RegExp(char, 'g')).length === 1)
	// 숫자를 포함하지 않은 문자열일때만 sort() 
	.sort()
	.join('');
}
```


---

### 잘라서 배열로 저장하기
my_str을 길이 n씩 잘라서 저장한 배열 구하기


```js
function solution(my_str, n) {
	return my_str.match(new RegExp(`.{1,${n}}`, 'g'));
}
```

```js
function solution(my_str, n) {
	let result = [];
	for(let i = 0; i < my_str.length; i += n) {
		result.push(my_str.slice(i, i + n))
	}
	return result;
}
```

---

### 진료순서 정하기
정수 배열 emergency가 매개변수로 주어질 때 
응급도가 높은 순서대로 진료 순서 배열을 구하기


```js
function solution(emergency) { 
	let 응급순서 = emergency.slice().sort((a, b) => b - a);
	return emergency.map(v => 응급순서.indexOf(v) + 1);
}
```



---

### 영어가 싫어요
문자열 numbers가 매개변수로 주어질 때,  numbers를 정수로 바꾸기


```js
function solution(numbers) {
	return +numbers
		.replaceAll('zero', '0')
		.replaceAll('one', '1')
		.replaceAll('two', '2')
		.replaceAll('three', '3')
		.replaceAll('four', '4')
		.replaceAll('five', '5')
		.replaceAll('six', '6')
		.replaceAll('seven', '7')
		.replaceAll('eight', '8')
		.replaceAll('nine', '9');
}
```

```js
function solution(numbers) {
	const obj = {
		zero: 0,
		one: 1,
		two: 2,
		three: 3,
		four: 4,
		five: 5,
		six: 6,
		seven: 7,
		eight: 8,
		nine: 9,
	}
	
	return +numbers.replace(/zero|one|two|three|four|five|six|seven|eight|nine/g, (v)=> obj[v])
}
```

---

### 외계어 사전
알파벳이 담긴 배열 spell과 외계어 사전 dic이 매개변수로 주어지고, spell에 담긴 알파벳을 한번씩만 모두 사용한 단어가 dic에 존재한다면 1, 존재하지 않는다면 2를 return


```js
function solution(spell, dic) { 
	return dic.some((v) => [...v].sort().toString() === [...spell].sort().toString()) ? 1 : 2; 
}
```



---

### 문자열 밀기 
문자열 A를 오른쪽으로 반복해서 밀어 B가 될 수 있다면 최소 횟수를, 안 되면 -1을 return

```
hello -> ohell : 1 
hello -> lohel : 2 
hello -> llohe : 3
```

A * 2 에서 B의 index를 찾고 A.length - B의 index를 비교해서 구할 수도 있지만 
```
hellohello -> ohell : 4
hellohello -> lohel : 3
hellohello -> llohe : 2
```

B * 2에서 A의 index를 구할 수도 있다 
```
ohellohell -> hello : 1
lohellohel -> hello : 2
llohellohe -> hello : 3
```

```js
function solution(A, B) { 
	return (B + B).indexOf(A); 
}
```

#### 좌표 이동 관련 추가 팁

```
[0, 0, 0, 0]
[0, 1, 0, 0] // 2번째 줄 1번 인덱스의 1을
[0, 0, 0, 0] // 3번째 줄 1번 인덱스의 1로
[0, 0, 0, 0]
```

이런 경우 1차원으로 만든 후 index의 값을 찾아 바꿔주면 됨.

```
[0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
```

나 자신을 0으로 만들고,  4칸 이후에 있는 index값을 1로 바꿔주면 됨

---

### 컨트롤제트
숫자와 "Z"가 공백으로 구분되어 담긴 문자열이 s로 주어질때,  숫자를 순서대로 더하되, “Z”가 나오면 직전 숫자를 제외한 최종 합 구하기


```js
function solution(s) { 
	s = s.split(' '); 
	let result = []; 
	for(let i of s) { 
		if(i === 'Z') { 
			result.pop(); 
		} else { 
			result.push(+i); 
		} 
	} 
	return result.reduce((a, c) => a + c, 0) 
}
```

#### 비슷한 문제 풀 때 팁

```
"110Z3"
```

이렇게 주어지고 1~10까지의 숫자를 판단해야 되는 경우
1. 정규식으로 1~10를 판단해 주거나
2. 1 다음 0이 나오면 10이라는 것을 인식해 주면 됨

```js
function solution(s) { 
	s = s.split(' '); 
	let result = []; 
	for(let i of s) { 
		if(i === 'Z') { 
			result.pop(); 
		} else { 
			result.push(+i); 
			if (i === 0) {
				result.push
			} 
		} 
	} 
	return result.reduce((a, c) => a + c, 0) 
}
```
현재값이 1이고 다음값이 0일 경우 10으로 교체