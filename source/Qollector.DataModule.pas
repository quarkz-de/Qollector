unit Qollector.DataModule;

interface

uses
  System.SysUtils, System.Classes, System.ImageList,
  Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.Themes, Vcl.StdCtrls,
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
    FDarkStyle: Boolean;
    procedure SetDarkStyle(const Value: Boolean);
  public
    property Database: IQollectorDatabase read FDatabase;
    procedure LoadDatabase(const AFilename: String);
    property DarkStyle: Boolean read FDarkStyle write SetDarkStyle;
  end;

var
  dmCommon: TdmCommon;

implementation

uses
  Spring.Container,
  EventBus,
  SynEdit,
  Qollector.Events;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmCommon.DataModuleDestroy(Sender: TObject);
begin
  Database.Close;
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
  FDarkStyle := Value;

  if DarkStyle then
    begin
      TStyleManager.TrySetStyle('Windows10 BlackPearl');
      vilIcons.ImageCollection := icLightIcons;
    end
  else
    begin
      TStyleManager.TrySetStyle('Windows');
//      vilIcons.ImageCollection := icDarkIcons;
    end;
end;

procedure TdmCommon.DataModuleCreate(Sender: TObject);
begin
  // Ref: https://theroadtodelphi.com/2011/12/16/exploring-delphi-xe2-vcl-styles-part-ii/
  TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TMemoStyleHook);

  DarkStyle := true;

exit;
  if (ParamCount > 0) and FileExists(ParamStr(1)) then
    LoadDatabase(ParamStr(1))
  else
    LoadDatabase('');
end;

end.
