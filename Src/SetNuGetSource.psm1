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
        
    $NugetExecutable = "$PSScriptRoot\nuget.exe"

    # Kludge to remove any existing conflicting source.
    # nuget.exe doesn't support "update if exists", "list existing with ID" or equivalent 
    # and "list" command returns unreliably parsable strings
    $OriginalErrorPreference = $ErrorActionPreference 
    Try{
       $ErrorActionPreference = 'Ignore'
       
       $NuGetParameters = @('sources','Remove','-Name',$Name,'-NonInteractive')

       If($ConfigFilePath){
           $NuGetParameters += @('-ConfigFile',$ConfigFilePath)
       }

       & $NugetExecutable $NuGetParameters *> $null
    }
    Finally{
        $ErrorActionPreference = $OriginalErrorPreference
    }

    $NugetExecutable =  @('sources','Add','-Name',$Name,'-Source',$SourceUrlOrPath,'-NonInteractive')
        
    If($UserName){
        $NugetExecutable += @('-UserName',$UserName)
    }
    If($Password){
        $NugetExecutable += @('-Password',$Password)
    }
    If($ConfigFilePath){
        $NugetExecutable += @('-ConfigFile',$ConfigFilePath)
    }
    
Write-Debug `
@"
Invoking nuget:
& $NugetExecutable $($NugetExecutable|Out-String)
"@
        & $NugetExecutable $NugetExecutable

        # handle errors
        if ($LastExitCode -ne 0) {
            throw $Error
        }

}

Export-ModuleMember -Function Invoke-PoshDevOpsTask
