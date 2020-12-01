unit Qollector.WelcomeFrame;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Qollector.Frames, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TFrame = TQollectorFrame;

  TfrWelcomeFrame = class(TFrame)
    imIcon: TImage;
    imLogo: TImage;
  private
  public
  end;

implementation

{$R *.dfm}

end.
