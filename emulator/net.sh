# 创建TAP设备  
sudo ip tuntap add dev stupidos-tap mode tap  
# 设置TAP设备的MAC地址  
sudo ip link set dev stupidos-tap address 12:34:56:65:43:21  
# 启动TAP设备  
sudo ip link set stupidos-tap up

# 创建br0
sudo ip link add name br0 type bridge
sudo ip link set dev br0 up
sudo ip link set dev stupidos-tap master br0

sudo iptables -A FORWARD -i br0 -o br0 -j ACCEPT
sudo iptables -A INPUT -i br0 -j ACCEPT
sudo iptables -A OUTPUT -o br0 -j ACCEPT
