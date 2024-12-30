# Retrieve a list of processes running on the system
Get-Process |

# Select all properties of each process and add a new property named 'Timestamp' with the current date and time in the format 'MM-dd-yy hh:mm:ss'
Select-Object -Property *, @{Name = 'Timestamp'; Expression = { Get-Date -Format 'MM-dd-yy hh:mm:ss' }} |

# Export the data to an Excel workbook located at the path '.\Processes.xlsx' and specify the name of the worksheet where the data will be exported
Export-Excel -Path .\Processes.xlsx -WorksheetName 'ProcessesOverTime'
