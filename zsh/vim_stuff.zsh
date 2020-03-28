
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

# zz - smart directory changer
# 14dec2015  +chris+
# 15dec2015  +chris+ clean up nonexisting paths
chpwd_zz() {
  print -P '0\t%D{%s}\t1\t%~' >>~/.zz
}

zz() {
  awk -v ${(%):-now='%D{%s}'} <~/.zz '
    function r(t,f) {
      age = now - t
      return (age<3600) ? f*4 : (age<86400) ? f*2 : (age<604800) ? f/2 : f/4
    }
    { f[$4]+=$3; if ($2>l[$4]) l[$4]=$2 }
    END { for(i in f) printf("%d\t%d\t%d\t%s\n",r(l[i],f[i]),l[i],f[i],i) }' |
      sort -k2 -n -r | sed 9000q | sort -n -r -o ~/.zz
  if (( $# )); then
    local p=$(awk 'NR != FNR { exit }  # exit after first file argument
                   { for (i = 3; i < ARGC; i++) if ($4 !~ ARGV[i]) next
                     print $4; exit }' ~/.zz ~/.zz "$@")
    [[ $p ]] || return 1
    local op=print
    [[ -t 1 ]] && op=cd
    if [[ -d ${~p} ]]; then
      $op ${~p}
    else
      # clean nonexisting paths and retry
      while read -r line; do
        [[ -d ${~${line#*$'\t'*$'\t'*$'\t'}} ]] && print -r $line
      done <~/.zz | sort -n -r -o ~/.zz
      zz "$@"
    fi
  else
    sed 10q ~/.zz
  fi
}

alias z=' zz'

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

