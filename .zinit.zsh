#!/usr/bin/env bash

EXCLUDE_DIRS='
.git go virtualenvs node_modules __pycache__ cache jsm build debug release
dist dist-newstyle mod pkg __MACOSX nltk_data wekafiles libchart fpdf16'

EXCLUDE_STRING=$(echo -n "$EXCLUDE_DIRS" | tr ' ' '\n' | \
                   sed 's/^/--exclude /' | paste -sd' ')

# fzf
export FZF_DEFAULT_COMMAND="fd --type f $EXCLUDE_STRING --follow"
FZF_BINDINGS='
# Global
esc:abort
ctrl-y:execute-silent(echo {+} | xclip)

# Navigation
ctrl-g:top
ctrl-b:half-page-up
ctrl-d:half-page-down
ctrl-k:up
ctrl-j:down
ctrl-space:jump

# Prompt
alt-h:backward-char
alt-l:forward-char
alt-b:backward-word
alt-f:forward-word
ctrl-a:beginning-of-line
ctrl-e:end-of-line
ctrl-u:unix-line-discard
ctrl-w:unix-word-rubout

# Selection
alt-c:clear-selection
alt-e:select-all
alt-t:toggle-all
tab:toggle+down
shift-tab:toggle+up

# Preview
alt-u:preview-page-up
alt-d:preview-page-down
alt-j:preview-down+preview-down+preview-down
alt-k:preview-up+preview-up+preview-up
alt-c:toggle-preview

# History
alt-p:previous-history
alt-n:next-history
'

FZF_BINDINGS_STRING=$(echo -n "$FZF_BINDINGS" | grep -e '^[^#]' |
                        tr '\n' ',' | sed -E 's/.$//')

FZF_COLORS="
dark
hl:$col_lime
fg+:$col_fg
bg+:$col_blue20
hl+:$col_lime
info:$col_fg
border:$col_fg10
prompt:$col_blue
pointer:$col_red
marker:$col_red
header:$col_fg50
gutter:-1
spinner:$col_blue
"
FZF_COLORS_STRING="$( echo -n "$FZF_COLORS" | grep -e '^[^#]' | paste -sd',' )"

export FZF_DEFAULT_OPTS="
  --exit-0 --multi --info=inline
  --no-border --layout=reverse
  --height 99% --no-mouse
  --preview-window='down:70%:wrap'
  --bind='$FZF_BINDINGS_STRING'
  --color='$FZF_COLORS_STRING'
"

# fzf-tab
zstyle ':fzf-tab:*' fzf-bindings \
  "$FZF_BINDINGS_STRING"
zstyle ':fzf-tab:*' fzf-flags --height 50%
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-flags --height 70%

fzf_preview_params() {
  TARGET_PREV_WIDTH="${1:-95}"
  SWITCH_LAYOUT_WIDTH="${2:-105}"

  MAX_WIDTH=$(( 3 * COLUMNS / 5 ))
  PREV_WIDTH=$(( TARGET_PREV_WIDTH > MAX_WIDTH ? MAX_WIDTH : TARGET_PREV_WIDTH ))
  RIGHT_PREV="right:${PREV_WIDTH}:noborder:nowrap"

  if (( COLUMNS <= SWITCH_LAYOUT_WIDTH )); then
    echo 'up:71%:border:nowrap'
  else
    echo "$RIGHT_PREV"
  fi
}

# fzf utilities
# open files
ñf() {
  PREVIEW_COMMAND='
    [[ \$(file --mime {}) =~ binary ]] \
        && echo {} is a binary file \
        || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null'

  OUT=("$(
      fzf --query="$1" --preview="$PREVIEW_COMMAND" \
        --preview-window="$(fzf_preview_params)"  \
        --expect=ctrl-f \
        --history="$HOME/.fzf-open-file-history")")

  read -r KEY <<< "$OUT"
  OUT=$(tail -n +2 <<< "$OUT")
  read -r FIRST <<< "$OUT"

  # shellcheck disable=SC2128
  if [[ -n "$OUT" ]]; then
    if [[ "$KEY" == 'ctrl-f' ]]; then
      cd "$(dirname "$FIRST")"
    else
      xargs -d'\n' "${EDITOR:-nvim}" <<< "$OUT"
    fi
  fi
}

# go to folder
zd() {
  PREVIEW_COMMAND='exa --color always --tree --level=2 --icons --git-ignore {}'
  cd "$(\
    FZF_DEFAULT_COMMAND="fd --type d $EXCLUDE_STRING" \
    fzf --no-multi \
        --exit-0 \
        --preview="$PREVIEW_COMMAND" \
        --preview-window="$(fzf_preview_params 50)" \
        --history="$HOME/.fzf-zd-history")"
}

# search regex
ñg() {
  FUZZY=0

  if [[ "$1" =~ 'fuzzy' ]]; then
    FUZZY=1
    shift
  fi

  COMMAND_FMT='rg --column --line-number --no-heading --color=always --smart-case -- %b || true'
  # shellcheck disable=SC2059
  INITIAL_COMMAND=$(printf "$COMMAND_FMT" "'$1'")
  # shellcheck disable=SC2059
  RELOAD_COMMAND="$(printf "$COMMAND_FMT" "{q}")"

  ARGS=(
    --ansi
    --query "$1"
    '--preview=fzf_rg_preview {}'
    --delimiter :
    "--preview-window=$(fzf_preview_params 100 180):+{2}-/2"
    "--history=$HOME/.fzf-rg-history"
  )

  if (( $FUZZY == 0 )); then
    ARGS+=(
      --disabled
      --bind "change:reload:$RELOAD_COMMAND"
    )
  fi

  RESULT=$(eval "$INITIAL_COMMAND" | fzf "${ARGS[@]}")

  if [[ -n "$RESULT" ]]; then
    if (( $(echo -n "$RESULT" | wc -l) > 1 )); then
      ${EDITOR:-nvim} -q <(echo -n "$RESULT")
    else
      ${EDITOR:-nvim} "$(echo "$RESULT" | cut -d: -f1-3)"
    fi
  fi
}

alias ñr='ñg --fuzzy'

# forgit
export forgit_log=gitl
export forgit_diff=gitd
export forgit_add=gita
export forgit_checkout_file=gitr
export forgit_reset_head=gitu
export forgit_ignore=gitignore
export forgit_stash_show=gitstash

# vim easymotion
bindkey -M vicmd 'ñ' vi-easy-motion
export EASY_MOTION_TARGET_KEYS='fasjuirwzmkhdoe'

