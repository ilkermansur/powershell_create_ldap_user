# Silinecek kullanıcıları manuel olarak belirle
$Users = @("user01", "user02", "user03", "user04", "user05")

foreach ($User in $Users) {
    # Kullanıcının olup olmadığını kontrol et
    if (Get-ADUser -Filter {SamAccountName -eq $User}) {
        Remove-ADUser -Identity $User -Confirm:$false
        Write-Host "? Kullanıcı $User silindi."
    } else {
        Write-Host "? Kullanıcı $User bulunamadı."
    }
}
