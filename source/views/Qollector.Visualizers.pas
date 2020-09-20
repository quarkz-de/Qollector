unit Qollector.Visualizers;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes,
  Spring.Collections, Spring.Container,
  VirtualTrees,
  Qollector.Notes;

type
  INotesTreeVisualizer = interface
    ['{E19DF1AA-DE43-4B86-9B98-3AB754881DE6}']
    procedure SetVirtualTree(const ATree: TVirtualStringTree);
    procedure SetNotebookItems(const AList: IList<TNotebookItem>);
    procedure UpdateContent;
  end;

implementation

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
  public
    procedure SetVirtualTree(const ATree: TVirtualStringTree);
    procedure SetNotebookItems(const AList: IList<TNotebookItem>);
    procedure UpdateContent;
  end;

  TNotesTreeItemType = (itNotebookItem, itNoteItem);

  TNotesTreeItem = record
    ItemType: TNotesTreeItemType;
    Notebook: TNotebookItem;
    Note: TNoteItem;
  end;
  PNotesTreeItem = ^TNotesTreeItem;

{$REGION 'TNotesTreeVisualizer'}

procedure TNotesTreeVisualizer.FreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PNotesTreeItem;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure TNotesTreeVisualizer.GetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TNotesTreeItem);
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
