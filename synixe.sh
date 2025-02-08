#!/bin/bash

NAME=""
MODS_LOCATION=""

update() {
    rsync -ur -av --delete-after --progress -e "ssh -p 62" download@arma.synixe.contractors:/ $MODS_LOCATION
    echo "Mods Updated"
}

launch() {
    # Get all folders starting with '@' in the specified directory
    mod_folders=$(find "$MODS_LOCATION" -maxdepth 1 -type d -name '@*')

    # Check if there are any mod folders
    if [ -z "$mod_folders" ]; then
        echo "No mod folders found starting with '@' in $MODS_LOCATION."
        exit 1
    fi

    if [ -z "$NAME" ]; then 
        echo "NAME is not set"
        exit 1
    fi

    # Construct the mod arguments for Steam
    mod_args=""
    for folder in $mod_folders; do
        mod_args+="-mod=\"$(realpath "$folder")\" "
    done

    # Launch Arma 3 via Steam with the mod arguments
    echo "Launching Arma 3"
    steam -applaunch 107410 -nolauncher -name="$NAME" -skipIntro -noSplash -noPause $mod_args
}

if [ -z "$MODS_LOCATION" ]; then 
    echo "MODS_LOCATION is not set"
    exit 1
fi

case $1 in
    update)
        update
        ;;
    launch)
        update
        launch
        ;;
    *)
        echo "Usage: $0 {update|launch}"
        exit 1
        ;;
esac
