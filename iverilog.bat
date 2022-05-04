echo "开始编译"
iverilog -o wave led_demo.v led_demo_tb.v
echo "编译完成"
vvp -n wave -lxt2
echo "生成波形文件"
cp wave.vcd wave.lxt
echo "打开波形文件"
gtkwave wave.lxt