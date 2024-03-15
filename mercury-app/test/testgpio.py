from pynq import Overlay

overlay = Overlay('<PATH/TO/overlay.bit>')

ip = overlay.my_ip

print(ip.register_map)

ip.register_map.value = value
print(ip.register_map.ret)