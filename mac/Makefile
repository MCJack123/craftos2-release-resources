CC=clang
CXX=clang++
ifneq (-target arm64-apple-macos11 -mmacosx-version-min=11.0,$(CFLAGS))
CFLAGS+=-mmacosx-version-min=10.15
endif
CFLAGS+= -g -O2 -Wall
CPPFLAGS+= -Icraftos2-lua/include -Iapi -Ideprebuild -I/usr/local/opt/openssl/include -DCRAFTOSPC_COMMIT=\"$(shell git rev-parse --short HEAD)\"
CXXFLAGS+= -std=c++17
LDFLAGS= -LCraftOS-PC.app/Contents/Frameworks -rdynamic
LIBS=craftos2-lua/src/liblua.dylib -lhpdf -lSDL2_mixer -lncurses -lpng -lwebp -lwebpmux -lflac -lmpg123 -lPocoNetSSL -lPocoNet -lPocoCrypto -lPocoJSON -lPocoXML -lPocoUtil -lPocoFoundation -lcrypto -lssl -lSDL2 -framework ApplicationServices -framework Security
PREFIX?=/usr/local
prefix=$(PREFIX)
DESTDIR?=${prefix}
ifneq (/usr,$(PREFIX))
CPPFLAGS:=$(CPPFLAGS) -DCUSTOM_ROM_DIR=\"$(PREFIX)/share/craftos\"
endif
SDIR=./src
IDIR=./api
ODIR?=obj
_OBJ=Computer.o configuration.o favicon.o font.o gif.o main.o plugin.o runtime.o speaker_sounds.o termsupport.o util.o \
	 apis_config.o apis_fs.o apis_fs_handle.o apis_http.o apis_http_handle.o apis_mounter.o apis_os.o apis_periphemu.o apis_peripheral.o apis_redstone.o apis_term.o \
	 peripheral_monitor.o peripheral_printer.o peripheral_computer.o peripheral_modem.o peripheral_drive.o peripheral_debugger.o \
	 peripheral_debug_adapter.o peripheral_speaker.o peripheral_chest.o peripheral_energy.o peripheral_tank.o \
	 terminal_SDLTerminal.o terminal_CLITerminal.o terminal_RawTerminal.o terminal_TRoRTerminal.o terminal_HardwareSDLTerminal.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

all: $(ODIR) craftos

craftos2-lua:
	git submodule update --init --recursive

craftos2-lua/src/liblua.dylib: craftos2-lua
	$(error Please build Lua for your platform inside the craftos2-lua directory)

_craftos_arm_app: craftos2-lua/src/liblua-arm64.dylib $(OBJ) $(ODIR)/platform_macapp.o
	echo " [LD]    CraftOS-PC.app/Contents/MacOS/craftos_arm"
	clang++ -Linclude_arm -LCraftOS-PC.app/Contents/Frameworks -rdynamic -o CraftOS-PC.app/Contents/MacOS/craftos_arm $^ $(LIBS) -F/Library/Frameworks -framework Foundation -framework AppKit -mmacosx-version-min=11.0 -target arm64-apple-macos11

craftos: craftos2-lua/src/liblua.dylib $(OBJ) $(ODIR)/platform.o
	echo " [LD]    $@"
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

macapp: craftos2-lua/src/liblua.dylib $(OBJ) $(ODIR)/platform_macapp.o
	mkdir -p CraftOS-PC.app/Contents/MacOS
	mkdir -p CraftOS-PC.app/Contents/Resources
	CFLAGS="-target arm64-apple-macos11 -mmacosx-version-min=11.0" CPPFLAGS="-Iinclude_arm" ODIR=obj_arm SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk make _craftos_arm_app
	echo " [LD]    CraftOS-PC.app/Contents/MacOS/craftos_x86"
	clang++ -Linclude_arm -LCraftOS-PC.app/Contents/Frameworks -rdynamic -o CraftOS-PC.app/Contents/MacOS/craftos_x86 $^ $(LIBS) -F/Library/Frameworks -framework Foundation -framework AppKit -mmacosx-version-min=10.9 -target x86_64-apple-macos10.9
	echo " [LIPO]  CraftOS-PC.app/Contents/MacOS/craftos"
	rm CraftOS-PC.app/Contents/MacOS/craftos
	lipo -create -output CraftOS-PC.app/Contents/MacOS/craftos CraftOS-PC.app/Contents/MacOS/craftos_x86 CraftOS-PC.app/Contents/MacOS/craftos_arm
	rm CraftOS-PC.app/Contents/MacOS/craftos_x86 CraftOS-PC.app/Contents/MacOS/craftos_arm
	lipo -create -output CraftOS-PC.app/Contents/Frameworks/liblua.dylib craftos2-lua/src/liblua.dylib craftos2-lua/src/liblua-arm64.dylib
	install_name_tool -add_rpath @executable_path/../Frameworks CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change liblua.dylib "@rpath/liblua.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change liblua-arm64.dylib "@rpath/liblua.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libPocoNetSSL.dylib "@rpath/libPocoNetSSL.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libPocoCrypto.dylib "@rpath/libPocoCrypto.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libPocoFoundation.dylib "@rpath/libPocoFoundation.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libPocoJSON.dylib "@rpath/libPocoJSON.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libPocoNet.dylib "@rpath/libPocoNet.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libPocoUtil.dylib "@rpath/libPocoUtil.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libPocoXML.dylib "@rpath/libPocoXML.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libSDL2_mixer.dylib "@rpath/libSDL2_mixer.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libSDL2.dylib "@rpath/libSDL2.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libFLAC.dylib "@rpath/libFLAC.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libmpg123.dylib "@rpath/libmpg123.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libcrypto.dylib "@rpath/libcrypto.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libssl.dylib "@rpath/libssl.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libhpdf.dylib "@rpath/libhpdf.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libpng.dylib "@rpath/libpng.dylib" CraftOS-PC.app/Contents/MacOS/craftos
	cp resources/Info.plist CraftOS-PC.app/Contents/
