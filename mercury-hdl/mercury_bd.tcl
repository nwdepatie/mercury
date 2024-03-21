
################################################################
# This is a generated script based on design: mercury
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source mercury_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART avnet.com:microzed_7020:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name mercury

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:axi_timer:2.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: drive
proc create_hier_cell_drive { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_drive() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI4


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O DAC_1_INA
  create_bd_pin -dir O DAC_1_INB
  create_bd_pin -dir O DAC_2_INA
  create_bd_pin -dir O DAC_2_INB
  create_bd_pin -dir O -from 0 -to 0 Drive_DIR_1
  create_bd_pin -dir O -from 0 -to 0 Drive_DIR_3

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]

  # Create instance: axi_timer_1, and set properties
  set axi_timer_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_1 ]

  # Create instance: axi_timer_2, and set properties
  set axi_timer_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_2 ]

  # Create instance: axi_timer_3, and set properties
  set axi_timer_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_3 ]

  # Create instance: axi_gpio_2, and set properties
  set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_DOUT_DEFAULT {0xFFFFFFFF} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_2


  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axi_timer_1/S_AXI] [get_bd_intf_pins S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axi_timer_2/S_AXI] [get_bd_intf_pins S_AXI1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins axi_timer_3/S_AXI] [get_bd_intf_pins S_AXI2]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins axi_gpio_2/S_AXI] [get_bd_intf_pins S_AXI3]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins S_AXI4]

  # Create port connections
  connect_bd_net -net axi_gpio_2_gpio2_io_o [get_bd_pins axi_gpio_2/gpio2_io_o] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins axi_gpio_2/gpio_io_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net axi_timer_0_pwm0 [get_bd_pins axi_timer_0/pwm0] [get_bd_pins DAC_1_INA]
  connect_bd_net -net axi_timer_1_pwm0 [get_bd_pins axi_timer_1/pwm0] [get_bd_pins DAC_1_INB]
  connect_bd_net -net axi_timer_2_pwm0 [get_bd_pins axi_timer_2/pwm0] [get_bd_pins DAC_2_INA]
  connect_bd_net -net axi_timer_3_pwm0 [get_bd_pins axi_timer_3/pwm0] [get_bd_pins DAC_2_INB]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_timer_1/s_axi_aclk] [get_bd_pins axi_timer_2/s_axi_aclk] [get_bd_pins axi_timer_3/s_axi_aclk] [get_bd_pins axi_gpio_2/s_axi_aclk] [get_bd_pins axi_timer_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_timer_1/s_axi_aresetn] [get_bd_pins axi_timer_3/s_axi_aresetn] [get_bd_pins axi_timer_2/s_axi_aresetn] [get_bd_pins axi_gpio_2/s_axi_aresetn] [get_bd_pins axi_timer_0/s_axi_aresetn]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlslice_0/Dout] [get_bd_pins Drive_DIR_1]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlslice_1/Dout] [get_bd_pins Drive_DIR_3]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: GPIO_Slicer
