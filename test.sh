#!/bin/bash

IP=$(gcloud compute forwarding-rules list | grep www-pool | awk '{print $3;}')
FIRSTCURL=$(curl http://$IP 2> /dev/null | sed -e s/.*app-/app-/g -e s/'!$'//g)
FIRSTCURLVALID=$?
SECONDCURL=$(curl http://$IP 2> /dev/null | sed -e s/.*app-/app-/g -e s/'!$'//g)
SECONDCURLVALID=$?

if [ "$FIRSTCURL" == "app-1" ] && [ "$SECONDCURL" == "app-2" ] && [ $FIRSTCURLVALID -eq 0 ] && [ $SECONDCURLVALID -eq 0 ]; then
  echo "[PASS] - we hit $FIRSTCURL and $SECONDCURL consecutively"
elif [ "$FIRSTCURL" == "app-2" ] && [ "$SECONDCURL" == "app-1" ] && [ $FIRSTCURLVALID -eq 0 ] && [ $SECONDCURLVALID -eq 0 ]; then
  echo "[PASS] - we hit $FIRSTCURL and $SECONDCURL consecutively, backwords for what it's worth"
else
  echo "[FAIL] - something went horribly wrong!"
  echo "We hit $FIRSTCURL and $SECONDCURL"
  echo "The returns from curl were $FIRSTCURLVALID and $SECONDCURLVALID"
fi
