
alias swork='sh $HOME/.screenlayout/work.sh'
alias wcon='sudo netctl stop-all && sudo netctl start wlp3s0-Bestmile'

alias kaws3='kubectl config use-context arn:aws:eks:eu-west-1:119119624364:cluster/aws3-prod'
alias kaws4='kubectl config use-context aws4.bestmile.io'
alias kstag='kubectl config use-context sandbox.bestmile.com'
alias kdev='kubectl config use-context dev.bestmile.io'
alias kgcep='kubectl config use-context gke_bm-eng_europe-west1-b_partners'
alias kgced='kubectl config use-context gke_bm-eng_europe-west1-b_developers'
alias kaz1='kubectl config use-context aks1-dev-admin'
alias kaz2='kubectl config use-context prod-admin'

#alias bastion_aws_dev='ssh -i $HOME/.ssh/bm-aws ec2-user@172.14.101.219'

alias ssh_aws_bastion='ssh -i $HOME/.ssh/bm-aws ec2-user@52.17.83.189'
alias ssh_mgmt='ssh -i ~/.ssh/bm-aws ec2-user@52.51.170.13'


alias ssh_aws_nixops_deploy='ssh -i $HOME/.ssh//bm/bm-aws root@172.16.18.87'
alias ssh_elk_aws_dev='ssh -i $HOME/.ssh/bm/bm-aws ubuntu@172.16.13.169'
alias ssh_elk_aws_prod='ssh -i $HOME/.ssh/bm/bm-aws ubuntu@172.16.13.109'
alias ssh_elk_aws_old='ssh -i $HOME/.ssh/bm/bm-aws ubuntu@172.16.12.216'
alias ssh_elk_gce_partners'ssh -i $HOME/bm/.ssh/gce-elk-partners/id_rsa docker-user@10.34.253.2'

alias ssh_aws2gce='ssh -i $HOME/.ssh/bm/bm-aws admin@172.16.0.55'

alias ssh_qa_dashboard='ssh -i ~/.ssh/bm/qa-dashboard/id_rsa ubuntu@172.16.21.151'
#
#alias monitoring='ssh -i $HOME/.ssh/bm-aws ubuntu@172.16.18.210'

alias kwn='watch -n 1 -d kubectl get nodes'
alias kdesc='kubectl describe'
alias klpod='kubectl logs -f'
alias kgp='kubectl get pods'
alias kgn='kubectl get nodes'
alias kg='kubectl get'

alias chamber='aws-vault exec chamber -- chamber'

alias bm-mail='cd ~/attachments-work/ ; neomutt -F ~/.mutt-bestmile/muttrc'
alias weeslack='weechat -d ~/.weeslack'

kb_nodes_ip_ssh() {
        for node in $(kb get nodes -o wide -o json | jq '.items[].status.addresses[0].address' | sed 's/"//g') ; do echo "ssh -i ~/.ssh/bm-aws ec2-user@$node" ; done
}

kblf () {
        kubectl logs -n $1 -f
}

kbdp () {
        kubectl describe -n $1 pod
}

zoomy () {
        if [[ $1 = *http*  ]]; then
                echo "opening WITH http"
                xdg-open "$1" 1>& /dev/null & disown ;
        else
                echo "opening WITHOUT http"
                xdg-open "zoommtg://zoom.us/join?action=join&confno=$1" 1>& /dev/null & disown
        fi
}

kzoom () {
        set -e
        kill -9 $(pidof zoom)
}

fwmail() {
        notmuch search --format=json --output=summary tag:unread and tag:work  | jq -c '.[] |  [ .date_relative,  .subject, [ .authors ]  ] '  | sed 's/,/ | /g' | sed 's/"//g' | cut -c2- | rev | cut -c2- | rev | awk -F ',' '{ print }' | fzf --color=dark --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
}

export_aws() {
  export AWS_ACCESS_KEY_ID=$(pass work/bestmile/aws-access-key-id)
  export AWS_SECRET_ACCESS_KEY=$(pass work/bestmile/aws-secret-access-key)
}


sshec2() {
  ssh -i ~/.ssh/bm-aws ec2-user@$1
}

