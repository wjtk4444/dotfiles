# set locale
export LANG=en_US.UTF-8
export LC_COLLATE=C
export LC_MEASUREMENT=C
export LC_MONETARY=C
export LC_NUMERIC=C
export LC_TIME=C

# add scripts to path
export PATH="$PATH:$HOME/.scripts"

# default appllications
export EDITOR='vim'
export TERMINAL='konsole'
export BROWSER='firefox'

# firefox KDE filepicker
export GTK_USE_PORTAL=1

# firefox web renderer
export MOZ_ACCELERATED=1
export MOZ_WEBRENDER=1

# cleanup
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE='-'
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
