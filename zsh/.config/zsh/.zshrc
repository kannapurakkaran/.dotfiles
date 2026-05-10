
# ── Export Paths ────────────────────────────────
export PATH=$PATH:$HOME/.local/share

export EDITOR=nvim

# ── Plugins ─────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# ── Download Zinit, if it's not there yet ───────
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# ── Source/Load zinit ───────────────────────────
source "${ZINIT_HOME}/zinit.zsh"

# ── Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# ── Add in snippets ─────────────────────────────
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
#zinit snippet OMZP::aws
#zinit snippet OMZP::kubectl
#zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# ── Load completions ────────────────────────────
autoload -Uz compinit && compinit

zinit cdreplay -q

# ── Enable OhMyPosh ─────────────────────────────
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/themes/zen.toml)"

# ── Keybindings ─────────────────────────────────
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# ── Aliases ─────────────────────────────────────
alias c='clear'
alias ls='eza -lh --group-directories-first --icons=auto'
alias ll='eza -al --group-directories-first --icons=always'
alias lt='eza -a --tree --level=2 --icons=always'
alias cat='bat --paging=never'
alias grep='rg'
alias ff='sudo fd -HI -a --exclude .snapshots'
alias top='btop'
alias fetch='fastfetch'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── History ─────────────────────────────────────
HISTSIZE=5000
HISTFILE=$ZDOTDIR/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ── Completion styling ──────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# ── Functions ───────────────────────────────────
# Smart cd: no args → home, valid dir → cd, otherwise → zoxide
zd() {
  if [[ -z "$1" ]]; then
    builtin cd ~
  elif [[ -d "$1" ]]; then
    builtin cd "$1"
  else
    __zoxide_z "$1"
  fi
}
alias cd='zd'

# Copy file content to clipboard
cp2c() { wl-copy < "$1"; }

# Paste clipboard to file
c2f() { wl-paste > "$1"; }

# Open file with default application (background)
open() { xdg-open "$@" &>/dev/null & disown; }

# Fuzzy find and preview files
is() { fzf --preview="bat --style=numbers --color=always {}"; }

# Fuzzy find and open in neovim
nis() { nvim "$(fzf --preview='bat --color=always {}')"; }

# ── Tool init ───────────────────────────────────
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

