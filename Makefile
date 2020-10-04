
vpath %.asm src
vpath %.inc include

MKDIR   := mkdir -p
RM      := rm -f
RMDIR   := rm -rf

AS      := nasm
ASFLAGS := -W+all -Ox -Iinclude -Pinclude/file-descriptors.inc -Pinclude/system-calls.inc -felf64 -gdwarf
LD      := ld
LDFLAGS := -O1 -nostdlib --sort-common --as-needed --relax -z relro -z now
LIBS    :=

SRCS    := $(notdir $(wildcard src/*.asm))
OBJS    := $(patsubst %.asm,%.o,$(SRCS))
LSTS    := $(patsubst %.asm,%.l,$(SRCS))

TARGET  := xserver

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $^

listings: $(LSTS)

%.l: %.asm
	$(AS) $(ASFLAGS) -l $@ -o $(patsubst %.asm,%.o,$^) $^

.PHONY: clean
clean:
	$(RM) $(OBJS) $(LSTS) $(TARGET)
