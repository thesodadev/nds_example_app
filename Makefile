CXX		= arm-none-eabi-g++
LD		= arm-none-eabi-g++
NDSTOOL = ndstool

APP_NAME = example
BUILD_DIR = build

SRC_DIR = src
SRC_FILES = main.cpp

LIB_DIRS = 	-L$(NDSCRT_DIR) \
			-L$(LIBNDS_DIR) \
			-L$(NEWLIB_DIR)/arm-none-eabi/thumb/newlib/thumb \
			-L$(NEWLIB_DIR)/arm-none-eabi/thumb/libgloss/libsysbase

LIBS = -lnds -lc -lm -lg -lsysbase

INCLUDE_DIRS = 	-I $(LIBNDS_DIR)/include \
				-I $(NEWLIB_DIR)/newlib/libc/include

ARCH := -mthumb -mthumb-interwork

CFLAGS := -Wall -Wno-reorder -O0 \
		-march=armv5te \
		-mtune=arm946e-s \
		-fomit-frame-pointer \
		-ffast-math \
		$(ARCH) \
		$(INCLUDE_DIRS) \
		-DARM9

CXXFLAGS = $(CFLAGS) -fno-rtti -fno-exceptions
LDFLAGS	= -B$(NDSCRT_DIR) -specs=$(NDSCRT_DIR)/arm9.specs $(ARCH)

NDSTOOL_TITLE = $(APP_NAME)
NDSTOOL_SUBTITLE1 = subtitle1
NDSTOOL_SUBTITLE2 = subtitle2
NDSTOOL_ICON = res/icon.bmp

# remove file extension -> instead append ".o" -> add to build path
SRC_OBJ_FILES = $(patsubst %,$(BUILD_DIR)/%,$(addsuffix .o,$(basename $(SRC_FILES))))
BIN_PATH = $(BUILD_DIR)/$(APP_NAME)

$(BIN_PATH).nds: $(BIN_PATH).elf
	$(NDSTOOL) -c $@ -9 $< -b $(NDSTOOL_ICON) "$(NDSTOOL_TITLE);$(NDSTOOL_SUBTITLE1);$(NDSTOOL_SUBTITLE2)"

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