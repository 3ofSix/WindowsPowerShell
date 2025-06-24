$Uri = 'https://dardapps.nigov.net/WorkerStatus/Home/Update'

$Form = @{
    Name = 'Garrett Vernon'
    AdUserId = 'daera-vernong' 
    Telephone = '00000024320' 
    WorkMobile = '' 
    NormalLocation = 'Dundonald House'
    WorkingAvailability = 'Available'
    Location = 'Home'
    Status = 'NormalWorking'
    ProjectedReturndate = ''
    HasLaptop = 'true'
    HasDesktop = 'false'
    HasMobile = 'false'
    HasTablet = 'false'
    HasNoDevice = 'false'
    PersonalMobileNumber = ''
    MobileConsentGiven = 'false'
    PersonalHomeNumber = ''
    PersonalEmail = 'garrett.vernon@version1.com'
    PostCode = 'BT27'
    Comments = Get-Date
}

$Result = Invoke-WebRequest -Uri $Uri -UseDefaultCredentials -Method Post -Body $Form
echo $Result