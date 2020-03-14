#! /bin/bash
# Merge of 
# https://github.com/b-ryan/powerline-shell/ and
# https://github.com/skeswa/prompt and
# https://gist.github.com/sminez/11fe5d763a9e9e63be5d836715c6425c
# Modified by phinasphreak
#
# Others icon "⚑","⇣", "⇡", "⬇", "⬆", "★", "●", "✖", "✚", "…", "", "✼", "✔", "✎"
#
# This value is used to hold the return value of the prompt sub-functions.
__prompt_retval=""

# Create some color constants to make the prompt a little more readable.
__prompt_color_prefix="\[\e["
__prompt_color_prefix_bold="\[\e[1m\]"
__prompt_color_prefix_no_bold="\[\e[0m\]"
__prompt_256_prefix="38;5;"
__prompt_color_suffix="m\]"
__prompt_no_color="\[\e[0m\]"

# Set the path color. Defaults to green. It can be overwritten by
# `PROMPT_PWD_COLOR`.
__prompt_pwd_color="${__prompt_color_prefix}${__prompt_256_prefix}33${__prompt_color_suffix}"
if ! [[ -z $PROMPT_PWD_COLOR ]]; then
  __prompt_pwd_color="${__prompt_color_prefix}${PROMPT_PWD_COLOR}${__prompt_color_suffix}"
fi

# Set the path color. Defaults to purple. It can be overwritten by
# `PROMPT_SEGMENT_JOBS_COLOR`.
__prompt_segment_jobs_color="${__prompt_color_prefix}${__prompt_256_prefix}202${__prompt_color_suffix}"
if ! [[ -z $PROMPT_SEGMENT_JOBS_COLOR ]]; then
  __prompt_segment_jobs="${__prompt_color_prefix}${PROMPT_SEGMENT_JOBS_COLOR}${__prompt_color_suffix}"
fi

# Set the git color. Defaults to purple. It can be overwritten by
# `PROMPT_GIT_COLOR`.
__prompt_git_color="${__prompt_color_prefix}${__prompt_256_prefix}105${__prompt_color_suffix}"
if ! [[ -z $PROMPT_GIT_COLOR ]]; then
  __prompt_git_color="${__prompt_color_prefix}${PROMPT_GIT_COLOR}${__prompt_color_suffix}"
fi

# Set the user-host color. Defaults to blue. It can be overwritten by
# `PROMPT_USERHOST_COLOR`.
if [ $UID -ne 0 ]; then
  # For simple user 
  __prompt_userhost_color="${__prompt_color_prefix}${__prompt_256_prefix}76${__prompt_color_suffix}"
  if ! [[ -z $PROMPT_USERHOST_COLOR ]]; then
    __prompt_userhost_color="${__prompt_color_prefix}${PROMPT_USERHOST_COLOR}${__prompt_color_suffix}"
  fi

else
  # Color the 'userhost' in RED for ROOT user.
  __prompt_userhost_color="${__prompt_color_prefix}${__prompt_256_prefix}160${__prompt_color_suffix}"
  if ! [[ -z $PROMPT_USERHOST_COLOR ]]; then
    __prompt_userhost_color="${__prompt_color_prefix}${PROMPT_USERHOST_COLOR}${__prompt_color_suffix}"
  fi
fi

# Set the error color. Defaults to red. It can be overwritten by
# `PROMPT_ERROR_COLOR`.
__prompt_error_color="${__prompt_color_prefix}${__prompt_256_prefix}204${__prompt_color_suffix}"
if ! [[ -z $PROMPT_ERROR_COLOR ]]; then
  __prompt_error_color="${__prompt_color_prefix}${PROMPT_ERROR_COLOR}${__prompt_color_suffix}"
fi

# Set the dollar color. Defaults to white. It can be overwritten by
# `PROMPT_DOLLAR_COLOR`.
__prompt_dollar_color="${__prompt_color_prefix}${__prompt_256_prefix}255${__prompt_color_suffix}"
if ! [[ -z $PROMPT_DOLLAR_COLOR ]]; then
  __prompt_dollar_color="${__prompt_color_prefix}${PROMPT_DOLLAR_COLOR}${__prompt_color_suffix}"
fi

