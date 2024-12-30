Get-Service | Select-Object -Property Name,Status,@{
    Name = 'Timestamp';
    Expression = { Get-Date -Format 'MM-dd-yy hh:mm:ss' }
} | Export-Excel .\ServiceStates.xlsx -WorksheetName 'Services' -Autosize -Append

#create a pivot data
Import-Excel .\ServiceStates.xlsx -WorksheetName 'Services' | Export-Excel -Path .\ServiceStates.xlsx 
-Show -IncludePivotTable -PivotRows Name,Timestamp
-PivotData @{Timestamp = 'count'} -PivotColumns Status