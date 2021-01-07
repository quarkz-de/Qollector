unit Qollector.WelcomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls,
  Generics.Collections,
  Eventbus,
  Qollector.Forms, Qollector.Events;

type
  TwWelcomeForm = class(TQollectorForm)
    imIcon: TImage;
    imLogo: TImage;
    txFilename: TLabel;
    btOpen: TButton;
    sbRecentFiles: TScrollBox;
    txRecentFiles: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    RecentFileButtons: TObjectList<TButton>;
    procedure UpdateRecentFileList;
    procedure RecentFileButtonClick(Sender: TObject);
  public
    [Subscribe]
    procedure OnDatabaseLoad(AEvent: IDatabaseLoadEvent);
  end;

implementation

{$R *.dfm}

uses
  Qodelib.HighDpi,
  Qollector.Settings, Qollector.Main, Qollector.DataModule;

{ TwWelcomeForm }

procedure TwWelcomeForm.FormDestroy(Sender: TObject);
begin
  RecentFileButtons.Free;
end;

procedure TwWelcomeForm.FormCreate(Sender: TObject);
begin
  RecentFileButtons := TObjectList<TButton>.Create(true);
  GlobalEventBus.RegisterSubscriberForEvents(Self);
end;

procedure TwWelcomeForm.OnDatabaseLoad(AEvent: IDatabaseLoadEvent);
begin
  txFilename.Caption := AEvent.Filename;
  UpdateRecentFileList;
end;

procedure TwWelcomeForm.RecentFileButtonClick(Sender: TObject);
begin
  dmCommon.LoadDatabase(TButton(Sender).CommandLinkHint);
end;

procedure TwWelcomeForm.UpdateRecentFileList;
var
  Filename: String;
  Button: TButton;
begin
  RecentFileButtons.Clear;

  for Filename in QollectorSettings.RecentFilenames do
    begin
      Button := TButton.Create(nil);
      Button.Style := bsCommandLink;
      Button.Caption := ChangeFileExt(ExtractFilename(Filename), '');
      Button.CommandLinkHint := Filename;
      Button.Images := wMain.vilLargeIcons;
      Button.ImageIndex := 9;
      Button.Height := 72;
      Button.Align := alTop;
      Button.Parent := sbRecentFiles;
      Button.OnClick := RecentFileButtonClick;

      RecentFileButtons.Add(Button);
    end;
end;

end.
