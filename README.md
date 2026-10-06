# Active Directory Help Desk Lab

A hands-on Windows Server lab built to practice real-world IT support tasks: user account management, password resets, account lockouts, onboarding/offboarding, file share permissions, and Group Policy troubleshooting.

**Author:** Tania Tolstykh

## Skills Demonstrated

- **Active Directory Domain Services:** domain setup, OU design, users, security groups
- **DNS & DHCP:** server configuration, scopes, client name resolution
- **Group Policy:** drive mapping with item-level targeting, screen lock, Control Panel restrictions
- **File Shares:** Share vs. NTFS permissions, department-based access control
- **PowerShell:** bulk user creation, account unlock, password reset
- **Troubleshooting:** `ipconfig`, `ping`, `gpupdate`, `gpresult`, `whoami`
- **Ticket documentation:** issue → troubleshooting → resolution

## Lab Environment

| Component | Details |
|---|---|
| Hypervisor | Oracle VirtualBox |
| DC01 | Windows Server 2022 — AD DS, DNS, DHCP, File Server — `10.0.2.10` |
| CLIENT01 | Windows 11 Enterprise — domain-joined workstation — DHCP |
| Domain | `lab.local` |
| Network | VirtualBox NAT Network `LabNet` — `10.0.2.0/24` |

## Network Diagram

```mermaid
flowchart LR
    Internet((Internet)) --- GW[NAT Gateway<br/>10.0.2.1]
    GW --- DC[DC01<br/>Windows Server 2022<br/>AD DS / DNS / DHCP / File Shares<br/>10.0.2.10]
    GW --- CL[CLIENT01<br/>Windows 11 Enterprise<br/>DHCP 10.0.2.100-200]
    CL -. DNS, Auth, GPO .-> DC
```

## OU Structure

```
lab.local
├── _USERS
│   ├── HR
│   ├── IT
│   └── Sales
├── _COMPUTERS
├── _GROUPS        (HR-Staff, IT-Staff, Sales-Staff)
└── _DISABLED
```

## Build Guide

1. [Domain Controller setup](setup/01-domain-controller.md)
2. [OUs, groups, and bulk users (PowerShell)](setup/02-users-and-ous.md)
3. [DHCP and joining a client to the domain](setup/03-dhcp-and-client.md)
4. [File shares and Group Policy](setup/04-shares-and-gpo.md)

## Help Desk Tickets

| # | Ticket | Key Skills |
|---|---|---|
| 001 | [Password reset](tickets/001-password-reset.md) | ADUC, PowerShell |
| 002 | [Account lockout](tickets/002-account-lockout.md) | Lockout policy, `Search-ADAccount`, `Unlock-ADAccount` |
| 003 | [New hire onboarding](tickets/003-onboarding.md) | User templates, group membership |
| 004 | [Employee offboarding](tickets/004-offboarding.md) | Disable, remove access, archive |
| 005 | [Shared drive not showing](tickets/005-shared-drive-access.md) | `gpresult`, groups vs. OUs, token refresh |

## Scripts

- [`Create-LabUsers.ps1`](scripts/Create-LabUsers.ps1): creates the OU structure, department security groups, and 45 test users with titles and departments.

> All passwords shown in this lab are for an isolated test environment only.
