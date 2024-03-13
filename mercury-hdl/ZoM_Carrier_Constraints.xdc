# ----------------------------------------------------------------------------
#     _____
#    /     \
#   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET Design Resource Center
#      \======/         www.em.avnet.com/drc
#       \====/    
# ----------------------------------------------------------------------------
# 
#  Created With Avnet UCF Generator V0.4.0 
#     Date: Wednesday, November 27, 2013 
#     Time: 2:10:18 PM 
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#  
#  Please direct any questions or issues to the MicroZed Community Forums:
#     http://www.microzed.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2013 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
#
#  Notes:
# 
#  27 November 2013
#     IO standards based upon Bank 34, Bank 35 Vcco supply options of 1.8V, 
#     2.5V, or 3.3V are possible based upon the Vadj jumper (J18) settings.  
#     By default, Vadj is expected to be set to 1.8V but if a different 
#     voltage is used for a particular design, then the corresponding IO 
#     standard within this UCF should also be updated to reflect the actual 
#     Vadj jumper selection.
# 
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.  
#     HDL net names are adjusted to contain no hyphen characters '-' but 
#     rather use underscore '_' characters.  Comment net name with the hyphen 
#     characters will remain in place since these are intended to match the 
#     schematic net names in order to better enable schematic search.
#
#     In the following, the XDC constraint is matched to the origanal UCF 
#     constraint, UCF commented out above, XDC equivalent placedbelow the UCF.
#
# ----------------------------------------------------------------------------


#NET BANK13_LVDS_0_N LOC = V7  | IOSTANDARD = LVCMOS18;  # "NSLEEP_2"
set_property PACKAGE_PIN V7 [get_ports {NSLEEP_2}]
#NET BANK13_LVDS_0_P LOC = U7  | IOSTANDARD = LVCMOS18;  # "NENBL_2"
set_property PACKAGE_PIN U7 [get_ports {NENBL_2}]
#NET BANK13_LVDS_1_N LOC = U10 | IOSTANDARD = LVCMOS18;  # "DIR_1"
set_property PACKAGE_PIN U10 [get_ports {DIR_1}]
#NET BANK13_LVDS_1_P LOC = T9  | IOSTANDARD = LVCMOS18;  # "CONFIG_1"
set_property PACKAGE_PIN T9 [get_ports {CONFIG_1}]
#NET BANK13_LVDS_2_N LOC = W8  | IOSTANDARD = LVCMOS18;  # "NSLEEP_1"
set_property PACKAGE_PIN W8 [get_ports {NSLEEP_1}]
#NET BANK13_LVDS_2_P LOC = V8  | IOSTANDARD = LVCMOS18;  # "BANK13_LVDS_2_P"
set_property PACKAGE_PIN V8 [get_ports {BANK13_LVDS_2_P}]
#NET BANK13_LVDS_3_N LOC = U5  | IOSTANDARD = LVCMOS18;  # "NENBL_1"
set_property PACKAGE_PIN U5 [get_ports {NENBL_1}]
#NET BANK13_LVDS_3_P LOC = T5  | IOSTANDARD = LVCMOS18;  # "STEP_1"
set_property PACKAGE_PIN T5 [get_ports {STEP_1}]
#NET BANK13_LVDS_4_N LOC = Y13 | IOSTANDARD = LVCMOS18;  # "Breakout2_10"
set_property PACKAGE_PIN Y13 [get_ports {Breakout2_10}]
#NET BANK13_LVDS_4_P LOC = Y12 | IOSTANDARD = LVCMOS18;  # "Breakout2_11"
set_property PACKAGE_PIN Y12 [get_ports {Breakout2_11}]
#NET BANK13_LVDS_5_N LOC = V10 | IOSTANDARD = LVCMOS18;  # "BANK13_LVDS_5_N"
set_property PACKAGE_PIN V10 [get_ports {BANK13_LVDS_5_N}]
#NET BANK13_LVDS_5_P LOC = V11 | IOSTANDARD = LVCMOS18;  # "Breakout1_14"
set_property PACKAGE_PIN V11 [get_ports {Breakout1_14}]
#NET BANK13_LVDS_6_N LOC = W6  | IOSTANDARD = LVCMOS18;  # "Breakout2_8"
set_property PACKAGE_PIN W6 [get_ports {Breakout2_8}]
#NET BANK13_LVDS_6_P LOC = V6  | IOSTANDARD = LVCMOS18;  # "Breakout2_9"
set_property PACKAGE_PIN V6 [get_ports {Breakout2_9}]
#NET BANK13_SE_0     LOC = V5  | IOSTANDARD = LVCMOS18;  # "BANK13_SE_0"
set_property PACKAGE_PIN V5 [get_ports {BANK13_SE_0}]

