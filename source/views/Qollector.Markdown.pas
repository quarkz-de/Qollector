unit Qollector.Markdown;

interface

uses
  System.SysUtils, System.StrUtils, System.RegularExpressions, System.Math,
  SynEdit, SynEditTypes, SynEditKeyCmds;

type
  TMarkdownItemType = (mitText, mitHeading, mitUnorderedList, mitOrderedList,
    mitQuote, mitTable);

  TMarkdownFormatStyle = (mfsBold, mfsItalic, mfsStrikethrough,
    mfsHeading1, mfsHeading2, mfsHeading3, mfsHeading4,
    mfsUnorderedList, mfsOrderedList,
    mfsQuote, mfsCode);

  TMarkdownEditHelper = class
  private
    FEditor: TSynEdit;
    FInheritedCommandProcessed: TProcessCommandEvent;
    procedure CommandProcessed(Sender: TObject; var Command:
      TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure CopyLastLinePrefix(const APrefix: String);
    procedure ExecuteLineBreak;
    procedure ExecuteBackSpace;
    procedure AttachEditor;
    procedure DetachEditor;
    function GetMarkdownType: TMarkdownItemType;
    function GetCurrentLineIndex: Integer;
    function GetPrevLineIndex: Integer;
    procedure FormatOrderedList;
    function IsOrderedList: Boolean; overload;
    function IsOrderedList(out AStartLine, AEndLine: Integer): Boolean; overload;
  public
    constructor Create(const AEditor: TSynEdit);
    destructor Destroy; override;
    procedure FormatText(const AFormatStyle: TMarkdownFormatStyle);
  end;

implementation

{ TMarkdownEditHelper }

procedure TMarkdownEditHelper.AttachEditor;
begin
  FInheritedCommandProcessed := FEditor.OnCommandProcessed;
  FEditor.OnCommandProcessed := CommandProcessed;
end;

procedure TMarkdownEditHelper.CommandProcessed(Sender: TObject;
  var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
begin
  if Assigned(FInheritedCommandProcessed) then
    FInheritedCommandProcessed(Sender, Command, AChar, Data);

  case Command of
    ecLineBreak:
      ExecuteLineBreak;
    ecDeleteLastChar:
      ExecuteBackSpace;
//    ecTab:
  end;
end;

procedure TMarkdownEditHelper.CopyLastLinePrefix(const APrefix: String);
var
  LineIndex: Integer;
begin
  LineIndex := FEditor.CaretY - 2;
  if LineIndex >= 0 then
    begin
      if (APrefix = FEditor.Lines[LineIndex]) then
        FEditor.Lines[LineIndex] := ''
      else if StartsText(APrefix, FEditor.Lines[LineIndex]) then
        FEditor.SelText := APrefix;
    end;
end;

constructor TMarkdownEditHelper.Create(const AEditor: TSynEdit);
begin
  inherited Create;
  FEditor := AEditor;
  AttachEditor;
end;

destructor TMarkdownEditHelper.Destroy;
begin
  DetachEditor;
  inherited;
end;

procedure TMarkdownEditHelper.DetachEditor;
begin
  FEditor.OnCommandProcessed := FInheritedCommandProcessed;
end;

procedure TMarkdownEditHelper.ExecuteBackSpace;
var
  Line: String;
begin
  Line := FEditor.Lines[GetCurrentLineIndex];
  if (Length(Line) = 1) and CharInSet(Line[1], ['*', '-', '>', '#', '|']) then
    FEditor.ExecuteCommand(ecDeleteLastChar, #0, nil);
end;

procedure TMarkdownEditHelper.ExecuteLineBreak;
begin
  case GetMarkdownType of
    mitUnorderedList:
      begin
        CopyLastLinePrefix('* ');
        CopyLastLinePrefix('- ');
      end;
    mitQuote:
      CopyLastLinePrefix('> ');
    mitOrderedList:
      FormatOrderedList;
    mitTable:
      ;
  end;
end;

procedure TMarkdownEditHelper.FormatOrderedList;

  function IsNotEmptyLine(const ALine, ACurrent: Integer): Boolean;
  begin
    Result := (ALine = ACurrent) or (FEditor.Lines[ALine] <> '');
  end;

var
  CurrentLine, StartLine, Endline, Topic, I, DotPos: Integer;
  Line, Prefix: String;
  CurrentIsEmpty, ChangePrefix: Boolean;
begin
  if not IsOrderedList(StartLine, EndLine) then
    Exit;

  CurrentLine := GetCurrentLineIndex;
  Topic := 1;

  for I := StartLine to EndLine do
    begin
      Line := FEditor.Lines[I];

      CurrentIsEmpty := (I = CurrentLine) and (Line = '');
      ChangePrefix := TRegEx.IsMatch(Line, '\d.');

      if CurrentIsEmpty or ChangePrefix then
        begin
          if ChangePrefix then
            begin
              DotPos := Pos('.', Line);
              Delete(Line, 1, DotPos + 1);
            end;

          Prefix := IntToStr(Topic) + '. ';

          if CurrentIsEmpty then
            FEditor.SelText := Prefix
          else
            FEditor.Lines[I] := Prefix + Line;

          Inc(Topic);
        end;
    end;
end;

procedure TMarkdownEditHelper.FormatText(
  const AFormatStyle: TMarkdownFormatStyle);

  procedure FormatSelection(const AFormatString: String);
  begin
    FEditor.SelText := Format(AFormatString, [FEditor.SelText]);
  end;

  procedure FormatHeading(const ALevel: Integer);
  var
    Index: Integer;
    Line: String;
  begin
    Index := GetCurrentLineIndex;
    Line := FEditor.Lines[Index];
    while Copy(Line, 1, 1) = '#' do
      Delete(Line, 1, 1);
    if Copy(Line, 1, 1) = ' ' then
      Delete(Line, 1, 1);
    FEditor.Lines[Index] := DupeString('#', ALevel) + ' ' + Line;
  end;

var
  FormatString: String;
begin
  case AFormatStyle of
    mfsBold:
      FormatSelection('**%s**');
    mfsItalic:
      FormatSelection('*%s*');
    mfsStrikethrough:
      FormatSelection('~~%s~~');
    mfsHeading1:
      FormatHeading(1);
    mfsHeading2:
      FormatHeading(2);
    mfsHeading3:
      FormatHeading(3);
    mfsHeading4:
      FormatHeading(4);
//    mfsUnorderedList:
//    mfsOrderedList:
//    mfsQuote:
//    mfsCode:
  end;
end;

function TMarkdownEditHelper.GetCurrentLineIndex: Integer;
begin
  Result := Max(0, FEditor.CaretY - 1);
end;

function TMarkdownEditHelper.GetMarkdownType: TMarkdownItemType;
var
  Line: String;
begin
  Result := mitText;

  if FEditor.Lines.Count = 0 then
    Exit;

//  Line := FEditor.Lines[GetCurrentLineIndex];
//  if (Line = '') then
    Line := FEditor.Lines[GetPrevLineIndex];

  if StartsText('* ', Line) or StartsText('- ', Line) then
    Result := mitUnorderedList
  else if StartsText('> ', Line) then
    Result := mitQuote
  else if StartsText('| ', Line) then
    Result := mitTable
  else if IsOrderedList then
    Result := mitOrderedList;
end;

function TMarkdownEditHelper.GetPrevLineIndex: Integer;
begin
  Result := Max(0, GetCurrentLineIndex - 1);
end;

function TMarkdownEditHelper.IsOrderedList: Boolean;
var
  StartLine, EndLine: Integer;
begin
  Result := IsOrderedList(StartLine, EndLine);
end;

function TMarkdownEditHelper.IsOrderedList(out AStartLine,
  AEndLine: Integer): Boolean;

  function IsNotEmptyLine(const ALine, ACurrent: Integer): Boolean;
  begin
    Result := (ALine = ACurrent) or TRegEx.IsMatch(FEditor.Lines[ALine], '\d.');
  end;

var
  CurrentLine, StartLine, EndLine: Integer;
begin
  CurrentLine := GetCurrentLineIndex;
  StartLine := CurrentLine;
  EndLine := CurrentLine;

  while (StartLine > 1) and IsNotEmptyLine(StartLine - 1, CurrentLine) do
    Dec(StartLine);

  while (EndLine < FEditor.Lines.Count - 1) and IsNotEmptyLine(StartLine + 1, CurrentLine) do
    Inc(EndLine);

  Result := (StartLine < CurrentLine) or (EndLine > CurrentLine);
  if Result then
    begin
      AStartLine := StartLine;
      AEndLine := EndLine;
    end;
end;

end.
