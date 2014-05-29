# The name of your sketch (used to find TARGET.ino and to name the compiled .hex file)
# change this name to what ever project you are working on
# make sure you name the .ino file and its parent directory the same if you want to make the project compatible
# with Arduino IDE, this is the Arduino IDE specific.
# e.g <project root>/blink/blink.ino
TARGET := blink

# Libraries
# add additional libraries that your working with here e.g servos, xbee, or if you want to add your own 
# library/source files add them to the <project root>/libraries/<library name>/<*.cpp> or <*.c> files
# you can look at the test example in the <project root>/libraries/test. The blink.ino file uses the function call to
# the test.cpp file for blinking an led. Include those libraries here. (this structure makes the project Arduino IDE compatible)
USER_LIBRARIES := SdFat test
CORE_LIBRARIES :=  SPI
USER_LIB_HOME := ../libraries

# Arduino IDE installation location
ARDUINO_HOME := ../arduino-1.0.5

# Arduino/Teensy files, Core libs
ARDUINO_HW_HOME := $(ARDUINO_HOME)/hardware
CORE_LIB_HOME := $(ARDUINO_HOME)/libraries
ARDUINO := $(ARDUINO_HW_HOME)/arduino/cores/arduino

#avr tools path
AVR_GCC_PATH=$(ARDUINO_HW_HOME)/tools/avr/bin

#************************************************************************
# Library includes and sources
#************************************************************************

