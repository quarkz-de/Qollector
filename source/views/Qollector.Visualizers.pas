unit Qollector.Visualizers;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes, System.Math,
  System.Types, System.UITypes,
  Winapi.ActiveX,
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
    function DeleteSelectedItem: Boolean;
    function GetSelectedItemType: TNotesTreeItemType;
    function GetSelectedNote: TNoteItem;
    function GetSelectedNotebook: TNotebookItem;
    function GetSelectedItemName: String;
    function GetItemType(const Node: PVirtualNode): TNotesTreeItemType;
    function GetNote(const Node: PVirtualNode): TNoteItem;
    function GetNotebook(const Node: PVirtualNode): TNotebookItem;
  end;

  ILinkListVisualizer = interface
    ['{462B26E1-7A78-405C-813F-7BB3F1E4B99B}']
    procedure SetVirtualTree(const ATree: TVirtualStringTree);
    procedure SetLinkItems(const AList: IList<TLinkItem>);
    procedure UpdateContent;
    function NewFavoriteItem(const ANote: TNoteItem;
      const AFilename: String): TLinkItem;
    function NewBookmarkItem(const ANote: TNoteItem;
      const AFilename: String): TLinkItem;
    function DeleteSelectedItem: Boolean;
    function GetSelectedItem: TLinkItem;
    function GetSelectedItemName: String;
    function GetItem(const Node: PVirtualNode): TLinkItem;
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
    procedure CompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure DragAllowed(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure DragDrop(Sender: TBaseVirtualTree; Source:
      TObject; DataObject: IDataObject; Formats: TFormatArray; Shift:
      TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure DragOver(Sender: TBaseVirtualTree; Source:
      TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode:
      TDropMode; var Effect: Integer; var Accept: Boolean);
    function NotebookNodeOfFocusedNode: PVirtualNode;
    procedure UpdatePositions(const ARootNode: PVirtualNode);
  public
    procedure SetVirtualTree(const ATree: TVirtualStringTree);
    procedure SetNotebookItems(const AList: IList<TNotebookItem>);
    procedure UpdateContent;
    function NewNote: TNoteItem;
    function NewNotebook: TNotebookItem;
    function DeleteSelectedItem: Boolean;
    function GetSelectedItemType: TNotesTreeItemType;
    function GetSelectedNote: TNoteItem;
    function GetSelectedNotebook: TNotebookItem;
    function GetSelectedItemName: String;
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

  TLinkListVisualizer = class(TInterfacedObject, ILinkListVisualizer)
  private
    FTree: TVirtualStringTree;
    FLinks: IList<TLinkItem>;
    procedure GetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize:
      Integer);
    procedure GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure GetImageIndex(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted:
      Boolean; var ImageIndex: TImageIndex);
    procedure Editing(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure NewText(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex; NewText: string);
    function NewItem(const ANote: TNoteItem;
      const AFilename, AName: String): TLinkItem;
  public
    procedure SetVirtualTree(const ATree: TVirtualStringTree);
    procedure SetLinkItems(const AList: IList<TLinkItem>);
    procedure UpdateContent;
    function NewFavoriteItem(const ANote: TNoteItem;
      const AFilename: String): TLinkItem;
    function NewBookmarkItem(const ANote: TNoteItem;
      const AFilename: String): TLinkItem;
    function DeleteSelectedItem: Boolean;
    function GetSelectedItem: TLinkItem;
    function GetSelectedItemName: String;
    function GetItem(const Node: PVirtualNode): TLinkItem;
  end;

  TLinkListItem = record
    Item: TLinkItem;
  end;
  PLinkListItem = ^TLinkListItem;

const
  colLinkName = 0;
  colLinkTarget = 1;

{ TNotesTreeVisualizer }

procedure TNotesTreeVisualizer.CompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PNotesTreeItem;
begin
  Data1 := FTree.GetNodeData(Node1);
  Data2 := FTree.GetNodeData(Node2);

  case Data1.ItemType of
    itNotebookItem:
      Result := CompareValue(Data1.Notebook.Position, Data2.Notebook.Position);
    itNoteItem:
      Result := CompareValue(Data1.Note.Position, Data2.Note.Position);
  end;
end;

function TNotesTreeVisualizer.DeleteSelectedItem: Boolean;
var
  Data: PNotesTreeItem;
  Node, NextNode: PVirtualNode;
  Database: IQollectorDatabase;
begin
  Result := false;
  Node := FTree.FocusedNode;
  if Node <> nil then
    begin
      NextNode := Node.PrevSibling;
      if NextNode = nil then
        NextNode := Node.NextSibling;
      if NextNode = nil then
        NextNode := Node.Parent;

      Data := FTree.GetNodeData(Node);
      case Data.ItemType of
        itNotebookItem:
          begin
            Database := GlobalContainer.Resolve<IQollectorDatabase>;
            Database.GetSession.Delete(Data.Notebook);
          end;
        itNoteItem:
          begin
            Database := GlobalContainer.Resolve<IQollectorDatabase>;
            Database.GetSession.Delete(Data.Note);
          end;
      end;

      FTree.DeleteNode(Node);

      if NextNode <> nil then
        begin
          FTree.FocusedNode := NextNode;
          FTree.Selected[NextNode] := true;
        end;
    end;
end;

procedure TNotesTreeVisualizer.DragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  Data: PNotesTreeItem;
begin
  Data := Sender.GetNodeData(Node);
  Allowed := Data.ItemType = itNoteItem;
end;

procedure TNotesTreeVisualizer.DragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  SourceNode, TargetNode: PVirtualNode;
  AttachMode: TVTNodeAttachMode;
  Data: PNotesTreeItem;
begin
  SourceNode := Sender.FocusedNode;
  TargetNode := Sender.DropTargetNode;

  if TargetNode <> nil then
    begin
      Data := Sender.GetNodeData(TargetNode);
      case Data.ItemType of
        itNotebookItem:
          begin
            AttachMode := amAddChildLast;
          end;
        itNoteItem:
          begin
            case Mode of
              dmNowhere:
                AttachMode := amNoWhere;
              dmOnNode, dmAbove:
                AttachMode := amInsertBefore;
              dmBelow:
                AttachMode := amInsertAfter;
              else
                AttachMode := amNoWhere;
            end;
          end;
        else
          begin
            AttachMode := amNoWhere;
          end;
      end;

      if AttachMode <> amNoWhere then
        begin
          Sender.MoveTo(SourceNode, TargetNode, AttachMode, false);
          UpdatePositions(TargetNode.Parent);
        end;
    end;
end;

procedure TNotesTreeVisualizer.DragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  SourceNode, TargetNode: PVirtualNode;
begin
  Accept := false;
  if (Source = Sender) then
    begin
      SourceNode := Sender.FocusedNode;
      TargetNode := Sender.DropTargetNode;
      if (SourceNode <> nil) and (TargetNode <> nil) then
        Accept := (SourceNode.Parent = TargetNode.Parent);
    end;
end;

procedure TNotesTreeVisualizer.Edited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PNotesTreeItem;
begin
  Data := FTree.GetNodeData(Node);
  case Data.ItemType of
    itNotebookItem:
      GlobalEventBus.Post(TEventFactory.NewNotebookEditEvent(Data.Notebook));
    itNoteItem:
      GlobalEventBus.Post(TEventFactory.NewNoteEditEvent(Data.Note));
  end;
end;

procedure TNotesTreeVisualizer.Editing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := true;
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

function TNotesTreeVisualizer.GetSelectedItemName: String;
var
  Data: PNotesTreeItem;
begin
  Result := '';
  if FTree.FocusedNode = nil then
    Exit;
  Data := FTree.GetNodeData(FTree.FocusedNode);

  case Data.ItemType of
    itNotebookItem:
      Result := Data.Notebook.Name;
    itNoteItem:
      Result := Data.Note.Name;
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
      CellText := Data.Notebook.Name;
    itNoteItem:
      CellText := Data.Note.Name;
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
  Result.Name := 'unbenannt';
  Result.NotebookId := ParentData.Notebook.Id;
  ParentData.Notebook.Notes.Value.Add(Result);

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
  Result.Name := 'unbenannt';
  FNotebooks.Add(Result);

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
        Data.Notebook.Name := NewText;
        Database.GetSession.Save(Data.Notebook);
      end;
    itNoteItem:
      begin
        Data.Note.Name := NewText;
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
  FTree.OnGetNodeDataSize := GetNodeDataSize;
  FTree.OnGetText := GetText;
  FTree.OnGetImageIndex := GetImageIndex;
  FTree.OnEdited := Edited;
  FTree.OnEditing := Editing;
  FTree.OnNewText := NewText;
  FTree.OnCompareNodes := CompareNodes;
  FTree.OnDragAllowed := DragAllowed;
  FTree.OnDragDrop := DragDrop;
  FTree.OnDragOver := DragOver;
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

  FTree.SortTree(0, sdAscending);
  FTree.EndUpdate;
  FTree.FullExpand;
end;

procedure TNotesTreeVisualizer.UpdatePositions(const ARootNode: PVirtualNode);
var
  Node: PVirtualNode;
  Data: PNotesTreeItem;
  Position: Integer;
  Database: IQollectorDatabase;
begin
  Node := FTree.GetFirstChild(ARootNode);
  Position := 1;
  Database := GlobalContainer.Resolve<IQollectorDatabase>;
  while Node <> nil do
    begin
      Data := FTree.GetNodeData(Node);
      Data.Note.Position := Position;
      Database.GetSession.Save(Data.Note);
      Node := Node.NextSibling;
      Inc(Position);
    end;
end;

{ TLinkListVisualizer }

function TLinkListVisualizer.DeleteSelectedItem: Boolean;
var
  Data: PLinkListItem;
  Node, NextNode: PVirtualNode;
  Database: IQollectorDatabase;
begin
  Result := false;
  Node := FTree.FocusedNode;
  if Node <> nil then
    begin
      NextNode := Node.PrevSibling;
      if NextNode = nil then
        NextNode := Node.NextSibling;
      if NextNode = nil then
        NextNode := Node.Parent;

      Data := FTree.GetNodeData(Node);
      Database := GlobalContainer.Resolve<IQollectorDatabase>;
      Database.GetSession.Delete(Data.Item);

      FTree.DeleteNode(Node);
      FLinks.Delete(FLinks.IndexOf(Data.Item));

      if NextNode <> nil then
        begin
          FTree.FocusedNode := NextNode;
          FTree.Selected[NextNode] := true;
        end;
    end;
end;

procedure TLinkListVisualizer.Editing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := true; //Column = colLinkName;
end;

procedure TLinkListVisualizer.GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
var
  Data: PLinkListItem;
begin
  if (Kind in [ikNormal, ikSelected]) and (Column = colLinkName) then
    begin
      Data := FTree.GetNodeData(Node);
      case Data.Item.ItemType of
        litUnknown:
          ImageIndex := -1;
        litBookmark:
          ImageIndex := 3;
        litFavoriteFile:
          ImageIndex := 2;
      end;
    end
  else
    ImageIndex := -1;
end;

function TLinkListVisualizer.GetItem(const Node: PVirtualNode): TLinkItem;
var
  Data: PLinkListItem;
begin
  if Assigned(Node) then
    begin
      Data := FTree.GetNodeData(Node);
      Result := Data.Item;
    end
  else
    Result := nil;
end;

procedure TLinkListVisualizer.GetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TLinkListItem);
end;

function TLinkListVisualizer.GetSelectedItem: TLinkItem;
begin
  Result := GetItem(FTree.FocusedNode);
end;

function TLinkListVisualizer.GetSelectedItemName: String;
var
  Data: PLinkListItem;
begin
  Result := '';
  if FTree.FocusedNode = nil then
    Exit;
  Data := FTree.GetNodeData(FTree.FocusedNode);
  Result := Data.Item.Name;
end;

procedure TLinkListVisualizer.GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PLinkListItem;
begin
  Data := Sender.GetNodeData(Node);

  case Column of
    colLinkName:
      CellText := Data.Item.Name;
    colLinkTarget:
      CellText := Data.Item.Filename;
  end;
end;

function TLinkListVisualizer.NewBookmarkItem(const ANote: TNoteItem;
  const AFilename: String): TLinkItem;
begin
  Result := NewItem(ANote, AFilename, 'Lesezeichen');
end;

function TLinkListVisualizer.NewFavoriteItem(const ANote: TNoteItem;
  const AFilename: String): TLinkItem;
begin
  Result := NewItem(ANote, AFilename, ExtractFilename(AFilename));
end;

function TLinkListVisualizer.NewItem(const ANote: TNoteItem; const AFilename,
  AName: String): TLinkItem;
var
  Node: PVirtualNode;
  Data: PLinkListItem;
  Database: IQollectorDatabase;
begin
  FTree.BeginUpdate;

  Result := TLinkItem.Create;
  Result.Name := AName;
  Result.Filename := AFilename;
  Result.NoteId := ANote.Id;

  Database := GlobalContainer.Resolve<IQollectorDatabase>;
  Database.GetSession.Save(Result);

  FLinks.Add(Result);

  Node := FTree.AddChild(nil);
  Data := FTree.GetNodeData(Node);
  Data.Item := Result;

  FTree.EndUpdate;

  FTree.FocusedNode := Node;
  FTree.Selected[Node] := true;
  FTree.EditNode(Node, 0);
end;

procedure TLinkListVisualizer.NewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  Data: PLinkListItem;
  Database: IQollectorDatabase;
begin
  Database := GlobalContainer.Resolve<IQollectorDatabase>;
  Data := Sender.GetNodeData(Node);

  case Column of
    colLinkName:
      begin
        Data.Item.Name := NewText;
        Database.GetSession.Save(Data.Item);
      end;
    colLinkTarget:
      begin
        Data.Item.Filename := NewText;
        Database.GetSession.Save(Data.Item);
      end;
  end;
end;

procedure TLinkListVisualizer.SetLinkItems(const AList: IList<TLinkItem>);
begin
  FLinks := AList;
end;

procedure TLinkListVisualizer.SetVirtualTree(const ATree: TVirtualStringTree);
begin
  FTree := ATree;
  FTree.OnGetNodeDataSize := GetNodeDataSize;
  FTree.OnGetText := GetText;
  FTree.OnGetImageIndex := GetImageIndex;
  FTree.OnEditing := Editing;
  FTree.OnNewText := NewText;
end;

procedure TLinkListVisualizer.UpdateContent;
var
  Item: TLinkItem;
  Node: PVirtualNode;
  Data: PLinkListItem;
begin
  FTree.Clear;

  FTree.BeginUpdate;

  for Item in FLinks do
    begin
      Node := FTree.AddChild(nil);
      Data := FTree.GetNodeData(Node);
      Data.Item := Item;
    end;

  FTree.EndUpdate;
end;

initialization
  GlobalContainer.RegisterType<TNotesTreeVisualizer>.Implements<INotesTreeVisualizer>;
  GlobalContainer.RegisterType<TLinkListVisualizer>.Implements<ILinkListVisualizer>;
end.
