#!/usr/bin/env bash

# parse overall device configuration
device() {
    local OUTPUT
    local PROPERTY
    local VALUE

    PROPERTY=$(cut -d "=" -f 1 <<< "$*")
    VALUE=$(cut -d "=" -f 2 <<< "$*")

    case $PROPERTY in
        "name")
            OUTPUT+="--name \"$VALUE\""
            ;;

        "vendorid")
            OUTPUT+="--vendor $VALUE"
            ;;

        "productid")
            OUTPUT+="--product $VALUE"
            ;;

        "grab")
            [[ $VALUE == "yes" ]] && OUTPUT+="--grab"
            ;;

        "ffbgain")
            OUTPUT+="--gain $VALUE"
            ;;

        "ffbautocenter")
            OUTPUT+="--autocenter $VALUE"
            ;;
    esac

    # add space, newline and tab if OUTPUT is not empty
    [[ $OUTPUT != "" ]] && OUTPUT=' \\\n\t'"$OUTPUT"
    echo -e "$OUTPUT"
}

# parse device's axes configuration
axes() {
    local OUTPUT
    local PROPERTY
    local VALUE

    PROPERTY=$(cut -d "=" -f 1 <<< "$1")
    VALUE=$(cut -d "=" -f 2 <<< "$1")

    case $PROPERTY in
        "autoaxes")
            [[ ${VALUE,,} == "no" ]] && OUTPUT+="--no-auto-axes"
            [[ $VALUE =~ [0-9]+ ]] && OUTPUT+="--axes $VALUE"
            ;;

        *)
            OUTPUT+="-a ${PROPERTY^^}"
            [[ ${VALUE,,} != "none" ]] && OUTPUT+=" -s ${VALUE^^}"
            [[ $2 == "invert" ]] && OUTPUT+=" --invert"
            ;;
    esac

    # add space, newline and tab if OUTPUT is not empty
    [[ $OUTPUT != "" ]] && OUTPUT=' \\\n\t'"$OUTPUT"
    echo -e "$OUTPUT"
}

# parse device's buttons configuration
buttons() {
    local OUTPUT
    local PROPERTY
    local VALUE

    PROPERTY=$(cut -d "=" -f 1 <<< "$1")
    VALUE=$(cut -d "=" -f 2 <<< "$1")

    case $PROPERTY in
        "autobuttons")
            [[ ${VALUE,,} == "no" ]] && OUTPUT+="--no-auto-buttons"
            [[ $VALUE =~ [0-9]+ ]] && OUTPUT+="--buttons $VALUE"
            ;;

        *)
            OUTPUT+="-b ${PROPERTY^^}"
            [[ ${VALUE,,} != "none" ]] && OUTPUT+=" -s ${VALUE^^}"
            [[ $2 == "invert" ]] && OUTPUT+=" --invert"
            ;;
    esac

    # add space, newline and tab if OUTPUT is not empty
    [[ $OUTPUT != "" ]] && OUTPUT=' \\\n\t'"$OUTPUT"
    echo -e "$OUTPUT"
}

# =============================================================================

echo ""
echo "Creating scripts for protopedal"
echo ""

# list device files in device-database
DEVICES=$(echo device-database/*)
SCRIPTS_DIR=scripts

mkdir "$SCRIPTS_DIR"

for DEVICE in $DEVICES; do
    SCRIPT_CONTENT=$(cat templates/script-template.sh)
    SCRIPT_NAME="protopedal-<device>.sh"
    SHORTNAME=""
    DECIDE=""

    echo "Creating script for $DEVICE"

    while read -r LINE; do
        case $LINE in
            "[device]")
                DECIDE="device"
                ;;

            "[axes]")
                DECIDE="axes"
                ;;

            "[buttons]")
                DECIDE="buttons"
                ;;

            *)
                [[ ${LINE,,} =~ ^shortname ]] && SHORTNAME=$(cut -d "=" -f 2 <<< "${LINE,,}")
                [[ $DECIDE == "" ]] && continue
                [[ $LINE == "" ]] && continue
                SCRIPT_CONTENT+=$(eval $DECIDE "$LINE")
                ;;
        esac
    done < "$DEVICE"

    SHORTNAME=$(tr ' ' '-' <<< "$SHORTNAME")
    SCRIPT_NAME=$(sed "s/<device>/$SHORTNAME/g" <<< "$SCRIPT_NAME")

    echo "$SCRIPT_CONTENT" > "$SCRIPTS_DIR/$SCRIPT_NAME"
    chmod 755 "$SCRIPTS_DIR/$SCRIPT_NAME"
done

echo ""
echo "Done creating scripts for protopedal"
