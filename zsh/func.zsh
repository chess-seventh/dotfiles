buku_bookmark() {
        INCSRC=$1
        MURL=$2
        DESC=$3
        TIT=$4

        if [[ "$INCSRC" == "newsboat" ]]; then
                SRCTAG="newsboat"
        elif [[ "$INCSRC" == "qute" ]]; then
                SRCTAG="qutebrowser"
        else
                SRCTAG="general"
        fi


        if [[ "$MURL" = *"git"* ]]; then
                buku -a $MURL git "$SRCTAG" tocheck
        else
                buku -a $MURL "$SRCTAG" toread
        fi


        notify-send "Bookmarked in buku"

}

passwd_generator_random() {
        RANDOM_SEP=$(</dev/urandom tr -dc '!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' | head -c 5  ; echo)
        PW=$(xkcdpass -n 5 -d \""$RANDOM_SEP"\" -C alternating)
        echo $PW
}


get_vol() {
        MPD="$(mpc | grep volume)"
        if [ -z "$MPD" ]; then
                echo ""
        else
                PCNT="$(mpc | grep -o '([0-9]*%)')"
                PAUSED="$(mpc | grep -o '\[paused\]')"
                if [ -z "$PAUSED" ]; then
                        STATUS=""
                else
                        STATUS=""
                fi
        fi

        VOL=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "" } else { print $2 }}' | head -n 1)

        REPEAT=$(mpc | grep repeat | awk -F '   ' '{print $2}' | awk -F ': ' '{print $2}')

        if [ "$REPEAT" == "on" ]; then
                REP=""
        else
                REP=""
        fi

        RD="$(mpc | awk 'NR==3' | awk -F '   ' '{print $3}' | cut -c 10-11)"

        if [ "$RD" == "on" ]; then
                RAND=""
        else
                RAND=""
        fi

        if [ "$VOL" != "" ]; then
                VOL="$VOL"%
        fi

        echo   $STATUS  $REP $RAND  $VOL

        exit 0
}


isvpn() {
        # Script to detect if I am connected to a VPN or not

        PVPN=$(sudo protonvpn-cli --status | awk 'NR==2' | awk -F ': ' '{print $2}')
        HVPN=$(pgrep openvpn)

        if [ "$PVPN" == 'Running' ]; then
                SEC=""
        elif [ -n "$HVPN" ]; then
                SEC=""
        else
                SEC=""
        fi

        echo "$SEC"
}


print_khal_mail() {
        khal printics --format "
        +----------------+
        | Calendar Event |
        +----------------+
        Event........{repeat-symbol}{title}
        Location.....{location}
        Start........{start-date-long} {start-time-full}
        End..........{end-date-long} {end-time-full}
        Status.......{status}
        Description:
        {description}" ${1} | awk '{if (NR>2) print}'
}


music_toggle() {

        STATUS=$(mpc | awk 'NR==2' | awk -F ' ' '{print $1}' | sed 's/\[//g' | sed 's/]//g')

        if [[ $STATUS == 'playing' ]]; then
                mpc pause
                pactl set-sink-mute @DEFAULT_SINK@ toggle
        elif [[ $STATUS == 'paused' ]]; then
                mpc play
                pactl set-sink-mute @DEFAULT_SINK@ toggle
                pactl set-sink-volume @DEFAULT_SINK@ 45%
        fi

}

alias sourcezsh='source ~/.zshrc'

