sign:
	echo " [SIGN]  CraftOS-PC.app"
	cp -R ${GITHUB_WORKSPACE}/craftos2-rom/rom ${GITHUB_WORKSPACE}/craftos2-rom/debug ${GITHUB_WORKSPACE}/craftos2-rom/bios.lua ${GITHUB_WORKSPACE}/craftos2-rom/hdfont.bmp ../CraftOS-PC.app/Contents/Resources/
	dsymutil ../CraftOS-PC.app/Contents/MacOS/craftos -o ../CraftOS-PC.app.dSYM
	strip -S ../CraftOS-PC.app/Contents/MacOS/craftos
	codesign -fs "Developer ID Application: Jack Bruienne (396R3XAD4M)" --timestamp --deep --options runtime --entitlements CraftOS-PC.entitlements ../CraftOS-PC.app
	codesign -vv ../CraftOS-PC.app
