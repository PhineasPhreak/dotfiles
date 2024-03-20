#!/bin/bash
# cf. https://gitlab.com/bersace/powerline.bash
# cf. Dernier commit depuis ma modification :
# Oct 06, 2023 "Correction icônes MDI pour Nerd Fonts ≥ 3.0.0" 2778c0b0152dff318f86417b3136690258424d70
#
# invocation sort équivalent à GNU sort --version-sort --check=quiet
if ! printf "4.4.12\n%s" "${BASH_VERSION-0}" | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -c 2>/dev/null ; then
	echo "erreur: powerline.bash requiert bash, en version 4.4.12 ou supérieur." >&2
	return
fi

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
declare -A __powerline_icons
declare -a __powerline_jobs


# Point d'entrée pour exécution dans PROMPT_COMMAND.
__update_ps1() {
	local last_exit_code=${1-$?}
	local segments=()
	local segname

	__powerline_git_status=()

	# Lister les tâches avant toutes sous-commandes.
	mapfile -t __powerline_jobs < <(jobs)

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
	# Option pour affichage sur 1 ligne
	POWERLINE_ONELINE="true"
	if [ "${POWERLINE_ONELINE-}" = true ] && [ "${POWERLINE_DIRECTION-}" != "rtl" ] ; then
		# Prompt with oneline
		__ps1+=""

		__powerline_dollar "$last_exit_code"
		__ps1+="${__powerline_retval[0]}"
	else
		# Prompt with linebreak
		__ps1+="\\n"

		__powerline_dollar "$last_exit_code"
		__ps1+="${__powerline_retval[0]}"
	fi

	PS1="${__ps1}"
}


# I N I T I A L I S A T I O N


__powerline_init() {
	__powerline_colors=()
	__powerline_context=()

	: "${POWERLINE_DIRECTION:=ltr}"
	if [ "${POWERLINE_DIRECTION}" = "rtl" ] ; then
		: "${POWERLINE_STYLE:=align_right}"
	else
		: "${POWERLINE_STYLE:=default}"
	fi

	__powerline_palette
	__powerline_context[palette]="${__powerline_retval[0]}"
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

	# Configure la couleur de la sortie de la commande. Bash affiche PS0
	# juste avant la sortie de la commande.
	color="${__powerline_colors[sortie-commande]}"
	color="${color/#48;/38;}"
	PS0="\e[${color}m${PS0-}"
}


