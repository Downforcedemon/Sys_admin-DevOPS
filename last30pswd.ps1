get-aduser -filter "enabled -eq 'true" -propeties passwordlastset | select name,passwordlastset
$today = Get-Date
$30daysago = $today.Adddays(-30)
