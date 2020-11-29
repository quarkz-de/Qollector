unit Qollector.EditLink;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Qollector.Notes, Vcl.StdCtrls;

type
  TwLinkEditor = class(TForm)
    txName: TLabel;
    txFilename: TLabel;
    edName: TEdit;
    edFilename: TEdit;
    btOk: TButton;
    btCancel: TButton;
  private
    procedure LoadValues(const ALink: TLinkItem);
    procedure SaveValues(const ALink: TLinkItem);
  public
    function Execute(const ALink: TLinkItem): Boolean;
    class function ExecuteDialog(const ALink: TLinkItem): Boolean;
  end;

var
  wLinkEditor: TwLinkEditor;

implementation

{$R *.dfm}

{ TwLinkEditor }

function TwLinkEditor.Execute(const ALink: TLinkItem): Boolean;
begin
  LoadValues(ALink);
  Result := ShowModal = mrOk;
  if Result then
    SaveValues(ALink);
end;

class function TwLinkEditor.ExecuteDialog(const ALink: TLinkItem): Boolean;
var
  Dlg: TwLinkEditor;
begin
  Dlg := TwLinkEditor.Create(nil);
  try
    Result := Dlg.Execute(ALink);
  finally
    Dlg.Free;
  end;
end;

procedure TwLinkEditor.LoadValues(const ALink: TLinkItem);
begin
  edName.Text := ALink.Name;
  edFilename.Text := ALink.Filename;
end;

procedure TwLinkEditor.SaveValues(const ALink: TLinkItem);
begin
  ALink.Name := edName.Text;
  ALink.Filename := edFilename.Text;
end;

end.