__powerline_autoicons() {
	# Configurer les séparateurs
	local mode
	# Déclaration de la variable "POWERLINE_ICONS" Pour l'utilisation d'un font en particulier nerd-fonts, etc.
    # POWERLINE_ICONS="nerd-fonts"
	mode=${POWERLINE_ICONS-auto}
	__powerline_icons=(
		# Par défaut, les valeurs powerline.
		[architecture]=""
		[docker]=""
		[etckeeper]=""
		[fail]="✘"
		[git]=$'\uE0A0 '  # de la police Powerline
		[git-detached]="@"
		[home]="~"
		[hostname]=""
		[jobs]="⚑"
		[invite]="\\$"
		[k8s]=$'\u2638 '  # de la police Powerline
		[newmail]="M"
		[openstack]="¤"
		[pwd]=""
		[python]=""

		# logos
		[alpine]="/\\\\"
		[apple]="X"
		[arch]="A"
		[centos]="※"
		[debian]="@"
		[elementary]="e"
		[fedora]="f"
		[freebsd]="BSD"
		[gentoo]="G"
		[linux]="linux"
		[linuxmint]="lm"
		[logo-inconnu]="?"
		[manjaro]="M"
		[raspbian]="RPI"
		[redhat]="RH"
		[slackware]=".S"
		[suse]="S"
		[ubuntu]="u"
		[windows]="#"
	)

	if [ "${POWERLINE_DIRECTION}" = "ltr" ] ; then
		__powerline_icons+=(
			[sep]=$'\uE0B0'
			[sep-fin]=$'\uE0B1'
		)
	else
		__powerline_icons+=(
			[sep]=$'\uE0B2'
			[sep-fin]=$'\uE0B3'
		)
	fi

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
			__powerline_icons+=(
				[git]=""
				[k8s]="*"
				[sep]=$'\u25B6'
				[sep-fin]='>'
			)
			;;
		powerline)
			;;
		flat)
			__powerline_icons+=(
				[sep]=""
				[sep-fin]=""
			)
			;;
		icons-in-terminal)
			__powerline_icons+=(
				[architecture]=$'\uE383'    # fa-microchip
				[docker]=$'\uE8EA '
				[etckeeper]=$'\uE025'
				[fail]=$'\uE023 '
				[git]=$'\uEDCE '
				[git-detached]=$'\uF0C1 '
				[home]=$'\uE67D '
				[horloge]=$'\uE0F7 '
				[hostname]=$'\uE4BA '
				[jobs]=$'\ue691 '
				[k8s]=$'\u2638 '
				[newmail]=$'\uE0E4 '
				[openstack]=$'\uE574 '
				[pwd]=$'\uE015 '
				[python]=$'\uEE10 '

				# Logos
				[alpine]=$'\uE9F4'
				[apple]=$'\uE9F2'
				[arch]=$'\uE9D9'
				[centos]=$'\uE9DA'
				[debian]=$'\uE9DB'
				[elementary]=$'\uE9EA'
				[fedora]=$'\uE9DC'
				[freebsd]=$'\uE9E7'
				[gentoo]=$'\uE9E9'
				[logo-inconnu]=$'\uE025'
				[linux]=$'\uE23A'
				[linuxmint]=$'\uE9DD'
				[manjaro]=$'\uE9F1'
				[raspbian]=$'\uE9F0'
				[suse]=$'\uE9E1'
				[slackware]=$'\uE9E3'
				[ubuntu]=$'\uE9E6'
				[redhat]=$'\uE9E2'
				[windows]=$'\uEA16'
			)
			;;
		nerd-fonts)
			# cf. https://www.nerdfonts.com/cheat-sheet
			__powerline_icons+=(
				[architecture]=$'\UF061A'  # nf-md-chip
				[docker]=$'\uF308 '        # nf-linux-docker
				[etckeeper]=$'\uF013 '     # nf-fa-gear
				[fail]=$'\uF071 '          # nf-fa-exclamation_triangle
				[git-detached]=$'\uF06A '  # nf-fa-exclamation_circle
				[git]=$'\uE725 '           # nf-dev-git_branch
				[home]=$'\UF02DC '         # nf-md-home
				[hostname]=$'\uF015 '      # nf-fa-home
				[k8s]=$'\UF0833 '          # nf-md-ship_wheel
				[newmail]=$'\UF06CF'       # nf-md-email_alert
				[openstack]=$'\UF07B6 '    # nf-md-cloud_tags
				[pwd]=$'\uF07B '           # nf-fa-folder
				[python]=$'\uE235 '        # nf-fae-python

				# logos
				[alpine]=$'\uF300'         # nf-linux-alpine
				[apple]=$'\uF302'          # nf-linux-apple
				[arch]=$'\uF303'           # nf-linux-archlinux
				[centos]=$'\uF304'         # nf-linux-centos
				[debian]=$'\uF306'         # nf-linux-debian
				[elementary]=$'\uF309'     # nf-linux-elementary
				[fedora]=$'\uF30A'         # nf-linux-fedora
				[freebsd]=$'\uF30C'        # nf-linux-freebsd
				[gentoo]=$'\uF30D'         # nf-linux-gentoo
				[linux]=$'\uF31A'          # nf-linux-tux
				[linuxmint]=$'\uF30E'      # nf-linux-linuxmint
				[logo-inconnu]=$'\uE795'   # nf-dev-terminal
				[manjaro]=$'\uF312'        # nf-linux-manjaro
				[raspbian]=$'\uF315'       # nf-linux-raspbian
				[redhat]=$'\uF316'         # nf-linux-redhat
				[slackware]=$'\uF318'      # nf-linux-slackware
				[suse]=$'\uF314'           # nf-linux-opensuse
				[ubuntu]=$'\uF31C'         # nf-linux-ubuntu_inverse
				[windows]=$'\uE70F'        # nf-dev-windows

			)
			;;
		*)
			echo "POWERLINE_ICONS=${mode} inconnu." >&2
			;;
	esac

	if [ -n "${!POWERLINE_ICONS_OVERRIDES[*]}" ] ; then
		for k in "${!POWERLINE_ICONS_OVERRIDES[@]}" ; do
			__powerline_icons[$k]="${POWERLINE_ICONS_OVERRIDES[$k]}"
		done
	fi
}


