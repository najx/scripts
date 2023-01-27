# This script allow you to automate repetitive tasks like
#   creating directories in bulk
#   creating files in bulk
#   return number of files & directories from a specified path recursively
#   search a file from a specified path recursively

import os
import time
from pathlib import Path

# Constants for coloring the console output
RED   = '\033[1;31m'
CYAN  = '\033[1;36m'
GREEN = '\033[0;32m'
RESET = '\033[0;0m'
BOLD  = '\033[;1m'

def create_dir(base_dir, dn):
    """
    Create `dn` number of directories in the specified `base_dir` location
    """
    for i in range(dn):
        os.mkdir(base_dir + str(i) + 'Folder')

def create_file(base_dir, fn):
    """
    Create `fn` number of files in the specified `base_dir` location
    """
    for i in range(fn):
        f = open(base_dir + str(i) + 'File.txt', 'w')
        f.close()

def file_counter(base_dir):
    """
    Count the number of files and directories in the specified `base_dir` location recursively
    """
    file_count = 0
    dir_count  = 0
    for root, dirs, files in os.walk(base_dir):
        for directories in dirs:
            dir_count += 1
        for files in files:
            file_count += 1
    print(CYAN,"Number of files:",RESET,file_count)
    print(CYAN,"Number of Directories:",RESET,dir_count)

def search_file(base_dir, ss):
    """
    Search for a file with the name `ss` in the specified `base_dir` location recursively
    """
    found = False
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file == ss:
                found = True
                break
    if found:
        print(GREEN, ss, 'located right there:', root,"!", RESET)
    else:
        print(RED, ss, 'has not been located..', RESET)

if __name__ =='__main__':
    print(BOLD,"Enter the absolute path of the location where the operations are going to take place ",RESET)
    base_dir = input("[eg: C:/Users/User/Desktop/fileman/ ] : ")
    print()
    print(GREEN,"1.",RESET,"Create Directories")
    print(GREEN,"2.",RESET,"Create Files")
    print(GREEN,"3.",RESET,"Count Files & Directories")
    print(GREEN,"4.",RESET,"Search files")
    print()
    op = int(input("Choose an option: "))
    i = 0
    # Loop until a valid option is chosen or the user runs out of chances
    while (op != 1 and op != 2 and op != 3 and op != 4) and (i < 3):
        print("> ", CYAN, (3-i), RESET, " chances left...")
        op = int(input("Choose an option: "))
        i += 1
    if op == 1:
      dn = int(input("How many directories you want to create? "))
      create_dir(base_dir, dn)
      print(GREEN, dn, "directories have been created successfully in", base_dir, RESET)
    elif op == 2:
      fn = int(input("How many files you want to create? "))
      create_file(base_dir, fn)
      print(GREEN, fn, "files have been created successfully in", base_dir, RESET)
    elif op == 3:
      file_counter(base_dir)
    elif op == 4:
      ss = input("Enter the name of the file you want to search for (include extension): ")
      search_file(base_dir, ss)
    else:
      print(RED, "You have run out of chances to choose a valid option. Exiting...", RESET)
