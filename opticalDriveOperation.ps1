###############################################################
# Pre-defines
###############################################################
<#
.supportedCommands
Current Supported Command list is defined to use Hashtable.
  key:value = "abbrevitaion":"regualar command"
  "abbreviation" must be unique.
#>
$CMD_ABR_CLOSE='c';
$CMD_ABR_OPEN='o';
$CMD_ABR_HELP='h';
$supportedCommands = @{
	$CMD_ABR_CLOSE = 'close'
	$CMD_ABR_OPEN = 'open'
	$CMD_ABR_HELP = 'help'
}
<#
.commandHelps
Describe help message against supported commands
#>
$commandHelps = @{
	$CMD_ABR_CLOSE = 'Close the optical drive'
	$CMD_ABR_OPEN = 'Open the optical drive'
	$CMD_ABR_HELP = 'Show this message'
}

<#
.regularizeCommand
Analyze input command and set processed command.
Function verify whether input command matches supported commands.
The verification behavior:
  first match
    ex1) input command = oscillator
	     matches => open
	ex2) input command = c
	     matches => close
Current Supported Commands:
  open
  close
#>
function regularizeCommand ($inputCommand) {
	foreach ($key in $supportedCommands.Keys) {
		$regex = '^' + $key + '.*$';
		if ($inputCommand.Value -match $regex) {
			$inputCommand.Value = $supportedCommands[$key];
			Write-Host ('op set to ' + $inputCommand.Value);
			return $true;
		}
	}
	return $false;
}

<#
.showHelpMessages
Show help messges.
#>
function showHelpMessages {
	$scriptname = Split-Path -Leaf $PSCommandPath
	Write-Host $scriptname.Substring(0, $scriptname.LastIndexOf('.'))
	foreach ($key in $supportedCommands.Keys) {
		Write-Host ('  ' + $key + '/' + $supportedCommands[$key] + ' --- ' + $commandHelps[$key])
	}
}
<#
.OperateOpticalDrive
Execute $command to operate optical drive.
If error has occured function doesn't process anything and show message.
#>
function operateOpticalDrive ($command) {
	$wmplayer = New-Object -ComObject WMPlayer.OCX;
	$wmplayer.cdromCollection.Item(0).Eject();
	if ($command -eq $supportedCommands[$CMD_ABR_CLOSE]) {
		$wmplayer.cdromCollection.Item(0).Eject();
	}
}

<#
.executeCommand
Execute $command.
If $command is the command to operate optical drive, function calls nested function.
#>
function executeCommand ($command) {
	if ($command -eq $supportedCommands[$CMD_ABR_HELP]) {
		showHelpMessages
	} else {
		operateOpticalDrive($op)
	}
}
###############################################################
# Main
###############################################################
# コマンド入力を受付
$op = (Read-Host コマンドを入力してください);

# コマンド正規化
if (regularizeCommand([ref]$op)) {
	# コマンド実行
	executeCommand($op);
} else {
	Write-Host ('正しいコマンドが指定されていません。やり直してください。 command: '+$op);
}
