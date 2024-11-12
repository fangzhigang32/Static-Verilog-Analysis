set prj_loc /mnt/hgfs/VMwareShare/CodeLint/LintLLM/complex
new_project complex_ -projectwdir $prj_loc -force
set top complex_30
read_file -type verilog /mnt/hgfs/VMwareShare/CodeLint/LintLLM/complex/complex_30.v
set_option enable_precompile_vlog yes
set_option sort yes
#set_option 87 yes
set_option language_mode mixed
set_option designread_disable_flatten yes
set_option enableSV yes
#set_parameter enable_generated_clock yes
#set_parameter enable_glitchfreecell_detection yes
set_parameter pt no
set_option sgsyn_clock_gating 1
set_option allow_module_override yes
set_option vlog2001_generate_name yes
set_option handlememory yes
set_option define_cell_sim_depth 11
set_option mthresh 400000
#set_option incdir {}
#current_methodology $SPYGLASS_HOME/GuideWare/latest/block/rtl_handoff
current_goal lint/lint_rtl -top complex_30
run_goal
write_report moresimple > /mnt/hgfs/VMwareShare/CodeLint/LintLLM/complex/result/spyglass/complex_30_spyglass.rpt
exit -force
