onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label tb_clk -radix binary /sdram_cnt_tb/tb_clk
add wave -noupdate -label tb_rst -radix binary /sdram_cnt_tb/tb_rst
add wave -noupdate -label tb_en -radix binary /sdram_cnt_tb/tb_en
add wave -noupdate -label tb_addr -radix hexadecimal /sdram_cnt_tb/tb_addr
add wave -noupdate -label tb_data -radix hexadecimal /sdram_cnt_tb/tb_data
add wave -noupdate -label tb_we -radix binary /sdram_cnt_tb/tb_we
add wave -noupdate -label rdy -radix binary /sdram_cnt_tb/rdy
add wave -noupdate -label valid -radix binary /sdram_cnt_tb/valid
add wave -noupdate -label data_out -radix binary /sdram_cnt_tb/data_out
add wave -noupdate -label Dq_out -radix hexadecimal /sdram_cnt_tb/Dq_out
add wave -noupdate -label Dq_oe -radix hexadecimal /sdram_cnt_tb/Dq_oe
add wave -noupdate -label Dq_in -radix hexadecimal /sdram_cnt_tb/Dq_in
add wave -noupdate -label Addr -radix hexadecimal /sdram_cnt_tb/Addr
add wave -noupdate -label Ba -radix binary /sdram_cnt_tb/Ba
add wave -noupdate -label Cke -radix binary /sdram_cnt_tb/Cke
add wave -noupdate -label Cs_n -radix binary /sdram_cnt_tb/Cs_n
add wave -noupdate -label Ras_n -radix binary /sdram_cnt_tb/Ras_n
add wave -noupdate -label Cas_n -radix binary /sdram_cnt_tb/Cas_n
add wave -noupdate -label We_n -radix binary /sdram_cnt_tb/We_n
add wave -noupdate -label Dqm -radix binary /sdram_cnt_tb/Dqm
add wave -noupdate -label Dq -radix hexadecimal /sdram_cnt_tb/Dq
add wave -noupdate -label result -radix hexadecimal /sdram_cnt_tb/result
add wave -noupdate -label addr1 -radix hexadecimal /sdram_cnt_tb/addr1
add wave -noupdate -label addr2 -radix hexadecimal /sdram_cnt_tb/addr2
add wave -noupdate -label write1 -radix hexadecimal /sdram_cnt_tb/write1
add wave -noupdate -label write2 -radix hexadecimal /sdram_cnt_tb/write2
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider {SDRAM CNT}
add wave -noupdate -label clk -radix binary /sdram_cnt_tb/cnti/clk
add wave -noupdate -label rst -radix binary /sdram_cnt_tb/cnti/rst
add wave -noupdate -label en -radix binary /sdram_cnt_tb/cnti/en
add wave -noupdate -label we -radix binary /sdram_cnt_tb/cnti/we
add wave -noupdate -label addr_in -radix hexadecimal /sdram_cnt_tb/cnti/addr_in
add wave -noupdate -label data_in -radix hexadecimal /sdram_cnt_tb/cnti/data_in
add wave -noupdate -label rdy -radix binary /sdram_cnt_tb/cnti/rdy
add wave -noupdate -label data_out -radix hexadecimal /sdram_cnt_tb/cnti/data_out
add wave -noupdate -label valid -radix binary /sdram_cnt_tb/cnti/valid
add wave -noupdate -label Dq_out -radix hexadecimal /sdram_cnt_tb/cnti/Dq_out
add wave -noupdate -label Dq_oe -radix hexadecimal /sdram_cnt_tb/cnti/Dq_oe
add wave -noupdate -label Dq_in -radix hexadecimal /sdram_cnt_tb/cnti/Dq_in
add wave -noupdate -label Addr -radix hexadecimal /sdram_cnt_tb/cnti/Addr
add wave -noupdate -label Ba -radix hexadecimal /sdram_cnt_tb/cnti/Ba
add wave -noupdate -label Cke -radix binary /sdram_cnt_tb/cnti/Cke
add wave -noupdate -label Cs_n -radix binary /sdram_cnt_tb/cnti/Cs_n
add wave -noupdate -label Ras_n -radix binary /sdram_cnt_tb/cnti/Ras_n
add wave -noupdate -label Cas_n -radix binary /sdram_cnt_tb/cnti/Cas_n
add wave -noupdate -label We_n -radix binary /sdram_cnt_tb/cnti/We_n
add wave -noupdate -label Dqm -radix binary /sdram_cnt_tb/cnti/Dqm
add wave -noupdate -label state -radix unsigned /sdram_cnt_tb/cnti/state
add wave -noupdate -label next_state -radix unsigned /sdram_cnt_tb/cnti/next_state
add wave -noupdate -label ref_cnt -radix unsigned /sdram_cnt_tb/cnti/ref_cnt
add wave -noupdate -label clk_cnt -radix unsigned /sdram_cnt_tb/cnti/clk_cnt
add wave -noupdate -label cmd -radix binary /sdram_cnt_tb/cnti/cmd
add wave -noupdate -label dly_full -radix binary /sdram_cnt_tb/cnti/dly_full
add wave -noupdate -label ref_dly -radix binary /sdram_cnt_tb/cnti/ref_dly
add wave -noupdate -label ref_full -radix binary /sdram_cnt_tb/cnti/ref_full
add wave -noupdate -label idle -radix binary /sdram_cnt_tb/cnti/idle
add wave -noupdate -label ref_req -radix binary /sdram_cnt_tb/cnti/ref_req
add wave -noupdate -label ref_err -radix binary /sdram_cnt_tb/cnti/ref_err
add wave -noupdate -divider {SDRAM CNT}
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider {SDRAM Signals}
add wave -noupdate -label Dq -radix hexadecimal /sdram_cnt_tb/sdrami/Dq
add wave -noupdate -label Addr -radix hexadecimal /sdram_cnt_tb/sdrami/Addr
add wave -noupdate -label Ba -radix hexadecimal /sdram_cnt_tb/sdrami/Ba
add wave -noupdate -label Clk -radix binary /sdram_cnt_tb/sdrami/Clk
add wave -noupdate -label Dqm -radix binary /sdram_cnt_tb/sdrami/Dqm
add wave -noupdate /sdram_cnt_tb/sdrami/Act_b0
add wave -noupdate /sdram_cnt_tb/sdrami/Act_b1
add wave -noupdate /sdram_cnt_tb/sdrami/Act_b2
add wave -noupdate /sdram_cnt_tb/sdrami/Act_b3
add wave -noupdate -divider {SDRAM Signals}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {217046833 ps} 0} {{Cursor 2} {120945000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 155
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {119146912 ps} {122743088 ps}
