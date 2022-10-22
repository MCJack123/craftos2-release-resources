#!/bin/bash
if [ "$1" = "setup" ]; then
    echo "$MACOS_CERTIFICATE" | base64 -d > certificate.p12
    security create-keychain -p actionrunner build.keychain
    security default-keychain -s build.keychain
    security unlock-keychain -p actionrunner build.keychain
    security import certificate.p12 -k build.keychain -P $MACOS_CERTIFICATE_PWD -T /usr/bin/codesign
    security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k actionrunner build.keychain
    security set-keychain-settings -lut 900
    echo "$NOTARIZATION_CERTIFICATE" | base64 -d > APIKey.p8
    brew install coreutils
elif [ "$1" = "build" ]; then
    git submodule update --init --recursive
    cp -Rp $GITHUB_WORKSPACE/craftos2-release-resources/mac/codesign $GITHUB_WORKSPACE/craftos2-release-resources/mac/deprebuild $GITHUB_WORKSPACE/craftos2-release-resources/mac/include_arm .
    if [[ $GITHUB_REF =~ luajit ]]; then
        cp -Rp $GITHUB_WORKSPACE/craftos2-release-resources/mac/Makefile-Accelerated $GITHUB_WORKSPACE/craftos2-release-resources/mac/CraftOS-PC-Accelerated.app .
        mv Makefile-Accelerated Makefile
        mv CraftOS-PC-Accelerated.app CraftOS-PC.app
        export MACOSX_DEPLOYMENT_TARGET=10.9
    else
        cp -Rp $GITHUB_WORKSPACE/craftos2-release-resources/mac/Makefile $GITHUB_WORKSPACE/craftos2-release-resources/mac/CraftOS-PC.app .
        make -C craftos2-lua macosx -j3
        rm craftos2-lua/src/*.o
        make -C craftos2-lua macosx-arm -j3
    fi
    mkdir obj obj_arm
    make macapp -j3
    make mac-plugin
    codesign -fs "Developer ID Application: Jack Bruienne (396R3XAD4M)" --timestamp --options runtime --deep ccemux.bundle
elif [ "$1" = "sign" ]; then
    if [[ $GITHUB_REF =~ luajit ]]; then
        cp -Rp $GITHUB_WORKSPACE/craftos2-release-resources/mac/CraftOS-PC-Accelerated CraftOS-PC
    else
        cp -Rp $GITHUB_WORKSPACE/craftos2-release-resources/mac/CraftOS-PC CraftOS-PC
    fi
    cp -Rp CraftOS-PC.app ccemux.bundle CraftOS-PC
    if [[ $GITHUB_REF =~ luajit ]]; then
        mv CraftOS-PC/CraftOS-PC.app CraftOS-PC/CraftOS-PC\ Accelerated.app
    fi
    curl -LO https://c-command.com/downloads/DropDMG-3.6.5.dmg
    hdiutil attach DropDMG-3.6.5.dmg
    cp -Rp /Volumes/DropDMG-*/DropDMG.app /Applications/
    mdimport /Applications/DropDMG.app
    sqlite3 "/Users/runner/Library/Application Support/com.apple.TCC/TCC.db" "insert into access values ('kTCCServiceAppleEvents', 'com.c-command.DropDMG', 0, 2, 4, 1, NULL, NULL, 0, 'com.apple.finder', NULL, 0, 0)"
    sqlite3 "/Users/runner/Library/Application Support/com.apple.TCC/TCC.db" "insert into access values ('kTCCServiceAppleEvents', '/Applications/DropDMG.app/Contents/Frameworks/DropDMGFramework.framework/Versions/A/dropdmg', 1, 2, 4, 1, NULL, NULL, 0, 'com.c-command.DropDMG', NULL, 0, 0)"
    sqlite3 "/Users/runner/Library/Application Support/com.apple.TCC/TCC.db" "insert into access values ('kTCCServiceAppleEvents', '$SHELL', 1, 2, 4, 1, NULL, NULL, 0, 'com.c-command.DropDMG', NULL, 0, 0)"
    sqlite3 "/Users/runner/Library/Application Support/com.apple.TCC/TCC.db" "insert into access values ('kTCCServiceAppleEvents', '/usr/bin/osascript', 1, 2, 4, 1, NULL, NULL, 0, 'com.c-command.DropDMG', NULL, 0, 0)"
    /Applications/DropDMG.app/Contents/Frameworks/DropDMGFramework.framework/Versions/A/dropdmg --layout-folder $GITHUB_WORKSPACE/craftos2-release-resources/mac/layout -f bzip2 -n CraftOS-PC
    xcrun notarytool submit -k APIKey.p8 -d C3VGHY9QZ3 -i 88c37dac-bd0f-4adc-9e79-a24745e2e292 --wait CraftOS-PC.dmg
    xcrun stapler staple CraftOS-PC.dmg
fi
