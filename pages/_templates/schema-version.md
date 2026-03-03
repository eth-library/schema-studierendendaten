---
layout: default
title: studierendendaten v__MAJOR__
major: "__MAJOR__"
---

## Schema: studierendendaten

**Namespace URI:** `https://schemas.library.ethz.ch/xmlns/studierendendaten/__MAJOR__`

**Download:** [studierendendaten.xsd](studierendendaten.xsd)

### Releases

| Version | Date | |
|---|---|---|
{% for release in site.data.releases %}{% assign rmajor = release.tagName | remove: "v" | split: "." | first %}{% if rmajor == page.major %}| {{ release.tagName }} | {{ release.publishedAt | slice: 0, 10 }} | [Notes](https://github.com/eth-library/schema-studierendendaten/releases/tag/{{ release.tagName }}) |
{% endif %}{% endfor %}

---

[GitHub Repository](https://github.com/eth-library/schema-studierendendaten) |
[CHANGELOG](https://github.com/eth-library/schema-studierendendaten/blob/main/CHANGELOG.md)
