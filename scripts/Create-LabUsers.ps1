# Create-LabUsers.ps1
# Builds the OU structure, department groups, and bulk test users for lab.local
# Run on DC01 in PowerShell ISE (as Administrator)

Import-Module ActiveDirectory

$Domain       = "DC=lab,DC=local"
$UPNSuffix    = "lab.local"
$Password     = ConvertTo-SecureString "Welcome2026!" -AsPlainText -Force   # lab-only password
$UsersPerDept = 15

$Departments = @{
    "IT"    = "Support Specialist"
    "HR"    = "HR Coordinator"
    "Sales" = "Sales Representative"
}

$FirstNames = @("James","Maria","David","Sofia","Michael","Emma","Daniel","Olivia","Chris","Ava",
                "Kevin","Mia","Brian","Chloe","Jason","Lily","Ryan","Grace","Eric","Nora")
$LastNames  = @("Smith","Garcia","Johnson","Lee","Brown","Martinez","Davis","Lopez","Wilson","Clark",
                "Lewis","Walker","Young","Hall","Allen","King","Wright","Scott","Green","Adams")

function New-OUIfMissing {
    param($Name, $Path)
    $exists = Get-ADOrganizationalUnit -Filter "Name -eq '$Name'" -SearchBase $Path -SearchScope OneLevel -ErrorAction SilentlyContinue
    if (-not $exists) {
        New-ADOrganizationalUnit -Name $Name -Path $Path -ProtectedFromAccidentalDeletion $false
        Write-Host "Created OU: $Name" -ForegroundColor Green
    }
}

# 1. Top-level OUs
foreach ($ou in "_USERS","_COMPUTERS","_GROUPS","_DISABLED") {
    New-OUIfMissing -Name $ou -Path $Domain
}

# 2. Department OUs and groups
foreach ($dept in $Departments.Keys) {
    New-OUIfMissing -Name $dept -Path "OU=_USERS,$Domain"

    $group = "$dept-Staff"
    if (-not (Get-ADGroup -Filter "Name -eq '$group'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $group -GroupScope Global -GroupCategory Security -Path "OU=_GROUPS,$Domain"
        Write-Host "Created group: $group" -ForegroundColor Green
    }
}

# 3. Bulk users
foreach ($dept in $Departments.Keys) {
    for ($n = 1; $n -le $UsersPerDept; $n++) {
        $first = Get-Random -InputObject $FirstNames
        $last  = Get-Random -InputObject $LastNames

        # Unique username: first.last, first.last2, ...
        $base = "$($first.ToLower()).$($last.ToLower())"
        $sam  = $base
        $i    = 1
        while (Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue) {
            $i++
            $sam = "$base$i"
        }
        $display = if ($i -gt 1) { "$first $last $i" } else { "$first $last" }

        New-ADUser -Name $display `
                   -GivenName $first `
                   -Surname $last `
                   -DisplayName $display `
                   -SamAccountName $sam `
                   -UserPrincipalName "$sam@$UPNSuffix" `
                   -Department $dept `
                   -Title $Departments[$dept] `
                   -Path "OU=$dept,OU=_USERS,$Domain" `
                   -AccountPassword $Password `
                   -ChangePasswordAtLogon $true `
                   -Enabled $true

        Add-ADGroupMember -Identity "$dept-Staff" -Members $sam
        Write-Host "Created user: $sam ($dept)" -ForegroundColor Cyan
    }
}

Write-Host "`nDone. Total users in _USERS:" -ForegroundColor Yellow
(Get-ADUser -Filter * -SearchBase "OU=_USERS,$Domain").Count