__powerline_autosegments() {
	local class="$1"
	# Détermine les segments pertinent pour l'environnement.
	__powerline_retval=()

	if [ "$class" != "local" ] ; then
		__powerline_retval+=(hostname)
	fi

	if ! uname -m | grep -Eq "(amd64|x86_64)" ; then
		__powerline_retval+=(archi)
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

	__powerline_retval+=(status jobs)
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
		[reset]="0"
		[gras]="1"
		[fade]="2"

		# Nom de couleurs.
		#
		# Attention à définir avec 48; (c'est-à-dire couleur de fond).
		# Le script sait transposer en couleur de texte au besoin.
		#
		# Les 8 couleurs élémentaires.
		#
		[blanc-cassé]="48;5;230"
		[blanc-gras]="1;48;5;15"
		[blanc]="48;5;15"
		[bleu-canard]="48;5;31"
		[bleu-docker]="48;5;39"
		[bleu-kubernetes]="48;5;27"
		[bleu]="48;5;20"
		[bleu]="48;5;4"
		[cyan]="48;5;6"
		[gris-clair0]="48;5;250"
		[gris-clair1]="48;5;251"
		[gris-clair2]="48;5;252"
		[gris-clair3]="48;5;253"
		[gris-clair4]="48;5;254"
		[gris-clair]=gris-clair0
		[gris-foncé0]="48;5;234"
		[gris-foncé1]="48;5;235"
		[gris-foncé2]="48;5;236"
		[gris-foncé3]="48;5;237"
		[gris-foncé4]="48;5;238"
		[gris-foncé5]="48;5;239"
		[gris]="48;5;240"
		[indigo]="48;5;25"
		[jaune-python]="48;5;220"
		[jaune-vif]="48;5;220"
		[jaune]="48;5;11"
		[jaune]="48;5;3"
		[magenta]="48;5;5"
		[noir]="48;5;0"
		[rouge]="48;5;1"
		[vert]="48;5;2"

		# Alias sémantiques
		[archi-fond]=gris-foncé5
		[archi-icone]=noir
		[archi-texte]=jaune

		[heure-fond]=gris-foncé2
		[heure-texte]=gris-clair

		[jobs-fond]=gris-foncé4
		[jobs-texte]=bleu-docker

		[sortie-commande]=reset

		[bleu-alpine]="48;2;11;88;126"
		[logo-alpine-fond]=blanc
		[logo-alpine-texte]=bleu-alpine

		[bleu-apple]="48;2;38;164;246"
		[gris-apple]="48;2;237;240;248"
		[logo-apple-fond]=bleu-apple
		[logo-apple-texte]=gris-apple

		[bleu-arch]="48;2;23;147;209"
		[gris-arch]="48;2;51;51;51"
		[logo-arch-fond]=gris-arch
		[logo-arch-texte]=bleu-arch

		[magenta-centos]="48;2;99;10;99"
		[violet-centos]="48;2;55;15;43"
		[logo-centos-fond]=magenta-centos
		[logo-centos-texte]=blanc

		[rouge-debian]="1;48;2;167;12;52"  # rouge gras
		[logo-debian-fond]=gris-clair4
		[logo-debian-texte]=rouge-debian

		[bleu-elementary]="48;2;69;180;231"
		[logo-elementary-fond]=bleu-elementary
		[logo-elementary-texte]=blanc-gras

		[bleu-fedora]="48;2;11;87;164"
		[noir-fedora]="48;2;7;44;97"
		[logo-fedora-fond]=bleu-fedora
		[logo-fedora-texte]=blanc

		[logo-freebsd-fond]=gris-foncé2
		[logo-freebsd-texte]=rouge-sombre

		[violet-gentoo]="48;2;83;71;120"
		[logo-gentoo-fond]=violet-gentoo
		[logo-gentoo-texte]=gris-clair2

		[logo-inconnu-fond]=blanc
		[logo-inconnu-texte]=noir

		[logo-linux-fond]=jaune-vif
		[logo-linux-texte]=noir

		[vert-manjaro]="48;2;52;190;91"
		[logo-manjaro-fond]=gris-foncé2
		[logo-manjaro-texte]=vert-manjaro

		[vert-mint]="48;2;135;189;74"
		[logo-mint-fond]=vert-mint
		[logo-mint-texte]=blanc

		[rouge-raspbian]="48;2;188;17;66"
		[logo-raspbian-fond]=rouge-raspbian
		[logo-raspbian-texte]=noir

		[logo-redhat-fond]=rouge-sombre
		[logo-redhat-texte]=noir

		[vert-clair-suse]="48;2;53;185;121"
		[vert-foncé-suse]="48;2;13;50;44"
		[logo-suse-fond]=vert-foncé-suse
		[logo-suse-texte]=vert-clair-suse

		[logo-slackware-fond]=gris-foncé2
		[logo-slackware-texte]=blanc

		[orange-ubuntu]="48;2;221;72;20"
		[logo-ubuntu-fond]=orange-ubuntu
		[logo-ubuntu-texte]=blanc

		[bleu-windows]="48;2;0;173;239"
		[logo-windows-fond]=bleu-windows
		[logo-windows-texte]=blanc

		[commande-utilisateur]=gras

		[docker-erreur]=violet
		[docker-succes]=bleu-docker
		[docker-texte]=blanc
		[docker-icone]=blanc

		[dollar-erreur]=rouge
		[dollar-succes]=""

		[etckeeper-propre-fond]=git-propre-fond
		[etckeeper-propre-texte]=git-propre-texte
		[etckeeper-modifications-fond]=git-modifications-fond
		[etckeeper-modifications-texte]=git-modifications-texte

		[git-icone]=orange
		[git-modifications-fond]=rouge-sombre
		[git-modifications-texte]=blanc-cassé
		[git-propre-fond]=vert-fluo
		[git-propre-texte]=noir
		[git-sync-fond]=gris-foncé2
		[git-sync-texte]=gris-clair0

		[k8s-fond]=bleu-kubernetes
		[k8s-texte]=gris-clair4

		[maildir-fond]=jaune
		[maildir-texte]=bleu-gras

		[openstack-fond]=gris-clair1
		[openstack-texte]=gris-foncé2
		[openstack-icone]=rouge

		[pwd-fond]=gris-foncé2
		[pwd-texte]=gris-clair0
		[pwd-home-fond]=turquoise
		[pwd-home-texte]=blanc
		[pwd-sys-fond]=gris-foncé2
		[pwd-sys-texte]=gris-clair4

		[python-fond]=indigo
		[python-texte]=jaune-python
		# Coloration pour les utilisateurs USER/ROOT
		[user-color-bg]="48;5;036"  # USER -> vert
		[user-color-fg]="38;5;235"  # Blanc

		[root-color-bg]="48;5;160"  # ROOT -> rouge
		[root-color-fg]="38;5;015"  # Blanc

		[status-fond]=rouge
		[status-texte]=gris-clair4
	)

	case "${__powerline_context[palette]}" in
		8bit)
			__powerline_colors+=(
				[blanc-cassé]=blanc
				[bleu-gras]=bleu
				[bleu-canard]=bleu
				[bleu-docker]=bleu
				[bleu-kubernetes]=bleu
				[jaune-python]=jaune
				[indigo]=bleu
				[gris-clair]=blanc
				[gris-clair0]=gris-clair
				[gris-clair1]=gris-clair
				[gris-clair2]=gris-clair
				[gris-clair3]=gris-clair
				[gris-clair4]=gris-clair
				[orange]=jaune
				[rouge-sombre]=rouge
				[rose]=magenta
				[vert-fluo]=vert
				[violet]=rose
				[turquoise]=cyan

				[git-modifications-fond]=magenta
			)
			;;
		256color|24bit|truecolor)
			__powerline_colors+=(
				# Nom de couleurs.
				#
				# Attention à définir avec 48; (c'est-à-dire couleur de fond).
				# Le script sait transposer en couleur de texte au besoin.
				[blanc-cassé]="48;5;230"
				[bleu]="48;5;20"
				[bleu-gras]="1;48;5;20"
				[bleu-canard]="48;5;31"
				[bleu-docker]="48;5;39"
				[bleu-kubernetes]="48;5;27"
				[jaune-python]="48;5;220"
				[indigo]="48;5;25"
				[gris-clair]=gris-clair0
				[gris-clair0]="48;5;250"
				[gris-clair1]="48;5;251"
				[gris-clair2]="48;5;252"
				[gris-clair3]="48;5;253"
				[gris-clair4]="48;5;254"
				[orange]="48;5;166"
				[rouge-sombre]="48;5;124"
				[rose]="48;5;161"
				[vert-fluo]="48;5;148"
				[violet]="48;5;53"
				[turquoise]="48;5;31"
			)
			;;

	esac

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
			if [ -z "$color" ] ; then
				continue
			fi
			[ -z "${__powerline_colors[$color]-}" ] && continue
			__powerline_colors[$key]="${__powerline_colors[$color]}"
			loop=1
		done
	done
}