# Gets the current working directory path, but shortens the directories in the
# middle of long paths to just their respective first letters.
function __prompt_get_short_pwd {
  # Break down the local variables.
  local dir=`dirs +0`
  local dir_parts=(${dir//// })
  local number_of_parts=${#dir_parts[@]}

  # If there are less than 6 path parts, then do no shortening.
  if [[ "$number_of_parts" -gt "5" ]]; then
    # Leave the last 2 part parts alone.
    local last_index="$(( $number_of_parts - 3 ))"
    local short_pwd=""

    # Check for a leading slash.
    if [[ "${dir:0:1}" == "/" ]]; then
      # If there is a leading slash, add one to `short_pwd`.
      short_pwd+='/'
    fi

    for i in "${!dir_parts[@]}"; do
      # Append a '/' before we do anything (provided this isn't the first part).
      if [[ "$i" -gt "0" ]]; then
        short_pwd+='/'
      fi

      # Don't shorten the first/last few arguments - leave them as-is.
      if [[ "$i" -lt "2" || "$i" -gt "$last_index" ]]; then
        short_pwd+="${dir_parts[i]}"
      else
        # This means that this path part is in the middle of the path. Our logic
        # dictates that we shorten parts in the middle like this.
        short_pwd+="${dir_parts[i]:0:1}"
      fi
    done

    # Return the resulting short pwd.
    __prompt_retval="$short_pwd"
  else
    # We didn't change anything, so return the original pwd.
    __prompt_retval="$dir"
  fi
}

# Returns the user@host. The host is overriden by `PROMPT_HOST_NAME`.
function __prompt_get_host() {
  # Check to see if we already have the host name cached.
  if [[ -z $PROMPT_HOST_NAME ]]; then
    # We do not have the friendly host name cached, so use use '\h'.
    __prompt_retval='\u@\h'
  else
    # We have the host name cached! Dope! Let's use it.
    __prompt_retval="\u@$PROMPT_HOST_NAME"
  fi
}

# Returns the git branch (if there is one), or returns empty.
function __prompt_get_git_stuff() {
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    
    # Added functionality for displaying file modification with git.
    local count_add=$(git status --short | wc -l)

    if [[ $count_add -eq 0 ]]; then
      count_add=""
    else
      count_add="…$count_add"
    fi
    
    # Return the resulting git branch/ref.
    __prompt_retval=":$branch$count_add"
  else
    # Return empty if there is no git stuff.
    __prompt_retval=''
  fi
}

# This function creates count for jobs running.
function __prompt_segment_jobs() {
  # Ancienne methode pour calculer les "jobs" en cours.
  #local jobsnum="$(jobs -p | wc -l)"

  # Compte le nombre de "jobs" avec un meilleur affichage pour le terminal
  # car il permet de choisir uniquement les process "Running" et "Stopped" 
  # et d'enlever les autres "Terminated" et "Done" qui ne sont pas important.
  local jobsnum=$(jobs -l | awk -F" " '{ print $3 }' | grep -E 'Running|Stopped' | wc -l)
    
  # Efface "jobsnum" si valeur egal a 0
  if [ $jobsnum -eq 0 ] ; then
      __prompt_retval=''
      return
  fi

  __prompt_retval=":$jobsnum"
}

# This function creates prompt.
function __prompt_command() {
  # Make the dollar red if the last command exited with error.
  local last_command_retval="$?"
  local dollar_color="$__prompt_dollar_color"
  if [ $last_command_retval -ne 0 ]; then
    dollar_color="$__prompt_error_color"
  fi

  # Calculate prompt parts.
  __prompt_get_short_pwd
  local short_pwd="${__prompt_pwd_color}${__prompt_retval}"

  __prompt_segment_jobs
  local jobsnum="${__prompt_segment_jobs_color}${__prompt_retval}"

  __prompt_get_host
  local host="${__prompt_userhost_color}${__prompt_retval}"

  __prompt_get_git_stuff
  local git_stuff="${__prompt_git_color}${__prompt_retval}"
  local dollar="${dollar_color}"'\$'

  # Set the PS1 to the new prompt. (func pwd not in bold)
  #PS1="${__prompt_color_prefix_bold}${host}${__prompt_no_color}${__prompt_color_prefix_no_bold}:${short_pwd}${git_stuff}${jobsnum}${__prompt_color_prefix_bold}${dollar}${__prompt_no_color} "

  # Set the PS1 to the new prompt ( with func pwd in bold) 
  PS1="${__prompt_color_prefix_bold}${host}${__prompt_no_color}${__prompt_color_prefix_no_bold}:${__prompt_color_prefix_bold}${short_pwd}${git_stuff}${__prompt_color_prefix_no_bold}${jobsnum}${__prompt_color_prefix_bold}${dollar}${__prompt_no_color} "
}

# Tell bash about the function above.
export PROMPT_COMMAND=__prompt_command