ifneq (,$(wildcard codesign/Makefile))
	make -C codesign
endif

$(ODIR):
	mkdir $@

$(ODIR)/main.o: $(SDIR)/main.cpp $(IDIR)/Computer.hpp $(IDIR)/lib.hpp $(SDIR)/util.hpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/platform_macapp.o: $(SDIR)/platform/macapp.mm $(SDIR)/platform.hpp
	echo " [OBJC]  $@"
	clang++ -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/platform.o: $(SDIR)/platform.cpp $(SDIR)/platform.hpp $(SDIR)/platform/linux.cpp $(SDIR)/platform/darwin.cpp $(SDIR)/platform/emscripten.cpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/http_emscripten.o: $(SDIR)/http_emscripten.cpp $(IDIR)/Computer.hpp $(IDIR)/lib.hpp $(SDIR)/util.hpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/%.o: $(SDIR)/%.c
	echo " [CC]    $@"
	$(CC) -o $@ -c $(CPPFLAGS) $(CFLAGS) $<

$(ODIR)/%.o: $(SDIR)/%.cpp $(IDIR)/Computer.hpp $(IDIR)/lib.hpp $(SDIR)/util.hpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/peripheral_%.o: $(SDIR)/peripheral/%.cpp $(SDIR)/peripheral/%.hpp $(IDIR)/peripheral.hpp $(IDIR)/Computer.hpp $(IDIR)/lib.hpp $(SDIR)/util.hpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/peripheral_computer.o: $(SDIR)/peripheral/computer_p.cpp $(SDIR)/peripheral/computer.hpp $(IDIR)/peripheral.hpp $(IDIR)/Computer.hpp $(IDIR)/lib.hpp $(SDIR)/util.hpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/speaker_sounds.o: $(SDIR)/peripheral/speaker_sounds.cpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/terminal_%.o: $(SDIR)/terminal/%.cpp $(SDIR)/terminal/%.hpp $(IDIR)/Terminal.hpp $(IDIR)/Computer.hpp $(IDIR)/lib.hpp $(SDIR)/util.hpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/apis_%.o: $(SDIR)/apis/%.cpp $(IDIR)/Computer.hpp $(IDIR)/lib.hpp $(SDIR)/util.hpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

$(ODIR)/apis_%_handle.o: $(SDIR)/apis/handles/%_handle.cpp $(SDIR)/apis/handles/%_handle.hpp $(IDIR)/Computer.hpp $(IDIR)/lib.hpp $(SDIR)/util.hpp
	echo " [CXX]   $@"
	$(CXX) -o $@ -c $(CPPFLAGS) $(CXXFLAGS) $(CFLAGS) $<

mac-plugin:
	echo " [CCLD]  ccemux.bundle"
	$(CXX) -LCraftOS-PC.app/Contents/Frameworks -std=c++17 -bundle -fpic -o ccemux_x86.bundle examples/ccemux.cpp craftos2-lua/src/liblua.dylib CraftOS-PC.app/Contents/Frameworks/libSDL2.dylib -Ideprebuild -Icraftos2-lua/include -Iapi
	$(CXX) -LCraftOS-PC.app/Contents/Frameworks -std=c++17 -bundle -fpic -target arm64-apple-macos11 -mmacosx-version-min=11.0 -o ccemux_arm.bundle examples/ccemux.cpp craftos2-lua/src/liblua-arm64.dylib CraftOS-PC.app/Contents/Frameworks/libSDL2.dylib -Ideprebuild -Icraftos2-lua/include -Iapi
	lipo -create -output ccemux.bundle ccemux_x86.bundle ccemux_arm.bundle
	rm ccemux_x86.bundle ccemux_arm.bundle
	install_name_tool -change liblua.dylib "@rpath/liblua.dylib" ccemux.bundle
	install_name_tool -change CraftOS-PC.app/Contents/Frameworks/libSDL2.dylib "@rpath/libSDL2.dylib" ccemux.bundle

linux-plugin:
	echo " [LD]    ccemux.so"
	$(CXX) -std=c++17 -shared -fPIC -o ccemux.so examples/ccemux.cpp craftos2-lua/src/liblua.dylib -lSDL2 -Icraftos2-lua/include -Iapi

clean: $(ODIR)
	rm -f craftos
	find obj -type f -not -name speaker_sounds.o -exec rm -f {} \;

rebuild: clean craftos

install: craftos
	echo " [CP]    $(DESTDIR)/craftos"
	cp craftos $(DESTDIR)/craftos

uninstall:
	echo " [RM]    $(DESTDIR)/craftos"
	rm $(DESTDIR)/craftos

test: craftos
	./craftos --headless --script $(shell pwd)/resources/CraftOSTest.lua -d "$(shell mktemp -d)"

.SILENT:
