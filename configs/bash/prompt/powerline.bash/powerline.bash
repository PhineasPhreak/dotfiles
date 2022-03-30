#!/bin/bash
# cf. https://gitlab.com/bersace/powerline.bash
# cf. Dernier commit depuis ma modification : 
# 29 Mar, 2022 "doc: Capture d'écran automatique" 2c272ac9ebf16b9fd80de162b9535dcb947d3af2
#
# Cette variable globale permet de retourner une valeurs à du code appelant
# sans passer par un sous-shell. Cela optimise énormément les performances.
# Cette valeur doit toujours être un tableau, contenant une seule valeur si la
# fonction retourne un scalaire.
#
# Merge of 
# https://gitlab.com/bersace/powerline.bash
# https://github.com/b-ryan/powerline-shell/
# https://github.com/skeswa/prompt
# https://gist.github.com/sminez/11fe5d763a9e9e63be5d836715c6425c
# Modified by phinasphreak
#
# Others icon "⚑","⇣", "⇡", "⬇", "⬆", "★", "●", "✖", "✚", "…", "", "✼", "✔", "✎", "⚙"
__powerline_retval=()

declare -A __powerline_colors
declare -A __powerline_context


# Point d'entrée pour exécution dans PROMPT_COMMAND.
__update_ps1() {
	local last_exit_code=${1-$?}
	local segments=()
	local segname

	__powerline_git_status=()
	for segname in ${POWERLINE_SEGMENTS-hostname pwd status} ; do
		"__powerline_segment_${segname}" "$last_exit_code"
		if [ "${POWERLINE_DIRECTION}" = "ltr" ] ; then
			segments+=("${__powerline_retval[@]}")
		else
			segments=("${__powerline_retval[@]}" "${segments[@]}")
		fi
	done

	local __ps1=""
	# Changer le titre de la fenêtre ou de l'onglet, par ex. POWERLINE_WINDOW_TITLE="\h"
	if [ -v POWERLINE_WINDOW_TITLE ] ; then
		__ps1+="\\[\\e]0;${POWERLINE_WINDOW_TITLE}\\a\\]"
	fi

	"__powerline_render_${POWERLINE_STYLE-default}" "${segments[@]}"

	# Affichage par défaut sur 2 lignes, 1 ligne si option
	__ps1+="${__powerline_retval[0]}\\[\\e[0m\\]"
	if [ "${POWERLINE_ONELINE-}" = true ] && [ "${POWERLINE_DIRECTION-}" != "rtl" ] ; then
		__ps1+=" "
	else
		# Prompt with linebreak
		#__ps1+="\\n"

		# Prompt without linebreak
		__ps1+=""

		__powerline_dollar "$last_exit_code"
		__ps1+="${__powerline_retval[0]}"
	fi

	PS1="${__ps1}"
}


#       I N I T I A L I S A T I O N


__powerline_init() {
	__powerline_colors=()
	__powerline_context=()

	: "${POWERLINE_DIRECTION:=ltr}"
	if [ "${POWERLINE_DIRECTION}" = "rtl" ] ; then
		: "${POWERLINE_STYLE:=align_right}"
	else
		: "${POWERLINE_STYLE:=default}"
	fi

	__powerline_autoicons
	__powerline_hostname_class
	__powerline_context[hostname-class]="${__powerline_retval[0]}"
	# Initialiser les segments à partir de l'environnement.
	__powerline_autosegments "${__powerline_context[hostname-class]}"
	: "${POWERLINE_SEGMENTS:=${__powerline_retval[*]}}"
	__powerline_init_segments
	__powerline_init_colors

	if [ -z "${PROMPT_COMMAND-}" ] ; then
		PROMPT_COMMAND='__update_ps1 $?'
	fi
}


