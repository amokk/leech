. $(dirname $0)/assert.sh

HERE=$(cd "$(dirname "$0")" && pwd)  # current dir
TOOL="$HERE/../sbin/leech"

SOURCE="$HERE/files/rss.xml"
PROCESSED="$HERE/files/processed.xml"

LUNCH="file://$PROCESSED"  # file/processed.xml

export CONFIG_DIR="$HERE/conf"
export DOWNLOADS_DIR="$HERE/dl"

. "$CONFIG_DIR"/default

rm -f "$DOWNLOADS_DIR"/*
rm -f "$DOWNLOADS_DIR"/.leech.db
rm -f "$PROCESSED"
rm -f "$FOODS"

echo $LUNCH >"$FOODS"  # put processed XML into foods
cat "$SOURCE" | sed -e "s|file://.|file://$HERE|" >"$PROCESSED"  # replace file://./files with absolute paths for cURL

($TOOL >/dev/null)

EXPIRED=expired.txt
SAMPLE_SUP=sample1.txt
SAMPLE_MKV=sample2.mkv
CRAP=crap.wmv

assert "! -f "$DOWNLOADS_DIR/$EXPIRED""  # expired record shouldn't be downloaded
assert "! -f "$DOWNLOADS_DIR/$CRAP""  # no crap
assert "-f "$DOWNLOADS_DIR/$SAMPLE_SUP""  # matches [sup]
assert "-f "$DOWNLOADS_DIR/$SAMPLE_MKV""  # matches *.mkv

# cleanup
rm -f "$DOWNLOADS_DIR/$SAMPLE_SUP"
rm -f "$DOWNLOADS_DIR/$SAMPLE_MKV"
rm -f "$DOWNLOADS_DIR/.leech.db"
rm -f "$PROCESSED"
rm -f "$FOODS"

DL_CONTENT=$(ls -a "$DOWNLOADS_DIR" | wc -l)
assert "$DL_CONTENT -eq 2"  # check that DL dir is empty after cleanup (nothing else was downloaded)