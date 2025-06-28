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

### 어서와 이런 오류는 처음이지? ### **Unimplemented component:** 

### **<RNMapsMapView>**

그리고 빌드.

그런데 갑자기 이런 에러가 터졌다:

```
Unimplemented component: <RNMapsMapView>
```