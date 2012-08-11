#!/bin/sh
# (c) http://www.linuxtopia.org/online_books/advanced_bash_scripting_guide/debugging.html

assert ()                 #  If condition false,
{                         #+ exit from script with error message.
  E_ASSERT_FAILED=99

  if [ ! $1 ]
  then
    echo "Assertion failed: \"$1\""
    echo "File \"$0\""
    exit $E_ASSERT_FAILED
  fi
}
