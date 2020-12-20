unit Qollector.SettingsForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls,
  Eventbus,
  Qollector.Forms, Qollector.Events;

type
  TwSettingsForm = class(TQollectorForm)
    txTheme: TLabel;
    cbTheme: TComboBox;
    cbEditorFont: TComboBox;
    txEditorFont: TLabel;
    procedure cbEditorFontChange(Sender: TObject);
    procedure cbThemeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadValues;
  public
  end;

implementation

{$R *.dfm}

uses
  Qodelib.Themes, QodeLib.Fonts,
  Qollector.Settings;

procedure TwSettingsForm.cbEditorFontChange(Sender: TObject);
begin
  if cbEditorFont.ItemIndex > -1 then
    QollectorSettings.EditorFont := cbEditorFont.Items[cbEditorFont.ItemIndex];
end;

{ TwWelcomeForm }

procedure TwSettingsForm.cbThemeChange(Sender: TObject);
begin
  QollectorSettings.Theme := cbTheme.Items[cbTheme.ItemIndex];
end;

procedure TwSettingsForm.FormCreate(Sender: TObject);
begin
//  GlobalEventBus.RegisterSubscriberForEvents(Self);
  LoadValues;
end;

procedure TwSettingsForm.LoadValues;
begin
  QuarkzThemeManager.AssignThemeNames(cbTheme.Items);
  cbTheme.ItemIndex := cbTheme.Items.IndexOf(QollectorSettings.Theme);

  TFontNames.GetFixedPitchFonts(cbEditorFont.Items);
  cbEditorFont.ItemIndex := cbEditorFont.Items.IndexOf(QollectorSettings.EditorFont);
end;

end.
