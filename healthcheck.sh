#!/bin/sh

if ([ -z `pidof -s mega-cmd-server` ]); then
echo -e "MegaCMD server is not running"
exit 1

else
exit 0

fi
