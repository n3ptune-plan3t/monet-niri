if status is-interactive
    fastfetch
    set -U fish_greeting ""
end

# Make sure local user binaries come first
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