__powerline_autoicons() {
	# Configurer les séparateurs
	local mode
	mode=${POWERLINE_ICONS-auto}

	if [ "${mode}" = "auto" ] ; then
		case "$TERM" in
			*256color|*-termite|*-direct|*-kitty)
				mode=powerline
				;;
			*)
				mode=compat
				;;
		esac
	fi

	# Attention. Les icônes sont déclarés avec l'a notation $'\uXXXX'. XXXX
	# est le code UNICODE (pas l'encodage UTF-8). Parfois, il faut ajouter
	# un espace pour les icônes larges. Bash 4.2 en CentOS7 plante
	# violemment si on injecte l'espace finale avec le symbole unicode. Le
	# contournement est de concaténer avec un espace dans une chaîne
	# traditionnelle.
	case "${mode}" in
		compat)
			: "${POWERLINE_SEP:=$'\u25B6'}"
			: "${POWERLINE_THINSEP:=$'\u276F'}"
			: "${POWERLINE_K8S_ICON:=*}"
			;;
		powerline)
			if [ "${POWERLINE_DIRECTION}" = "ltr" ] ; then
				: "${POWERLINE_SEP:=$'\uE0B0'}"
				: "${POWERLINE_THINSEP:=$'\uE0B1'}"
			else
				: "${POWERLINE_SEP:=$'\uE0B2'}"
				: "${POWERLINE_THINSEP:=$'\uE0B3'}"
			fi
			: "${POWERLINE_GIT_ICON:=$'\uE0A0 '}"  # de la police Powerline
			: "${POWERLINE_K8S_ICON:=$'\u2638 '}"
			;;
		flat)
			: "${POWERLINE_SEP:=}"
			: "${POWERLINE_THINSEP:=}"
			;;
		icons-in-terminal)
			if [ "${POWERLINE_DIRECTION}" = "ltr" ] ; then
				: "${POWERLINE_SEP:=$'\uE0B0'}"
				: "${POWERLINE_THINSEP:=$'\uE0B1'}"
			else
				: "${POWERLINE_SEP:=$'\uE0B2'}"
				: "${POWERLINE_THINSEP:=$'\uE0B3'}"
			fi
			: "${POWERLINE_NEWMAIL_ICON:=$'\uE0E4 '}"
			: "${POWERLINE_FAIL_ICON:=$'\uE023 '}"
			: "${POWERLINE_GIT_DETACHED_ICON:=$'\uF0C1 '}"
			: "${POWERLINE_GIT_ICON:=$'\uEDCE '}"
			: "${POWERLINE_HOSTNAME_ICON:=$'\uE4BA '}"
			: "${POWERLINE_OPENSTACK_ICON:=$'\uE574 '}"
			: "${POWERLINE_PWD_ICON:=$'\uE015 '}"
			: "${POWERLINE_HOME_ICON:=$'\uE67D '}"
			: "${POWERLINE_PYTHON_ICON:=$'\uEE10 '}"
			: "${POWERLINE_DOCKER_ICON:=$'\uE8EA '}"
			: "${POWERLINE_K8S_ICON:=$'\u2638 '}"
			;;
		nerd-fonts)  # cf https://www.nerdfonts.com/cheat-sheet
			if [ "${POWERLINE_DIRECTION}" = "ltr" ] ; then
				: "${POWERLINE_SEP:=$'\uE0B0'}"         # nf-pl-left_hard_divider
				: "${POWERLINE_THINSEP:=$'\uE0B1'}"     # nf-pl-left_soft_divider
			else
				: "${POWERLINE_SEP:=$'\uE0B2'}"
				: "${POWERLINE_THINSEP:=$'\uE0B3'}"
			fi
			: "${POWERLINE_NEWMAIL_ICON:=$'\uFBCD'}"        # nf-mdi-email_alert
			: "${POWERLINE_FAIL_ICON:=$'\uF071 '}"          # nf-fa-exclamation_triangle
			: "${POWERLINE_GIT_DETACHED_ICON:=$'\uF06A '}"  # nf-fa-exclamation_circle
			: "${POWERLINE_GIT_ICON:=$'\uE725 '}"           # nf-dev-git_branch
			: "${POWERLINE_HOSTNAME_ICON:=$'\uF015 '}"      # nf-fa-home
			: "${POWERLINE_OPENSTACK_ICON:=$'\uFCB4 '}"     # nf-mdi-cloud_tags
			: "${POWERLINE_PWD_ICON:=$'\uF07B '}"           # nf-fa-folder
			: "${POWERLINE_HOME_ICON:=$'\uF7DB '}"          # nf-mdi-home
			: "${POWERLINE_PYTHON_ICON:=$'\uE235 '}"        # nf-fae-python
			: "${POWERLINE_DOCKER_ICON:=$'\uF308 '}"        # nf-linux-docker
			: "${POWERLINE_K8S_ICON:=$'\uFD31 '}"           # nf-mdi-ship_wheel
			: "${POWERLINE_ETCKEEPER_ICON:=$'\uF992 '}"     # nf-mdi-message_settings
			;;
		*)
			echo "POWERLINE_ICONS=${mode} inconnu." >&2
			;;
	esac
}


__powerline_autosegments() {
	local class="$1"
	# Détermine les segments pertinent pour l'environnement.
	__powerline_retval=()

	if [ "$class" != "local" ] ; then
		__powerline_retval+=(hostname)
	fi

	if [ -v POWERLINE_MAILDIR ] ; then
		__powerline_retval+=(maildir)
	fi

	__powerline_retval+=(pwd)

	if type -p python2 >/dev/null || type -p python3 >/dev/null ; then
		__powerline_retval+=(python)
	fi

	if type -p git >/dev/null ; then
		if [ "${POWERLINE_DIRECTION-ltr}" = ltr ] ; then
			__powerline_retval+=(git git_sync)
		else
			__powerline_retval+=(git_sync git)
		fi
	fi

	if type -p python >/dev/null ; then
		__powerline_retval+=(openstack)
	fi

	if type -p docker-compose >/dev/null ; then
		__powerline_retval+=(docker)
	fi

	if type -p kubectl >/dev/null ; then
		__powerline_retval+=(k8s)
	fi

	# Ajout du test pour le segment "jobs"
	if type -p jobs >/dev/null ; then
		__powerline_retval+=(jobs)
	fi

	__powerline_retval+=(status)
}

__powerline_init_segments() {
	local segment
	local init
	for segment in ${POWERLINE_SEGMENTS} ; do
		init=__powerline_init_$segment
		if type -t "$init" &> /dev/null ; then
			"$init"
		fi
	done
}


__powerline_init_colors() {
	__powerline_colors=(
		# Nom de couleurs.
		#
		# Attention à définir avec 48; (c'est-à-dire couleur de fond).
		# Le script sait transposer en couleur de texte au besoin.
		[blanc]="48;5;15"
		[blanc-cassé]="48;5;230"
		[bleu]="48;5;20"
		[bleu-canard]="48;5;31"
		[bleu-docker]="48;5;39"
		[bleu-kubernetes]="48;5;27"
		[jaune]="48;5;11"
		[jaune-python]="48;5;220"
		[indigo]="48;5;25"
		[gris]="48;5;240"
		[gris-clair]=gris-clair0
		[gris-clair0]="48;5;250"
		[gris-clair1]="48;5;251"
		[gris-clair2]="48;5;252"
		[gris-clair3]="48;5;253"
		[gris-clair4]="48;5;254"
		[gris-foncé]="48;5;236"
		[noir]="48;5;0"
		[orange]="48;5;166"
		[rouge]="48;5;1"
		[rouge-sombre]="48;5;124"
		[rose]="48;5;161"
		[vert-fluo]="48;5;148"
		[violet]="48;5;53"
		[turquoise]="48;5;31"

		# Alias sémantiques
		[docker-erreur]=violet
		[docker-succes]=bleu-docker
		[docker-texte]=blanc
		[docker-icone]=blanc

		[dollar-erreur]=rouge
		[dollar-succes]="0"  # reset

		[etckeeper-propre-fond]=git-propre-fond
		[etckeeper-propre-texte]=git-propre-texte
		[etckeeper-modifications-fond]=git-modifications-fond
		[etckeeper-modifications-texte]=git-modifications-texte

		[git-icone]=orange
		[git-modifications-fond]=rouge-sombre
		[git-modifications-texte]=blanc-cassé
		[git-propre-fond]=vert-fluo
		[git-propre-texte]=noir
		[git-sync-fond]=gris
		[git-sync-texte]=gris-clair0

		[k8s-fond]=bleu-kubernetes
		[k8s-texte]=gris-clair4

		[maildir-fond]=jaune
		[maildir-texte]="48;5;20;1"  # bleu gras

		[openstack-fond]=gris-clair1
		[openstack-texte]=gris-foncé
		[openstack-icone]=rouge

		[pwd-fond]=gris-foncé
		[pwd-texte]=gris-clair0
		[pwd-home-fond]=turquoise
		[pwd-home-texte]=blanc
		[pwd-sys-fond]=gris-foncé
		[pwd-sys-texte]=gris-clair4

		[python-fond]=indigo
		[python-texte]=jaune-python

		# jobs segment
		[jobs-bg]="48;5;172"  # jaune fonce
		[jobs-fg]="48;5;234"  # gris fonce


		[user-color]="48;5;036"
		[root-color]="48;5;160"

		[status-fond]=rouge
		[status-texte]=gris-clair4
	)

	# Charger la personnalisation.
	if declare -p POWERLINE_COLORS &> /dev/null; then
		for key in "${!POWERLINE_COLORS[@]}" ; do
			__powerline_colors[$key]="${POWERLINE_COLORS[$key]}"
		done
	fi

	# Appliquer les alias, récursivement.
	loop=1
	while [ -n "$loop" ] ; do
		loop=
		for key in "${!__powerline_colors[@]}" ; do
			color="${__powerline_colors[$key]}"
			[ -z "${__powerline_colors[$color]-}" ] && continue
			__powerline_colors[$key]="${__powerline_colors[$color]}"
			loop=1
		done
	done
}


#       R E N D U

# A render function is a bash function starting with `__powerline_render_`. It puts
# a PS1 string in `__powerline_retval`.

__powerline_dollar() {
	local fg
	local last_exit_code=$1
	# Déterminer la couleur du dollar
	if [ "$last_exit_code" -gt 0 ] ; then
		fg="1;${__powerline_colors[dollar-erreur]/#48;/38;}"
	else
		fg="${__powerline_colors[dollar-succes]}"
	fi
	# Afficher le dollar sur une nouvelle ligne, pas en mode powerline
	__powerline_retval=("\\[\\e[${fg}m\\]\\\$\\[\\e[0m\\] ")
}


__powerline_render_default() {
	local bg=''
	local fg
	local icon
	local icon_fg
	local infos
	local old_bg
	local ps=''
	local segment
	local text
	local separator

	for segment in "$@" ; do
		if [ -z "${segment}" ] ; then
			continue
		fi

		old_bg=${bg-}
		__powerline_split ':' "${segment}"
		infos=("${__powerline_retval[@]}")
		icon_fg="${infos[0]}"
		icon="${infos[1]}"

		bg="${infos[2]%%:}"
		bg="${__powerline_colors[$bg]-$bg}"
		fg="${infos[3]%%:}"
		fg="${__powerline_colors[$fg]-$fg}"
		fg="${fg/#48;/38;}"

		icon_fg="${icon_fg:-${fg/#1;/}}"
		icon_fg="${__powerline_colors[$icon_fg]-$icon_fg}"
		icon_fg="${icon_fg/#48;/38;}"

		# Recoller les entrées suivantes avec ':'
		printf -v text ":%s" "${infos[@]:4}"
		text=${text:1}
		# Nettoyer le \n ajouté par <<<
		text="${text##[[:space:]]}"
		text="${text%%[[:space:]]}"
		# Sauter les segments vides
		if [ -z "${text}" ] && [ -z "$icon" ]; then
			continue
		fi

		# D'abord, afficher le chevron avec la transition de fond.
		if [ -n "${old_bg}" ] ; then
			if [ "$bg" = "$old_bg" ]; then
				# Séparateur léger, même couleurs que le texte.
				separator=${POWERLINE_THINSEP-}
				colors="${fg};${bg}"
			else
				separator=${POWERLINE_SEP-}
				colors="${old_bg/48;/38;};${bg}"
			fi
			ps+="\\[\\e[0;${colors}m\\]${separator}"
		fi

		# Ensuite, afficher le segment, coloré.
		ps+="\\[\\e[0;${bg};"
		if [ -n "$icon" ] ; then
			# Définir la couleur de texte sans la graisse (qui doit
			# être au début) avant l'icône et définir la couleur de
			# texte avec graisse après l'icône. Cela permet d'avoir
			# l'icône dans la même couleur que le texte mais sans
			# graisse par défaut, et de pouvoir changer la couleur
			# de l'icône.
			ps+="${icon_fg}m\\] $icon\\[\\e["
		fi
		ps+="${fg}m\\]"
		if [ -n "${text}" ] ; then
			ps+=" $text"
		fi
		ps+=" "
	done

	# Afficher le dernier chevron, transition du fond vers rien.
	old_bg=${bg-}
	if [ -n "${old_bg}" ] ; then
		ps+="\\[\\e[0;${old_bg/#48;/38;}m\\]${POWERLINE_SEP-${__default_sep}}"
	fi

	# Retourner l'invite de commande
	__powerline_retval=("${ps}")
}


