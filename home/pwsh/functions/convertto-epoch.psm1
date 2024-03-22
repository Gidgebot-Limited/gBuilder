function ConvertTo-epoch($date){
    return Get-Date -Date $date -UFormat %s
}