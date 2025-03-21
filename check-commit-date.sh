#!/bin/bash

echo "✅ [hook] frontmatter.date 삽입 중..."

# Git에서 커밋된 파일만 찾기
for file in $(git diff --cached --name-only --diff-filter=A | grep '\.md$'); do
  echo "☑️  Processing $file" # 파일 처리 시작

  if [[ -f "$file" ]]; then
    echo "📄 파일이 존재: $file" # 파일이 존재하면 출력

    # 파일의 첫 번째 커밋 시간 확인
    created_date=$(git log --reverse --format=%aI -- "$file" | head -n 1)

    # 출력
    if [[ -z "$created_date" ]]; then
      echo "⚠️  $file → 생성일을 추적할 수 없음"
    else
      echo "📄 $file → Git 최초 커밋 날짜: $created_date"
    fi
  else
    echo "⚠️ $file → 존재하지 않는 파일"
  fi
done