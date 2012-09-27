. $(dirname $0)/assert.sh

TOOL="$(dirname $0)/../sbin/rfc822tounix"

U1033545600=$($TOOL "Wed, 02 Oct 2002 08:00:00 +0000")
U1033545600UT=$($TOOL "Wed, 02 Oct 2002 08:00:00 UT")
U1033545600UTC=$($TOOL "Wed, 02 Oct 2002 08:00:00 UTC")
U1033545600GMT=$($TOOL "Wed, 02 Oct 2002 08:00:00 GMT")
U1033563600=$($TOOL "Wed, 02 Oct 2002 08:00:00 EST")
U1033570800=$($TOOL "Wed, 02 Oct 2002 08:00:00 -0700")
U1980316800=$($TOOL "Wed, 02 Oct 2032 08:00:00 +0000")
# here is year 2038 problem, what the hell, i need to update this around Dec 2037
#U7660512000=$($TOOL "Wed, 02 Oct 2212 08:00:00 +0000")

assert "$U1033545600 -eq 1033545600"
assert "$U1033545600UT -eq 1033545600"
assert "$U1033545600UTC -eq 1033545600"
assert "$U1033545600GMT -eq 1033545600"
assert "$U1033563600 -eq 1033563600"
assert "$U1033570800 -eq 1033570800"
assert "$U1980316800 -eq 1980316800"