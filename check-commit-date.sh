#!/bin/bash

echo "✅ [batch] 기존 파일들에 date 삽입 중..."

find content -name "*.md" | while IFS= read -r file; do
  echo "☑️ Processing $file"

  if [[ -f "$file" ]]; then
    if ! grep -q "^date:" "$file"; then
      created_date=$(git log --follow --reverse --format=%aI -- "$file" | head -n 1)

      if [[ -z "$created_date" ]]; then
        echo "⏭️  $file → git 최초 커밋 없음 → 건너뜀"
        continue
      fi

      tmpfile=$(mktemp)
      frontmatter=0
      inserted=0

      while IFS= read -r line; do
        if [[ "$line" == "---" ]]; then
          frontmatter=$((frontmatter + 1))
          echo "$line" >> "$tmpfile"

          if [[ "$frontmatter" == 1 && "$inserted" == 0 ]]; then
            echo "date: $created_date" >> "$tmpfile"
            inserted=1
          fi
        else
          echo "$line" >> "$tmpfile"
        fi
      done < "$file"

      mv "$tmpfile" "$file"
      echo "📄 date: $created_date → $file"
    else
      echo "⚠️  $file → 이미 date: 있음 → 건너뜀"
    fi
  fi
done