autoload -Uz promptinit

promptinit

source $HOME/.zsh/exports.zsh
source $HOME/.zsh/global_vars.zsh

HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
HELMFILE_HELM3=1

# ****************************
# SOURCE FILES
# ****************************

source /usr/bin/virtualenvwrapper.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
alias saws='source /usr/sbin/aws_zsh_completer.sh'

source $HOME/.antigen/antigen.zsh

for i in $(/usr/bin/ls ~/.zsh/*.zsh); do
        source "$i"
done

if [ "$TMUX" = "" ]; then tmux new-session -A -s aboa ; fi

autoload -U colors; colors

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit

zmodload zsh/mapfile

compinit -i
stty -ixon

[[ -s /etc/profile.d/autojump.zsh ]] && source /etc/profile.d/autojump.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

