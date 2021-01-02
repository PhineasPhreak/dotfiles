#!/bin/bash


################################################
### Configuration powerline.bash/prompt.bash ###
################################################
#
# If the variable environment is 'xterm-256color' and you still want the 'prompt.bash'
# you can choose with this variable between "prompt.bash" and "powerline.bash".
#
# To make simple choose between "prompt.bash" or "powerline.bash".
PWL_PRT="powerline.bash"
DIRECTORY=""

if [[ $UID -eq 1000 ]]; then
    # UID=1000 --> USER
    DIRECTORY="/home/$USER"
else
    # UID=0 --> ROOT
    # Enter user name manually
    DIRECTORY="/home/pspk"
fi


# change the prompt if powerline fonts is supported or not
if [[ $TERM == "xterm-256color" || $TERM == "screen-256color" ]]; then
    if [[ $PWL_PRT == "powerline.bash" ]]; then
        # You choose "powerline.bash"
        # Use powerline.bash for shell
        if [ -f ${DIRECTORY}/.config/prompt/powerline.bash ]; then
            # Copier et adapter ceci dans votre .bashrc
            source ${DIRECTORY}/.config/prompt/powerline.bash
            PROMPT_COMMAND='__update_ps1 $?'
        fi
    fi

    if [[ $PWL_PRT == "prompt.bash" ]]; then
        # You choose "prompt.bash"
        # Use skeswa/prompt
        if [ -f ${DIRECTORY}/.config/prompt/prompt.bash ]; then
            source ${DIRECTORY}/.config/prompt/prompt.bash
        fi
    fi
fi

# for terminal in vscode
if [[ $TERM_PROGRAM == "vscode" ]]; then
    # Use skeswa/prompt
    if [ -f ${DIRECTORY}/.config/prompt/prompt.bash ]; then
        source ${DIRECTORY}/.config/prompt/prompt.bash
    fi
fi

# for terminal in Pycharm (JetBrains)
if [[ $TERMINAL_EMULATOR == "JetBrains-JediTerm" ]]; then
    # Use skeswa/prompt
    if [ -f ${DIRECTORY}/.config/prompt/prompt.bash ]; then
        source ${DIRECTORY}/.config/prompt/prompt.bash
    fi
fi

# when you use tty's session (with CTRL + F1-F6 to access the terminal that you want)
if [[ $TERM == "linux" ]]; then
    # Use skeswa/prompt
    if [ -f ${DIRECTORY}/.config/prompt/prompt.bash ]; then
        source ${DIRECTORY}/.config/prompt/prompt.bash
    fi
fi
