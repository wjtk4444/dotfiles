# load keyword completion lists
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

################################################################################

# PS for root and normal users
if [[ ${EUID} != 0 ]] ; then # any user
    #                R   G   B
    PS1='\[\033[38;2;000;255;255m\]\u@\h [\W] $ \[\033[00m\]'
    PS2='\[\033[38;2;000;255;255m\]> \[\033[00m\]'
    PS3='\[\033[38;2;000;255;255m\]\#? \[\033[00m\]'
    PS4='\[\033[38;2;000;255;255m\][${LINENO}]+ \[\033[00m\]'
else # root
    PS1='\[\033[38;2;255;000;000m\]\u@\h [\W] $ \[\033[00m\]'
    PS2='\[\033[38;2;255;000;000m\]> \[\033[00m\]'
    PS3='\[\033[38;2;255;000;000m\]\#? \[\033[00m\]'
    PS4='\[\033[38;2;255;000;000m\][${LINENO}]+ \[\033[00m\]'
fi

# enable colors for commands
alias ls='ls --color --human-readable --group-directories-first'
alias ip='ip --color'
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'
alias diff='diff --color=always'
alias less='less --raw-control-chars'
man() {
    env \
        LESS_TERMCAP_mb=$(printf '\e[1;31m') \
        LESS_TERMCAP_md=$(printf '\e[1;31m') \
        LESS_TERMCAP_me=$(printf '\e[0m') \
        LESS_TERMCAP_se=$(printf '\e[0m') \
        LESS_TERMCAP_so=$(printf '\e[1;44;33m') \
        LESS_TERMCAP_ue=$(printf '\e[0m') \
        LESS_TERMCAP_us=$(printf '\e[1;32m') \
        man "$@"
}

################################################################################

# update system w/ git packages, prompt to remove orphans (if any) and purge package cache (keep installed and previous)
alias update='yay -Syu --devel; yay -Rs $(yay -Qqtd); paccache -rk 2 && paccache -ruk 0 && yes | yay -Sc'

# mini system monitor
alias sysmon="watch -t '(echo -e \"\n\nCPU:\"; sensors | grep -o \"SYSTIN.*C  \|CPUTIN.*C  \|AUXTIN0.*C  \|AUXTIN2 .*C  \" | sed \"s/   / /g\"; echo -e \"\nGPU:\"; sensors | tail -n12 | grep -o \".*°C  \|.* W  \") | sed \"s/^/\t/g\"'"

################################################################################

alias q='exit'

# preserve enviroment variables
alias sudo='sudo -E '
alias su='su -m '

# confirm before overwrite/delete
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# human-readable sizes
alias ls='ls -h'
alias df='df -h'
alias du='du -h'
alias free='free -m'

# no error for existing directories, create parents if needed
alias mkdir='mkdir -p'

# hide xorg startup messages
alias startx='startx &> /dev/null'

# make zathura pdf always fork to background
alias zathura='zathura --fork'

# download from mega
alias mega='megatools dl'

# xev without the clutter
alias xevi='xev | awk -F"[ )]+" '\''/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'\'

# mpv in terminal
alias termpv='mpv --vo=tct --vo-tct-256 --really-quiet'

# make smloadr script take priority over the program
alias smloadr='~/.scripts/smloadr'

# neofetch with custom picture
alias neofetch='neofetch --w3m ~/Pictures/neofetch/aqua.png --size 36% --yoffset 10'

# base 64 decoder
function dbase64() { echo "$1" | base64 -d; echo; }
