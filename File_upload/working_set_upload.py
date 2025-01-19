from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import requests
from bs4 import BeautifulSoup
import time
options = Options()
options.add_argument('--ignore-certificate-errors')
options.add_argument('--ignore-ssl-errors')

driver = webdriver.Chrome(options=options)

count=4040

url="https://ckey.apps.nagcprdnac.nac.tcc.net/apigw/nac-pm/pm/"
# 指定要讀取的txt檔案的路徑
import os

ws_fpath = 'C:\working_set_create\HHH'

# 初始化一個空的陣列，用於存儲每行的內容
lines = []
lines = os.listdir(ws_fpath)
# print(lines)

# # 前往網站python -m pip --version
driver.get(url)

# # 等待網頁載入完成
driver.implicitly_wait(16)

time.sleep(5)
# # 在搜尋欄位輸入文字
search_bar = driver.find_element(By.ID,'target2')
search_bar.send_keys('omc')
search_bar = driver.find_element(By.ID,'login-password')
search_bar.send_keys('Vision*1')
# # 點擊搜尋按鈕
search_button = driver.find_element(By.ID,'sbtbtn')
search_button.click()
time.sleep(9)
#search_button = driver.find_element(By.ID,'kc-accept')
#print("kc-accept completed")
#search_button.click()
time.sleep(16)

#search_button = driver.find_element(By.ID,'csfWidgets-banner-appBanner-sideDrawerButton-content')
#search_button.click()
#search_button = driver.find_element(By.ID,'contentExplorer')
#search_button.click()
#time.sleep(10)
search_button = driver.find_element(By.XPATH, '//*[@id="tab-working-set"]')
search_button.click()
print("button_clicked_clicked成功進入working set")
time.sleep(10)
#url="https://arc31was.arc31.netact.tcc.net/NetworkElementAccessControl/html/neacui.jsf"
#driver.get(url)
for fileName in lines:
	print(fileName)
	#//*[@id="import-button"]
	search_button = driver.find_element(By.XPATH, '//*[@id="import-button"]')
	search_button.click()
	print("import process on here end 在這裡")
	# wait = WebDriverWait(driver, 10)
	# upload_input = wait.until(EC.element_to_be_clickable((By.XPATH, '//*[@id="csfWidgets-fileUploader"]/div/div[1]/div/div[2]/span[3]')))
	# upload_input = driver.find_element_by_xpath('//*[@id="csfWidgets-fileUploader"]/div/div[1]/div/div[2]/span[3]')
	# upload_input = driver.find_element_by_xpath('//*[@id="csfWidgets-fileUploader"]/div/div[1]/div/div[2]/span[3]')
	time.sleep(2)
	wait = WebDriverWait(driver, 1)
	upload_input = wait.until(EC.element_to_be_clickable((By.XPATH, '//*[@id="csfWidgets-fileUploader"]/div/div[1]/div/input')))
	#//
	# 點擊上傳檔案元素，觸發檔案選擇對話框
	#upload_input.click()
	#upload_input = driver.find_element(By.ID,'csfWidgets-fileUploader')  # 替換為實際的元素ID或XPath

	# 指定要上傳的檔案的路徑
	file_path = os.path.join(ws_fpath,fileName)  # 替換為實際的檔案路徑 
	print("檔案上傳file upload process")
	#print(file_path)
	# 將檔案路徑輸入到上傳輸入框
	upload_input.send_keys(file_path)
	rname = fileName.replace('.csv','')
	#driver.execute_script("arguments[0].value = arguments[1];", upload_input, file_path)
	search_bar = driver.find_element(By.XPATH, '//*[@id="textInput-textInput"]')
	search_bar.send_keys(rname)
	wait = WebDriverWait(driver, 1)
	time.sleep(1)
	search_bar = wait.until(EC.element_to_be_clickable((By.XPATH, '//*[@id="working-set-import-dialog"]/div/div[2]/div/div[2]/div[4]/div/textarea')))
	#search_bar = driver.find_element(By.ID,'textInput-textInput-errorMsg')//*[@id="textInput-textInput"]
	search_bar.send_keys(rname)
	# 提交表單
	submit_button = driver.find_element(By.XPATH, '//*[@id="import-content"]')  # 替換為實際的按鈕ID或XPath
	submit_button.click()
	# print(fileName.replace('.csv',''))
	time.sleep(3)
	count+=1
	print(count,"of file already uploaded",fileName,"working set create finished")
	



'''search_bar = driver.find_element(By.ID,'cnumList:dataTableCnum:cnumStatusFilterBox')
search_bar.send_keys('Not')
search_bar.send_keys(Keys.ENTER)
time.sleep(5)

# 找到下拉式選單元素
select_element = driver.find_element(By.ID,"cnumList:dataTableCnum:recordsCount")



# 將 Select 類別初始化為該元素
select = Select(select_element)
# 選擇指定值
select.select_by_value("100")


while True:

    #單台迴圈
    while True:
        try:
            select_element = driver.find_element(By.NAME,"cnumList:dataTableCnum:"+str(counter)+":oPTSAccessTypeList")
            print("trying "+str(counter))
            select = Select(select_element)
            select.select_by_value("PREFER TLS")
            time.sleep(2)
            print("pass " + str(counter))
            break
        except:
            pass

    counter += 1
    if counter%100==0:#####
        counter=0
        search_button = driver.find_element(By.ID, 'cnumList:dataTableCnum:chkAllRows')
        search_button.click()
        time.sleep(2)
        search_button = driver.find_element(By.ID, 'cnumList:startActivation')
        search_button.click()
        time.sleep(16)
        # 點擊按鈕
        # except:
        #     break

'''
# 關閉瀏覽器
print("Process finished")
driver.quit()
