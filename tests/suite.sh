
# suite for running different tests
# suite.sh <SHELL>

TESTS="$(dirname $0)/rfc822tounix.sh\
    $(dirname $0)/leech.sh"

run_test()
{
    ($1)  # note that this modification of assert will print dot after each successful check
    RET=$?

    echo -n "$SHELL:$1: "  # after test finished, print shell and test name
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
