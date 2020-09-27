unit Qollector.About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TwAbout = class(TForm)
    Image1: TImage;
    btOk: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  wAbout: TwAbout;

implementation

{$R *.dfm}

end.