# Bank 13, Vcco = Vadj 
# Set the bank voltage for bank 13.
set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 13 } ]

#NET JX1_LVDS_0_N    LOC = T10 | IOSTANDARD = LVCMOS18;  # "DAC_1_INB"
set_property PACKAGE_PIN T10 [get_ports {DAC_1_INB}]
#NET JX1_LVDS_0_P    LOC = T11 | IOSTANDARD = LVCMOS18;  # "DAC_1_INA"
set_property PACKAGE_PIN T11 [get_ports {DAC_1_INA}]
#NET JX1_LVDS_1_N    LOC = U12 | IOSTANDARD = LVCMOS18;  # "Limit_SW_4"
set_property PACKAGE_PIN U12 [get_ports {Limit_SW_4}]
#NET JX1_LVDS_1_P    LOC = T12 | IOSTANDARD = LVCMOS18;  # "Limit_SW_3"
set_property PACKAGE_PIN T12 [get_ports {Limit_SW_3}]
#NET JX1_LVDS_10_N   LOC = U15 | IOSTANDARD = LVCMOS18;  # "NSLEEP_4"
set_property PACKAGE_PIN U15 [get_ports {NSLEEP_4}]
#NET JX1_LVDS_10_P   LOC = U14 | IOSTANDARD = LVCMOS18;  # "NENBL_4"
set_property PACKAGE_PIN U14 [get_ports {NENBL_4}]
#NET JX1_LVDS_11_N   LOC = U19 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_3"
set_property PACKAGE_PIN U19 [get_ports {Sensor_IO_3}]
#NET JX1_LVDS_11_P   LOC = U18 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_4"
set_property PACKAGE_PIN U18 [get_ports {Sensor_IO_4}]
#NET JX1_LVDS_12_N   LOC = P19 | IOSTANDARD = LVCMOS18;  # "M1_3"
set_property PACKAGE_PIN P19 [get_ports {M1_3}]
#NET JX1_LVDS_12_P   LOC = N18 | IOSTANDARD = LVCMOS18;  # "M0_3"
set_property PACKAGE_PIN N18 [get_ports {M0_3}]
#NET JX1_LVDS_13_N   LOC = P20 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_1"
set_property PACKAGE_PIN P20 [get_ports {Sensor_IO_1}]
#NET JX1_LVDS_13_P   LOC = N20 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_2"
set_property PACKAGE_PIN N20 [get_ports {Sensor_IO_2}]
#NET JX1_LVDS_14_N   LOC = U20 | IOSTANDARD = LVCMOS18;  # "DIR_3"
set_property PACKAGE_PIN U20 [get_ports {DIR_3}]
#NET JX1_LVDS_14_P   LOC = T20 | IOSTANDARD = LVCMOS18;  # "CONFIG_3"
set_property PACKAGE_PIN T20 [get_ports {CONFIG_3}]
#NET JX1_LVDS_15_N   LOC = W20 | IOSTANDARD = LVCMOS18;  # "NSLEEP_5"
set_property PACKAGE_PIN W20 [get_ports {NSLEEP_5}]
#NET JX1_LVDS_15_P   LOC = V20 | IOSTANDARD = LVCMOS18;  # "Servo_PWM"
set_property PACKAGE_PIN V20 [get_ports {Servo_PWM}]
#NET JX1_LVDS_16_N   LOC = Y19 | IOSTANDARD = LVCMOS18;  # "NENBL_3"
set_property PACKAGE_PIN Y19 [get_ports {NENBL_3}]
#NET JX1_LVDS_16_P   LOC = Y18 | IOSTANDARD = LVCMOS18;  # "STEP_3"
set_property PACKAGE_PIN Y18 [get_ports {STEP_3}]
#NET JX1_LVDS_17_N   LOC = W16 | IOSTANDARD = LVCMOS18;  # "STEP_5"
set_property PACKAGE_PIN W16 [get_ports {STEP_5}]
#NET JX1_LVDS_17_P   LOC = V16 | IOSTANDARD = LVCMOS18;  # "NENBL_5"
set_property PACKAGE_PIN V16 [get_ports {NENBL_5}]
#NET JX1_LVDS_18_N   LOC = R17 | IOSTANDARD = LVCMOS18;  # "M0_2"
set_property PACKAGE_PIN R17 [get_ports {M0_2}]
#NET JX1_LVDS_18_P   LOC = R16 | IOSTANDARD = LVCMOS18;  # "NSLEEP_3"
set_property PACKAGE_PIN R16 [get_ports {NSLEEP_3}]
#NET JX1_LVDS_19_N   LOC = R18 | IOSTANDARD = LVCMOS18;  # "CONFIG_5"
set_property PACKAGE_PIN R18 [get_ports {CONFIG_5}]
#NET JX1_LVDS_19_P   LOC = T17 | IOSTANDARD = LVCMOS18;  # "DIR_5"
set_property PACKAGE_PIN T17 [get_ports {DIR_5}]
#NET JX1_LVDS_2_N    LOC = V13 | IOSTANDARD = LVCMOS18;  # "DAC_2_INA"
set_property PACKAGE_PIN V13 [get_ports {DAC_2_INA}]
#NET JX1_LVDS_2_P    LOC = U13 | IOSTANDARD = LVCMOS18;  # "JX1_LVDS_2_P"
set_property PACKAGE_PIN U13 [get_ports {JX1_LVDS_2_P}]
#NET JX1_LVDS_20_N   LOC = V18 | IOSTANDARD = LVCMOS18;  # "CONFIG_2"
set_property PACKAGE_PIN V18 [get_ports {CONFIG_2}]
#NET JX1_LVDS_20_P   LOC = V17 | IOSTANDARD = LVCMOS18;  # "M1_2"
set_property PACKAGE_PIN V17 [get_ports {M1_2}]
#NET JX1_LVDS_21_N   LOC = W19 | IOSTANDARD = LVCMOS18;  # "M0_5"
set_property PACKAGE_PIN W19 [get_ports {M0_5}]
#NET JX1_LVDS_21_P   LOC = W18 | IOSTANDARD = LVCMOS18;  # "M1_5"
set_property PACKAGE_PIN W18 [get_ports {M1_5}]
#NET JX1_LVDS_22_N   LOC = P18 | IOSTANDARD = LVCMOS18;  # "STEP_2"
set_property PACKAGE_PIN P18 [get_ports {STEP_2}]
#NET JX1_LVDS_22_P   LOC = N17 | IOSTANDARD = LVCMOS18;  # "DIR_2"
set_property PACKAGE_PIN N17 [get_ports {DIR_2}]
#NET JX1_LVDS_23_N   LOC = P16 | IOSTANDARD = LVCMOS18;  # "M1_1"
set_property PACKAGE_PIN P16 [get_ports {M1_1}]
#NET JX1_LVDS_23_P   LOC = P15 | IOSTANDARD = LVCMOS18;  # "M0_1"
set_property PACKAGE_PIN P15 [get_ports {M0_1}]
#NET JX1_LVDS_3_N    LOC = W13 | IOSTANDARD = LVCMOS18;  # "Limit_SW_1"
set_property PACKAGE_PIN W13 [get_ports {Limit_SW_1}]
#NET JX1_LVDS_3_P    LOC = V12 | IOSTANDARD = LVCMOS18;  # "Limit_SW_2"
set_property PACKAGE_PIN V12 [get_ports {Limit_SW_2}]
#NET JX1_LVDS_4_N    LOC = T15 | IOSTANDARD = LVCMOS18;  # "M0_4"
set_property PACKAGE_PIN T15 [get_ports {M0_4}]
#NET JX1_LVDS_4_P    LOC = T14 | IOSTANDARD = LVCMOS18;  # "DAC_2_INB"
set_property PACKAGE_PIN T14 [get_ports {DAC_2_INB}]
#NET JX1_LVDS_5_N    LOC = R14 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_9"
set_property PACKAGE_PIN R14 [get_ports {Sensor_IO_9}]
#NET JX1_LVDS_5_P    LOC = P14 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_10"
set_property PACKAGE_PIN P14 [get_ports {Sensor_IO_10}]
#NET JX1_LVDS_6_N    LOC = Y17 | IOSTANDARD = LVCMOS18;  # "CONFIG_4"
set_property PACKAGE_PIN Y17 [get_ports {CONFIG_4}]
#NET JX1_LVDS_6_P    LOC = Y16 | IOSTANDARD = LVCMOS18;  # "M1_4"
set_property PACKAGE_PIN Y16 [get_ports {M1_4}]
#NET JX1_LVDS_7_N    LOC = Y14 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_7"
set_property PACKAGE_PIN Y14 [get_ports {Sensor_IO_7}]
#NET JX1_LVDS_7_P    LOC = W14 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_8"
set_property PACKAGE_PIN W14 [get_ports {Sensor_IO_8}]
#NET JX1_LVDS_8_N    LOC = U17 | IOSTANDARD = LVCMOS18;  # "STEP_4"
set_property PACKAGE_PIN U17 [get_ports {STEP_4}]
#NET JX1_LVDS_8_P    LOC = T16 | IOSTANDARD = LVCMOS18;  # "DIR_4"
set_property PACKAGE_PIN T16 [get_ports {DIR_4}]
#NET JX1_LVDS_9_N    LOC = W15 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_5"
set_property PACKAGE_PIN W15 [get_ports {Sensor_IO_5}]
#NET JX1_LVDS_9_P    LOC = V15 | IOSTANDARD = LVCMOS18;  # "Sensor_IO_6"
set_property PACKAGE_PIN V15 [get_ports {Sensor_IO_6}]
#NET JX1_SE_0        LOC = R19 | IOSTANDARD = LVCMOS18;  # "JX1_SE_0"
set_property PACKAGE_PIN R19 [get_ports {JX1_SE_0}]
#NET JX1_SE_1        LOC = T19 | IOSTANDARD = LVCMOS18;  # "JX1_SE_1"
set_property PACKAGE_PIN T19 [get_ports {JX1_SE_1}]

