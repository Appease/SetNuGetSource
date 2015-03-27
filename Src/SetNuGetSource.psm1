function Invoke-PoshDevOpsTask(
[String]
[ValidateNotNullOrEmpty()]
[Parameter(
    Mandatory=$true,
    ValueFromPipelineByPropertyName=$true)]
$Name,

[String]
[ValidateNotNullOrEmpty()]
[Parameter(
    Mandatory=$true,
    ValueFromPipelineByPropertyName=$true)]
$SourceUrlOrPath,

[String]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$UserName,

[String]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$Password,

[String]
[ValidateScript({if($_){Test-Path $_ -PathType Leaf}})]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$ConfigFilePath){
        
    $nugetExecutable = "$PSScriptRoot\nuget.exe"

    # Kludge to remove any existing conflicting source.
    # nuget.exe doesn't support "update if exists", "list existing with ID" or equivalent 
    # and "list" command returns unreliably parsable strings
    $OriginalErrorPreference = $ErrorActionPreference 
    Try{
       $ErrorActionPreference = 'SilentlyContinue'
       & $nugetExecutable @('sources','Remove','-Name',$Name,'-Source',$SourceUrlOrPath,'-NonInteractive')
    }
    Finally{
        $ErrorActionPreference = $OriginalErrorPreference
    }

    $nugetParameters =  @('sources','Add','-Name',$Name,'-Source',$SourceUrlOrPath,'-NonInteractive')
        
    If($UserName){
        $nugetParameters += @('-UserName',$UserName)
    }
    If($Password){
        $nugetParameters += @('-Password',$Password)
    }
    If($ConfigFilePath){
        $nugetParameters += @('-ConfigFile',$ConfigFilePath)
    }
    
Write-Debug `
@"
Invoking nuget:
& $nugetExecutable $($nugetParameters|Out-String)
"@
        & $nugetExecutable $nugetParameters

        # handle errors
        if ($LastExitCode -ne 0) {
            throw $Error
        }

}

Export-ModuleMember -Function Invoke-PoshDevOpsTask
