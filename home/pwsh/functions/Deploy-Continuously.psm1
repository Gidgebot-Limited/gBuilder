function Invoke-SSHCommand 
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$User,

        [Parameter(Mandatory=$true)]
        [string]$HostName,

        [Parameter(Mandatory=$false)]
        [string]$Command,

        [Parameter(Mandatory=$false)]
        [string]$PrivateKeyPath
    )

    # Define the SSH command with the private key file
    $SSHCommand = "ssh -i $PrivateKeyPath $User@$HostName '$Command'"

    # Execute the SSH command using Invoke-Expression
    Invoke-Expression -Command $SSHCommand
}
function ConvertTo-epoch($date){
    return Get-Date -Date $date -UFormat %s
}

function read-profiles 
{
	($profile | get-member -type noteproperty).foreach{ 
        	if(test-path $profile.($_.name)){
			$_.name + " - " + $profile.($_.name).length + " - " +  $profile.($_.name)
        	}else{$_.name + " - " + "NoFile" + " - " +  $profile.($_.name)}}
}

function find-dotgitdirs #fromunder 
{
    Get-ChildItem -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Force -Directory $args[0] -Recurse  `
    | Where-Object { $_.Name -like "*.git" } `
    | Where-Object { $_.psparentpath -notlike "*recycle*" } `
    | ForEach-Object { $_.psparentpath.split(":")[3]}
}

function find-composers #fromunder
{
    get-childitem -recurse -ErrorAction SilentlyContinue -WarningAction SilentlyContinue $args[0] `
    | where-object {
        $_.name -like "*docker-compose*" `
        -and $_.psparentpath -notlike "*var/lib*" `
        -and $_.psparentpath -notlike "*cache*" `
        -and $_.psparentpath -notlike "*usr*" `
        -and $_.psparentpath -notlike "*vendor*" `
        -and $_.psparentpath -notlike "*.vscode*"
    } `
    | foreach-object {$_.psparentpath.split(':')[3]}
}

function send-block #@(paths) #{scriptblock}
{
    $taskdir = (Get-Location).path; $paths = $args[0]; $com = $args[1]
    $paths.foreach{Write-Output $_; Set-Location $_; & ([scriptblock]::Create($com))} 
    Set-Location $taskdir
}

function initialize-zero #clonedirs #url
{
    if ($clonedirs = $args[0]){
        $clonedirs.foreach{ 
            if($url = $args[1]){ 
                git clone $url
            } 
            else {
                Write-Output "repo exists"
            }
        }
    }
}
    
function import-zero #gits 
{
    send-block @($args[0]) {git checkout zero}  
    send-block @($args[0]) {git fetch}
    send-block @($args[0]) {git pull}
}

function initialize-devOne #gits #composers
{
    try {
        send-block @($args[0]) {git checkout devOne}
    } 
    catch {
        send-block @($args[0]) {git checkout -b devOne}
    }    
    send-block @($args[1]) {docker compose up -d}
}
function clear-devOne #composers #gits
{
    send-block @($args[0]) {docker compose down}
    send-block @($args[1]) {git checkout zero}
}

function merge-gitbranches #gits #to #from   
{
    send-block @($args[0]){git checkout $args[1] ;git merge $args[2]}
}
function sync-gitbranches #gits #branchname  
{
    send-block @($args[0]){git checkout $args[1]}
}