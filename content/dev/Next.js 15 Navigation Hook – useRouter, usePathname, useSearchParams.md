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

## **useRouter – 라우팅 관련 정보와 함수 제공**

  

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

## **usePathname – 현재 경로 얻기**

  

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

---

## **useSearchParams – 쿼리 파라미터 관리**

  

useSearchParams는 현재 URL에서 쿼리 파라미터를 쉽게 가져오고 변경할 수 있게 해주는 Hook이다. 이를 통해 URL의 쿼리 파라미터를 직접 조작하거나 상태에 맞게 URL을 업데이트할 수 있다.

```
import { useSearchParams } from 'next/navigation';

export default function SearchPage() {
  const searchParams = useSearchParams();
  const searchQuery = searchParams.get('query');

  return (
    <div>
      <h1>검색어: {searchQuery}</h1>
    </div>
  );
}
```

useSearchParams는 URL에 있는 쿼리 파라미터를 쉽게 처리할 수 있게 도와준다. 예를 들어, 검색 페이지에서 사용자가 검색어를 입력할 때 URL의 쿼리 파라미터를 업데이트하고, 그 값을 읽어와서 적절히 처리할 수 있다.

---

## **그럼 Page Router에서는 어떻게 쓰나?**

  

**Page Router**에서는 **`next/navigation`** 대신 **`next/router`** 를 사용한다.  **`next/navigation의 useRouter`** 는 App Router에서만 사용할 수 있으며, **Page Router에서는 `next/router`** 에서 제공하는 기능을 사용해 페이지를 이동시키고, 경로를 관리해야 한다. `next/router`는 `router.push`, `router.replace`, `router.query` 등을 제공하며, 페이지의 쿼리 파라미터나 경로 정보를 가져오는 데 사용된다.

```
import { useRouter } from 'next/router';

export default function MyPage() {
  const router = useRouter();

  // 현재 페이지의 경로를 가져옴
  const currentPath = router.pathname;

  // 쿼리 파라미터를 가져옴
  const query = router.query;

  // 라우트 매개변수를 가져옴
  const { id } = router.query;

  const handleClick = () => {
    router.push('/next-page');
  };

  return (
    <div>
      <p>현재 경로: {currentPath}</p>
      <p>쿼리 파라미터: {JSON.stringify(query)}</p>
      <button onClick={handleClick}>Go to Next Page</button>
    </div>
  );
}
```

---

이렇게 useRouter와 next/router를 구분하여 사용하면 각 환경에 맞는 라우팅을 구현할 수 있다. App Router에서 제공하는 useRouter와 Page Router에서 사용하는 next/router의 차이를 이해하고, 적절한 환경에서 사용할 수 있도록 해야 한다.
