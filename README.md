# SPI_UVM
UVM-Based verification environment to verify SPI module

# Environment Overview
![image](https://github.com/mohamedtarek54/SPI_UVM/assets/25269476/498aef5b-4767-447c-899c-d525c62a01d4)

There are four agents in this setup—two are like leaders (masters), and the other two are followers (slaves). The master agents are split into two types: active and passive. The active one handles input, checks it, and sends it to the scoreboard. The passive one watches the output and sends it to the scoreboard to compare with what the active agent sent earlier. The same thing goes on with the slave agents. Lastly, a basic subscriber is there to cover data bits just for practicing coverage.

<!-- # SPI Waveform 
![image](https://github.com/mohamedtarek54/SPI_UVM/assets/25269476/b0c1f74b-510d-4ef4-935a-946ca1085f86) -->

# How to use
add files to a project then execute the command `do run.do` in the terminal
