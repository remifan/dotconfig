# Intended to be sourced from zsh.
# Colors the current Kitty tab by SSH target and resets on the local prompt.

if [[ -z "${ZSH_VERSION:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi

if [[ -n "${_CODEX_KITTY_SSH_TAB_COLOR_LOADED:-}" ]]; then
  return 0
fi
typeset -g _CODEX_KITTY_SSH_TAB_COLOR_LOADED=1

autoload -Uz add-zsh-hook

function _codex_kitty_extract_remote_target() {
  emulate -L zsh
  local -a words
  local cmd expect_arg=0 word

  words=("${(z)1}")
  (( ${#words} == 0 )) && return 1
  cmd="$words[1]"
  case "$cmd" in
    ssh|mosh) ;;
    *) return 1 ;;
  esac

  for word in "${words[@]:1}"; do
    if (( expect_arg )); then
      expect_arg=0
      continue
    fi

    [[ "$word" == "--" ]] && continue

    if [[ "$word" == -* ]]; then
      if [[ "$word" == --*=* ]]; then
        continue
      fi
      case "$word" in
        -B|-b|-c|-D|-E|-e|-F|-I|-i|-J|-L|-l|-m|-O|-o|-p|-Q|-R|-S|-W|-w|--ssh|--predict|--family|--port)
          expect_arg=1
          ;;
      esac
      continue
    fi

    print -r -- "$word"
    return 0
  done

  return 1
}

function _codex_kitty_hash_u32() {
  emulate -L zsh
  local input="$1" ch ord
  integer -i 10 h=2166136261 i

  for (( i = 1; i <= ${#input}; i++ )); do
    ch="$input[i]"
    ord=$(printf '%d' "'$ch")
    (( h = (h ^ ord) * 16777619 ))
    (( h &= 0xffffffff ))
  done

  print -r -- "$h"
}

function _codex_kitty_hsv_to_rgb() {
  emulate -L zsh
  integer -i 10 h="$1" s="$2" v="$3"
  integer -i 10 sector remainder p q t r g b

  (( sector = h / 60 ))
  (( remainder = ((h % 60) * 255) / 60 ))
  (( p = (v * (255 - s)) / 255 ))
  (( q = (v * (255 - ((s * remainder) / 255))) / 255 ))
  (( t = (v * (255 - ((s * (255 - remainder)) / 255))) / 255 ))

  case "$sector" in
    0) r=$v; g=$t; b=$p ;;
    1) r=$q; g=$v; b=$p ;;
    2) r=$p; g=$v; b=$t ;;
    3) r=$p; g=$q; b=$v ;;
    4) r=$t; g=$p; b=$v ;;
    *) r=$v; g=$p; b=$q ;;
  esac

  printf '%d %d %d\n' "$r" "$g" "$b"
}

function _codex_kitty_ssh_tab_preexec() {
  emulate -L zsh
  local target hash active_bg inactive_bg
  local -a rgb
  integer -i 10 h hue sat val r g b ir ig ib

  [[ -z "${KITTY_WINDOW_ID:-}" ]] && return 0

  target="$(_codex_kitty_extract_remote_target "$1")"
  [[ $? -ne 0 ]] && return 0
  hash="$(_codex_kitty_hash_u32 "$target")"
  h="$hash"

  (( hue = h % 360 ))
  (( sat = 210 + ((h >> 9) % 36) ))
  (( val = 180 + ((h >> 15) % 48) ))
  rgb=($(_codex_kitty_hsv_to_rgb "$hue" "$sat" "$val"))
  r="$rgb[1]"
  g="$rgb[2]"
  b="$rgb[3]"

  (( ir = r + 22, ig = g + 22, ib = b + 22 ))
  (( ir > 255 )) && ir=255
  (( ig > 255 )) && ig=255
  (( ib > 255 )) && ib=255
  active_bg=$(printf "#%02X%02X%02X" "$r" "$g" "$b")
  inactive_bg=$(printf "#%02X%02X%02X" "$ir" "$ig" "$ib")

  kitten @ set-tab-color \
    --match "window_id:${KITTY_WINDOW_ID}" \
    active_bg="$active_bg" \
    inactive_bg="$inactive_bg" \
    >/dev/null 2>&1
}

function _codex_kitty_ssh_tab_precmd() {
  [[ -z "${KITTY_WINDOW_ID:-}" ]] && return 0
  kitten @ set-tab-color \
    --match "window_id:${KITTY_WINDOW_ID}" \
    active_bg=NONE \
    inactive_bg=NONE \
    >/dev/null 2>&1
}

add-zsh-hook preexec _codex_kitty_ssh_tab_preexec
add-zsh-hook precmd _codex_kitty_ssh_tab_precmd
