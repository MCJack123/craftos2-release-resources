#!/bin/zsh
RELEASES=(focal jammy kinetic lunar)
VERSION=`grep -o "[0-9\.~\+]*-${RELEASES[1]}[0-9][0-9]*" debian/changelog | head -n 1 | sed 's/-.*//'`
DEBVER=`grep -o "[0-9\.~\+]*-${RELEASES[1]}[0-9][0-9]*" debian/changelog | head -n 1 | sed 's/^.*-[^0-9]*//'`
echo Building and uploading CraftOS-PC Accelerated v`echo $VERSION | sed "s/${RELEASES[1]}//"`...
for i in $(seq 1 $((${#RELEASES[@]}))); do
    echo Building package for ${RELEASES[$i]}...
    if [ $i -gt 1 ]; then
        sed "s/${RELEASES[$i-1]}/${RELEASES[$i]}/g" debian/changelog > debian/changelog.tmp
        mv debian/changelog.tmp debian/changelog
        VERSION=`echo $VERSION | sed "s/${RELEASES[$i-1]}/${RELEASES[$i]}/"`
    fi
    debuild -S -d
    dput -U ppa:jackmacwindows/ppa ../craftos-pc-accelerated_${VERSION}-${RELEASES[$i]}${DEBVER}_source.changes
done
sed "s/${RELEASES[$((${#RELEASES[@]}))]}/${RELEASES[1]}/g" debian/changelog > debian/changelog.tmp
mv debian/changelog.tmp debian/changelog
echo Done!
