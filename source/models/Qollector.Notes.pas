unit Qollector.Notes;

interface

uses
  System.SysUtils, System.Generics.Collections,
  Spring, Spring.Collections, Spring.Persistence.Mapping.Attributes;

type
  TNotebookItem = class;

  TNoteItemType = (tnNote, tnLink, tnBookmark, tnTodo);

  [Entity]
  [Table('NOTES')]
  TNoteItem = class
  private
    [Column('ID', [cpRequired, cpPrimaryKey])][AutoGenerated]
    FId: Integer;
    [Column('TYPE')]
    FNotetype: Integer;
    FNotebookId: Integer;
    FCaption: String;
    FData: String;
//    FNotebook: TNotebookItem;
    function GetNoteItemType: TNoteItemType;
    procedure SetNoteItemType(const Value: TNoteItemType);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property Id: Integer read FId;

    [Column('NOTEBOOK')]
    [ForeignJoinColumn('NOTEBOOK', 'NOTEBOOKS', 'ID', [fsOnDeleteCascade, fsOnUpdateCascade])]
    property NotebookId: Integer read FNotebookId write FNotebookId;

    [Column('CAPTION')]
    property Caption: String read FCaption write FCaption;

    [Column('DATA')]
    property Data: String read FData write FData;

    property NoteType: TNoteItemType read GetNoteItemType write SetNoteItemType;

//    [ManyToOne(False, [ckCascadeAll], 'NOTEBOOK')]
//    property Notebook: TNotebookItem read FNotebook write FNotebook;

    function ToString: String; override;
  end;

  TLinkItem = class(TNoteItem)
  public
    constructor Create; override;
  end;

  TBookmarkItem = class(TNoteItem)
  public
    constructor Create; override;
  end;

  TTodoItem = class(TNoteItem)
  public
    constructor Create; override;
  end;

  [Entity]
  [Table('NOTEBOOKS')]
  TNotebookItem = class
  private
    [Column('ID', [cpRequired, cpPrimaryKey])][AutoGenerated]
    FId: Integer;
    FCaption: String;
    [OneToMany(False, [ckCascadeAll])]
    FNotes: Lazy<IList<TNoteItem>>;
  public
    constructor Create;

    property Id: Integer read FId write FId;
    [Column('CAPTION')]
    property Caption: String read FCaption write FCaption;

    property Notes: Lazy<IList<TNoteItem>> read FNotes write FNotes;

    function ToString: String; override;
  end;

implementation

type
  TNoteItemTypeConverter = record
  public
    class function ToInteger(const AValue: TNoteItemType): Integer; static;
    class function FromInteger(const AValue: Integer): TNoteItemType; static;
  end;

{$REGION 'TNoteItemTypeConverter'}

class function TNoteItemTypeConverter.FromInteger(const AValue: Integer): TNoteItemType;
begin
  case AValue of
    0:
      Result := tnNote;
    1:
      Result := tnLink;
    2:
      Result := tnBookmark;
    3:
      Result := tnTodo;
    else
      Result := tnNote;
  end;
end;

class function TNoteItemTypeConverter.ToInteger(const AValue: TNoteItemType): Integer;
begin
  case AValue of
    tnNote:
      Result := 0;
    tnLink:
      Result := 1;
    tnBookmark:
      Result := 2;
    tnTodo:
      Result := 3;
    else
      Result := 0;
  end;
end;

{$ENDREGION}

{$REGION 'TNoteItem'}

constructor TNoteItem.Create;
begin
  inherited;
  NoteType := tnNote;
end;

destructor TNoteItem.Destroy;
begin
//  if Assigned(FNotebook) then
//    begin
{$IFDEF AUTOREFCOUNT}
//      FNotebook.DisposeOf;
{$ENDIF}
//      FNotebook.Free;
//    end;
  inherited;
end;

function TNoteItem.GetNoteItemType: TNoteItemType;
begin
  Result := TNoteItemTypeConverter.FromInteger(FNoteType);
end;

procedure TNoteItem.SetNoteItemType(const Value: TNoteItemType);
begin
  FNoteType := TNoteItemTypeConverter.ToInteger(Value);
end;

function TNoteItem.ToString: String;
begin
  Result := Caption;
end;

{$ENDREGION}

{$REGION 'TLinkItem'}

constructor TLinkItem.Create;
begin
  inherited;
  NoteType := tnLink;
end;

{$ENDREGION}

{$REGION 'TBookmarkItem'}

constructor TBookmarkItem.Create;
begin
  inherited;
  NoteType := tnBookmark;
end;

{$ENDREGION}

{$REGION 'TTodoItem'}

constructor TTodoItem.Create;
begin
  inherited;
  NoteType := tnTodo;
end;

{$ENDREGION}

{$REGION 'TNotebookItem'}

constructor TNotebookItem.Create;
begin
  inherited;
  FNotes := TCollections.CreateObjectList<TNoteItem>;
end;

function TNotebookItem.ToString: String;
begin
  Result := Caption;
end;

{$ENDREGION}

end.
