#!/bin/bash

# 커밋된 md 파일만 찾기 (content 폴더에 있는 md 파일들만)
for file in $(git ls-tree -r HEAD --name-only | grep 'content/.*\.md$'); do
  if [[ -f "$file" ]]; then
    echo "☑️  Processing $file"

    # 파일의 첫 번째 커밋 시간 확인
    created_date=$(git log --reverse --format=%aI -- "$file" | head -n 1)

    if [[ -z "$created_date" ]]; then
      echo "⚠️  $file → 생성일을 추적할 수 없음"
    else
      echo "📄 $file → Git 최초 커밋 날짜: $created_date"

      # 임시 파일로 작업
      tmpfile=$(mktemp)

      awk -v d="date: $created_date" '
        BEGIN { in_frontmatter = 0; inserted = 0 }
        {
          if ($0 == "---") {
            in_frontmatter++
            print
            next
          }

          if (in_frontmatter == 1 && inserted == 0) {
            print d
            inserted = 1
          }

          print

          if (in_frontmatter == 2) {
            exit
          }
        }
      ' "$file" > "$tmpfile" && mv "$tmpfile" "$file"
    fi
  fi
done