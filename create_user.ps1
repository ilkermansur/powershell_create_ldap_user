param(
    [int]$UserCount = 15,
    [string]$Password = "Aa123456",
    [string]$OUPath = "OU=collab_user,DC=collab,DC=local"
)

for ($i = 1; $i -le $UserCount; $i++) {
    $UserName = "user" + ($i.ToString("00"))
    $GivenName = "User"
    $Surname = "Number$i"
    $SamAccountName = $UserName
    $UserPrincipalName = "$UserName@collab.local"
    $Email = "$UserName@collab.local"
    $PhoneNumber = "100$($i.ToString("0"))"

    # Kullanıcıyı oluştur
    New-ADUser -Name $UserName -GivenName $GivenName -Surname $Surname -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName -Path $OUPath -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true

    # Kullanıcının şifresini ayarla ve sıfırla
    Set-ADAccountPassword -Identity $SamAccountName -NewPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Reset

    # Kullanıcının şifre değişiklik ayarlarını yap
    Set-ADUser -Identity $SamAccountName -ChangePasswordAtLogon $false
    Set-ADUser -Identity $SamAccountName -PasswordNeverExpires $true

    # Kullanıcı bilgilerini güncelle (E-posta ve Telefon Numarası)
    Set-ADUser -Identity $SamAccountName -EmailAddress $Email -OfficePhone $PhoneNumber

    # Kullanıcıyı etkinleştir
    Enable-ADAccount -Identity $SamAccountName

    Write-Host "? Kullanıcı $UserName başarıyla oluşturuldu ve yapılandırıldı."
}
