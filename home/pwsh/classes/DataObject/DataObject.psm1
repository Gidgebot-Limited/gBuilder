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

    # Get the migration schema definition for the field
    [string] GetMigrationSchema() {
        $schema = "`$this.Name:`$this.Type"

        if ($this.IsPrimary) {
            $schema += ":primary"
        }

        if ($this.IsForeign) {
            $schema += ":foreign:$($this.ForeignTable):$($this.ForeignKey)"
        }

        return $schema
    }
}

class DataObject {
    [string]$Name
    [string]$TableName
    [DataField[]]$Fields
    [DataMethod[]]$Methods

    DataObject([string]$Name, [string]$TableName, [DataField[]]$Fields, [DataMethod[]]$Methods) {
        $this.Name = $Name
        $this.TableName = $TableName
        $this.Fields = $Fields
        $this.Methods = $Methods
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
