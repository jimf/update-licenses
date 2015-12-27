#!/usr/bin/env zsh

local prog="${0##*/}"
(( ${+SEARCH} )) || local SEARCH="$HOME/git"
(( ${+YEAR} )) || local YEAR=$(date +"%Y")

main() {
    setopt localoptions nonomatch

    echo "$prog: Find license files and extend copyright to given year"
    echo
    echo -n "  Search: "
    echo -e "\e[1;35m$SEARCH\e[1;00m"
    echo -n "    Year: "
    echo -e "\e[1;35m$YEAR\e[1;00m"
    echo
    echo -n "Continue? ([Y]/n): "
    read REPLY
    [[ "$REPLY:l" == n* ]] && exit

    echo

    if [ -z "$GITHUB_USER" ]; then
        echo -n "GitHub username: "
        read GITHUB_USER
        echo
    fi

    # Loop through git projects
    for d in "$SEARCH"/*(/); do
        # Skip non-npm repos
        [ -e "$d/package.json" ] || continue

        local gitdir="$d/.git"

        # Skip non-github/jimf repos
        local origin=$(git --git-dir="$gitdir" config --get "remote.origin.url")
        [[ "$origin" == *github.com/"$GITHUB_USER"* ]] || continue

        # Skip forks
        local upstream=$(git --git-dir="$gitdir" config --get "remote.upstream.url")
        [ -z "$upstream" ] || continue

        # Skip repos that aren't on master
        local branch=$(git --git-dir="$gitdir" rev-parse --abbrev-ref HEAD)
        if [[ $branch != master ]]; then
            echo -e "\e[0;33mSkipping $d -- not on master!\e[1;00m"
            continue
        fi

        targets=($d/LICENSE* $d/README*)
        if [[ "${#targets}" == 0 ]]; then
            echo skip
            continue;
        fi

        for f in $targets; do
            [ -e "$f" ] || continue
            perl -pi -e 's/^(Copyright.* \d{4})(-\d{4})?+/$1-'$YEAR'/' $f
        done

        if git --git-dir="$gitdir" diff | egrep -q 'Copyright'; then
            echo -e "\e[0;36mUpdated license: $d\e[1;00m"
        fi
    done
}

main
