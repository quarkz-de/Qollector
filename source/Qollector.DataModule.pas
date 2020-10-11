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
    icLightIcons: TImageCollection;
    vilIcons: TVirtualImageList;
    vilLargeIcons: TVirtualImageList;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FDatabase: IQollectorDatabase;
    procedure SetDarkStyle(const Value: Boolean);
    procedure ThemeChangeEvent(Sender: TObject);
  public
    property Database: IQollectorDatabase read FDatabase;
    procedure LoadDatabase(const AFilename: String);
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

procedure TdmCommon.LoadDatabase(const AFilename: String);
begin
  FDatabase := GlobalContainer.Resolve<IQollectorDatabase>;
  if AFilename = '' then
    Database.Load
  else
    Database.Load(AFilename);

  GlobalEventBus.Post(TDatabaseLoadEvent.Create(Database.Filename), '', TEventMM.mmAutomatic);
end;

procedure TdmCommon.SetDarkStyle(const Value: Boolean);
begin
  if Value then
    vilIcons.ImageCollection := icLightIcons
  else
    vilIcons.ImageCollection := icLightIcons ; //icDarkIcons;
end;

procedure TdmCommon.ThemeChangeEvent(Sender: TObject);
begin
  if QuarkzThemeManager.IsDark then
    vilIcons.ImageCollection := icLightIcons
  else
    vilIcons.ImageCollection := icLightIcons ; //icDarkIcons;
end;

procedure TdmCommon.DataModuleCreate(Sender: TObject);
begin
  // Ref: https://theroadtodelphi.com/2011/12/16/exploring-delphi-xe2-vcl-styles-part-ii/
  TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TMemoStyleHook);

  QuarkzThemeManager.OnChange := ThemeChangeEvent;
  QollectorSettings.LoadSettings;
//  QuarkzThemeManager.Theme := qttQuarkzDarkBlue;

//  if (ParamCount > 0) and FileExists(ParamStr(1)) then
//    LoadDatabase(ParamStr(1))
//  else
//    LoadDatabase('');
end;

end.