# Bank 34, Vcco = Vadj
# Set the bank voltage for bank 34.
set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 34 } ]

#NET JX2_LVDS_0_N    LOC = B20 | IOSTANDARD = LVCMOS18;  # "Speed_SNS_3"
set_property PACKAGE_PIN B20 [get_ports {Speed_SNS_3}]
#NET JX2_LVDS_0_P    LOC = C20 | IOSTANDARD = LVCMOS18;  # "Speed_SNS_4"
set_property PACKAGE_PIN C20 [get_ports {Speed_SNS_4}]
#NET JX2_LVDS_1_N    LOC = A20 | IOSTANDARD = LVCMOS18;  # "Flood_Light_2"
set_property PACKAGE_PIN A20 [get_ports {Flood_Light_2}]
#NET JX2_LVDS_1_P    LOC = B19 | IOSTANDARD = LVCMOS18;  # "Flood_Light_1"
set_property PACKAGE_PIN B19 [get_ports {Flood_Light_1}]
#NET JX2_LVDS_10_N   LOC = L17 | IOSTANDARD = LVCMOS18;  # "Spare_4"
set_property PACKAGE_PIN L17 [get_ports {Spare_4}]
#NET JX2_LVDS_10_P   LOC = L16 | IOSTANDARD = LVCMOS18;  # "Spare_3"
set_property PACKAGE_PIN L16 [get_ports {Spare_3}]
#NET JX2_LVDS_11_N   LOC = K18 | IOSTANDARD = LVCMOS18;  # "Breakout2_1"
set_property PACKAGE_PIN K18 [get_ports {Breakout2_1}]
#NET JX2_LVDS_11_P   LOC = K17 | IOSTANDARD = LVCMOS18;  # "Breakout1_7"
set_property PACKAGE_PIN K17 [get_ports {Breakout1_7}]
#NET JX2_LVDS_12_N   LOC = H17 | IOSTANDARD = LVCMOS18;  # "Spare_6"
set_property PACKAGE_PIN H17 [get_ports {Spare_6}]
#NET JX2_LVDS_12_P   LOC = H16 | IOSTANDARD = LVCMOS18;  # "Spare_5"
set_property PACKAGE_PIN H16 [get_ports {Spare_5}]
#NET JX2_LVDS_13_N   LOC = H18 | IOSTANDARD = LVCMOS18;  # "Breakout2_3"
set_property PACKAGE_PIN H18 [get_ports {Breakout2_3}]
#NET JX2_LVDS_13_P   LOC = J18 | IOSTANDARD = LVCMOS18;  # "Breakout2_2"
set_property PACKAGE_PIN J18 [get_ports {Breakout2_2}]
#NET JX2_LVDS_14_N   LOC = G18 | IOSTANDARD = LVCMOS18;  # "Spare_8"
set_property PACKAGE_PIN G18 [get_ports {Spare_8}]
#NET JX2_LVDS_14_P   LOC = G17 | IOSTANDARD = LVCMOS18;  # "Spare_7"
set_property PACKAGE_PIN G17 [get_ports {Spare_7}]
#NET JX2_LVDS_15_N   LOC = F20 | IOSTANDARD = LVCMOS18;  # "Breakout2_5"
set_property PACKAGE_PIN F20 [get_ports {Breakout2_5}]
#NET JX2_LVDS_15_P   LOC = F19 | IOSTANDARD = LVCMOS18;  # "Breakout2_4"
set_property PACKAGE_PIN F19 [get_ports {Breakout2_4}]
#NET JX2_LVDS_16_N   LOC = G20 | IOSTANDARD = LVCMOS18;  # "Spare_10"
set_property PACKAGE_PIN G20 [get_ports {Spare_10}]
#NET JX2_LVDS_16_P   LOC = G19 | IOSTANDARD = LVCMOS18;  # "Spare_9"
set_property PACKAGE_PIN G19 [get_ports {Spare_9}]
#NET JX2_LVDS_17_N   LOC = H20 | IOSTANDARD = LVCMOS18;  # "Breakout2_7"
set_property PACKAGE_PIN H20 [get_ports {Breakout2_6}]
#NET JX2_LVDS_17_P   LOC = J20 | IOSTANDARD = LVCMOS18;  # "Breakout2_6"
set_property PACKAGE_PIN J20 [get_ports {Breakout2_6}]
#NET JX2_LVDS_18_N   LOC = J14 | IOSTANDARD = LVCMOS18;  # "Spare_12"
set_property PACKAGE_PIN J14 [get_ports {Spare_12}]
#NET JX2_LVDS_18_P   LOC = K14 | IOSTANDARD = LVCMOS18;  # "Spare_11"
set_property PACKAGE_PIN K14 [get_ports {Spare_11}]
#NET JX2_LVDS_19_N   LOC = G15 | IOSTANDARD = LVCMOS18;  # "Breakout1_9"
set_property PACKAGE_PIN G15 [get_ports {Breakout1_9}]
#NET JX2_LVDS_19_P   LOC = H15 | IOSTANDARD = LVCMOS18;  # "Breakout1_8"
set_property PACKAGE_PIN H15 [get_ports {Breakout1_8}]
#NET JX2_LVDS_2_N    LOC = D18 | IOSTANDARD = LVCMOS18;  # "Speed_SNS_1"
set_property PACKAGE_PIN D18 [get_ports {Speed_SNS_1}]
#NET JX2_LVDS_2_P    LOC = E17 | IOSTANDARD = LVCMOS18;  # "Speed_SNS_2"
set_property PACKAGE_PIN E17 [get_ports {Speed_SNS_2}]
#NET JX2_LVDS_20_N   LOC = N16 | IOSTANDARD = LVCMOS18;  # "Breakout2_14"
set_property PACKAGE_PIN N16 [get_ports {Breakout2_14}]
#NET JX2_LVDS_20_P   LOC = N15 | IOSTANDARD = LVCMOS18;  # "Spare_13"
set_property PACKAGE_PIN N15 [get_ports {Spare_13}]
#NET JX2_LVDS_21_N   LOC = L15 | IOSTANDARD = LVCMOS18;  # "Breakout1_11"
set_property PACKAGE_PIN L15 [get_ports {Breakout1_11}]
#NET JX2_LVDS_21_P   LOC = L14 | IOSTANDARD = LVCMOS18;  # "Breakout1_12"
set_property PACKAGE_PIN L14 [get_ports {Breakout1_12}]
#NET JX2_LVDS_22_N   LOC = M15 | IOSTANDARD = LVCMOS18;  # "Breakout2_12"
set_property PACKAGE_PIN M15 [get_ports {Breakout2_12}]
#NET JX2_LVDS_22_P   LOC = M14 | IOSTANDARD = LVCMOS18;  # "Breakout2_13"
set_property PACKAGE_PIN M14 [get_ports {Breakout2_13}]
#NET JX2_LVDS_23_N   LOC = J16 | IOSTANDARD = LVCMOS18;  # "Breakout1_13"
set_property PACKAGE_PIN J16 [get_ports {Breakout1_13}]
#NET JX2_LVDS_23_P   LOC = K16 | IOSTANDARD = LVCMOS18;  # "Breakout1_12"
set_property PACKAGE_PIN K16 [get_ports {Breakout1_12}]
#NET JX2_LVDS_3_N    LOC = D20 | IOSTANDARD = LVCMOS18;  # "Flood_Light_4"
set_property PACKAGE_PIN D20 [get_ports {Flood_Light_4}]
#NET JX2_LVDS_3_P    LOC = D19 | IOSTANDARD = LVCMOS18;  # "Flood_Light_3"
set_property PACKAGE_PIN D19 [get_ports {Flood_Light_3}]
#NET JX2_LVDS_4_N    LOC = E19 | IOSTANDARD = LVCMOS18;  # "Drive_EN_2"
set_property PACKAGE_PIN E19 [get_ports {Drive_DIR_2}]
#NET JX2_LVDS_4_P    LOC = E18 | IOSTANDARD = LVCMOS18;  # "Drive_EN_1"
set_property PACKAGE_PIN E18 [get_ports {Drive_DIR_1}]
#NET JX2_LVDS_5_N    LOC = F17 | IOSTANDARD = LVCMOS18;  # "Breakout1_2"
set_property PACKAGE_PIN F17 [get_ports {Breakout1_2}]
#NET JX2_LVDS_5_P    LOC = F16 | IOSTANDARD = LVCMOS18;  # "Breakout1_1"
set_property PACKAGE_PIN F16 [get_ports {Breakout1_1}]
#NET JX2_LVDS_6_N    LOC = L20 | IOSTANDARD = LVCMOS18;  # "Drive_EN_4"
set_property PACKAGE_PIN L20 [get_ports {Drive_DIR_4}]
#NET JX2_LVDS_6_P    LOC = L19 | IOSTANDARD = LVCMOS18;  # "Drive_EN_3"
set_property PACKAGE_PIN L19 [get_ports {Drive_DIR_3}]
#NET JX2_LVDS_7_N    LOC = M20 | IOSTANDARD = LVCMOS18;  # "Breakout1_4"
set_property PACKAGE_PIN M20 [get_ports {Breakout1_4}]
#NET JX2_LVDS_7_P    LOC = M19 | IOSTANDARD = LVCMOS18;  # "Breakout1_3"
set_property PACKAGE_PIN M19 [get_ports {Breakout1_3}]
#NET JX2_LVDS_8_N    LOC = M18 | IOSTANDARD = LVCMOS18;  # "Spare_2"
set_property PACKAGE_PIN M18 [get_ports {Spare_2}]
#NET JX2_LVDS_8_P    LOC = M17 | IOSTANDARD = LVCMOS18;  # "Spare_1"
set_property PACKAGE_PIN M17 [get_ports {Spare_1}]
#set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { Spare_1 }];
#NET JX2_LVDS_9_N    LOC = J19 | IOSTANDARD = LVCMOS18;  # "Breakout1_6"
set_property PACKAGE_PIN J19 [get_ports {Breakout1_6}]
#NET JX2_LVDS_9_P    LOC = K19 | IOSTANDARD = LVCMOS18;  # "Breakout1_5"
set_property PACKAGE_PIN K19 [get_ports {Breakout1_5}]
#NET JX2_SE_0        LOC = G14 | IOSTANDARD = LVCMOS18;  # "JX2_SE_0"
set_property PACKAGE_PIN G14 [get_ports {JX2_SE_0}]
#NET JX2_SE_1        LOC = J15 | IOSTANDARD = LVCMOS18;  # "JX2_SE_1"
set_property PACKAGE_PIN J15 [get_ports {JX2_SE_1}]

# Bank 35, Vcco = Vadj
# Set the bank voltage for bank 35.
set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 35 } ]
