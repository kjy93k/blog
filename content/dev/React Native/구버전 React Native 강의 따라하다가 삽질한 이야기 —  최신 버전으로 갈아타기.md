---
tags:
  - 개발
  - 리액트네이티브
  - ReactNative
  - ReactNativeCLI
date: 2025-06-20T16:57:00
---
React Native CLI 강의를 그대로 따라하다가 예상치 못한 문제가 생겼다.

구버전 Ruby, CocoaPods, React Native CLI를 억지로 맞추다 보니 호환이 되지 않았다.

  

Expo로 작업할 땐 없던 버전 충돌.

댓글엔 포기한 사람도 많았지만 직접 해결해두면 나중에도 비슷한 상황에서 덜 헤맬 것 같았다.

  

결국 하루를 버전 맞추기에 쏟고 나서야 깨달았다.

애써 구버전을 맞춰도 결국 최신 버전만 지원하는 상황을 또 마주칠 수 있다.

처음부터 최신 버전에 맞춰서 작업하는 게 훨씬 낫다.

단 이건 강의를 보고 따라하는 실습이기때문에 가능한 선택..!


**실제 프로젝트라면...**

- **버전을 함부로 올리지 않는다.**
    
    기존 코드, 네이티브 모듈, 빌드 스크립트 호환성을 꼭 확인해야 한다.
    
- **버전 업그레이드는 단계적으로 한다.**
    
    한 번에 큰 버전을 올리면 에러가 폭발한다. React Native는 마이너 단위로 조금씩 올려가면서 테스트한다.
    
- **공식 업그레이드 가이드 활용**
    
    react-native upgrade 혹은 [React Native Upgrade Helper](https://react-native-community.github.io/upgrade-helper/)를 사용해 변경점을 비교한다.
    
- **CI/CD 파이프라인에서 사전에 빌드 확인**
    
    로컬에서만 돌려보고 배포하면 서버나 스토어 빌드에서 터질 수 있다.
    
- **팀 내에서 버전 호환 정책을 문서화**
    
    새로 모듈 추가할 때 팀원들이 각자 버전을 따로 쓰지 않도록 가이드라인을 만든다.
    


---

### **상황 정리**

  

**강의 권장 환경**

- Ruby 2.7.x
    
- CocoaPods 1.11.x (Ruby 2.7.x에서만 사용 가능)
    
- React Native CLI (npx react-native init)
    
- 실행: yarn start 후 i 키로 iOS 시뮬레이터 실행
    

  

**현재 환경 (2024 기준)**

- Ruby 2.7.x는 지원 종료(EOL)
    
- 최신 CocoaPods와 React Native는 Ruby 3.2.x 이상 필요
    
- CLI 구조가 바뀌어 init 명령어는 deprecated
    
- Metro Bundler 키보드 단축키는 사라짐 → run-ios로 실행
    

  

결과적으로, 강의 방식 그대로는 빌드가 되지 않는다.

---

### **꼬였던 지점**

1. 구버전 Ruby 설치
    
    - 최신 CocoaPods, React Native에서 요구 버전 미달
        
    - activesupport NameError
        
    - Logger 오류
        
    - xcconfig 파일 누락
    
2. CLI 구조 변경
    
    - npx react-native init → 더 이상 사용하지 않음
        
    - npx @react-native-community/cli init로 대체
    
3. Metro Bundler 단축키 변경
    
    - 예전엔 `yarn start` 후  `i`  키로 시뮬레이터  실행
     (현재는 Key commands available에서 i 키가 사라짐)
        
    - 현재는 `npx react-native run-ios` 로 실행
  

---

### **해결 방법**

  

강의 버전에 얽매이지 않고 Ruby, Node, CocoaPods, React Native를 최신으로 맞췄다.

- Ruby: LTS (예: 3.2.x)
    
- Node: LTS (nvm 사용)
    
- CocoaPods: 최신 (gem install cocoapods)
    
- React Native: npx @react-native-community/cli init


---

### **작업하면서 얻은 교훈**

- 강의 버전이 오래됐다면 먼저 공식 문서를 본다.
    
- React Native는 버전 차이로 의존성 충돌이 쉽게 생긴다.
    
- 빌드 오류가 나면 node_modules, Pods, DerivedData를 다 지우고 다시 설치한다.

```bash
rm -rf node_modules
npm install
cd ios

// 기존 Pod 의존성 폴더 제거, 고정된 Pod 버전 정보 제거, 이전 Xcode 빌드 캐시 제거 
rm -rf Pods Podfile.lock build  

pod install --repo-update 
// pod install은 iOS 네이티브 의존성을 맞출 때만 필요

cd ..
```

- iOS는 .xcworkspace로 열어야 한다. .xcodeproj로 열면 CocoaPods가 안 붙는다.

---

### **최신 실행 흐름**

```bash
npx @react-native-community/cli init MyApp --version latest

npm install  # 또는 yarn install
```

####  ios 시뮬레이터 실행

```bash
npx react-native run-ios 
# 혹은 yarn ios
```

⚡️  **No script URL provided. 에러가 뜨는 경우**

run-ios 명령어로 JavaScript 번들 서버(Metro)가 자동으로 안 켜질 때가 있다.
**이럴 땐 터미널 하나 더 열어서 아래 명령어 실행하기:**

```bash
npx react-native start 
# 혹은 yarn start
```


React Native 0.70 이상부터는 console.log가 Metro 터미널에 안 찍힌다.
대신 Metro  start한 터미널에서 j 누르면 Chrome DevTools로 디버깅 가능하다.

| **터미널 1**              | **터미널 2**                |
| ---------------------- | ------------------------ |
| npx react-native start | npx react-native run-ios |
이렇게 터미널 두 개 나눠서 돌리는 게 제일 깔끔하고 안정적이다.


**+**

나는 터미널 두개 쓰기 싫고 디버깅 안한다.
그냥 단축키 하나로 끝내겠다 싶으면 (오...진짜?)
 
 package.json 의 android와 ios를 아래처럼 수정 후 
 
```json
"scripts": {
	"android": "yarn start & react-native run-android",
	"ios": "yarn start & react-native run-ios",
}
```

아래 코드를 실행 

```bash
yarn ios
```

단, 이렇게 하면 j 같은 단축키는 안 먹히니까
DevTools는 npx react-devtools로 따로 켜야 한다는 거만 기억해두기.

---

### **앞으로의 다짐**

  
앞으로는 강의 코드를 무조건 그대로 따라가지 않는다.

먼저 공식 문서를 확인하고 내 환경에 맞게 수정해서 쓴다.

이런 삽질이 결국엔 실력으로 남는다. (제발 글로 남기자)

---

### **참고**

- [React Native 공식 환경 설정](https://reactnative.dev/docs/environment-setup)
    
- [NVM](https://github.com/nvm-sh/nvm)
    
- [CocoaPods](https://cocoapods.org/)