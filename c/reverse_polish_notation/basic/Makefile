PRODUCT := rpn.x

SRCDIR := src
BINDIR := build
BINARY := $(BINDIR)/$(PRODUCT)
HDRS := $(wildcard $(SRCDIR)/*.h)
SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(SRCS:$(SRCDIR)/%.c=$(BINDIR)/%.o)

# Compiler Flags:
CC := gcc
LD := gcc
CCFLAGS := -g -Wall -Wextra -ansi -O0 -g  -std=c99

# Utility functions:
define maketargetdir
	-@mkdir -p $(dir $@) > /dev/null 2>&1
endef

all : $(BINARY)

$(BINARY) : $(OBJS)
	@echo linking $@
	$(maketargetdir)
	$(LD) $(LDFLAGS) -o $@ $^

$(BINDIR)/%.o : $(SRCDIR)/%.c
	@echo compiling $<
	$(maketargetdir)
	$(CC) $(CCFLAGS) $(CCINCLUDES) -c -o $@ $<

clean :
	rm -f $(BINARY) $(OBJS)
	rm -rf $(BINDIR)
