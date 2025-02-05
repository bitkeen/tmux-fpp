#!/usr/bin/env bash

get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z $option_value ]; then
    echo $default_value
  else
    echo $option_value
  fi
}

readonly key="$(get_tmux_option "@fpp-key" "f")"

tmux bind-key "$key" capture-pane -J \\\; \
    save-buffer "/tmp/tmux-buffer" \\\; \
    delete-buffer \\\; \
    new-window -n pe -c "#{pane_current_path}" 'sh -c "vim \"$(cat /tmp/tmux-buffer | path-extractor | fzf)\" ; rm /tmp/tmux-buffer"'
