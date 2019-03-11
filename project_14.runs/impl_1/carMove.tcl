proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  set_param simulator.modelsimInstallPath D:/modelsim/win32pe
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir E:/demo/FGPA/0/0/project_14/project_14.cache/wt [current_project]
  set_property parent.project_path E:/demo/FGPA/0/0/project_14/project_14.xpr [current_project]
  set_property ip_repo_paths e:/demo/FGPA/0/0/project_14/project_14.cache/ip [current_project]
  set_property ip_output_repo e:/demo/FGPA/0/0/project_14/project_14.cache/ip [current_project]
  add_files -quiet E:/demo/FGPA/0/0/project_14/project_14.runs/synth_1/carMove.dcp
  read_xdc E:/demo/FGPA/0/0/project_14/project_14.srcs/constrs_1/new/CarC.xdc
  link_design -top carMove -part xc7a100tcsg324-1
  write_hwdef -file carMove.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force carMove_opt.dcp
  report_drc -file carMove_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force carMove_placed.dcp
  report_io -file carMove_io_placed.rpt
  report_utilization -file carMove_utilization_placed.rpt -pb carMove_utilization_placed.pb
  report_control_sets -verbose -file carMove_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force carMove_routed.dcp
  report_drc -file carMove_drc_routed.rpt -pb carMove_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file carMove_timing_summary_routed.rpt -rpx carMove_timing_summary_routed.rpx
  report_power -file carMove_power_routed.rpt -pb carMove_power_summary_routed.pb -rpx carMove_power_routed.rpx
  report_route_status -file carMove_route_status.rpt -pb carMove_route_status.pb
  report_clock_utilization -file carMove_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set src_rc [catch { 
    puts "source E:/demo/FGPA/pree.tcl"
    source E:/demo/FGPA/pree.tcl
  } _RESULT] 
  if {$src_rc} { 
    send_msg_id runtcl-1 error "$_RESULT"
    send_msg_id runtcl-2 error "sourcing script E:/demo/FGPA/pree.tcl failed"
    return -code error
  }
  catch { write_mem_info -force carMove.mmi }
  write_bitstream -force carMove.bit 
  catch { write_sysdef -hwdef carMove.hwdef -bitfile carMove.bit -meminfo carMove.mmi -file carMove.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

