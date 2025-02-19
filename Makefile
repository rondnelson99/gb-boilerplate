
.SUFFIXES:

################################################
#                                              #
#             CONSTANT DEFINITIONS             #
#                                              #
################################################

## Directory constants
# These directories can be placed elsewhere if you want; directories whose placement
# must be fixed lest this Makefile breaks are hardcoded throughout this Makefile
BINDIR := bin
OBJDIR := obj
DEPDIR := dep

# Program constants
ifneq ($(OS),Windows_NT)
    # POSIX OSes
    RM_RF := rm -rf
    MKDIR_P := mkdir -p
else
    # Windows
    RM_RF := -del /q
    MKDIR_P := -mkdir
endif

# Shortcut if you want to use a local copy of WLA
WLA     := 
WLA6502 := $(WLA)wla-6502
WLALINK := $(WLA)wlalink

ROM = $(BINDIR)/$(ROMNAME).$(ROMEXT)

# Argument constants
INCDIRS  = src/ src/include/
ASFLAGS  =  $(addprefix -I ,$(INCDIRS)) 
LDFLAGS  = 
# The list of "root" ASM files that WLA will be invoked on
SRCS = $(wildcard src/*.asm)

## Project-specific configuration
# Use this to override the above
include project.mk

################################################
#                                              #
#                    TARGETS                   #
#                                              #
################################################

# `all` (Default target): build the ROM
all: $(ROM)
.PHONY: all

# `clean`: Clean temp and bin files
clean:
	$(RM_RF) $(BINDIR)
	$(RM_RF) $(OBJDIR)
	$(RM_RF) $(DEPDIR)
	$(RM_RF) res
.PHONY: clean

# `rebuild`: Build everything from scratch
# It's important to do these two in order if we're using more than one job
rebuild:
	$(MAKE) clean
	$(MAKE) all
.PHONY: rebuild

###############################################
#                                             #
#                 COMPILATION                 #
#                                             #
###############################################

# How to build a ROM
$(BINDIR)/%.$(ROMEXT) $(BINDIR)/%.sym: $(patsubst src/%.asm,$(OBJDIR)/%.o,$(SRCS))
	@$(MKDIR_P) $(@D)
	$(WLALINK) $(LDFLAGS)  -S  -s  -r linkfile $(BINDIR)/$*.$(ROMEXT) 

# `.mk` files are auto-generated dependency lists of the "root" ASM files, to save a lot of hassle.
# Also add all obj dependencies to the dep file too, so Make knows to remake it

	

$(OBJDIR)/%.o $(DEPDIR)/%.mk : src/%.asm
	@$(MKDIR_P) $(patsubst %/,%,$(dir $(OBJDIR)/$* $(DEPDIR)/$*))
	$(WLA6502) $(ASFLAGS) -M $< > $(DEPDIR)/$*.mk
	$(WLA6502) $(ASFLAGS) -o $(OBJDIR)/$*.o $<

ifneq ($(MAKECMDGOALS),clean)
-include $(patsubst src/%.asm,$(DEPDIR)/%.mk,$(SRCS))
endif

################################################
#                                              #
#                RESOURCE FILES                #
#                                              #
################################################


# By default, asset recipes convert files in `res/` into other files in `res/`
# This line causes assets not found in `res/` to be also looked for in `src/res/`
# "Source" assets can thus be safely stored there without `make clean` removing them
VPATH := src

# Define how to compress files using the PackBits16 codec
# Compressor script requires Python 3
res/%.pb16: src/tools/pb16.py res/%
	@$(MKDIR_P) $(@D)
	$^ $@

# Catch non-existent files
# KEEP THIS LAST!!
%:
	@false
