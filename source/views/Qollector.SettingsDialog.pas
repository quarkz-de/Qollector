unit Qollector.SettingsDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TwSettingsDialog = class(TForm)
    txTheme: TLabel;
    cbTheme: TComboBox;
    btOk: TButton;
    btCancel: TButton;
  private
    procedure LoadValues;
    procedure SaveValues;
  public
    function Execute: Boolean;
    class function ExecuteDialog: Boolean;
  end;

var
  wSettingsDialog: TwSettingsDialog;

implementation

{$R *.dfm}

uses
  Qodelib.Themes,
  Qollector.Settings;

{ TwSettingsDialog }

function TwSettingsDialog.Execute: Boolean;
begin
  LoadValues;
  Result := ShowModal = mrOk;
  if Result then
    SaveValues;
end;

class function TwSettingsDialog.ExecuteDialog: Boolean;
var
  Dialog: TwSettingsDialog;
begin
  Dialog := TwSettingsDialog.Create(nil);
  try
    Result := Dialog.Execute;
  finally
    Dialog.Free;
  end;
end;

procedure TwSettingsDialog.LoadValues;
begin
  QuarkzThemeManager.AssignThemeNames(cbTheme.Items);
  cbTheme.ItemIndex := cbTheme.Items.IndexOf(QollectorSettings.Theme);
end;

procedure TwSettingsDialog.SaveValues;
begin
  QollectorSettings.Theme := cbTheme.Items[cbTheme.ItemIndex];
end;

end.
