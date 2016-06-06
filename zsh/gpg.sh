export GPG_TTY=$(tty)

gpg_agent_info_file="${HOME}/.gpg-agent-info"

function gpg_agent_exists {
    command -v gpg-agent >/dev/null 2>&1
}

function gpg_info_file_exists {
    [[ -f "$gpg_agent_info_file" ]]
}

function gpg_agent_vars {
    [[ -n "$GPG_AGENT_INFO" ]] && [[ -n "$SSH_AUTH_SOCK" ]] && [[ -n "$SSH_AGENT_PID" ]];
}

function gpg_agent_running {
    [[ -n "$SSH_AGENT_PID" ]] && ps "$SSH_AGENT_PID";
}

function gpg_agent_export_vars {
    . "$gpg_agent_info_file"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
}

function gpg_agent_run {
    gpg-agent --daemon --enable-ssh-support --write-env-file "$gpg_agent_info_file"
    gpg_agent_export_vars
}

if gpg_agent_exists; then
    if ! gpg_info_file_exists || ! gpg_agent_running; then
        gpg_agent_run;
    elif ! gpg_agent_vars; then
        gpg_agent_export_vars;
    fi
else
    echo "Install gpg-agent!"
fi