__powerline_render_align_right() {
	local bg=''
	local fg
	local icon
	local infos
	local largeur
	local old_bg
	local ps=''
	local raw_ps=''  # PS sans instructions \[\] pour calculer la largeur de l'invit
	local segment
	local text
	local separator

	for segment in "$@" ; do
		if [ -z "${segment}" ] ; then
			continue
		fi

		old_bg=${bg-}
		__powerline_split ':' "${segment}"
		infos=("${__powerline_retval[@]}")
		icon_fg="${infos[0]}"
		icon="${infos[1]}"

		bg="${infos[2]%%:}"
		bg="${__powerline_colors[$bg]-$bg}"
		fg="${infos[3]%%:}"
		fg="${__powerline_colors[$fg]-$fg}"
		fg="${fg/#48;/38;}"

		icon_fg="${icon_fg:-${fg/#1;/}}"
		icon_fg="${__powerline_colors[$icon_fg]-$icon_fg}"
		icon_fg="${icon_fg/#48;/38;}"

		# Recoller les entrées suivantes avec ':'
		printf -v text ":%s" "${infos[@]:4}"
		text=${text:1}
		# Sauter les segments vides
		if [ -z "${text}" ] && [ -z "$icon" ]; then
			continue
		fi

		# D'abord, afficher le chevron avec la transition de fond.
		if [ "$bg" = "$old_bg" ] ; then
			# Séparateur léger, même couleurs que le texte
			separator=${POWERLINE_THINSEP-}
			colors="${fg};${bg}"
		else
			separator=${POWERLINE_SEP-}
			colors="${bg/48;/38;};${old_bg}"
		fi
		ps+="\\[\\e[0;${colors%;}m\\]${separator}"
		raw_ps+="$separator"

		# Ensuite, afficher le segment, coloré.
		ps+="\\[\\e[0;${bg};"
		if [ -n "$icon" ] ; then
			# Définir la couleur de texte sans la graisse (qui doit
			# être au début) avant l'icône et définir la couleur de
			# texte avec graisse après l'icône. Cela permet d'avoir
			# l'icône dans la même couleur que le texte mais sans
			# graisse par défaut, et de pouvoir changer la couleur
			# de l'icône.
			ps+="${fg/#1;/}m\\] $icon\\[\\e[${fg}m\\]"
			raw_ps+=" $icon"
		else
			# Pas d'icône, on défini simplement la couleur de
			# texte.
			ps+="${fg}m\\]"
		fi
		if [ -n "${text}" ] ; then
			ps+=" $text"
			raw_ps+=" $text"
		fi
		ps+=" "
		raw_ps+=" "
	done

	# Mesurer la largueur totale des segments.
	largeur=${#raw_ps}
	printf -v ps "%*s%s\\r%s" $(( COLUMNS - largeur )) "" "$ps" ""

	__powerline_retval=("$ps")
}


#       S E G M E N T S

# Un segment est une fonction bash préfixé par `__powerline_segment_`. Le
# retour est un tableau contenant des chaînes au format :
# `<couleur-icône>:<icône>:<couleur-fond>:<couleur-texte>:<texte>`. Chaque
# chaîne correspond à un segment.

__powerline_segment_docker() {
	local bg
	local dir
	local project
	local service_names
	local service_names_a
	local service_nr
	local started

	__powerline_retval=()

	__powerline_find_parent "$PWD" docker-compose.yml
	if [ -z "${__powerline_retval[*]}" ] ; then
		return
	fi
	local composefile="${__powerline_retval[*]}"
	local composeoverride="${composefile/.yml/.override.yml}"

	# Extraire les noms uniques des services. La locale LANG=C est plus rapide pour sort.
	service_names="$(LANG=C.UTF-8 sed --separate '0,/^services:/d;/^[[:alpha:]]/,$d;/^ *#/d;/^   /d;/^$/d' "${composefile}" "${composeoverride}" 2>/dev/null | sort -u)"
	# Compter le nombre de services dans le fichier compose.
	readarray service_names_a <<<"${service_names}"
	service_nr="${#service_names_a[@]}"
	dir="${__powerline_retval%/*}"
	project="${COMPOSE_PROJECT_NAME-${dir##*/}}"

	# Lister les conteneurs associé au projet. docker (en go) est beaucoup
	# plus rapide que docker-compose (python). Environ 5 fois.
	started=$(docker ps --format "{{ .Status }}" --filter label=com.docker.compose.project="$project")
	__powerline_split $'\n' "${started}"
	started=("${__powerline_retval[@]}")
	if [ "${#started[@]}" -eq "${service_nr}" ] ; then
		bg=docker-succes
	else
		bg=docker-erreur
	fi

	__powerline_retval=(
		"docker-icone:${POWERLINE_DOCKER_ICON-docker}:$bg:docker-texte:${#started[@]}/${service_nr}"
	)
}


# ETCKEEPER
#
# autosegment n'active pas ce segment car l'usage de sudo peut déclencher des
# mails de sécurité en cas de mauvaise configuration. Émettre un mail à chaque
# ouverture de terminal pourrait avoir des conséquences désagréables :-)

__powerline_segment_etckeeper(){
	local code_couleur
	local text="${POWERLINE_ETCKEEPER_LABEL-Etckeeper}"
	local status_symbol

	if [ -n "$(sudo -n git -C /etc/ status --porcelain=v2 2>/dev/null)" ] ; then
		# le dossier '/etc/' est modifié
		code_couleur=modifications
		status_symbol="*"
	else
		# le dossier '/etc/' n'est pas modifier
		code_couleur=propre
		status_symbol=""
	fi

	__powerline_retval=(
		":${POWERLINE_ETCKEEPER_ICON-}:etckeeper-${code_couleur}-fond:etckeeper-${code_couleur}-texte:${status_symbol}${text}"
	)
}


# Variable partagée entre les segments git. Résultat d'une fonction
# __powerline_parse_git_status_*.
__powerline_git_status=()


# GIT
__powerline_segment_git() {
	local branch
	local colors
	local ahead
	local ab
	local ab_segment=''
	local detached
	local status_symbol
	local bg
	local fg

	# Si pas de dossier .git parent, zapper.
	__powerline_find_parent "${PWD}" .git
	if [ -z "${__powerline_retval[*]}" ] ; then
		__powerline_retval=()
		return
	fi

	if ! status="$(LC_ALL=C.UTF-8 "${__powerline_git_cmd[@]}" 2>/dev/null)" ; then
		__powerline_retval=()
		return
	fi
	$__powerline_git_parser "${status}"
	__powerline_git_status=("${__powerline_retval[@]}")
	branch="${__powerline_git_status[0]}"
	detached="${__powerline_git_status[3]}"

	# Colorer la branche selon l'existance de modifications.
	if [ -n "${__powerline_git_status[1]}" ] ; then
		# Modifications présentes.
		fg="git-modifications-texte"
		bg="git-modifications-fond"
		status_symbol="*"
	else
		# Pas de modifications.
		fg="git-propre-texte"
		bg="git-propre-fond"
	fi
	anchor=$'\u2693' # Émoji: ⚓
	anchor="${POWERLINE_GIT_DETACHED_ICON-${anchor}}"

	__powerline_retval=(
		"git-icone:${POWERLINE_GIT_ICON-}:$bg:$fg:${detached:+ ${anchor}}${branch}${status_symbol-}"
	)
}

__powerline_segment_git_sync() {
	local branch
	local colors
	local ahead
	local ab
	local ab_segment=''
	local detached
	local status_symbol
	# local count_commits

	# affiche le compteur de commit désynchronisé
	POWERLINE_GIT_SYNC_COUNT=1

	# Si pas de dossier .git parent, zapper.
	__powerline_find_parent "${PWD}" .git
	if [ -z "${__powerline_retval[*]}" ] ; then
		__powerline_retval=()
		return
	fi

	detached="${__powerline_git_status[3]}"
	ab="${__powerline_git_status[2]}"

	# La valeur ahead-behind concerne upstream ou track. Ce qui nous
	# intéresse est de savoir si on doit pousser dans la branche de
	# destination, pas la branche amont.
	if [ -n "${detached}" ] ; then
		# Pas de push dans une commit détachée.
		ahead=0
	# elif ! ahead="$(git rev-list --count "@..@{push}" -- 2>/dev/null)" ; then
	elif ! ahead="$(git rev-list --count "@{push}..@" -- 2>/dev/null)" ; then
		# En cas d'erreur, on considère qu'il n'y a pas de branche
		# @{push}, donc rien à pousser.
		ahead=0
	fi

	# Segment d'état de synchronisation.
	if [ -n "${ab##+* -0}" ] ; then
		# Il faut tirer des commits upstream.
		ab_segment+="⬇"
		if [ "${POWERLINE_GIT_SYNC_COUNT-}" ] ; then
			ab_segment+=" ${ab##+* -} "
		fi
	fi
	if [ "${ahead}" -gt 0 ] ; then
		# Il faut pousser des commits.
		# 
		# count_commits="$(git rev-list origin..HEAD | wc -l)"
		# ab_segment+="⬆ … $count_commits"
		ab_segment+="⬆ …"
		if [ "${POWERLINE_GIT_SYNC_COUNT-}" ] ; then
			ab_segment+=" $ahead "
		fi
	fi
	if [ -n "${ab_segment}" ] ; then
		__powerline_retval=(
			"::git-sync-fond:git-sync-texte:${ab_segment% }"
		)
	else
		__powerline_retval=()
	fi
}


# Analye git status --porcelain=v2
__powerline_parse_git_status_v2() {
	local status="$1"
	# Le retour de la fonction : sha, name, upstream, ahead/behind
	local branch_infos=()
	local dirty=
	local ab
	local detached=

	while read -r line ; do
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
		branch="${branch_infos[1]}"
	fi

	ab="${branch_infos[3]-}"
	__powerline_retval=("${branch}" "${dirty}" "${ab}" "${detached}")
}

# Analyser la sortie v1 de git status --porcelain
__powerline_parse_git_status_v1() {
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
		branch="${__powerline_retval[0]}"
		else
		# Les autres lignes sont des lignes de modification.
		dirty=1
		break
		fi
	done

	# On bidonne l'état de synchronisation, faute d'information dans git status.
	local ab="+0 -0"

	__powerline_retval=("${branch}" "${dirty}" "${ab}" "${detached}")
}


__powerline_git_cmd=(git status --branch)
__powerline_git_parser=

__powerline_init_git() {
	local v

	# Sélectionner le format de git status à analyser
	v="$(git --version 2>/dev/null)"
	v="${v#git version }"

	# La V2 affiche en une commande l'état de synchronisation
	# (ahead-behind) cf. https://man.netbsd.org/NetBSD-9.0/sort.1,
	# https://www.unix.com/man-page/FreeBSD/1/sort/ et
	# https://ss64.com/osx/sort.html.
	if printf '2.11.0\n%s' "$v" | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -c 2>/dev/null; then
		__powerline_git_cmd+=("--porcelain=v2")
		__powerline_git_parser=__powerline_parse_git_status_v2
	else
		__powerline_git_cmd+=(--porcelain)
		__powerline_git_parser=__powerline_parse_git_status_v1
	fi
}


# HOSTNAME

__powerline_init_hostname() {
	# Comme le segment hostname est fixe tout au long de l'exécution du
	# shell, on le précalcule.
	local bg
	local rgb
	local fg
	local text
	local h

	# Personnaliser la couleur du segment hostname
	# POWERLINE_HOSTNAME_BG="48;5;036"
	# POWERLINE_HOSTNAME_FG="38;5;015"

	# Coloration suivant si le terminal a les droits Administrateur (root/user).
	if [ $UID -ne 0 ]; then
		# USER
		POWERLINE_HOSTNAME_BG="user-color"
		POWERLINE_HOSTNAME_FG="38;5;015"
	else
		# ROOT
		POWERLINE_HOSTNAME_BG="root-color"
		POWERLINE_HOSTNAME_FG="38;5;015"
	fi


	if [ -z "${HOSTNAME-}" ] && [ -f /etc/hostname ] ; then
		read -r HOSTNAME < /etc/hostname
	fi
	USER="${USER-${USERNAME-${LOGNAME-}}}"
	# N'appeler whoami qui si besoin
	if [ -z "${USER}" ] ; then
		USER=$(whoami)
	fi

	text="${USER}@${HOSTNAME-*unknown*}"

	if [ -n "${POWERLINE_HOSTNAME_BG-}" ] && [ -n "${POWERLINE_HOSTNAME_FG-}" ]; then
		fg="${POWERLINE_HOSTNAME_FG}"
		bg="${POWERLINE_HOSTNAME_BG}"
	else
		h=$(cksum <<< "$text")
		h="${h% *}"
		if [[ $COLORTERM =~ ^(truecolor|24bit)$ ]] && type -p awk &>/dev/null ; then
			__powerline_hostname_color24 "${__powerline_context[hostname-class]}" "$h"
			__powerline_hsl2rgb "${__powerline_retval[@]}"
			rgb=("${__powerline_retval[@]}")
			bg="48;2;${rgb[0]};${rgb[1]};${rgb[2]}"
			fg="38;5;253"
		else
			__powerline_hostname_color256 "$h"
			rgb=("${__powerline_retval[@]}")
			__powerline_color256 "${rgb[@]}"
			bg="48;5;${__powerline_retval[0]}"

			# Assurer la lisibilité en déterminant la couleur du texte en fonction de la
			# clareté du fond.
			__powerline_get_foreground "${rgb[@]}"
			fg="38;5;${__powerline_retval[0]}"
		fi
	fi

	__powerline_context[hostname-segment]=":${POWERLINE_HOSTNAME_ICON-}:${bg}:${fg}:${text}"
}

__powerline_hostname_color256() {
	# Calcule une couleur parmi les 215 couleurs RGB de la palette. Pour
	# éviter un effet fluo, on se restreint au couleurs pastels. Pour cela,
	# on choisie parmi les combinaisons RGB {0..4}{1..3}{1..4} soit 5 * 3 *
	# 4 = 60 couleurs.
	#
	# Retourne les valeurs de chaques composants RGB. Pour obtenir le code
	# 256, utiliser __powerline_color256.
	#
	# Le script tests/hostname256.sh affiche toutes les combinaisons possibles.

	local h="$1"
	h=$((h % 60))
	__powerline_retval=(
		# R = Nombre de fractions de 12 dans 60.
		$((h / 3 / 4))
		# V = Nombre de fraction de 4 dans le module de 12.
		$((1 + (h % (3 * 4)) / 4))
		# B = Module de 4.
		$((1 + h % 4))
	)
}

__powerline_hostname_color24() {
	# Quelle couleur choisir pour identifier l'utilisateur et la machine du
	# shell courant ?
	#
	# On va utiliser des teintes dans tout le spectre sauf le rouge et le
	# vert vif, on les garde pour les autres segments.
	#
	# Pour la saturation, on varie sur un bon écart pour bien distinguer
	# les saturations. On réserve les saturations élevées pour
	# l'utilisateur root, on va augmenter la staturation. Une couleur plus
	# pimpante aidera à faire plus attention.
	#
	# On reste sur une luminosité moyenne, pour ne pas trop attirer
	# l'attention par rapport aux autres segments, comme pour le rouge et
	# le vert.
	#
	# Le script tests/hostname24.sh affiche toutes les combinaisons possibles.

	local class="$1"
	local h="$2"
	local hue
	local sat
	local lum

	# Saturations : {2..8} -> 7 valeurs
	local shift_sat=2
	local num_sat=7
	local shift_hue
	local num_hue
	case "$class" in
		local)
			# Teintes : 5 ou 9 -> 2 valeurs
			shift_hue=5
			num_hue=2
			;;
		remote)
			# Teintes : 13, 17, 21 -> 3 valeurs
			shift_hue=13
			num_hue=3
			;;
		container|virtualmachine)
			# Teintes : {45..77}/4 -> 9 valeurs
			shift_hue=45
			num_hue=9
			;;
		root)
			# Teintes : {81..93}/4: -> 4 valeurs
			shift_hue=81
			num_hue=4
			# Saturations : {6..8} -> 3 valeurs
			shift_sat=6
			num_sat=3
			;;
		*)
			# Un orange fixe pour le repli.
			__powerline_retval=(0.09 0.60 0.35)
			return
			;;
	esac

	h=$((h % (num_sat * num_hue)))

	hue=$((shift_hue + (h / num_sat) * 4))
	printf -v hue "0.%02d" "$hue"

	sat=$((shift_sat + h % num_sat))
	sat=0.$sat

	# Luminance fixe, assez faible pour ne pas capter trop l'attention.
	lum=0.35

	__powerline_retval=("$hue" "$sat" "$lum")
}

