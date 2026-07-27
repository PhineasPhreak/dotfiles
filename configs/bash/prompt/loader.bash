#!/bin/bash
#
# Shell Prompt Configuration
# Selects between 'powerline.bash' and 'prompt.bash' based on environment and user choice.
#

# Configuration: Set to "powerline.bash" or "prompt.bash"
# If export not declared in .bashrc file "powerline.bash" is default
PWL_PRT="${PWL_PRT:-powerline.bash}"

# Determine the home directory of the current user safely
# Using 'eval echo ~$USER' handles edge cases better than manual path construction
CURRENT_USER="${USER:-$(whoami)}"
HOME_DIR=$(eval echo ~"$CURRENT_USER")
CONFIG_DIR="${HOME_DIR}/.config/prompt"

# Define the prompt file to load based on user choice
if [[ "$PWL_PRT" == "powerline.bash" ]]; then
    PROMPT_SCRIPT="${CONFIG_DIR}/powerline.bash"
else
    PROMPT_SCRIPT="${CONFIG_DIR}/prompt.bash"
fi

# Check if the prompt script exists
if [[ ! -f "$PROMPT_SCRIPT" ]]; then
    # Optional: Uncomment the line below to warn if the file is missing
    # echo "Warning: Prompt script not found at $PROMPT_SCRIPT" >&2
    return 0 2>/dev/null || exit 0
fi

# Determine if we should load the prompt based on the terminal type
# Supports: xterm, screen, emacs (dumb), vscode, jetbrains, and linux (tty)
LOAD_PROMPT=false

case "$TERM" in
    xterm-256color|screen-256color)
        LOAD_PROMPT=true
        ;;

    linux|dumb|eterm-color)
        # Forcing using "prompt.bash"
        PROMPT_SCRIPT="${CONFIG_DIR}/prompt.bash"
        source "$PROMPT_SCRIPT"
        ;;

    *)
        # No custom prompt, default from .bashrc file
        LOAD_PROMPT=false
        ;;
esac

# Check for specific terminal emulators (VSCode, JetBrains)
if [[ "$TERM_PROGRAM" == "vscode" ]] || [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]]; then
    LOAD_PROMPT=true
fi

# Source the script if conditions are met
if [[ "$LOAD_PROMPT" == true ]]; then
    source "$PROMPT_SCRIPT"

    # If using powerline.bash, it often sets a PROMPT_COMMAND
    if [[ "$PWL_PRT" == "powerline.bash" ]]; then
        # Ensure the function exists before assigning PROMPT_COMMAND to avoid errors
        if declare -f __update_ps1 > /dev/null 2>&1; then
            PROMPT_COMMAND='__update_ps1 $?'
        fi
    fi
fi
