# Define the DataField class
Class DataField {
    [string]$FieldName
    [string]$FieldType

    DataField([string]$FieldName, [string]$FieldType) {
        $this.FieldName = $FieldName
        $this.FieldType = $FieldType
    }

    # Get the migration schema definition for the field
    [string] GetMigrationSchema() {
        return "`t`$table->" + $this.FieldName + "('" + $this.FieldType + "')"
    }
}

# Define the DataMethod class (for demonstration purposes)
Class DataMethod {
    [string]$MethodName

    DataMethod([string]$MethodName) {
        $this.MethodName = $MethodName
    }
}

# Define the DataObject class
Class DataObject {
    [string]$Name
    [string]$TableName
    [System.Collections.Generic.List[DataField]]$Fields
    [System.Collections.Generic.List[DataMethod]]$Methods

    DataObject(
        [string]$Name,
        [string]$TableName,
        [System.Collections.Generic.List[DataField]]$Fields = @(),
        [System.Collections.Generic.List[DataMethod]]$Methods = @()
    ) {
        $this.Name = $Name
        $this.TableName = $TableName
        $this.Fields = $Fields
        $this.Methods = $Methods
    }
    
    # Get the migration schema definition for the object
    [string] GetMigrationSchema() {
        $schema = "`$this.TableName"

        foreach ($field in $this.Fields) {
            $schema += "`n" + "`t" + $field.GetMigrationSchema()
        }

        return $schema
    }
}
