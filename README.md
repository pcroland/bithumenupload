![logo](https://i.kek.sh/coQmSWoCfSX.png)
# bhup
### Feltöltő script BitHUmenre eredeti release-ekhez film és sorozat kategóriában.
## Leírás
* A script automatikusan készít torrent és NFO fájlt a megadott inputokhoz, ha valamelyik még nincs.
* A feltöltési kategóriát mappanévből állapítja meg.
* A script az `~/.ncup/` mappában tárolja a cookies fájlt.
## Szükséges programok
* `curl`
* `mktorrent`
* `mediainfo` (ha a feltölteni kívánt mappában nincs NFO fájl, a script létrehoz egyet)
## Telepítés
* `install -D -m 755 <(curl -fsSL git.io/JJ94i) ~/.local/bin/bhup`

(Ha a `~/.local/bin` nincs benne PATH-ban, akkor írjuk be a `.bashrc`/`.zshrc` fájlunkba hogy: `PATH="$HOME/.local/bin:$PATH"`.)
* `hash -r && ncup -d && ncup -e`
* A `cookies.txt` fájlt a `~/.bhup` mappába másoljuk.
* `ncup -c` paranccsal tudjuk szerkeszteni a config fájlunkat.
## Használat
```sh
bhup [input(s)]
```
