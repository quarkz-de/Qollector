unit Qollector.Frames;

interface

uses
  Vcl.Forms,
  Qollector.Notes;

type
  TQollectorFrame = class(TFrame)
  private
    FNote: TNoteItem;
  protected
    procedure SetNote(const AValue: TNoteItem); virtual;
    procedure SaveValues; virtual;
    procedure LoadValues; virtual;
  public
    destructor Destroy; override;
    property Note: TNoteItem read FNote write SetNote;
    procedure SaveData; virtual;
    function IsModified: Boolean; virtual;
  end;

implementation

uses
  Spring.Container,
  Qollector.Database;

{ TQollectorFrame }

procedure TQollectorFrame.SaveValues;
begin

end;

destructor TQollectorFrame.Destroy;
begin
  SaveData;
  inherited Destroy;
end;

function TQollectorFrame.IsModified: Boolean;
begin
  Result := false;
end;

procedure TQollectorFrame.LoadValues;
begin

end;

procedure TQollectorFrame.SaveData;
var
  Database: IQollectorDatabase;
begin
  if Note = nil then
    Exit;

  if IsModified then
    begin
      SaveValues;
      Database := GlobalContainer.Resolve<IQollectorDatabase>;
      Database.GetSession.Save(Note);
    end;
end;

procedure TQollectorFrame.SetNote(const AValue: TNoteItem);
begin
  FNote := AValue;
  LoadValues;
end;

end.
