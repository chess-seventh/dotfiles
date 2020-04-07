
vim_commands=(vi vim gvim mvim nvim)

_run_vim_wrapper() {
        local cmd
        for arg in $@; do
                cmd="$cmd \"${arg/:/\" \"+:}\""
        done
        eval $cmd
}

for cmd in $vim_commands; do
        eval "function ${cmd}_wrapper () { _run_vim_wrapper $cmd \$@}"
        alias $cmd=${cmd}_wrapper
done
function helpme {
        curl cheat.sh/"$1" | less
}

set -o vi

vf() {
        # open file with vim
        local files

        files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

        if [[ -n $files ]]
        then
                vim -- $files
                print -l $files[1]
        fi
}

