
# bench for running same suite in different shells
# ./bench.sh

SUITE=$(dirname $0)/suite.sh

sh $SUITE sh
ksh $SUITE ksh
dash $SUITE dash
bash $SUITE bash
