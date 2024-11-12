# LintLLM

import os
import sys
import pandas as pd
from datetime import datetime
from openai import OpenAI
from openpyxl import load_workbook

# modelname = "deepseek-coder"
# modelname = "Llama-3-1-405B-Instruct"
# modelname = "gpt-4"
# modelname = "gpt-4o"
# modelname = "o1-mini"

# create a new folder
# modelname+P4

def llmFun(moduleName,pri_loc):
    verilog_path = pri_loc+'/'+moduleName+'.v'
    prompt_txt = 'llmprompt.txt'

    prompt0 = 'The following <code> is the Verilog code for the module named <'+moduleName+'>.'
    prompt1 = '''Please check this <code> step by step using the following steps and rules.
step 1: Identify punctuation marks
    (1) Chinese punctuation cannot appear in the code.
step 2: Identify module
    (1) Module must be wrapped by 'module-endmodule'.
step 3: Identify statements
    (1) For statements in the module header, end with (','), and do not punctuate the last statement.
    (2) For statements outside the module header, end with (';').
step 4: Identify variables
    (1) For variables defined in the module header, the port type ('input', 'output', 'input') must be defined.
        a. For 'input' type variables, they must be assigned to other variables.
        b. For 'output' type variables, they need to be assigned values by other variables.
        c. For 'inout' type variables, they can be assigned to other variables or assigned to other variables.
    (2) For variables not defined in the module header, the port type ('input', 'output', 'input') cannot be defined.
    (3) For each variable, the data type ('wire', 'reg') must be defined.
        a. For variables of type 'wire', to be used in combinatorial logic.
        b. For variables of type 'reg', to be used in temporal logic.
        c. The default data type for variables is 'wire'.
    (4) For each variable, declare the bit-width ([MSB:LSB], which satisfies MSB>LSB), the default bit-width is 1, which can be omitted.
        a. Variable of bit width 0 ([0:0]) cannot be declared.
        b. For variables with a bit-width greater than 1, use the process to match the bit-width of the variable involved in the operation, neither exceeding the index nor leaving the bit-width free.
    (5) For assigning Values to Variable.
        a. To comply with the bit width requirements, distinguishing between binary, octal and hexadecimal mechanisms; each bit of octal represents three bits of binary, and each bit of hexadecimal represents four bits of binary.
        b. Cannot have an indefinite state ('x','X') or a highly resistive state ('z','Z').
    (6) Each variable is to be used.
step 5: Identify 'always' block
    (1) The 'always' block should be wrapped with 'begin-end'.
    (2) Identify 'always' types.
        a. Temporal logic.
        b. Combinational logic.
    (3) Identify sensitive lists.
        a. Sensitive list of temporal logic.
            ① Each signal in the sensitive list should have a 'posedge' edge or a 'neggedge' edge.
            ② For the judgment signal in the if condition, the original signal is used for the 'posedge' edge and the negative signal is used for the 'neggedge' edge.
            ③ Use ('or',',') to connect multiple signals in the sensitive list.
            ④ All signals used in the sensitive list should be listed.
        b. Sensitive list of combinatorial logic.
            ① Signals in the sensitive list cannot have a 'posedge' or 'negedge' edge.
            ② Multiple signals in the sensitive list are connected by ('or',',').
            ③ All signals used should be listed in the sensitive list or replaced by ('*').
        c. Cannot mix signals with edges and signals without edges.
        d. Cannot include extraneous signals.
    (4) Identify the mode of assignment
        a. Non-blocking assignment ('<=') is used in temporal logic.
        b. The use of blocking assignment methods ('=') in combinational logic.
        c. Cannot mix non-blocking assignment methods ('<=') and blocking methods ('=').
step 6: Identify 'begin-end' block
    (1) 'begin' and 'end' always occur in pairs.
    (2) For statements that execute one statement a time, 'begin-end' can be omitted.
    (3) For statements that execute more than one statement at a time, 'begin-end' cannot be omitted.
step 7: Identify reserved words
    (1) verilog includes reserved words: always,and,assign,automatic,begin,buf,buff0,buff1,case,casex,casez,cell,cmos,config,deassign,default,defparam,disable,edge,else,end,endcase,endconfig,endfunction,endgenerate,endmodule,endprimitive,endspecify,endtable,endtask,event,for,function,force,forever,fork,generate,genvar,highz0,highz1,if,ifnone,ifcdir,include,initial,inout,input,instance,integer,join,large,liblist,library,localparameter,macromodule,medium,module,nand,negedge,nmos,nor,not,notif0,notif1,noshowcancelled,notif0,notif1,pmos,pulsestyle_onevent,pulsestyle_ondetect,rcmos,real,realtime,reg,release,repeat,rnmos,rpmos,rtran,rtranif0,rtranif1,scalared,showcanclled,signed,small,specify,specparam,strong0,strong1,supply0,supply1,table,task,time,tran,or,posedge,output,parameter,tranif0,tranif1,tri,tri0,tri1,triand,trior,trireg,unsigned,use,uwire,vertored,wait,wand,weak0,weak1,while,wire,wor,xnor,xor,primitive,pull0,pull1,pulldown,pullup.
    (2) Cannot use reserved words as variable or module names.
    (3) Cannot use reserved words that do not exist in verilog.
step 8: Identify race or hazard condition
    (1) In temporal logic, a variable cannot be read immediately after it is assigned a value in the same 'always' block.
    (2) In temporal logic, it is not possible to assign a value to the same variable in the same sensitive list of 'always' block.
step 9: Identify 'case' structure
    (1) The 'case' structure should have a 'default' statement.
    (2) The 'case' structure should include all possible branches.
    (3) The 'case' structure should be wrapped in a 'case-endcase'.
step 10: Identify instantiated modules
    (1) Module port instantiation methods.
        a. Connected by position.
        b. Connected by name.
        c. Cannot mix the two methods.
    (2) The number of modules instantiated should be the same as the number required in the code.
    (3) The port type ('input', 'output', 'inout'), data type ('wire', 'reg') and data bit width of the module instantiation should be the same.
    (4) Each port should be connected when instantiated, not floating.
step 11: Identify operator
    (1) For the bitwise operators ('&', '|', '^', '~'), which are used for operations on multi-bit width variables.
    (2) For logical operators ('&&', '||', '!'), which are used for one-bit width variables.
step 12: Defect Traceability
    (1) If multiple defects are detected, they will be sequentially numbered as D1, D2, D3, etc.
    (2) After repairing D1, retest the defects and record the number of remaining defects as N1;
    (3) After repairing D2, retest the defects and record the number of remaining defects as N2;
    (4) After repairing D3, retest the defects and record the number of remaining defects as N3;
    (5) Repeat the steps of repairing defects until all multiple defects have been fixed.
    (6) Sort the number of remaining defects N1, N2, N3.
    (7) The defect with the smallest remaining defect quantity is the main defect, and the row where the main defect is located is output.
Please indicate which [line number] of code has defect.Following the output template.
RESULT: [YES|NO]
DEFECT LINE: [line number]
Please do not output medium processes or other content.'''     

