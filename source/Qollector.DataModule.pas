unit Qollector.DataModule;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TdmCommon = class(TDataModule)
    icIcons: TImageCollection;
    vilIcons: TVirtualImageList;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  dmCommon: TdmCommon;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
