; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "CraftOS-PC"
#define MyAppPublisher "JackMacWindows"
#define MyAppURL "https://www.craftos-pc.cc"
#define MyAppExeName "CraftOS-PC.exe"
#define AppId "{13785CC7-9ECF-4EDD-A43E-A85926D7F4CD}"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{#AppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={code:GetInstallDir}\{#MyAppName}
DisableDirPage=no                                      
DisableProgramGroupPage=yes
DisableWelcomePage=no
LicenseFile=LICENSE.txt
InfoBeforeFile=DeltaReadme.txt
; Uncomment the following line to run in non administrative install mode (install for current user only.)
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog
;UsePreviousPrivileges=no
OutputDir={#WorkspaceDir}
OutputBaseFilename=CraftOS-PC-Setup_Delta-{#DeltaVersion}
Compression=lzma2/ultra64
SolidCompression=yes
;WizardStyle=modern
WizardSmallImageFile=icon.bmp
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64
AlwaysRestart=no
RestartIfNeededByRun=no
VersionInfoVersion={#MyAppVersion}
;CloseApplications=yes
;CloseApplicationsFilter=CraftOS-PC.exe
Uninstallable=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "ccemux"; Description: "CCEmuX plugin"; GroupDescription: "Optional components:"; Flags: unchecked
Name: "console"; Description: "Console build (for raw mode)"; GroupDescription: "Optional components:"
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "syslink"; Description: "Add craftos.exe to PATH"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[InstallDelete]
Type: filesandordirs; Name: "{app}\rom"

[Files]
Source: "{#WorkspaceDir}\bin\CraftOS-PC.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#WorkspaceDir}\bin\CraftOS-PC_console.exe"; DestDir: "{app}"; DestName: "CraftOS-PC_console.exe"; Flags: ignoreversion; Tasks: console
Source: "{#WorkspaceDir}\bin\lua51.dll"; DestDir: "{app}"
Source: "{#WorkspaceDir}\craftos2-rom\*"; DestDir: "{app}"; Excludes: "\.git,\README.md,.gitattributes,.gitignore,\sounds,\plugins,\.github,\plugins-luajit,\plugins*"; Flags: ignoreversion recursesubdirs createallsubdirs

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall

[Code]
function GetInstallDir(Value: string): string;
begin
  if IsAdmin() then
    Result := ExpandConstant('{commonpf64}')    
  else
    Result := ExpandConstant('{localappdata}')
end;

function InitializeSetup: Boolean;
begin
  Result := True;
  if not (RegKeyExists(HKEY_LOCAL_MACHINE,
       'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#AppId}_is1') or
     RegKeyExists(HKEY_CURRENT_USER,
       'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#AppId}_is1')) then
  begin
    MsgBox('This installer only supports updating an existing installation. Please use the full CraftOS-PC-Setup.exe installer instead.', mbError, MB_OK);
    Result := False;
  end;
end;