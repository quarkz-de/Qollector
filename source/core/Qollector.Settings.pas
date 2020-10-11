unit Qollector.Settings;

interface

uses
  System.SysUtils, System.Classes;

type
  TQollectorSettings = class
  private
    procedure SetTheme(const AValue: String);
    function GetTheme: String;
    function GetSettingsFilename: String;
    function GetSettingsFoldername: String;
  public
    constructor Create;
    procedure LoadSettings;
    procedure SaveSettings;
  published
    property Theme: String read GetTheme write SetTheme;
  end;

var
  QollectorSettings: TQollectorSettings;

implementation

uses
  System.IOUtils, System.JSON,
  Neon.Core.Persistence, Neon.Core.Persistence.JSON,
  Qodelib.Themes, Qodelib.IOUtils;

{ TQollectorSettings }

constructor TQollectorSettings.Create;
begin
  inherited Create;
end;

function TQollectorSettings.GetSettingsFilename: String;
begin
  Result := TPath.Combine(GetSettingsFoldername, 'Qollector.json');
end;

function TQollectorSettings.GetSettingsFoldername: String;
begin
  Result := TPath.Combine(TKnownFolders.GetAppDataPath, 'quarkz');
end;

function TQollectorSettings.GetTheme: String;
begin
  Result := QuarkzThemeManager.ThemeName;
end;

procedure TQollectorSettings.LoadSettings;
var
  JSON: TJSONValue;
  Strings: TStringList;
begin
  if FileExists(GetSettingsFilename) then
    begin
      Strings := TStringList.Create;
      Strings.LoadFromFile(GetSettingsFilename);
      JSON := TJSONObject.ParseJSONValue(Strings.Text);
      TNeon.JSONToObject(self, JSON, TNeonConfiguration.Default);
      JSON.Free;
      Strings.Free;
    end;
end;

procedure TQollectorSettings.SaveSettings;
var
  JSON: TJSONValue;
  Stream: TFileStream;
begin
  ForceDirectories(GetSettingsFoldername);
  JSON := TNeon.ObjectToJSON(self);
  Stream := TFileStream.Create(GetSettingsFilename, fmCreate);
  TNeon.PrintToStream(JSON, Stream, true);
  Stream.Free;
  JSON.Free;
end;

procedure TQollectorSettings.SetTheme(const AValue: String);
begin
  QuarkzThemeManager.ThemeName := AValue;
end;

initialization
  QollectorSettings := TQollectorSettings.Create;

finalization
  FreeAndNil(QollectorSettings);

end.
