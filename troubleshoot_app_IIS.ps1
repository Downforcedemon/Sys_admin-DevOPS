# IIS Troubleshooting Script
Write-Host "Starting IIS Troubleshooting Script..." -ForegroundColor Cyan

# Step 1: Verify Application Pool Status
Write-Host "`nStep 1: Checking Application Pool Status..."
$appPoolName = Read-Host "Enter the Application Pool Name"
$appPoolStatus = Get-WebAppPoolState -Name $appPoolName

if ($appPoolStatus.Status -eq "Started") {
    Write-Host "Application Pool '$appPoolName' is running." -ForegroundColor Green
} else {
    Write-Host "Application Pool '$appPoolName' is not running. Attempting to start..." -ForegroundColor Yellow
    Start-WebAppPool -Name $appPoolName
    Write-Host "Application Pool '$appPoolName' started successfully." -ForegroundColor Green
}

# Step 2: Verify Website Status
Write-Host "`nStep 2: Checking Website Status..."
$siteName = Read-Host "Enter the Website Name"
$siteStatus = (Get-Website -Name $siteName).State

if ($siteStatus -eq "Started") {
    Write-Host "Website '$siteName' is running." -ForegroundColor Green
} else {
    Write-Host "Website '$siteName' is not running. Attempting to start..." -ForegroundColor Yellow
    Start-Website -Name $siteName
    Write-Host "Website '$siteName' started successfully." -ForegroundColor Green
}

# Step 3: Check Worker Process Resource Usage
Write-Host "`nStep 3: Monitoring Worker Processes (w3wp.exe)..."
$workerProcesses = Get-CimInstance -Namespace "root\WebAdministration" -ClassName WorkerProcess

if ($workerProcesses) {
    Write-Host "Worker Processes Found:" -ForegroundColor Green
    foreach ($wp in $workerProcesses) {
        Write-Host "  PID: $($wp.ProcessId), App Pool: $($wp.AppPoolName), Requests: $($wp.Requests)"
    }
} else {
    Write-Host "No worker processes are running. The application might not be handling requests." -ForegroundColor Red
}

# Step 4: Analyze IIS Logs
Write-Host "`nStep 4: Analyzing IIS Logs..."
$logPath = Read-Host "Enter IIS Log File Path (e.g., C:\inetpub\logs\LogFiles\W3SVC1)"
$errorCodes = @("500", "404")
Write-Host "Searching logs for errors (500, 404)..."

$errorCount = 0
foreach ($error in $errorCodes) {
    $matches = Select-String -Path "$logPath\*.log" -Pattern " $error " -List
    $count = $matches.Count
    Write-Host "  Error $error: $count occurrences"
    $errorCount += $count
}

if ($errorCount -eq 0) {
    Write-Host "No errors found in the logs." -ForegroundColor Green
} else {
    Write-Host "Errors detected. Check logs for details." -ForegroundColor Yellow
}

# Step 5: Event Viewer Check
Write-Host "`nStep 5: Checking IIS-Related Event Logs..."
$iisLogs = Get-EventLog -LogName Application -Source "IIS" -EntryType Error -Newest 20
if ($iisLogs) {
    Write-Host "Recent IIS Errors:" -ForegroundColor Yellow
    $iisLogs | ForEach-Object {
        Write-Host "  Event ID: $($_.EventID), Message: $($_.Message)"
    }
} else {
    Write-Host "No recent IIS errors found in the Event Viewer." -ForegroundColor Green
}

# Step 6: Check Request Execution Time
Write-Host "`nStep 6: Checking Request Execution Times..."
$slowThreshold = Read-Host "Enter threshold for slow requests in milliseconds (e.g., 2000)"
$slowRequests = Select-String -Path "$logPath\*.log" -Pattern "\d+$slowThreshold"

if ($slowRequests) {
    Write-Host "Slow requests found exceeding $slowThreshold ms:" -ForegroundColor Yellow
    $slowRequests | ForEach-Object { Write-Host $_.Line }
} else {
    Write-Host "No slow requests detected." -ForegroundColor Green
}

Write-Host "`nIIS Troubleshooting Completed." -ForegroundColor Cyan