__powerline_hostname_class() {
	__powerline_retval=(local)

	if [ "${USER}" = "root" ] ; then
		__powerline_retval=(root)
	elif [ "${UID}" -eq 1000 ] ; then
		__powerline_retval=()
	# elif [ "${USER}" = "pspk" ] ; then
	# 	__powerline_retval=()
	elif [ -f /.dockerenv ] ; then
		__powerline_retval=(container)
	elif LC_ALL=C lscpu |& grep -iq 'hypervisor vendor' ; then
		__powerline_retval=(virtualmachine)
	elif [ -v SSH_CLIENT ] ; then
		__powerline_retval=(remote)
	elif [ -v POWERLINE_HOSTNAME_CLASS ] ; then
		__powerline_retval=("${POWERLINE_HOSTNAME_CLASS}")
	fi
}

__powerline_segment_hostname() {
	# Initialisation paresseuse, cela permet d'activer le segment hostname
	# à chaud.
	if [ -z "${__powerline_context[hostname-segment]-}" ] ; then
		__powerline_init_hostname
	fi
	__powerline_retval=("${__powerline_context[hostname-segment]}")
}


# KUBERNETES

__powerline_segment_k8s() {
	__powerline_retval=()
	local contexte namespace texte
	local format='{..current-context}|{..namespace}'

	if ! [ -f "${KUBE_CONFIG-$HOME/.kube/config}" ] ; then
		return
	fi

	texte="$(kubectl config view --minify --output "jsonpath=$format" 2>/dev/null)"
	if [ -z "$texte" ] ; then
		return
	fi
	contexte="${texte%%|*}"
	namespace="${texte##*|}"

	__powerline_retval=(
		":${POWERLINE_K8S_ICON-}:k8s-fond:k8s-texte:$contexte"
		"::k8s-fond:k8s-texte:$namespace"
	)
}


