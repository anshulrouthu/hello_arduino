	
_build:	
	mkdir -p _build

.PHONY:	all
all: _build/Makefile
	$(MAKE) -C _build all
	
.PHONY: upload
upload: _build/Makefile
	$(MAKE) -C _build upload

.PHONY: menuconfig
menuconfig: _build
	cd _build && ccmake ..
	
################# making platform specific config files ##################
.PHONY: _config
_config: _build
	cd _build && cmake -DCMAKE_TOOLCHAIN_FILE=$(TOOLCHAIN) ..
	
.PHONY:	arduinoconfig
arduinoconfig: TOOLCHAIN=cmake_config/arduino.cmake
arduinoconfig: _config

################ cleaning up ##################
.PHONY: clean
clean: _build/Makefile
	$(MAKE) -C _build clean

.PHONY: distclean
distclean:
	rm -rf _build