unit Qollector.Settings;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Forms;

type
  TQollectorFormPosition = class(TPersistent)
  private
    FWindowState: TWindowState;
    FTop: Integer;
    FLeft: Integer;
    FHeight: Integer;
    FWidth: Integer;
  public
    procedure Assign(Source: TPersistent); override;
    procedure LoadPosition(const AForm: TForm);
    procedure SavePosition(const AForm: TForm);
  published
    property WindowState: TWindowState read FWindowState write FWindowState;
    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
    property Height: Integer read FHeight write FHeight;
    property Width: Integer read FWidth write FWidth;
  end;

  TQollectorSettingValue = (svEditorFont);

  TQollectorSettings = class(TPersistent)
  private
    FEditorFont: String;
    FEditorFontSize: Integer;
    FDrawerOpened: Boolean;
    FFormPosition: TQollectorFormPosition;
    procedure SetTheme(const AValue: String);
    function GetTheme: String;
    function GetSettingsFilename: String;
    function GetSettingsFoldername: String;
    procedure SetFormPositon(const Value: TQollectorFormPosition);
    procedure ChangeEvent(const AValue: TQollectorSettingValue);
    procedure SetEditorFont(const AValue: String);
    procedure SetEditorFontSize(const AValue: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadSettings;
    procedure SaveSettings;
  published
    property Theme: String read GetTheme write SetTheme;
    property EditorFont: String read FEditorFont write SetEditorFont;
    property EditorFontSize: Integer read FEditorFontSize write SetEditorFontSize;
    property DrawerOpened: Boolean read FDrawerOpened write FDrawerOpened;
    property FormPosition: TQollectorFormPosition read FFormPosition write SetFormPositon;
  end;

var
  QollectorSettings: TQollectorSettings;

implementation

uses
  System.IOUtils, System.JSON,
  Neon.Core.Persistence, Neon.Core.Persistence.JSON,
  EventBus,
  Qollector.Events,
  Qodelib.Themes, Qodelib.IOUtils;

{ TQollectorSettings }

procedure TQollectorSettings.ChangeEvent(const AValue: TQollectorSettingValue);
begin
  GlobalEventBus.Post(TSettingChangeEvent.Create(AValue), '',
    TEventMM.mmAutomatic);
end;

constructor TQollectorSettings.Create;
begin
  inherited Create;
  FEditorFont := 'Courier New';
  FEditorFontSize := 10;
  FFormPosition := TQollectorFormPosition.Create;
  FDrawerOpened := true;
end;

destructor TQollectorSettings.Destroy;
begin
  FormPosition.Free;
  inherited;
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

procedure TQollectorSettings.SetEditorFont(const AValue: String);
begin
  FEditorFont := AValue;
  ChangeEvent(svEditorFont);
end;

procedure TQollectorSettings.SetEditorFontSize(const AValue: Integer);
begin
  FEditorFontSize := AValue;
  ChangeEvent(svEditorFont);
end;

procedure TQollectorSettings.SetFormPositon(
  const Value: TQollectorFormPosition);
begin
  FFormPosition.Assign(Value);
end;

procedure TQollectorSettings.SetTheme(const AValue: String);
begin
  QuarkzThemeManager.ThemeName := AValue;
end;

{ TQollectorFormPosition }

procedure TQollectorFormPosition.Assign(Source: TPersistent);
begin
  if Source is TQollectorFormPosition then
    begin
      WindowState := TQollectorFormPosition(Source).WindowState;
      Top := TQollectorFormPosition(Source).Top;
      Left := TQollectorFormPosition(Source).Left;
      Height := TQollectorFormPosition(Source).Height;
      Width := TQollectorFormPosition(Source).Width;
    end
  else
    inherited Assign(Source);
end;

procedure TQollectorFormPosition.SavePosition(const AForm: TForm);
begin
  WindowState := AForm.WindowState;
  Top := AForm.Top;
  Left := AForm.Left;
  Height := AForm.Height;
  Width := AForm.Width;
end;

procedure TQollectorFormPosition.LoadPosition(const AForm: TForm);
begin
  if (Width > 0) and (Height > 0) then
    begin
      AForm.WindowState := WindowState;
      AForm.Top := Top;
      AForm.Left := Left;
      AForm.Height := Height;
      AForm.Width := Width;
    end;
end;

initialization
  QollectorSettings := TQollectorSettings.Create;

finalization
  FreeAndNil(QollectorSettings);

end.
