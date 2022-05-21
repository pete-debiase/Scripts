# Collection of QOL Windows registry adjustments
# Pete Adriano DeBiase
# Created: 2020/04/05

# Clean up context menu
reg delete HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\ANotepad++64 /f
reg delete "HKEY_CLASSES_ROOT\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
reg delete "HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\DropboxExt" /f
reg delete "HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\DropboxExt" /f
reg delete "HKEY_CLASSES_ROOT\Directory\shell\AddToPlaylistVLC" /f
reg delete "HKEY_CLASSES_ROOT\Directory\shell\PlayWithVLC" /f
reg delete "HKEY_CLASSES_ROOT\Directory\shell\git_gui" /f
reg delete "HKEY_CLASSES_ROOT\Directory\shell\git_shell" /f
reg delete "HKEY_CLASSES_ROOT\LibraryFolder\background\shell\git_gui" /f
reg delete "HKEY_CLASSES_ROOT\LibraryFolder\background\shell\git_shell" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\background\shell\git_gui" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\background\shell\git_shell" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\background\shellex\ContextMenuHandlers\DropboxExt" /f
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\DropboxExt" /f
reg delete "HKEY_CLASSES_ROOT\lnkfile\shellex\ContextMenuHandlers\DropboxExt" /f
reg delete "HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\Foxit_ConvertToPDF_Reader" /f
reg delete "HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\ModernSharing" /f
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode" /f
reg delete "HKEY_CLASSES_ROOT\Directory\shell\AnyCode" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{776DBC8D-7347-478C-8D71-791E12EF49D8}" /t REG_SZ /d "Skype" /f
reg add "HKCU\Software\Classes\ms-officeapp\Shell\Open\Command" /t REG_SZ /d rundll32 /f

# Disable animations in Microsoft Office
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\Graphics" /t REG_DWORD /v DisableAnimations /d 1 /f

# Set UAC to sane level
reg import "UAC_do-not-dim.reg"

# Hide OneDrive from Explorer
reg import "hide_OneDrive.reg"
