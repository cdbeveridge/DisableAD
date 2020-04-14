#Author: Chris Beveridge
#Creation Date: 30/03/2020

#MoveADAccount.ps1 is used to disable ActiveDirectory accounts and move user and computer objects into a new OU.
#Provide a local csv and amend the path below as required. 
#csv column headers are comps and users
#the script will write to a csv the original OU before moving the objects

import-module ActiveDirectory

$accounts = Import-Csv ("C:\temp\accounts.csv")
Foreach($pc in $accounts.comps){
Disable-ADAccount -Identity "$pc"
Get-ADComputer -Identity "$pc" | select DistinguishedName >> C:\Temp\OriginalOU.csv 
Get-ADComputer -Identity "$pc" | Move-ADObject -TargetPath "OU=PC Destination,OU=Computers,DC=Domain,DC=com"
Write-Host("$pc has been disabled and moved to the PC Destination Devices OU")
}
foreach($user in $accounts.users){
Disable-ADAccount -Identity $user
Get-ADUser -Identity "$user" | select DistinguishedName >> C:\Temp\OriginalOU.csv
Get-ADUser -Identity "$user" | Move-ADObject -TargetPath "OU=User Destination,OU=Computers,DC=Domain,DC=com"
Write-Host("$user has been disabled and moved to the User Destination OU")
}