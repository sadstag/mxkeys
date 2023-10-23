#!/bin/sh

RULES=/usr/share/X11/xkb/rules
EVDEV="$RULES/evdev.xml"

NAME="macintosh_vndr/frmxkeys"

LAYOUTLIST="/xkbConfigRegistry/layoutList"
LAYOUT="$LAYOUTLIST/layout[last()]"
CONFIGITEM="$LAYOUT/configItem"
LANGUAGELIST="$CONFIGITEM/languageList"

sudo cp frmxkeys /usr/share/X11/xkb/symbols/macintosh_vndr

READNAME=$(xmlstarlet sel --template --value-of "$CONFIGITEM/name" "$EVDEV")

if [ "$READNAME" = "$NAME" ]; then
    echo "Skipping evdev.xml modification (layout exists)"
else
    sudo chmod -R 777 $RULES # or cannot write hereafter
    sudo xmlstarlet ed --pf --ps \
        --subnode "$LAYOUTLIST" --type elem -n layout --value ""\
        --subnode "$LAYOUT" --type elem -n configItem --value ""\
        --subnode "$CONFIGITEM" --type elem -n name --value "$NAME"\
        --subnode "$CONFIGITEM" --type elem -n shortDescription --value "fr mac mx-keys"\
        --subnode "$CONFIGITEM" --type elem -n description --value "French (Macintosh, logiteck mx-keys)"\
        --subnode "$CONFIGITEM" --type elem -n languageList --value ""\
        --subnode "$LANGUAGELIST" --type elem -n iso639Id --value "fra"\
        "$EVDEV"\
    > ./evdev.xml.tmp
    sudo cp ./evdev.xml.tmp "$EVDEV"
    rm evdev.xml.tmp
fi
