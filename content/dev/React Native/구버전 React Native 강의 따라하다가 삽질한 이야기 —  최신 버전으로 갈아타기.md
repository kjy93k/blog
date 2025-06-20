---
tags:
  - 개발
  - 리액트네이티브
  - ReactNative
  - ReactNativeCLI
date: 2025-06-20T16:57:00
---
### **들어가며**

  

React Native CLI 강의를 그대로 따라하다가 예상치 못한 문제가 생겼다.

구버전 Ruby, CocoaPods, React Native CLI를 억지로 맞추다 보니 호환이 되지 않았다.

  

Expo로 작업할 땐 없던 버전 충돌.

댓글엔 포기한 사람도 많았지만 직접 해결해두면 나중에도 비슷한 상황에서 덜 헤맬 것 같았다.

  

결국 하루를 버전 맞추기에 쏟고 나서야 깨달았다.

지금은 최신 버전에 맞춰 작업하는 게 훨씬 낫다.

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
    
    - 예전엔 yarn start 후 i 키 실행
        
    - 현재는 npx react-native run-ios 필요
        
    

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

```
rm -rf node_modules
npm install
cd ios

// 기존 Pod 의존성 폴더 제거, 고정된 Pod 버전 정보 제거, 이전 Xcode 빌드 캐시 제거 
rm -rf Pods Podfile.lock build  
pod install --repo-update // pod install은 iOS 네이티브 의존성을 맞출 때만 필요

cd ..
```

- iOS는 .xcworkspace로 열어야 한다. .xcodeproj로 열면 CocoaPods가 안 붙는다.

---

### **최신 실행 흐름**

```
npx @react-native-community/cli init MyApp --version latest

npm install  # 또는 yarn install

npx react-native run-ios 
```
---

### **앞으로의 다짐**

  
앞으로는 강의 코드를 무조건 그대로 따라가지 않는다.

먼저 공식 문서를 확인하고 내 환경에 맞게 수정해서 쓴다.

이런 삽질이 결국엔 실력으로 남는다.

---

### **참고**

- [React Native 공식 환경 설정](https://reactnative.dev/docs/environment-setup)
    
- [NVM](https://github.com/nvm-sh/nvm)
    
- [CocoaPods](https://cocoapods.org/)