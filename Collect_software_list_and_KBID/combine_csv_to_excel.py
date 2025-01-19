import pandas as pd
import os

# 定義 CSV 檔案所在的目錄路徑
csv_folder = r'C:\Users\ahsieh\Desktop\AndyHsieh\Sharefolder\script_test\Get_system_SW_and_KBID\SW_list_CSV'

# 定義要生成的 Excel 文件名稱
excel_file = 'ARC41_SW_list_and_KBID.xlsx'

# 使用 ExcelWriter 並指定 openpyxl 引擎
with pd.ExcelWriter(excel_file, engine='openpyxl') as writer:
    # 獲取所有 CSV 檔案，按照文件在目錄中的順序
    csv_files = [f for f in os.listdir(csv_folder) if f.endswith('.csv')]
    
    # 遍歷所有檔案
    for csv_file in csv_files:
        # 完整的 CSV 檔案路徑
        csv_path = os.path.join(csv_folder, csv_file)
        # 讀取 CSV 檔案
        df = pd.read_csv(csv_path)
        # 去除檔案名稱中的擴展名 ".csv" 作為工作表名稱
        sheet_name = os.path.splitext(csv_file)[0]
        # 將資料寫入 Excel 檔案中的新工作表，工作表名稱與 CSV 檔名相同
        df.to_excel(writer, sheet_name=sheet_name, index=False)

print("All CSV files combined into the Excel, and the sheet names are in the directory order!")

