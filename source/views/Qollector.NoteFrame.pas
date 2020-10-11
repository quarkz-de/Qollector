unit Qollector.NoteFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls,
  VirtualTrees,
  SynEdit, SynEditTypes, SynEditKeyCmds,
  HTMLUn2, HtmlView,
  Qollector.Notes, Qollector.Visualizers;

type
  TfrNoteFrame = class(TFrame)
    pcNote: TPageControl;
    tsEdit: TTabSheet;
    tsView: TTabSheet;
    edText: TSynEdit;
    hvText: THtmlViewer;
    tsLinks: TTabSheet;
    stLinks: TVirtualStringTree;
    procedure edTextCommandProcessed(Sender: TObject; var Command:
      TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure pcNoteChange(Sender: TObject);
    procedure stLinksDblClick(Sender: TObject);
  private
    FNote: TNoteItem;
    FVisualizer: ILinkListVisualizer;
    procedure UpdatePreview;
  protected
    procedure SetNote(const AValue: TNoteItem); virtual;
    procedure SaveValues;
    procedure LoadValues;
  public
    constructor Create(Owner: TComponent); override;
    function IsModified: Boolean;
    procedure SaveData;
    procedure NewFavoriteItem(const AFilename: TFilename);
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
  FVisualizer := GlobalContainer.Resolve<ILinkListVisualizer>;
  FVisualizer.SetVirtualTree(stLinks);
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
        CopyLastLinePrefix('> ');
      end;
  end;
end;

function TfrNoteFrame.IsModified: Boolean;
begin
  Result := edText.Modified;
end;

procedure TfrNoteFrame.LoadValues;
begin
  edText.Lines.Text := Note.Text;
  edText.Modified := false;
  UpdatePreview;
  FVisualizer.SetLinkItems(Note.Links);
  FVisualizer.UpdateContent;
end;

procedure TfrNoteFrame.NewFavoriteItem(const AFilename: TFilename);
begin
  FVisualizer.NewFavoriteItem(Note, AFilename);
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

procedure TfrNoteFrame.SaveData;
begin
  if IsModified then
    SaveValues;
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

procedure TfrNoteFrame.stLinksDblClick(Sender: TObject);
var
  Item: TLinkItem;
begin
  Item := FVisualizer.GetSelectedItem;
  if Item <> nil then
    ShellExecute(0, 'open', PChar(Item.Filename), nil, nil, SW_SHOWNORMAL);
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
