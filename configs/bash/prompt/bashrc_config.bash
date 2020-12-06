#!/bin/bash

################################################
### Configuration powerline.bash/prompt.bash ###
################################################


if [[ $UID -eq 1000 ]]; then
    # UID=1000 --> USER
    DIRECTORY="/home/$USER"
else
    # UID=0 --> ROOT
    DIRECTORY="/home/pspk"
fi


# change the prompt if powerline fonts is supported or not
if [[ $TERM == "xterm-256color" ]]; then
   # Use powerline.bash for shell
   if [ -f ${DIRECTORY}/.config/prompt/powerline.bash ]; then
       # Copier et adapter ceci dans votre .bashrc
       source ${DIRECTORY}/.config/prompt/powerline.bash
       PROMPT_COMMAND='__update_ps1 $?'
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
