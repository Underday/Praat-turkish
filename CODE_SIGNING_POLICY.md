# Code signing policy

*Türkçe özet aşağıda.*

Praat Türkçe is a modified, unofficial build of [Praat](https://www.praat.org) (GPL-3.0-or-later) with a Turkish user interface and a plugin of Turkish analysis tools. This page describes how its Windows releases are signed.

Free code signing provided by [SignPath.io](https://about.signpath.io/), certificate by [SignPath Foundation](https://signpath.org/).

**Status:** application to the SignPath Foundation open source program is pending. Until it is approved, releases are not signed. This page will name the first signed release.

## What is signed

- Signed: `Praat.exe` in the Windows package (`Praat-tr-<version>-win-x64.zip`) on the [Releases page](https://github.com/Underday/Praat-turkish/releases).
- Not signed: the Linux package, and the text and script files in the package (dictionary, plugin scripts, readme, license).

Only binaries built from this repository by the [release workflow](.github/workflows/surum.yml) on GitHub Actions are submitted for signing. Nothing built on a personal computer is signed. Each signed build comes from a tagged commit (`tr-v<version>`) in this repository.

## Team and roles

The project has a single maintainer.

| Role | Members |
|---|---|
| Committers and reviewers | [Underday](https://github.com/Underday) |
| Approvers | [Underday](https://github.com/Underday) |

Changes from other people are accepted only as pull requests and are reviewed by the maintainer before they are merged. Every signing request is approved manually. The maintainer uses multi-factor authentication for GitHub and SignPath.

## Upstream code

Most of the source code is Praat by Paul Boersma and David Weenink, taken unchanged from [praat/praat](https://github.com/praat/praat) and updated from there. The Turkish interface layer, the dictionary and the plugin are maintained in this repository. The signed `Praat.exe` is built from this repository's full source tree; no upstream binaries are signed.

## Privacy policy

When Praat Türkçe opens with its window (not in script or batch mode), it sends one request to the GitHub API (`https://api.github.com/repos/Underday/Praat-turkish/releases/latest`) with `curl` to see whether a newer version exists. GitHub receives the usual request data (IP address, curl's user agent). No recordings, analysis results, file names, settings or other personal information are sent.

To turn this off, set the environment variable `PRAAT_CEVIRI_ACILIS=0`. The startup window and the check are then skipped.

Apart from this, the program does not transfer any information to other networked systems unless the user asks for it, for example by clicking "Open download page" or by running a script that does so.

## Installation and removal

There is no installer and the program makes no system changes. To install, extract the zip file to a folder. To remove, delete that folder. Praat keeps its preferences in `%APPDATA%\Praat` (Windows) or `~/.config/praat` (Linux); delete that folder too to remove all settings, including `ceviri_ayar.txt`.

---

## Türkçe özet

- Windows paketindeki `Praat.exe`, SignPath Foundation'ın açık kaynak programıyla ücretsiz imzalanacak. Başvuru sürüyor; onaylanana kadar sürümler imzasızdır.
- Yalnızca bu depodan GitHub Actions'ta derlenen dosyalar imzalanır.
- Proje tek kişi tarafından sürdürülüyor: [Underday](https://github.com/Underday). Her imza isteği elle onaylanır.
- Gizlilik: Program pencereyle açılınca GitHub'a yeni sürüm olup olmadığını bir kez sorar. Kayıt, sonuç ya da kişisel bilgi gönderilmez. Kapatmak için `PRAAT_CEVIRI_ACILIS=0` ortam değişkeni.
- Kaldırma: Programın klasörünü silin. Ayarlar için `%APPDATA%\Praat` klasörünü de silebilirsiniz.
