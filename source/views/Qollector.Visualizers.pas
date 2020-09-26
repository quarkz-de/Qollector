unit Qollector.Visualizers;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes,
  Spring.Collections, Spring.Container,
  VirtualTrees,
  Qollector.Notes, Qollector.Database;

type
  TNotesTreeItemType = (itNone, itNotebookItem, itNoteItem);

  INotesTreeVisualizer = interface
    ['{E19DF1AA-DE43-4B86-9B98-3AB754881DE6}']
    procedure SetVirtualTree(const ATree: TVirtualStringTree);
    procedure SetNotebookItems(const AList: IList<TNotebookItem>);
    procedure UpdateContent;
    function NewNote: TNoteItem;
    function NewNotebook: TNotebookItem;
    function GetSelectedItemType: TNotesTreeItemType;
    function GetSelectedNote: TNoteItem;
    function GetSelectedNotebook: TNotebookItem;
    function GetItemType(const Node: PVirtualNode): TNotesTreeItemType;
    function GetNote(const Node: PVirtualNode): TNoteItem;
    function GetNotebook(const Node: PVirtualNode): TNotebookItem;
  end;

implementation

uses
  EventBus,
  Qollector.Events;

type
  TNotesTreeVisualizer = class(TInterfacedObject, INotesTreeVisualizer)
  private
    FTree: TVirtualStringTree;
    FNotebooks: IList<TNotebookItem>;
    procedure FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure GetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize:
      Integer);
    procedure GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure GetImageIndex(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted:
      Boolean; var ImageIndex: TImageIndex);
    procedure Edited(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex);
    procedure Editing(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure NewText(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex; NewText: string);
    function NotebookNodeOfFocusedNode: PVirtualNode;
  public
    procedure SetVirtualTree(const ATree: TVirtualStringTree);
    procedure SetNotebookItems(const AList: IList<TNotebookItem>);
    procedure UpdateContent;
    function NewNote: TNoteItem;
    function NewNotebook: TNotebookItem;
    function GetSelectedItemType: TNotesTreeItemType;
    function GetSelectedNote: TNoteItem;
    function GetSelectedNotebook: TNotebookItem;
    function GetItemType(const Node: PVirtualNode): TNotesTreeItemType;
    function GetNote(const Node: PVirtualNode): TNoteItem;
    function GetNotebook(const Node: PVirtualNode): TNotebookItem;
  end;

  TNotesTreeItem = record
    ItemType: TNotesTreeItemType;
    Notebook: TNotebookItem;
    Note: TNoteItem;
  end;
  PNotesTreeItem = ^TNotesTreeItem;

{$REGION 'TNotesTreeVisualizer'}

procedure TNotesTreeVisualizer.Edited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PNotesTreeItem;
begin
  Data := FTree.GetNodeData(Node);
  case Data.ItemType of
    itNotebookItem:
      GlobalEventBus.Post(TNotebookEditEvent.Create(Data.Notebook), '', TEventMM.mmAutomatic);
    itNoteItem:
      GlobalEventBus.Post(TNoteEditEvent.Create(Data.Note), '', TEventMM.mmAutomatic);
  end;
end;

procedure TNotesTreeVisualizer.Editing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := true;
end;

procedure TNotesTreeVisualizer.FreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PNotesTreeItem;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure TNotesTreeVisualizer.GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
var
  Data: PNotesTreeItem;
begin
  case Kind of
    ikNormal, ikSelected:
      begin
        Data := FTree.GetNodeData(Node);
        case Data.ItemType of
          itNotebookItem:
            ImageIndex := 0;
          itNoteItem:
            ImageIndex := 1;
          else
            ImageIndex := -1;
        end;
      end;
    else
      ImageIndex := -1;
  end;
end;

function TNotesTreeVisualizer.GetItemType(
  const Node: PVirtualNode): TNotesTreeItemType;
var
  Data: PNotesTreeItem;
begin
  if Node = nil then
    begin
      Result := itNone;
    end
  else
    begin
      Data := FTree.GetNodeData(Node);
      Result := Data.ItemType;
    end;
end;

procedure TNotesTreeVisualizer.GetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TNotesTreeItem);
end;

function TNotesTreeVisualizer.GetNote(const Node: PVirtualNode): TNoteItem;
var
  Data: PNotesTreeItem;
begin
  if Node = nil then
    begin
      Result := nil;
    end
  else
    begin
      Data := FTree.GetNodeData(Node);
      Result := Data.Note;
    end;
end;

function TNotesTreeVisualizer.GetNotebook(
  const Node: PVirtualNode): TNotebookItem;
var
  Data: PNotesTreeItem;
begin
  if Node = nil then
    begin
      Result := nil;
    end
  else
    begin
      Data := FTree.GetNodeData(Node);
      Result := Data.Notebook;
    end;
end;

