unit Qollector.NoteFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, Winapi.ActiveX,
  System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  System.Win.ComObj, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.StdActns, Vcl.ActnList, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ToolWin, Vcl.Clipbrd,
  VirtualTrees,
  Eventbus,
  SynEdit, SynEditTypes, SynEditKeyCmds,
  HTMLUn2, HtmlView, UrlConn,
  Qodelib.Themes,
  Qollector.Notes, Qollector.Events, Qollector.Visualizers, Vcl.Menus;

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
    spSplitter: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    stNotebooks: TVirtualStringTree;
    Label1: TLabel;
    alActions: TActionList;
    acNewNotebook: TAction;
    acNewNote: TAction;
    acDeleteItem: TAction;
    acNewBookmark: TAction;
    acNewFavorite: TFileOpen;
    tbBookmarks: TToolBar;
    tbNewBookmark: TToolButton;
    tbNewFavorite: TToolButton;
    tbNotes: TToolBar;
    tbNewNotebook: TToolButton;
    tbNewNote: TToolButton;
    tbDeleteItem: TToolButton;
    acDeleteLink: TAction;
    acEditLink: TAction;
    btEditLink: TToolButton;
    btDeleteLink: TToolButton;
    pmNotes: TPopupMenu;
    pmLinks: TPopupMenu;
    miNewNotebook: TMenuItem;
    miNewNote: TMenuItem;
    miDeleteItem: TMenuItem;
    miNewBookmark: TMenuItem;
    miNewFavorite: TMenuItem;
    miEditLink: TMenuItem;
    miDeleteLink: TMenuItem;
    procedure acDeleteItemExecute(Sender: TObject);
    procedure acDeleteLinkExecute(Sender: TObject);
    procedure acEditLinkExecute(Sender: TObject);
    procedure acNewBookmarkExecute(Sender: TObject);
    procedure acNewFavoriteAccept(Sender: TObject);
    procedure acNewNotebookExecute(Sender: TObject);
    procedure acNewNoteExecute(Sender: TObject);
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
    procedure stLinksFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
        Column: TColumnIndex);
    procedure stLinksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure stNotebooksFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
        Column: TColumnIndex);
    procedure stNotebooksFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode:
        PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
  private
    FLinkVisualizer: ILinkListVisualizer;
    FTreeVisualizer: INotesTreeVisualizer;
    function IsModified: Boolean;
    procedure UpdatePreview;
    procedure UpdateNoteActions(const ASelectedItemType: TNotesTreeItemType);
    procedure UpdateLinkActions;
    procedure NewFavoriteItem(const AFilename: TFilename);
    function GetCurrentNote: TNoteItem;
  protected
    procedure LoadNote(const ANote: TNoteItem);
    procedure SaveNote(const ANote: TNoteItem);
    property CurrentNote: TNoteItem read GetCurrentNote;
  public
    constructor Create(Owner: TComponent); override;
    [Subscribe(TThreadMode.Main)]
    procedure OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
    procedure SaveChanges;
  end;

implementation

{$R *.dfm}

uses
  Spring.Container, Spring.Collections,
  MarkdownProcessor,
  Qollector.Database, Qollector.Execute, Qollector.DataModule,
  Qollector.EditLink;

{ TfrNoteFrame }

constructor TfrNoteFrame.Create(Owner: TComponent);
begin
  inherited;
  GlobalEventBus.RegisterSubscriberForEvents(Self);

  pcNote.ActivePage := tsEdit;

  FLinkVisualizer := GlobalContainer.Resolve<ILinkListVisualizer>;
  FLinkVisualizer.SetVirtualTree(stLinks);

  FTreeVisualizer := GlobalContainer.Resolve<INotesTreeVisualizer>;
  FTreeVisualizer.SetVirtualTree(stNotebooks);
end;

procedure TfrNoteFrame.acDeleteItemExecute(Sender: TObject);
begin
  FTreeVisualizer.DeleteSelectedItem;
end;

procedure TfrNoteFrame.acDeleteLinkExecute(Sender: TObject);
begin
  FLinkVisualizer.DeleteSelectedItem;
end;

procedure TfrNoteFrame.acEditLinkExecute(Sender: TObject);
var
  Link: TLinkItem;
  Database: IQollectorDatabase;
begin
  Link := FLinkVisualizer.GetSelectedItem;
  if TwLinkEditor.ExecuteDialog(Link) then
    begin
      Database := GlobalContainer.Resolve<IQollectorDatabase>;
      Database.GetSession.Save(Link);
    end;
end;

procedure TfrNoteFrame.acNewBookmarkExecute(Sender: TObject);
var
  Url: String;
begin
  if Clipboard.HasFormat(CF_TEXT) then
    Url := Clipboard.AsText
  else
    Url := '';

  if TShellExecute.IsUrl(Url) then
    NewFavoriteItem(Url)
  else
    NewFavoriteItem('');
end;

