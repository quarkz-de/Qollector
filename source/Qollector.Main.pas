unit Qollector.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.CategoryButtons, Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.ActnList,
  Vcl.StdActns, Vcl.Clipbrd,
  VirtualTrees,
  Eventbus,
  Qollector.Visualizers, Qollector.Events, Qollector.Frames,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.TitleBarCtrls;

type
  TwMain = class(TForm)
    stNotebooks: TVirtualStringTree;
    spSplitter: TSplitter;
    odBookmark: TOpenDialog;
    amActions: TActionManager;
    acHelpAbout: TAction;
    acFileExit: TFileExit;
    acFileOpen: TFileOpen;
    acSettings: TAction;
    acNewNotebook: TAction;
    acNewNote: TAction;
    acDeleteNote: TAction;
    acNewBookmark: TAction;
    acNewFavorite: TFileOpen;
    tbpTitleBar: TTitleBarPanel;
    mbMain: TActionMainMenuBar;
    procedure FormDestroy(Sender: TObject);
    procedure acDeleteNoteExecute(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure acNewBookmarkExecute(Sender: TObject);
    procedure acNewFavoriteAccept(Sender: TObject);
    procedure acNewNotebookExecute(Sender: TObject);
    procedure acNewNoteExecute(Sender: TObject);
    procedure acSettingsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mbMainPaint(Sender: TObject);
    procedure stNotebooksFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure stNotebooksFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode:
      PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
  private
    FTreeVisualizer: INotesTreeVisualizer;
    FFrames: TQollectorFrameList;
    procedure UpateActions(const ASelectedItemType: TNotesTreeItemType);
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WmSize(var Message: TWMSize); message WM_SIZE;
  protected
    property Frames: TQollectorFrameList read FFrames;
  public
    [Subscribe(TThreadMode.Main)]
    procedure OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
    [Subscribe(TThreadMode.Main)]
    procedure OnSelectItem(AEvent: TSelectItemEvent);
    [Subscribe(TThreadMode.Main)]
    procedure OnThemeChange(AEvent: TThemeChangeEvent);
  end;

var
  wMain: TwMain;

implementation

{$R *.dfm}

uses
  Spring.Container, Spring.Collections,
  Qollector.DataModule, Qollector.Notes, Qollector.About,
  Qollector.SettingsDialog, Qollector.Execute;

procedure TwMain.acDeleteNoteExecute(Sender: TObject);
begin
  FTreeVisualizer.DeleteSelectedItem;
end;

procedure TwMain.acHelpAboutExecute(Sender: TObject);
begin
  TwAbout.ExecuteDialog;
end;

procedure TwMain.acNewBookmarkExecute(Sender: TObject);
var
  Url: String;
begin
  if Clipboard.HasFormat(CF_TEXT) then
    Url := Clipboard.AsText
  else
    Url := '';

  if TShellExecute.IsUrl(Url) then
    Frames.NoteFrame.NewFavoriteItem(Url)
  else
    Frames.NoteFrame.NewFavoriteItem('');
end;

procedure TwMain.acNewFavoriteAccept(Sender: TObject);
begin
  Frames.NoteFrame.NewFavoriteItem(acNewFavorite.Dialog.Filename);
end;

procedure TwMain.acNewNotebookExecute(Sender: TObject);
begin
  FTreeVisualizer.NewNotebook;
end;

procedure TwMain.acNewNoteExecute(Sender: TObject);
begin
  FTreeVisualizer.NewNote;
end;

procedure TwMain.acSettingsExecute(Sender: TObject);
begin
  TwSettingsDialog.ExecuteDialog;
end;

procedure TwMain.FormCreate(Sender: TObject);
begin
  FFrames := TQollectorFrameList.Create(self);

  GlobalEventBus.RegisterSubscriberForEvents(Self);
  dmCommon.MainFormCreated;

  FTreeVisualizer := GlobalContainer.Resolve<INotesTreeVisualizer>;
  FTreeVisualizer.SetVirtualTree(stNotebooks);

  dmCommon.LoadDatabase('');
end;

procedure TwMain.FormDestroy(Sender: TObject);
begin
  FFrames.Free;
end;

procedure TwMain.mbMainPaint(Sender: TObject);
var
  Color: TColor;
begin
  if CustomTitleBar.Enabled and not CustomTitleBar.SystemColors then
    begin
      if Active then
        Color := CustomTitleBar.BackgroundColor
      else
        Color := CustomTitleBar.InactiveBackgroundColor;
      mbMain.Canvas.Brush.Color := Color;
      mbMain.Canvas.FillRect(mbMain.ClientRect);
    end;
end;

procedure TwMain.OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
var
  Notebooks: IList<TNotebookItem>;
begin
  Caption := 'Qollector - ' + ExtractFilename(AEvent.Filename);

  Notebooks := dmCommon.Database.GetSession.FindAll<TNotebookItem>();
  FTreeVisualizer.SetNotebookItems(Notebooks);
  FTreeVisualizer.UpdateContent;

  UpateActions(itNone);
end;

procedure TwMain.OnSelectItem(AEvent: TSelectItemEvent);
begin
  case AEvent.ItemType of
    itNone:
      Frames.ShowFrame(nil);
    itNotebookItem:
      Frames.ShowFrame(nil);
    itNoteItem:
      begin
        Frames.ShowFrame(Frames.NoteFrame);
        Frames.NoteFrame.Note := FTreeVisualizer.GetSelectedNote;
      end;
  end;
  UpateActions(AEvent.ItemType);
end;

procedure TwMain.OnThemeChange(AEvent: TThemeChangeEvent);
begin
  CustomTitleBar.SystemColors := AEvent.ThemeName = 'Windows';
  mbMain.Invalidate;
end;

procedure TwMain.stNotebooksFocusChanged(Sender: TBaseVirtualTree; Node:
  PVirtualNode; Column: TColumnIndex);
begin
  GlobalEventBus.Post(TSelectItemEvent.Create(FTreeVisualizer.GetSelectedItemType), '', TEventMM.mmAutomatic);
end;

procedure TwMain.stNotebooksFocusChanging(Sender: TBaseVirtualTree; OldNode,
  NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed:
  Boolean);
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
        Frames.NoteFrame.SaveData;
      end;
  end;
end;

procedure TwMain.UpateActions(const ASelectedItemType: TNotesTreeItemType);
var
  IsItemSelected: Boolean;
begin
  IsItemSelected := ASelectedItemType in [itNotebookItem, itNoteItem];

  acDeleteNote.Enabled := IsItemSelected;
  acNewNote.Enabled := IsItemSelected;
  acNewBookmark.Enabled := IsItemSelected;
  acNewFavorite.Enabled := IsItemSelected;
end;

procedure TwMain.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if CustomTitleBar.Enabled and Assigned(mbMain) then
    mbMain.Invalidate;
end;

procedure TwMain.WmSize(var Message: TWMSize);
begin
  inherited;
  if Assigned(mbMain) then
    begin
      case Message.SizeType of
        SIZE_MAXIMIZED:
          mbMain.Top := 0;
        SIZE_RESTORED:
          mbMain.Top := (CustomTitleBar.Height - mbMain.Height) div 2;
      end;
    end;
end;

end.
