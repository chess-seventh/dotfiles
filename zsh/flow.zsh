# =========================
# SH FLOW
# =========================
alias p='pwd'
alias tmux='tmux -2'
alias ping='prettyping'
alias pping='/usr/bin/ping'
alias grep='grep --color=auto'
alias ls='k -h'
alias ll='k -hA'
alias l='k -h'
alias df='df -h'
alias snano='sudo nano'
alias grep='grep --color=auto'
alias dmesg='dmesg -T'
alias pist='pbpst -S -f '

alias meteog='curl wttr.in/geneva'
alias meteol='curl wttr.in/lausanne'
alias meteo='curl wttr.in/$0'

alias dotfiles='cd ~/.dotfiles/'
alias eth='sudo dhcpcd enp0s31f6'
alias mutt='cd $HOME/attachments/ ; neomutt -F ~/.mutt-proton/muttrc'
alias feh='feh --scale-down --auto-zoom'

alias shome='sh $HOME/.screenlayout/home.sh'
alias slapt='sh $HOME/.screenlayout/laptop.sh'

#
# =========================
# FILE EDITING
# =========================

alias muttrc='vim ~/.mutt/muttrc'
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias svim='sudo vim'

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
        if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
        rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
        local pid
        if [ "$UID" != "0" ]; then
                pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
        else
                pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        fi

        if [ "x$pid" != "x" ]
        then
                echo $pid | xargs kill -${1:-9}
        fi
}

# fd - cd to selected directory
fd() {
        local dir
        dir=$(find ${1:-.} -path '*/\.*' -prune \
                -o -type d -print 2> /dev/null | fzf +m) &&
                cd "$dir"
        }

# fda - including hidden directories
fda() {
        local dir
        dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

cf() {
        # cf - fuzzy cd from anywhere
        # ex: cf word1 word2 ... (even part of a file name)
        # zsh autoload function
        local file

        file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

        if [[ -n $file ]]
        then
                if [[ -d $file ]]
                then
                        cd -- $file
                else
                        cd -- ${file:h}
                fi
        fi
}

cdf() {
        local file
        local dir
        file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# Use fd and fzf to get the args to a command.
# Works only with zsh
# Examples:
# f mv # To move files. You can write the destination after selecting the files.
# f 'echo Selected:'
# f 'echo Selected music:' --extention mp3
# fm rm # To rm files in current directory
f() {
        sels=( "${(@f)$(fd "${fd_default[@]}" "${@:2}"| fzf)}" )
        test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
}

# Like f, but not recursive.
fm() f "$@" --max-depth 1



setopt HIST_IGNORE_SPACE
alias jrnlw=" jrnl work"
alias jrnln=" jrnl notes"

fjrnl_notes() {
        title=$(jrnl notes --short | fzf --tac --no-sort) &&
                jrnl notes -on "$(echo $title | cut -c 1-16)" $1
        }

fjrnl_work() {
        title=$(jrnl work --short | fzf --tac --no-sort) &&
                jrnl work -on "$(echo $title | cut -c 1-16)" $1
        }



fb() {
        # buku
        # save newline separated string into an array
        mapfile -t website <<< "$(buku -p -f 5 | column -ts$'\t' | fzf --multi)"

    # open each website
    for i in "${website[@]}"; do
            index="$(echo "$i" | awk '{print $1}')"
            buku -p "$index"
            buku -o "$index"
    done
}


fcat () {
        fzf --preview 'cat {}'
}

eip() {
        curl http://ifconfig.me
}
