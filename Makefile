
vpath %.asm src
vpath %.inc include

MKDIR   := mkdir -p
RM      := rm -f
RMDIR   := rm -rf

AS      := nasm
ASFLAGS := -W+all -Ov -Iinclude -Pinclude/file-descriptors.inc -Pinclude/system-calls.inc -felf64 -gdwarf
LD      := ld
LSTOPTS := -Lb -Ld -Le -Lm -Ls
LDFLAGS := -O1 -nostdlib --sort-common --as-needed --relax -z relro -z now -T src/linker.ld
LIBS    :=

SRCS    := $(notdir $(wildcard src/*.asm))
OBJS    := $(patsubst %.asm,%.o,$(SRCS))
LSTS    := $(patsubst %.asm,%.lst,$(SRCS))

TARGET  := xserver

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $^

listings: $(LSTS)

%.lst: %.asm
	$(AS) $(ASFLAGS) -l $@ $(LSOPTS) -o $(patsubst %.asm,%.o,$^) $^

.PHONY: clean
clean:
	$(RM) $(OBJS) $(LSTS) $(TARGET)
