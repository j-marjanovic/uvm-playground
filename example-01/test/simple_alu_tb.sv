

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

class t_data extends uvm_sequence_item;
    rand bit [7:0] a, b;
    rand bit       op;

    function new(string name = "t_data");
        super.new(name);
    endfunction

    `uvm_object_utils_begin( t_data )
        `uvm_field_int ( a, UVM_ALL_ON )
        `uvm_field_int ( b, UVM_ALL_ON )
    `uvm_object_utils_end
endclass


class in_if_driver extends uvm_driver #(t_data);

    // TODO: virtual interface

    `uvm_component_utils(in_if_driver)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual task run_phase(uvm_phase phase);
    forever begin
        `uvm_info("driver", "`run` phase", UVM_LOW);
        seq_item_port.get_next_item(req);
        //respond_to_transfer(req);
        // TODO: drive();
        seq_item_port.item_done();
    end
    endtask : run_phase

endclass : in_if_driver


//==============================================================================
// sequencer

class simple_alu_seqr extends uvm_sequencer #(t_data);
    `uvm_component_utils(simple_alu_seqr)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass


//==============================================================================
// environment

class env extends uvm_env;

    `uvm_component_utils(env)

    virtual simple_alu_in_if m_in_if;
    in_if_driver             m_drv;
    simple_alu_seqr          m_seqr;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("env", "Constructor finished", UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("env", "In the `build` phase", UVM_LOW);
        super.build_phase(phase);
        m_drv = in_if_driver::type_id::create("drv", this);
        m_seqr = simple_alu_seqr::type_id::create("seqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        `uvm_info("env", "In the `connect` phase", UVM_LOW);
        assert(uvm_resource_db#(virtual simple_alu_in_if)::read_by_name(
                get_full_name(), "simple_alu_in_if", m_in_if));
        m_drv.seq_item_port.connect(m_seqr.seq_item_export);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("env", "In the `run` phase", UVM_LOW);
        phase.drop_objection(this);
    endtask
endclass

//==============================================================================
// sequence

class simple_alu_seq extends uvm_sequence #(t_data);

    `uvm_object_utils(simple_alu_seq)

    function new(string name="");
        super.new(name);
    endfunction

    task body();
        t_data data;
        start_item(data);
        //assert(data.randomize());
        finish_item(data);
        //`uvm_do(data);
    endtask
endclass


//==============================================================================
// test

class simple_alu_test extends uvm_test;

    `uvm_component_utils(simple_alu_test)

    env m_env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_env = env::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase (uvm_phase phase);
        uvm_top.print_topology();
    endfunction


    task run_phase(uvm_phase phase);
        simple_alu_seq seq;
        `uvm_info("test", "In the `run` phase", UVM_LOW);
        phase.raise_objection(this);
        seq = simple_alu_seq::type_id::create("seq1");
        seq.start(m_env.m_seqr);
        phase.drop_objection(this);
    endtask
endclass

//==============================================================================
// testbench

module simple_alu_tb;

bit clk;
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

    uvm_resource_db#(virtual simple_alu_in_if)::set("env", "simple_alu_in_if", in_if);

    run_test("simple_alu_test");
end

endmodule
