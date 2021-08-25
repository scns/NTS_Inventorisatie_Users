#connecto to AzureAD

#Connect-AzureAD
<#

-Email (Unique identifier)
-Full Name
-Jobtitle
-Company
-Place
-department
-Manager

Computer

Mobile

Workspace type

-MS License

App
Personage Type

#>

Clear-Host

#$boolProefRun              = $false
$verbose                   = $true


 

$strLogFile                = "$PSScriptRoot\Logging\logging.log"
$varMaxLengthLogFile       = 50000

 



if (!(test-path $strLogFile)) {
    $logfile  = new-item -ItemType file -Path $strLogFile
}
else {
    $logfile = $strLogFile
}
$error.clear()

 

Function LOG($strText) {
    $strDatum = (get-date).ToString("yyyyMMdd HH:mm:ss")
    if ($verbose -eq $true) {
        write-host "[$($strDatum)] $($strText)"
    }
    add-content -Path $logfile "[$($strDatum)] $($strText)"
}





########## Variables ###############
$arrUsers = @();
$timer = Get-Date -UFormat %s -Millisecond 0
$path = "$PSScriptRoot\Export\Export-"+$timer+".csv"
$licNumber = 0
$devNumber = 0
$countUsers = 0
$i = 0
$y = 0
$Sku = @{
	"O365_BUSINESS_ESSENTIALS"		     = "Office 365 Business Essentials"
	"O365_BUSINESS_PREMIUM"			     = "Office 365 Business Premium"
	"DESKLESSPACK"					     = "Office 365 (Plan K1)"
	"DESKLESSWOFFPACK"				     = "Office 365 (Plan K2)"
	"LITEPACK"						     = "Office 365 (Plan P1)"
	"EXCHANGESTANDARD"				     = "Office 365 Exchange Online Only"
	"STANDARDPACK"					     = "Enterprise Plan E1"
	"STANDARDWOFFPACK"				     = "Office 365 (Plan E2)"
	"ENTERPRISEPACK"					 = "Enterprise Plan E3"
	"ENTERPRISEPACKLRG"				     = "Enterprise Plan E3"
	"ENTERPRISEWITHSCAL"				 = "Enterprise Plan E4"
	"STANDARDPACK_STUDENT"			     = "Office 365 (Plan A1) for Students"
	"STANDARDWOFFPACKPACK_STUDENT"	     = "Office 365 (Plan A2) for Students"
	"ENTERPRISEPACK_STUDENT"			 = "Office 365 (Plan A3) for Students"
	"ENTERPRISEWITHSCAL_STUDENT"		 = "Office 365 (Plan A4) for Students"
	"STANDARDPACK_FACULTY"			     = "Office 365 (Plan A1) for Faculty"
	"STANDARDWOFFPACKPACK_FACULTY"	     = "Office 365 (Plan A2) for Faculty"
	"ENTERPRISEPACK_FACULTY"			 = "Office 365 (Plan A3) for Faculty"
	"ENTERPRISEWITHSCAL_FACULTY"		 = "Office 365 (Plan A4) for Faculty"
	"ENTERPRISEPACK_B_PILOT"			 = "Office 365 (Enterprise Preview)"
	"STANDARD_B_PILOT"				     = "Office 365 (Small Business Preview)"
	"VISIOCLIENT"					     = "Visio Pro Online"
	"POWER_BI_ADDON"					 = "Office 365 Power BI Addon"
	"POWER_BI_INDIVIDUAL_USE"		     = "Power BI Individual User"
	"POWER_BI_STANDALONE"			     = "Power BI Stand Alone"
	"POWER_BI_STANDARD"				     = "Power-BI Standard"
	"PROJECTESSENTIALS"				     = "Project Lite"
	"PROJECTCLIENT"					     = "Project Professional"
	"PROJECTONLINE_PLAN_1"			     = "Project Online"
	"PROJECTONLINE_PLAN_2"			     = "Project Online and PRO"
	"ProjectPremium"					 = "Project Online Premium"
	"ECAL_SERVICES"					     = "ECAL"
	"EMS"							     = "Enterprise Mobility Suite"
	"RIGHTSMANAGEMENT_ADHOC"			 = "Windows Azure Rights Management"
	"MCOMEETADV"						 = "PSTN conferencing"
	"SHAREPOINTSTORAGE"				     = "SharePoint storage"
	"PLANNERSTANDALONE"				     = "Planner Standalone"
	"CRMIUR"							 = "CMRIUR"
	"BI_AZURE_P1"					     = "Power BI Reporting and Analytics"
	"INTUNE_A"						     = "Windows Intune Plan A"
	"PROJECTWORKMANAGEMENT"			     = "Office 365 Planner Preview"
	"ATP_ENTERPRISE"					 = "Exchange Online Advanced Threat Protection"
	"EQUIVIO_ANALYTICS"				     = "Office 365 Advanced eDiscovery"
	"AAD_BASIC"						     = "Azure Active Directory Basic"
	"RMS_S_ENTERPRISE"				     = "Azure Active Directory Rights Management"
	"AAD_PREMIUM"					     = "Azure Active Directory Premium"
	"MFA_PREMIUM"					     = "Azure Multi-Factor Authentication"
	"STANDARDPACK_GOV"				     = "Microsoft Office 365 (Plan G1) for Government"
	"STANDARDWOFFPACK_GOV"			     = "Microsoft Office 365 (Plan G2) for Government"
	"ENTERPRISEPACK_GOV"				 = "Microsoft Office 365 (Plan G3) for Government"
	"ENTERPRISEWITHSCAL_GOV"			 = "Microsoft Office 365 (Plan G4) for Government"
	"DESKLESSPACK_GOV"				     = "Microsoft Office 365 (Plan K1) for Government"
	"ESKLESSWOFFPACK_GOV"			     = "Microsoft Office 365 (Plan K2) for Government"
	"EXCHANGESTANDARD_GOV"			     = "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
	"EXCHANGEENTERPRISE_GOV"			 = "Microsoft Office 365 Exchange Online (Plan 2) only for Government"
	"SHAREPOINTDESKLESS_GOV"			 = "SharePoint Online Kiosk"
	"EXCHANGE_S_DESKLESS_GOV"		     = "Exchange Kiosk"
	"RMS_S_ENTERPRISE_GOV"			     = "Windows Azure Active Directory Rights Management"
	"OFFICESUBSCRIPTION_GOV"			 = "Office ProPlus"
	"MCOSTANDARD_GOV"				     = "Lync Plan 2G"
	"SHAREPOINTWAC_GOV"				     = "Office Online for Government"
	"SHAREPOINTENTERPRISE_GOV"		     = "SharePoint Plan 2G"
	"EXCHANGE_S_ENTERPRISE_GOV"		     = "Exchange Plan 2G"
	"EXCHANGE_S_ARCHIVE_ADDON_GOV"	     = "Exchange Online Archiving"
	"EXCHANGE_S_DESKLESS"			     = "Exchange Online Kiosk"
	"SHAREPOINTDESKLESS"				 = "SharePoint Online Kiosk"
	"SHAREPOINTWAC"					     = "Office Online"
	"YAMMER_ENTERPRISE"				     = "Yammer Enterprise"
	"EXCHANGE_L_STANDARD"			     = "Exchange Online (Plan 1)"
	"MCOLITE"						     = "Lync Online (Plan 1)"
	"SHAREPOINTLITE"					 = "SharePoint Online (Plan 1)"
	"OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ" = "Office ProPlus"
	"EXCHANGE_S_STANDARD_MIDMARKET"	     = "Exchange Online (Plan 1)"
	"MCOSTANDARD_MIDMARKET"			     = "Lync Online (Plan 1)"
	"SHAREPOINTENTERPRISE_MIDMARKET"	 = "SharePoint Online (Plan 1)"
	"OFFICESUBSCRIPTION"				 = "Office ProPlus"
	"YAMMER_MIDSIZE"					 = "Yammer"
	"DYN365_ENTERPRISE_PLAN1"		     = "Dynamics 365 Customer Engagement Plan Enterprise Edition"
	"ENTERPRISEPREMIUM_NOPSTNCONF"	     = "Enterprise E5 (without Audio Conferencing)"
	"ENTERPRISEPREMIUM"				     = "Enterprise E5 (with Audio Conferencing)"
	"MCOSTANDARD"					     = "Skype for Business Online Standalone Plan 2"
	"PROJECT_MADEIRA_PREVIEW_IW_SKU"	 = "Dynamics 365 for Financials for IWs"
	"STANDARDWOFFPACK_IW_STUDENT"	     = "Office 365 Education for Students"
	"STANDARDWOFFPACK_IW_FACULTY"	     = "Office 365 Education for Faculty"
	"EOP_ENTERPRISE_FACULTY"			 = "Exchange Online Protection for Faculty"
	"EXCHANGESTANDARD_STUDENT"		     = "Exchange Online (Plan 1) for Students"
	"OFFICESUBSCRIPTION_STUDENT"		 = "Office ProPlus Student Benefit"
	"STANDARDWOFFPACK_FACULTY"		     = "Office 365 Education E1 for Faculty"
	"STANDARDWOFFPACK_STUDENT"		     = "Microsoft Office 365 (Plan A2) for Students"
	"DYN365_FINANCIALS_BUSINESS_SKU"	 = "Dynamics 365 for Financials Business Edition"
	"DYN365_FINANCIALS_TEAM_MEMBERS_SKU" = "Dynamics 365 for Team Members Business Edition"
	"FLOW_FREE"						     = "Microsoft Flow Free"
	"POWER_BI_PRO"					     = "Power BI Pro"
	"O365_BUSINESS"					     = "Office 365 Business"
	"DYN365_ENTERPRISE_SALES"		     = "Dynamics Office 365 Enterprise Sales"
	"RIGHTSMANAGEMENT"				     = "Rights Management"
	"PROJECTPROFESSIONAL"			     = "Project Professional"
	"VISIOONLINE_PLAN1"				     = "Visio Online Plan 1"
	"EXCHANGEENTERPRISE"				 = "Exchange Online Plan 2"
	"DYN365_ENTERPRISE_P1_IW"		     = "Dynamics 365 P1 Trial for Information Workers"
	"DYN365_ENTERPRISE_TEAM_MEMBERS"	 = "Dynamics 365 For Team Members Enterprise Edition"
	"CRMSTANDARD"					     = "Microsoft Dynamics CRM Online Professional"
	"EXCHANGEARCHIVE_ADDON"			     = "Exchange Online Archiving For Exchange Online"
	"EXCHANGEDESKLESS"				     = "Exchange Online Kiosk"
	"SPZA_IW"						     = "App Connect"
	"WINDOWS_STORE"					     = "Windows Store for Business"
	"MCOEV"							     = "Microsoft Phone System"
	"VIDEO_INTEROP"					     = "Polycom Skype Meeting Video Interop for Skype for Business"
	"SPE_E5"							 = "Microsoft 365 E5"
	"SPE_E3"							 = "Microsoft 365 E3"
	"ATA"							     = "Advanced Threat Analytics"
	"MCOPSTN2"						     = "Domestic and International Calling Plan"
	"FLOW_P1"						     = "Microsoft Flow Plan 1"
	"FLOW_P2"						     = "Microsoft Flow Plan 2"
	"CRMSTORAGE"						 = "Microsoft Dynamics CRM Online Additional Storage"
	"SMB_APPS"						     = "Microsoft Business Apps"
	"MICROSOFT_BUSINESS_CENTER"		     = "Microsoft Business Center"
	"DYN365_TEAM_MEMBERS"			     = "Dynamics 365 Team Members"
	"STREAM"							 = "Microsoft Stream Trial"
	"EMSPREMIUM"                         = "ENTERPRISE MOBILITY + SECURITY E5"
    "IDENTITY_THREAT_PROTECTION_FACULTY" = "Identity Protection Faculty"
	"THREAT_INTELLIGENCE"                = "Threat Intelligence"
    "DYN365_BUSCENTRAL_PREMIUM"          = "Dynamics 365 Business Central Premium"
}


