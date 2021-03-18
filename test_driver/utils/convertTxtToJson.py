import json
import datetime
import re
import os
import sys

filenames = sys.argv

content = []
failed_test = 'Some tests failed'
passed_test = 'All tests passed!'
long_time_complete = 'taking a long time to complete'


def extract_data(filename):

    # resultant dictionary
    dict1 = {}
    list1 = []
    dict1['testName'] = filename+'.dart'
    isFoundNumbers = False
    filePath = 'test_driver/reports/'+filename+'.txt'

    if os.path.isfile(filePath) and os.access(filePath, os.R_OK):
        with open(filePath, 'r') as fh:
            for line in fh:

                # reading line by line from the text file
                description = line.strip()
                list1.append(description)
                if(passed_test in description):
                    if('+' in description):
                        dict1['passed'] = description[description.find(
                            '+') + 1: description.find('+') + 2]
                    dict1['failed'] = '0'
                    dict1['error'] = 'None'

                if(failed_test in description):
                    if('+' in description):
                        dict1['passed'] = description[description.find(
                            '+') + 1: description.find('+') + 2]
                        dict1['failed'] = description[description.find(
                            '-') + 1: description.find('-') + 2]
                    isFoundNumber = True

                if(isFoundNumbers == False):
                    if(long_time_complete in description):
                        dict1['passed'] = failed_test
                        dict1['failed'] = failed_test
                        jsonError = ''
                        for j in range(len(list1)-1):
                            if(list1[j].find('VMServiceFlutterDriver:') != -1):
                                jsonError = list1[j]
                        dict1['error'] = jsonError + '    ' + description
                else:
                    if(long_time_complete in description):
                        jsonError = ''
                        for j in range(len(list1)-1):
                            if(list1[j].find('VMServiceFlutterDriver:') != -1):
                                jsonError = list1[j]
                                print(jsonError)
                        dict1['error'] = jsonError + '    ' + description

        dict1['command'] = 'flutter drive --target=test_driver/tests/' + \
            filename+'.dart --no-build --no-pub'
        dict1['date/time'] = str(datetime.datetime.now())

        # Sorting the dict
        dict1 = {k: dict1[k] for k in sorted(dict1, reverse=True)}
        content.append(dict1)


for i in filenames:
    fileslist = i.split('\n')
    for filename in fileslist:
        extract_data(filename)

with open('test_driver/reports/final_test_run_report.json', 'w') as f:
    json.dump(content, f, indent=4)
