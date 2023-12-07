vlog rtl/*.v
vlog spi_intf.sv 

vlog spi_pkg.sv
vlog spi_top.sv +cover

vsim spi_top -voptargs=+acc -assertdebug +UVM_VERBOSITY=UVM_LOW -coverage 

add wave -position insertpoint sim:/spi_top/u_SPI_Master/*
set NoQuitOnFinish 1

run -all 
coverage report -codeAll -cvg -verbose
exit