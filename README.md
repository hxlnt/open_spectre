Work in progress, read me


tested_modules:

DIGITAL SIDE:
  --> pin_matrix: or_matrix_full (not TB but tested and passed)
  --> XY invert logic: xor18(passed)
  --> low_counter: slow_counter (passed)
      --> pulse_generator (unverified)
  --> Overlay gates: nand4 (passed)
  
  --> inverters: invert_4 (passed)
  --> delay_800: delay_800us (needs test bench, current method is FIFO for delay)
  --> edge detect: monostable_4 (passed)
  --> flip_flop*: D_filimflop_ext (passed)
  
  --> Matrix input inverters: xor_n (passed)
  
  --> Chroma output mux: muc_5 (passed)
  
  --> Comparitor: compare_7 (not passing)
      --> wc_*: window_comparitor (passed)
