
# bench for running same suite in different shells
# ./bench.sh

SUITE=$(dirname $0)/suite.sh

sh $SUITE sh
ash $SUITE ash
ksh $SUITE ksh
dash $SUITE dash
bash $SUITE bash