__powerline_resolve_color() {
	local input="$1"
	name="${input#[[:digit:]];}" # Supprimer la graisse
	name="${name##[[:digit:]]*}" # Supprimer un code couleur (commence par un chiffre).
	if [ -z "$name" ] ; then
		__powerline_retval=("$input")
	else
		__powerline_retval=("${input/$name/${__powerline_colors[$name]-badcolor}}")
	fi
}

__powerline_foreground_color() {
	case "$1" in
		'1;'*)
			__powerline_retval=("${1/#1;48;/1;38;}")
			;;
		'2;'*)
			__powerline_retval=("${1/#2;48;/2;38;}")
			;;
		*)
			__powerline_retval=("${1/#48;/38;}")
	esac
}

__powerline_palette() {
	local auto ident
	ident="${COLORTERM:-${OLDTERM:-$TERM}}"
	case "$ident" in
		*256color)
			auto="256color"
			;;

		24bit|truecolor|*-termite|*-direct|*-kitty)
			auto="24bit"
			;;
		*)
			auto="8bit"
			;;
	esac

	__powerline_retval=("${POWERLINE_PALETTE-$auto}")
}


# R E N D U

# A render function is a bash function starting with `__powerline_render_`. It puts
# a PS1 string in `__powerline_retval`.

__powerline_dollar() {
	local color dollar fg
	local last_exit_code=$1
	# Déterminer la couleur du dollar
	if [ "$last_exit_code" -gt 0 ] ; then
		__powerline_foreground_color "${__powerline_colors[dollar-erreur]}"
		fg="1;${__powerline_retval[0]}"
	else
		fg="${__powerline_colors[dollar-succes]}"
	fi
	__powerline_foreground_color "${__powerline_colors[commande-utilisateur]}"
	color="${__powerline_retval[0]}"

	dollar="${__powerline_icons[invite]}"
	# Afficher le dollar sur une nouvelle ligne, pas en mode powerline
	__powerline_retval=("\\[\\e[${fg}m\\]$dollar\\[\\e[0;${color}m\\] ")
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

		__powerline_split ':' "${segment}"
		infos=("${__powerline_retval[@]}")
		icon_fg="${infos[0]}"
		icon="${infos[1]}"
		if [ -n "$icon" ] ; then
			icon="${__powerline_icons[$icon]-¤}"
		fi
		icon="${icon//\\/\\\\}"

		# Recoller les entrées suivantes avec ':'
		printf -v text ":%s" "${infos[@]:4}"
		text=${text:1}
		# Nettoyer le \n ajouté par <<<
		text="${text##[[:space:]]}"
		text="${text%%[[:space:]]}"
		# Sauter les segments vides
		if [ -z "${icon// }${text// }" ]; then
			continue
		fi

		old_bg=${bg-}
		__powerline_resolve_color "${infos[2]%%:}"
		bg="${__powerline_retval[0]}"
		__powerline_resolve_color "${infos[3]%%:}"
		__powerline_foreground_color "${__powerline_retval[0]}"
		fg="${__powerline_retval[0]}"

		icon_fg="${icon_fg:-${fg/#1;}}" # Supprimer la graisse
		icon_fg="${icon_fg/#2;}" # Supprimer la sécheresse
		__powerline_resolve_color "$icon_fg"
		__powerline_foreground_color "${__powerline_retval[0]}"
		icon_fg="${__powerline_retval[0]}"

		# D'abord, afficher le chevron avec la transition de fond.
		if [ -n "${old_bg}" ] ; then
			if [ "$bg" = "$old_bg" ]; then
				# Séparateur léger, même couleurs que le texte.
				separator="${__powerline_icons[sep-fin]-}"
				fgsep="$fg"
				fgsep="${fgsep#1;}" # Supprimer la graisse
				fgsep="${fgsep#2;}" # Supprimer la sècheresse.
				colors="$fgsep;$bg"
			else
				separator="${__powerline_icons[sep]-}"
				__powerline_foreground_color "$old_bg"
				fgsep="${__powerline_retval[0]}"
				fgsep="${fgsep#1;}" # Supprimer la graisse
				fgsep="${fgsep#2;}" # Supprimer la sècheresse.
				colors="$fgsep;$bg"
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
			# Affadir les @.
			if [[ "$text" == *@* ]] ; then
				text="${text//@/\\[\\e[2m\\]@\\[\\e[22m\\]}"
			fi
			ps+=" $text"
		fi
		ps+=" "
	done

	# Afficher le dernier chevron, transition du fond vers rien.
	old_bg=${bg-}
	if [ -n "${old_bg}" ] ; then
		__powerline_foreground_color "$old_bg"
		fgsep="${__powerline_retval[0]}"
		ps+="\\[\\e[0;${fgsep}m\\]${__powerline_icons[sep]-}"
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

		__powerline_split ':' "${segment}"
		infos=("${__powerline_retval[@]}")
		icon_fg="${infos[0]}"
		icon="${infos[1]}"
		if [ -n "$icon" ] ; then
			icon="${__powerline_icons[$icon]-¤}"
		fi
		icon="${icon//\\/\\\\}"

		# Recoller les entrées suivantes avec ':'
		printf -v text ":%s" "${infos[@]:4}"
		text=${text:1}
		# Sauter les segments vides
		if [ -z "${text}" ] && [ -z "$icon" ]; then
			continue
		fi

		old_bg=${bg-}
		__powerline_resolve_color "${infos[2]%%:}"
		bg="${__powerline_retval[0]}"
		__powerline_resolve_color "${infos[3]%%:}"
		__powerline_foreground_color "${__powerline_retval[0]}"
		fg="${__powerline_retval[0]}"

		if [ -n "${icon_fg}" ] ; then
			__powerline_resolve_color "$icon_fg"
			__powerline_foreground_color "${__powerline_retval[0]}"
			icon_fg="${__powerline_retval[0]}"
		else
			icon_fg="${icon_fg:-${fg/#1;}}"
			icon_fg="${fg/#2;}"
		fi

		# D'abord, afficher le chevron avec la transition de fond.
		if [ "$bg" = "$old_bg" ] ; then
			# Séparateur léger, même couleurs que le texte
			separator="${__powerline_icons[sep-fin]}"
			fgsep="${fg#1;}"
			fgsep="${fgsep#2;}"
			colors="$fgsep;$bg"
		else
			separator="${__powerline_icons[sep]}"
			__powerline_foreground_color "$bg"
			fgsep="${__powerline_retval[0]#1;}"
			fgsep="${fgsep#2;}"
			colors="$fgsep;$old_bg"
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
			ps+="${icon_fg}m\\] $icon\\[\\e[${fg}m\\]"
			raw_ps+=" $icon"
		else
			# Pas d'icône, on défini simplement la couleur de
			# texte.
			ps+="${fg}m\\]"
		fi
		if [ -n "${text}" ] ; then
			raw_ps+=" $text"
			# Affadir les @.
			if [[ "$text" == *@* ]] ; then
				text="${text//@/\\[\\e[2m\\]@\\[\\e[0;$fg;${bg}m\\]}"
			fi
			ps+=" $text"
		fi
		ps+=" "
		raw_ps+=" "
	done

	# Mesurer la largueur totale des segments.
	largeur=${#raw_ps}
	printf -v ps "%*s%s\\r%s" $(( COLUMNS - largeur )) "" "$ps" ""

	__powerline_retval=("$ps")
}


# S E G M E N T S

# Un segment est une fonction bash préfixé par `__powerline_segment_`. Le
# retour est un tableau contenant des chaînes au format :
# `<couleur-icône>:<icône>:<couleur-fond>:<couleur-texte>:<texte>`. Chaque
# chaîne correspond à un segment.

__powerline_segment_archi() {
	__powerline_retval=(
		"archi-icone:architecture:archi-fond:archi-texte:${MACHTYPE%%-*}"
	)
}


__powerline_init_logo() {
	local id s

	if [ -v WSLENV ] ; then
		id=windows
	elif [ -f /etc/os-release ] ; then
		# shellcheck source=/dev/null
		. /etc/os-release
		id="$ID"
	elif [ -v OSTYPE ] ; then
		case "$OSTYPE" in
			darwin*)
				id=apple
				;;
			linux*)
				id=linux
				;;
			cygwin|msys|win32)
				id=windows
				;;
			*bsd*)
				id=freebsd
				;;
			*)
				id="$OSTYPE"
				;;

		esac
	fi

	id="${POWERLINE_LOGO_ID-$id}"
	__powerline_context[logo]=$id

	case "$id" in
		alpine)
			printf -v s ":alpine:logo-alpine-fond:logo-alpine-texte:"
			;;
		apple)
			printf -v s ":apple:logo-apple-fond:logo-apple-texte:"
			;;
		arch)
			printf -v s ":arch:logo-arch-fond:logo-arch-texte:"
			;;
		centos)
			printf -v s ":centos:logo-centos-fond:logo-centos-texte:"
			;;
		debian)
			printf -v s ":debian:logo-debian-fond:logo-debian-texte:"
			;;
		elementary)
			printf -v s ":elementary:logo-elementary-fond:logo-elementary-texte:"
			;;
		fedora)
			printf -v s ":fedora:logo-fedora-fond:logo-fedora-texte:"
			;;
		freebsd)
			printf -v s ":freebsd:logo-freebsd-fond:logo-freebsd-texte:"
			;;
		gentoo)
			printf -v s ":gentoo:logo-gentoo-fond:logo-gentoo-texte:"
			;;
		linux)
			printf -v s ':linux:logo-linux-fond:logo-linux-texte:'
			;;
		linuxmint)
			printf -v s ":linuxmint:logo-mint-fond:logo-mint-texte:"
			;;
		manjaro)
			printf -v s ":manjaro:logo-manjaro-fond:logo-manjaro-texte:"
			;;
		*suse*)
			printf -v s ":suse:logo-suse-fond:logo-suse-texte:"
			;;
		slackware)
			printf -v s ":slackware:logo-slackware-fond:logo-slackware-texte:"
			;;
		ubuntu)
			printf -v s ":ubuntu:logo-ubuntu-fond:logo-ubuntu-texte:"
			;;
		raspbian)
			printf -v s ":raspbian:logo-raspbian-fond:logo-raspbian-texte:"
			;;
		redhat)
			printf -v s ":redhat:rouge-sombre:noir:"
			;;
		windows)
			printf -v s ":windows:logo-windows-fond:logo-windows-texte:"
			;;
		*)
			printf -v s ":logo-inconnu:logo-inconnu-fond:logo-inconnu-texte:"
			;;
	esac

	__powerline_context[logo-segment]="$s"
}

