#!/usr/bin/env bash

shopt -s nullglob

READ_DIR="$HOME/Documents/Books"

LIBRARIES=( "$READ_DIR" )

for dir in "$READ_DIR"/*; do
    if [[ -d "$dir" ]]; then
        LIBRARIES+=( "$dir" )
    fi
done

if [ "$@" ]
then
    zathura "$ROFI_INFO" &> /dev/null &
else
    echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>read</span>\n"
    echo -en "\x00markup-rows\x1ftrue\n"

    for LIBRARY in "${LIBRARIES[@]}"; do
        if [[ -d "$LIBRARY" ]]; then
            LIB_NAME="$(basename "$LIBRARY")"
            for FILE in "$LIBRARY"/*.{pdf,epub,djvu}; do
                printf "<b>%s/</b>$(basename "$FILE")\x00info\x1f%s\n" "$LIB_NAME" "$FILE"
            done
        fi
    done
fi

