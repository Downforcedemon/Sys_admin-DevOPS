# IIS Troubleshooting Script with Multiple Default Log Paths
Write-Host "IIS Troubleshooting Script" -ForegroundColor Cyan

# Default IIS Logs Paths
$defaultLogPaths = @("C:\inetpub\logs\LogFiles\W3SVC1", "C:\inetpub\logs\LogFiles\W3SVC2")

# Function to Check Application Pool Status
function Get-AppPoolStatus {
    Write-Host "`nChecking Application Pool Status..."
    $appPoolName = Read-Host "Enter the Application Pool Name"
    $appPoolStatus = Get-WebAppPoolState -Name $appPoolName

    if ($appPoolStatus.Status -eq "Started") {
        Write-Host "Application Pool '$appPoolName' is running." -ForegroundColor Green
    } else {
        Write-Host "Application Pool '$appPoolName' is not running. Attempting to start..." -ForegroundColor Yellow
        Start-WebAppPool -Name $appPoolName
        Write-Host "Application Pool '$appPoolName' started successfully." -ForegroundColor Green
    }
}

# Function to Check Website Status
function Get-WebsiteStatus {
    Write-Host "`nChecking Website Status..."
    $siteName = Read-Host "Enter the Website Name"
    $siteStatus = (Get-Website -Name $siteName).State

    if ($siteStatus -eq "Started") {
        Write-Host "Website '$siteName' is running." -ForegroundColor Green
    } else {
        Write-Host "Website '$siteName' is not running. Attempting to start..." -ForegroundColor Yellow
        Start-Website -Name $siteName
        Write-Host "Website '$siteName' started successfully." -ForegroundColor Green
    }
}

# Function to Analyze IIS Logs with Line Output
function Test-IISLogs {
    Write-Host "`nAnalyzing IIS Logs..."
    $logPaths = Read-Host "Enter IIS Log File Path (Press Enter to use default paths: $($defaultLogPaths -join ', '))"
    if (-not $logPaths) { $logPaths = $defaultLogPaths }

    $errorCodes = Read-Host "Enter the HTTP status codes or patterns to search for (comma-separated, e.g., 500,404,GET)" -split ","
    if (-not $errorCodes) {
        Write-Host "No status codes or patterns entered. Exiting log analysis." -ForegroundColor Yellow
        return
    }

    foreach ($path in $logPaths) {
        if (-not (Test-Path $path)) {
            Write-Host "Log path '$path' does not exist. Skipping..." -ForegroundColor Yellow
            continue
        }

        $logFiles = Get-ChildItem -Path $path -Filter *.log -ErrorAction SilentlyContinue
        if (-not $logFiles) {
            Write-Host "No log files found in '$path'. Skipping..." -ForegroundColor Yellow
            continue
        }

        foreach ($logFile in $logFiles) {
            Write-Host "`nAnalyzing file: $($logFile.FullName)" -ForegroundColor Cyan
            $fileContent = Get-Content -Path $logFile.FullName -ErrorAction SilentlyContinue
            if (-not $fileContent) {
                Write-Host "Unable to read file '$($logFile.FullName)'. Skipping..." -ForegroundColor Yellow
                continue
            }

            foreach ($code in $errorCodes) {
                $logmatches = $fileContent | Select-String -Pattern "\s$code\s"
                $count = $logmatches.Count
                Write-Host "  Error $code in $($logFile.Name): $count occurrences" -ForegroundColor Yellow
                
                # Display the matching lines if any occurrences are found
                if ($count -gt 0) {
                    Write-Host "    Matching lines:" -ForegroundColor Green
                    $logmatches | ForEach-Object { Write-Host "      $_" -ForegroundColor White }
                }
            }
        }
    }
}



# Function to Check Event Viewer
function Get-EventViewerErrors {
    Write-Host "`nChecking IIS-Related Event Logs..."
    $iisLogs = Get-EventLog -LogName Application -Newest 20 | Where-Object { $_.Message -like "*IIS*" }

    if ($iisLogs) {
        Write-Host "Recent IIS Errors/Warnings:" -ForegroundColor Yellow
        $iisLogs | ForEach-Object {
            Write-Host "  Event ID: $($_.EventID), Message: $($_.Message)"
        }
    } else {
        Write-Host "No IIS-related events found in the Event Viewer." -ForegroundColor Green
    }
}

# Function to Analyze Slow Requests
function Test-SlowRequests {
    Write-Host "`nChecking Request Execution Times..."
    $logPath = Read-Host "Enter IIS Log File Path (Press Enter to use default paths: $($defaultLogPaths -join ', '))"
    if (-not $logPath) { $logPath = $defaultLogPaths }

    $slowThreshold = Read-Host "Enter threshold for slow requests in milliseconds (e.g., 2000)"

    foreach ($path in $logPath) {
        $slowRequests = Select-String -Path "$path\*.log" -Pattern "\d+$slowThreshold"
        if ($slowRequests) {
            Write-Host "Slow requests found exceeding $slowThreshold ms in `${path}`:" -ForegroundColor Yellow
            $slowRequests | ForEach-Object { Write-Host $_.Line }
        } else {
            Write-Host "No slow requests detected in `${path}`." -ForegroundColor Green
        }
    }
}

# Main Menu
function Show-Menu {
    Write-Host "`nSelect an option to troubleshoot:" -ForegroundColor Cyan
    Write-Host "1. Get Application Pool Status"
    Write-Host "2. Get Website Status"
    Write-Host "3. Test IIS Logs for Errors"
    Write-Host "4. Get Event Viewer Errors"
    Write-Host "5. Test for Slow Requests"
    Write-Host "6. Exit"
}

# Main Loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-6)"
    switch ($choice) {
        "1" { Get-AppPoolStatus }
        "2" { Get-WebsiteStatus }
        "3" { Test-IISLogs }
        "4" { Get-EventViewerErrors }
        "5" { Test-SlowRequests }
        "6" { Write-Host "Exiting Troubleshooting Script." -ForegroundColor Cyan }
        default { Write-Host "Invalid choice. Please select again." -ForegroundColor Red }
    }
} while ($choice -ne "6")
