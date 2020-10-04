
vpath %.asm src

MKDIR   := mkdir -p
RM      := rm -f
RMDIR   := rm -rf

AS      := nasm
ASFLAGS := -W+all -felf64
LD      := ld
LDFLAGS := -O1 -nostdlib --sort-common --as-needed --relax -z relro -z now
LIBS    :=

SRCS    := $(notdir $(wildcard src/*.asm))
OBJS    := $(patsubst %.asm,%.o,$(SRCS))

TARGET  := xserver

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $^

.PHONY: clean
clean:
	$(RM) $(OBJS) $(TARGET)