$action  = Copy-Item $strLogFile -Destination "$strLogFile$timer.log"
$action  = remove-item $strLogFile -Force
$action  = add-content -Path $strLogFile $null


LOG "[INFO] // START RUN"



$UsersArray = New-Object psobject

#Get-AzureADUser -All $true
#$AzureADSubscribedSKU = Get-AzureADSubscribedSku |select SKU*


try 
{ $vargetazuread = Get-AzureADTenantDetail } 

catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException] 
{ LOG [WARNING] "You're not connected."; Connect-AzureAD}

Connect-MgGraph "device.read.all"



if ($AzureADUserARR) {
    write-host "Er is al data aanwezig. Deze data opnieuw inlezen?"
    LOG "[INFO] er is al data aanwezig"
    write-host "LET OP. Het vernieuwen van de gegevens kan enige tijd in beslag nemen. Afhankelijk van de hoeveelheid data die opgehaald moet worden."
    $refresh = Read-Host -prompt "y/n"
    LOG "[INFO] $refresh"
}else{

    $refresh = "y"
    }
 

If ($refresh -eq "y"){

     LOG "[INFO] Data Inlezen"
     LOG "[INFO] Preparing AzureAD Users" 
     #$AzureADUserARR = Get-AzureADUser -all $true |Select-Object objectid,UserPrincipalName, Displayname, GivenName, Surname, Jobtitle, companyname, City, Department, manager, assignedlicenses 
     $AzureADUserARR = Get-AzureADUser -Top 300 |Select-Object objectid,UserPrincipalName, Displayname, GivenName, Surname, Jobtitle, companyname, City, Department, manager, assignedlicenses 
     LOG "[INFO] Found $($AzureADUserARR.COUNT) Users"
     LOG "[INFO] Preparing AzureAD Devices" 
     $devices = Get-MgDevice -All
     

     LOG "[INFO] Found $($devices.COUNT) Devices"
 }





