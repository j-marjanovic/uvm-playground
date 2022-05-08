

import uvm_pkg::*;
`include "uvm_macros.svh"

//==============================================================================
// environment

class env extends uvm_env;
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("env", "Constructor finished", UVM_LOW);
    endfunction

    function void connect_phase(uvm_phase phase);
        `uvm_info("env", "In the `connect` phase", UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
        // phase.raise_objection(this);
        `uvm_info("env", "In the `run` phase", UVM_LOW);
        // phase.drop_objection(this);
    endtask
endclass: env

//==============================================================================
// testbench

module simple_alu_tb;

bit clk;
env env;

simple_alu DUT (
    .clk
);

initial begin: proc_main
    `uvm_info("main", "Testbench starting (msg verbosity: HIGH)", UVM_HIGH);
    `uvm_info("main", "Testbench starting (msg verbosity: LOW)", UVM_LOW);
    `uvm_info("main", "Testbench starting (msg verbosity: DEBUG)", UVM_DEBUG);
    `uvm_info("main", "Testbench starting (msg verbosity: NONE)", UVM_NONE);

    env = new("env");

    run_test();
end

endmodule
