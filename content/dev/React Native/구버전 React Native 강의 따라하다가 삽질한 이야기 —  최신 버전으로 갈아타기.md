### **들어가며**

최근에 React Native CLI 강의를 새로 들으면서 그대로 따라하다가 큰 문제를 만났다.

핵심은 이제는 돌아가지 않는 구버전 Ruby, CocoaPods, React Native CLI를 억지로 쓰려다가 호환성 문제가 터진 것이다. 

확실히 React Native Expo에선 만날 수 없었던 버전 이슈...! 
댓글들엔 다들 강의 포기선언이 잔뜩이라 들을까 말까 고민했지만 앱을 빠르게 경험하고자 한 선택이고 나중에도 마주칠 문제라고 생각해서 문제를 해결해보기로했다.

지금의 버전이랑 너무 차이가 있어서 최신버전으로 작업을 하는게 낫지 않을까 싶어 버전을 맞춰서 작업해보는게 이후에도 좋을 것이라고 생각해서 버전을 맞춰서 작업해보기로 했다.

강의대로 버전을 맞추려다가 하루 종일 삽질하고, 다 지우고, 최신 버전으로 환경을 재정비한 뒤에야 제대로 돌아갔다.

비슷한 상황에 있는 분들을 위해 기록을 남긴다.

---

### **상황 요약**

  

강의에서 권장한 환경

- Ruby 2.7.x
    
- CocoaPods 1.11.x (이건 강의에서 권장했다기보단 Ruby 2.7.x가 이 밑으로만 동작했다.)
    
- React Native CLI → npx react-native init
    
- 실행 방법: yarn start 후 i 키로 iOS 시뮬레이터 실행
    

  

현실 (2024 이후)

- Ruby 2.7.x는 이제 공식 지원 종료됨 (End of Life)
    
- 최신 CocoaPods, React Native는 Ruby 3.2.x 이상 필요
    
- React Native CLI 구조가 바뀌어 init 명령어가 deprecated
    
- Metro Bundler의 키보드 커맨드(i, a) 기능도 사라지고 run-ios를 별도로 실행해야 함
    

  

결과적으로 강의에서 알려준 방법으로는 더 이상 빌드가 불가능하다.

---

### **꼬였던 지점**

1. 구버전 Ruby 강제로 설치 → 최신 CocoaPods와 React Native에서 요구하는 최소 버전에 미달
    
    - pod install 도중 activesupport 관련 NameError 발생
        
    - Logger 관련 오류
        
    - xcconfig 파일을 찾지 못함
        
    
2. React Native CLI 구조가 변경됨
    
    - npx react-native init 명령어는 이제 deprecated
        
    - npx @react-native-community/cli init 을 사용해야 함
        
    
3. Metro Bundler 키보드 명령 변화
    
    - 예전에는 yarn start 후 i 키로 iOS 실행 가능
        
    - 지금은 별도로 npx react-native run-ios 로 빌드 실행해야 함
        
    

---

### **선택한 해결책**

  

강의를 무리하게 그대로 따라가지 않고, Ruby, Node, CocoaPods, React Native 모두 최신 버전으로 갈아엎기로 했다.

  

최종 선택

- Ruby: 최신 LTS (3.2.x)
    
- Node: 최신 LTS (nvm으로 관리)
    
- CocoaPods: 최신 버전 (gem install cocoapods)
    
- React Native: 최신 CLI (npx @react-native-community/cli init)
    

---

### **헤매며 배운 교훈**

- 강의가 구버전이면 일단 의심하고 공식 문서를 먼저 참고할 것
    
- React Native 환경은 작은 버전 차이로도 의존성 충돌이 생기기 쉽다
    
- 빌드 오류가 나면 node_modules, Pods, DerivedData를 모두 지우고 다시 설치해야 한다
    

  

예시
```
rm -rf node_modules
npm install
cd ios
rm -rf Pods Podfile.lock build
pod install --repo-update
```
- 빌드는 반드시 .xcworkspace 로 열어야 한다
    
    (.xcodeproj 로 열면 CocoaPods가 연결되지 않는다)
    

---

### **최신 실행 플로우**
```
npx @react-native-community/cli init MyApp --version latest

npm install  # 또는 yarn install

cd ios
pod install --repo-update

npx react-native start  # 첫 번째 터미널

npx react-native run-ios  # 두 번째 터미널
```
---

### **앞으로의 다짐**

  

이번 삽질을 통해 깨달았다. 강의 내용을 그대로 따라가면 앞으로도 버전 호환 문제는 무조건 발생할 수밖에 없다.

따라서 앞으로는 강의 코드를 복사하기 전에 먼저 공식 문서를 확인하고, 현재 사용하는 React Native, Node, Ruby, CocoaPods 버전에 맞게 직접 수정해서 쓸 것이다.

이 과정 자체가 좋은 연습이자 실력 향상으로 이어질 거라 생각한다.

---

### **참고 링크**

- React Native 공식 환경 설정: https://reactnative.dev/docs/environment-setup
    
- NVM 공식: https://github.com/nvm-sh/nvm
    
- CocoaPods 공식: https://cocoapods.org/
    

---

## **끝**

  

혹시 이 글이 도움이 되셨다면 댓글이나 피드백 환영합니다.

나중에 비슷한 삽질을 방지하는 데 작은 도움이 되길 바라며 기록을 마친다.