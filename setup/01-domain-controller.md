# 01 — Domain Controller Setup

## Steps
1. Installed **Windows Server 2022 Standard (Desktop Experience)** on a VirtualBox VM.
2. Installed VirtualBox Guest Additions.
3. Renamed the server to `DC01`.
4. Set a static IP: `10.0.2.10/24`, gateway `10.0.2.1`.
5. Installed the **Active Directory Domain Services** role.
6. Promoted the server to a domain controller in a new forest: `lab.local`.
7. Verified the domain in Active Directory Users and Computers and confirmed DNS points to `127.0.0.1`.

## Screenshots
![Server edition](../screenshots/01-server-edition.png)
![Administrator password](../screenshots/02-admin-password.png)
![Rename to DC01](../screenshots/03-rename-dc01.png)
![Static IP](../screenshots/04-static-ip.png)
![AD DS role](../screenshots/05-adds-role.png)
![New forest](../screenshots/07-new-forest.png)
![DC promotion successful](../screenshots/08-dc-promoted.png)
![Domain login](../screenshots/09-domain-login.png)
![ADUC showing lab.local](../screenshots/10-aduc-lab-local.png)
![DNS loopback](../screenshots/11-dns-loopback.png)
