import os
import time
from pathlib import Path

RED   = '\033[1;31m'
CYAN  = '\033[1;36m'
GREEN = '\033[0;32m'
RESET = '\033[0;0m'
BOLD  = '\033[;1m'

def createDir(BASE_DIR,dn):
  for i in range(dn):
    os.mkdir(BASE_DIR + str(i) + 'Folder')
    
def createFile(BASE_DIR,fn):
  for i in range(fn):
    f=open(BASE_DIR + str(i) + 'File.txt','w')
    f.close()

def fileCounter(BASE_DIR):
  fileCount = 0
  dirCount  = 0
  print()
  for root, dirs, files in os.walk(BASE_DIR):
    for directories in dirs:
        dirCount += 1
    for Files in files:
        fileCount += 1
  print(CYAN,"Number of files:",RESET,fileCount)
  print(CYAN,"Number of Directories:",RESET,dirCount)
  print()

def searchFile(BASE_DIR,ss):
  got=False
  for root, dirs, files in os.walk(BASE_DIR):
    for Files in files:
      try:
        found = Files.find(ss)
        if found != -1:
          got=True
          break
      except:
        print(RED,'Something went wrong! Try again..',RESET)
        exit()
  if got==True:
    print(GREEN,ss, 'located right there:',root,"!",RESET)
  else:
    print(RED,ss, 'has not been located..',RESET)

if __name__ =='__main__':
  print(BOLD,"Enter the absolute path of the location where the operations are going to take place ",RESET)
  BASE_DIR=input("[eg: C:/Users/User/Desktop/fileman/ ] : ")
  print()
  print(GREEN,"1.",RESET,"Create Directories")
  print(GREEN,"2.",RESET,"Create Files")
  print(GREEN,"3.",RESET,"Count Files & Directories")
  print(GREEN,"4.",RESET,"Search files")
  print()
  op=int((input("Choose an option: ")))
  i=0
  while (op != 1 and op != 2 and op != 3 and op != 4 and op != 5) and (i<3):
    print(  "> ",CYAN,(3-i),RESET," chances left...")
    op=int((input("Choose an option: ")))
    i+=1
  if op==1:
    dn=int(input("How many directories you want to create? : "))
    createDir(BASE_DIR,dn)
  elif op==2:
    fn=int(input("How many files you want to create? : "))
    createFile(BASE_DIR,fn)
  elif op==3:
    fileCounter(BASE_DIR)
  elif op==4:
    ss=input("Enter the exact file name with extenstion: ")
    searchFile(BASE_DIR,ss)
  else:
    print(RED,"> Invalid option!", RESET)
