
verilator   ?= verilator
ver-library ?= ver_work
defines     ?= 
max_cycles ?= 1000000000000000000000000000000000000
vcd        ?= 0
imem ?= ./Script/build/ICACHE.mem
# dmem ?= ./Script/build/DCACHE.mem


incdir 	:= 	
list_incdir := $(foreach dir, ${incdir}, +incdir+$(dir))



src_core := ./top.sv 						\
		$(wildcard ./uart/*.svh)						\
	   $(wildcard ./rtl/Core/Datapath/*.sv)							\
	   $(wildcard ./rtl/Core/Controller/*.sv)						\
	   $(wildcard ./uart/*.sv)						

src_gemm :=  ./tb_random_gemm.sv							\
		./Config.sv 										\
		./gemm.sv											\
	   $(wildcard ./rtl/Gemm/Controller/*.sv)					\
	   $(wildcard ./rtl/Gemm/Datapath/*.sv)						\
	   $(wildcard ./rtl/Gemm/Utilities/*.sv)					\
	   $(wildcard ./rtl/Core/Datapath/*.sv)							\
	   $(wildcard ./rtl/Core/Controller/*.sv)						\
	   $(wildcard ./uart/*.sv)								\
	   $(wildcard ./uart/*.svh)						

verilate_command_core := $(verilator) +define+$(defines) \
					--cc $(src_core) $(list_incdir)	\
					--top-module top			\
					-Wno-TIMESCALEMOD 			\
					-Wno-MULTIDRIVEN 			\
					-Wno-CASEOVERLAP 			\
        				-Wno-WIDTH  			\
					-Wno-UNOPTFLAT 				\
					-Wno-IMPLICIT 				\
					-Wno-PINMISSING 			\
					--timing	\
					--Mdir $(ver-library)				\
					--exe verilator_testbench/tb_top.cpp		\
					--trace-structs --trace
					
verilate_command_gemm := $(verilator) 	+define+$(defines)		\
					--cc $(src_gemm) $(list_incdir)	\
					--top-module tb_random_gemm			\
					-Wno-TIMESCALEMOD 			\
					-Wno-MULTIDRIVEN 			\
					-Wno-CASEOVERLAP 			\
        				-Wno-WIDTH  			\
					-Wno-MODDUP	\
					-Wno-WIDTHCONCAT \
					-Wno-CMPCONST	\
					-Wno-CASEINCOMPLETE	\
					-Wno-INITIALDLY	\
					-Wno-LATCH	\
					-Wno-UNOPTFLAT 				\
					-Wno-IMPLICIT 				\
					-Wno-PINMISSING 			\
					--timing	\
					--Mdir $(ver-library)			\
					--exe verilator_testbench/tb_random_gemm.cpp		\
					--trace-structs --trace


verilate_core: 
	@echo "Building verilator model"
	$(verilate_command_core)
	cd $(ver-library) && $(MAKE) -f V_top.mk
	@echo "hello entering simulation"
	$(ver-library)/V_top  +max_cycles=$(max_cycles) +vcd=$(vcd)


verilate_gemm:
	@echo "Building verilator model"
	$(verilate_command_gemm)
	cd $(ver-library) && $(MAKE) -f Vtb_random_gemm.mk
	@echo "hello entering simulation"
	$(ver-library)/Vtb_random_gemm  +max_cycles=$(max_cycles) +vcd=$(vcd)


clean-all:
	rm -rf ver_work/ *.log *.vcd 					\
	verif/*work/


