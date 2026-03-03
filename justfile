default: validate

# Validate that studierendendaten.xsd is a well-formed and valid XSD schema
validate-schema:
    xmllint --noout studierendendaten.xsd

# Validate all example XML files against the XSD schema
validate-examples:
    #!/usr/bin/env bash
    set -euo pipefail
    for f in Beispieldateien/*.xml; do
        echo "Validating $f..."
        xmllint --noout --schema studierendendaten.xsd "$f"
    done

# Verify UTF-8 encoding declaration in all XML/XSD files
check-encoding:
    #!/usr/bin/env bash
    set -euo pipefail
    for f in studierendendaten.xsd Beispieldateien/*.xml; do
        if ! head -1 "$f" | grep -qi 'encoding=.utf-8'; then
            echo "ERROR: $f missing UTF-8 encoding declaration" && exit 1
        fi
    done
    echo "All files declare UTF-8 encoding."

# Check for forbidden XML entity declarations (eCH-0018 security rule)
check-no-entities:
    #!/usr/bin/env bash
    set -euo pipefail
    if grep -rl '<!ENTITY' *.xsd Beispieldateien/*.xml 2>/dev/null; then
        echo "ERROR: Entity declarations found (eCH-0018 violation)" && exit 1
    fi
    echo "No entity declarations found."

# Run all validation checks
validate: validate-schema validate-examples check-encoding check-no-entities

# Generate Pages data and per-major-version schema directories from GitHub releases
generate-pages:
    #!/usr/bin/env bash
    set -euo pipefail
    cd pages
    mkdir -p _data
    gh release list --limit 100 --json tagName,publishedAt,name > _data/releases.json
    gh release list --limit 100 --json tagName \
      --jq '[.[].tagName | ltrimstr("v") | split(".")[0]] | unique | map({major: .})' \
      > _data/schemas.json
    for major in $(jq -r '.[].major' _data/schemas.json); do
      dir="xmlns/studierendendaten/$major"
      mkdir -p "$dir"
      latest_tag=$(gh release list --limit 100 --json tagName \
        --jq "[.[].tagName | select(startswith(\"v${major}.\"))] | .[0]")
      gh release download "$latest_tag" --pattern "studierendendaten.xsd" \
        --dir "$dir" --clobber
      sed "s/__MAJOR__/$major/g" _templates/schema-version.md > "$dir/index.md"
    done
    echo "Pages generated."

# Serve GitHub Pages site locally for preview
serve-pages: generate-pages
    cd pages && bundle install --quiet && bundle exec jekyll serve --livereload