__powerline_segment_logo() {
	if [ -z "${__powerline_context[logo-segment]}" ] ; then
		__powerline_init_logo
	fi

	__powerline_retval=(
		"${__powerline_context[logo-segment]-}"
	)
}

__powerline_segment_docker() {
	local bg
	local composefiles
	local dir
	local project
	local service_names
	local service_names_a
	local service_nr
	local started

	__powerline_retval=()

	if [ -v COMPOSE_FILE ] ; then
		__powerline_split ':' "${COMPOSE_FILE}"
		composefiles=("${__powerline_retval[@]}")
	else
		__powerline_find_parent "$PWD" docker-compose.yml
		if [ -z "${__powerline_retval[*]}" ] ; then
			return
		fi
		composefiles=(
			"${__powerline_retval[*]}"
			"${__powerline_retval[*]/.yml/.override.yml}"
		)
	fi

	# Extraire les noms uniques des services. La locale LANG=C est plus rapide pour sort.
	service_names="$(LANG=C.UTF-8 sed --separate '0,/^services:/d;/^[[:alpha:]]/,$d;/^ *#/d;/^   /d;/^$/d' "${composefiles[@]}" 2>/dev/null | sort -u)"
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
	if [ "${#started[@]}" -ge "${service_nr}" ] ; then
		bg=docker-succes
	else
		bg=docker-erreur
	fi

	__powerline_retval=(
		"docker-icone:docker:$bg:docker-texte:${#started[@]}/${service_nr}"
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

	if [ -n "$(sudo -n git -C "${POWERLINE_ETCKEEPER_DIR-/etc/}" status --porcelain=v2 2>/dev/null)" ] ; then
		# le dossier '/etc/' est modifié
		code_couleur=modifications
		status_symbol="*"
	else
		# le dossier '/etc/' n'est pas modifier
		code_couleur=propre
		status_symbol=""
	fi

	__powerline_retval=(
		":etckeeper:etckeeper-${code_couleur}-fond:etckeeper-${code_couleur}-texte:${status_symbol}${text}"
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
	anchor="${__powerline_icons[git-detached]}"

	__powerline_retval=(
		"git-icone:git:$bg:$fg:${detached:+ ${anchor}}${branch}${status_symbol-}"
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
		ab_segment+="⬆"
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
	# Le retour de la fonction : sha, name, upstream, ahead/behind
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


# HEURE

__powerline_segment_heure() {
	__powerline_retval=(
		":horloge:heure-fond:heure-texte:$(date +%H:%M)"
	)
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
		# USER (texte blanc sur fond vert)
		POWERLINE_HOSTNAME_BG="user-color-bg"
		POWERLINE_HOSTNAME_FG="user-color-fg"
	else
		# ROOT (text blanc sur fond rouge)
		POWERLINE_HOSTNAME_BG="root-color-bg"
		POWERLINE_HOSTNAME_FG="root-color-fg"
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
		case "${__powerline_context[palette]}" in
			24bit|truecolor)
				__powerline_hostname_color24 "${__powerline_context[hostname-class]}" "$h"
				__powerline_hsl2rgb "${__powerline_retval[@]}"
				rgb=("${__powerline_retval[@]}")
				bg="48;2;${rgb[0]};${rgb[1]};${rgb[2]}"
				fg=gris-clair3
				;;
			256color*)
				__powerline_hostname_color256 "$h"
				rgb=("${__powerline_retval[@]}")
				__powerline_color256 "${rgb[@]}"
				bg="48;5;${__powerline_retval[0]}"

				# Assurer la lisibilité en déterminant la couleur du texte en fonction de la
				# clareté du fond.
				__powerline_get_foreground "${rgb[@]}"
				fg="38;5;${__powerline_retval[0]}"
				;;
			8bit)
				__powerline_hostname_color8 "${__powerline_context[hostname-class]}"
				bg="${__powerline_retval[0]%:*}"
				fg="${__powerline_retval[0]#*:}"
				;;
		esac
	fi

	__powerline_context[hostname-segment]=":hostname:${bg}:${fg}:${text}"
}

__powerline_hostname_color8() {
	local classe="$1"
	case "$classe" in
		local)
			__powerline_retval=(vert:noir)
			;;
		root)
			__powerline_retval=(rouge:blanc)
			;;
		remote)
			__powerline_retval=(bleu:blanc)
			;;
		container|virtualmachine)
			__powerline_retval=(cyan:noir)
			;;
		*)
			__powerline_retval=(magenta:blanc)
			;;
	esac
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
	elif [ -f /.dockerenv ] ; then
		__powerline_retval=(container)
	elif type -p systemd-detect-virt &>/dev/null && systemd-detect-virt --quiet ; then
		# Systemd
		__powerline_retval=(virtualmachine)
	elif LC_ALL=C lscpu |& grep -iq 'hypervisor vendor' ; then
		# Linux
		__powerline_retval=(virtualmachine)
	elif sysctl kern.vm_guest |& grep -iq kvm ; then
		# FreeBSD
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


