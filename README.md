# MinerSchedule
This script can be used to start and stop a cryptocurrency miner on a schedule.

MinerSchedule is very easy to use, with minimal steps for installation and configuration.

## Installing MinerSchedule:
- Download, install, and configure your cryptocurrency miner of choice (the miner configured by default in the script is t-rex, with unMineable as the mining pool)
- Download the `MinerSchedule.ps1` script and save it to your desired location
- Configure `MinerSchedule.ps1` using your text editor of choice - configuration is located at the top of the MinerSchedule.ps1 file in the `User variables` section

## Configuring MinerSchedule
- $StartTime - the time to start the miner each day (format: HH:MM:SSam or HH:MM:SSpm)
- $StopTime - the time to stop the miner each day (format: HH:MM:SSam or HH:MM:SSpm)
- $MinerCommand - the full path of the miner binary with the command-line arguments for the miner
- $MinerProcess - the string of the miner binary filename, including .exe

Note: `$StartTime` and `$StopTime` are both rough start and stop times. The actual miner start time will occur within plus or minus 5 minutes of the configured start time and stop times occur within plus or minus 15 minutes.

## Running MinerSchedule
- Once the previous steps have been completed, right-click on the `MinerSchedule.ps1` script then click `Run with PowerShell`
- Leave the script running and the script will start and stop your configured cryptocurrency miner every day at the desired times.
