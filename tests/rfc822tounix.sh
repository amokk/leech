. $(dirname $0)/assert.sh

TOOL="../sbin/rfc822tounix"

U1033563600=$($TOOL "Wed, 02 Oct 2002 08:00:00 EST")
U1033570800=$($TOOL "Wed, 02 Oct 2002 08:00:00 -0700")

assert "$U1033563600 -eq 1033563600"
assert "$U1033570800 -eq 1033570800"
