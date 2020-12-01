unit Qollector.Frames;

interface

uses
  System.Generics.Collections, System.Generics.Defaults,
  Vcl.Forms, Vcl.Controls;

type
  TQollectorFrame = class(TFrame)
  public
    procedure Activate; virtual;
    procedure Deactivate; virtual;
  end;

  TQollectorFrameType = (qftWelcome, qftNotes);

  TQollectorFrameList = class(TObject)
  private
    FParent: TWinControl;
    FFrames: array[TQollectorFrameType] of TQollectorFrame;
    function GetActiveFrame: TQollectorFrame;
    procedure CreateFrames;
  public
    constructor Create(const AParent: TWinControl);
    procedure ShowFrame(const AFrame: TQollectorFrameType);
    property ActiveFrame: TQollectorFrame read GetActiveFrame;
  end;

implementation

uses
  Qollector.WelcomeFrame, Qollector.NoteFrame;

{ TQollectorFrameList }

constructor TQollectorFrameList.Create(const AParent: TWinControl);
begin
  inherited Create;
  FParent := AParent;
  CreateFrames;
end;

procedure TQollectorFrameList.CreateFrames;
begin
  FFrames[qftWelcome] := TfrWelcomeFrame.Create(FParent);
  FFrames[qftNotes] := TfrNoteFrame.Create(FParent);
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

procedure TQollectorFrameList.ShowFrame(const AFrame: TQollectorFrameType);
var
  Frame: TQollectorFrame;
  FrameType: TQollectorFrameType;
begin
  for FrameType := Low(TQollectorFrameType) to High(TQollectorFrameType) do
    begin
      Frame := FFrames[FrameType];
      if (FrameType = AFrame) then
        begin
          Frame.Parent := FParent;
          Frame.Align := alClient;
          Frame.Visible := true;
          Frame.Activate;
        end
      else
        begin
          Frame.Deactivate;
          Frame.Visible := false;
          Frame.Parent := nil;
        end;
    end;
end;

{ TQollectorFrame }

procedure TQollectorFrame.Activate;
begin

end;

procedure TQollectorFrame.Deactivate;
begin

end;

end.
