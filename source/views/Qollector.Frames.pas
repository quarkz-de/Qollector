unit Qollector.Frames;

interface

uses
  System.Generics.Collections, System.Generics.Defaults,
  Vcl.Forms, Vcl.Controls,
  Qollector.NoteFrame;

type
  TQollectorFrameList = class(TObject)
  private
    FParent: TWinControl;
    FFrames: TObjectList<TFrame>;
    function GetActiveFrame: TFrame;
    function CreateNoteFrame: TFrame;
    function GetNoteFrame: TfrNoteFrame;
  public
    constructor Create(const AParent: TWinControl);
    destructor Destroy; override;
    procedure ShowFrame(const AFrame: TFrame);
    property ActiveFrame: TFrame read GetActiveFrame;
    property NoteFrame: TfrNoteFrame read GetNoteFrame;
  end;

implementation

{ TQollectorFrameList }

constructor TQollectorFrameList.Create(const AParent: TWinControl);
begin
  inherited Create;
  FParent := AParent;
  FFrames := TObjectList<TFrame>.Create;
  FFrames.Add(CreateNoteFrame);
end;

function TQollectorFrameList.CreateNoteFrame: TFrame;
begin
  Result := TfrNoteFrame.Create(nil);
  Result.Visible := false;
end;

destructor TQollectorFrameList.Destroy;
begin
  FFrames.Free;
  inherited;
end;

function TQollectorFrameList.GetActiveFrame: TFrame;
var
  Frame: TFrame;
begin
  Result := nil;
  for Frame in FFrames do
    if (Frame <> nil) and (Frame.Visible) then
      begin
        Result := Frame;
        Break;
      end;
end;

function TQollectorFrameList.GetNoteFrame: TfrNoteFrame;
var
  Frame: TFrame;
begin
  Result := nil;
  for Frame in FFrames do
    if Frame is TfrNoteFrame then
      begin
        Result := TfrNoteFrame(Frame);
        Break;
      end;
end;

procedure TQollectorFrameList.ShowFrame(const AFrame: TFrame);
var
  Frame: TFrame;
begin
  for Frame in FFrames do
    begin
      if (Frame = AFrame) then
        begin
          Frame.Parent := FParent;
          Frame.Align := alClient;
          Frame.Visible := true;
        end
      else
        begin
          Frame.Visible := false;
          Frame.Parent := nil;
        end;
    end;
end;


//    TfrNoteFrame(Result).Note := ANote;

end.