$countUsers = $AzureADUserARR.Count

#dummy info
        $UsersArray = New-Object psobject
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name UserPrincipalName -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DisplayName -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name GivenName -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name SurName -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Jobtitle -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name CompanyName -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name City -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Department -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name ManagerName -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name ManagerUPN -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie1 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie2 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie3 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie4 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie5 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie6 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie7 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie8 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie9 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie10 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name TotalLic -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device1 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS1 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion1 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor1 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model1 -Value "DUMMY"
                Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device2 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS2 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion2 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor2 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model2 -Value "DUMMY"
                Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device3 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS3 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion3 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor3 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model3 -Value "DUMMY"
                Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device4 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS4 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion4 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor4 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model4 -Value "DUMMY"
                Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device5 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS5 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion5 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor5 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model5 -Value "DUMMY"
                Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device6 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS6 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion6 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor6 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model6 -Value "DUMMY"
                Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device7 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS7 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion7 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor7 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model7 -Value "DUMMY"
                Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device8 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS8 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion8 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor8 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model8 -Value "DUMMY"
                Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device9 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS9 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion9 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor9 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model9 -Value "DUMMY"
                Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device10 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS10 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion10 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor10 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model10 -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name TotalDevices -Value "DUMMY"
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name GroupMemberships -Value "DUMMY"

        $arrUsers += $UsersArray

