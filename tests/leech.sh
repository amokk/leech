. $(dirname $0)/assert.sh

TOOL="../sbin/leech"

SOURCE="files/rss.xml"
PROCESSED="files/processed.xml"

PWD=$(pwd)
LUNCH="file://$PWD/$PROCESSED"

export CONFIG_DIR=$(dirname $0)/conf
export DOWNLOADS_DIR=$(dirname $0)/dl

. "$CONFIG_DIR"/default

rm -f "$DOWNLOADS_DIR/*"
rm -f "$DOWNLOADS_DIR/.leech.db"
rm -f "$PROCESSED"

echo $LUNCH >"$FOODS"
cat "$SOURCE" | sed -e "s|file://.|file://$PWD|" >"$PROCESSED"

($TOOL)

rm -f "$DOWNLOADS_DIR/*"
rm -f "$PROCESSED"
rm -f "$FOODS"