# MAILDIR

__powerline_init_maildir() {
	if ! [ -v POWERLINE_MAILDIR ] ; then
		echo "POWERLINE_MAILDIR indéfini. Voir la documentation." >&2
	fi
}

__powerline_segment_maildir() {
	__powerline_retval=()
	newmails=("${POWERLINE_MAILDIR}"/new/*)
	local count="${#newmails[@]}"
	if [ "${newmails[0]}" = "${POWERLINE_MAILDIR}/new/*" ] ; then
		# nullglob option not activated, dir is empty so the glob returns the pattern
		return
	fi
	__powerline_retval=(
		":${POWERLINE_NEWMAIL_ICON-M}:maildir-fond:maildir-texte:${count}"
	)
}


# OPENSTACK

__powerline_segment_openstack() {
	__powerline_retval=()
	if [ -z "${OS_USERNAME-}${OS_APPLICATION_CREDENTIAL_ID-}" ] ; then
		return;
	fi

	local text
	if [ -n "${OS_USERNAME-}" ] ; then
		text="${OS_USERNAME}"
	else
		text="${OS_APPLICATION_CREDENTIAL_ID::8}"
	fi

	text+="@"
	if [ -n "${OS_PROJECT_NAME-}" ] ; then
		text+="${OS_PROJECT_NAME}"
	else
		text+="${OS_AUTH_URL##http*//}"
	fi

	__powerline_retval=(
		"openstack-icone:${POWERLINE_OPENSTACK_ICON-¤}:openstack-fond:openstack-texte:${text}"
	)
}


