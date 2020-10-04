unit Qollector.Frames;

interface

uses
  Vcl.Forms, Vcl.Controls,
  Qollector.Notes;

type
  TQollectorFrameType = (ftNone, ftNote);

  TQollectorFrame = class(TFrame)
  protected
    procedure LoadValues; virtual;
    procedure SaveValues; virtual;
  public
    destructor Destroy; override;
    procedure SaveData; virtual;
    function IsModified: Boolean; virtual;
  end;

  TQollectorFrameList = class(TObject)
  private
    FParent: TWinControl;
    FFrames: Array[TQollectorFrameType] of TQollectorFrame;
    function GetActiveFrame: TQollectorFrame;
    function CreateNoteFrame: TQollectorFrame;
  public
    constructor Create(const AParent: TWinControl);
    destructor Destroy; override;
    function ShowFrame(const AType: TQollectorFrameType): TQollectorFrame; overload;
    function ShowFrame(const ANote: TNoteItem): TQollectorFrame; overload;
    property ActiveFrame: TQollectorFrame read GetActiveFrame;
  end;

implementation

uses
  Qollector.NoteFrame;

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
begin
  if IsModified then
    SaveValues;
end;

{ TQollectorFrameList }

constructor TQollectorFrameList.Create(const AParent: TWinControl);
begin
  inherited Create;
  FParent := AParent;

  FFrames[ftNone] := nil;
  FFrames[ftNote] := CreateNoteFrame;
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

function TQollectorFrameList.ShowFrame(const AType: TQollectorFrameType): TQollectorFrame;
var
  I: TQollectorFrameType;
  Frame: TQollectorFrame;
begin
  Result := nil;

  for I := Low(TQollectorFrameType) to High(TQollectorFrameType) do
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
    Result := ShowFrame(ftNone)
  else
    Result := ShowFrame(ftNote);

  if (Result <> nil) and (Result is TfrNoteFrame) then
    TfrNoteFrame(Result).Note := ANote;
end;

end.
