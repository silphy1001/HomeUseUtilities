# HomeUseUtilities
Collection of home use utilities
## Environments
| Module | Version |
----|----
| OS | Windows 10 Pro 64bit Version 21H1 Build 19043.1415 |
| Power Automate Desktop | 2.15.284.21354 |
| PowerShell | 5.1.19041.1320 |
| TaskScheduler | 1.0 |
## Development Tools
| Module | Version |
----|----
| Windows Terminal | 1.11.3471.0 |
| Visual Studio Code | 1.63.2 |
| git | 2.34.1.windows.1 |
## Descriptions
### opticalDriveOperation.ps1
* source code file is encoded to Shift-JIS
* remote controller for optical drive
* extensible for commands
* output messages are localized for Japanese
### PADProcessChecker.ps1
* This script to check PAD's process.
* If PAD's process not found, this script notifies on Discord using WebHook
* This script is launched by Task-Scheduler.
* WebHook URL is specified as an argument of task in Task-Scheduler.
* PAD means "Power Automate Desktop" that is a product of Microsoft.
* This is a part of RPA system made by me.
  * The flow defined in PAD gets detailed statements of ETC at every 15th.
  * This script checks the status of the flow before execution.
  * PAD's script is managed on OneDriver Personal.
