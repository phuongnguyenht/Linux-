#!/bin/bash

voice01=10.84.5.170
voice02=10.84.5.171
return_code=1 # fail

# check remote instance fist
timeout 2 sipsak -s sip:$voice01:5060
exit_status=$?
if [[ $exit_status -eq 0 ]]; then
  echo "sip ping successful to voice01 [$voice01]"
  exit $return_code
fi

# remote instance failed, check local
timeout 2 sipsak -s sip:$voice02:5060
exit_status=$?
if [[ $exit_status -eq 0 ]]; then
  echo "sip ping successful to voice02 [$voice02]"
  return_code=0
fi

echo "return code [$return_code]"

exit $return_code