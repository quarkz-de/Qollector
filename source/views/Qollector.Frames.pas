unit Qollector.Frames;

interface

uses
  Vcl.Forms, Vcl.Controls,
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

  TQollectorFrameList = class(TObject)
  private
    FParent: TWinControl;
    FFrames: Array[TNoteItemType] of TQollectorFrame;
    function GetActiveFrame: TQollectorFrame;
    function CreateNoteFrame: TQollectorFrame;
  public
    constructor Create(const AParent: TWinControl);
    destructor Destroy; override;
    function ShowFrame(const AType: TNoteItemType): TQollectorFrame; overload;
    function ShowFrame(const ANote: TNoteItem): TQollectorFrame; overload;
    property ActiveFrame: TQollectorFrame read GetActiveFrame;
  end;

implementation

uses
  Spring.Container,
  Qollector.Database, Qollector.NoteFrame;

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

{ TQollectorFrameList }

constructor TQollectorFrameList.Create(const AParent: TWinControl);
begin
  inherited Create;
  FParent := AParent;

  FFrames[tnUnknown] := nil;
  FFrames[tnNote] := CreateNoteFrame;
  FFrames[tnLink] := nil;
  FFrames[tnBookmark] := nil;
  FFrames[tnTodo] := nil;
end;

function TQollectorFrameList.CreateNoteFrame: TQollectorFrame;
begin
  Result := TfrNoteFrame.Create(nil);
  Result.Visible := false;
end;

destructor TQollectorFrameList.Destroy;
var
  Frame: TQollectorFrame;
begin
  for Frame in FFrames do
    if Frame <> nil then
      Frame.Free;
  inherited;
end;

function TQollectorFrameList.GetActiveFrame: TQollectorFrame;
var
  Frame: TQollectorFrame;
begin
  Result := nil;
  for Frame in FFrames do
    if (Frame <> nil) and (Frame.Visible) then
      begin
        Result := Frame;
        Break;
      end;
end;

function TQollectorFrameList.ShowFrame(const AType: TNoteItemType): TQollectorFrame;
var
  I: TNoteItemType;
  Frame: TQollectorFrame;
begin
  Result := nil;

  for I := Low(TNoteItemType) to High(TNoteItemType) do
    begin
      Frame := FFrames[I];
      if (Frame <> nil) then
        begin
          if (I = AType) then
            begin
              Frame.Parent := FParent;
              Frame.Align := alClient;
              Frame.Visible := true;
              Result := Frame;
            end
          else
            begin
              Frame.Visible := false;
              Frame.Parent := nil;
            end;
        end;
    end;
end;

function TQollectorFrameList.ShowFrame(const ANote: TNoteItem): TQollectorFrame;
begin
  if ANote = nil then
    Result := ShowFrame(tnUnknown)
  else
    Result := ShowFrame(ANote.NoteType);

  if (Result <> nil) then
    Result.Note := ANote;
end;

end.
