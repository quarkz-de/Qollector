unit Qollector.Events;

interface

uses
  EventBus;

type
  TDatabaseLoadEvent = class(TObject)
  private
    FFilename: String;
    procedure SetFilename(const Value: String);
  public
    constructor Create(const AFilename: String);
    property Filename: String read FFilename write SetFilename;
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

end.
