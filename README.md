# ECSE425---Computer-Architecture
Projects for ECSE 425 - Computer Architecture

This is an implementation of a pipelined processor for the course ECSE 425. I was in charge of implementing instruction memory, decode, and memory / memory access.

Additionally, I worked with a partner to connect all of the components in the pipeline.tcl file. 

Each file has a test bench to ensure accurate results are produced; however, synchronicity was not fully controlled, as the triggers were not properly selected.

pipeline.tcl contains a worked example of our incomplete pipelined processor. It can handle multiple arithmetic instructions in a row, but falters when there are branches or memory accesses. 


