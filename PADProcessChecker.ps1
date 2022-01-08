###############################################################
# Pre-defines
###############################################################
Param($Arg1)
<#
.PADHost
 name of process of Power Automate Desktop console host
.hookUrl
 Webhook URL for Discrod private srever
.content4Host
 Content for PAD.Console.Host.exe
.isDebug
 Mode flag for debug: true=debug
#>
$PADHost = 'PAD.Console.Host'
$hookUrl = New-Object System.Uri($Arg1)
$contentHeader = @"
-------------------------------------------
[!] PAD Process Checker::Error
-------------------------------------------`n
"@
$content4Host = @"
`nProcess not found: $PADHost
"@
$content4PostError = @"
"@
$isDebug = $false

<#
.content
 payload string
#>
function restPost([string]$content) {
    $curDate = (Get-Date).ToString("yyyy-MM-dd HH:MM:SS.fff")
    $tmp = $contentHeader + "Occured: " + $curDate + $content
    $payload = [PSCustomObject]@{
        content = $tmp
    }
    $payloadData = $payload | ConvertTo-Json
    $payloadJson = [System.Text.Encoding]::UTF8.GetBytes($payloadData)
    return Invoke-WebRequest -Uri $hookUrl -Method Post -Body $payloadJson -ContentType 'application/json'
}

# check PAD.Console.Host.exe
$found = Get-Process -Name $PADHost -ErrorAction SilentlyContinue
if (!$found) {
    $res = restPost($content4Host)
    $statusCode = $res.StatusCode
    if ($statusCode -notmatch '2[0-9]{2}') {
        $errorDetails = Out-String -InputObject $res
        $content4PostError += Out-String -InputObject $errorDetails
        restPost($content4PostError)
    }
    exit
}

if ($isDebug) {
    $res = restPost($content4Host)
    Write-Output (Out-String -InputObject $res)
    if ($res.StatusCode -match '2[0-9]{2}') {
        $errorDetails = Out-String -InputObject $res
        $content4PostError += Out-String -InputObject $errorDetails
        restPost($content4PostError)
    }
}

exit
