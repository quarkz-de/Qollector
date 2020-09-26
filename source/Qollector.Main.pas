unit Qollector.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.CategoryButtons, Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.ActnList,
  Vcl.StdActns,
  VirtualTrees,
  Eventbus,
  Qollector.Visualizers, Qollector.Events, Qollector.NoteFrame;

type
  TwMain = class(TForm)
    mmMenu: TMainMenu;
    alActions: TActionList;
    acFileExit: TFileExit;
    miFile: TMenuItem;
    miFileExit: TMenuItem;
    acFileOpen: TFileOpen;
    N1: TMenuItem;
    miFileOpen: TMenuItem;
    stNotebooks: TVirtualStringTree;
    spSplitter: TSplitter;
    acNewNotebook: TAction;
    acNewNote: TAction;
    miNotes: TMenuItem;
    miNewNotebook: TMenuItem;
    miNewNote: TMenuItem;
    procedure acNewNotebookExecute(Sender: TObject);
    procedure acNewNoteExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure stNotebooksFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
        Column: TColumnIndex);
    procedure stNotebooksFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode:
        PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
  private
    FTreeVisualizer: INotesTreeVisualizer;
    FNoteFrame: TfrNoteFrame;
  public
    [Subscribe(TThreadMode.Main)]
    procedure OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
  end;

var
  wMain: TwMain;

implementation

{$R *.dfm}

uses
  Spring.Container, Spring.Collections,
  Qollector.DataModule, Qollector.Notes;

procedure TwMain.acNewNotebookExecute(Sender: TObject);
begin
  FTreeVisualizer.NewNotebook;
end;

procedure TwMain.acNewNoteExecute(Sender: TObject);
begin
  FTreeVisualizer.NewNote;
end;

procedure TwMain.FormCreate(Sender: TObject);
begin
  FNoteFrame := TfrNoteFrame.Create(self);
  FNoteFrame.Visible := false;
  FNoteFrame.Parent := self;
  FNoteFrame.Align := alClient;

  GlobalEventBus.RegisterSubscriberForEvents(Self);

  FTreeVisualizer := GlobalContainer.Resolve<INotesTreeVisualizer>;
  FTreeVisualizer.SetVirtualTree(stNotebooks);

  dmCommon.LoadDatabase('');
end;

procedure TwMain.OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
var
  Notebooks: IList<TNotebookItem>;
begin
  Caption := 'Qollector - ' + ExtractFilename(AEvent.Filename);

  Notebooks := dmCommon.Database.GetSession.FindAll<TNotebookItem>();
  FTreeVisualizer.SetNotebookItems(Notebooks);
  FTreeVisualizer.UpdateContent;
end;

procedure TwMain.stNotebooksFocusChanged(Sender: TBaseVirtualTree; Node:
  PVirtualNode; Column: TColumnIndex);
begin
  case FTreeVisualizer.GetSelectedItemType of
    itNone:
      begin
        FNoteFrame.Visible := false;
      end;
    itNotebookItem:
      begin
        FNoteFrame.Visible := false;
      end;
    itNoteItem:
      begin
        FNoteFrame.Note := FTreeVisualizer.GetSelectedNote;
        FNoteFrame.Visible := true;
      end;
  end;
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
        FNoteFrame.SaveData;
      end;
  end;
end;

end.