proc create_hier_cell_GPIO_Slicer { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_GPIO_Slicer() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 GPIO_buf
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_1
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_2
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_3
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_4
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_5
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_6
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_7
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_8
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_9
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_10
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_11
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_12
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_13
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_14
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_15
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_16
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_17
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_18
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_19
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_20
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_21
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_22
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_23
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_24
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_25
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_26
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_27
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_28
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_29
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_30
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_31
  create_bd_pin -dir O -from 0 -to 0 GPIO_buf_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property CONFIG.DIN_TO {1} $xlslice_1


  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
  ] $xlslice_2


  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
  ] $xlslice_3


  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {4} \
    CONFIG.DIN_TO {4} \
  ] $xlslice_4


  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {5} \
    CONFIG.DIN_TO {5} \
  ] $xlslice_5


  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {6} \
    CONFIG.DIN_TO {6} \
  ] $xlslice_6


  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {7} \
  ] $xlslice_7


  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {8} \
    CONFIG.DIN_TO {8} \
  ] $xlslice_8


  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {9} \
    CONFIG.DIN_TO {9} \
  ] $xlslice_9


  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {10} \
    CONFIG.DIN_TO {10} \
  ] $xlslice_10


  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {11} \
    CONFIG.DIN_TO {11} \
  ] $xlslice_11


  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {12} \
    CONFIG.DIN_TO {12} \
  ] $xlslice_12


  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {13} \
    CONFIG.DIN_TO {13} \
  ] $xlslice_13


  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {14} \
    CONFIG.DIN_TO {14} \
  ] $xlslice_14


  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {15} \
    CONFIG.DIN_TO {15} \
  ] $xlslice_15


  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {16} \
    CONFIG.DIN_TO {16} \
  ] $xlslice_16


  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {17} \
    CONFIG.DIN_TO {17} \
  ] $xlslice_17


  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {18} \
    CONFIG.DIN_TO {18} \
  ] $xlslice_18


  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {19} \
    CONFIG.DIN_TO {19} \
  ] $xlslice_19


  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {20} \
    CONFIG.DIN_TO {20} \
  ] $xlslice_20


  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {21} \
    CONFIG.DIN_TO {21} \
  ] $xlslice_21


  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {22} \
    CONFIG.DIN_TO {22} \
  ] $xlslice_22


  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DIN_TO {23} \
  ] $xlslice_23


  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {24} \
    CONFIG.DIN_TO {24} \
  ] $xlslice_24


  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {25} \
    CONFIG.DIN_TO {25} \
  ] $xlslice_25


  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {26} \
    CONFIG.DIN_TO {26} \
  ] $xlslice_26


  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {27} \
    CONFIG.DIN_TO {27} \
  ] $xlslice_27


  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {28} \
    CONFIG.DIN_TO {28} \
  ] $xlslice_28


  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {29} \
    CONFIG.DIN_TO {29} \
  ] $xlslice_29


  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {30} \
    CONFIG.DIN_TO {30} \
  ] $xlslice_30


  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {31} \
    CONFIG.DIN_TO {31} \
  ] $xlslice_31


  # Create port connections
  connect_bd_net -net GPIO_buf_1 [get_bd_pins GPIO_buf] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_25/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlslice_0/Dout] [get_bd_pins GPIO_buf_0]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlslice_10/Dout] [get_bd_pins GPIO_buf_10]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlslice_11/Dout] [get_bd_pins GPIO_buf_11]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlslice_12/Dout] [get_bd_pins GPIO_buf_12]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlslice_13/Dout] [get_bd_pins GPIO_buf_13]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlslice_14/Dout] [get_bd_pins GPIO_buf_14]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlslice_15/Dout] [get_bd_pins GPIO_buf_15]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlslice_16/Dout] [get_bd_pins GPIO_buf_16]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlslice_17/Dout] [get_bd_pins GPIO_buf_17]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlslice_18/Dout] [get_bd_pins GPIO_buf_18]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlslice_19/Dout] [get_bd_pins GPIO_buf_19]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlslice_1/Dout] [get_bd_pins GPIO_buf_1]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlslice_20/Dout] [get_bd_pins GPIO_buf_20]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlslice_21/Dout] [get_bd_pins GPIO_buf_21]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlslice_22/Dout] [get_bd_pins GPIO_buf_22]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlslice_23/Dout] [get_bd_pins GPIO_buf_23]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlslice_24/Dout] [get_bd_pins GPIO_buf_24]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlslice_25/Dout] [get_bd_pins GPIO_buf_25]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlslice_26/Dout] [get_bd_pins GPIO_buf_26]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlslice_27/Dout] [get_bd_pins GPIO_buf_27]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlslice_28/Dout] [get_bd_pins GPIO_buf_28]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlslice_29/Dout] [get_bd_pins GPIO_buf_29]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlslice_2/Dout] [get_bd_pins GPIO_buf_2]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlslice_30/Dout] [get_bd_pins GPIO_buf_30]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlslice_31/Dout] [get_bd_pins GPIO_buf_31]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlslice_3/Dout] [get_bd_pins GPIO_buf_3]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlslice_4/Dout] [get_bd_pins GPIO_buf_4]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlslice_5/Dout] [get_bd_pins GPIO_buf_5]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlslice_6/Dout] [get_bd_pins GPIO_buf_6]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlslice_7/Dout] [get_bd_pins GPIO_buf_7]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlslice_8/Dout] [get_bd_pins GPIO_buf_8]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlslice_9/Dout] [get_bd_pins GPIO_buf_9]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports
  set DAC_1_INA [ create_bd_port -dir O -type data DAC_1_INA ]
  set DAC_1_INB [ create_bd_port -dir O -type data DAC_1_INB ]
  set DAC_2_INA [ create_bd_port -dir O -type data DAC_2_INA ]
  set DAC_2_INB [ create_bd_port -dir O -type data DAC_2_INB ]
  set M0_1 [ create_bd_port -dir O -from 0 -to 0 M0_1 ]
  set M1_1 [ create_bd_port -dir O -from 0 -to 0 M1_1 ]
  set CONFIG_1 [ create_bd_port -dir O -from 0 -to 0 CONFIG_1 ]
  set NENBL_1 [ create_bd_port -dir O -from 0 -to 0 NENBL_1 ]
  set STEP_1 [ create_bd_port -dir O -from 0 -to 0 STEP_1 ]
  set DIR_1 [ create_bd_port -dir O -from 0 -to 0 DIR_1 ]
  set Breakout1_1 [ create_bd_port -dir O -from 0 -to 0 Breakout1_1 ]
  set Breakout1_2 [ create_bd_port -dir O -from 0 -to 0 Breakout1_2 ]
  set Breakout1_3 [ create_bd_port -dir O -from 0 -to 0 Breakout1_3 ]
  set Sensor_IO_8 [ create_bd_port -dir O -from 0 -to 0 Sensor_IO_8 ]
  set Sensor_IO_1 [ create_bd_port -dir O -from 0 -to 0 Sensor_IO_1 ]
  set Sensor_IO_2 [ create_bd_port -dir O -from 0 -to 0 Sensor_IO_2 ]
  set Sensor_IO_3 [ create_bd_port -dir O -from 0 -to 0 Sensor_IO_3 ]
  set Sensor_IO_5 [ create_bd_port -dir O -from 0 -to 0 Sensor_IO_5 ]
  set Drive_DIR_1 [ create_bd_port -dir O -from 0 -to 0 -type data Drive_DIR_1 ]
  set Drive_DIR_2 [ create_bd_port -dir O -from 0 -to 0 -type data Drive_DIR_2 ]
  set Drive_DIR_3 [ create_bd_port -dir O -from 0 -to 0 -type data Drive_DIR_3 ]
  set Drive_DIR_4 [ create_bd_port -dir O -from 0 -to 0 -type data Drive_DIR_4 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [list \
    CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
    CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
    CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
    CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
    CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {25.000000} \
    CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
    CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
    CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {667} \
    CONFIG.PCW_CLK0_FREQ {100000000} \
    CONFIG.PCW_CLK1_FREQ {10000000} \
    CONFIG.PCW_CLK2_FREQ {10000000} \
    CONFIG.PCW_CLK3_FREQ {10000000} \
    CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
    CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
    CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
    CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
    CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
    CONFIG.PCW_DM_WIDTH {4} \
    CONFIG.PCW_DQS_WIDTH {4} \
    CONFIG.PCW_DQ_WIDTH {32} \
    CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
    CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
    CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
    CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
    CONFIG.PCW_ENET0_RESET_ENABLE {0} \
    CONFIG.PCW_ENET_RESET_ENABLE {1} \
    CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_EN_CLK0_PORT {1} \
    CONFIG.PCW_EN_CLK1_PORT {0} \
    CONFIG.PCW_EN_CLK2_PORT {0} \
    CONFIG.PCW_EN_CLK3_PORT {0} \
    CONFIG.PCW_EN_DDR {1} \
    CONFIG.PCW_EN_EMIO_TTC0 {1} \
    CONFIG.PCW_EN_ENET0 {1} \
    CONFIG.PCW_EN_GPIO {1} \
    CONFIG.PCW_EN_QSPI {1} \
    CONFIG.PCW_EN_RST0_PORT {1} \
    CONFIG.PCW_EN_RST1_PORT {0} \
    CONFIG.PCW_EN_RST2_PORT {0} \
    CONFIG.PCW_EN_RST3_PORT {0} \
    CONFIG.PCW_EN_SDIO0 {1} \
    CONFIG.PCW_EN_TTC0 {1} \
    CONFIG.PCW_EN_UART1 {1} \
    CONFIG.PCW_EN_USB0 {1} \
    CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
    CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
    CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {100} \
    CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {33.333333} \
    CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
    CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
    CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
    CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
    CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_I2C_RESET_ENABLE {0} \
    CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_0_PULLUP {disabled} \
    CONFIG.PCW_MIO_0_SLEW {slow} \
    CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_10_PULLUP {disabled} \
    CONFIG.PCW_MIO_10_SLEW {slow} \
    CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_11_PULLUP {disabled} \
    CONFIG.PCW_MIO_11_SLEW {slow} \
    CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_12_PULLUP {disabled} \
    CONFIG.PCW_MIO_12_SLEW {slow} \
    CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_13_PULLUP {disabled} \
    CONFIG.PCW_MIO_13_SLEW {slow} \
    CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_14_PULLUP {disabled} \
    CONFIG.PCW_MIO_14_SLEW {slow} \
    CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_15_PULLUP {disabled} \
    CONFIG.PCW_MIO_15_SLEW {slow} \
    CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_16_PULLUP {disabled} \
    CONFIG.PCW_MIO_16_SLEW {slow} \
    CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_17_PULLUP {disabled} \
    CONFIG.PCW_MIO_17_SLEW {slow} \
    CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_18_PULLUP {disabled} \
    CONFIG.PCW_MIO_18_SLEW {slow} \
    CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_19_PULLUP {disabled} \
    CONFIG.PCW_MIO_19_SLEW {slow} \
    CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_1_PULLUP {disabled} \
    CONFIG.PCW_MIO_1_SLEW {slow} \
    CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_20_PULLUP {disabled} \
    CONFIG.PCW_MIO_20_SLEW {slow} \
    CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_21_PULLUP {disabled} \
    CONFIG.PCW_MIO_21_SLEW {slow} \
    CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_22_PULLUP {disabled} \
    CONFIG.PCW_MIO_22_SLEW {slow} \
    CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_23_PULLUP {disabled} \
    CONFIG.PCW_MIO_23_SLEW {slow} \
    CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_24_PULLUP {disabled} \
    CONFIG.PCW_MIO_24_SLEW {slow} \
    CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_25_PULLUP {disabled} \
    CONFIG.PCW_MIO_25_SLEW {slow} \
    CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_26_PULLUP {disabled} \
    CONFIG.PCW_MIO_26_SLEW {slow} \
    CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_27_PULLUP {disabled} \
    CONFIG.PCW_MIO_27_SLEW {slow} \
    CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_28_PULLUP {disabled} \
    CONFIG.PCW_MIO_28_SLEW {slow} \
    CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_29_PULLUP {disabled} \
    CONFIG.PCW_MIO_29_SLEW {slow} \
    CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_2_SLEW {slow} \
    CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_30_PULLUP {disabled} \
    CONFIG.PCW_MIO_30_SLEW {slow} \
    CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_31_PULLUP {disabled} \
    CONFIG.PCW_MIO_31_SLEW {slow} \
    CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_32_PULLUP {disabled} \
    CONFIG.PCW_MIO_32_SLEW {slow} \
    CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_33_PULLUP {disabled} \
    CONFIG.PCW_MIO_33_SLEW {slow} \
    CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_34_PULLUP {disabled} \
    CONFIG.PCW_MIO_34_SLEW {slow} \
    CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_35_PULLUP {disabled} \
    CONFIG.PCW_MIO_35_SLEW {slow} \
    CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_36_PULLUP {disabled} \
    CONFIG.PCW_MIO_36_SLEW {slow} \
    CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_37_PULLUP {disabled} \
    CONFIG.PCW_MIO_37_SLEW {slow} \
    CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_38_PULLUP {disabled} \
    CONFIG.PCW_MIO_38_SLEW {slow} \
    CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_39_PULLUP {disabled} \
    CONFIG.PCW_MIO_39_SLEW {slow} \
    CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_3_SLEW {slow} \
    CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_40_PULLUP {disabled} \
    CONFIG.PCW_MIO_40_SLEW {slow} \
    CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_41_PULLUP {disabled} \
    CONFIG.PCW_MIO_41_SLEW {slow} \
    CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_42_PULLUP {disabled} \
    CONFIG.PCW_MIO_42_SLEW {slow} \
    CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_43_PULLUP {disabled} \
    CONFIG.PCW_MIO_43_SLEW {slow} \
    CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_44_PULLUP {disabled} \
    CONFIG.PCW_MIO_44_SLEW {slow} \
    CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_45_PULLUP {disabled} \
    CONFIG.PCW_MIO_45_SLEW {slow} \
    CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_46_PULLUP {disabled} \
    CONFIG.PCW_MIO_46_SLEW {slow} \
    CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_47_PULLUP {disabled} \
    CONFIG.PCW_MIO_47_SLEW {slow} \
    CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_48_PULLUP {disabled} \
    CONFIG.PCW_MIO_48_SLEW {slow} \
    CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_49_PULLUP {disabled} \
    CONFIG.PCW_MIO_49_SLEW {slow} \
    CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_4_SLEW {slow} \
    CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_50_PULLUP {disabled} \
    CONFIG.PCW_MIO_50_SLEW {slow} \
    CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_51_PULLUP {disabled} \
    CONFIG.PCW_MIO_51_SLEW {slow} \
    CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_52_PULLUP {disabled} \
    CONFIG.PCW_MIO_52_SLEW {slow} \
    CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_53_PULLUP {disabled} \
    CONFIG.PCW_MIO_53_SLEW {slow} \
    CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_5_SLEW {slow} \
    CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_6_SLEW {slow} \
    CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_7_SLEW {slow} \
    CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_8_SLEW {slow} \
    CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_9_PULLUP {disabled} \
    CONFIG.PCW_MIO_9_SLEW {slow} \
    CONFIG.PCW_MIO_PRIMITIVE {54} \
    CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#USB Reset#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet\
0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#GPIO#UART 1#UART 1#SD\
0#GPIO#Enet 0#Enet 0} \
    CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#reset#qspi_fbclk#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#gpio[47]#tx#rx#wp#gpio[51]#mdc#mdio}\
\
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.416} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.408} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.369} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.370} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {0.001} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.037} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.074} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.098} \
    CONFIG.PCW_PACKAGE_NAME {clg400} \
    CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
    CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
    CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
    CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
    CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
    CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
    CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
    CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
    CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
    CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
    CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
    CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
    CONFIG.PCW_SD0_GRP_WP_IO {MIO 50} \
    CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
    CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {25} \
    CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
    CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
    CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
    CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
    CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
    CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
    CONFIG.PCW_UIPARAM_DDR_BL {8} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.294} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.298} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.338} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.334} \
    CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {54.14} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {54.14} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {39.7} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {39.7} \
    CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {50.05} \
    CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {50.43} \
    CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {50.10} \
    CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {50.01} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.072} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.024} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.023} \
    CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {49.59} \
    CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {51.74} \
    CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {50.32} \
    CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {48.55} \
    CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
    CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
    CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
    CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_USB0_RESET_ENABLE {1} \
    CONFIG.PCW_USB0_RESET_IO {MIO 7} \
    CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
    CONFIG.PCW_USB_RESET_ENABLE {1} \
    CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_USE_AXI_NONSECURE {0} \
    CONFIG.PCW_USE_DMA0 {0} \
    CONFIG.PCW_USE_DMA1 {0} \
    CONFIG.PCW_USE_M_AXI_GP0 {1} \
    CONFIG.PCW_USE_M_AXI_GP1 {1} \
    CONFIG.PCW_USE_S_AXI_ACP {0} \
    CONFIG.PCW_USE_S_AXI_GP0 {0} \
    CONFIG.PCW_USE_S_AXI_GP1 {0} \
  ] $processing_system7_0


  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {10} \
    CONFIG.NUM_SI {2} \
  ] $axi_interconnect_0


  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0xFFFFFFFF} \
    CONFIG.C_IS_DUAL {0} \
  ] $axi_gpio_0


  # Create instance: GPIO_Slicer
  create_hier_cell_GPIO_Slicer [current_bd_instance .] GPIO_Slicer

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0xFFFFFFFF} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $axi_gpio_1


  # Create instance: drive
  create_hier_cell_drive [current_bd_instance .] drive

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins drive/S_AXI4]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins drive/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins drive/S_AXI1]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins drive/S_AXI2]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins axi_interconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins drive/S_AXI3]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP1 [get_bd_intf_pins processing_system7_0/M_AXI_GP1] [get_bd_intf_pins axi_interconnect_0/S01_AXI]

  # Create port connections
  connect_bd_net -net Drive_Dir1 [get_bd_pins drive/DAC_2_INB] [get_bd_ports DAC_2_INB]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_5 [get_bd_pins GPIO_Slicer/GPIO_buf_5] [get_bd_ports M0_1]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_6 [get_bd_pins GPIO_Slicer/GPIO_buf_6] [get_bd_ports M1_1]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_7 [get_bd_pins GPIO_Slicer/GPIO_buf_7] [get_bd_ports CONFIG_1]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_8 [get_bd_pins GPIO_Slicer/GPIO_buf_8] [get_bd_ports NENBL_1]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_9 [get_bd_pins GPIO_Slicer/GPIO_buf_9] [get_bd_ports DIR_1]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_10 [get_bd_pins GPIO_Slicer/GPIO_buf_10] [get_bd_ports STEP_1]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_11 [get_bd_pins GPIO_Slicer/GPIO_buf_11] [get_bd_ports Breakout1_1]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_12 [get_bd_pins GPIO_Slicer/GPIO_buf_12] [get_bd_ports Breakout1_2]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_13 [get_bd_pins GPIO_Slicer/GPIO_buf_13] [get_bd_ports Breakout1_3]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_14 [get_bd_pins GPIO_Slicer/GPIO_buf_14] [get_bd_ports Sensor_IO_1]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_15 [get_bd_pins GPIO_Slicer/GPIO_buf_15] [get_bd_ports Sensor_IO_3]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_16 [get_bd_pins GPIO_Slicer/GPIO_buf_16] [get_bd_ports Sensor_IO_5]
  connect_bd_net -net GPIO_Slicer_GPIO_buf_17 [get_bd_pins GPIO_Slicer/GPIO_buf_17] [get_bd_ports Sensor_IO_2]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins GPIO_Slicer/GPIO_buf]
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_pins axi_gpio_1/gpio_io_o] [get_bd_ports Sensor_IO_8]
  connect_bd_net -net drive_DAC_1_INA [get_bd_pins drive/DAC_1_INA] [get_bd_ports DAC_1_INA]
  connect_bd_net -net drive_DAC_1_INB [get_bd_pins drive/DAC_1_INB] [get_bd_ports DAC_1_INB]
  connect_bd_net -net drive_DAC_2_INA [get_bd_pins drive/DAC_2_INA] [get_bd_ports DAC_2_INA]
  connect_bd_net -net drive_Drive_DIR_1 [get_bd_pins drive/Drive_DIR_1] [get_bd_ports Drive_DIR_1] [get_bd_ports Drive_DIR_2]
  connect_bd_net -net drive_Drive_DIR_3 [get_bd_pins drive/Drive_DIR_3] [get_bd_ports Drive_DIR_3] [get_bd_ports Drive_DIR_4]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/M_AXI_GP1_ACLK] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins drive/s_axi_aclk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins drive/s_axi_aresetn]

  # Create address segments
  assign_bd_address -dict [list offset 0x7FFF8000 range 0x00008000 offset 0x80000000 range 0x00008000] -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_gpio_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x42800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x42810000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_timer_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x42820000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_timer_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x42830000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_timer_3/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