# JOBS

__powerline_segment_jobs() {
	__powerline_retval=()

	if [ "${#__powerline_jobs[@]}" -eq "0" ] ; then
		__powerline_retval=()
		return
	fi

	__powerline_retval=(":jobs:jobs-fond:jobs-texte:${#__powerline_jobs[@]}")
}

# KUBERNETES

__powerline_segment_k8s() {
	local contexte namespace texte
	local format='{..current-context}|{..namespace}'
	local config="${KUBECONFIG-$HOME/.kube/config}"

	__powerline_retval=()

	# Arrêt rapide si pas de fichier de configuration.
	if ! [ -f "$config" ] ; then
		return
	fi

	# Arrêt rapide si pas de contexte configuré.
	if ! grep -Fq current-context "$config" ; then
		return
	fi

	texte="$(kubectl config view --minify --output "jsonpath=$format" 2>/dev/null)"
	if [ -z "$texte" ] ; then
		return
	fi
	contexte="${texte%%|*}"
	namespace="${texte##*|}"

	__powerline_retval=(
		":k8s:k8s-fond:k8s-texte:$contexte"
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
		":newmail:maildir-fond:maildir-texte:${count}"
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
		"openstack-icone:openstack:openstack-fond:openstack-texte:${text}"
	)
}


# PWD

