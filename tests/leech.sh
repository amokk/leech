. $(dirname $0)/assert.sh

TOOL="../sbin/leech"

SOURCE="files/rss.xml"
PROCESSED="files/processed.xml"

PWD=$(pwd)
LUNCH="file://$PWD/$PROCESSED"

export CONFIG_DIR=$(dirname $0)/conf
export DOWNLOADS_DIR=$(dirname $0)/dl

. "$CONFIG_DIR"/default

rm -f "$DOWNLOADS_DIR"/*
rm -f "$DOWNLOADS_DIR"/.leech.db
rm -f "$PROCESSED"
rm -f "$FOODS"

echo $LUNCH >"$FOODS"
cat "$SOURCE" | sed -e "s|file://.|file://$PWD|" >"$PROCESSED"

($TOOL >/dev/null)

EXPIRED=expired.txt
SAMPLE_SUP=sample1.txt
SAMPLE_MKV=sample2.mkv
CRAP=crap.wmv

assert "! -f "$DOWNLOADS_DIR/$EXPIRED""  # expired record shouldn't be downloaded
assert "! -f "$DOWNLOADS_DIR/$CRAP""  # no crap
assert "-f "$DOWNLOADS_DIR/$SAMPLE_SUP""  # matches [sup]
assert "-f "$DOWNLOADS_DIR/$SAMPLE_MKV""  # matches *.mkv

rm -f "$DOWNLOADS_DIR/$SAMPLE_SUP"
rm -f "$DOWNLOADS_DIR/$SAMPLE_MKV"
rm -f "$DOWNLOADS_DIR/.leech.db"
rm -f "$PROCESSED"
rm -f "$FOODS"

DL_CONTENT=$(ls -a "$DOWNLOADS_DIR" | wc -l)
assert "$DL_CONTENT -eq 2"  # check that DL dir is empty after cleanup (nothing else was downloaded)