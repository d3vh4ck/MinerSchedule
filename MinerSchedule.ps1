#
# MinerSchedule PowerShell script
#
# Version: 0.0.1
# Description: This script can be used to start and stop a cryptocurrency miner on a schedule.
# Author: d3vh4ck
#

# User variables
$StartTime = '7:30:00am'
$StopTime = '6:00:00pm'
$MinerCommand = 'C:\Users\user\Desktop\t-rex-0.26.8-win\t-rex.exe -a firopow -o stratum+ssl://firopow-us.unmineable.com:443 -u SHIB:wallet.Worker01#referralcode -p x --no-strict-ssl'
$MinerProcess = "t-rex.exe"

# Global variables
$global:MinerRunning = $false

# Remove .exe from the end of the miner process name
$MinerProcess = $MinerProcess.Substring(0, $MinerProcess.Length - 4)

function Miner-Running
{
	if (Get-Process | Where {$_.Name -eq $MinerProcess})
	{
		"`r`n[#] Miner process detected running."
		$global:MinerRunning = $true
	} else {
		"`r`n[#] Miner process NOT detected running."
		$global:MinerRunning = $false
	}
}

# Function to start the miner process
function Start-Miner
{
	# Don't need to start the miner if it's already started
	if (Get-Process | Where {$_.Name -eq $MinerProcess})
	{
		return
	}

	while ($true)
	{
		"[#] Miner process start attempt..."
		Start-Process cmd.exe "/c $MinerCommand"
		Start-Sleep -Seconds 5
		if (Get-Process | Where {$_.Name -eq $MinerProcess})
		{
			return
		}
	}
}

# Function to stop the miner process
function Stop-Miner
{
	# Loop until the miner process is terminated
	while (Get-Process | Where {$_.Name -eq $MinerProcess})
	{
		"[#] Miner process stop attempt..."
		$result = Stop-Process -Name $MinerProcess -Force
		Start-Sleep -Seconds 5
	}
}

function Show-Times
{
	$CurrentTime = Get-Date
	"[#] Current time: $CurrentTime"
	"[#] Start time: $StartTime"
	"[#] Stop time: $StopTime"
}

# Script banner
"Miner_Schedule v0.0.1"

# Check to see if the miner process is running
Miner-Running

# Check to see if the miner is already running and abort if already running
if ($global:MinerRunning)
{
	# Do not start the script if the miner is already running
	"[!] Aborting..."
	Start-Sleep -Seconds 5
} else {
	"[#] Starting script..."

	while ($true)
	{
		Miner-Running

		if ($global:MinerRunning -eq $false)
		{
			if ((Get-Date -Date $StartTime) -gt (Get-Date))
			{
				# Sleep if not time to start the miner
				$CurrentTime = Get-Date
				Show-Times
				"[#] Scheduled time not reached. Sleeping for 5 minutes..."
				Start-Sleep -Seconds 300
			}
			# If the miner start time has been reached and it's not after the stop time
			elseif ((Get-Date -Date $StartTime) -lt (Get-Date) -and (Get-Date -Date $StopTime) -gt (Get-Date))
			{
				# Run the miner once start time has been reached
				Show-Times
				"`r`n[!] Start time reached. Starting miner..."
				Start-Miner
			}
			# If the current time is after the miner start and stop times
			elseif ((Get-Date -Date $StartTime) -lt (Get-Date) -and (Get-Date -Date $StopTime) -lt (Get-Date))
			{
				$CurrentTime = Get-Date
				Show-Times
				"[#] Scheduled time not reached. Sleeping for 5 minutes..."
				Start-Sleep -Seconds 300
			}
		} else {
			# If the stop time has been reached
			if ((Get-Date -Date $StopTime) -lt (Get-Date))
			{
				# Stop the miner process when the stop time is reached
				Show-Times
				"`r`n[!] Stop time reached. Stopping miner process..."
				Stop-Miner
			} else {
				# Sleep until it's time to stop the miner process
				Show-Times
				"[#] Not time to stop the miner process. Sleeping for 15 minutes..."
				Start-Sleep -Seconds 900
			}
		}
	}
}
