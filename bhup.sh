#!/bin/bash
LC_ALL=C.UTF-8
LANG=C.UTF-8

cookies=~/.bhup/cookies.txt
script=~/.local/bin/bhup

if [[ -f "$cookies" ]]; then
  if [[ $(curl -s -I -b "$cookies" 'https://bithumen.be/' -o /dev/null -w '%{http_code}') == 200 ]]; then
    printf '\e[92m%s\e[0m\n' "Cookies OK."
  else
    printf '\e[91m%s\e[0m\n' "ERROR: cookies.txt does not work."
  fi
else
  printf '\e[91m%s\e[0m\n' "ERROR: cookies.txt is missing."
fi

for x in "$@"; do
  torrent_name=$(basename "$x")
  torrent_file="$torrent_name".torrent
  nfo_files=("$x"/*.nfo)
  nfo_file="${nfo_files[0]}"
  printf '\e[92m%s\e[0m\n' "$torrent_name"

  if (( ${#nfo_files[@]} > 1 )); then
    printf '\e[91m%s\e[0m\n' "ERROR: Multiple NFO files were found." >&2
    exit 1
  fi
  if [[ -f "$nfo_file" && -f "$torrent_file" ]]; then
    printf 'Already has NFO and torrent file.\n'
  else
    if [[ ! -f "$nfo_file" ]]; then
      printf 'Creating NFO.\n'
      mediainfo "$x" > "$x"/"$torrent_name".nfo
    fi
    if [[ ! -f "$torrent_file" ]]; then
      mktorrent -a http://bithumen.be:11337/announce -l 24 -o "$torrent_file" "$x" | while read -r; do printf '\r\e[K%s' "$REPLY"; done
    fi
  fi
done

printf '%.0s─' $(seq 1 "$(tput cols)")
for x in "$@"; do
  torrent_name=$(basename "$x")
  torrent_file="$torrent_name".torrent
  nfo_file=("$x"/*.nfo)
  printf '\e[92m%s\e[0m\n' "$torrent_name"

  resolution=$(grep -oP '\d+(?=[ip])' <<< "$torrent_name")

  if grep -qE "(S|E)[0-9][0-9]" <<< "$torrent_name"; then
    if grep -qEi "\.hun(\.|\-)" <<< "$torrent_name"; then
      if (( resolution >= 720 )); then
        type='41' # sorozat hun hd
      else
        type='7'  # sorozat hun sd
      fi
    else
      if (( resolution >= 720 )); then
        type='42' # sorozat hd
      else
        type='26' # sorozat sd
      fi
    fi
  else
    if grep -qEi "\.hun(\.|\-)" <<< "$torrent_name"; then
      if grep -qEi "(remux|bd25|bd50)" <<< "$torrentname"; then
        type='33' # film hun bluray
      elif (( resolution >= 1080 )); then
        type='37' # film hun 1080p
      elif (( resolution >= 720 )); then
        type='25' # film hun 720p
      else
        type='23' # film hun sd
      fi
    else
      if grep -qEi "(remux|bd25|bd50)" <<< "$torrentname"; then
        type='40' # film bluray
      elif (( resolution >= 1080 )); then
        type='39' # film 1080p
      elif (( resolution >= 720 )); then
        type='5'  # film 720p
      else
        type='19' # film sd
      fi
    fi
  fi

  printf 'Patching torrent file\n'
  chtor --reannounce-all=http://bithumen.be:11337/announce -s info.source=bH "$torrent_file" > /dev/null

  printf 'Uploading in category \e[93m%s\e[0m. ' "$type"
  description=''
  # shellcheck disable=SC2128
  torrent_link=$(curl -Ls -o /dev/null -w "%{url_effective}" "https://bithumen.be/takeupload.php" \
  -b "$cookies" \
  -F MAX_FILE_SIZE=20971520 \
  -F type="$type" \
  -F name="$torrent_name" \
  -F file=@"$torrent_file" \
  -F nfo=@"$nfo_file" \
  -F descr="$description")
#  torrent_id="${torrent_link//[!0-9]/}"
#  printf 'Downloading: \e[93m%s\e[0m\n' "$torrent_link"
#  curl "http://bithumen.be/download.php/${torrent_id}/a.torrent" -b "$cookies" -s -o "${torrent_name}_bh.torrent"
done
