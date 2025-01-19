# 保存为 Get-InstalledSoftwareAndKBIDs.ps1

# 获取主机名
$hostname = $env:COMPUTERNAME

# 定义保存结果的文件路径，文件名中包含主机名
$applicationsOutput = "C:\${hostname}_SW_list.csv"
$hotfixesOutput = "C:\${hostname}_KBID.csv"

# 获取已安装的应用程序信息
$apps = Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version

# 获取已安装的 KBIDs 信息
$kbids = Get-HotFix | Select-Object -Property HotFixID

# 将结果导出到 CSV 文件，保存到 C: 盘，文件名中包含主机名
$apps | Export-Csv -Path $applicationsOutput -NoTypeInformation
$kbids | Export-Csv -Path $hotfixesOutput -NoTypeInformation

# 输出提示信息
Write-Output "Installed applications and KBIDs have been exported to C: drive:"
Write-Output $applicationsOutput
Write-Output $hotfixesOutput

# 自我删除脚本文件
$scriptPath = $MyInvocation.MyCommand.Path
Start-Sleep -Seconds 24  # 等待 2 秒以确保文件操作完成
Start-Sleep -Seconds 2

# 删除生成的 CSV 文件
Remove-Item -Path $applicationsOutput -Force
Remove-Item -Path $hotfixesOutput -Force

Remove-Item -Path $scriptPath -Force
