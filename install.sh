#!/usr/bin/env zsh

(( ${+PREFIX} )) || local PREFIX=/usr/local/bin

if which -s update-licenses &> /dev/null; then
    echo "update-licenses already installed. Exiting."
else
    chmod +x "$PWD/update-licenses.sh" &&
        ln -s "$PWD/update-licenses.sh" "$PREFIX/update-licenses" &&
        echo "Success! Installed to $PREFIX/update-licenses"
fi
