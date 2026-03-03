# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-03

First public release of the XML schema for archiving student data,
based on the [nestor schema](https://nbn-resolving.org/urn:nbn:de:0008-2023050314)
(Version 1.0) and adapted for Swiss institutions following
[eCH-0018](https://www.ech.ch/de/ech/ech-0018/2.0) best practices.

### Added

- XML Schema (`studierendendaten.xsd`) with namespace
  `https://schemas.library.ethz.ch/xmlns/studierendendaten/1`
- `version="1.0.0"` attribute on `xsd:schema` element
- Example files in `Beispieldateien/`:
  - `pflichtelemente.xml` — mandatory elements only
  - `alle-elemente.xml` — all permitted elements
- Nix flake (`flake.nix`) providing `libxml2` and `just` via `nix develop`
- `justfile` with validation recipes: `validate-schema`, `validate-examples`,
  `check-encoding`, `check-no-entities`, and `validate` (runs all)
- GitHub Actions CI workflow (`.github/workflows/validate.yml`)
  running `nix develop -c just validate` on push and pull request
- Versioning strategy documented in README following eCH-0018 namespace conventions

### Changed (relative to nestor schema)

#### eCH-0018 compliance

- ComplexType names use UpperCamelCase with `Type` suffix (Chapter 3.2)
- SimpleType `nonEmptyString` renamed to `NonEmptyStringType` (Chapter 3.2)
- SimpleType `namenszusatz-types` renamed to `NamenszusatzType` (Chapter 3.2)
- Language markup uses element pairs instead of `xml:lang` attributes (Chapter 3.7.2)

#### PersonenstammdatenType

- Renamed `kuenstler_ordensname` to `abweichenderName`
- Added `fruehererName` element to `NameType`
- Added `fruehereGeschlechter` element
- Made `geburtsort` optional (Swiss citizens use `heimatort` instead)
- Made `land` mandatory instead of `ort` in `GeburtsortType`
- Added `heimatorte` element with `HeimatortType`
- Added `herkunftsland` element
- Renamed `familienstand` to `zivilstand` (Swiss terminology)
- Removed `religionszugehoerigkeit` (not collected in Switzerland)
- Added `maturatyp` and `schule` to `hochschulzulassungsberechtigung`

#### StudienverlaufType

- Made `studiensemester` repeatable
- Added `semesterwochenstunden` element
- Renamed `hoerstatus` to `hoererstatus`
- Added `finanzierung` element for scholarships and self-financing (doctoral students)

#### StudienleistungenType

- Added `studienabteilung` element (`departement`, `fakultaet`, `institut`)
- Added `geltendeDoktoratsverordnung` element
- Added `auszeichnungen` element to `leistung`
- Added `doktorarbeit` element with `DoktorarbeitType`

#### New types

- `HeimatortType` — Swiss citizenship place of origin
- `DoktorarbeitType` — doctoral thesis details
- `StudiengangType` — study programme with language element
- `FachrichtungType` — field of study with language element
- `GeldbetragType` — monetary amounts with currency
- `NamenszusaetzeType` — name affixes (prefixed, middle, postfixed)

#### Removed types

- `AnschriftStud` — replaced by separate `heimatanschrift`/`semesteranschrift` elements
- `NonEmptyWithLang` — replaced by element-pair language markup

#### Other

- Renamed `landkreis` elements to `kanton`
- Renamed `anschriftenszusatz` to `adresszusatz` in `AnschriftType`
