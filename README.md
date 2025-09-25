# OPEN_SPECTRE
## An open-source FPGA-based EMS SPECTRE video synth.
*A project aimed at recreating the EMS SPECTRE VIDEO SYNTHESIZER in HDL*

###  ✨The EMS SPECTRE Colour Video ✨
>Synthesizer is a unique and revolutionary new product: an instrument capable of producing exciting graphic images on an ordinary television screen. The complete SPECTRE package consists of the synthesizer itself, plus a Sony Trinitron colour monitor, and a Sony black-and-white TV camera. The synthesizer is compact (38"x23.5"x7"), portable (about 35 pounds/15.9KG), and unequalled in its simplicity and versatility.

![EMS SPECTRE](/Spectron%20Resources/Product%20Photos/spectre1.jpg)

### Design Info
#### 🎉Aim 🎉
The aim of this project is to preserve this rare and unique video synth by recreating it in an FPGA, but also to use it as a building block to make a Spectre that is both true to the original and also a modern tool for creativity.
For more info in this process take a look at: 
[Cloning Hardware Ethos](documentation/Cloning%20a%20process%20not%20a%20device.md)

### 🍣Want to Contribute?🍣
Amazing! If you have FPGA and or Verilog/VHDL skills we would love to have you involved. But, first, there are a few things you should know. 
#### What to do first
- Look through the resources folder to get an idea of what the EMS SPECTRE is and how it works
- Look at the top-level diagram and the list of modules
#### Project Details For Contributors
- RTL in VHDL or Verilog (VHDL preferred, no system Verilog 😎 sorry) 
- One module per file with a separate testbench (Verilog or VHDL test benches only, *not everything has one yet, but it should)
- Test benches should print out a message at the end confirming if they are successful or not
- No HSL or auto-generated code, no busses or interfaces for now (will be busses later)
- Use any software you like, but a Vivado project will be supplied
- Follow the template for file headers and comments 📑
- Follow the folder structure for the project 📂
- All code must be open source or MIT license 👍

#### If after all that you still want to be involved you can do one of three things:
- Email us at *OPEN.SPECTRE.PROJECT@gmail.com* and see what modules we need to make at the moment
- Branch the repo, make a module, and submit a pull request 
- If you are not any good at git/GitHub, if you write any modules you can email them to us and we will integrate them into the project

### 🐙License🐙
Creative Commons CC BY-NC

### Contributors
-Remi Freer
-Jacob Stoker
-Robert D Jordan

### Donations
We are very thankful to have received donations from the following people:
Chris Korvin,
Jay Hotchin,
Milton Grimshaw, and more amazing anonymous people. 
