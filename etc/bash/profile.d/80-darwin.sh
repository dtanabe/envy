# shellcheck shell=bash

update_terminal_cwd ()
{
    local url_path='';
    {
        local i ch hexch LC_CTYPE=C LC_COLLATE=C LC_ALL='' LANG='';
        for ((i = 0; i < ${#PWD}; ++i))
        do
            ch="${PWD:i:1}";
            if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
                url_path+="$ch";
            else
                printf -v hexch "%02X" "'$ch";
                url_path+="%${hexch: -2:2}";
            fi;
        done
    };
    printf '\e]7;%s\a' "file://$HOSTNAME$url_path"
}
