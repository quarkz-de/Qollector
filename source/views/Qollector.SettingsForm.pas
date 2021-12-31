unit Qollector.SettingsForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls,
  Eventbus,
  Qollector.Forms, Qollector.Events, Vcl.WinXCtrls, Vcl.WinXPanels;

type
  TwSettingsForm = class(TQollectorForm)
    txTheme: TLabel;
    cbTheme: TComboBox;
    cbEditorFont: TComboBox;
    txEditorFont: TLabel;
    cbEditorFontSize: TComboBox;
    txView: TLabel;
    Bevel1: TBevel;
    procedure cbEditorFontChange(Sender: TObject);
    procedure cbEditorFontSizeChange(Sender: TObject);
    procedure cbThemeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadValues;
    procedure InitControls;
  public
  end;

implementation

{$R *.dfm}

uses
  Qodelib.Themes, QodeLib.Fonts,
  Qollector.Settings, Qollector.FontThemeManager;

{ TwSettingsForm }

procedure TwSettingsForm.cbEditorFontChange(Sender: TObject);
begin
  if cbEditorFont.ItemIndex > -1 then
    QollectorSettings.EditorFont := cbEditorFont.Items[cbEditorFont.ItemIndex];
end;

procedure TwSettingsForm.cbEditorFontSizeChange(Sender: TObject);
var
  Size: Integer;
begin
  Size := String(cbEditorFontSize.Text).ToInteger;
  if Size > 5 then
    QollectorSettings.EditorFontSize := Size;
end;

procedure TwSettingsForm.cbThemeChange(Sender: TObject);
begin
  QollectorSettings.Theme := cbTheme.Items[cbTheme.ItemIndex];
end;

procedure TwSettingsForm.FormCreate(Sender: TObject);
begin
  FontThemeManager.AddControl(txView, ftHeading);
//  GlobalEventBus.RegisterSubscriberForEvents(Self);
  InitControls;
  LoadValues;
end;

procedure TwSettingsForm.InitControls;
var
  I: Integer;
begin
  cbEditorFontSize.Items.Clear;
  for I := 6 to 30 do
    cbEditorFontSize.Items.Add(I.ToString);
end;

procedure TwSettingsForm.LoadValues;
begin
  QuarkzThemeManager.AssignThemeNames(cbTheme.Items);
  cbTheme.ItemIndex := cbTheme.Items.IndexOf(QollectorSettings.Theme);

  TFontNames.GetFixedPitchFonts(cbEditorFont.Items);
  cbEditorFont.ItemIndex := cbEditorFont.Items.IndexOf(QollectorSettings.EditorFont);
  cbEditorFontSize.Text := QollectorSettings.EditorFontSize.ToString;
end;

end.