ForEach ($AzureADUser in $AzureADUserARR){
    Log "[INFO] ******************* NEW USER *******************"
    if (($AzureADUser.UserPrincipalName -notLike '*#EXT#*') -AND ($AzureADUser.UserPrincipalName -notLike '*admin*' ))  {
      
        $UsersArray = New-Object psobject
        $upn = $AzureADUser.UserPrincipalName
        $y=0
        $i++
        $MemberString = $null

    Write-Progress -Activity "Progress users" `
        -CurrentOperation "$upn ($i from in total $($AzureADUserARR.count))" `
        -PercentComplete (($i*100)/$countUsers) `
        -Status "$(([math]::Round((($i)/$countUsers * 100),2))) %" `
        -id 1
    
        LOG "[INFO] Exporting UserDetails $upn ... " -ForegroundColor Green



        ############# defaultInformation

        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name UserPrincipalName -Value $AzureADUser.UserPrincipalName
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DisplayName -Value $AzureADUser.DisplayName
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name GivenName -Value $AzureADUser.GivenName
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name SurName -Value $AzureADUser.Surname
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Jobtitle -Value $AzureADUser.JobTitle
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name CompanyName -Value $AzureADUser.CompanyName
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name City -Value $AzureADUser.City
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Department -Value $AzureADUser.Department

        ############ Get Groupmemberships:

        $AzureADUserGroups = Get-AzureADUserMembership -ObjectId $AzureADUser.objectid

        LOG "[INFO] groupmemberships"
        
        ForEach ($AzureADUserGroup in $AzureADUserGroups){


            if ($AzureADUserGroup -like "*AG_*"){

                LOG "[INFO]  $($AzureADUserGroup.displayname)"
                $MemberString += $($AzureADUserGroup.displayname) 
                $MemberString += "`r`n"

                if ($AzureADUserGroup.displayname -like "AAD_AG_MEET_Nebato_Users")

                {
                    Log "[INFO] NEBATO.LOCAL user"

                    $secpasswd = ConvertTo-SecureString "v_zzASPLDuZ/2KE" -AsPlainText -Force
                    $mycreds = New-Object System.Management.Automation.PSCredential ("sa.ldap.wiki.e", $secpasswd)

                    $samaccountname = (get-aduser -filter "UserPrincipalName -eq '$($AzureADUser.UserPrincipalName)'"  -Server "nebato.local" -Credential $mycreds).samaccountname

                    $NebatoGroups = (Get-ADPrincipalGroupMembership -Identity $samaccountname -Server "nebato.local" -Credential $mycreds -ResourceContextServer nebato.local).name

                    ForEach ($NebatoGroup in $NebatoGroups){


                      if ($NebatoGroup -like "*G_APP*"){

                          Log "[INFO] $NebatoGroup"
                          $MemberString += $($NebatoGroup) 
                          $MemberString += "`r`n"


                        }
                      
                }

            }
            
         }    
        }

        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name GroupMemberships -Value $MemberString
        $MemberString = $null

        #LOG "[INFO] $MemberString"
        
        ############ Manager
    
        LOG "[INFO] Exporting Manager $upn ... " -ForegroundColor Green

        $AzureADuserManager = Get-AzureADUserManager -ObjectId $AzureADUser.UserPrincipalName

        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name ManagerName -Value $AzureADuserManager.DisplayName
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name ManagerUPN -Value $AzureADuserManager.UserPrincipalName

        ############# Lic
        LOG "[INFO] Finding Licenses $upn ... " -ForegroundColor Green

        ForEach ($lic in $azureaduser.AssignedLicenses)
            {
            $licNumber++
    
            $License = Get-AzureADSubscribedSku |select SKU* | where SKUid -like $lic.SkuId
            $lic = $license.SkuPartNumber

            LOG "[INFO] Finding $lic in the Hash Table..."
			
                    $LicenseItem = $lic -split ":" | Select-Object -Last 1
			        $TextLic = $Sku.Item("$LicenseItem")

            If (!($TextLic))
			        {

				        LOG "[ERROR]  The Hash Table has no match for $LicenseItem for $upn!" -ForegroundColor Red
				        $LicenseFallBackName = $License.AccountSkuId
				        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie$licNumber -Value $license.SkuPartNumber
                        #$license.SkuPartNumber
			        }
			        Else
			        {
				        LOG "[INFO]  The Hash Table has a match for $LicenseItem for $upn!"
                    
				        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Licentie$licNumber -Value $textlic
                    
			        }
          
    
            }
      Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name TotalLic -Value $licNumber
      $licNumber = 0

      
        
      
  
      ################### DEVICES
      LOG [INFO] Finding Devices

      ForEach ($device in $devices){
      $y++
      
  

      Write-Progress -Activity "Progress Devices" `
        -CurrentOperation "$($device.displayname) ($y from in total $($devices.count))" `
        -PercentComplete (($y*100)/$($devices.count)) `
        -Status "$(([math]::Round((($y)/$($devices.count) * 100),2))) %" `
        -ParentId 1
        

        $owner = $device.physicalids | ? -FilterScript {$_ -like "*USER-GID*"} 
        $owner = $owner -split ":" |Select-Object -Skip 1 | Select-Object -First 1
        
        #$AzureADUser.objectid



        if ($owner -eq $AzureADUser.objectid){ 
        $devNumber++
        Log  "[INFO] Device Found $($device.DisplayName)"

        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Device$devNumber -Value $device.DisplayName
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOS$devNumber -Value $device.OperatingSystem
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name DeviceOSVersion$devNumber -Value $device.OperatingSystemVersion
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Vendor$devNumber -Value $device.AdditionalProperties.manufacturer
        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name Model$devNumber -Value $device.AdditionalProperties.model

        
        }
  




}

        Add-Member -InputObject $UsersArray -MemberType NoteProperty -Name TotalDevices -Value $devNumber
        $devNumber = 0
        $arrUsers += $UsersArray

    } Else {LOG "[INFO]  $($AzureADUser.UserPrincipalName) is an Excluded user. Skipping this user" 
            $i++}
    
    
   }

#### EXPORT ####



$arrUsers | Export-Csv $path -Delimiter ';' -NoTypeInformation -Encoding UTF8


LOG "// END RUN"