LIBRARY_PATHS := $(foreach lib,$(CORE_LIBRARIES),$(CORE_LIB_HOME)/$(lib)) $(foreach lib,$(USER_LIBRARIES),$(USER_LIB_HOME)/$(lib))
LIBRARY_INCLUDES := $(foreach libdir,$(LIBRARY_PATHS),-I$(libdir))
SRC := $(foreach libdir,$(LIBRARY_PATHS),$(wildcard $(libdir)/*.c)) $(wildcard $(ARDUINO)/*.c)
CXXSRC :=  $(foreach libdir,$(LIBRARY_PATHS),$(wildcard $(libdir)/*.cpp)) $(wildcard $(ARDUINO)/*.cpp)

# port to which the arduino board is connect /dev/ttyACM0 is default for linux
#PORT = /dev/ttyACM0

# change the MCU to what ever your board's cpu is 
MCU = atmega2560

F_CPU = 16000000
FORMAT = ihex
UPLOAD_RATE = 115200
ARDUINO_BOARD = mega

# -------------------------- Changes below this line are usually not required --------------------#

# setting the path that are dependent on operating systems
ifeq ($(shell uname), Darwin)
	AVRDUDE_PATH=$(ARDUINO_HW_HOME)/tools/avr/bin
	PORT = /dev/tty.usbmodem1421
	AVRDUDE_CONFIG_FILE:=$(AVRDUDE_PATH)/../etc/avrdude.conf
endif
ifeq ($(shell uname), Linux)
	AVRDUDE_PATH=$(ARDUINO_HW_HOME)/tools
	PORT = /dev/ttyACM0
	AVRDUDE_CONFIG_FILE:=$(AVRDUDE_PATH)/avrdude.conf
endif

# Name of this Makefile (used for "make depend").
MAKEFILE = Makefile

# Debugging format.
# Native formats for AVR-GCC's -g are stabs [default], or dwarf-2.
# AVR (extended) COFF requires stabs, plus an avr-objcopy run.
DEBUG = stabs

OPT = s

# Place -D or -U options here
CDEFS = -DF_CPU=$(F_CPU)
CXXDEFS = -DF_CPU=$(F_CPU)

# Place -I options here
CINCS = -I$(ARDUINO) $(LIBRARY_INCLUDES) -I$(ARDUINO_HW_HOME)/arduino/variants/$(ARDUINO_BOARD)
CXXINCS = -I$(ARDUINO) $(LIBRARY_INCLUDES) -I$(ARDUINO_HW_HOME)/arduino/variants/$(ARDUINO_BOARD)

# Compiler flag to set the C Standard level.
# c89   - "ANSI" C
# gnu89 - c89 plus GCC extensions
# c99   - ISO C99 standard (not yet fully implemented)
# gnu99 - c99 plus GCC extensions
CSTANDARD = -std=gnu99
CDEBUG = -g$(DEBUG)
CWARN = -Wall -Wstrict-prototypes
CTUNING = -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
#CEXTRA = -Wa,-adhlns=$(<:.c=.lst)

CFLAGS = $(CDEBUG) $(CDEFS) $(CINCS) -O$(OPT) $(CWARN) $(CSTANDARD) $(CEXTRA)
CXXFLAGS = $(CDEFS) $(CINCS) -O$(OPT)
#ASFLAGS = -Wa,-adhlns=$(<:.S=.lst),-gstabs 

# Programming support using avrdude. Settings and variables.
AVRDUDE_PROGRAMMER = stk500v2
AVRDUDE_PORT = $(PORT)
AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).hex
AVRDUDE_FLAGS = -F -p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER) -b $(UPLOAD_RATE) -C $(AVRDUDE_CONFIG_FILE)

# Program settings
CC = $(AVR_GCC_PATH)/avr-gcc
CXX = $(AVR_GCC_PATH)/avr-g++
OBJCOPY = $(AVR_GCC_PATH)/avr-objcopy
OBJDUMP = $(AVR_GCC_PATH)/avr-objdump
SIZE = $(AVR_GCC_PATH)/avr-size
NM = $(AVR_GCC_PATH)/avr-nm
AVRDUDE = $(AVRDUDE_PATH)/avrdude
REMOVE = rm -f
MV = mv -f

# Define all object files.
OBJ = $(TARGET).o $(SRC:.c=.o) $(CXXSRC:.cpp=.o) $(ASRC:.S=.o)

# Define all listing files.
LST = $(ASRC:.S=.lst) $(CXXSRC:.cpp=.lst) $(SRC:.c=.lst)

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_CFLAGS = -mmcu=$(MCU) -I. $(CFLAGS)
ALL_CXXFLAGS = -mmcu=$(MCU) -I. $(CXXFLAGS)
ALL_INOFLAGS = $(ALL_CXXFLAGS) -x c++
ALL_ASFLAGS = -mmcu=$(MCU) -I. -x assembler-with-cpp $(ASFLAGS)

# Default target.
all: build

build: elf hex eep upload

elf: $(TARGET).elf
hex: $(TARGET).hex
eep: $(TARGET).eep
lss: $(TARGET).lss 
sym: $(TARGET).sym

# Program the device.  
upload: $(TARGET).hex $(TARGET).eep
	@echo "Uploading $(TARGET).hex to target board"
	@$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)

# Convert ELF to COFF for use in debugging / simulating in AVR Studio or VMLAB.
COFFCONVERT=$(OBJCOPY) --debugging \
--change-section-address .data-0x800000 \
--change-section-address .bss-0x800000 \
--change-section-address .noinit-0x800000 \
--change-section-address .eeprom-0x810000 

coff: $(TARGET).elf
	@$(COFFCONVERT) -O coff-avr $(TARGET).elf $(TARGET).cof


extcoff: $(TARGET).elf
	@$(COFFCONVERT) -O coff-ext-avr $(TARGET).elf $(TARGET).cof

.SUFFIXES: .elf .hex .eep .lss .sym

.elf.hex:
	@echo "[OBJCOPY] $@"
	@$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

.elf.eep:
	@echo "[OBJCOPY] $@"
	@-$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" -O $(FORMAT) $< $@

# Create extended listing file from ELF output file.
.elf.lss:
	@$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
.elf.sym:
	@echo "[NM] $@"
	@$(NM) -n $< > $@

# Link: create ELF output file from object files.
$(TARGET).elf: $(OBJ)
	@echo "[CXX] $@"
	@$(CXX) $(ALL_CFLAGS) $(OBJ) --output $@ $(LDFLAGS)

# Compile: create object files from ino source files.
%.o: %.ino
	@echo "[CXX] $@"
	@$(CXX) -c $(ALL_INOFLAGS) $< -o $@ 

# Compile: create object files from C++ source files.
%.o: %.cpp
	@echo "[CXX] $@"
	@$(CXX) -c $(ALL_CXXFLAGS) $< -o $@ 

# Compile: create object files from C source files.
%.o: %.c
	@echo "[CC] $@"
	@$(CC) -c $(ALL_CFLAGS) $< -o $@ 

# Compile: create assembler files from C source files.
%.o: %.s
	@echo "[CC] $@"
	@$(CC) -S $(ALL_CFLAGS) $< -o $@

# Assemble: create object files from assembler source files.
%.o: %.S
	@echo "[CC] $@"
	@$(CC) -c $(ALL_ASFLAGS) $< -o $@

# Target: clean project.
clean:
	$(REMOVE) $(TARGET).hex $(TARGET).eep $(TARGET).cof $(TARGET).elf \
	$(TARGET).map $(TARGET).sym $(TARGET).lss \
	$(OBJ)

depend:
	if grep '^# DO NOT DELETE' $(MAKEFILE) >/dev/null; \
	then \
		sed -e '/^# DO NOT DELETE/,$$d' $(MAKEFILE) > \
			$(MAKEFILE).$$$$ && \
		$(MV) $(MAKEFILE).$$$$ $(MAKEFILE); \
	fi
	echo '# DO NOT DELETE THIS LINE -- make depend depends on it.' \
		>> $(MAKEFILE); \
	$(CC) -M -mmcu=$(MCU) $(CDEFS) $(CINCS) $(SRC) $(ASRC) >> $(MAKEFILE)

.PHONY:	all build elf hex eep lss sym program coff extcoff clean depend