__powerline_segment_pwd() {
	local colors
	local short_pwd
	local icon

	"__powerline_shorten_dir_${POWERLINE_PWD_SHORTENING-initiale}" "$PWD"
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
	for i in "${!parts[@]}" ; do
		part="${parts[$i]}"
		if [ "$((i+1))" -eq "${#parts[@]}" ] ; then
			graisse=1
		else
			graisse=2
		fi

		if [ "${part}" = '~' ] ; then
			icon="home"
			part=
			colors="pwd-home-fond:pwd-home-texte"
		elif [ "${part}" = "" ] ; then
			icon="pwd"
			# Command original from gitlab.
			# colors="pwd-sys-fond:pwd-sys-texte"

			# Coloration suivant si le terminal a les droits Administrateur (root/user).
			if [ $UID -ne 0 ]; then
				# USER (texte blanc sur fond vert)
				colors="user-color-bg:pwd-home-texte"
			else
				# ROOT (text blanc sur fond rouge)
				colors="root-color-bg:pwd-home-texte"
			fi
		else
			icon=
			colors="pwd-fond:$graisse;pwd-texte"
		fi
		__powerline_retval+=(":$icon:$colors:$part")
	done
}


# PYTHON

__powerline_segment_python() {
	local text

	if [ -v VIRTUAL_ENV ] ; then
		# Lire le nom du venv dans le prompt. (pour les .venv/bin/activate)
		if ! text="$(grep -m 1 -Po 'PS1="\(\K[^)]+' "$VIRTUAL_ENV/bin/activate" 2>/dev/null)" ; then
			# ou utiliser le dossier
				text=${VIRTUAL_ENV##*/}
		fi
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
			":python:python-fond:python-texte:${text}")
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


# STATUS

__powerline_segment_status() {
	local ec=$1

	if [ "$ec" -eq 0 ] ; then
		__powerline_retval=()
		return
	fi

	__powerline_retval=(
		":fail:status-fond:status-texte:$ec"
	)
}


# T O O L I N G

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
__powerline_shorten_dir_initiale() {
	local short_pwd=
	local dir="$1"

	dir="${dir/$HOME/'~'}"  # Abbréger home avec ~

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

	for i in "${!dir_parts[@]}"; do
		if ! [ '~' = "${dir_parts[$i]}" ] ; then
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

	__powerline_retval=("$short_pwd")
}

__powerline_shorten_dir_ellipse() {
	local short_pwd=
	local dir="$1"

	dir="${dir/$HOME/'~'}"  # Abbréger home avec ~

	__powerline_split / "${dir##/}"
	dir_parts=("${__powerline_retval[@]}")
	local number_of_parts=${#dir_parts[@]}

	# Ne pas abbréger les chemins de moins de 5 segments
	if [[ "$number_of_parts" -lt "5" ]]; then
		__powerline_retval=("${dir}")
		return
	fi
	# Laisser les deux derniers dossiers.
	local last_index="$(( number_of_parts - 2 ))"

	for part in "${dir_parts[@]:0:2}" $'\u2026' "${dir_parts[@]:$last_index}"; do
		if ! [ '~' = "$part" ] ; then
			short_pwd+=/
		fi

		short_pwd+="$part"
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


# F I R E

__powerline_init
