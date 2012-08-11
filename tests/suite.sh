
TESTS=$(dirname $0)/rfc822tounix.sh \

run_test()
{
    TEST=$1

    ($TEST)
    RET=$?

    echo -n "$SHELL:$TEST: "
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
