. $(dirname $0)/assert.sh

file_md5() {
    FILENAME=$1
    echo "$(expr substr "$(md5sum $FILENAME)" 1 32)"
}

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

SAMPLE_SUP="$HERE/files/sample1.txt"
SAMPLE_MKV="$HERE/files/sample2.mkv"
MD5S="$(file_md5 "$SAMPLE_SUP") $(file_md5 "$SAMPLE_MKV")"

# expired record shouldn't be downloaded
# crap record shouldn't be downloaded
# only two records: SAMPLE_SUP and SAMPLE_MKV
#
assert "$(ls $DOWNLOADS_DIR | grep ".torrent" | wc -l) -eq 2"

# each downloaded file md5sum should be present in $MD5S string
#
ls $DOWNLOADS_DIR | grep ".torrent" | while read FILENAME; do
    FILENAME="$DOWNLOADS_DIR/$FILENAME"
    FILENAME_MD5=$(file_md5 "$FILENAME")
    assert ""$(echo $MD5S | grep $FILENAME_MD5)" == $MD5S"
done

# cleanup
rm -f "$DOWNLOADS_DIR/*"
rm -f "$DOWNLOADS_DIR/.leech.db"
rm -f "$PROCESSED"
rm -f "$FOODS"
