
alias gitquick='git add . && git commit -m "git quick auto-commit" && git push'

# alias gst='git status'
# alias gc='git commit'
# alias gpl='git pull'
# alias gps='git push'

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'

_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

# fgst - pick files from `git status -s`
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fgst() {
  # "Nothing to see here, move along"
  is_in_git_repo || return

  local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    echo "$item" | awk '{print $2}'
  done
  echo
}

function git-fixup () {
  # git fixup
  # git rebase -i master --autosquash
  git ll -n 20 | fzf | cut -f 1 | xargs git commit --no-verify --fixup
}

fstash() {
  # fstash - easier way to deal with stashes
  # type fstash to get a list of your stashes
  # enter shows you the contents of the stash
  # ctrl-d shows a diff of the stash against your current HEAD
  # ctrl-b checks the stash out as a branch, for easier merging
  zmodload zsh/mapfile
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

fshow() {
  # fshow - git commit browser
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# fbr - checkout git branch (including remote branches)
fbrr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbrc() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
}


fco_preview() {
# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

git_dirs() {
  dir="$1"

  # No directory has been provided, use current
  if [ -z "$dir" ]; then
    dir="`pwd`"
  fi

  # Make sure directory ends with "/"
  if [[ $dir != */ ]]; then
    dir="$dir/*"
  else
    dir="$dir*"
  fi

  # Loop all sub-directories
  for f in $dir; do
  # Only interested in directories
    [ -d "${f}" ] || continue

  # Check if directory is a git repository
    if [ -d "$f/.git" ]; then
      cd $f
      MURL=$(git config --get remote.origin.url)
      echo -en "\033[0;31m"
      echo "Git directory:"
      echo -en "\033[0m"
      echo -en "\033[0;32m"
      echo "$f"
      echo -en "\033[0m"
      echo -en "\033[0;36m"
      echo "$MURL"
      echo -en "\033[0m"
    fi
  cd ../
  done
}


git_dirs_st() {
  echo "$1"
  dir="$1"
  # No directory has been provided, use current
  if [ -z "$dir" ]; then
    dir="`pwd`"
    echo "no dir provided using pwd"j
  fi

  # Make sure directory ends with "/"
  if [[ $dir != */ ]]; then
    dir="$dir/*"
  else
    dir="$dir*"
  fi


  # Loop all sub-directories
  for f in $dir; do
  echo "looping in dirs"
  # Only interested in directories
    [ -d "${f}" ] || continue
  # Check if directory is a git repository
  if [ -d "$f/.git" ]; then
    mod=0
    cd $f

  # Check for modified files
    if [ $(git status | grep modified -c) -ne 0 ]; then
      mod=1
      MURL=$(git config --get remote.origin.url)
      echo -en "\033[0;31m"
      echo "Modified files: "
      echo -en "\033[0m"
      echo -en "\033[0;34m"
      echo "${f}"
      echo -en "\033[0m"
      echo -en "\033[0;36m"
      echo "$MURL"
      echo -en "\033[0m"
      echo
    fi

  # Check for untracked files
    if [ $(git status | grep Untracked -c) -ne 0 ]; then
      mod=1
      MURL=$(git config --get remote.origin.url)
      echo -en "\033[0;31m"
      echo "Untracked files: "
      echo -en "\033[0m"
      echo -en "\033[0;34m"
      echo "${f}"
      echo -en "\033[0m"
      echo -en "\033[0;36m"
      echo "$MURL"
      echo -en "\033[0m"
      echo
    fi
    cd ../
  fi
  done
}

# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

fcoc_preview() {
  local commit
  commit=$( glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" ) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fcs() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

alias muttgit='neomutt -F ~/.neomutt/muttrc-git'

