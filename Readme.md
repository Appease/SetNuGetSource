![](https://ci.appveyor.com/api/projects/status/4j343xtqm93ro3mf?svg=true)

####What is it?

An [Appease](http://appease.io) task template that sets a [NuGet](https://nuget.org) source

####How do I install it?

```PowerShell
Add-AppeaseTask `
    -DevOpName YOUR-DEVOP-NAME `
    -Name YOUR-TASK-NAME `
    -TemplateId SetNuGetSource
```

####What parameters are required?

#####Name
description: a `string` representing a unique name for the source.

#####SourceUrlOrPath
description: a `string` representing the url or path of the source.

####What parameters are optional?

#####UserName
description: a `string` representing the username credential to use when authenticating with the source.

#####Password
description: a `string` representing the password credential to use when authenticating with the source.

#####ConfigFilePath
description: a `string` representing the path of the `Nuget.config` file to set the source in.  
default: `%AppData%\NuGet\NuGet.config`