import pandas as pd
import os

# 定義 Excel 檔案的路徑
excel_file = r'C:\Users\ahsieh\Desktop\AndyHsieh\Sharefolder\output.xlsx'

# 定義輸出的 CSV 檔案保存目錄
output_folder = r'C:\Users\ahsieh\Desktop\AndyHsieh\Sharefolder\SW_list_CSV'

# 讀取 Excel 檔案中的所有工作表
excel_data = pd.read_excel(excel_file, sheet_name=None)

# 確保輸出資料夾存在，若不存在則創建
os.makedirs(output_folder, exist_ok=True)

# 遍歷每個工作表，將其保存為單獨的 CSV 檔案
for sheet_name, df in excel_data.items():
    # 定義輸出的 CSV 檔案名稱，使用工作表名稱作為檔名
    csv_file = os.path.join(output_folder, f'{sheet_name}.csv')
    # 將資料寫入 CSV 檔案
    df.to_csv(csv_file, index=False)

print("All sheet generate to csv file！")
