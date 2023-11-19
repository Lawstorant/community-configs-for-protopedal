#!/usr/bin/env bash

echo ""
echo "Creating udev rules for protopedal"
echo ""

# list device files in device-database
DEVICES=$(echo device-database/*)
RULES_DIR=rules
INPUT_GROUP="$1"

mkdir "$RULES_DIR"

for DEVICE in $DEVICES; do
    RULE_CONTENT=$(cat templates/udev-rule-template.rule)
    RULE_NAME="99-protopedal-<device>.rule"
    SHORTNAME=""
    VENDOR=""
    PRODUCT=""

    echo "Creating rule for $DEVICE"

    while read -r LINE; do
        PROPERTY=$(cut -d "=" -f 1 <<< "$LINE")
        VALUE=$(cut -d "=" -f 2 <<< "$LINE")

        case $PROPERTY in
            shortname)
                SHORTNAME="$VALUE"
                ;;

            vendorid)
                VENDOR="$VALUE"
                ;;

            productid)
                PRODUCT="$VALUE"
                ;;
        esac
    done < "$DEVICE"

    RULE_CONTENT=$(sed "s/<device>/$SHORTNAME/g" <<< "$RULE_CONTENT")
    RULE_CONTENT=$(sed "s/<vendor>/$VENDOR/g" <<< "$RULE_CONTENT")
    RULE_CONTENT=$(sed "s/<product>/$PRODUCT/g" <<< "$RULE_CONTENT")
    RULE_CONTENT=$(sed "s/<input-group>/$INPUT_GROUP/g" <<< "$RULE_CONTENT")

    RULE_NAME=$(sed "s/<device>/$SHORTNAME/g" <<< "$RULE_NAME")

    echo "$RULE_CONTENT" > "$RULES_DIR/$RULE_NAME"
done

echo ""
echo "Done creating udev rules for protopedal"