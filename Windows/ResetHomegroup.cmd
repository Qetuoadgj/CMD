@echo off
set "PeerNetworkingDir=%WinDir%\ServiceProfiles\LocalService\AppData\Roaming\PeerNetworking"
net stop HomeGroupProvider
rd %PeerNetworkingDir% /q /s
md %PeerNetworkingDir%
net start HomeGroupProvider
pause
