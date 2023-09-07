.PHONY: all clean chopUpDigits_control register
all:
	@echo Please use one of the make targets specified in the handout.


chopUpDigits_circuit: chopUpDigits_circuit_exe
	./$<

chopUpDigits_circuit_exe: chopUpDigits_circuit_tb.v chopUpDigits_circuit.v register.v chopUpDigits_lib.v
	iverilog -o $@ -Wall $^

chopUpDigits_control: chopUpDigits_control_exe
	./$<

chopUpDigits_control_exe: chopUpDigits_control_tb.v chopUpDigits_control.v chopUpDigits_circuit.v chopUpDigits_lib.v register.v
	iverilog -o $@ -Wall $^

clean:
	rm -f *_exe *.vcd
