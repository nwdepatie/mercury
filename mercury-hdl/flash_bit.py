from pynq import Overlay

overlay = Overlay('./overlays/mercury.bit', './overlays/mercury.hwh')

for i in overlay.ip_dict:
    print(i)

#ip = overlay.axi_gpio_0

# Retrieve the base address property of the IP block
#base_address = ip.register_map.mmio.base_addr

# Print the base address
#print(f"Base Address of IP block: {base_address}")

#ip.register_map.value = value
#print(ip.register_map.ret)