# PWD

__powerline_segment_pwd() {
	local colors
	local short_pwd
	local icon

	__powerline_shorten_dir "$(dirs +0)"
	local short_pwd="${__powerline_retval[0]}"

	# Affichage de la branche "/" dans le prompt
	if [ "$short_pwd" = "/" ] ; then
		__powerline_split "" "${short_pwd}"
		local parts=("${__powerline_retval[@]}")
	else
		__powerline_split / "${short_pwd}"
		local parts=("${__powerline_retval[@]}")
	fi

	__powerline_retval=()
	for part in "${parts[@]}" ; do
		if [ "${part}" = '~' ] ; then
			icon="${POWERLINE_HOME_ICON-~}"
			part=
			colors="pwd-home-fond:pwd-home-texte"
		elif [ "${part}" = "" ] ; then
			icon="${POWERLINE_PWD_ICON-}"  # Icône hors ~
			# colors="pwd-sys-fond:pwd-sys-texte"
			colors="user-color:pwd-home-texte"
		else
			icon=
			colors="pwd-fond:pwd-texte"
		fi
		__powerline_retval+=(":$icon:$colors:$part")
	done
}


# PYTHON

__powerline_segment_python() {
	local text

	if [ -v VIRTUAL_ENV ] ; then
		# Les virtualenv python classiques
		text=${VIRTUAL_ENV##*/}
	elif [ -v CONDA_ENV_PATH ] ; then
		text=${CONDA_ENV_PATH##*/}
	elif [ -v CONDA_DEFAULT_ENV ] ; then
		text=${CONDA_DEFAULT_ENV##*/}
	elif [ -v PYENV_ROOT ] ; then
		# Les virtualenv et versions pyenv
		__powerline_pyenv_version_name
		text="${__powerline_retval[*]}"
	fi

	if [ -n "${text}" ] ; then
		__powerline_retval=(
			":${POWERLINE_PYTHON_ICON-}:python-fond:python-texte:${text}")
	else
		__powerline_retval=()
	fi
}

__powerline_pyenv_version_name() {
	local dir="$PWD"
	__powerline_retval=("${PYENV_VERSION-}")
	if [ -n "${__powerline_retval[*]}" ] ; then
		return
	fi

	__powerline_find_parent "${dir}" .python-version
	if [ -n "${__powerline_retval[*]}" ] && readarray __powerline_retval < "${__powerline_retval[*]}" 2>/dev/null ; then
		# read a trouvé quelque choses (et l'a enregistré), c'est tout bon.
		return
	fi

	# L'existence de ${PYENV_ROOT} a déjà été testée dans le segment "python".
	if [ -f "${PYENV_ROOT}/version" ] ; then
		readarray -n 1 -t __powerline_retval < "${PYENV_ROOT}"/version 2>/dev/null
	fi
}

# JOBS

__powerline_segment_jobs() {
	# Ancienne methode pour calculer les "jobs" en cours.
	#local jobsnum="$(jobs -p | wc -l)"

	# Compte le nombre de "jobs" avec un meilleur affichage pour le terminal
	# car il permet de choisir uniquement les process "Running" et "Stopped" 
	# et d'enlever les autres "Terminated" et "Done" qui ne sont pas important.
	local jobsnum
	jobsnum=$(jobs -l | awk -F" " '{ print $3 }' | grep -c -E 'Running|Stopped')

	# Efface "jobsnum" si valeur egal a 0
	if [ "$jobsnum" -eq 0 ] ; then
		__powerline_retval=()
		return
	fi

	# __powerline_retval=("::jobs-bg:jobs-fg:⚙ $jobsnum")
	__powerline_retval=("jobs-fg:⚙:jobs-bg:jobs-fg:$jobsnum")
}
# STATUS

__powerline_segment_status() {
	local ec=$1

	if [ "$ec" -eq 0 ] ; then
		__powerline_retval=()
		return
	fi

	__powerline_retval=(
		":${POWERLINE_FAIL_ICON-✘}:status-fond:status-texte:$ec"
	)
}


#      T O O L I N G

__powerline_find_parent() {
	local cwd="$1"
	local name="$2"
	__powerline_retval=()

	while [ "$cwd" ] ; do
		if [ -e "$cwd/$name" ] ; then
			__powerline_retval=("$cwd/$name")
			return
		fi
		# Sinon, on remonte d'un cran dans l'arborescence.
		cwd="${cwd%/*}"
	done
}


__powerline_color256() {
	__powerline_retval=(
		$((16 + $1 * 36 + $2 * 6 + $3))
	)
}

__powerline_get_foreground() {
	local R=$1
	local V=$2
	local B=$3

	# Les terminaux 256 couleurs ont 6 niveaux pour chaque composant. Les
	# valeurs réelles associées aux indices entre 0 et 5 sont les
	# suivantes.
	local values=(0 95 135 175 215 255)
	# Indice de luminosité entre 0 et 9 calculé à partir des composants
	# RGB.
	local luminance
	# On associe une couleur de texte pour chaque niveau de luminosité
	# entre 0 et 9. Du gris clair au gris foncé en passant par blanc et
	# noir.
	local foregrounds=(252 253 253 255 16 16 16 235 234 234)

	# cf. https://fr.wikipedia.org/wiki/SRGB#Caract%C3%A9ristiques_principales
	luminance=$(((${values[${R}]} * 2126 + ${values[${V}]} * 7152 + ${values[${B}]} * 722) / 280000))

	# Tronquer la partie décimale et assurer le 0 initial.
	LC_ALL=C printf -v luminance "%.0f" $luminance

	# Récupérer la couleur de texte selon la luminosité
	__powerline_retval=("${foregrounds[$luminance]}")

	# Afficher le résultat pour test visuel.
	if [ -n "${DEBUG-}" ] ; then
		fg="${__powerline_retval[*]}"
		bg=$((16 + 36 * R + 6 * V + B))
		fgbg="$fg/$bg"
		text="${LOGNAME}@${HOSTNAME}"
		printf "\\e[38;5;${fg};48;5;${bg}m $text \\e[0m RVB=%s L=%d %7s" "$R$V$B" "$luminance" "$fgbg"
	fi
}


__powerline_hsl2rgb() {
	local h="$1"
	local s="$2"
	local l="$3"

	# cf. https://github.com/python/cpython/blob/3.6/Lib/colorsys.py#L70
	rvb=$(awk -f - <<-EOF
	function component(hue, m1, m2) {
		if ( hue < 0 ) hue = hue + 1
		if ( 1 < hue ) hue = hue - 1

		if ( hue < 1/6 ) {
			return m1 + (m2 - m1) * 6 * hue
		} else if ( hue < 1/2 ) {
			return m2
		} else if ( hue < 2/3 ) {
			return m1 + (m2 - m1) * (2/3 - hue) * 6
		} else {
			return m1
		}
	}

	BEGIN {

	if ( $l <= 0.5 ) {
		m2 = $l * (1 + $s)
	} else {
		m2 = $l + $s - $l * $s
	}
	m1 = 2 * $l - m2

	if ( $s == 0 ) {
		r = v = b = $l
	} else {
		r = component($h + 1/3, m1, m2)
		v = component($h, m1, m2)
		b = component($h - 1/3, m1, m2)
	}

	printf "%d\n%d\n%d\n", 255 * r / 1, 255 * v / 1, 255 * b / 1
	}
	EOF
	)
	readarray -t __powerline_retval <<<"$rvb"
	key=$(( ${#__powerline_retval[@]} - 3 ))
	__powerline_retval=("${__powerline_retval[@]:$key:3}")
}


# Abrège les dossiers intermédiaires pour raccourcir le chemine complet.
__powerline_shorten_dir() {
	local short_pwd
	local dir="$1"

	__powerline_split / "${dir##/}"
	dir_parts=("${__powerline_retval[@]}")
	local number_of_parts=${#dir_parts[@]}

	# If there are less than 6 path parts, then do no shortening.
	if [[ "$number_of_parts" -lt "5" ]]; then
		__powerline_retval=("${dir}")
		return
	fi
	# Leave the last 2 part parts alone.
	local last_index="$(( number_of_parts - 3 ))"
	local short_pwd=""

	# Check for a leading slash.
	if [[ "${dir:0:1}" == "/" ]]; then
		# If there is a leading slash, add one to `short_pwd`.
		short_pwd+='/'
	fi

	for i in "${!dir_parts[@]}"; do
		# Append a '/' before we do anything (provided this isn't the
		# first part).
		if [[ "$i" -gt "0" ]]; then
			short_pwd+='/'
		fi

		# Don't shorten the first/last few arguments - leave them
		# as-is.
		if [[ "$i" -lt "2" || "$i" -gt "$last_index" ]]; then
			short_pwd+="${dir_parts[i]}"
		else
			# This means that this path part is in the middle of
			# the path. Our logic dictates that we shorten parts in
			# the middle like this.
			short_pwd+="${dir_parts[i]:0:1}"
		fi
	done

	# Return the resulting short pwd.
	__powerline_retval=("$short_pwd")
}


__powerline_split() {
	local sep="$1"
	local str="$2"
	local OIFS="${IFS-__UNDEF__}"
	IFS="$sep"
	set -f
	# shellcheck disable=SC2206
	__powerline_retval=(${str})
	set +f
	if [ "${OIFS}" = "__UNDEF__" ] ; then
		unset IFS
	else
		IFS="${OIFS}"
	fi
}


# Fonction de traçage des performances : utiliser ces fonctions avant et après le code à tracer.
# Le script tests/perf.py permet de calculer le temps effectif de chaque commande.

__powerline_trace_on()
{
	PS4='$EPOCHREALTIME+'
	local log="${1-my-powerline.${EPOCHREALTIME%%,*}.${POWERLINE_DIRECTION-ltr}.log}"
	set -x
	: "Traces dans $log"
	exec 3>&2 2>"$log"
}


__powerline_trace_off()
{
	set +x
	exec 2>&3 3>&-
}


#      F I R E

__powerline_init
