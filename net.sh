# 创建TAP设备  
sudo ip tuntap add dev tap0 mode tap  
  
# 设置TAP设备的MAC地址  
sudo ip link set dev tap0 address 5a:5a:5a:5a:5a:5a  
  
# 启动TAP设备  
sudo ip link set tap0 up
