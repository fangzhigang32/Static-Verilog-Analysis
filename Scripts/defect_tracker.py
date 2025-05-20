# Defect Tracker

import os
import sys
import pandas as pd
from datetime import datetime
from openai import OpenAI
from openpyxl import load_workbook

modelname = "deepseek-coder"

# create a new folder
# modelname+tracker

def llmFun(moduleName,pri_loc):
    verilog_path = pri_loc+'/'+moduleName+'.v'
    prompt_txt = 'llmprompt.txt'

    prompt0 = 'The following <code> is the Verilog code for the module named <'+moduleName+'>.'
    prompt1 = '''Please check this <code> step by step using the following steps and rules to find defects.
step 1: If multiple defects are detected, they will be sequentially numbered as D1, D2, D3, etc.
step 2: After repairing D1, retest the defects and record the number of remaining defects as N1;
step 3: After repairing D2, retest the defects and record the number of remaining defects as N2;
step 4: After repairing D3, retest the defects and record the number of remaining defects as N3;
step 5: Repeat the steps of repairing defects until all multiple defects have been fixed.
step 6: Sort the number of remaining defects N1, N2, N3.
step 7: The defect with the smallest remaining defect quantity is the main defect, and the row where the main defect is located is output.
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
    rptfile = pri_loc+'/result/'+modelname+'tracker/'+moduleName+'_'+modelname+'.rpt'
    with open(rptfile,'w',encoding='utf-8') as file:
        file.write(answer)
    
def llmF(m,n,new_project,pri_loc):
    beginTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    for k in range(m,n):
        moduleName = new_project+str(k)
        formatted_time1 = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        print(formatted_time1+' '+moduleName+' '+modelname+'tracker Lint begin',flush=True)
        llmFun(moduleName,pri_loc)
        formatted_time2 = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        print(formatted_time2+' '+moduleName+' '+modelname+'tracker Lint end',flush=True)
    endTime = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    begin = datetime.strptime(beginTime, '%Y-%m-%d %H:%M:%S.%f')
    end = datetime.strptime(endTime, '%Y-%m-%d %H:%M:%S.%f')
    totalSeconds = (end-begin).total_seconds()
    print('--->'+str(totalSeconds)+'s '+new_project+' '+modelname+'tracker Lint Time',flush=True)
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

# python defect_tracker.py