procedure TfrNoteFrame.acNewFavoriteAccept(Sender: TObject);
begin
  NewFavoriteItem(acNewFavorite.Dialog.Filename);
end;

procedure TfrNoteFrame.acNewNotebookExecute(Sender: TObject);
begin
  FTreeVisualizer.NewNotebook;
end;

procedure TfrNoteFrame.acNewNoteExecute(Sender: TObject);
begin
  FTreeVisualizer.NewNote;
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

function TfrNoteFrame.GetCurrentNote: TNoteItem;
begin
  Result := FTreeVisualizer.GetSelectedNote;
end;

procedure TfrNoteFrame.hvTextHotSpotClick(Sender: TObject; const SRC: string;
    var Handled: Boolean);
begin
  TShellExecute.Open(SRC);
end;

function TfrNoteFrame.IsModified: Boolean;
begin
  Result := (CurrentNote.Id < 1) or edText.Modified;
end;

procedure TfrNoteFrame.LoadNote(const ANote: TNoteItem);
begin
  edText.Lines.Text := ANote.Text;
  edText.Modified := false;
  UpdatePreview;
  FLinkVisualizer.SetLinkItems(ANote.Links);
  FLinkVisualizer.UpdateContent;
  UpdateLinkActions;
end;

procedure TfrNoteFrame.NewFavoriteItem(const AFilename: TFilename);
begin
  FLinkVisualizer.NewFavoriteItem(CurrentNote, AFilename);
end;

procedure TfrNoteFrame.OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
var
  Notebooks: IList<TNotebookItem>;
begin
  Notebooks := dmCommon.Database.GetSession.FindAll<TNotebookItem>();
  FTreeVisualizer.SetNotebookItems(Notebooks);
  FTreeVisualizer.UpdateContent;
  UpdateNoteActions(itNone);
end;

procedure TfrNoteFrame.pcNoteChange(Sender: TObject);
begin
  if pcNote.ActivePage = tsView then
    begin
      SaveNote(CurrentNote);
      UpdatePreview;
    end;
end;

procedure TfrNoteFrame.SaveChanges;
begin
  SaveNote(CurrentNote);
end;

procedure TfrNoteFrame.SaveNote(const ANote: TNoteItem);
var
  Database: IQollectorDatabase;
begin
  if (ANote <> nil) and IsModified then
    begin
      ANote.Text := edText.Lines.Text;
      edText.Modified := false;

      Database := GlobalContainer.Resolve<IQollectorDatabase>;
      Database.GetSession.Save(ANote);
    end;
end;

procedure TfrNoteFrame.stLinksDblClick(Sender: TObject);
begin
  TShellExecute.Open(FLinkVisualizer.GetSelectedItem);
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
              FLinkVisualizer.NewFavoriteItem(CurrentNote, DroppedFiles[J]);
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

procedure TfrNoteFrame.stLinksFocusChanged(Sender: TBaseVirtualTree; Node:
    PVirtualNode; Column: TColumnIndex);
begin
  UpdateLinkActions;
end;

procedure TfrNoteFrame.stLinksKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  case Key of
    VK_DELETE:
      if Shift = [] then
        begin
          FLinkVisualizer.DeleteSelectedItem;
          Key := 0;
        end;
    VK_RETURN:
      if Shift = [] then
        begin
          TShellExecute.Open(FLinkVisualizer.GetSelectedItem);
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

procedure TfrNoteFrame.stNotebooksFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  case FTreeVisualizer.GetItemType(Node) of
    itNone:
      begin
        pcNote.Visible := false;
      end;
    itNotebookItem:
      begin
        pcNote.Visible := false;
      end;
    itNoteItem:
      begin
        pcNote.Visible := true;
        LoadNote(CurrentNote);
      end;
  end;

  UpdateNoteActions(FTreeVisualizer.GetItemType(Node));
end;

procedure TfrNoteFrame.stNotebooksFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
  case FTreeVisualizer.GetItemType(OldNode) of
    itNone:
      begin
      end;
    itNotebookItem:
      begin
      end;
    itNoteItem:
      begin
        SaveNote(CurrentNote);
      end;
  end;
end;

procedure TfrNoteFrame.UpdateLinkActions;
var
  IsItemSelected: Boolean;
begin
  IsItemSelected := FLinkVisualizer.GetSelectedItem <> nil;
  acEditLink.Enabled := IsItemSelected;
  acDeleteLink.Enabled := IsItemSelected;
end;

procedure TfrNoteFrame.UpdateNoteActions(
  const ASelectedItemType: TNotesTreeItemType);
var
  IsItemSelected: Boolean;
begin
  IsItemSelected := ASelectedItemType in [itNotebookItem, itNoteItem];
  acDeleteItem.Enabled := IsItemSelected;
  acNewNote.Enabled := IsItemSelected;
  acNewBookmark.Enabled := IsItemSelected;
  acNewFavorite.Enabled := IsItemSelected;
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
