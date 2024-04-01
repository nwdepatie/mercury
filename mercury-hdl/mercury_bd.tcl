
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


# The design that will be created by this Tcl script contains the following 
# module references:
# stepper_pulse, stepper_pulse, stepper_pulse, stepper_pulse, stepper_pulse

# Please add the sources of those modules before sourcing this Tcl script.

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
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:util_vector_logic:2.0\
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

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
stepper_pulse\
stepper_pulse\
stepper_pulse\
stepper_pulse\
stepper_pulse\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
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


# Hierarchical cell: lighting
proc create_hier_cell_lighting { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lighting() - Empty argument(s)!"}
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


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O Flood_Light_1
  create_bd_pin -dir O Flood_Light_2
  create_bd_pin -dir O Flood_Light_3
  create_bd_pin -dir O Flood_Light_4

  # Create instance: axi_timer_headlight_lower, and set properties
  set axi_timer_headlight_lower [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_headlight_lower ]

  # Create instance: axi_timer_brakelight, and set properties
  set axi_timer_brakelight [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_brakelight ]

  # Create instance: axi_timer_headlight_upper, and set properties
  set axi_timer_headlight_upper [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_headlight_upper ]

  # Create instance: axi_timer_workcell, and set properties
  set axi_timer_workcell [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_workcell ]
  set_property CONFIG.enable_timer2 {1} $axi_timer_workcell


  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M12_AXI [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_timer_workcell/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M13_AXI [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_timer_headlight_upper/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M14_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_timer_headlight_lower/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M15_AXI [get_bd_intf_pins S_AXI1] [get_bd_intf_pins axi_timer_brakelight/S_AXI]

  # Create port connections
  connect_bd_net -net axi_timer_brakelight_pwm0 [get_bd_pins axi_timer_brakelight/pwm0] [get_bd_pins Flood_Light_2]
  connect_bd_net -net axi_timer_headlight_lower_pwm0 [get_bd_pins axi_timer_headlight_lower/pwm0] [get_bd_pins Flood_Light_1]
  connect_bd_net -net axi_timer_headlight_upper_pwm0 [get_bd_pins axi_timer_headlight_upper/pwm0] [get_bd_pins Flood_Light_3]
  connect_bd_net -net axi_timer_workcell_pwm0 [get_bd_pins axi_timer_workcell/pwm0] [get_bd_pins Flood_Light_4]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins s_axi_aclk] [get_bd_pins axi_timer_workcell/s_axi_aclk] [get_bd_pins axi_timer_headlight_upper/s_axi_aclk] [get_bd_pins axi_timer_brakelight/s_axi_aclk] [get_bd_pins axi_timer_headlight_lower/s_axi_aclk]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins axi_timer_workcell/s_axi_aresetn] [get_bd_pins axi_timer_headlight_upper/s_axi_aresetn] [get_bd_pins axi_timer_brakelight/s_axi_aresetn] [get_bd_pins axi_timer_headlight_lower/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: gantry
proc create_hier_cell_gantry { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_gantry() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type data CONFIG_1
  create_bd_pin -dir O -from 0 -to 0 -type data DIR_1
  create_bd_pin -dir O -from 0 -to 0 -type data M0_1
  create_bd_pin -dir O -from 0 -to 0 -type data M1_1
  create_bd_pin -dir O -from 0 -to 0 -type data NENBL_1
  create_bd_pin -dir O -from 0 -to 0 -type data NSLEEP_1
  create_bd_pin -dir O -type data STEP_1
  create_bd_pin -dir O -from 0 -to 0 -type data CONFIG_2
  create_bd_pin -dir O -from 0 -to 0 -type data DIR_2
  create_bd_pin -dir O -from 0 -to 0 -type data M0_2
  create_bd_pin -dir O -from 0 -to 0 -type data M1_2
  create_bd_pin -dir O -from 0 -to 0 -type data NENBL_2
  create_bd_pin -dir O -from 0 -to 0 -type data NSLEEP_2
  create_bd_pin -dir O -type data STEP_2
  create_bd_pin -dir O -from 0 -to 0 -type data CONFIG_3
  create_bd_pin -dir O -from 0 -to 0 -type data DIR_3
  create_bd_pin -dir O -from 0 -to 0 -type data M0_3
  create_bd_pin -dir O -from 0 -to 0 -type data M1_3
  create_bd_pin -dir O -from 0 -to 0 -type data NENBL_3
  create_bd_pin -dir O -from 0 -to 0 -type data NSLEEP_3
  create_bd_pin -dir O -type data STEP_3
  create_bd_pin -dir I Limit_SW_1
  create_bd_pin -dir I Limit_SW_2
  create_bd_pin -dir I Limit_SW_3
  create_bd_pin -dir I Limit_SW_4
  create_bd_pin -dir O -type data STEP_4
  create_bd_pin -dir O -from 0 -to 0 -type data DIR_4
  create_bd_pin -dir O -from 0 -to 0 -type data M1_4
  create_bd_pin -dir O -from 0 -to 0 -type data M0_4
  create_bd_pin -dir O -from 0 -to 0 -type data NSLEEP_4
  create_bd_pin -dir O -from 0 -to 0 -type data CONFIG_4
  create_bd_pin -dir O -from 0 -to 0 -type data NENBL_4
  create_bd_pin -dir O -from 0 -to 0 -type data DIR_5
  create_bd_pin -dir O -type data STEP_5
  create_bd_pin -dir O -from 0 -to 0 -type data NSLEEP_5
  create_bd_pin -dir O -from 0 -to 0 -type data CONFIG_5
  create_bd_pin -dir O -from 0 -to 0 -type data NENBL_5
  create_bd_pin -dir O -from 0 -to 0 -type data M0_5
  create_bd_pin -dir O -from 0 -to 0 -type data M1_5

  # Create instance: axi_gpio_step1, and set properties
  set axi_gpio_step1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_step1 ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO2_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_step1


  # Create instance: axi_gpio_step2, and set properties
  set axi_gpio_step2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_step2 ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO2_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_step2


  # Create instance: axi_gpio_step3, and set properties
  set axi_gpio_step3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_step3 ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO2_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_step3


  # Create instance: axi_gpio_rst, and set properties
  set axi_gpio_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_rst ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000001} \
    CONFIG.C_GPIO2_WIDTH {4} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_rst


  # Create instance: xlconstant_gnd, and set properties
  set xlconstant_gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_gnd ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_gnd


  # Create instance: xlconstant_vcc, and set properties
  set xlconstant_vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_vcc ]
  set_property CONFIG.CONST_VAL {1} $xlconstant_vcc


  # Create instance: axi_gpio_dir1, and set properties
  set axi_gpio_dir1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_dir1 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {0} \
  ] $axi_gpio_dir1


  # Create instance: axi_gpio_dir2, and set properties
  set axi_gpio_dir2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_dir2 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {0} \
  ] $axi_gpio_dir2


  # Create instance: axi_gpio_dir3, and set properties
  set axi_gpio_dir3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_dir3 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {0} \
  ] $axi_gpio_dir3


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_0


  # Create instance: axi_gpio_step4, and set properties
  set axi_gpio_step4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_step4 ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO2_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_step4


  # Create instance: axi_gpio_dir4, and set properties
  set axi_gpio_dir4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_dir4 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {0} \
  ] $axi_gpio_dir4


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_1


  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_2


  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_3


  # Create instance: stepper_pulse_0, and set properties
  set block_name stepper_pulse
  set block_cell_name stepper_pulse_0
  if { [catch {set stepper_pulse_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $stepper_pulse_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: stepper_pulse_1, and set properties
  set block_name stepper_pulse
  set block_cell_name stepper_pulse_1
  if { [catch {set stepper_pulse_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $stepper_pulse_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: stepper_pulse_2, and set properties
  set block_name stepper_pulse
  set block_cell_name stepper_pulse_2
  if { [catch {set stepper_pulse_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $stepper_pulse_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: stepper_pulse_3, and set properties
  set block_name stepper_pulse
  set block_cell_name stepper_pulse_3
  if { [catch {set stepper_pulse_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $stepper_pulse_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {11} \
    CONFIG.S00_HAS_DATA_FIFO {2} \
    CONFIG.STRATEGY {2} \
  ] $axi_interconnect_0


  # Create instance: axi_gpio_dir5, and set properties
  set axi_gpio_dir5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_dir5 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {0} \
  ] $axi_gpio_dir5


  # Create instance: stepper_pulse_4, and set properties
  set block_name stepper_pulse
  set block_cell_name stepper_pulse_4
  if { [catch {set stepper_pulse_4 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $stepper_pulse_4 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_4


  # Create instance: axi_gpio_step5, and set properties
  set axi_gpio_step5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_step5 ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO2_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_step5


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_gpio_dir1/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_gpio_dir2/S_AXI] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_gpio_dir3/S_AXI] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_gpio_dir4/S_AXI] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_gpio_step1/S_AXI] [get_bd_intf_pins axi_interconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_gpio_step2/S_AXI] [get_bd_intf_pins axi_interconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_gpio_step3/S_AXI] [get_bd_intf_pins axi_interconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_gpio_step4/S_AXI] [get_bd_intf_pins axi_interconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins axi_gpio_rst/S_AXI] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins axi_gpio_dir5/S_AXI] [get_bd_intf_pins axi_interconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins axi_gpio_step5/S_AXI] [get_bd_intf_pins axi_interconnect_0/M10_AXI]

  # Create port connections
  connect_bd_net -net Limit_SW_1_1 [get_bd_pins Limit_SW_1] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net Limit_SW_2_1 [get_bd_pins Limit_SW_2] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net Limit_SW_3_1 [get_bd_pins Limit_SW_3] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net Limit_SW_4_1 [get_bd_pins Limit_SW_4] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_gpio_4_gpio_io_o [get_bd_pins axi_gpio_dir1/gpio_io_o] [get_bd_pins DIR_1]
  connect_bd_net -net axi_gpio_5_gpio_io_o [get_bd_pins axi_gpio_dir2/gpio_io_o] [get_bd_pins DIR_3]
  connect_bd_net -net axi_gpio_6_gpio_io_o [get_bd_pins axi_gpio_dir3/gpio_io_o] [get_bd_pins DIR_2]
  connect_bd_net -net axi_gpio_dir4_gpio_io_o [get_bd_pins axi_gpio_dir4/gpio_io_o] [get_bd_pins DIR_4]
  connect_bd_net -net axi_gpio_dir5_gpio_io_o [get_bd_pins axi_gpio_dir5/gpio_io_o] [get_bd_pins DIR_5]
  connect_bd_net -net axi_gpio_rst_gpio_io_o [get_bd_pins axi_gpio_rst/gpio_io_o] [get_bd_pins stepper_pulse_0/rst_n]
  connect_bd_net -net axi_gpio_step1_gpio_io_o [get_bd_pins axi_gpio_step1/gpio_io_o] [get_bd_pins stepper_pulse_0/pulse_count]
  connect_bd_net -net axi_gpio_step2_gpio_io_o [get_bd_pins axi_gpio_step2/gpio_io_o] [get_bd_pins stepper_pulse_1/pulse_count]
  connect_bd_net -net axi_gpio_step3_gpio_io_o [get_bd_pins axi_gpio_step3/gpio_io_o] [get_bd_pins stepper_pulse_2/pulse_count]
  connect_bd_net -net axi_gpio_step4_gpio_io_o [get_bd_pins axi_gpio_step4/gpio_io_o] [get_bd_pins stepper_pulse_3/pulse_count]
  connect_bd_net -net axi_gpio_step5_gpio_io_o [get_bd_pins axi_gpio_step5/gpio_io_o] [get_bd_pins stepper_pulse_4/pulse_count]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins axi_gpio_step2/s_axi_aresetn] [get_bd_pins axi_gpio_step3/s_axi_aresetn] [get_bd_pins axi_gpio_rst/s_axi_aresetn] [get_bd_pins axi_gpio_step1/s_axi_aresetn] [get_bd_pins axi_gpio_dir1/s_axi_aresetn] [get_bd_pins axi_gpio_dir2/s_axi_aresetn] [get_bd_pins axi_gpio_dir3/s_axi_aresetn] [get_bd_pins axi_gpio_step4/s_axi_aresetn] [get_bd_pins axi_gpio_dir4/s_axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_gpio_dir5/s_axi_aresetn] [get_bd_pins axi_gpio_step5/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_interconnect_0/M10_ARESETN]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_rst/s_axi_aclk] [get_bd_pins axi_gpio_step3/s_axi_aclk] [get_bd_pins axi_gpio_step2/s_axi_aclk] [get_bd_pins axi_gpio_step1/s_axi_aclk] [get_bd_pins axi_gpio_dir1/s_axi_aclk] [get_bd_pins axi_gpio_dir2/s_axi_aclk] [get_bd_pins axi_gpio_dir3/s_axi_aclk] [get_bd_pins axi_gpio_step4/s_axi_aclk] [get_bd_pins axi_gpio_dir4/s_axi_aclk] [get_bd_pins stepper_pulse_0/clk] [get_bd_pins stepper_pulse_1/clk] [get_bd_pins stepper_pulse_2/clk] [get_bd_pins stepper_pulse_3/clk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins stepper_pulse_4/clk] [get_bd_pins axi_gpio_dir5/s_axi_aclk] [get_bd_pins axi_gpio_step5/s_axi_aclk] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_interconnect_0/M10_ACLK]
  connect_bd_net -net stepper_pulse_0_done_out [get_bd_pins stepper_pulse_0/done_out] [get_bd_pins axi_gpio_step1/gpio2_io_i] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net stepper_pulse_0_pulse [get_bd_pins stepper_pulse_1/pulse_out] [get_bd_pins STEP_2]
  connect_bd_net -net stepper_pulse_0_pulse_out [get_bd_pins stepper_pulse_0/pulse_out] [get_bd_pins STEP_1]
  connect_bd_net -net stepper_pulse_1_done_out [get_bd_pins stepper_pulse_1/done_out] [get_bd_pins axi_gpio_step2/gpio2_io_i] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net stepper_pulse_2_done_out [get_bd_pins stepper_pulse_2/done_out] [get_bd_pins axi_gpio_step3/gpio2_io_i] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net stepper_pulse_2_pulse_out [get_bd_pins stepper_pulse_2/pulse_out] [get_bd_pins STEP_3]
  connect_bd_net -net stepper_pulse_3_done_out [get_bd_pins stepper_pulse_3/done_out] [get_bd_pins axi_gpio_step4/gpio2_io_i] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net stepper_pulse_3_pulse_out [get_bd_pins stepper_pulse_3/pulse_out] [get_bd_pins STEP_4]
  connect_bd_net -net stepper_pulse_4_done_out [get_bd_pins stepper_pulse_4/done_out] [get_bd_pins util_vector_logic_4/Op1] [get_bd_pins axi_gpio_step5/gpio2_io_i]
  connect_bd_net -net stepper_pulse_4_pulse_out [get_bd_pins stepper_pulse_4/pulse_out] [get_bd_pins STEP_5]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins NSLEEP_1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins NSLEEP_2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins NSLEEP_3]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins util_vector_logic_3/Res] [get_bd_pins NSLEEP_4]
  connect_bd_net -net util_vector_logic_4_Res [get_bd_pins util_vector_logic_4/Res] [get_bd_pins NSLEEP_5]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins axi_gpio_rst/gpio2_io_i]
  connect_bd_net -net xlconstant_gnd_dout [get_bd_pins xlconstant_gnd/dout] [get_bd_pins M0_1] [get_bd_pins M0_3] [get_bd_pins M0_2] [get_bd_pins M1_1] [get_bd_pins M1_2] [get_bd_pins M1_3] [get_bd_pins NENBL_1] [get_bd_pins NENBL_2] [get_bd_pins NENBL_3] [get_bd_pins M0_4] [get_bd_pins M1_4] [get_bd_pins NENBL_4] [get_bd_pins NENBL_5] [get_bd_pins M0_5] [get_bd_pins M1_5]
  connect_bd_net -net xlconstant_vcc_dout [get_bd_pins xlconstant_vcc/dout] [get_bd_pins CONFIG_4] [get_bd_pins CONFIG_3] [get_bd_pins CONFIG_2] [get_bd_pins CONFIG_1] [get_bd_pins CONFIG_5]

  # Restore current instance
  current_bd_instance $oldCurInst
}

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

  # Create instance: axi_timer_drv2, and set properties
  set axi_timer_drv2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_drv2 ]

  # Create instance: axi_timer_drv3, and set properties
  set axi_timer_drv3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_drv3 ]

  # Create instance: axi_timer_drv4, and set properties
  set axi_timer_drv4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_drv4 ]

  # Create instance: axi_gpio_dir, and set properties
  set axi_gpio_dir [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_dir ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_DOUT_DEFAULT {0xFFFFFFFF} \
    CONFIG.C_GPIO2_WIDTH {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_dir


  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: axi_timer_drv1, and set properties
  set axi_timer_drv1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_drv1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axi_timer_drv3/S_AXI] [get_bd_intf_pins S_AXI1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins axi_timer_drv4/S_AXI] [get_bd_intf_pins S_AXI2]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins axi_gpio_dir/S_AXI] [get_bd_intf_pins S_AXI3]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins axi_timer_drv2/S_AXI] [get_bd_intf_pins S_AXI4]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_timer_drv1/S_AXI]

  # Create port connections
  connect_bd_net -net axi_gpio_2_gpio2_io_o [get_bd_pins axi_gpio_dir/gpio2_io_o] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_pins axi_gpio_dir/gpio_io_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net axi_timer_2_pwm0 [get_bd_pins axi_timer_drv3/pwm0] [get_bd_pins DAC_2_INA]
  connect_bd_net -net axi_timer_3_pwm0 [get_bd_pins axi_timer_drv4/pwm0] [get_bd_pins DAC_2_INB]
  connect_bd_net -net axi_timer_drv1_pwm0 [get_bd_pins axi_timer_drv1/pwm0] [get_bd_pins DAC_1_INA]
  connect_bd_net -net axi_timer_drv2_pwm0 [get_bd_pins axi_timer_drv2/pwm0] [get_bd_pins DAC_1_INB]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_timer_drv3/s_axi_aclk] [get_bd_pins axi_timer_drv4/s_axi_aclk] [get_bd_pins axi_gpio_dir/s_axi_aclk] [get_bd_pins axi_timer_drv2/s_axi_aclk] [get_bd_pins axi_timer_drv1/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_timer_drv4/s_axi_aresetn] [get_bd_pins axi_timer_drv3/s_axi_aresetn] [get_bd_pins axi_gpio_dir/s_axi_aresetn] [get_bd_pins axi_timer_drv2/s_axi_aresetn] [get_bd_pins axi_timer_drv1/s_axi_aresetn]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlslice_0/Dout] [get_bd_pins Drive_DIR_1]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlslice_1/Dout] [get_bd_pins Drive_DIR_3]

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
  set Drive_DIR_1 [ create_bd_port -dir O -from 0 -to 0 -type data Drive_DIR_1 ]
  set Drive_DIR_2 [ create_bd_port -dir O -from 0 -to 0 -type data Drive_DIR_2 ]
  set Drive_DIR_3 [ create_bd_port -dir O -from 0 -to 0 -type data Drive_DIR_3 ]
  set Drive_DIR_4 [ create_bd_port -dir O -from 0 -to 0 -type data Drive_DIR_4 ]
  set NENBL_1 [ create_bd_port -dir O -from 0 -to 0 -type data NENBL_1 ]
  set STEP_1 [ create_bd_port -dir O -type data STEP_1 ]
  set DIR_1 [ create_bd_port -dir O -from 0 -to 0 -type data DIR_1 ]
  set M0_1 [ create_bd_port -dir O -from 0 -to 0 -type data M0_1 ]
  set M1_1 [ create_bd_port -dir O -from 0 -to 0 -type data M1_1 ]
  set CONFIG_1 [ create_bd_port -dir O -from 0 -to 0 -type data CONFIG_1 ]
  set NSLEEP_1 [ create_bd_port -dir O -from 0 -to 0 -type data NSLEEP_1 ]
  set CONFIG_2 [ create_bd_port -dir O -from 0 -to 0 -type data CONFIG_2 ]
  set DIR_2 [ create_bd_port -dir O -from 0 -to 0 -type data DIR_2 ]
  set M0_2 [ create_bd_port -dir O -from 0 -to 0 -type data M0_2 ]
  set M1_2 [ create_bd_port -dir O -from 0 -to 0 -type data M1_2 ]
  set NENBL_2 [ create_bd_port -dir O -from 0 -to 0 -type data NENBL_2 ]
  set NSLEEP_2 [ create_bd_port -dir O -from 0 -to 0 -type data NSLEEP_2 ]
  set STEP_2 [ create_bd_port -dir O -type data STEP_2 ]
  set CONFIG_3 [ create_bd_port -dir O -from 0 -to 0 -type data CONFIG_3 ]
  set DIR_3 [ create_bd_port -dir O -from 0 -to 0 -type data DIR_3 ]
  set M0_3 [ create_bd_port -dir O -from 0 -to 0 -type data M0_3 ]
  set M1_3 [ create_bd_port -dir O -from 0 -to 0 -type data M1_3 ]
  set NENBL_3 [ create_bd_port -dir O -from 0 -to 0 -type data NENBL_3 ]
  set NSLEEP_3 [ create_bd_port -dir O -from 0 -to 0 -type data NSLEEP_3 ]
  set STEP_3 [ create_bd_port -dir O -type data STEP_3 ]
  set Limit_SW_1 [ create_bd_port -dir I Limit_SW_1 ]
  set Limit_SW_2 [ create_bd_port -dir I Limit_SW_2 ]
  set Limit_SW_3 [ create_bd_port -dir I Limit_SW_3 ]
  set Limit_SW_4 [ create_bd_port -dir I Limit_SW_4 ]
  set Flood_Light_1 [ create_bd_port -dir O Flood_Light_1 ]
  set Flood_Light_2 [ create_bd_port -dir O Flood_Light_2 ]
  set Flood_Light_3 [ create_bd_port -dir O Flood_Light_3 ]
  set Flood_Light_4 [ create_bd_port -dir O Flood_Light_4 ]
  set Breakout1_14 [ create_bd_port -dir O -from 0 -to 0 -type data Breakout1_14 ]
  set STEP_4 [ create_bd_port -dir O -type data STEP_4 ]
  set DIR_4 [ create_bd_port -dir O -from 0 -to 0 -type data DIR_4 ]
  set M0_4 [ create_bd_port -dir O -from 0 -to 0 -type data M0_4 ]
  set M1_4 [ create_bd_port -dir O -from 0 -to 0 -type data M1_4 ]
  set NENBL_4 [ create_bd_port -dir O -from 0 -to 0 -type data NENBL_4 ]
  set NSLEEP_4 [ create_bd_port -dir O -from 0 -to 0 -type data NSLEEP_4 ]
  set CONFIG_4 [ create_bd_port -dir O -from 0 -to 0 -type data CONFIG_4 ]
  set CONFIG_5 [ create_bd_port -dir O -from 0 -to 0 -type data CONFIG_5 ]
  set DIR_5 [ create_bd_port -dir O -from 0 -to 0 -type data DIR_5 ]
  set M0_5 [ create_bd_port -dir O -from 0 -to 0 -type data M0_5 ]
  set M1_5 [ create_bd_port -dir O -from 0 -to 0 -type data M1_5 ]
  set NENBL_5 [ create_bd_port -dir O -from 0 -to 0 -type data NENBL_5 ]
  set NSLEEP_5 [ create_bd_port -dir O -from 0 -to 0 -type data NSLEEP_5 ]
  set STEP_5 [ create_bd_port -dir O -type data STEP_5 ]

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
    CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {1} \
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
    CONFIG.S00_HAS_DATA_FIFO {2} \
    CONFIG.S01_HAS_DATA_FIFO {2} \
    CONFIG.STRATEGY {2} \
  ] $axi_interconnect_0


  # Create instance: drive
  create_hier_cell_drive [current_bd_instance .] drive

  # Create instance: gantry
  create_hier_cell_gantry [current_bd_instance .] gantry

  # Create instance: lighting
  create_hier_cell_lighting [current_bd_instance .] lighting

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI1_1 [get_bd_intf_pins lighting/S_AXI1] [get_bd_intf_pins axi_interconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net S_AXI2_1 [get_bd_intf_pins lighting/S_AXI2] [get_bd_intf_pins axi_interconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net S_AXI3_1 [get_bd_intf_pins lighting/S_AXI3] [get_bd_intf_pins axi_interconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins lighting/S_AXI] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins drive/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins drive/S_AXI1]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins drive/S_AXI2]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins drive/S_AXI3]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins drive/S_AXI4]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins gantry/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP1 [get_bd_intf_pins processing_system7_0/M_AXI_GP1] [get_bd_intf_pins axi_interconnect_0/S01_AXI]

  # Create port connections
  connect_bd_net -net Drive_Dir1 [get_bd_pins drive/DAC_2_INB] [get_bd_ports DAC_2_INB]
  connect_bd_net -net Limit_SW_1_1 [get_bd_ports Limit_SW_1] [get_bd_pins gantry/Limit_SW_1]
  connect_bd_net -net Limit_SW_2_1 [get_bd_ports Limit_SW_2] [get_bd_pins gantry/Limit_SW_2]
  connect_bd_net -net Limit_SW_3_1 [get_bd_ports Limit_SW_3] [get_bd_pins gantry/Limit_SW_3]
  connect_bd_net -net Limit_SW_4_1 [get_bd_ports Limit_SW_4] [get_bd_pins gantry/Limit_SW_4]
  connect_bd_net -net drive_DAC_1_INA [get_bd_pins drive/DAC_1_INA] [get_bd_ports DAC_1_INA]
  connect_bd_net -net drive_DAC_1_INB [get_bd_pins drive/DAC_1_INB] [get_bd_ports DAC_1_INB]
  connect_bd_net -net drive_DAC_2_INA [get_bd_pins drive/DAC_2_INA] [get_bd_ports DAC_2_INA]
  connect_bd_net -net drive_Drive_DIR_1 [get_bd_pins drive/Drive_DIR_1] [get_bd_ports Drive_DIR_1] [get_bd_ports Drive_DIR_2]
  connect_bd_net -net drive_Drive_DIR_3 [get_bd_pins drive/Drive_DIR_3] [get_bd_ports Drive_DIR_3] [get_bd_ports Drive_DIR_4]
  connect_bd_net -net gantry_CONFIG_1 [get_bd_pins gantry/CONFIG_1] [get_bd_ports CONFIG_1]
  connect_bd_net -net gantry_CONFIG_2 [get_bd_pins gantry/CONFIG_2] [get_bd_ports CONFIG_2]
  connect_bd_net -net gantry_CONFIG_3 [get_bd_pins gantry/CONFIG_3] [get_bd_ports CONFIG_3]
  connect_bd_net -net gantry_CONFIG_4 [get_bd_pins gantry/CONFIG_4] [get_bd_ports CONFIG_4]
  connect_bd_net -net gantry_CONFIG_5 [get_bd_pins gantry/CONFIG_5] [get_bd_ports CONFIG_5]
  connect_bd_net -net gantry_DIR_1 [get_bd_pins gantry/DIR_1] [get_bd_ports DIR_1]
  connect_bd_net -net gantry_DIR_2 [get_bd_pins gantry/DIR_2] [get_bd_ports DIR_2]
  connect_bd_net -net gantry_DIR_3 [get_bd_pins gantry/DIR_3] [get_bd_ports DIR_3]
  connect_bd_net -net gantry_DIR_4 [get_bd_pins gantry/DIR_4] [get_bd_ports DIR_4]
  connect_bd_net -net gantry_DIR_5 [get_bd_pins gantry/DIR_5] [get_bd_ports DIR_5]
  connect_bd_net -net gantry_M0_1 [get_bd_pins gantry/M0_1] [get_bd_ports M0_1]
  connect_bd_net -net gantry_M0_2 [get_bd_pins gantry/M0_2] [get_bd_ports M0_2]
  connect_bd_net -net gantry_M0_3 [get_bd_pins gantry/M0_3] [get_bd_ports M0_3]
  connect_bd_net -net gantry_M0_4 [get_bd_pins gantry/M0_4] [get_bd_ports M0_4]
  connect_bd_net -net gantry_M0_5 [get_bd_pins gantry/M0_5] [get_bd_ports M0_5]
  connect_bd_net -net gantry_M1_1 [get_bd_pins gantry/M1_1] [get_bd_ports M1_1]
  connect_bd_net -net gantry_M1_2 [get_bd_pins gantry/M1_2] [get_bd_ports M1_2]
  connect_bd_net -net gantry_M1_3 [get_bd_pins gantry/M1_3] [get_bd_ports M1_3]
  connect_bd_net -net gantry_M1_4 [get_bd_pins gantry/M1_4] [get_bd_ports M1_4]
  connect_bd_net -net gantry_M1_5 [get_bd_pins gantry/M1_5] [get_bd_ports M1_5]
  connect_bd_net -net gantry_NENBL_1 [get_bd_pins gantry/NENBL_1] [get_bd_ports NENBL_1]
  connect_bd_net -net gantry_NENBL_2 [get_bd_pins gantry/NENBL_2] [get_bd_ports NENBL_2]
  connect_bd_net -net gantry_NENBL_3 [get_bd_pins gantry/NENBL_3] [get_bd_ports NENBL_3]
  connect_bd_net -net gantry_NENBL_4 [get_bd_pins gantry/NENBL_4] [get_bd_ports NENBL_4]
  connect_bd_net -net gantry_NENBL_5 [get_bd_pins gantry/NENBL_5] [get_bd_ports NENBL_5]
  connect_bd_net -net gantry_NSLEEP_1 [get_bd_pins gantry/NSLEEP_1] [get_bd_ports NSLEEP_1]
  connect_bd_net -net gantry_NSLEEP_2 [get_bd_pins gantry/NSLEEP_2] [get_bd_ports NSLEEP_2]
  connect_bd_net -net gantry_NSLEEP_3 [get_bd_pins gantry/NSLEEP_3] [get_bd_ports NSLEEP_3]
  connect_bd_net -net gantry_NSLEEP_4 [get_bd_pins gantry/NSLEEP_4] [get_bd_ports NSLEEP_4]
  connect_bd_net -net gantry_NSLEEP_5 [get_bd_pins gantry/NSLEEP_5] [get_bd_ports NSLEEP_5]
  connect_bd_net -net gantry_STEP_1 [get_bd_pins gantry/STEP_1] [get_bd_ports STEP_1]
  connect_bd_net -net gantry_STEP_2 [get_bd_pins gantry/STEP_2] [get_bd_ports STEP_2]
  connect_bd_net -net gantry_STEP_3 [get_bd_pins gantry/STEP_3] [get_bd_ports STEP_3]
  connect_bd_net -net gantry_STEP_4 [get_bd_pins gantry/STEP_4] [get_bd_ports STEP_4]
  connect_bd_net -net gantry_STEP_5 [get_bd_pins gantry/STEP_5] [get_bd_ports STEP_5]
  connect_bd_net -net lighting_Flood_Light_1 [get_bd_pins lighting/Flood_Light_1] [get_bd_ports Flood_Light_1]
  connect_bd_net -net lighting_Flood_Light_2 [get_bd_pins lighting/Flood_Light_2] [get_bd_ports Flood_Light_2]
  connect_bd_net -net lighting_Flood_Light_3 [get_bd_pins lighting/Flood_Light_3] [get_bd_ports Flood_Light_3]
  connect_bd_net -net lighting_Flood_Light_4 [get_bd_pins lighting/Flood_Light_4] [get_bd_ports Flood_Light_4]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/M_AXI_GP1_ACLK] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins drive/s_axi_aclk] [get_bd_pins gantry/s_axi_aclk] [get_bd_pins lighting/s_axi_aclk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins drive/s_axi_aresetn] [get_bd_pins gantry/s_axi_aresetn] [get_bd_pins lighting/s_axi_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_ports Breakout1_14]

  # Create address segments
  assign_bd_address -offset 0x40040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_dir1/S_AXI/Reg] -force
  assign_bd_address -offset 0x40050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_dir2/S_AXI/Reg] -force
  assign_bd_address -offset 0x40060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_dir3/S_AXI/Reg] -force
  assign_bd_address -offset 0x40070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_dir4/S_AXI/Reg] -force
  assign_bd_address -offset 0x40080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_dir5/S_AXI/Reg] -force
  assign_bd_address -dict [list offset 0x7FFF8000 range 0x00008000 offset 0x80000000 range 0x00008000] -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_gpio_dir/S_AXI/Reg] -force
  assign_bd_address -offset 0x40090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_rst/S_AXI/Reg] -force
  assign_bd_address -offset 0x400A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_step1/S_AXI/Reg] -force
  assign_bd_address -offset 0x400B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_step2/S_AXI/Reg] -force
  assign_bd_address -offset 0x400C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_step3/S_AXI/Reg] -force
  assign_bd_address -offset 0x400D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_step4/S_AXI/Reg] -force
  assign_bd_address -offset 0x400E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gantry/axi_gpio_step5/S_AXI/Reg] -force
  assign_bd_address -offset 0x400F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs lighting/axi_timer_brakelight/S_AXI/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_timer_drv1/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_timer_drv2/S_AXI/Reg] -force
  assign_bd_address -offset 0x40020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_timer_drv3/S_AXI/Reg] -force
  assign_bd_address -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs drive/axi_timer_drv4/S_AXI/Reg] -force
  assign_bd_address -offset 0x40100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs lighting/axi_timer_headlight_lower/S_AXI/Reg] -force
  assign_bd_address -offset 0x40110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs lighting/axi_timer_headlight_upper/S_AXI/Reg] -force
  assign_bd_address -offset 0x40120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs lighting/axi_timer_workcell/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

