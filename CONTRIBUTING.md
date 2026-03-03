# Contributing

Thank you for your interest in contributing to the Studierendendaten XML Schema.

## Language conventions

| Context | Language |
|---|---|
| Schema content (`xsd:documentation`, element names) | German |
| README | German |
| CONTRIBUTING, CHANGELOG | English |
| Commit messages, PR titles/descriptions | English |
| Code comments (justfile, flake.nix, CI) | English |

## Prerequisites

The project requires two tools for local development:

- [`just`](https://just.systems/) — a command runner
- [`xmllint`](https://gnome.pages.gitlab.gnome.org/libxml2/xmllint.html) — XML/XSD validator (part of libxml2)

### Recommended: Nix

We recommend using [Nix](https://nixos.org/) for a reproducible environment that
provides both tools automatically:

```sh
nix develop
```

### Alternative: manual installation

If you prefer not to use Nix, install `just` and `libxml2` through your system
package manager:

```sh
# macOS
brew install just libxml2

# Ubuntu/Debian
sudo apt-get install -y just libxml2-utils
```

## Validating

All validation is managed through a `justfile`. Run all checks with:

```sh
just validate
```

Individual recipes:

| Recipe | Description |
|---|---|
| `just validate-schema` | Checks that `studierendendaten.xsd` is well-formed and valid |
| `just validate-examples` | Validates all XML files in `Beispieldateien/` against the XSD |
| `just check-encoding` | Verifies UTF-8 encoding declaration in all XML/XSD files |
| `just check-no-entities` | Scans for `<!ENTITY` declarations (eCH-0018 security rule) |
| `just validate` | Runs all of the above (default) |

## CI

GitHub Actions runs `nix develop -c just validate` on every push and pull request.
The CI uses the same Nix environment and justfile as local development — there is
no separate CI-specific validation logic.

## Branching conventions

| Prefix | Use for |
|---|---|
| `fix/` | Bug fixes, schema corrections |
| `feature/` | New schema elements, types, or features |
| `chore/` | Tooling, dependencies, non-schema changes |
| `ci/` | CI/CD pipeline changes |
| `docs/` | Documentation changes |

## Commits

This project follows [Conventional Commits](https://www.conventionalcommits.org/).
Write commit messages in English with a type prefix:

```
<type>: <short imperative description>

<optional body>
```

Common types:

| Type | Use for |
|---|---|
| `feat` | New schema elements, types, or features |
| `fix` | Bug fixes, schema corrections |
| `docs` | Documentation changes |
| `chore` | Tooling, dependencies, maintenance |
| `ci` | CI/CD changes |
| `refactor` | Schema restructuring without functional change |

Examples:

```
feat: add optional emailAdresse element to PersonenstammdatenType
fix: correct minOccurs on geburtsort element
docs: update changelog for v1.1.0
chore: update flake.lock
```

## Versioning

This project follows [Semantic Versioning](https://semver.org/). The version is
tracked in three places:

1. `xsd:schema[@version]` attribute in `studierendendaten.xsd`
2. `Version:` line in `README.md`
3. Git tags (`v1.0.0`, `v1.1.0`, ...)

### Namespace URI

Per [eCH-0018](https://www.ech.ch/de/ech/ech-0018/2.0), the namespace URI contains
only the **major version**:

```
https://schemas.library.ethz.ch/xmlns/studierendendaten/1
```

The namespace URI changes only on a major version bump (breaking change).

### What constitutes a version bump?

| Change | Version bump | Namespace changes? |
|---|---|---|
| Fix typo in `xsd:documentation` | Patch | No |
| Add new optional element | Minor | No |
| Add new optional ComplexType | Minor | No |
| Relax a constraint (`minOccurs="1"` → `"0"`) | Minor | No |
| Remove or rename an element | **Major** | **Yes** |
| Tighten a constraint (`minOccurs="0"` → `"1"`) | **Major** | **Yes** |
| Change element order in a sequence | **Major** | **Yes** |

### Changelog

All notable changes are recorded in `CHANGELOG.md` following the
[Keep a Changelog](https://keepachangelog.com/) format. The changelog is
updated as part of the release preparation — there is no `[Unreleased]`
section to maintain during regular development.

## Releasing

Releases are created from `main`. There are no release branches — we tag commits
directly.

### Steps to create a release

1. **Prepare the version bump** on a `chore/prepare-vX.Y.Z` branch:
   - Update `version="X.Y.Z"` in the `xsd:schema` element of `studierendendaten.xsd`
   - Update `Version: X.Y.Z` in `README.md`
   - Add a new `[X.Y.Z] - YYYY-MM-DD` section to `CHANGELOG.md` with all changes
     since the last release (use `git log vLAST..main --oneline` to review)
   - Open a PR, get it reviewed and merged

2. **Tag the merge commit** on `main`:
   ```sh
   git checkout main && git pull
   git tag -a vX.Y.Z -m "vX.Y.Z"
   git push origin vX.Y.Z
   ```

3. **GitHub Actions takes over automatically:**
   - Creates a GitHub release from the tag
   - Attaches `studierendendaten.xsd` as a release asset
   - Generates landing pages for all major versions from release data
   - Builds the Jekyll site and deploys to GitHub Pages

### Schema hosting

The namespace URI `https://schemas.library.ethz.ch/xmlns/studierendendaten/1`
is both an identifier and a resolvable URL. The setup uses a reverse proxy at
ETH that forwards requests to GitHub Pages, so consumers always see the
`schemas.library.ethz.ch` domain.

```
Browser / XML tool
  → https://schemas.library.ethz.ch/xmlns/studierendendaten/1/studierendendaten.xsd
  → reverse proxy at ETH (invisible to user)
  → https://eth-library.github.io/schema-studierendendaten/xmlns/studierendendaten/1/studierendendaten.xsd
  → served by GitHub Pages (Jekyll)
```

The GitHub Pages site is built with Jekyll (minimal theme) from the `pages/`
directory. Only `pages/_config.yml` and `pages/index.md` are checked into the
repo — everything else (release data, per-major-version landing pages, XSD
copies) is generated automatically by the release workflow. New major versions
get their own landing page and XSD without any manual file creation.

The XSD file for each major version is available at:

```
https://schemas.library.ethz.ch/xmlns/studierendendaten/{major}/studierendendaten.xsd
```

Specific versions are also available as GitHub release assets.

## eCH-0018 compliance

All changes to the schema must comply with
[eCH-0018 V2.0 XML Best Practices](https://www.ech.ch/de/ech/ech-0018/2.0).
Key rules to keep in mind:

- **Naming** (Chapter 3.2): ComplexTypes use UpperCamelCase with `Type` suffix,
  SimpleTypes use UpperCamelCase with `Type` suffix, elements use lowerCamelCase
- **Encoding**: UTF-8, declared in the XML prolog
- **No entity declarations**: `<!ENTITY` is forbidden
- **Language markup** (Chapter 3.7.2): use element pairs, not `xml:lang` attributes
- **Schema location** (Chapter 4): namespace URI is an identifier, not a locator
