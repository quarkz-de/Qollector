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
  end;

var
  dmCommon: TdmCommon;

implementation

uses
  Spring.Container;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmCommon.DataModuleDestroy(Sender: TObject);
begin
  Database.Close;
end;

procedure TdmCommon.DataModuleCreate(Sender: TObject);
begin
  FDatabase := GlobalContainer.Resolve<IQollectorDatabase>;
  if (ParamCount > 0) and FileExists(ParamStr(1)) then
    Database.Load(ParamStr(1))
  else
    Database.Load;
end;

end.
