#!/bin/bash

# How to launch the script:
# "./display_tree.sh ../.. output.txt py" to generate the content of all .py files

# Mandatory parameters
path=$1
outputFile=$2

# Optional parameter with a default value
filterExtension=${3:-'*'}

# Check if the path exists
if [ ! -d "$path" ]; then
    echo "The specified path does not exist"
    exit 1
fi

# Remove the output file if it exists, then create it
rm -f $outputFile
touch $outputFile

# Display the directory tree excluding .git
# The command 'find' is used with the '-prune' option to exclude '.git' directories
find $path -type d \( -name .git -prune \) -o -print | grep -v '/.git/' >> $outputFile

# Search for files matching the filter extension and add their content to the output file
for file in $(find $path -type f -name "*.$filterExtension"); do
    # Add the full path of the file to the output file
    echo "" >> $outputFile
    echo "Content of the file: $file" >> $outputFile
    echo '````' >> $outputFile
    
    # Add the content of the file to the output file
    # The 'cat' command is used to read the file content
    cat $file >> $outputFile
    
    echo '````' >> $outputFile
    echo "" >> $outputFile
done
