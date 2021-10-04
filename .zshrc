# Enable colors and change prompt:
#autoload -U colors && colors
# History in cache directory:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

# Auto tab completion stuff:
zmodload zsh/complist
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*:options' list-colors '=^(-- *)=34'
zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

_comp_options+=(globdots)		# Include hidden files.
autoload -Uz compinit
if [[ -n $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION(#qN.mh+24) ]]; then
	compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION;
else
	compinit -C;
fi;

# cd without cd
setopt correct
setopt  auto_cd

# plugins
source ~/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/.config/zsh/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-history-substring-search.zsh

# autosuggest
zmodload zsh/zpty
ZSH_AUTOSUGGEST_STRATEGY=(completion history match_prev_cmd)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=10
ZSH_AUTOSUGGEST_USE_ASYNC=1

# for nnn icons

 export LANG=en_US.UTF-8

# aliases
## config aliases
alias sc="nv ~/.config/sxhkd/sxhkdrc"
alias nc="nv ~/.config/nvim/init.vim"
alias zc="nvim ~/.zshrc"

## misc niceties

alias np="ncmpcpp"
alias rt="rtorrent"
alias ls='lsd '
alias nb="newsboat"
alias d="git --git-dir=$HOME/dl/git/dotfiles/ --work-tree=$HOME "
alias nm="neomutt"
alias pb="podboat"
alias nv="nvim"

## program aliases due to xdg, etc
alias zul="zulip-term -c ~/.config/zulip/zuliprc "
alias vim="vim -i NONE"
alias wget="wget --hsts-file="$XDG_CACHE_HOME/wget-hsts" "
alias grep="grep --color=always"
alias cp="advcp -gv"
alias mv="advmv -gv"
alias abook="abook -C "$XDG_CONFIG_HOME"/abook/abookrc --datafile "$XDG_DATA_HOME"/abook/adressbook"
alias weechat="weechat -d "$XDG_CONFIG_HOME"/weechat"
alias mbsync="mbsync -c "$XDG_CONFIG_HOME"/isync/mbsyncrc"
# history plugin bindkeys and other keybindings

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# NNN

n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
         NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    #export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef
    nnn -cdrUAx "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
# ssh agent
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
# prompt

eval "$(starship init zsh)"
