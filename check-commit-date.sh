#!/bin/bash

# content 폴더 내 모든 md 파일 찾기 (dev, life, idea 폴더 포함)
for file in $(find content -type f -name "*.md"); do
echo "☑️  Processing $file"
  if [[ -f "$file" ]]; then
    echo "☑️  Processing $file"

    # 이미 date: 필드가 있으면 건너뛰기
    # if ! grep -q "^date:" "$file"; then
    #   # 첫 번째 커밋 시간 확인 (git 최초 커밋 날짜)
    #   created_date=$(git log --reverse --format=%aI -- "$file" | head -n 1)

    #   # 생성일이 없다면 현재 날짜로 설정
    #   if [[ -z "$created_date" ]]; then
    #     created_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    #   fi

    #   echo "📄 $file → Git 최초 커밋 날짜: $created_date"

    #   # 파일에서 frontmatter(---) 부분 찾기
    #   tmpfile=$(mktemp)

    #   # 앞부분에 date 삽입
    #   awk -v date="date: $created_date" '
    #     BEGIN { in_frontmatter = 0 }
    #     {
    #       if ($0 == "---") {
    #         in_frontmatter++
    #         print
    #         next
    #       }

    #       if (in_frontmatter == 1 && !inserted) {
    #         print date
    #         inserted = 1
    #       }

    #       print

    #       if (in_frontmatter == 2) {
    #         exit
    #       }
    #     }
    #   ' "$file" > "$tmpfile" && mv "$tmpfile" "$file"
    # else
    #   echo "⚠️  $file → 이미 date 필드가 존재합니다."
    # fi
  fi
done