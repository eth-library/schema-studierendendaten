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
