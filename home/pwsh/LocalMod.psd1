@{
    RootModule = 'LocalMod.psm1'
    ModuleVersion = '1.0'
    Author = 'Richard Leon Rodriguez'
    Description = 'A Laravel builder'
    FunctionsToExport = @('Start-LocalMod', 'Stop-LocalMod')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('Tag1', 'Tag2')
            LicenseUri = 'https://example.com/license'
            ProjectUri = 'https://example.com/project'
            ReleaseNotes = 'Release notes for version 1.0'
        }
    }
    RequiredModules = @()
    # NestedModules = @('Classes\*.psm1', 'Functions\*.psm1')
}
