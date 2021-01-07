unit Qollector.Events;

interface

uses
  EventBus,
  Qollector.Notes, Qollector.Visualizers, Qollector.Settings;

type
  IDatabaseLoadEvent = interface
    ['{470BFEAA-A717-4A97-B417-7587616165FA}']
    function GetFilename: String;
    property Filename: String read GetFilename;
  end;

  INotebookEditEvent = interface
    ['{91F5E29A-0547-44E7-BC9B-B904715E3EA1}']
    function GetNotebook: TNotebookItem;
    property Notebook: TNotebookItem read GetNotebook;
  end;

  INoteEditEvent = interface
    ['{B7565739-DB8D-4AA2-BE26-6C0D236785D1}']
    function GetNote: TNoteItem;
    property Note: TNoteItem read GetNote;
  end;

  ISelectItemEvent = interface
    ['{3C9A667A-DC70-4D98-A0D4-0202C6AC1A4B}']
    function GetItemType: TNotesTreeItemType;
    property ItemType: TNotesTreeItemType read GetItemType;
  end;

  IThemeChangeEvent = interface
    ['{CEC869F4-50DE-441F-8C81-BF2C4C2B4C93}']
    function GetThemeName: String;
    function GetIsDark: Boolean;
    property ThemeName: String read GetThemeName;
    property IsDark: Boolean read GetIsDark;
  end;

  ISettingChangeEvent = interface
    ['{474DE67D-B3C4-415B-857C-031FB122408B}']
    function GetValue: TQollectorSettingValue;
    property Value: TQollectorSettingValue read GetValue;
  end;

  TEventFactory = class
  public
    class function NewDatabaseLoadEvent(
      const AFilename: String): IDatabaseLoadEvent;
    class function NewNotebookEditEvent(
      const ANotebook: TNotebookItem): INotebookEditEvent;
    class function NewNoteEditEvent(
      const ANote: TNoteItem): INoteEditEvent;
    class function NewSelectItemEvent(
      const AItemType: TNotesTreeItemType): ISelectItemEvent;
    class function NewThemeChangeEvent(
      const AThemeName: String; const AIsDark: Boolean): IThemeChangeEvent;
    class function NewSettingChangeEvent(
      const AValue: TQollectorSettingValue): ISettingChangeEvent;
  end;

implementation

type
  TDatabaseLoadEvent = class(TInterfacedObject, IDatabaseLoadEvent)
  private
    FFilename: String;
  protected
    function GetFilename: String;
  public
    constructor Create(const AFilename: String);
    property Filename: String read GetFilename;
  end;

  TNotebookEditEvent = class(TInterfacedObject, INotebookEditEvent)
  private
    FNotebook: TNotebookItem;
  protected
    function GetNotebook: TNotebookItem;
  public
    constructor Create(const ANotebook: TNotebookItem);
    property Notebook: TNotebookItem read GetNotebook;
  end;

  TNoteEditEvent = class(TInterfacedObject, INoteEditEvent)
  private
    FNote: TNoteItem;
  protected
    function GetNote: TNoteItem;
  public
    constructor Create(const ANote: TNoteItem);
    property Note: TNoteItem read GetNote;
  end;

  TSelectItemEvent = class(TInterfacedObject, ISelectItemEvent)
  private
    FItemType: TNotesTreeItemType;
  protected
    function GetItemType: TNotesTreeItemType;
  public
    constructor Create(const AItemType: TNotesTreeItemType);
    property ItemType: TNotesTreeItemType read GetItemType;
  end;

  TThemeChangeEvent = class(TInterfacedObject, IThemeChangeEvent)
  private
    FThemeName: String;
    FIsDark: Boolean;
  protected
    function GetThemeName: String;
    function GetIsDark: Boolean;
  public
    constructor Create(const AThemeName: String; const AIsDark: Boolean);
    property ThemeName: String read GetThemeName;
    property IsDark: Boolean read GetIsDark;
  end;

  TSettingChangeEvent = class(TInterfacedObject, ISettingChangeEvent)
  private
    FValue: TQollectorSettingValue;
  protected
    function GetValue: TQollectorSettingValue;
  public
    constructor Create(const AValue: TQollectorSettingValue);
    property Value: TQollectorSettingValue read GetValue;
  end;

{ TDatabaseLoadEvent }

constructor TDatabaseLoadEvent.Create(const AFilename: String);
begin
  inherited Create;
  FFilename := AFilename;
end;

function TDatabaseLoadEvent.GetFilename: String;
begin
  Result := FFilename;
end;

{ TNotebookEditEvent }

constructor TNotebookEditEvent.Create(const ANotebook: TNotebookItem);
begin
  inherited Create;
  FNotebook := ANotebook;
end;

function TNotebookEditEvent.GetNotebook: TNotebookItem;
begin
  Result := FNotebook;
end;

{ TNoteEditEvent }

constructor TNoteEditEvent.Create(const ANote: TNoteItem);
begin
  inherited Create;
  FNote := ANote;
end;

function TNoteEditEvent.GetNote: TNoteItem;
begin
  Result := FNote;
end;

{ TSelectItemEvent }

constructor TSelectItemEvent.Create(const AItemType: TNotesTreeItemType);
begin
  inherited Create;
  FItemType := AItemType;
end;

function TSelectItemEvent.GetItemType: TNotesTreeItemType;
begin
  Result := FItemType;
end;

{ TThemeChangeEvent }

constructor TThemeChangeEvent.Create(const AThemeName: String;
  const AIsDark: Boolean);
begin
  inherited Create;
  FThemeName := AThemeName;
  FIsDark := AIsDark;
end;

function TThemeChangeEvent.GetIsDark: Boolean;
begin
  Result := FIsDark;
end;

function TThemeChangeEvent.GetThemeName: String;
begin
  Result := FThemeName;
end;

{ TSettingChangeEvent }

constructor TSettingChangeEvent.Create(const AValue: TQollectorSettingValue);
begin
  inherited Create;
  FValue := AValue;
end;

function TSettingChangeEvent.GetValue: TQollectorSettingValue;
begin
  Result := FValue;
end;

{ TEventFactory }

class function TEventFactory.NewDatabaseLoadEvent(
  const AFilename: String): IDatabaseLoadEvent;
begin
  Result := TDatabaseLoadEvent.Create(AFilename);
end;

class function TEventFactory.NewNotebookEditEvent(
  const ANotebook: TNotebookItem): INotebookEditEvent;
begin
  Result := TNotebookEditEvent.Create(ANotebook);
end;

class function TEventFactory.NewNoteEditEvent(
  const ANote: TNoteItem): INoteEditEvent;
begin
  Result := TNoteEditEvent.Create(ANote);
end;

class function TEventFactory.NewSelectItemEvent(
  const AItemType: TNotesTreeItemType): ISelectItemEvent;
begin
  Result := TSelectItemEvent.Create(AItemType);
end;

class function TEventFactory.NewSettingChangeEvent(
  const AValue: TQollectorSettingValue): ISettingChangeEvent;
begin
  Result := TSettingChangeEvent.Create(AValue);
end;

class function TEventFactory.NewThemeChangeEvent(const AThemeName: String;
  const AIsDark: Boolean): IThemeChangeEvent;
begin
  Result := TThemeChangeEvent.Create(AThemeName, AIsDark);
end;

end.
