unit Qollector.DataModule;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, System.ImageList,
  Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.Themes, Vcl.StdCtrls,
  EventBus,
  Qodelib.Themes,
  Qollector.Database;

type
  TdmCommon = class(TDataModule)
    icDarkIcons: TImageCollection;
    vilIcons: TVirtualImageList;
    icLightIcons: TImageCollection;
    vilLargeIcons: TVirtualImageList;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FDatabase: IQollectorDatabase;
    procedure ThemeChangeEvent(Sender: TObject);
    procedure ThemeChanged;
    procedure UpdateIcons;
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
  if QuarkzThemeManager.IsDark then
    Result := icLightIcons
  else
    Result := icDarkIcons;
end;

procedure TdmCommon.LoadDatabase(const AFilename: String);
begin
  FDatabase := GlobalContainer.Resolve<IQollectorDatabase>;
  if AFilename = '' then
    Database.Load
  else
    Database.Load(AFilename);

  GlobalEventBus.Post(TDatabaseLoadEvent.Create(Database.Filename), '', TEventMM.mmAutomatic);
end;

procedure TdmCommon.MainFormCreated;
begin
  ThemeChanged;
end;

procedure TdmCommon.ThemeChanged;
begin
  GlobalEventBus.Post(TThemeChangeEvent.Create(QuarkzThemeManager.ThemeName,
    QuarkzThemeManager.IsDark), '', TEventMM.mmAutomatic);
end;

procedure TdmCommon.ThemeChangeEvent(Sender: TObject);
begin
  UpdateIcons;
  ThemeChanged;
end;

procedure TdmCommon.UpdateIcons;
begin
  vilIcons.ImageCollection := GetImageCollection;
  vilLargeIcons.ImageCollection := GetImageCollection;
end;

procedure TdmCommon.DataModuleCreate(Sender: TObject);
begin
  // Ref: https://theroadtodelphi.com/2011/12/16/exploring-delphi-xe2-vcl-styles-part-ii/
  TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TMemoStyleHook);

  QuarkzThemeManager.OnChange := ThemeChangeEvent;
  QollectorSettings.LoadSettings;
  UpdateIcons;
  ThemeChanged;

//  if (ParamCount > 0) and FileExists(ParamStr(1)) then
//    LoadDatabase(ParamStr(1))
//  else
//    LoadDatabase('');
end;

end.
