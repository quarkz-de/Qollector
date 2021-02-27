unit Qollector.WelcomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls,
  Generics.Collections,
  Eventbus,
  Qollector.Forms, Qollector.Events, Vcl.VirtualImage, Vcl.ControlList;

type
  TwWelcomeForm = class(TQollectorForm)
    imIcon: TImage;
    imLogo: TImage;
    txFilename: TLabel;
    btOpen: TButton;
    txRecentFiles: TLabel;
    clRecentFiles: TControlList;
    txItemName: TLabel;
    txItemFilename: TLabel;
    imItem: TVirtualImage;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure clRecentFilesBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure clRecentFilesItemClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    RecentFileButtons: TObjectList<TButton>;
    procedure UpdateRecentFileList;
  public
    [Subscribe]
    procedure OnDatabaseLoad(AEvent: IDatabaseLoadEvent);
    [Subscribe]
    procedure OnThemeChange(AEvent: IThemeChangeEvent);
  end;

implementation

{$R *.dfm}

uses
  Qodelib.HighDpi,
  Qollector.Settings, Qollector.Main, Qollector.DataModule;

{ TwWelcomeForm }

procedure TwWelcomeForm.clRecentFilesBeforeDrawItem(AIndex: Integer;
  ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
var
  Filename: String;
begin
  Filename := QollectorSettings.RecentFilenames[AIndex];
  txItemName.Caption := ChangeFileExt(ExtractFilename(Filename), '');
  txItemFilename.Caption := Filename;
end;

procedure TwWelcomeForm.clRecentFilesItemClick(Sender: TObject);
begin
  dmCommon.LoadDatabase(QollectorSettings.RecentFilenames[clRecentFiles.ItemIndex]);
  clRecentFiles.ItemIndex := -1;
end;

procedure TwWelcomeForm.FormActivate(Sender: TObject);
begin
  txItemName.Font.Size := Font.Size + 2;
  if Font.Size > 8 then
    txItemFileName.Font.Size := Font.Size - 2;
end;

procedure TwWelcomeForm.FormCreate(Sender: TObject);
begin
  RecentFileButtons := TObjectList<TButton>.Create(true);
  GlobalEventBus.RegisterSubscriberForEvents(Self);
end;

procedure TwWelcomeForm.FormDestroy(Sender: TObject);
begin
  RecentFileButtons.Free;
end;

procedure TwWelcomeForm.OnDatabaseLoad(AEvent: IDatabaseLoadEvent);
begin
  txFilename.Caption := AEvent.Filename;
  UpdateRecentFileList;
end;

procedure TwWelcomeForm.OnThemeChange(AEvent: IThemeChangeEvent);
begin
  imItem.ImageCollection := dmCommon.GetImageCollection;
end;

procedure TwWelcomeForm.UpdateRecentFileList;
begin
  clRecentFiles.ItemCount := QollectorSettings.RecentFilenames.Count;
end;

end.
