unit Qollector.Forms;

interface

uses
  System.Classes, System.Generics.Defaults,
  Generics.Collections,
  Vcl.Forms, Vcl.Controls,
  Qodelib.Forms,
  Qollector.FontThemeManager;

type
  TQollectorForm = class(TQzForm)
  private
    FFontThemeManager: TFontThemeManager;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property FontThemeManager: TFontThemeManager read FFontThemeManager;
    procedure AfterConstruction; override;
  end;

  TQollectorFormType = (qftWelcome, qftNotes, qftSettings);

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
  Qollector.WelcomeForm, Qollector.NoteForm, Qollector.SettingsForm;

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
  FForms[qftSettings] := TwSettingsForm.Create(FParent);

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
          Form.FontThemeManager.StyleControls;
          Form.Visible := true;
          Form.Activate;
        end
      else
        begin
          Form.Deactivate;
          Form.Visible := false;
        end;
    end;
end;

{ TQollectorForm }

procedure TQollectorForm.AfterConstruction;
begin
  inherited AfterConstruction;
  FontThemeManager.StyleControls;
end;

constructor TQollectorForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFontThemeManager := TFontThemeManager.Create;
end;

destructor TQollectorForm.Destroy;
begin
  FFontThemeManager.Free;
  FFontThemeManager := nil;
  inherited Destroy;
end;

end.
