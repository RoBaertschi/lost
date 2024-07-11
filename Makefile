EXE := lost.bin

CC = x86_64-elf-gcc
CFLAGS = -Wall -Wextra -Wpedantic -std=gnu99 -ffreestanding
OPTFLAGS = -O2
64BITFLAGS = -mno-red-zone -mno-mmx -mno-sse -mno-sse2

AS = x86_64-elf-as
ASFLAGS = -msyntax=intel -mnaked-reg

LINKER = linker.ld
LDFLAGS = -lgcc -nostdlib

QEMUCMD = qemu-system-x86_64
QEMUFLAGS = -drive format=raw,file=


OBJDIR = ./obj

KSRCS := $(shell find ./kernel/ -name '*.c')
BSRCS := $(shell find ./bootloader/ -name '*.asm')

KOBJS := $(KSRCS:%=$(OBJDIR)/kernel/%.o)
BOBJS := $(BSRCS:%=$(OBJDIR)/bootloader/%.o)

KDEPS := $(KOBJS:.o=.d)
BDEPS := $(BOBJS:.o=.d)

INC_DIRS := $(shell find ./kernel -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS := $(INC_FLAGS) -MMD -MP

$(EXE): $(KOBJS) $(BOBJS)
	$(CC) $(BOBJS) $(KOBJS) -o $(EXE) $(CFLAGS) $(LDFLAGS) $(64BITFLAGS) $(DIRECTIVES) -T $(LINKER) $(OPTFLAGS)

$(OBJDIR)/kernel/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) -c $< -o $@ $(CFLAGS) $(OPTFLAGS) $(DIRECTIVES) $(64BITFLAGS)



$(OBJDIR)/bootloader/%.asm.o: %.asm
	mkdir -p $(dir $@)
	$(AS) $< -o $@ $(ASFLAGS)

.PHONY: clean qemu
clean:
	rm -rf $(OBJDIR)

qemu: $(EXE)
	$(QEMUCMD) $(QEMUFLAGS)$(EXE)

-include $(KDEPS)
-include $(BDEPS)
