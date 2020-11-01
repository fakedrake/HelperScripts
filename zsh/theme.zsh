# This is a full blown oh-my-zsh theme but insetad of forking the
# whole project for these minor little things, just source this.


function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

function host_color {
    case $(hostname) in
	'purple' | 'ashmore') echo 'magenta';;
	'red' |  'tuvalu' | 'marxistutopia') echo 'red';;
	'yellow' | 'futuna') echo 'yellow';;
	'cyan') echo 'cyan';;
	'gray') echo 'grey';;
	'white') echo 'white';;
	'astaroth') echo 'white';;
	*) echo 'green';;
    esac
}

function name_color {
    echo 'green'
}

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[$(name_color)]%}%n@)%{$fg_bold[$(host_color)]%}%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)%_$(prompt_char)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "
