$ErrorActionPreference = 'Stop'

function Invoke(
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
        
    $NuGetCommand = 'nuget'

    # Kludge to remove any existing conflicting source.
    # nuget.exe doesn't support "update if exists", "list existing with ID" or equivalent 
    # and "list" command returns unreliably parsable strings       
    $NuGetParameters = @('sources','Remove','-Name',$Name,'-NonInteractive')

    If($ConfigFilePath){
        $NuGetParameters += @('-ConfigFile',$ConfigFilePath)
    }
    & $NuGetCommand $NuGetParameters *> $null


    # add it back with desired values
    $NuGetParameters =  @('sources','Add','-Name',$Name,'-Source',$SourceUrlOrPath,'-NonInteractive')
        
    If($UserName){
        $NuGetParameters += @('-UserName',$UserName)
    }
    If($Password){
        $NuGetParameters += @('-Password',$Password)
    }
    If($ConfigFilePath){
        $NuGetParameters += @('-ConfigFile',$ConfigFilePath)
    }
    
Write-Debug `
@"
Invoking nuget:
& $NuGetCommand $($NuGetParameters|Out-String)
"@
        & $NuGetCommand $NuGetParameters

        # handle errors
        if ($LastExitCode -ne 0) {
            throw $Error
        }

}

Export-ModuleMember -Function Invoke
