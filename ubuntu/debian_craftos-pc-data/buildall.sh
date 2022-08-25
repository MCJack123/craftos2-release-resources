#!/bin/zsh
find . -type f -not -path "./debian/*" -not -path "./.git*" -not -path ./README.md -not -path ./.pc | sed 's/^.\///g' | awk 'BEGIN {print "#!/usr/bin/env dh-exec"}; {print $1 " => /usr/share/craftos/" $1}' > debian/install
VERSION=`grep -o "[0-9\.~\+]*-[0-9][0-9]*" debian/changelog | head -n 1 | sed 's/-.*//'`
DEBVER=`grep -o "[0-9\.~\+]*-[0-9][0-9]*" debian/changelog | head -n 1 | sed 's/^.*-[^0-9]*//'`
debuild -S -d
dput -U ppa:jackmacwindows/ppa ../craftos-pc-data_${VERSION}-${DEBVER}_source.changes
