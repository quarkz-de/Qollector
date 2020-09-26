unit Qollector.Events;

interface

uses
  EventBus,
  Qollector.Notes;

type
  TDatabaseLoadEvent = class(TObject)
  private
    FFilename: String;
    procedure SetFilename(const Value: String);
  public
    constructor Create(const AFilename: String);
    property Filename: String read FFilename write SetFilename;
  end;

  TNotebookEditEvent = class(TObject)
  private
    FNotebook: TNotebookItem;
  public
    constructor Create(const ANotebook: TNotebookItem);
    property Notebook: TNotebookItem read FNotebook write FNotebook;
  end;

  TNoteEditEvent = class(TObject)
  private
    FNote: TNoteItem;
  public
    constructor Create(const ANote: TNoteItem);
    property Note: TNoteItem read FNote write FNote;
  end;

implementation

{ TDatabaseLoadEvent }

constructor TDatabaseLoadEvent.Create(const AFilename: String);
begin
  inherited Create;
  Filename := AFilename;
end;

procedure TDatabaseLoadEvent.SetFilename(const Value: String);
begin
  FFilename := Value;
end;

{ TNotebookEditEvent }

constructor TNotebookEditEvent.Create(const ANotebook: TNotebookItem);
begin
  inherited Create;
  FNotebook := ANotebook;
end;

{ TNoteEditEvent }

constructor TNoteEditEvent.Create(const ANote: TNoteItem);
begin
  inherited Create;
  FNote := ANote;
end;

end.
