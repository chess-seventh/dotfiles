
alias xkcd_pass_gen='xkcdpass -n 5 -d '_!+!_' -C alternating'
alias backpwork='mount /mnt/usb_0/ && rsync -av --exlude .git* --progress $HOME/src /mnt/usb_0 && umount /mnt/usb_0/ '

flpass() {
        lpass show -c --password $(lpass ls  | fzf | awk '{print $(NF)}' | sed 's/\]//g')
}

# pass completion suggested by @d4ndo (#362)
_fzf_complete_pass() {
  _fzf_complete '+m' "$@" < <(
    pwdir=${PASSWORD_STORE_DIR-~/.password-store/}
    stringsize="${#pwdir}"
    find "$pwdir" -name "*.gpg" -print |
        cut -c "$((stringsize + 1))"-  |
        sed -e 's/\(.*\)\.gpg/\1/'
  )
}

[ -n "$BASH" ] && complete -F _fzf_complete_pass -o default -o bashdefault pass
