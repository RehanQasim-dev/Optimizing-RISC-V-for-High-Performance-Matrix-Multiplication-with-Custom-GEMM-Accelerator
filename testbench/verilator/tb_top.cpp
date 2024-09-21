#include<stdlib.h>
#include<iostream>
#include<verilated.h>
#include<verilated_vcd_c.h>
#include<V_top.h>
#define MAX_SIM_TIME 20000


vluint64_t sim_time =0;
vluint64_t posedge_cnt=0;

void dut_reset (V_top *dut , vluint64_t &sim_time);

int main (int argc, char** argv , char** env) {
	Verilated::commandArgs(argc,argv);
	V_top *dut = new V_top;

	Verilated::traceEverOn(true);
	VerilatedVcdC *m_trace = new VerilatedVcdC;
	dut->trace(m_trace,10);
	m_trace->open("waveform.vcd");

	while (sim_time <MAX_SIM_TIME) {

		dut_reset(dut,sim_time);
		dut->clk^= 1;
		dut->eval();		
		if (dut->clk == 1) {
		posedge_cnt++ ;
		}				
	
	m_trace-> dump(sim_time);
	sim_time++;
	}

	m_trace->close();
	delete dut;
	exit(EXIT_SUCCESS);
}

void dut_reset (V_top *dut, vluint64_t &sim_time){
    dut->rst = 0;
    if(sim_time >= 3 && sim_time < 6){
        dut->rst = 1;
        
    }
}


