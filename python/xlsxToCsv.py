# To convert all XLSX files in a folder to CSV files

import glob
import pandas as pd
excel_files = glob.glob('*xlsx')
for excel_file in excel_files:
    print("Converting '{}'".format(excel_file))
    try:
        df = pd.read_excel(excel_file)
        output = excel_file.split('.')[0]+'.csv'
        df.to_csv(output, index=False)
        print('Success!')   
    except KeyError:
        print("Failed to convert")