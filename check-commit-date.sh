#!/bin/bash

# content 폴더 내 모든 md 파일 찾기 (서브폴더 포함)
for file in $(find content -type f -name "*.md"); do
  if [[ -f "$file" ]]; then
    echo "☑️  Processing $file"

    # 파일에 date: 가 있는지 확인
    if grep -q "^date:" "$file"; then
      echo "⚠️  $file → 이미 date 필드가 존재합니다. 건너뜁니다."
      continue
    fi

    # 파일의 첫 번째 커밋 시간 확인
    created_date=$(git log --reverse --format=%aI -- "$file" | head -n 1)

    if [[ -z "$created_date" ]]; then
      echo "⚠️  $file → 생성일을 추적할 수 없음"
    else
      echo "📄 $file → Git 최초 커밋 날짜: $created_date"

      # 임시 파일로 작업
      tmpfile=$(mktemp)

      # --- 다음에 date 필드 삽입
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