---
date: 2025-03-31T16:11:00
tags:
  - NextJS15
  - AppRouter
  - useRouter
  - usePathname
  - useSearchParams
  - Navigation
  - Hooks
---
**Next.js 15**에서는 App Router가 기본적으로 제공하는 새로운 **Navigation Hook**들이 있다. 이 Hook들은 React 앱의 라우팅을 좀 더 편리하고, 직관적으로 만들어준다. 특히 useRouter, usePathname, useSearchParams와 같은 Hook들은 네비게이션과 관련된 작업을 손쉽게 해준다.

  
---

**useRouter – 라우팅 관련 정보와 함수 제공**

  

useRouter는 현재 라우터와 관련된 정보와 함수들을 제공한다. 페이지 이동이나 라우팅 상태를 관리할 때 유용하다. App Router에서는 useRouter로 router.push, router.replace 등의 기능을 사용할 수 있고, 현재 URL 정보를 얻을 수 있다.

```
import { useRouter } from 'next/navigation';

export default function MyPage() {
  const router = useRouter();
  
  const handleClick = () => {
    router.push('/next-page');
  };
  
  return (
    <div>
      <button onClick={handleClick}>Go to Next Page</button>
    </div>
  );
}
```

useRouter는 페이지 이동을 쉽게 할 수 있게 도와준다. 또한, 페이지의 query나 path, search params 등도 바로 가져올 수 있다.

---

**usePathname – 현재 경로 얻기**

  

usePathname은 현재 경로를 가져올 때 유용한 Hook이다. 페이지의 경로를 기반으로 조건부 렌더링을 할 때 주로 사용된다.

```
import { usePathname } from 'next/navigation';

export default function Navigation() {
  const pathname = usePathname();
  
  return (
    <div>
      <h1>현재 경로: {pathname}</h1>
    </div>
  );
}
```