function TNotesTreeVisualizer.GetSelectedItemType: TNotesTreeItemType;
begin
  Result := GetItemType(FTree.FocusedNode);
end;

function TNotesTreeVisualizer.GetSelectedNote: TNoteItem;
begin
  Result := GetNote(FTree.FocusedNode);
end;

function TNotesTreeVisualizer.GetSelectedNotebook: TNotebookItem;
begin
  Result := GetNotebook(FTree.FocusedNode);
end;

procedure TNotesTreeVisualizer.GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PNotesTreeItem;
begin
  Data := FTree.GetNodeData(Node);
  case Data.ItemType of
    itNotebookItem:
      CellText := Data.Notebook.Caption;
    itNoteItem:
      CellText := Data.Note.Caption;
  end;
end;

function TNotesTreeVisualizer.NewNote: TNoteItem;
var
  Node, ParentNode: PVirtualNode;
  Data, ParentData: PNotesTreeItem;
begin
  Result := nil;
  ParentNode := NotebookNodeOfFocusedNode;
  if ParentNode = nil then
    Exit;

  FTree.BeginUpdate;

  ParentData := FTree.GetNodeData(ParentNode);

  Result := TNoteItem.Create;
  Result.Caption := 'unbenannt';
  Result.NotebookId := ParentData.Notebook.Id;

  Node := FTree.AddChild(ParentNode);
  Data := FTree.GetNodeData(Node);
  Data.ItemType := itNoteItem;
  Data.Notebook := ParentData.Notebook;
  Data.Note := Result;

  FTree.EndUpdate;

  FTree.FocusedNode := Node;
  FTree.Selected[Node] := true;
  FTree.EditNode(Node, -1);
end;

function TNotesTreeVisualizer.NewNotebook: TNotebookItem;
var
  Node: PVirtualNode;
  Data: PNotesTreeItem;
begin
  FTree.BeginUpdate;

  Result := TNotebookItem.Create;
  Result.Caption := 'unbenannt';

  Node := FTree.AddChild(nil);
  Data := FTree.GetNodeData(Node);
  Data.ItemType := itNotebookItem;
  Data.Notebook := Result;
  Data.Note := nil;

  FTree.EndUpdate;

  FTree.FocusedNode := Node;
  FTree.Selected[Node] := true;
  FTree.EditNode(Node, -1);
end;

procedure TNotesTreeVisualizer.NewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  Database: IQollectorDatabase;
  Data: PNotesTreeItem;
begin
  Database := GlobalContainer.Resolve<IQollectorDatabase>;

  Data := FTree.GetNodeData(Node);
  case Data.ItemType of
    itNotebookItem:
      begin
        Data.Notebook.Caption := NewText;
        Database.GetSession.Save(Data.Notebook);
      end;
    itNoteItem:
      begin
        Data.Note.Caption := NewText;
        Database.GetSession.Save(Data.Note);
      end;
  end;
end;

function TNotesTreeVisualizer.NotebookNodeOfFocusedNode: PVirtualNode;
begin
  Result := FTree.FocusedNode;
  if Result <> nil then
    begin
      if Result.Parent <> FTree.RootNode then
        Result := Result.Parent;
    end;
end;

procedure TNotesTreeVisualizer.SetNotebookItems(const AList: IList<TNotebookItem>);
begin
  FNotebooks := AList;
end;

procedure TNotesTreeVisualizer.SetVirtualTree(const ATree: TVirtualStringTree);
begin
  FTree := ATree;
  FTree.OnFreeNode := FreeNode;
  FTree.OnGetNodeDataSize := GetNodeDataSize;
  FTree.OnGetText := GetText;
  FTree.OnGetImageIndex := GetImageIndex;
  FTree.OnEdited := Edited;
  FTree.OnEditing := Editing;
  FTree.OnNewText := NewText;
end;

procedure TNotesTreeVisualizer.UpdateContent;
var
  Notebook: TNotebookItem;
  Note: TNoteItem;
  NotebookNode, NoteNode: PVirtualNode;
  Notes: IList<TNoteItem>;
  Data: PNotesTreeItem;
begin
  FTree.Clear;

  FTree.BeginUpdate;

  for Notebook in FNotebooks do
    begin
      NotebookNode := FTree.AddChild(nil);
      Data := FTree.GetNodeData(NotebookNode);
      Data.ItemType := itNotebookItem;
      Data.Notebook := Notebook;
      Data.Note := nil;

      Notes := Notebook.Notes;
      for Note in Notes do
        begin
          NoteNode := FTree.AddChild(NotebookNode);
          Data := FTree.GetNodeData(NoteNode);
          Data.ItemType := itNoteItem;
          Data.Notebook := Notebook;
          Data.Note := Note;
        end;
    end;

  FTree.EndUpdate;
  FTree.FullExpand;
end;

{$ENDREGION}

initialization
  GlobalContainer.RegisterType<TNotesTreeVisualizer>.Implements<INotesTreeVisualizer>;
end.
