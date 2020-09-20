unit Qollector.DataModule;

interface

uses
  System.SysUtils, System.Classes, System.ImageList,
  Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection,
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
  public
    property Database: IQollectorDatabase read FDatabase;
    procedure LoadDatabase(const AFilename: String);
  end;

var
  dmCommon: TdmCommon;

implementation

uses
  Spring.Container,
  EventBus,
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

procedure TdmCommon.DataModuleCreate(Sender: TObject);
begin
exit;
  if (ParamCount > 0) and FileExists(ParamStr(1)) then
    LoadDatabase(ParamStr(1))
  else
    LoadDatabase('');
end;

end.
