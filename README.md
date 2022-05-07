# UVM Playground

## UVM for FPGAs (Part 1): Get, Set, Go – Be Productive with UVM

https://www.aldec.com/en/support/resources/multimedia/webinars/2136

### Notes

- typical design: multiple IPs, interfaces (Avalon, AXI, ...), complex
- "FPGAs are now extremely complex"
- reasons: most widely adopted framework, same framework as for ASICs, industry standard
- FPUVM [presenter's approach on UVM]

**FPUVM example**

```systemverilog
task avl_wr_rd_test::main();

  `fp_uvm_display("Start of the test");
  vif.cb.AVALON_READ <= 1'b0;
  // ...

endtask;


initial begin
  // ...
  run_test("avl_wr_rd_test");s
end
```

- UVM approach: separation of concerns
- `uvm_object`, `uvm_component`, `uvm_driver`, `uvm_monitor`, `uvm_agent`,
  `uvm_transaction`, `uvm_sequence`, `uvm_test`, `uvm_scoreboard`

```systemverilog
class avalon_mm_xactn extends uvm_sequence_item;

  rand avalon_mm_xn_kind_e kind;
  rand bit [1:0] n_bytes;
  rand bit [3:0] n_cycles;
  bit [AVALON_DATA_W-1:0] rd_data;

  constraint cst_min_1_byte { num_bytes != 0 };

endclass
```

- TLM: transaction level modeling
- top -> env -> agent -> driver, monitor
- configuration database
- **GitHub link:** [FPUVM](github.com/svenka3/fp-uvm)
- http://www.cvcblr.com/
- `+UVM_TESTNAME` - select an individual test


## UVM for FPGAs (Part 2): Solving FPGA Verification Challenges with UVM

https://www.aldec.com/en/support/resources/multimedia/webinars/2137

- capture low-hanging fruit (mistakes in the design) in the simulation
- https://fp-uvm.blogspot.com/
- `clocking` [vs `modport`?]
- included in FPUVM: VHDL-2-SystemVerilog
- round-robin arbitration for sequences, sequencer arbitration policies
- sequence library, virtual sequences
- `covergroup`, `coverpoint`, `cross`
- https://s3.amazonaws.com/verificationhorizons.verificationacademy.com/volume-12_issue-1/complete-issue/stream/volume12-issue1-verification-horizons-publication-lr.pdf

