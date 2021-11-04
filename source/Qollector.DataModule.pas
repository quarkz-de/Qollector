unit Qollector.DataModule;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, System.ImageList, System.UITypes,
  Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.Themes, Vcl.StdCtrls, Vcl.Dialogs,
  EventBus,
  Qodelib.Themes,
  Qollector.Database;

type
  TdmCommon = class(TDataModule)
    icColorIcons: TImageCollection;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FDatabase: IQollectorDatabase;
    procedure ThemeChangeEvent(Sender: TObject);
    procedure ThemeChanged;
  public
    property Database: IQollectorDatabase read FDatabase;
    procedure LoadDatabase(const AFilename: String);
    procedure MainFormCreated;
    function GetImageCollection: TImageCollection;
  end;

var
  dmCommon: TdmCommon;

implementation

uses
  Spring.Container,
  SynEdit,
  Qollector.Events, Qollector.Settings;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmCommon.DataModuleDestroy(Sender: TObject);
begin
  Database.Close;
  QollectorSettings.SaveSettings;
end;

function TdmCommon.GetImageCollection: TImageCollection;
begin
  Result := icColorIcons;
end;

procedure TdmCommon.LoadDatabase(const AFilename: String);
begin
  if (AFilename <> '') and not FileExists(AFilename) then
    begin
      if MessageDlg(Format('Die Datei "%s" existiert nicht. Möchten Sie eine neue Sammlung anlegen?', [AFilename]),
        mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Exit;
    end;

  FDatabase := GlobalContainer.Resolve<IQollectorDatabase>;
  if AFilename = '' then
    Database.Load
  else
    Database.Load(AFilename);

  QollectorSettings.AddRecentFilename(Database.Filename);

  GlobalEventBus.Post(TEventFactory.NewDatabaseLoadEvent(Database.Filename));
end;

procedure TdmCommon.MainFormCreated;
begin
  ThemeChanged;
end;

procedure TdmCommon.ThemeChanged;
begin
  GlobalEventBus.Post(TEventFactory.NewThemeChangeEvent(
    QuarkzThemeManager.ThemeName, QuarkzThemeManager.IsDark));
end;

procedure TdmCommon.ThemeChangeEvent(Sender: TObject);
begin
  ThemeChanged;
end;

procedure TdmCommon.DataModuleCreate(Sender: TObject);
begin
  // Ref: https://theroadtodelphi.com/2011/12/16/exploring-delphi-xe2-vcl-styles-part-ii/
  TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TMemoStyleHook);

  QuarkzThemeManager.OnChange := ThemeChangeEvent;
  QollectorSettings.LoadSettings;
  ThemeChanged;

//  if (ParamCount > 0) and FileExists(ParamStr(1)) then
//    LoadDatabase(ParamStr(1))
//  else
//    LoadDatabase('');
end;

end.
