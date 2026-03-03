---
layout: default
---

XML Schema for archiving student data following
[eCH-0018](https://www.ech.ch/de/ech/ech-0018/2.0) and
[nestor](https://nbn-resolving.org/urn:nbn:de:0008-2023050314) standards.

## Available schemas

| Schema | Namespace URI | XSD |
|---|---|---|{% for schema in site.data.schemas %}
| studierendendaten v{{ schema.major }} | `https://schemas.library.ethz.ch/xmlns/studierendendaten/{{ schema.major }}` | [Download](xmlns/studierendendaten/{{ schema.major }}/studierendendaten.xsd) |{% endfor %}

## Releases

| Version | Date | |
|---|---|---|{% for release in site.data.releases %}
| {{ release.tagName }} | {{ release.publishedAt | slice: 0, 10 }} | [Notes](https://github.com/eth-library/schema-studierendendaten/releases/tag/{{ release.tagName }}) |{% endfor %}

## Links

- [GitHub Repository](https://github.com/eth-library/schema-studierendendaten)
- [CHANGELOG](https://github.com/eth-library/schema-studierendendaten/blob/main/CHANGELOG.md)
- [CONTRIBUTING](https://github.com/eth-library/schema-studierendendaten/blob/main/CONTRIBUTING.md)
