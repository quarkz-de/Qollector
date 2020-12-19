unit Qollector.WelcomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls,
  Eventbus,
  Qollector.Forms, Qollector.Events;

type
  TwWelcomeForm = class(TQollectorForm)
    imIcon: TImage;
    imLogo: TImage;
    txFilename: TLabel;
    procedure FormCreate(Sender: TObject);
  public
    [Subscribe(TThreadMode.Main)]
    procedure OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
  end;

implementation

{$R *.dfm}

{ TwWelcomeForm }

procedure TwWelcomeForm.FormCreate(Sender: TObject);
begin
  GlobalEventBus.RegisterSubscriberForEvents(Self);
end;

procedure TwWelcomeForm.OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
begin
  txFilename.Caption := AEvent.Filename;
end;

end.
