CXX	 = arm-none-eabi-g++
LD = arm-none-eabi-g++

APP_NAME = example
BUILD_DIR = build

SRC_DIR = src
SRC_FILES = main.cpp

LIBS = -lnds9 -lm -lg -lsysbase -lc -lgcc -nodefaultlibs

ARCH := -mthumb -mthumb-interwork

CXXFLAGS := -DARM9 \
		    -Wall -Wno-reorder -O0 \
		    -march=armv5te \
		    -mtune=arm946e-s \
		    -fomit-frame-pointer \
		    -ffast-math \
		    -fno-rtti \
		    -fno-exceptions \
		    $(ARCH)

LDFLAGS	= -specs=arm9.specs \
		  -mcpu=arm946e-s \
		  $(ARCH) 

NDS_TITLE = $(APP_NAME)
NDS_SUBTITLE1 = subtitle1
NDS_SUBTITLE2 = subtitle2
NDS_ICON = res/icon.bmp

# remove file extension -> instead append ".o" -> add to build path
SRC_OBJ_FILES = $(patsubst %,$(BUILD_DIR)/%,$(addsuffix .o,$(basename $(SRC_FILES))))
BIN_PATH = $(BUILD_DIR)/$(APP_NAME)

$(BIN_PATH).nds: $(BIN_PATH).elf
	ndstool -c $@ -7 /opt/nds/arm7_default.elf -9 $< -b $(NDS_ICON) "$(NDS_TITLE);$(NDS_SUBTITLE1);$(NDS_SUBTITLE2)"

$(BIN_PATH).elf: $(SRC_OBJ_FILES)
	$(LD) $(LDFLAGS) $^ $(LIB_DIRS) $(LIBS) -o $@
	
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

.PHONY: all clean rebuild path_builder

all: path_builder $(BUILD_DIR)/$(APP_NAME).nds

rebuild: clean all

clean:
	rm -rf $(BUILD_DIR)

path_builder:
	mkdir -p $(BUILD_DIR)
