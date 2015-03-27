####What is it?

A [PoshDevOps](https://github.com/PoshDevOps/PoshDevOps) task that sets a [NuGet](https://nuget.org) package source

####How do I install it?

```PowerShell
New-PoshDevOpTask -Name "YOUR-TASK-NAME" -PackageId "SetNuGetSource"
```

####What parameters are available?

#####IncludeSlnAndOrConfigFilePath
A String[] representing included .sln and/or .config file paths. Either literal or wildcard paths are allowed; Default is all .sln files within the project root dir @ any depth
```PowerShell
[String[]]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$IncludeSlnAndOrConfigFilePath
```

#####Recurse
a Switch representing whether to include .sln and/or .config files located in sub directories of $IncludeSlnAndOrConfigFilePath (at any depth)
```PowerShell
[Switch]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$Recurse
```
#####Name
A String representing the unique name of the source
```PowerShell
[String]
[ValidateNotNullOrEmpty()]
[Parameter(
    Mandatory=$true,
    ValueFromPipelineByPropertyName=$true)]
$Name
```

#####SourceUrlOrPath
A String representing the unique url or path of the source
```PowerShell
[String]
[ValidateNotNullOrEmpty()]
[Parameter(
    Mandatory=$true,
    ValueFromPipelineByPropertyName=$true)]
$SourceUrlOrPath
```

#####UserName
A String representing the username credential to use when authenticating with the source (if any)
```PowerShell
[String]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$UserName
```

#####Password
A String representing the password credential to use when authenticating with the source (if any)
```PowerShell
[String]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$Password
```

#####ConfigFilePath
A String representing the path of the `Nuget.config` file to set the source in; defaults to `%AppData%\NuGet\NuGet.config`
```PowerShell
[String]
[ValidateScript({if($_){Test-Path $_ -PathType Leaf}})]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$ConfigFilePath
```

####What's the build status?
![](https://ci.appveyor.com/api/projects/status/4j343xtqm93ro3mf?svg=true)