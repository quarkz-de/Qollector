unit Qollector.NoteFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Qollector.Frames, Qollector.Notes;

type
  TFrame = TQollectorFrame;

  TfrNoteFrame = class(TFrame)
    edText: TMemo;
  protected
    procedure SaveValues; override;
    procedure LoadValues; override;
  public
    constructor Create(Owner: TComponent); override;
    function IsModified: Boolean; override;
  end;

implementation

{$R *.dfm}

{ TfrNoteFrame }

constructor TfrNoteFrame.Create(Owner: TComponent);
begin
  inherited;
  edText.Font.Name := 'Consolas';
  edText.Font.Size := edText.Font.Size + 2;
end;

function TfrNoteFrame.IsModified: Boolean;
begin
  Result := edText.Modified or Application.Terminated;
end;

procedure TfrNoteFrame.LoadValues;
begin
  edText.Lines.Text := Note.Data;
  edText.Modified := false;
end;

procedure TfrNoteFrame.SaveValues;
begin
  Note.Data := edText.Lines.Text;
  edText.Modified := false;
end;

end.
