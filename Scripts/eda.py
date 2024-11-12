import os
import sys
from datetime import datetime

def vcsFun(moduleName,pri_loc):
    os.system('vcs -full64 +lint=all '+pri_loc+'/'+moduleName+'.v > '+pri_loc+'/result/vcs/'+moduleName+'_vcs.rpt')
    os.system('rm -rf ./simv.daidir')
    os.system('rm -rf ./csrc')

def spyglassFun(moduleName,pri_loc,new_project):
    with open('spyglass.tcl', 'w') as file:   
        file.write('set prj_loc '+pri_loc+'\n')
        file.write('new_project '+new_project+' -projectwdir $prj_loc -force'+'\n')
        file.write('set top '+moduleName+'\n')
        file.write('read_file -type verilog '+pri_loc+'/'+moduleName+'.v'+'\n')
        file.write('set_option enable_precompile_vlog yes'+'\n')
        file.write('set_option sort yes'+'\n')
        file.write('#set_option 87 yes'+'\n')
        file.write('set_option language_mode mixed'+'\n')
        file.write('set_option designread_disable_flatten yes'+'\n')
        file.write('set_option enableSV yes'+'\n')
        file.write('#set_parameter enable_generated_clock yes'+'\n')
        file.write('#set_parameter enable_glitchfreecell_detection yes'+'\n')
        file.write('set_parameter pt no'+'\n')
        file.write('set_option sgsyn_clock_gating 1'+'\n')
        file.write('set_option allow_module_override yes'+'\n')
        file.write('set_option vlog2001_generate_name yes'+'\n')
        file.write('set_option handlememory yes'+'\n')
        file.write('set_option define_cell_sim_depth 11'+'\n')
        file.write('set_option mthresh 400000'+'\n')
        file.write('#set_option incdir {}'+'\n')
        file.write('#current_methodology $SPYGLASS_HOME/GuideWare/latest/block/rtl_handoff'+'\n')
        file.write('current_goal lint/lint_rtl -top '+moduleName+'\n')
        file.write('run_goal'+'\n')
        file.write('write_report moresimple > '+pri_loc+'/result/spyglass/'+moduleName+'_spyglass.rpt'+'\n')
        file.write('exit -force'+'\n')
    os.system('sg_shell -tcl spyglass.tcl &>sg.log')
    os.system('rm -rf '+pri_loc+'/'+new_project)

def spyglassF(m,n,new_project,pri_loc):
    beginTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]

    for k in range(m,n):
        moduleName = new_project+str(k)

        formatted_time1 = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        print(formatted_time1+' '+moduleName+' SpyGlass Lint begin',flush=True)
        spyglassFun(moduleName,pri_loc,new_project)
        formatted_time2 = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        print(formatted_time2+' '+moduleName+' SpyGlass Lint end',flush=True)

    endTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    begin = datetime.strptime(beginTime, '%Y-%m-%d %H:%M:%S.%f')
    end = datetime.strptime(endTime, '%Y-%m-%d %H:%M:%S.%f')
    totalSeconds = (end-begin).total_seconds()
    print('--->'+str(totalSeconds)+'s '+new_project+' SpyGlass Lint Time',flush=True)

def vcsF(m,n,new_project,pri_loc):
    beginTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    for k in range(m,n):
        moduleName = new_project+str(k)
        formatted_time1 = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        print(formatted_time1+' '+moduleName+' VCS Lint begin',flush=True)
        vcsFun(moduleName,pri_loc)
        formatted_time2 = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        print(formatted_time2+' '+moduleName+' VCS Lint end',flush=True)
    endTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    begin = datetime.strptime(beginTime, '%Y-%m-%d %H:%M:%S.%f')
    end = datetime.strptime(endTime, '%Y-%m-%d %H:%M:%S.%f')
    totalSeconds = (end-begin).total_seconds()
    print('--->'+str(totalSeconds)+'s '+new_project+' VCS Lint Time',flush=True)

def main():
    m = 1 # update
    n = 31 # update

    new_project = ['simple_', 'medium_', 'complex_'] # update
    folderlist = ['simple', 'medium', 'complex'] # update

    beginTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    for project,folder in zip(new_project,folderlist):
        pri_loc = '/mnt/hgfs/VMwareShare/CodeLint/LintLLM/'+folder

        spyglassF(m,n,project,pri_loc)
        vcsF(m,n,project,pri_loc)
    
    endTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    begin = datetime.strptime(beginTime, '%Y-%m-%d %H:%M:%S.%f')
    end = datetime.strptime(endTime, '%Y-%m-%d %H:%M:%S.%f')
    totalSeconds = (end-begin).total_seconds()
    print('--->'+str(totalSeconds)+'s Total Lint Time',flush=True)
    
    os.system('rm sg.log')
main()

# Liunx
# python3.9 eda.py