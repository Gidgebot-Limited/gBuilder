class DataObject {
    [string]$Name
    [string]$TableName
    [Object[]]$Fields
    [Object[]]$Methods

    DataObject(
        [string]$Name,
        [string]$TableName,
        [Object[]]$Fields = @(),
        [Object[]]$Methods = @()
    ) {
        $this.Name = $Name
        $this.TableName = $TableName
        $this.Fields = $Fields
        $this.Methods = $Methods
    }

    DataObject(
        [string]$Name,
        [string]$TableName,
        [Object[]]$Fields = @()
    ) {
        $this.Name = $Name
        $this.TableName = $TableName
        $this.Fields = $Fields
    }

    # Get the migration schema definition for the object
    [string] GetMigrationSchema() {
        $schema = "`$this.TableName"

        foreach ($field in $this.Fields) {
            $schema += " " + $field.GetMigrationSchema()
        }

        return $schema
    }
}

class DataMethod {
    [string]$Name
    [string]$Content

    DataMethod([string]$Name, [string]$Content) {
        $this.Name = $Name
        $this.Content = $Content
    }
}

class DataField {
    [string]$Name
    [string]$Type
    [bool]$IsPrimary = $false
    [bool]$IsForeign = $false
    [bool]$IsNullable = $false  # New property for nullable fields
    [string]$ForeignTable
    [string]$ForeignKey

    DataField([string]$Name, [string]$Type) {
        $this.Name = $Name
        $this.Type = $Type
    }

    # Set the field as primary key
    [void] SetAsPrimary() {
        $this.IsPrimary = $true
    }

    # Set the field as foreign key
    [void] SetAsForeign([string]$ForeignTable, [string]$ForeignKey) {
        $this.IsForeign = $true
        $this.ForeignTable = $ForeignTable
        $this.ForeignKey = $ForeignKey
    }

    # Set the field as nullable
    [void] SetAsNullable() {
        $this.IsNullable = $true
    }

    # Get the migration schema definition for the field
    [string] GetMigrationSchema() {
        $schema = "`$this.Name:`$this.Type"

        if ($this.IsPrimary) {
            $schema += ":primary"
        }

        if ($this.IsForeign) {
            $schema += ":foreign:$($this.ForeignTable):$($this.ForeignKey)"
        }

        if ($this.IsNullable) {
            $schema += ":nullable"
        }

        return $schema
    }
}