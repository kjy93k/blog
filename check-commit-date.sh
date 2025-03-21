#!/bin/bash

# Git에서 커밋된 파일만 찾기
for file in $(git diff --cached --name-only --diff-filter=A | grep '\.md$'); do
  if [[ -f "$file" ]]; then
    echo "☑️  Processing $file"

    # 파일의 첫 번째 커밋 시간 확인
    created_date=$(git log --reverse --format=%aI -- "$file" | head -n 1)

    # 출력
    if [[ -z "$created_date" ]]; then
      echo "⚠️  $file → 생성일을 추적할 수 없음"
    else
      echo "📄 $file → Git 최초 커밋 날짜: $created_date"
    fi
  fi
done
