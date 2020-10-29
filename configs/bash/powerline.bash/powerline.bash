#!/bin/bash
# cf. https://gitlab.com/bersace/powerline.bash
# cf. Dernier commit depuis ma modification : 
# 02 Oct, 2020 "Améliorer le choix de la couleur d'hôte en 24bit" 101cac7fcd9c0bfb89ab622ef4ad48c7ffa2da54
#
# Cette variable globale permet de retourner une valeurs à du code appelant
# sans passer par un sous-shell. Cela optimise énormément les performances.
# Cette valeur doit toujours être un tableau, contenant une seule valeur si la
# fonction retourne un scalaire.
#
# Merge of 
# https://github.com/b-ryan/powerline-shell/ and
# https://github.com/skeswa/prompt and
# https://gist.github.com/sminez/11fe5d763a9e9e63be5d836715c6425c
# Modified by phinasphreak
#
# Others icon "⚑","⇣", "⇡", "⬇", "⬆", "★", "●", "✖", "✚", "…", "", "✼", "✔", "✎", "⚙"
__powerline_retval=()


# Point d'entrée pour exécution dans PROMPT_COMMAND.
__update_ps1() {
	local last_exit_code=${1-$?}
	local __powerline_segments=()
	local segname

	__powerline_git_status=()
	for segname in ${POWERLINE_SEGMENTS-hostname pwd status} ; do
		"__powerline_segment_${segname}" "$last_exit_code"
		__powerline_segments+=("${__powerline_retval[@]}")
	done

	local __ps1=""
	# Changer le titre de la fenêtre ou de l'onglet, par ex. POWERLINE_WINDOW_TITLE="\h"
	if [ -v POWERLINE_WINDOW_TITLE ] ; then
		ps1+="\\[\\e]0;${POWERLINE_WINDOW_TITLE}\\a\\]"
	fi

	"__powerline_render_${POWERLINE_STYLE-default}"

	# Prompt without linebreak
	__ps1+="${__powerline_retval[0]}\\[\\e[0m\\]"
	# Prompt with linebreak
	#__ps1+="${__powerline_retval[0]}\\[\\e[0m\\]\\n"

	__powerline_dollar "$last_exit_code"
	__ps1+="${__powerline_retval[0]}"
	PS1="${__ps1}"
}


#	I N I T I A L I S A T I O N


__powerline_init() {
	# Initialiser les segments à partir de l'environnement.
	__powerline_setup_colors
	__powerline_autoicons
	__powerline_autosegments
	: "${POWERLINE_SEGMENTS:=${__powerline_retval[*]}}"
	__powerline_init_segments

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
			*256color|*-termite|*-direct)
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
			: "${POWERLINE_SEP:=$'\uE0B0'}"
			: "${POWERLINE_THINSEP:=$'\uE0B1'}"
			: "${POWERLINE_GIT_ICON:=$'\uE0A0 '}"  # de la police Powerline
			: "${POWERLINE_K8S_ICON:=$'\u2638 '}"
			;;
		flat)
			: "${POWERLINE_SEP:=}"
			: "${POWERLINE_THINSEP:=}"
			;;
		icons-in-terminal)
			: "${POWERLINE_SEP:=$'\uE0B0'}"
			: "${POWERLINE_THINSEP:=$'\uE0B1'}"
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
			: "${POWERLINE_SEP:=$'\uE0B0'}"                 # nf-pl-left_hard_divider
			: "${POWERLINE_THINSEP:=$'\uE0B1'}"             # nf-pl-left_soft_divider
			: "${POWERLINE_NEWMAIL_ICON:=$'\uFBCD'}"        # nf-mdi-email_alert
			: "${POWERLINE_FAIL_ICON:=$'\uF071 '}"          # nf-fa-exclamation_triangle
			: "${POWERLINE_GIT_DETACHED_ICON:=$'\uF06A '}"  # nf-fa-exclamation_circle
			: "${POWERLINE_GIT_ICON:=$'\uE725 '}"           # nf-dev-git_branch
			: "${POWERLINE_HOSTNAME_ICON:=$'\uF015 '}"      # nf-fa-home
			: "${POWERLINE_OPENSTACK_ICON:=$'\uFCB4 '}"     # nf-mdi-cloud_tags
			: "${POWERLINE_PWD_ICON:=$'\uF07B '}"           # nf-fa-folder
			: "${POWERLINE_PWD_ICON:=$'\uF7DB '}"           # nf-mdi-home
			: "${POWERLINE_PYTHON_ICON:=$'\uE235 '}"        # nf-fae-python
			: "${POWERLINE_DOCKER_ICON:=$'\uF308 '}"        # nf-linux-docker
			: "${POWERLINE_K8S_ICON:=$'\uFD31 '}"           # nf-mdi-ship_wheel
			: "${POWERLINE_ETCKEEPER_ICON:=$'\uF992 '}"   # nf-mdi-message_settings
			;;
		*)
			echo "POWERLINE_ICONS=${mode} inconnu." >&2
			;;
	esac
}


__powerline_autosegments() {
	# Détermine les segments pertinent pour l'environnement.
	__powerline_retval=()

	if [ -f /.dockerenv ] ; then
		container=docker
	fi

	local remote;
	remote=${SSH_CLIENT-${SUDO_USER-${container-}}}
	if [ $UID -eq 1000 ] ; then
		__powerline_retval+=(hostname)
	else
		if [ -n "${remote}" ] ; then
			__powerline_retval+=(hostname)
		fi
	fi

	if [ -v POWERLINE_MAILDIR ] ; then
		__powerline_retval+=(maildir)
	fi

	__powerline_retval+=(pwd)

	# Remplacer "python" par "python3" si python2.7 n'est pas installer sur votre système
	if type -p python3 >/dev/null ; then
		__powerline_retval+=(python)
	fi

	if type -p git >/dev/null ; then
		__powerline_retval+=(git git_sync)
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


#	R E N D U
#
# A render function is a bash function starting with `__powerline_render_`. It puts
# a PS1 string in `__powerline_retval`.

__powerline_dollar() {
	local fg
	local last_exit_code=$1
	# Déterminer la couleur du dollar
	if [ "$last_exit_code" -gt 0 ] ; then
		fg=${__powerline_colors[DOLLAR_ERROR_FG]}
	else
		fg=${__powerline_colors[DOLLAR_FG]}
	fi
	# Afficher le dollar sur une nouvelle ligne, pas en mode powerline
	__powerline_retval=("\\[\\e[${fg}m\\]\\\$\\[\\e[0m\\] ")
}


__powerline_render_default() {
	local bg=''
	local fg
	local icon
	local infos
	local old_bg
	local ps=''
	local segment
	local text
	local separator

	for segment in "${__powerline_segments[@]}" ; do
		if [ -z "${segment}" ] ; then
			continue
		fi

		old_bg=${bg-}
		__powerline_split ':' "${segment}"
		infos=("${__powerline_retval[@]}")
		icon="${infos[2]}"
		# Recoller les entrées 2 et suivantes avec :
		printf -v text ":%s" "${infos[@]:3}"
		text=${text:1}
		# Nettoyer le \n ajouté par <<<
		text="${text##[[:space:]]}"
		text="${text%%[[:space:]]}"
		# Sauter les segments vides
		if [ -z "${text}" ] && [ -z "$icon" ]; then
			continue
		fi

		# D'abord, afficher le chevron avec la transition de fond.
		bg=${infos[0]%%:}
		fg=${infos[1]%%:}
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
			ps+="${fg/#1;/}m\\] $icon\\[\\e[${fg}m\\]"
		else
			# Pas d'icône, on défini simplement la couleur de
			# texte.
			ps+="${fg}m\\]"
		fi
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


#	S E G M E N T S
#
# Un segment est une fonction bash préfixé par `__powerline_segment_`. Le
# retour est un table contenant des chaînes au format :
# `<bg_color>:<fg_color>:<icon>:<text>`. Chaque chaîne correspond à un segment.

__powerline_segment_docker() {
	local bg
	local dir
	local project
	local service_nr
	local started

	__powerline_retval=()

	__powerline_find_parent "$PWD" docker-compose.yml
	if [ -z "${__powerline_retval[*]}" ] ; then
		return
	fi

	# Compter le nombre de services dans le fichier compose.
	service_nr="$(grep --count "^    image:" "${__powerline_retval[*]}")"
	dir="${__powerline_retval%/*}"
	project="${COMPOSE_PROJECT_NAME-${dir##*/}}"

	# Lister les conteneurs associé au projet. docker (en go) est beaucoup
	# plus rapide que docker-compose (python). Environ 5 fois.
	started=$(docker ps --format "{{ .Status }}" --filter label=com.docker.compose.project="$project")
	__powerline_split $'\n' "${started}"
	started=("${__powerline_retval[@]}")
	if [ "${#started[@]}" -eq "${service_nr}" ] ; then
		bg="${__powerline_colors[SEGMENT_DOCKER_ALL_STARTED_BG]}"
	else
		bg="${__powerline_colors[SEGMENT_DOCKER_NOT_ALL_STARTED_BG]}"
	fi

	__powerline_retval=(
		"$bg:${__powerline_colors[SEGMENT_DOCKER_FG]}:${__powerline_colors[ICON_DOCKER]}${POWERLINE_DOCKER_ICON-docker}:${#started[@]}/${service_nr}"
	)
}


#	ETCKEEPER
#
# autosegment n'active pas ce segment car l'usage de sudo peut déclencher des
# mails de sécurité en cas de mauvaise configuration. Émettre un mail à chaque
# ouverture de terminal pourrait avoir des conséquences désagréables :-)

__powerline_segment_etckeeper(){
	local fg
	local bg
	local text="${POWERLINE_ETCKEEPER_LABEL-Etckeeper}"
	local status_symbol

	if [ -n "$(sudo -n git -C /etc/ status --porcelain=v2 2>/dev/null)" ] ; then
		# le dossier '/etc/' est modifié
		fg="38;5;230"
		bg="48;5;124"
		status_symbol="*"
	else
		# le dossier '/etc/' n'est pas modifier
		fg="38;5;0"
		bg="48;5;148"
		status_symbol=""
	fi

	__powerline_retval=("${bg}:${fg}:${POWERLINE_ETCKEEPER_ICON-}:${status_symbol}${text}")
}


# Variable partagée entre les segments git. Résultat d'une fonction
# __powerline_parse_git_status_*.
__powerline_git_status=()


#	GIT

__powerline_segment_git() {
	local branch
	local colors
	local ahead
	local ab
	local ab_segment=''
	local detached
	local status_symbol

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
		branch_fg="${__powerline_colors[SEGMENT_GIT_MODIF_BRANCH_FG]}"
		branch_bg="${__powerline_colors[SEGMENT_GIT_MODIF_BRANCH_BG]}"
		status_symbol="*"
	else
		# Pas de modifications.
		branch_fg="${__powerline_colors[SEGMENT_GIT_BRANCH_FG]}"
		branch_bg="${__powerline_colors[SEGMENT_GIT_BRANCH_BG]}"
	fi
	icon="${__powerline_colors[ICON_GIT]}${POWERLINE_GIT_ICON-}"
	colors="${branch_bg}:${branch_fg}"
	anchor=$'\u2693' # Émoji: ⚓
	anchor="${POWERLINE_GIT_DETACHED_ICON-${anchor}}"

	__powerline_retval=("${colors}:${icon}:${detached:+ ${anchor}}${branch}${status_symbol-}")
}

__powerline_segment_git_sync() {
	local branch
	local colors
	local ahead
	local ab
	local ab_segment=''
	local detached
	local status_symbol
	local count_commits

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
	elif ! ahead="$(git rev-list --count "@{push}..@" -- 2>/dev/null)" ; then
		# En cas d'erreur, on considère qu'il n'y a pas de branche
		# @{push}, donc rien à pousser.
		ahead=0
	fi

	# Segment d'état de synchronisation.
	if [ "${ahead}" -gt 0 ] ; then
		# Il faut pousser des commits.
		count_commits=$(git rev-list origin..HEAD | wc -l)
		ab_segment="⬆ … $count_commits"
		if [ "${POWERLINE_GIT_SYNC_COUNT-}" ] ; then
			ab_segment+="(+$ahead)"
		fi
	fi
	if [ -n "${ab##+* -0}" ] ; then
		# Il faut tirer des commits upstream.
		ab_segment+="⬇"
		if [ "${POWERLINE_GIT_SYNC_COUNT-}" ] ; then
			ab_segment+="(${ab##+* })"
		fi
	fi
	if [ -n "${ab_segment}" ] ; then
		__powerline_retval=("${__powerline_colors[SEGMENT_GIT_AB_BG]}:${__powerline_colors[SEGMENT_GIT_AB_FG]}::${ab_segment}")
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

	# La V2 affiche en une commande l'état de synchronisation (ahead-behind)
	if printf '2.11.0\n%s' "$v" | sort --version-sort --check=quiet ; then
		__powerline_git_cmd+=("--porcelain=v2")
		__powerline_git_parser=__powerline_parse_git_status_v2
	else
		__powerline_git_cmd+=(--porcelain)
		__powerline_git_parser=__powerline_parse_git_status_v1
	fi
}


#	HOSTNAME

__powerline_init_hostname() {
	# Comme le segment hostname est fixe tout au long de l'exécution du
	# shell, on le précalcule.
	local bg
	local rgb
	local fg
	local text
	local h

	if [ -z "${HOSTNAME-}" ] && [ -f /etc/hostname ] ; then
		read -r HOSTNAME < /etc/hostname
	fi
	USER="${USER-${USERNAME-${LOGNAME-}}}"
	# N'appeler whoami qui si besoin
	if [ -z "${USER}" ] ; then
		USER=$(whoami)
	fi

	text="${USER}@${HOSTNAME-*unknown*}"
	h=$(cksum <<< "$text")
	h="${h% *}"
	if [[ $COLORTERM =~ ^(truecolor|24bit)$ ]] && type -p bc &>/dev/null ; then
		__powerline_hostname_color24 "${USER//root/1}" "$h"
		__powerline_hsl2rgb "${__powerline_retval[@]}"
		rgb=("${__powerline_retval[@]}")
		bg="48;2;${rgb[0]};${rgb[1]};${rgb[2]}"
		fg="38;5;253"

		# Fonction de coloration.
		__powerline_color_user_root
	else
		__powerline_hostname_color256 "$h"
		rgb=("${__powerline_retval[@]}")
		__powerline_color256 "${rgb[@]}"
		bg="48;5;${__powerline_retval[0]}"

		# Assurer la lisibilité en déterminant la couleur du texte en fonction de la
		# clareté du fond.
		__powerline_get_foreground "${rgb[@]}"
		fg="38;5;${__powerline_retval[0]}"

		# Fonction de coloration.
		__powerline_color_user_root
	fi

	__powerline_hostname_segment="${bg}:${fg}:${POWERLINE_HOSTNAME_ICON-}:${text}"
}

__powerline_color_user_root() {
	# Coloration suivant si le terminal a les droits Administrateur (root/user).
	if [ $UID -ne 0 ]; then
		# With 'bold'
		bg="1;48;5;36"

		# Without 'bold'
		#bg="48;5;36"
	else
		# With 'bold'
		bg="1;48;5;160"

		# Without 'bold'
		#bg="48;5;160"
	fi

}

__powerline_hostname_color256() {
	# Calcule une couleur parmi les 215 couleurs RGB de la palette. Pour
	# éviter un effet fluo, on se restreint au couleurs pastels. Pour cela,
	# on choisie parmi les combinaisons RGB {0..4}{1..3}{1..4} soit 5 * 3 *
	# 4 = 60 couleurs.
	#
	# Retourne les valeurs de chaques composants RGB. Pour obtenir le code
	# 256, utiliser __powerline_color256.

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
	# Le script tests/pastel.sh affiche toutes les combinaisons possibles.

	local root="$1"
	local h="$2"
	local hue
	local sat
	local lum

	# Sat : {2..4} -> 3 valeurs ( +4 pour root )
	# Teinte : {5..80}/5 - {30,35}/5 -> 16 valeurs
	# Total: 16 * 3 = 48 couleurs
	h=$((h % 48))

	# Nombre de fractions de 3 (max 15)
	hue=$((h / 3))
	# Commencer à 5 (après le rouge vif) et échelonner tout les 5 pour
	# avoir des couleurs distinctes.
	hue=$((5 + hue * 5))
	# Sauter le vert : 0.3-0.4
	if [ 30 -le $hue ] ; then
		hue=$((hue+10))
	fi
	printf -v hue "0.%02d" "$hue"

	# Module de 7, décalé pour commencer après les gris.
	sat=$((2 + h % 3))
	if [ "$root" = 1 ] ; then
		sat=$((sat + 4))
	fi
	sat=0.$sat

	# Luminance fixe, assez faible pour ne pas capter trop l'attention.
	lum=0.35

	__powerline_retval=("$hue" "$sat" "$lum")
}

__powerline_segment_hostname() {
	__powerline_retval=("$__powerline_hostname_segment")
}


#	KUBERNETES

__powerline_segment_k8s() {
	__powerline_retval=()
	local seg

	local ctx ns
	ctx=$(kubectl config current-context)
	ns=$(kubectl config view --minify --output 'jsonpath={..namespace}')

	if [ "${POWERLINE_K8S_CTX_SHOW:-0}" == "1" ]; then
		seg="${ctx}/${ns}"
	else
		seg="${ns}"
	fi

	__powerline_retval=("${__powerline_colors[SEGMENT_K8S_FG]}:${__powerline_colors[SEGMENT_K8S_BG]}:${POWERLINE_K8S_ICON-}:$seg")
}


#	MAILDIR

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
	local bg="${__powerline_colors[SEGMENT_MAILDIR_BG]}"
	local fg="${__powerline_colors[SEGMENT_MAILDIR_FG]}"
	__powerline_retval=("${bg}:${fg}:${POWERLINE_NEWMAIL_ICON-M}:${count}")
}


#	OPENSTACK

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

	local bg="${__powerline_colors[SEGMENT_OPENSTACK_BG]}"
	local fg="${__powerline_colors[SEGMENT_OPENSTACK_FG]}"
	local icon_color="${__powerline_colors[ICON_OPENSTACK]}"
	__powerline_retval=(
		"${bg}:${fg}:${icon_color}${POWERLINE_OPENSTACK_ICON-¤}:${text}"
	)
}


#	PWD

__powerline_segment_pwd() {
	local colors
	local short_pwd
	local icon

	__powerline_shorten_dir "$(dirs +0)"
	local short_pwd="${__powerline_retval[0]}"

	if [ "$short_pwd" = "/" ] ; then
		__powerline_split "" "${short_pwd}"
		local parts=("${__powerline_retval[@]}")
	else
		__powerline_split / "${short_pwd}"
		local parts=("${__powerline_retval[@]}")
	fi

	__powerline_retval=()
	icon="${POWERLINE_PWD_ICON-}"
	for part in "${parts[@]}" ; do
		if [ "${part}" = '~' ] ; then
			icon="${POWERLINE_HOME_ICON-~}"
			part=
			colors="${__powerline_colors[SEGMENT_PWD_HOME]}"
		elif [ "${part}" = "" ] ; then
			colors="${__powerline_colors[SEGMENT_PWD_NOPARTS]}"
		else
			colors="${__powerline_colors[SEGMENT_PWD_DEFAULT]}"
		fi
		__powerline_retval+=("$colors:$icon:$part")
		icon=
	done
}


#	PYTHON

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
		__powerline_retval=("${__powerline_colors[SEGMENT_PYTHON_BG]}:${__powerline_colors[SEGMENT_PYTHON_FG]}:${POWERLINE_PYTHON_ICON-}:${text}")
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