# If there are defects in the code, please indicate which [line number] of code has defect.Following the output template.
# RESULT: [YES]
# DEFECT LINE: [line number]
# If there are no defects in the code, following the output template.
# RESULT: [NO]
# Please do not output medium processes or other content.     
    with open(verilog_path,'r',encoding='utf-8') as verilog:
        context = verilog.readlines()
        with open(prompt_txt,'w',encoding='utf-8') as prompt:
            prompt.write(prompt0+'\n')
            for i,line in enumerate(context):
                prompt.write(str(i+1)+'    '+line)
            prompt.write('\n')
            prompt.write(prompt1)
        
    
    client = OpenAI(
        api_key = "",
        base_url= ""
    )
    with open(prompt_txt,'r',encoding='utf-8') as file:
        context = file.read()
    response = client.chat.completions.create(
        model=modelname,  
        temperature=0,
        messages=[
                {"role": "system", "content": "You are a verilog code defect checker and are able to follow the defined rules."},
                {"role": "user", "content": context}
            ]  
    )
    answer= response.choices[0].message.content
    rptfile = pri_loc+'/result/'+modelname+'P4/'+moduleName+'_'+modelname+'.rpt'
    with open(rptfile,'w',encoding='utf-8') as file:
        file.write(answer)

def llmF(m,n,new_project,pri_loc):
    beginTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    for k in range(m,n):
        moduleName = new_project+str(k)
        formatted_time1 = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        print(formatted_time1+' '+moduleName+' '+modelname+'P4 Lint begin',flush=True)
        llmFun(moduleName,pri_loc)
        formatted_time2 = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        print(formatted_time2+' '+moduleName+' '+modelname+'P4 Lint end',flush=True)
    endTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    begin = datetime.strptime(beginTime, '%Y-%m-%d %H:%M:%S.%f')
    end = datetime.strptime(endTime, '%Y-%m-%d %H:%M:%S.%f')
    totalSeconds = (end-begin).total_seconds()
    print('--->'+str(totalSeconds)+'s '+new_project+' '+modelname+'P4 Lint Time',flush=True)
def main():
    m = 1 # update
    n = 31 # update

    new_project = ['simple_', 'medium_', 'complex_'] # update
    folderlist = ['simple', 'medium', 'complex'] # update
    
    beginTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    for project,folder in zip(new_project,folderlist):
        pri_loc = '../'+folder
            
        llmF(m,n,project,pri_loc)

    endTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    begin = datetime.strptime(beginTime, '%Y-%m-%d %H:%M:%S.%f')
    end = datetime.strptime(endTime, '%Y-%m-%d %H:%M:%S.%f')
    totalSeconds = (end-begin).total_seconds()
    print('--->'+str(totalSeconds)+'s Total Lint Time',flush=True)
    os.system('del llmprompt.txt')
main()

# python lintllm.py