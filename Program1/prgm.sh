#!/bin/bash

#Test Files
mkdir -p src/objects
mkdir -p src/profiles
mkdir -p src/reports/CACI_Imports
touch src/objects/Event.object
touch src/objects/Trading_Event__c.object
touch src/objects/ActiveScratchOrg.object
touch src/profiles/Admin.profile
touch src/reports/CACI_Imports/All_Closed.report


# Specify the file name to read
read_filename="file_diff.txt"
project_path="/home/ec2-user/ProjectPath/"

#Deleting old files if any
`rm -f add.txt modified.txt deleted.txt rename.txt 2>/dev/null`

# Check if the file exists
if [[ ! -f "$read_filename" ]]; then
    echo "File not found!"
    exit 1
fi

# Printing the file, ignoring lines starting with # and empty lines
#grep -v '^$' "$read_filename" | grep -v '^#' | while IFS= read -r line; do
#    #echo "$line"
#done

# Process the file, ignoring lines starting with # and empty lines
grep -v '^$' "$read_filename" | grep -v '^#' | while IFS= read -r line; do
    #echo "---------------------------------------"
    #echo "Processing line ---> $line"
    # Split the string by spaces
    IFS=' ' read -r -a array <<< "$line"
    if [[ ${#array[@]} -ne 2 ]]; then
       echo "Line has invalid values --> $line"
       #exit 1
    else
       operation="${array[0]}"
       filepath="${array[1]}"
       filename=$(basename "$filepath")
       #echo "Functionality ${operation}"
       if [[ ${operation} = "A" ]]; then
           #Added File
           echo "$filename" >> add.txt
           rsync -avq --relative "./$filepath" "$project_path"
       elif [[ ${operation} = "M" ]]; then
           #Modified file
           echo "$filename" >> modified.txt
           rsync -avq --relative "./$filepath" "$project_path"
       elif [[ ${operation} = "D" ]]; then
           #Deleted File
           echo "$filename" >> deleted.txt
           rm -f "$project_path$filepath"
       elif [[ ${operation} = "R" ]]; then
           #Rename File
           echo "$filename" >> rename.txt
           rm -f "$project_path$filepath"
       else
           #Invalid Option
           echo "Invalid Functionality $operation"
       fi

    fi
    #echo "---------------------------------------"
done

#cat add.txt
#cat modified.txt
#cat deleted.txt
#cat rename.txt