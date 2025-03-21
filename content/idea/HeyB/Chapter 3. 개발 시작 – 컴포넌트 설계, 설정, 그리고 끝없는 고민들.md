---
tags:
  - React
  - 컴포넌트설계
  - heyb
  - 개발고민
  - 취미
  - 개발
date: 2025-03-11T16:51:25+09:00
---

## **개발 시작 전에, 먼저 셋팅부터**

막상 개발을 시작하려니까 기본적인 셋팅부터 필요했다.

Next.js 프로젝트를 세팅하고 ESLint, Prettier 같은 기본 설정을 잡았다.

혼자 하는 프로젝트라 **브랜치 전략이 복잡할 필요는 없었고**,

v1이 나오기 전까지는 **메인 브랜치에서 작업**,

이후부터는 feature 브랜치를 만들어서 작업하기로 했다.

이슈가 생기면 fix 브랜치를 만들 수도 있지만,

일단은 **혼자 하는 프로젝트라 필요할 때 추가하는 게 맞다고 판단했다.**

---

## **App Router vs Page Router – 결국 App Router를 선택한 이유**

처음에는 Page Router도 고려했지만, **결국 App Router를 선택했다.**

### 📌 **App Router를 선택한 이유**

✅ **Next.js의 방향성이 Page Router → App Router 중심으로 가고 있음**

• Next.js가 앞으로 App Router를 기반으로 발전할 가능성이 높았고,

• 새로운 기능들도 Page Router가 아니라 **App Router 위주로 추가되는 상황**이었다.

✅ **언젠가는 써야 할 거라면, 지금부터 적응하는 게 낫다고 판단**

• 지금 당장은 익숙한 Page Router를 쓰는 게 편할 수도 있지만,

• App Router로 넘어가야 하는 순간이 올 거라면,

• **미리 적응해두는 게 커리어적으로도 유리할 거라고 생각했다.**

✅ **기존 Page Router에서 할 수 없었던 유용한 기능들 제공**

• Page Router에서는 Client Component와 Server Component가 명확히 구분되지 않아서,

• 클라이언트 사이드에서 불필요한 데이터를 불러오는 일이 많았음.

• **App Router에서는 Server Component와 Client Component를 분리할 수 있어서, 속도 최적화가 가능했다.**

• 서버에서 필요한 데이터만 내려받고, 불필요한 Client-side 렌더링을 줄일 수 있음.

✅ **React Server Component(RSC)와의 자연스러운 연계 가능**

• **Server Component를 활용하면 클라이언트에 불필요한 코드가 덜 전달됨.**

• 예를 들어, 데이터 요청이 필요한 부분은 Server Component에서 처리하고,

• 인터랙션이 필요한 UI 부분만 Client Component로 관리할 수 있음.

• 이를 통해 **최적화된 페이지 로딩 속도를 기대할 수 있다.**

처음부터 App Router를 쓴 건 아니었지만,

결국 **앞으로의 개발 커리어에도 도움이 될 거라고 판단해서 선택했다.**

---

## **App Router를 쓰려면 emotion(css, styled) 못 쓴다고?!**

App Router를 선택한 순간, **emotion을 못 쓴다는 걸 깨달았다.**

(정확히는 사용할 수 있지만, SSR 환경에서의 문제가 있다.)

**감성 스타일링이 금지된 건가…**

emotion을 못 쓰게 되면서 스타일링 라이브러리를 다시 고민해야 했다.

### 📌 **고려했던 스타일링 방식**

✅ .module.scss → 익숙하지만, 유지보수가 어려울 것 같음

✅ Vanilla Extract → 빌드 타임 스타일 생성으로 성능은 좋지만, 문법이 다소 번거로움

✅ Tailwind CSS → 클래스 네이밍을 외우는 게 번거롭고, 특정 스타일 적용이 어려움

✅ CSS Modules → 확장성이 부족하고, 유지보수할 때 코드가 길어질 가능성이 있음

결국 **Vanilla Extract를 선택했다.**

그런데 솔직히 아직도 불만이 많다.

**emotion 쓰게 해줘라…!!!**

