# Kitty SSH Tab Color Mapping

This setup makes Kitty tab background colors change based on SSH target.

- Local shell prompt: tab colors reset to theme defaults.
- `ssh` / `mosh` session: tab gets a deterministic color based on remote target.

Why `eva` and `evb` looked the same before:

- the old mapper split a single integer hash straight into RGB bitfields
- short, similar hostnames often differed only in the lowest bits
- that changed only one channel slightly, so the final colors were nearly identical

The updated mapper below uses:

- 32-bit FNV-1a for stable string hashing
- full-wheel hue selection from the hash
- fixed high saturation/value so different targets stay visually far apart
- a lighter inactive color derived from the active color

## Kitty Config (required)

In `~/.config/kitty/kitty.conf`, ensure:

```conf
allow_remote_control yes
```

Restart Kitty (or open a new Kitty OS window) after changing this.

## Zsh Hook (verified)

Status: verified on this machine.

Put the hook logic in a separate file under `~/.config/kitty/` and source it from `~/.zshrc`.

Installed hook file:

```zsh
~/.config/kitty/ssh-tab-color.sh
```

Minimal `~/.zshrc` line:

```zsh
source ~/.config/kitty/ssh-tab-color.sh
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

  _codex_kitty_hash_u32_bash() {
    local input="$1" i ch ord h=2166136261
    for (( i=0; i<${#input}; i++ )); do
      ch=${input:i:1}
      printf -v ord '%d' "'$ch"
      h=$(( (h ^ ord) * 16777619 ))
      h=$(( h & 0xffffffff ))
    done
    printf '%s\n' "$h"
  }

  _codex_kitty_hsv_to_rgb_bash() {
    local h="$1" s="$2" v="$3"
    local sector remainder p q t r g b

    sector=$(( h / 60 ))
    remainder=$(( ((h % 60) * 255) / 60 ))
    p=$(( (v * (255 - s)) / 255 ))
    q=$(( (v * (255 - ((s * remainder) / 255))) / 255 ))
    t=$(( (v * (255 - ((s * (255 - remainder)) / 255))) / 255 ))

    case "$sector" in
      0) r=$v; g=$t; b=$p ;;
      1) r=$q; g=$v; b=$p ;;
      2) r=$p; g=$v; b=$t ;;
      3) r=$p; g=$q; b=$v ;;
      4) r=$t; g=$p; b=$v ;;
      *) r=$v; g=$p; b=$q ;;
    esac

    printf '%s %s %s\n' "$r" "$g" "$b"
  }

  _codex_kitty_ssh_tab_debug_preexec() {
    __codex_last_command="$BASH_COMMAND"
  }

  _codex_kitty_ssh_tab_precmd() {
    local target hash h hue sat val r g b ir ig ib active_bg inactive_bg
    local -a rgb

    target="$(_codex_kitty_extract_remote_target_bash "$__codex_last_command")"
    if [[ $? -ne 0 ]]; then
      kitten @ set-tab-color --match "window_id:${KITTY_WINDOW_ID}" active_bg=NONE inactive_bg=NONE >/dev/null 2>&1
      return
    fi

    hash="$(_codex_kitty_hash_u32_bash "$target")"
    h=$hash

    hue=$(( h % 360 ))
    sat=$(( 210 + ((h >> 9) % 36) ))
    val=$(( 180 + ((h >> 15) % 48) ))
    read -r r g b < <(_codex_kitty_hsv_to_rgb_bash "$hue" "$sat" "$val")

    ir=$((r + 22)); (( ir > 255 )) && ir=255
    ig=$((g + 22)); (( ig > 255 )) && ig=255
    ib=$((b + 22)); (( ib > 255 )) && ib=255

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
