// mode[2:0]
`define BURST_1           3'b000
`define BURST_2           3'b001
`define BURST_4           3'b010
`define BURST_8           3'b011

// mode[3]
`define BURST_FULL        3'b111
`define BURST_SEQUENTIAL  1'b0
`define BURST_INTERLEAVED 1'b1

// mode[6:4]
`define CAS_1             3'b001
`define CAS_2             3'b010
`define CAS_3             3'b011

// mode[8:7]
`define OPMODE_STD        2'b00

// mode[9]
`define WR_BURST_PROG     1'b0
`define WR_BURST_SINGLE   1'b1

`define STATE_S0        0
`define STATE_WAIT      1
`define STATE_INIT      2
`define STATE_PRECHARGE 3
`define STATE_REFRESH   4
`define STATE_LMR       5
`define STATE_IDLE      6
`define STATE_ACTIVATE  7
`define STATE_WRITE     8
`define STATE_READ      9


`define SYSCLK 100_000_000
`define DLY_FULL (`SYSCLK/10_000)
`define REF_REQ  (`SYSCLK/150_000) // Minimum 128KHz
`define REF_FULL (`SYSCLK/128_000) // Minimum 128KHz

//CS# RAS# CAS# WE#
`define COM_INHIBIT   4'b1111
`define COM_NOP       4'b0111
`define COM_PRECHARGE 4'b0010
`define COM_REFRESH   4'b0001
`define COM_LMR       4'b0000
`define COM_ACTIVATE  4'b0011
`define COM_WRITE     4'b0100
`define COM_READ      4'b0101
