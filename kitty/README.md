# Kitty SSH Tab Color Mapping

This setup makes Kitty tab background colors change based on SSH target.

- Local shell prompt: tab colors reset to theme defaults.
- `ssh` / `mosh` session: tab gets a deterministic color based on remote target.

## Kitty Config (required)

In `~/.config/kitty/kitty.conf`, ensure:

```conf
allow_remote_control yes
```

Restart Kitty (or open a new Kitty OS window) after changing this.

## Zsh Hook (verified)

Status: verified on this machine.

Add the block below to `~/.zshrc`:

```zsh
# >>> codex kitty ssh tab color >>>
# Color the current kitty tab by SSH target (stable hash-like mapping).
# Reset to theme defaults when back at the local prompt.
if [[ -n "$KITTY_WINDOW_ID" ]]; then
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
          # Common options with separate value (for ssh/mosh)
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

  function _codex_kitty_hash_color_index() {
    emulate -L zsh
    local input="$1" ch ord
    integer -i 10 h=5381 i
    for (( i = 1; i <= ${#input}; i++ )); do
      ch="$input[i]"
      ord=$(printf '%d' "'$ch")
      (( h = ((h << 5) + h + ord) & 0x7fffffff ))
    done
    print -r -- "$h"
  }

  function _codex_kitty_ssh_tab_preexec() {
    emulate -L zsh
    local target hash active_bg inactive_bg
    integer -i 10 h r g b ir ig ib

    target="$(_codex_kitty_extract_remote_target "$1")"
    [[ $? -ne 0 ]] && return 0
    hash="$(_codex_kitty_hash_color_index "$target")"
    h="$hash"

    # Deterministic "hash-like" RGB mapping per target.
    (( r = 72 + ( h        & 0x7F ) ))
    (( g = 72 + ((h >> 7 ) & 0x7F ) ))
    (( b = 72 + ((h >> 14) & 0x7F ) ))
    (( ir = r + 36, ig = g + 36, ib = b + 36 ))
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
    kitten @ set-tab-color --match "window_id:${KITTY_WINDOW_ID}" active_bg=NONE inactive_bg=NONE >/dev/null 2>&1
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _codex_kitty_ssh_tab_preexec
  add-zsh-hook precmd _codex_kitty_ssh_tab_precmd
fi
# <<< codex kitty ssh tab color <<<
```

Reload shell:

```zsh
source ~/.zshrc
```

## Bash Hook (not yet verified)

Status: not yet verified on this machine.

Add this to `~/.bashrc`:

```bash
# >>> codex kitty ssh tab color (bash) >>>
if [[ -n "$KITTY_WINDOW_ID" ]]; then
  __codex_last_command=""

  _codex_kitty_extract_remote_target_bash() {
    local cmd="$1" token expect_arg=0 first=1
    local -a words

    # Simple split (does not fully preserve complex shell quoting)
    read -r -a words <<< "$cmd"
    [[ ${#words[@]} -eq 0 ]] && return 1

    case "${words[0]}" in
      ssh|mosh) ;;
      *) return 1 ;;
    esac

    for token in "${words[@]:1}"; do
      if [[ $expect_arg -eq 1 ]]; then
        expect_arg=0
        continue
      fi

      [[ "$token" == "--" ]] && continue

      if [[ "$token" == -* ]]; then
        case "$token" in
          --*=*) continue ;;
          -B|-b|-c|-D|-E|-e|-F|-I|-i|-J|-L|-l|-m|-O|-o|-p|-Q|-R|-S|-W|-w|--ssh|--predict|--family|--port)
            expect_arg=1
            ;;
        esac
        continue
      fi

      printf '%s\n' "$token"
      return 0
    done

    return 1
  }

  _codex_kitty_hash_color_index_bash() {
    local input="$1" i ch ord h=5381
    for (( i=0; i<${#input}; i++ )); do
      ch=${input:i:1}
      printf -v ord '%d' "'$ch"
      h=$(( ((h << 5) + h + ord) & 0x7fffffff ))
    done
    printf '%s\n' "$h"
  }

  _codex_kitty_ssh_tab_debug_preexec() {
    __codex_last_command="$BASH_COMMAND"
  }

  _codex_kitty_ssh_tab_precmd() {
    local target hash h r g b ir ig ib active_bg inactive_bg

    target="$(_codex_kitty_extract_remote_target_bash "$__codex_last_command")"
    if [[ $? -ne 0 ]]; then
      kitten @ set-tab-color --match "window_id:${KITTY_WINDOW_ID}" active_bg=NONE inactive_bg=NONE >/dev/null 2>&1
      return
    fi

    hash="$(_codex_kitty_hash_color_index_bash "$target")"
    h=$hash

    r=$((72 + ( h        & 0x7F ) ))
    g=$((72 + ((h >> 7 ) & 0x7F ) ))
    b=$((72 + ((h >> 14) & 0x7F ) ))
    ir=$((r + 36)); (( ir > 255 )) && ir=255
    ig=$((g + 36)); (( ig > 255 )) && ig=255
    ib=$((b + 36)); (( ib > 255 )) && ib=255

    printf -v active_bg '#%02X%02X%02X' "$r" "$g" "$b"
    printf -v inactive_bg '#%02X%02X%02X' "$ir" "$ig" "$ib"

    kitten @ set-tab-color \
      --match "window_id:${KITTY_WINDOW_ID}" \
      active_bg="$active_bg" \
      inactive_bg="$inactive_bg" \
      >/dev/null 2>&1
  }

  trap '_codex_kitty_ssh_tab_debug_preexec' DEBUG
  PROMPT_COMMAND="_codex_kitty_ssh_tab_precmd${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi
# <<< codex kitty ssh tab color (bash) <<<
```

Reload shell:

```bash
source ~/.bashrc
```

## Notes

- Works only in Kitty because it uses `kitten @ set-tab-color`.
- Requires being in a real Kitty window (`KITTY_WINDOW_ID` set).
- For non-`ssh` / non-`mosh` commands, color is reset to defaults.
