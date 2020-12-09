unit Qollector.Forms;

interface

uses
  System.Generics.Collections, System.Generics.Defaults,
  Vcl.Forms, Vcl.Controls;

type
  TQollectorForm = class(TForm);

  TQollectorFormType = (qftWelcome, qftNotes);

  TQollectorFormList = class(TObject)
  private
    FParent: TForm;
    FForms: array[TQollectorFormType] of TQollectorForm;
    function GetActiveForm: TQollectorForm;
    procedure CreateForms;
  public
    constructor Create(const AParent: TForm);
    procedure ShowForm(const AForm: TQollectorFormType);
    property ActiveForm: TQollectorForm read GetActiveForm;
  end;

implementation

uses
  Qollector.WelcomeForm, Qollector.NoteForm;

{ TQollectorFormList }

constructor TQollectorFormList.Create(const AParent: TForm);
begin
  inherited Create;
  FParent := AParent;
  CreateForms;
end;

procedure TQollectorFormList.CreateForms;
var
  Form: TQollectorForm;
begin
  FForms[qftWelcome] := TwWelcomeForm.Create(FParent);
  FForms[qftNotes] := TwNoteForm.Create(FParent);

  for Form in FForms do
    Form.Font := FParent.Font;
end;

function TQollectorFormList.GetActiveForm: TQollectorForm;
var
  Form: TQollectorForm;
begin
  Result := nil;
  for Form in FForms do
    if (Form <> nil) and (Form.Visible) then
      begin
        Result := Form;
        Break;
      end;
end;

procedure TQollectorFormList.ShowForm(const AForm: TQollectorFormType);
var
  Form: TQollectorForm;
  FormType: TQollectorFormType;
begin
  for FormType := Low(TQollectorFormType) to High(TQollectorFormType) do
    begin
      Form := FForms[FormType];
      if (FormType = AForm) then
        begin
          Form.Parent := FParent;
          Form.Align := alClient;
          Form.Visible := true;
          Form.Activate;
        end
      else
        begin
          Form.Deactivate;
          Form.Visible := false;
          Form.Parent := nil;
        end;
    end;
end;

end.
