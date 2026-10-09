#define AppName "Estalingrado Corp Netrunner Console"
#define AppVersion "1.0.0"
#define AppPublisher "Estalingrado Corp"

[Setup]
AppId={{ESTALINGRADO-CORP-NETRUNNER-CONSOLE}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputDir=output
OutputBaseFilename=EstalingradoCorp-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile=imagenes\icono.ico
UninstallDisplayName={#AppName} - Desinstalar
PrivilegesRequired=admin

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Files]
Source: "estalingrado_corp_netrunner_console.asi"; DestDir: "{code:GetGameDir}\bin\x64\plugins"; Flags: ignoreversion
Source: "version.dll"; DestDir: "{code:GetGameDir}\bin\x64"; Flags: ignoreversion onlyifdoesntexist
Source: "global.ini"; DestDir: "{code:GetGameDir}\bin\x64"; Flags: ignoreversion onlyifdoesntexist

[Code]
var
  GameDirPage: TInputDirWizardPage;

procedure InitializeWizard;
begin
  GameDirPage := CreateInputDirPage(wpWelcome,
    'Ubicaci\u00f3n de Cyberpunk 2077',
    'Selecciona la carpeta donde est\u00e1 instalado Cyberpunk 2077.',
    'El instalador necesita la carpeta ra\u00edz del juego (donde se encuentra la carpeta bin).',
    False, '');
  GameDirPage.Add('Carpeta del juego:');
  GameDirPage.Values[0] := ExpandConstant('{autopf}\Cyberpunk 2077');
end;

function GetGameDir(Param: String): String;
begin
  Result := GameDirPage.Values[0];
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  GameDir: String;
begin
  Result := True;
  if CurPageID = GameDirPage.ID then
  begin
    GameDir := GameDirPage.Values[0];
    if not FileExists(GameDir + '\bin\x64\Cyberpunk2077.exe') then
    begin
      MsgBox('No se encontr\u00f3 Cyberpunk2077.exe en la carpeta seleccionada.' + #13#10 +
             'Verifica que la ruta sea correcta.', mbCriticalError, MB_OK);
      Result := False;
    end;
  end;
end;

[UninstallDelete]
Type: filesandordirs; Name: "{code:GetGameDir}\bin\x64\plugins\estalingrado_corp_netrunner_console.asi"
