unit Qollector.WelcomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Qollector.Forms;

type
  TwWelcomeForm = class(TQollectorForm)
    imIcon: TImage;
    imLogo: TImage;
  private
  public
  end;

implementation

{$R *.dfm}

end.
