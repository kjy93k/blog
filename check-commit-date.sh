#!/bin/bash

echo "✅ frontmatter.date 삽입 중..."

for file in $(find content -name "*.md"); do
  echo "☑️ Processing $file"
  if [[ -f "$file" ]]; then
    if ! grep -q "^date:" "$file"; then
      created_date=$(git log --reverse --format=%aI -- "$file" | head -n 1)
      if [[ -z "$created_date" ]]; then
        created_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
      fi

      echo "📄 $file ← ⏱️  $created_date"

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
            while ((getline line < FILENAME) > 0) print line
            exit
          }
        }
      ' "$file" > "$tmpfile" && mv "$tmpfile" "$file"
    fi
  fi
done