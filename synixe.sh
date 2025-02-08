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

    # Construct the mod arguments for Steam, relative to ARMA_LOCATION
    mod_args=""
    for folder in $mod_folders; do
        mod_args+="-mod=\"Z:$(realpath "$folder")\" "
    done

    join_args=""
    if [ -n "$SERVER" ]; then
        join_args+="-connect=\"$SERVER\" "
    fi
    if [ -n "$PASSWORD" ]; then
        join_args+="-password=\"$PASSWORD\" "
    fi
    if [ -n "$PORT" ]; then
        join_args+="-port=\"$PORT\" "
    fi

    # Launch Arma 3 via Steam with the mod arguments
    echo "Launching Arma 3"
    steam -applaunch 107410 -nolauncher -name="$NAME" -skipIntro -noSplash -noPause $mod_args $join_args
}
if [ -z "$MODS_LOCATION" ]; then 
    echo "MODS_LOCATION is not set"
    exit 1
fi

case $1 in
    update)
        update
        exit 0
        ;;
    contracts)
        SERVER="arma.synixe.contractors"
        PORT="2302"
        PASSWORD="literallyjusthitspacebar" 
        ;;
    training)
        SERVER="arma.synixe.contractors"
        PORT="2602"
        PASSWORD="equals"
        ;;
    launch)
        ;;
    *)
        echo "Usage: $0 {update|launch|training|contracts}"
        exit 1
        ;;
esac

update
launch
