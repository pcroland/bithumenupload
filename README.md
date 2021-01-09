# bhup
### Feltöltő script BitHUmenre eredeti release-ekhez film és sorozat kategóriában.
## Leírás
* A script automatikusan készít torrent és NFO fájlt a megadott inputokhoz, ha valamelyik még nincs.
* A feltöltési kategóriát mappanévből állapítja meg.
* A script az `~/.ncup/` mappában tárolja a cookies fájlt.
## Szükséges programok
* `curl`
* `mktorrent`
* `chtor`
* `mediainfo` (ha a feltölteni kívánt mappában nincs NFO fájl, a script létrehoz egyet)
## Telepítés
* `install -D -m 755 <(curl -fsSL git.io/JLpSv) ~/.local/bin/bhup`\
(Ha a `~/.local/bin` nincs benne PATH-ban, akkor írjuk be a `.bashrc`/`.zshrc` fájlunkba hogy: `PATH="$HOME/.local/bin:$PATH"`.)
* `hash -r`
* A `cookies.txt` fájlt a `~/.bhup` mappába másoljuk.
## Frissítés
* `install -D -m 755 <(curl -fsSL git.io/JLpSv) ~/.local/bin/bhup`
## Használat
```sh
bhup [input(s)]
```