(이 부분은 Dev 카테고리에서 더 자세히 다룰 예정.)

---

## **Compound, Headless 컴포넌트 – 기존 방식이 App Router에서도 괜찮을까?**

Compound와 Headless 컴포넌트 패턴은 익숙했지만,

**App Router 환경에서 이렇게 사용해도 되는 걸까?** 하는 고민이 들었다.

### 📌 **고민했던 점**

✅ **use client를 써야 할까?**

• App Router에서는 불필요한 use client 사용을 최소화하는 게 중요했다.

• Compound Component를 사용할 때 useContext를 활용하면 use client가 필요하지만,

• **모든 컴포넌트에서 use client를 강제하는 게 맞는지 고민이 많았다.**

✅ **children에 props를 넘겨서 해결할까?**

• cloneElement 방식을 사용해서 children에 props를 넘기는 방법을 고려했다.

• 하지만 이 방식은 **새로운 요소가 추가될 경우 깨질 가능성이 있어서 신중하게 적용해야 했다.**

✅ **Zustand 같은 전역 상태 관리를 도입할까?**

• 처음엔 상태 관리를 단순화하려고 Zustand 같은 전역 상태 관리 라이브러리를 고려했지만,

• **컴포넌트 내부에서 관리해야 할 데이터까지 굳이 전역 상태로 둘 필요는 없어 보였다.**

• 결국 **전역 상태로 관리해야 할 데이터와, 컴포넌트 내부에서 관리해야 할 데이터를 분리하는 방향**으로 정리했다.

---

### **📌 Compound Component 패턴을 처음 접한 게 아니라, 익숙했지만 App Router에서 혼란스러웠다**

Compound Component 패턴을 처음 접한 건 **이 영상 때문이었다.**

🎥 [**🔗 Compound Components in TypeScript with React (by Tony Alicea)**](https://youtu.be/aAs36UeLnTg?feature=shared)

그래서 이 패턴을 잘 활용해오고 있었는데,

**App Router로 넘어오면서 기존 방식과 맞지 않는 부분들이 생겼다.**

• **기존에는 emotion을 활용해서 자유롭게 스타일을 적용할 수 있었는데, App Router에서는 emotion을 못 쓰게 되면서 스타일 적용 방식이 바뀌었다.**

• **useContext를 사용할 경우 use client가 필요해졌고, 이걸 최소화하려면 props를 넘기는 방식을 고려해야 했다.**

• **Zustand 같은 중앙 관리 방식은 어울리지 않는다고 생각했지만, 대안으로 적절한 상태 관리 방식을 고민해야 했다.**

결국 **컴포넌트의 역할에 따라 useContext를 쓰거나, props를 넘기는 방식으로 해결했다.**

App Router에서 Compound Component를 적용하면서 생긴 고민은 아직도 진행 중이다.

---

## **Vanilla Extract + Headless 적용… 솔직히 짜증났다**

**App Router에서 Emotion 못 쓰니까 Vanilla Extract 쓰는 건 좋은데,**

**상태에 따라 스타일 바꿀 때마다 styleVariants나 recipe() 같은 걸 써야 해서 좀 귀찮다.**

✅ Emotion이면 css prop 하나로 해결할 수 있는데,

✅ Vanilla Extract는 스타일이 정적이라서 **미리 정의해야 하는 부분이 많아 개발 속도가 좀 느려지는 느낌?**

이 부분은 **Dev 카테고리에서 더 자세히 다룰 예정.**

생각보다 Vanilla Extract가 좋은 점도 있지만, **불편한 점도 꽤 많았다.**

---

## **결론 – 예상보다 더 오래 걸린 개발 과정**

처음엔 **그냥 컴포넌트 개발하고 페이지 붙이면 끝날 줄 알았는데,**

✅ 상태 관리 고민 (Context? Props? use client 최소화?)

✅ 디자인 요소 수정 (Input, 버튼 등)

✅ 예상보다 복잡했던 에디터 디자인

✅ Compound & Headless 조합을 어떻게 할지 고민

이런 요소들 때문에 생각보다 더 오래 걸렸다.

이제 기본적인 셋팅과 컴포넌트 개발이 끝났으니,
