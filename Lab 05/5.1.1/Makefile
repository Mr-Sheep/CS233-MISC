# Disable make's irritating builtin rules
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:


all:
	@echo Please run one of the following targets:
	@echo decoder, 
	@echo clean
.PHONY: all clean

# Verilog simulations sometimes enter infinite loops, and piping the simulation
# through grep (below) causes it to be block-buffered, meaning nothing gets
# printed out to the screen, confusing people. This is to force line-buffering;
# script should be available everywhere but it uses different parameters on
# Linux and OS X, making it simpler to use stdbuf on Linux instead
ifneq ($(shell command -v stdbuf;),)
    UNBUFFER = stdbuf -oL
else ifneq ($(shell command -v script;),)
    UNBUFFER = script -q /dev/null
endif

decoder: decoder_exe
	./$<

decoder_exe: mips_defines.v decoder.v decoder_tb.v
	iverilog -o $@ -Wall $^

# dumping register values causes spurious VCD warnings to be printed during execution,
# hence the use of grep to filter them up. However, the presence of 'VCD warning' in a
# command freaked a bunch of people out last time, so I'm echoing a fake command instead
# of the actual one to prevent any confusion

clean:
	rm -f decoder_exe decoder.vcd
