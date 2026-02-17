XML-Schema für Studierendendaten
==================

Version: 1.0

## Einführung ##

Dies ist das XML-Schema für die Archivierung von Studierendendaten, dass im Rahmen des Projekts «Digital Campus» an der ETH Zürich entwickelt wurde. Das Schema basiert auf dem XML-Schema von nestor zur «Archivierung von Studierendendaten aus Fachverfahren - Version 1.0» ([urn:nbn:de:0008-2023060507](https://d-nb.info/1294122746/34)), wurde an Schweizer Gegebenheiten angepasst und erfüllt alle erforderlichen Best Practices von [eCH-0018](https://www.ech.ch/de/ech/ech-0018/2.0). Es ermöglicht das Erzeugen von Studierenden-Dossiers für die Archivierung, entsprechend enthalten die Dossiers nur Angaben, die für die Archivierung relevant sind. Neben den Angaben in der XML-Datei werden normalerweise auch zusätzliche Dokumente (meist als PDF) mitarchiviert.

In diesem Repositorium findet sich:
- Das XML-Schema als XSD-Datei
- Dieses Readme, welche das Schema und deren Nutzung beschreibt
- Beispieldateien von XML-Dateien, die dem Schema folgen

### Hinweis zu den Beispieldateien

Im Ordner «Beispieldateien» finden sich zwei Beispiele. Die XML-Datei *alle-elemente.xml* beinhaltet jedes erlaubte Elemente mindestens einmal und ein `xsi:schemaLocation`-Attribut, während die XML-Datei *pflichtelemente.xml* nur alle Pflichtelemente enthält und kein `xsi:schemaLocation`-Attribut. Die Beispieldateien dienen nur zur Veranschaulichung und bilden selbst nicht zwingend ein plausibles oder vollständiges Studierendendossier ab. Zu beachten ist ebenfalls, dass das Element `anschriften` nicht vorgibt, dass ein Element `heimatanschrift` oder `semesteranschrift` Pflicht ist, allerdings sollte effektiv mindestens eines dieser Elemente vorhanden sein.

## Wie das XML-Schema genutzt wird

XML-Dateien können auf zwei Ebenen auf ihre syntaktische Korrektheit überprüft werden. Eine wohlgeformte XML-Datei (well-formed) hält die grundsätzlichen Regeln von XML ein, während eine gültige XML-Datei (valid) sich zusätzlich an ein vorgegebenes Schema hält. Ein XML-Schema deklariert, welche Datenelemente in einer XML-Datei vorhanden sein dürfen und wie diese strukturiert sind. Durch diese Vorgaben kann sichergestellt werden, dass ein XML nur Daten enthält, die vom Schema her zu erwarten sind. Beim Erstellen einer XML-Datei muss sich an das vorgegebene Schema gehalten werden. Das Schema kann zusätzlich mit einem Validator genutzt werden, die XML-Dateien auf ihre Gültigkeit zu prüfen. Im Ordner «Beispieldateien» findet sich eine Sammlung von gültigen XML-Dateien.

### Das xsi:schemaLocation-Attribut in der XML-Datei

Nach eCH-0018 sollte auf das `xsi:schemaLocation`-Attribut verzichtet werden und die Identifikation des Schemas nur über den Namespace-Namen erfolgen. Werden die XML-Dateien aber in standardisierten Dossiers geliefert, in denen auch die XSD-Schemadatei standardmässig abgelegt ist, kann eine Referenz auf die lokale XSD-Datei mit dem `xsi:schemaLocation`-Attribut in der XML-Datei im Rahmen der Archivierung sinnvoll sein, um künftige Validierungen zu vereinfachen.


## Unterschiede zum nestor-Schema

Das Kompetenznetzwerk Langzeitarchivierung und Langzeitverfügbarkeit digitaler Ressourcen in Deutschland e.V. «nestor» hat 2023 Materialien zur Archivierung von Studierendendaten aus Fachverfahren veröffentlicht. Sie beschreiben ein Vorgehen, wie Studierendendaten aus Fachverfahren archiviert werden können. Zu diesen Materialien gehört auch ein Muster für ein XML-Schema [urn:nbn:de:0008-2023050314](https://nbn-resolving.org/urn:nbn:de:0008-2023050314). Dieses ist explizit als Muster erstellt worden und nicht als endgültigen Standard. So sind Doktorierende im Muster-Schema nicht abgedeckt und zudem gibt es Unterschiede zum Schweizer (Bildungs-)System. Aus diesem Grund hat die ETH-Bibliothek das Muster als Grundlage genommen, um ein eigenes Schema zu entwickeln. In diesem Rahmen wurde das XML-Schema zusätzlich an die erforderlichen Best Practices von [eCH-0018](https://www.ech.ch/de/ech/ech-0018/2.0) angepasst. Es wurde versucht, das Schema allgemeingültig zu halten, damit es auch von anderen Schweizer Institutionen genutzt werden könnte.

### Liste der Anpassungen

#### Anpassungen für Einhaltung von eCH-0018

- Definitionen von Complex Types wurde «Type» hinzugefügt (Kapitel 3.2)
- Für Elemente, deren Sprache im nestor-Standard mit dem `xml:lang`-Attribut deklariert sind, wurden stattdessen eigene Elemente (Value-Pair) eingeführt (Kapitel 3.7.2). Das Element wurde in diesem Zuge meist ebenfalls leicht angepasst und unique-Constrains, die sich auf diese Elemente bezogen haben wurden entfernt.

#### Im Element PersonenstammdatenType

- Das Element `kuenstler_ordensname` wurde zu `abweichenderName` geändert, um flexibler nutzbar zu sein.
- Das Element `fruehererName` wurde dem Element `name` hinzugefügt, um Namensänderungen erfassbar zu machen.
- Das Element `fruehereGeschlechter` wurde dem Element `PersonenstammdatenType` hinzugefügt, um Geschlechtsänderungen erfassbar zu machen.
- Das Element `geburtsort` wurde optional gemacht, da bei Personen mit Schweizer Staatsbürgerschaft stattdessen der Heimatort erfasst wird.
- Im Element `geburtsort` wurde statt dem Element `ort` das Element `land` verpflichtend gemacht, da der Geburtsort vermutlich nur bei Personen ohne Schweizer Staatsbürgerschaft erfasst wird.
- Das Element `heimatorte` wurde dem Element `PersonenstammdatenType` hinzugefügt.
- Das Element `herkunftsland` wurde dem Element `PersonenstammdatenType` hinzugefügt, damit das Herkunftsland vom Geburtsland unterschieden werden kann.
- Das Element `familienstand` wurde zu `zivilstand` umbenannt, da dies die Schweizerische Bezeichnung ist.
- Das Element `religionszugehoerigkeit` wurde entfernt, da diese Angabe in der Schweiz nicht erhoben wird.
- Dem Element `hochschulzulassungsberechtigung` wurden die Elemente `maturatyp` und `schule` hinzugefügt.

#### Im Element StudienverlaufType

- Das Element `studiensemester` wurde wiederholbar gemacht.
- Das Element `semesterwochenstunden` wurde dem Element `studiensemester` hinzugefügt.
- Das Element `hoerstatus` wurde auf `hoererstatus` umbenannt.
- Das Element `finanzierung` wurde dem Element `studiensemester` hinzugefügt, um Stipendien oder die Selbstfinanzierung bei Doktorierenden zu erfassen.

#### Im Element StudienleistungType

- Das Element `studienabteilung` wurde dem Element `studiengang` hinzugefügt, damit darin das `departement`, die `fakultaet` oder das `institut` erfasst werden kann.
- Das Element `geltendeDoktoratsverordnung` wurde dem Element `studiengang` hinzugefügt.
- Das Element `auszeichnungen` wurde dem Element `leistung` hinzugefügt.
- Das Element `doktorarbeit` wurde dem Element `leistung` hinzugefügt, in dem spezifische Angaben zu Doktorarbeiten erfasst werden können.

#### Neu hinzugefügte oder entfernte Complex Types

- Das Element `HeimatortType` wurde hinzugefügt, um den Heimatort von Personen mit Schweizer Staatsbürgerschaft zu erfassen.
- Das Element `DoktorarbeitType` wurde hinzugefügt, welches spezifische Angaben zu Doktorarbeiten erfasst.
- Das Element `StudiengangType` wurde hinzugefügt, um die Sprache als eigenes Element zu erfassen.
- Das Element `FachrichtungType` wurde hinzugefügt, um die Sprache als eigenes Element zu erfassen.
- Das Element `AnschriftStud` wurde entfernt, da die Unterscheidung von der Heimatanschrift und Semesteranschrift nicht über Attribute gelöst wird, sondern über zwei separate Elemente.
- Das Element `GeldbetragType` wurde hinzugefügt, um Geldbeträge im Element `finanzierung` zu erfassen.
- Das Element `NonEmptyWithLang` wurde entfernt, da die Sprachkennzeichnung nicht über Attribute gelöst wird.

#### Sonstige Anpassungen

- Die Elemente `landkreis` wurden auf `kanton` umbenannt.
- Das Element `anschriftenszusatz` wurde im Complex Type `AnschriftType` auf `adresszusatz` umbenannt.