#   JOBS

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

	__powerline_retval=("${__powerline_colors[SEGMENT_JOBS_BG]}:${__powerline_colors[SEGMENT_JOBS_FG]}:⚙ $jobsnum")
}


#	STATUS

__powerline_segment_status() {
	local ec=$1

	if [ "$ec" -eq 0 ] ; then
		__powerline_retval=()
		return
	fi

	__powerline_retval=("${__powerline_colors[SEGMENT_STATUS_BG]}:${__powerline_colors[SEGMENT_STATUS_FG]}:${POWERLINE_FAIL_ICON-✘}:$ec")
}


#	T O O L I N G

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
	rvb=$(bc -l <<-EOF
	scale = 20
	if ( $l <= 0.5 ) {
		m2 = $l * (1 + $s)
	} else {
		m2 = $l + $s - $l * $s
	}
	m1 = 2 * $l - m2

	define component(hue) {
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

	if ( $s == 0 ) {
		r = v = b = $l
	} else {
		r = component($h + 1/3)
		v = component($h)
		b = component($h - 1/3)
	}

	# Arrondi à l'entier.
	scale = 0
	255 * r / 1
	255 * v / 1
	255 * b / 1
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


#	C O L O R S
#
# using an associative array to not overload the environment with dozens of variables
declare -A __powerline_colors

__powerline_setup_colors() {

	# dollar
	__powerline_colors[DOLLAR_ERROR_FG]=${ERROR_FG-"1;38;5;161"} # bold red
	__powerline_colors[DOLLAR_FG]="0" # no-color

	# docker
	__powerline_colors[SEGMENT_DOCKER_ALL_STARTED_BG]="48;5;39"  # bleu ciel docker
	__powerline_colors[SEGMENT_DOCKER_NOT_ALL_STARTED_BG]="48;5;53"  # violet, ne pas trop jurer avec status et git.
	__powerline_colors[SEGMENT_DOCKER_FG]="38;5;15"
	__powerline_colors[ICON_DOCKER]="\\[\\e[97m\\]"

	# git
	__powerline_colors[SEGMENT_GIT_MODIF_BRANCH_FG]="38;5;230" # white
	__powerline_colors[SEGMENT_GIT_MODIF_BRANCH_BG]="48;5;124" # red
	__powerline_colors[SEGMENT_GIT_BRANCH_FG]="38;5;0" # black
	__powerline_colors[SEGMENT_GIT_BRANCH_BG]="48;5;148" # green
	__powerline_colors[ICON_GIT]="\\[\\e[38;5;166m\\]" # orange
	__powerline_colors[SEGMENT_GIT_AB_BG]="48;5;240"
	__powerline_colors[SEGMENT_GIT_AB_FG]="38;5;250"

	# kubernetes
	__powerline_colors[SEGMENT_K8S_FG]="38;5;27"
	__powerline_colors[SEGMENT_K8S_BG]="15"

	# maildir
	__powerline_colors[SEGMENT_MAILDIR_BG]="48;5;11"
	__powerline_colors[SEGMENT_MAILDIR_FG]="1;38;5;20"

	# openstack
	__powerline_colors[SEGMENT_OPENSTACK_BG]="48;5;251"
	__powerline_colors[SEGMENT_OPENSTACK_FG]="38;5;236"
	__powerline_colors[ICON_OPENSTACK]="\\[\\e[38;5;160m\\]"

	# pwd
	__powerline_colors[SEGMENT_PWD_HOME]="48;5;31:38;5;15" # white on light blue
	__powerline_colors[SEGMENT_PWD_NOPARTS]="48;5;237:38;5;254" # white on gray
	__powerline_colors[SEGMENT_PWD_DEFAULT]="48;5;237:38;5;250" # white on gray

	# python
	__powerline_colors[SEGMENT_PYTHON_BG]="48;5;25"
	__powerline_colors[SEGMENT_PYTHON_FG]="38;5;220"

	# jobs
	__powerline_colors[SEGMENT_JOBS_BG]="48;5;172"
	__powerline_colors[SEGMENT_JOBS_FG]="38;5;234"

	# status
	__powerline_colors[SEGMENT_STATUS_BG]="48;5;1" # red
	__powerline_colors[SEGMENT_STATUS_FG]="1;38;5;253" # bold white

}


#	F I R E

__powerline_init
