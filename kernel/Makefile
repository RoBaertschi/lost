TARGET ?= lost.elf

CC					:= x86_64-elf-gcc
AR					:= x86_64-elf-ar
CFLAGS			:= -Wall -Wextra -Wpedantic -std=gnu99 -ffreestanding
OPTFLAGS		:= -O2
64BITFLAGS	:= -mno-red-zone -mno-mmx -mno-sse -mno-sse2

AS			:= x86_64-elf-as
ASFLAGS := -msyntax=intel -mnaked-reg

LINKER  := ../linker.ld
LDFLAGS := -lgcc -nostdlib

BUILD_DIR := ./build
SRCS			:= $(wildcard *.c *.asm)
OBJS			:= $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS			:= $(OBJS:.o=.d)
INC_DIRS	:= $(shell find . -type d)
INC_FLAGS	:= $(addprefix -I,$(INC_DIRS))

CPPFLAGS	:= $(INC_FLAGS) -MMD -MP

all: $(BUILD_DIR)/$(TARGET)

$(BUILD_DIR)/$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(BUILD_DIR)/$(TARGET) $(CFLAGS) $(LDFLAGS) $(64BITFLAGS) $(DIRECTIVES) -Ttext=0x01000000 $(OPTFLAGS) -e init
	# $(AR) rcs $(BUILD_DIR)/$(TARGET) $(OBJS)
	

$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) -c $< -o $@ $(CFLAGS) $(CPPFLAGS) $(OPTFLAGS) $(DIRECTIVES) $(64BITFLAGS)

$(OBJDIR)/%.asm.o: %.asm
	mkdir -p $(dir $@)
	$(AS) $< -o $@ $(ASFLAGS)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

-include $(DEPS)
