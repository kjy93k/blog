---
description: 버전 지옥 탈출기 & 성공적 연동 경험담
date: 2025-06-28T17:08:00
tags:
  - ReactNative
  - ReactNativeCLI
  - GoogleMaps
  - ReactNativeMaps
  - 버전이슈
  - Fix
---
### **시작은 가볍게**

  

맛집 지도 앱을 만들면서 Google Maps를 붙이기로 했다.

react-native-maps 라이브러리를 쓰면 되는 줄 알고 가볍게 시작했다.

  

하지만, 예상대로(?) 쉽게 되지는 않았다.

---

### **Swift 환경부터 발목 잡기**

  

공식 문서에는 AppDelegate.mm 파일을 수정하라고 나와 있었는데,

내 프로젝트는 AppDelegate.swift를 사용하고 있었다.

  

그래서 직접 구글링하면서 문법을 맞춰봤다.

```objc
// 공식 문서
#import <GoogleMaps/GoogleMaps.h>
[GMSServices provideAPIKey:@"YOUR_GOOGLE_MAPS_API_KEY"];
```

Swift에서는 이렇게 바꿨다:
```swift
import GoogleMaps
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```
---

### **Podfile 수정도 한참**

  

iOS 설정을 위해 Podfile에 이런 걸 추가하라고 했다:

```ruby
rn_maps_path = '../node_modules/react-native-maps'
pod 'react-native-maps/Google', :path => rn_maps_path
```

삽질하면서 아래 코드들도 추가했다(문서엔 없어서 안적어도 될 수도...?)
그리고 상단에 이걸 추가:

```ruby
project '프로젝트명.xcodeproj'
```

중간에는 아래 줄도 추가했다:

```ruby
pod 'GoogleMaps'
pod 'react-native-maps', :path => '../node_modules/react-native-maps'
```

추가로 platform :ios, '13.0' 이런 것도 쓰라고 했는데,

오히려 이 줄 때문에 오류가 났다. 그냥 안 고치고 넘어갔는데도 잘 돌아갔다.

(이 부분은 환경에 따라 케바케인 듯.)

---

### **Android는 비교적 단순**

  

Android는 아래 항목들을 AndroidManifest.xml에 넣으면 끝이다.

```xml
<application
... 
	android:useCleartextTraffic="true"
	<meta-data
		android:name="com.google.android.geo.API_KEY"
	  android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
...
</application>
```

---

### 어서와 이런 오류는 처음이지? Unimplemented component: \<RNMapsMapView\>

그리고 빌드.
그런데 갑자기 이런 에러가 터졌다:

```
Unimplemented component: <RNMapsMapView>
```

여기서부터 지옥이 시작됐다.

대체 왜 안 되는지 모르겠어서 구글링, 구글링, 또 구글링.

  
그러다가 GitHub 이슈에서 이런 문구를 발견했다:

  
> the issue "react-native": "0.80.0" if downgrade to "react-native": "0.79.2" it works fine.

오 선생님 너무 감사합니다
맞아요 제 버전에 0.80입니다 ㅠㅠ 맞아요 맞아요ㅠㅠ

 "react-native": "0.80.0"에서는 안 되고
 "react-native": "0.79.2"로 낮추면 된다.

  

그래서 바로 버전을 낮췄다:

```bash
yarn add react-native@0.79.2
```

### **또 오류… 프로젝트 구조가 다르다?**

  

React Native 0.80 기준으로 만들어진 프로젝트였기 때문에

0.79.2로 바꾸자마자 오류가 잔뜩 터졌다.

의존성, Pod 캐시를 다 지우고 다시 설치해도 여전히... 안된다.

React Native 0.80부터는 npx react-native init이 아닌
npx @react-native-community/cli init 방식으로 프로젝트가 생성된다.

그렇다면 android/, ios/ 폴더 내부 구조에도 차이가 있을 수 있다...

---

### **ios, android 폴더를 새 프로젝트로 교체**

  

그래서 아예 0.79.2 기반으로 새 프로젝트를 만들고

그 안에 있는 ios/, android/ 폴더를 기존 프로젝트에 덮어씌웠다.

  

이때 **주의할 점**은 프로젝트명이 다르면 내부 설정이 꼬일 수 있다는 점이다.

Xcode 프로젝트 이름 등 경로가 바뀌지 않게 주의하면서 갈아끼웠다.

---

### **그런데 또 오류… React 버전이 문제였다**

  

이번엔 이런 에러가 떴다:

```
react-native-renderer는 19.0인데,
react는 19.1.0이다
```

React Native가 내부적으로 사용하는 renderer 버전과

내 프로젝트에 설치된 React 버전이 맞지 않아서 발생한 문제였다.

  

그래서 React 버전을 19.0으로 낮췄다.

제발...!!!!!

```
npx pod-install ios
yarn ios
```
---

### **그리고 마침내… 구글맵 등장**

드디어… 드디어 구글맵이 나왔다.

길고도 길었던 버전 지옥의 끝이었다.