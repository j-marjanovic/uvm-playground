

import uvm_pkg::*;
`include "uvm_macros.svh"


//==============================================================================
// interfaces

interface simple_alu_in_if (input wire clk);
    logic  [7:0]  a;
    logic  [7:0]  b;
    logic         op;
    logic         in_vld;

    modport agent (input a, b, op, in_vld);

    modport host (output a, b, op, in_vld);

endinterface


//==============================================================================
// drivers

typedef struct {
    bit [7:0] a, b;
    bit       op;
} t_data;


class in_if_driver extends uvm_driver #(t_data);

    // TODO: virtual interface

    `uvm_component_utils(in_if_driver)

    // Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    virtual task run_phase(uvm_phase phase);
    //forever begin
        `uvm_info("driver", "`run` phase", UVM_LOW);
        //seq_item_port.get_next_item(req);
        //respond_to_transfer(req);
        //drive();
        //seq_item_port.item_done();
    //end
    endtask : run_phase

endclass : in_if_driver


//==============================================================================
// environment

class env extends uvm_env;

    `uvm_component_utils(env)

    virtual simple_alu_in_if in_if;
    in_if_driver             drv;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("env", "Constructor finished", UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("env", "In the `build` phase", UVM_LOW);
        super.build_phase(phase);
        drv = in_if_driver::type_id::create("drv", this);
        // seqr = uvm_sequencer#(t_data)::type_id::create("seqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        `uvm_info("env", "In the `connect` phase", UVM_LOW);
        assert(uvm_resource_db#(virtual simple_alu_in_if)::read_by_name(
                get_full_name(), "simple_alu_in_if", in_if));
        // drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("env", "In the `run` phase", UVM_LOW);
        phase.drop_objection(this);
    endtask
endclass


//==============================================================================
// testbench

module simple_alu_tb;

bit clk;
env env;
simple_alu_in_if in_if(.clk(clk));

simple_alu DUT (
    .clk,

    // TODO: "(vopt-8637) A modport ('agent') should not be used in a hierarchical path."
    .a(in_if.agent.a),
    .b(in_if.agent.b),
    .op(in_if.agent.op),
    .in_vld(in_if.agent.in_vld)
);

initial begin: proc_main
    `uvm_info("main", "Testbench starting (msg verbosity: HIGH)", UVM_HIGH);
    `uvm_info("main", "Testbench starting (msg verbosity: LOW)", UVM_LOW);
    `uvm_info("main", "Testbench starting (msg verbosity: DEBUG)", UVM_DEBUG);
    `uvm_info("main", "Testbench starting (msg verbosity: NONE)", UVM_NONE);

    env = new("env");
    uvm_resource_db#(virtual simple_alu_in_if)::set("env", "simple_alu_in_if", in_if);

    run_test();
end

endmodule
