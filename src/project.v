/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_registers (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Internal signals to connect between registers and external paths
    wire [7:0] data_a_out;      // Output from a_register
    wire [7:0] data_b_out;      // Output from b_register
    wire [7:0] instruction_out; // Output from instruction_register

    // Instantiate a_register
    tt_um_a_register reg_a (
        .ui_in(ui_in),           // Connect input bus to ui_in
        .uo_out(data_a_out),     // Connect output to internal wire
        .uio_in(uio_in),         // Connect external IO input
        .uio_out(),              // Unused, leave unconnected
        .uio_oe(),               // Unused, leave unconnected
        .ena(ena),               // Enable signal (always 1)
        .clk(clk),               // Clock signal
        .rst_n(rst_n)            // Reset signal
    );

    // Instantiate b_register
    tt_um_b_register reg_b (
        .ui_in(ui_in),           // Connect input bus to ui_in
        .uo_out(data_b_out),     // Connect output to internal wire
        .uio_in(uio_in),         // Connect external IO input
        .uio_out(),              // Unused, leave unconnected
        .uio_oe(),               // Unused, leave unconnected
        .ena(ena),               // Enable signal (always 1)
        .clk(clk),               // Clock signal
        .rst_n(rst_n)            // Reset signal
    );

    // Instantiate instruction_register
    tt_um_instruction_register instruct_reg (
        .ui_in(ui_in),           // Connect input bus to ui_in
        .uo_out(instruction_out),// Connect output to internal wire
        .uio_in(uio_in),         // Connect external IO input
        .uio_out(),              // Unused, leave unconnected
        .uio_oe(),               // Unused, leave unconnected
        .ena(ena),               // Enable signal (always 1)
        .clk(clk),               // Clock signal
        .rst_n(rst_n)            // Reset signal
    );

    // Combine outputs from the three registers
    assign uo_out = data_a_out | data_b_out | instruction_out;

    // Set uio_out and uio_oe as 0 (unused)
    assign uio_out = 8'b0;
    assign uio_oe = 8'b0;

endmodule
