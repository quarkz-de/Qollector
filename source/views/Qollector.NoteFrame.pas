unit Qollector.NoteFrame;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls,
  SynEdit, SynEditTypes, SynEditKeyCmds,
  HTMLUn2, HtmlView,
  Qollector.Frames, Qollector.Notes;

type
  TFrame = TQollectorFrame;

  TfrNoteFrame = class(TFrame)
    pcNote: TPageControl;
    tsEdit: TTabSheet;
    tsView: TTabSheet;
    edText: TSynEdit;
    hvText: THtmlViewer;
    procedure edTextCommandProcessed(Sender: TObject; var Command:
      TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure pcNoteChange(Sender: TObject);
  private
    FNote: TNoteItem;
    procedure UpdatePreview;
  protected
    procedure SetNote(const AValue: TNoteItem); virtual;
    procedure SaveValues; override;
    procedure LoadValues; override;
  public
    constructor Create(Owner: TComponent); override;
    function IsModified: Boolean; override;
    property Note: TNoteItem read FNote write SetNote;
  end;

implementation

{$R *.dfm}

uses
  Spring.Container,
  MarkdownProcessor,
  Qollector.Database;

{ TfrNoteFrame }

constructor TfrNoteFrame.Create(Owner: TComponent);
begin
  inherited;
  pcNote.ActivePage := tsEdit;
end;

procedure TfrNoteFrame.edTextCommandProcessed(Sender: TObject; var Command:
  TSynEditorCommand; var AChar: Char; Data: Pointer);

  procedure CopyLastLinePrefix(const APrefix: String);
  var
    LineIndex: Integer;
  begin
    LineIndex := edText.CaretY - 2;
    if LineIndex >= 0 then
      begin
        if (APrefix = edText.Lines[LineIndex]) then
          edText.Lines[LineIndex] := ''
        else if StartsText(APrefix, edText.Lines[LineIndex]) then
          edText.SelText := APrefix;
      end;
  end;

begin
  case Command of
    ecLineBreak:
      begin
        CopyLastLinePrefix('* ');
        CopyLastLinePrefix('- ');
      end;
  end;
end;

function TfrNoteFrame.IsModified: Boolean;
begin
  Result := edText.Modified or Application.Terminated;
end;

procedure TfrNoteFrame.LoadValues;
begin
  edText.Lines.Text := Note.Text;
  edText.Modified := false;
  UpdatePreview;
end;

procedure TfrNoteFrame.pcNoteChange(Sender: TObject);
begin
  if pcNote.ActivePage = tsView then
    begin
      if IsModified then
        SaveValues;
      UpdatePreview;
    end;
end;

procedure TfrNoteFrame.SaveValues;
var
  Database: IQollectorDatabase;
begin
  Note.Text := edText.Lines.Text;
  edText.Modified := false;

  Database := GlobalContainer.Resolve<IQollectorDatabase>;
  Database.GetSession.Save(Note);
end;

procedure TfrNoteFrame.SetNote(const AValue: TNoteItem);
begin
  FNote := AValue;
  LoadValues;
end;

procedure TfrNoteFrame.UpdatePreview;
var
  Markdown: TMarkdownProcessor;
begin
  Markdown := TMarkdownProcessor.CreateDialect(mdDaringFireball);
  Markdown.UnSafe := true;
  hvText.LoadFromString(Markdown.Process(edText.Text));
end;

end.
