Next.js 15은 기존 Page Router에서 **App Router 중심의 아키텍처로 전환**하면서,

React Server Components(RSC), Server Actions, Partial Prerendering(PPR) 등의 기능을 도입했다.

  

이제 Next.js는 단순한 React 프레임워크를 넘어

**서버와 클라이언트를 자연스럽게 연결하는 풀스택 프레임워크**로 자리 잡았다.

  

그렇다면 Next.js 15에서 **어떤 변화가 있었고**,

실제 프로젝트에서는 **이걸 어떻게 적용해야 할까?**

이 글에서 **핵심 기능과 실무 적용 방법을 정리**한다.

---

**1. Next.js 15의 주요 변화 – 뭐가 달라졌을까?**

| **기능**                            | **설명**                 | **기존 방식 (Page Router)**               | **Next.js 15 (App Router)**          |
| --------------------------------- | ---------------------- | ------------------------------------- | ------------------------------------ |
| **라우팅 방식**                        | 파일 기반 라우팅              | pages/ 디렉터리                           | app/ 디렉터리                            |
| **데이터 패칭**                        | 서버 요청 처리 방식            | getServerSideProps, getStaticProps 사용 | fetch()를 Server Component에서 직접 실행 가능 |
| **React Server Components (RSC)** | 서버와 클라이언트의 분리          | 클라이언트에서 데이터 요청 후 렌더링                  | 서버에서 데이터를 렌더링 후 클라이언트로 전송            |
| **Partial Prerendering (PPR)**    | 정적 + 동적 조합 가능          | ISR 기반 정적 생성                          | 일부 페이지는 즉시 렌더링, 일부는 클라이언트에서 동적 로드    |
| **Server Actions**                | API 라우트 없이 서버에서 데이터 처리 | pages/api/를 활용한 API 요청                | async function을 서버에서 직접 실행 가능        |
| **빌드 시스템**                        | Webpack & Vite         | Turbopack 적용 (더 빠른 빌드 속도)             |                                      |

---

**2. App Router로의 전환 – “App Router를 써야 하는 이유가 있나요?”**

  

Next.js 15에서는 기본적으로 **App Router를 권장**하지만,

그렇다고 Page Router가 사라진 것은 아니다.

  

_“그럼 App Router를 써야 하는 이유가 있나요?”_ 라는 질문을 한다면,

대답은 **“케이스 바이 케이스”**다.

이론적으로는 App Router가 더 나은 방식이지만, **모든 프로젝트가 무조건 App Router로 가야 하는 것은 아니다.**

  

**📌 App Router의 장점 (언제 사용하면 좋을까?)**

  

✅ **React Server Components(RSC)를 활용해 성능 최적화가 필요할 때**

✅ **서버와 클라이언트를 명확하게 분리하고 싶을 때**

✅ **SSR(서버 사이드 렌더링)에서 API 요청을 줄이고 싶을 때**

✅ **새로운 Next.js 기능 (PPR, Server Actions 등)을 적극 활용하고 싶을 때**

  

**📌 Page Router를 유지하는 것이 좋은 경우**

  

✅ **기존 Page Router 기반 프로젝트를 유지보수해야 할 때**

✅ **현재 App Router로 전환할 필요 없이, 기존 방식이 더 익숙한 경우**

✅ **SSG(정적 사이트 생성) 중심의 프로젝트일 때 (App Router에서는 getStaticProps가 사라짐)**

  

결론적으로, **새 프로젝트라면 App Router를 선택하는 것이 더 나은 선택이지만,**

**기존 Page Router 프로젝트를 당장 전환할 필요는 없다.**

---

**3. 데이터 패칭 – Page Router vs App Router에서의 차이**

  

Next.js에서 데이터를 불러오는 방식은 Page Router와 App Router에서 다르게 동작한다.

  

**📌 Page Router에서의 데이터 패칭**

  

기존 Page Router에서는 **getServerSideProps, getStaticProps를 사용해서 서버에서 데이터를 불러왔다.**

```

```