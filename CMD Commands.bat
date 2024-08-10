#Add AzureAD account to local administrators group       
net localgroup Administrators AzureAD\Username /add

#Fix broken Windows Hello Pin/Facial
takeown /f %windir%\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /r /d y
icacls %windir%\ServiceProfiles\LocalService\AppData\Local\Microsoft\NGC /grant administrators:F /t

#DISM Repairs
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth

#Set NZ NTP Pool
net stop w32time
w32tm /config /syncfromflags:manual /manualpeerlist:nz.pool.ntp.org
w32tm /config /reliable:yes
net start w32time

#Check NTP settings
w32tm /query /configuration
w32tm /query /status

#Create an Admin User Account Using CMD Prompt
net user /add username pass

#Take ownership of folder
TAKEOWN /F "[Target Folder]" /R /D Y

#Repair ShadowProtect corrupted file
"C:\Program Files (x86)\StorageCraft\ImageManager\x64\image" v "[Backup File Path]\D_VOL-b001-i1971-cd-cw.spi"
