---
description: Obsidian 기반 블로그 Quartz 설정부터, Cloudflare Pages 배포, 도메인 연결까지!
tags:
  - Obsidian
  - Quartz
  - DNS
  - Blog
aliases:
  - HeyB 블로그 세팅기 ✨✨
date:
---
## **Obsidian 기반 블로그 Quartz 설정부터, Cloudflare Pages 배포, 도메인 연결까지!**

Quartz라는 프로젝트를 알게 되었고, 이걸로 블로그를 만들면 괜찮겠다 싶어서 찾아보다가 **Obsidian**을 쓰게 됐다.

Obsidian에서 정리한 마크다운을 웹에서 그대로 블로그처럼 활용할 수 있다는 점이 마음에 들었다.

  

## **Quartz 프로젝트 클론 후 시작하기**

  

GitHub에서 Quartz 저장소를 클론해서 기본적인 세팅을 진행했다.

```
git clone https://github.com/jackyzha0/quartz.git
cd quartz
```

그런데 실행해보기도 전에 **.lock 파일 충돌**이 발생했다.

뭔가 잘못됐다는 걸 직감했지만, 이미 터미널엔 오류 메시지가 가득했다.

  

### **.lock 파일 충돌 이슈 발생**

  

정확한 이유는 알 수 없었지만,

**Git에 올리고 나서 배포 단계에서 빌드가 실패**했다.

.lock 파일이 문제인가 싶어서 **Git에서 제거하고 다시 빌드해보니 정상적으로 실행**되었다.

  

### **Yarn quartz 실행 오류**

  

yarn quartz를 실행했는데, 계속 **인수가 부족하다는 오류**가 떴다.

아무리 찾아봐도 원인을 모르겠어서 더 찾아보니,

**create 명령어를 먼저 실행해야 하는 거였다.**

  

**💡 해결 방법**


Quartz를 초기화하는 명령어를 먼저 실행해야 오류 없이 진행할 수 있다.

```
npx quartz create
```

이렇게 설정한 후 다시 실행하니 **이제야 정상적으로 동작했다.**

  

## **Cloudflare Pages 연동**

  

배포는 Cloudflare Pages를 이용하기로 했다.

GitHub에 커밋만 하면 자동으로 배포되는 방식이라 신경 쓸 일이 줄어든다.

  

### **Cloudflare Pages에 Git 리포 연결하기**

  

Cloudflare Pages를 사용하려면 GitHub 저장소를 연결해야 했다.

방법은 간단했다.

• Cloudflare에 가입 후 **Cloudflare Pages로 이동**

• Create a Project → GitHub 리포 연결

• Quartz 저장소 선택 후, 자동 배포 설정 🎉

  

이렇게 설정하면 GitHub에 커밋할 때마다 자동으로 사이트가 배포된다.

배포 과정에서 손댈 일이 없다는 게 가장 큰 장점.

  

### **도메인 연결을 위해 서브도메인 필요**

  

Cloudflare Pages 기본 도메인은 pages.dev였는데,

브랜드를 만들려면 **고유 도메인**이 있어야 할 것 같았다.

결국 도메인을 구매하기로 결정!

  

### **도메인 구매 💸**

  

서브도메인 대신, 아예 내 도메인을 사기로 했다.

.kr, .co.kr, .com 중에서 고민했는데, 가격 차이가 꽤 났다.

  

✅ **.com** → 브랜드 느낌은 좋은데… 가격이 너무 비쌌다. 😢

✅ **.co.kr** → 가비아에서 아예 판매 안 하고 있었고, .kr보다 비쌌다.

✅ **.kr** → 적당한 가격에 익숙한 느낌이라 최종 선택!

  

그렇게 최종적으로 **.kr 도메인을 구매하고 연결을 진행했다.**

  

## **Cloudflare DNS 이전**

  

구매한 도메인을 Cloudflare로 연결해서 DNS를 관리하기로 했다.

  

**네임서버를 Cloudflare로 변경**

  

도메인을 사면 기본 네임서버가 설정돼 있지만,

Cloudflare를 쓰면 **속도도 빠르고, SSL도 자동 적용**되기 때문에 네임서버를 바꿨다.

  

**💡 설정 방법**

• 가비아에서 **네임서버 변경 메뉴**로 이동

• 네임서버를 **Cloudflare에서 제공하는 주소**로 변경

• 변경 후 전파 완료 (최대 24시간 소요)

  

**Cloudflare를 선택한 이유**

  

Cloudflare는 무료 플랜에서도 꽤 괜찮은 기능을 제공했다.

  

✅ **무료인데도 캐싱, 보안, 속도 최적화 기능 제공**

✅ **Cloudflare Pages랑 연동하면 배포 속도가 빠름**

✅ **UI가 직관적이라 설정이 간편함**

  

Cloudflare DNS를 적용한 뒤,

SSL 설정이나 성능 최적화도 신경 쓸 필요 없이 **자동 적용**됐다.

  

**HeyB 블로그, 이렇게 완성!**

  

Obsidian 기반 **Quartz로 블로그를 구축**했고,

Cloudflare Pages를 통해 **자동 배포 & 도메인 연결까지 완료!** 🚀✨

  

**이 과정에서 제일 까다로웠던 부분?**

  

😵 .lock 파일 충돌 → Git에서 제거 후 빌드하니 해결됨

🤔 도메인 선택 → .com은 너무 비쌌고, .kr이 적당

🛠️ yarn quartz 실행 오류 → npx quartz create 후 실행해야 해결됨

  

하지만 다 해결하고 나니까, **드디어 첫 블로그 오픈!!** 🎉