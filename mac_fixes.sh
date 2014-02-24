#!/bin/bash

if [ "root" != "`whoami`" ]; then
  echo "Please run this script as root (or using sudo)"
  exit 1
fi

# /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin always gets moved to the top of the PATH variable
# This ruins the functionality of a lot of things.
# For example, rbenv breaks inside of tmux because of it.
#
# This fixes it using method outlined in:
# - https://github.com/sstephenson/rbenv/issues/369#issuecomment-22200587
# - http://www.softec.lu/site/DevelopersCorner/MasteringThePathHelper
for file in `grep -rIl 'eval.*path_helper' /etc/*`; do
  if ! grep 'PATH=""' $file > /dev/null; then
    echo "Modifying $file"
    sed -i '' '/eval.*path_helper/i\
    \	PATH=""
    ' $file
  fi
done
