#!/bin/bash
#
# Merge of 
# https://github.com/b-ryan/powerline-shell/ and
# https://github.com/skeswa/prompt
# Modified by phinasphreak
#
# Others icon "⚑", "⬇", "⬆", "★", "●", "✖", "✚", "…", "", "✼", "✔", "✎"
#
# Configuration:
# all option are: hostname diskp disku diska pwd venv git status jobs
#
POWERLINE_SEGMENTS="hostname pwd venv git status jobs"
# POWERLINE_STYLE="default" or your
POWERLINE_SEP=''
POWERLINE_THINSEP=''
#
# These variables can be set per shell, without export.

__default_sep=''
__default_thinsep=''

if [ -f /.dockerenv ] ; then
    container=docker
fi

# This value is used to hold the return value of the prompt sub-functions. This
# hack avoid calling functions un subprocess to get ret from stdout.
__powerline_retval=""

__powerline_split() {
    local sep="$1"
    local str="$2"
    local OIFS="${IFS}"
    IFS="$sep"
    __powerline_retval=(${str})
    IFS="${OIFS}"
}

# Gets the current working directory path, but shortens the directories in the
# middle of long paths to just their respective first letters.
function __powerline_shorten_dir {
    # Break down the local variables.
    local short_pwd
    local dir="$1"

    __powerline_split / "${dir##/}"
    dir_parts=("${__powerline_retval[@]}")
    local number_of_parts=${#dir_parts[@]}

    # If there are less than 6 path parts, then do no shortening.
    if [[ "$number_of_parts" -lt "5" ]]; then
        __powerline_retval="${dir}"
        return
    fi
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
    __powerline_retval="$short_pwd"
}

# Parses git status --porcelain=v2 output in an array
function __powerline_parse_git_status_v2() {
    local status="$1"
    # branch infos as returned by status : sha, name, upstream, ahead/behind
    local branch_infos=()
    local sha
    local dirty=
    local ab
    local detached=

    while read line ; do
        # If line starts with '# ', it's branch info
        if [ -z "${line### branch.*}" ] ; then
            branch_infos+=("${line#\# branch.* }")
        else
            # Else, it's a changes. The worktree is dirty
            dirty=1
            break
        fi
    done <<< "${status}"

    # Try to provide a meaningful info if we are not on a branch.
    if [ "${branch_infos[1]}" == "(detached)" ] ; then
        detached=1
        if desc="$(git describe --tags --abbrev=7 2>/dev/null)" ; then
            branch="${desc}"
        else
            # Au pire des cas, utiliser la SHA du commit courant.
            branch="${branch_infos[0]:0:7}"
        fi
    else
        branch=" ${branch_infos[1]}"
    fi

    ab="${branch_infos[3]-}"
    __powerline_retval=("${branch}" "${dirty}" "${ab}" "${detached}")
}

# Analyser la sortie v1 de git status --porcelain
function __powerline_parse_git_status_v1() {
    local status="$1"

    local branch
    local detached=
    local dirty=

    __powerline_split $'\n' "$status"
    local lines=("${__powerline_retval[@]}")

    for line in "${lines[@]}" ; do
        if [ "${line}" = "## HEAD (no branch)" ] ; then
            detached=1
            if desc="$(git describe --tags --abbrev=7 2>/dev/null)" ; then
                branch="${desc}"
            else
                # Au pire des cas, utiliser la SHA du commit courant.
                branch="$(git rev-parse --short HEAD)"
            fi
        elif [ -z "${line####*}" ] ; then
            __powerline_split '...' "${line#### }"
            branch=" ${__powerline_retval[0]}"
        else
            # Les autres lignes sont des lignes de modification.
            dirty=1
            break
        fi
    done

    # On bidonne l'état de synchronisation, faut d'information dans git status.
    local ab="+0 -0"

    __powerline_retval=("${branch}" "${dirty}" "${ab}" "${detached}")
}

# Sélectionner le format de git status à analyser
__powerline_git_version="$(git --version 2>/dev/null)"
__powerline_git_version="${__powerline_git_version#git version }"

# la V2 affiche en une commande l'état de synchronisation.
if printf "2.11.0\n%s" "${__powerline_git_version}" | sort --version-sort --check=quiet ; then
    __powerline_git_cmd=(git status --branch --porcelain=v2)
    __powerline_git_parser=__powerline_parse_git_status_v2
else
    __powerline_git_cmd=(git status --branch --porcelain)
    __powerline_git_parser=__powerline_parse_git_status_v1
fi


__powerline_get_foreground() {
    local R=$1
    local G=$2
    local B=$3

    # Les terminaux 256 couleurs ont 6 niveaux pour chaque composant. Les
    # valeurs réelles associées aux indices entre 0 et 5 sont les suivantes.
    local values=(0 95 135 175 215 255)
    # Indice de luminosité entre 0 et 9 calculé à partir des composants RGB.
    local luminance
    # On associe une couleur de texte pour chaque niveau de luminosité entre 0
    # et 9. Du gris clair au gris foncé en passant par blanc et noir.
    local foregrounds=(252 253 253 255 255 16 16 235 234 234)

    # cf. https://fr.wikipedia.org/wiki/SRGB#Caract%C3%A9ristiques_principales
    luminance=$(((${values[${R}]} * 2126 + ${values[${G}]} * 7152 + ${values[${B}]} * 722) / 280000))

    # Tronquer la partie décimale et assurer le 0 initial.
    LC_ALL=C printf -v luminance "%.0f" $luminance

    # Récupérer la couleur de texte selon la luminosité
    __powerline_retval=${foregrounds[$luminance]}

    # Afficher le résultat pour test visuel.
    if [ -n "${DEBUG-}" ] ; then
        fg=${__powerline_retval}
        bg=$((16 + 36 * R + 6 * G + B))
        fgbg="$fg/$bg"
        text="${LOGNAME}@${HOSTNAME}"
        printf "\e[38;5;${fg};48;5;${bg}m $text \e[0m RGB=%s L=%d %7s" "${RGB}" $luminance $fgbg
    fi
}

# Un segment est une fonction bash préfixé par `__powerline_segment_`. Le retour
# est un table contenant des chaînes au format :
# `<t|p>:<bg_color>:<fg_color>:<text>`. Chaque chaîne correspond à un segment.

__powerline_segment_hostname() {
    local bg
    local rgb
    local fg
    local text
    local hash
    local bold_hostname

    if [ -z "${HOSTNAME-}" -a -f /etc/hostname ] ; then
        read HOSTNAME < /etc/hostname
    fi
    USER="${USER-${USERNAME-${LOGNAME-}}}"
    # N'appeler whoami qui si besoin
    if [ -z "${USER}" ] ; then
        USER=$(whoami)
    fi

    # Affiche hostname en gras avec valeur egale a (";1") 
    # Affiche hostname normalement avec ("")
    bold_hostname=";1"

    # Valeur hostname par defaut 
    text="${USER}@${HOSTNAME-*unknown*}"
    
    # Affiche seulement le nom d'utilisateur dans le prompt
    #text="${USER}"

    # Calculer la couleur à partir du texte à afficher.
    # Par defaut
    #hash=$(sum <<< "${text}")
    #bg=$((1${hash// /} % 215))
    #rgb=($((bg / 36)) $(((bg % 36) / 6)) $((bg % 6)))
    #bg=$((16+bg))

    hash=$(sum <<< "${text}")
    bg=$((1${hash// /} % 1))
    rgb=($((bg / 36)) $(((bg % 36) / 6)) $((bg % 6)))

    # Change la couleur du background suivant l'utilisateur "green" pour USER et "red" pour ROOT
    # "$UID = 0" egal ROOT
    # "$UID = 1000" egal USER
    if [ "$UID" = "0" ] ; then
        # ROOT couleur RED
        bg=$((124+bg))
    else
        # USER couleur GREEN
        bg=$((35+bg))
    fi

    # Assurer la lisibilité en déterminant la couleur du texte en fonction de la
    # clareté du fond.
    __powerline_get_foreground "${rgb[@]}"
    fg=${__powerline_retval}

    __powerline_retval=("p:48;5;${bg}:38;5;${fg}${bold_hostname}:${text}")
}

__powerline_segment_pwd() {
    local colors
    local next_sep
    local short_pwd

    __powerline_shorten_dir "$(dirs +0)"
    local short_pwd="${__powerline_retval}"

    if [ "$short_pwd" = "/" ] ; then
        __powerline_split "" "${short_pwd}"
        local parts=("${__powerline_retval[@]}")

    else
    __powerline_split / "${short_pwd}"
    local parts=("${__powerline_retval[@]}")
    fi

    __powerline_retval=()
    local sep=p
    for part in "${parts[@]}" ; do
        if [ "${part}" = '~' -o "${part}" = "" ] ; then
            colors="48;5;31:38;5;15"
            next_sep=p

        # Couleur pour le dossier racine "/"
        elif [ "${part}" = '/' -o "${part}" = "" ]; then
            # Couleur grise par defaut
            colors="48;5;237:38;5;250"

            # Couleur rouge
            #colors="48;5;88:38;5;15"
            next_sep=p

        else
            colors="48;5;237:38;5;250"
            # Les segments suivants auront un séparateur léger
            next_sep=t
        fi

        __powerline_retval+=("${sep}:${colors}:${part}")
        sep=${next_sep}
    done
}

__powerline_segment_venv() {
    if [ -z "${VIRTUAL_ENV-}" ] ; then
        __powerline_retval=()
        return
    fi

    __powerline_retval=("p:48;5;35:38;5;0:${VIRTUAL_ENV##*/}")
}

__powerline_segment_status() {
    local ec=$1

    if [ $ec -eq 0 ] ; then
        __powerline_retval=()
        return
    fi

    # Mettre en gras avec ;1
    __powerline_retval=("p:48;5;1:38;5;234;1:✘ $ec")
}

__powerline_segment_jobs() {
    local bg
    local fg
    local bold
    # Ancienne methode pour calculer les "jobs" en cours.
    #local jobsnum="$(jobs -p | wc -l)"

    # Compte le nombre de "jobs" avec un meilleur affichage pour le terminal
    # car il permet de choisir uniquement les process "Running" et "Stopped" 
    # et d'enlever les autres "Terminated" et "Done" qui ne sont pas important.
    local jobsnum=$(jobs -l | awk -F" " '{ print $3 }' | grep -E 'Running|Stopped' | wc -l)

    fg=234
    # Si command lancer en background depuis le terminal superieur a 5
    # alors la couleur change et le chiffre se met en gras
    if [ $jobsnum -le 5 ] ; then
        bg=172
        bold=16
    else
        bg=202
        bold=1
    fi
    
    # Efface "jobsnum" si valeur egal a 0
    if [ $jobsnum -eq 0 ] ; then
        __powerline_retval=()
        return
    fi

    __powerline_retval=("p:48;5;${bg}:38;5;${fg};${bold}:… $jobsnum")
}

__powerline_segment_diskp() {
    local bg
    local fg
    local bold

    local usepc=$(df -Th $HOME | awk '/[0-9]%/{print $(NF-1)}')
    local usepc_int=${usepc::-1}

    fg=234
    # Affiche le pourcentage du disque utiliser
    # alors la couleur change et le chiffre se met en gras
    if [ $usepc_int -le 25 ] ; then
        bg=28
        bold=16

    elif [ $usepc_int -le 50 ] ; then
        bg=172
        bold=16

    elif [ $usepc_int -ge 50 ] ; then
        bg=202
        bold=16
        if [ $usepc_int -ge 75 ] ; then
            bg=196
            bold=16
        fi

    else
        bg=16
        bold=1
    fi

    # Efface "usepc" si valeur egal a 0
    if [ $usepc_int -eq 0 ] ; then
        __powerline_retval=()
        return
    fi

    __powerline_retval=("p:48;5;${bg}:38;5;${fg};${bold}:$usepc")

}

__powerline_segment_disku() {
    # Affiche la taille utiliser sur le disque
    local bg
    local fg
    local bold
    local used=$(df -Th $HOME | awk '/[0-9]%/{print $(NF-3)}')
    # local used_int=${used::-1}

    fg=234
    bg=25
    bold=16

    __powerline_retval=("p:48;5;${bg}:38;5;${fg};${bold}:$used")
}

__powerline_segment_diska() {
    # Affiche la taille disponible sur la disque
    local bg
    local fg
    local bold
    local avail=$(df -Th $HOME | awk '/[0-9]%/{print $(NF-2)}')
    # local avail_int=${avail::-1}

    fg=234
    bg=30
    bold=16

    __powerline_retval=("p:48;5;${bg}:38;5;${fg};${bold}:$avail")
}

__powerline_segment_git() {
    local branch
    local branch_colors
    local ab
    local ab_segment=''
    local detached
    local change_branch
    
    #local count_commits=$(git shortlog -s | grep -i "$(git config --global -l | grep -i "name" | gawk -F"=" '{ print $2 }')" | gawk -F" " '{ print $1 }')

    if ! status="$(LC_ALL=C.UTF-8 ${__powerline_git_cmd[@]} 2>/dev/null)" ; then
        __powerline_retval=()
        return
    fi
    $__powerline_git_parser "${status}"
    branch="${__powerline_retval[0]}"
    ab="${__powerline_retval[2]}"
    detached="${__powerline_retval[3]}"

    # Colorer la branche selon l'existance de modifications.
    if [ -n "${__powerline_retval[1]}" ] ; then
        local count_add=$(git status --short | wc -l)
        branch_colors="48;5;161:38;5;15"
        change_branch=1
    else
        branch_colors="48;5;148:38;5;0"
        change_branch=0
    fi

    if [ $change_branch -eq 1 ] ; then
        __powerline_retval=("p:${branch_colors}:${detached:+⚓ }${branch} … ${count_add}")
    else
        __powerline_retval=("p:${branch_colors}:${detached:+⚓ }${branch}")
    fi

    # Segments de modification de la branch par defaut
    #__powerline_retval=("p:${branch_colors}:${detached:+⚓ }${branch}")

    # Compute ahead/behind segment
    if [ -n "${ab##+0*}" ] ; then
        # No +0, the local branch is ahead upstream.
        local count_commits=$(git rev-list origin..HEAD | wc -l)
        ab_segment="↑ … $count_commits"
    fi
    if [ -n "${ab##+* -0}" ] ; then
        # No -0, the local branch is behind upstream.
        ab_segment+="↓"
    fi
    if [ -n "${ab_segment}" ] ; then
        # Juste pour tester la colorisation du nombre de commit 
        #count_commits=$(($count_commits + 41))

        if [ $count_commits -eq 1 ] ; then
            # Couleur = Blanc
            __powerline_retval+=("p:48;5;240:38;5;250:${ab_segment}")

        elif [ $count_commits -le 3 ] ; then
            # Couleur = Vert
            __powerline_retval+=("p:48;5;240:38;5;70:${ab_segment}")

        elif [ $count_commits -le 5 ] ; then
            # Couleur = Jaune
            __powerline_retval+=("p:48;5;240:38;5;172:${ab_segment}")

        elif [ $count_commits -le 10 ]; then
            # Couleur = Orange
            __powerline_retval+=("p:48;5;240:38;5;202:${ab_segment}")

        elif [ $count_commits -le 20 ]; then
            # Couleur = Rouge
            __powerline_retval+=("p:48;5;240:38;5;88:${ab_segment}")

        elif [ $count_commits -ge 21 ]; then
            # Couleur = Noir et en gras
            __powerline_retval+=("p:48;5;240:38;5;16;1:${ab_segment}")

        else
            __powerline_retval+=("p:48;5;240:38;5;250:${ab_segment}")
        fi

        # Par defaut sans coloration du nombres de commit
        #__powerline_retval+=("p:48;5;240:38;5;250:${ab_segment}")
    fi
}


# A render function is a bash function starting with `__powerline_render_`. It puts
# a PS1 string in `__powerline_retval`.

__powerline_render_default() {
    local bg=''
    local fg
    local ps=''
    local segment
    local text
    local separator

    for segment in "${__powerline_segments[@]}" ; do
        __powerline_split ':' "${segment}"
        local infos=("${__powerline_retval[@]}")

        local old_bg=${bg-}
        # Recoller les entrées 2 et suivantes avec :
        printf -v text ":%s" "${infos[@]:3}"
        text=${text:1}
        # Nettoyer le \n ajouté par <<<
        text="${text##[[:space:]]}"
        text="${text%%[[:space:]]}"
        # Sauter les segments vides
        if [ -z "${text}" ] ; then
            continue
        fi

        # D'abord, afficher le chevron avec la transition de fond.
        bg=${infos[1]%%:}
        fg=${infos[2]%%:}
        if [ -n "${old_bg}" ] ; then
            if [ "${infos[0]}" = "t" ] ; then
                # Séparateur léger, même couleurs que le texte
                separator=${POWERLINE_THINSEP-$__default_thinsep}
                colors="${fg};${bg}"
            else
                separator=${POWERLINE_SEP-$__default_sep}
                colors="${old_bg/48;/38;};${bg}"
            fi
            ps+="\[\e[${colors}m\]${separator}"
        fi
        # Ensuite, afficher le segment, coloré
        ps+="\[\e[${bg}m\e[${fg}m\] ${text} "
    done

    # Afficher le dernier chevron, transition du fond vers rien.
    old_bg=${bg-}
    bg='49'
    if [ -n "${old_bg}" ] ; then
        ps+="\[\e[${old_bg/48;/38;}m\e[${bg}m\]${POWERLINE_SEP-${__default_sep}}"
    fi

    # Retourner l'invite de commande
    __powerline_retval="${ps}"
}


# Show dollar line.
__powerline_dollar() {
    local fg
    local last_exit_code=$1
    # Déterminer la couleur du dollar
    if [ $last_exit_code -gt 0 ] ; then
        fg=${ERROR_FG-"1;38;5;161"}
    else
        fg=0
    fi
    # Afficher le dollar sur une nouvelle ligne, pas en mode powerline
    __powerline_retval="\[\e[${fg}m\]\\\$\[\e[0m\] "
}

__update_ps1() {
    local last_exit_code=${1-$?}
    local __powerline_segments=()

    # Détecter si on est connecté sur une autre machine ou un autre utilisateur.
    local other=${SSH_CLIENT-${SUDO_USER-${container-}}}
    local segments=${POWERLINE_SEGMENTS-${other:+hostname} pwd venv git status jobs diskp disku diska}
    local segment
    for segment in ${segments} ; do
        __powerline_segment_${segment} $last_exit_code
        __powerline_segments+=("${__powerline_retval[@]}")
    done

    local __ps1=""
    __powerline_render_${POWERLINE_STYLE-default}
    __ps1+="${__powerline_retval}"
    __powerline_dollar $last_exit_code

    # Pour retirer le retour chariot supprimmer "\n" de la ligne suivant
    __ps1+=" ${__powerline_retval}"
    PS1="${__ps1}"
}

if [ -z "${PROMPT_COMMAND-}" ] ; then
    PROMPT_COMMAND='__update_ps1 $?'
fi
