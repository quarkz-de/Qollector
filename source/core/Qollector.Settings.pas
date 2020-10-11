unit Qollector.Settings;

interface

uses
  System.SysUtils;

type
  TQollectorSettings = class
  private
    procedure SetTheme(const AValue: String);
    function GetTheme: String;
  public
    constructor Create;
  published
    property Theme: String read GetTheme write SetTheme;
  end;

var
  QollectorSettings: TQollectorSettings;

implementation

uses
  Qodelib.Themes;

{ TQollectorSettings }

constructor TQollectorSettings.Create;
begin
  inherited Create;
end;

function TQollectorSettings.GetTheme: String;
begin
  QuarkzThemeManager.ThemeName;
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
