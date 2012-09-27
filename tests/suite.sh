
TESTS="$(dirname $0)/rfc822tounix.sh\
    $(dirname $0)/leech.sh"

run_test()
{
    ($1)
    RET=$?

    echo -n "$SHELL:$1: "
    case $RET in
        0)
            echo "OK"
            ;;

        *)
            ;;
    esac
}

SHELL=$1

for CASE in $TESTS; do
    run_test "$CASE"
done
