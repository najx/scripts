# This script converts a file from CSV to JSON.
# The output can either is sent to specified file.

# To Run It :
# python csv_to_json.py

import csv
import json

file_name = input("Provide the CSV filename without extension>> ")

with open(file_name + '.csv') as f:
    reader = csv.reader(f, delimiter=',')
    titles = []
    temp_data = {}

    for heading in reader:
        titles = heading
        break

    i = 1
    for row in reader:
        current_row = "row{}".format(i)
        temp_data['{}'.format(current_row)] = {}
        for col in range(len(titles)):
            temp_data[current_row][titles[col]] = row[col]
        i += 1

with open(file_name + '.json', 'w') as f_j:
    json.dump(temp_data, f_j, indent=4)

print("File converted successfully :)\n")
