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

한 개 이상의 항의 합으로 이루어진 다항식을 동류항끼리 계산해 결과값을 문자열로 구하기


```js
function solution(polynomial) {
    const arr = polynomial.split(' + ');
    
    const x_sum = arr
        .filter(v => v.includes('x'))
        .map(v => parseInt(v.replace('x', '')) || 1)
        .reduce((a, c) => a + c, 0);
    
    const constant_sum = arr
        .filter(v => !v.includes('x'))
        .reduce((a, c) => a + parseInt(c), 0);
    
    const answer = [];
    x_sum && answer.push(x_sum === 1 ? 'x' : `${x_sum}x`);
    constant_sum && answer.push(constant_sum);
    
    return answer.join(' + ');
}
```



---
### 안전지대

지뢰는 2차원 배열 board에 1로 표시되어 있고 지뢰에 인접한 위, 아래, 좌, 우 대각선 칸을 모두 위험지역으로 분류.
지뢰가 매설된 지역의 지도 board가 매개변수로 주어질 때, 안전한 지역의 칸 수 구하기

```js
function solution(board) { 
	const n = board.length; 
	const d = [ 
		[0,0], //self
		[0,-1], // 좌
		[0,1], // 우
		[-1,-1], // 좌측 대각선 위
		[-1,0], //위
		[-1,1], //우측 대각선 위
		[1,-1], // 좌측 대각선 아래
		[1,0], // 아래
		[1,1], // 우측 대각선 아래
	]; // Set으로 위험지역을 1로 변환(Set => 중복 제거)
	let dangerZone = new Set(); 
	for (let i = 0; i < n; i++) { 
		for (let j = 0; j < n; j++) { 
		if (board[i][j] === 1) { 
			d.forEach(v => {
				let [col, row] = [i + v[0], j + v[1]];
				if (col >= 0 && col < n && row >= 0 && row < n) {
				 dangerZone.add(col+" "+row);
				} 
			}) 
		 } 
	 } 
	} 
	return n * n - dangerZone.size;
}
```



---
###  겹치는 선분의 길이

세 선분의 시작과 끝 좌표가 `[[start, end], [start, end], [start, end]]` 형태로 들어있는 2차원 배열 lines가 매개변수로 주어질 때, 두 개 이상의 선분이 겹치는 부분의 길이 구하기

```js
function solution(lines) { 
	let line = new Array(200).fill(0);
	lines.forEach(([min, max]) => { 
		for(; min < max; min++) { 
			line[min+100]++; //음수도 고려
		} 
	});
	return line.filter(v => v > 1).length; 
}
```



---
### 구글 입사문제 중에서

1부터 10,000까지 8이 총 몇번 나오는지 구하기

```js
function solution() { 
	return Array(10000).fill(0).map((v, i) => i).toString().split('').filter(v => v === '8').length;
}
```



---
### 다음 입사문제 중에서

1차원의 정렬된 점들이 주어졌을 때, 그 중 가장 거리가 짧은 것의 쌍을 출력하기

```js
// s = [1, 3, 4, 8, 13, 17, 20]
function solution(s) { 
	let index = 0;
	let minim = Infinity;
	for(let i = 1; i < s.length; i++) { 
		if(s[i] - s[i - 1] < minim) { 
			index = i;
			min = s[i] - s[i - 1];
		} 
	} 
	return [s[index], s[index - 1]]
}
```

```js
// s = [1, 3, 4, 8, 13, 17, 20]
function solution(s) { 
	const ss = s.slice(1);
	return s.map((v, i) => [v, ss[i]]).sort((a, b) => (a[1] - a[0]) - (b[1] - b[0]))[0];
}
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

