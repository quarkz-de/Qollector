unit Qollector.NoteFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, Winapi.ActiveX,
  System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  System.Win.ComObj,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls,
  VirtualTrees,
  SynEdit, SynEditTypes, SynEditKeyCmds,
  HTMLUn2, HtmlView, UrlConn,
  Qodelib.Themes,
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
    Connectors: ThtConnectionManager;
    FileConnector: ThtFileConnector;
    ResourceConnector: ThtResourceConnector;
    procedure edTextCommandProcessed(Sender: TObject; var Command:
      TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure hvTextHotSpotClick(Sender: TObject; const SRC: string; var Handled:
        Boolean);
    procedure pcNoteChange(Sender: TObject);
    procedure stLinksDblClick(Sender: TObject);
    procedure stLinksDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure stLinksDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure stLinksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
  Qollector.Database,
  Qollector.Execute;

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

procedure TfrNoteFrame.hvTextHotSpotClick(Sender: TObject; const SRC: string;
    var Handled: Boolean);
begin
  TShellExecute.Open(SRC);
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
begin
  TShellExecute.Open(FVisualizer.GetSelectedItem);
end;

procedure TfrNoteFrame.stLinksDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);

  procedure GetFileListFromObj(const DataObj: IDataObject;
    FileList: TStringList);
  var
    FmtEtc: TFormatEtc;
    Medium: TStgMedium;
    DroppedFileCount: Integer;
    I: Integer;
    FileNameLength: Integer;
    FileName: string;
  begin
    FmtEtc.cfFormat := CF_HDROP;
    FmtEtc.ptd := nil;
    FmtEtc.dwAspect := DVASPECT_CONTENT;
    FmtEtc.lindex := -1;
    FmtEtc.tymed := TYMED_HGLOBAL;
    OleCheck(DataObj.GetData(FmtEtc, Medium));
    try
      try
        DroppedFileCount := DragQueryFile(Medium.hGlobal, $FFFFFFFF, nil, 0);
        for I := 0 to Pred(DroppedFileCount) do
          begin
            FileNameLength := DragQueryFile(Medium.hGlobal, I, nil, 0);
            SetLength(FileName, FileNameLength);
            DragQueryFileW(Medium.hGlobal, I, PWideChar(FileName), FileNameLength + 1);
            FileList.Append(FileName);
          end;
      finally
        DragFinish(Medium.hGlobal);
      end;
    finally
      ReleaseStgMedium(Medium);
    end;
  end;

var
  I, J: Integer;
  DroppedFiles: TStringList;
begin
  DroppedFiles := TStringList.Create;
  try
    for I := 0 to High(Formats) - 1 do
      begin
        if (Formats[i] = CF_HDROP) then
          begin
            GetFileListFromObj(DataObject, DroppedFiles);
            for J := 0 to DroppedFiles.Count - 1 do
              FVisualizer.NewFavoriteItem(Note, DroppedFiles[J]);
          end;
      end;
  finally
    DroppedFiles.Free;
  end;
end;

procedure TfrNoteFrame.stLinksDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := true;
end;

procedure TfrNoteFrame.stLinksKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  case Key of
    VK_DELETE:
      if Shift = [] then
        begin
          FVisualizer.DeleteSelectedItem;
          Key := 0;
        end;
    VK_RETURN:
      if Shift = [] then
        begin
          TShellExecute.Open(FVisualizer.GetSelectedItem);
          Key := 0;
        end;
    VK_F2:
      if Shift = [ssShift] then
        begin
          stLinks.EditNode(stLinks.FocusedNode, 1);
          Key := 0;
        end;
  end;
end;

procedure TfrNoteFrame.UpdatePreview;
var
  Markdown: TMarkdownProcessor;
  Html: String;
begin
  Markdown := TMarkdownProcessor.CreateDialect(mdCommonMark);
  Html := '<html><head>' + #13#10 +
    '<link rel="StyleSheet" type="text/css" href="res:///' +
    QuarkzThemeManager.StyleResource + '.css">' + #13#10 +
    '</head><body>' + #13#10 +
    Markdown.Process(edText.Text) + #13#10 +
    '</body></html>';
  hvText.LoadFromString(Html);
  Markdown.Free;
end;

end.
