unit Qollector.Parameters;

interface

uses
  System.Classes, Winapi.Windows, Winapi.Messages, Vcl.Forms;

const
  WM_PROCESSPARAMETERS = WM_USER + 1;

type
  TParameterSender = class
  private
    class procedure AssignParams(const AStrings: TStrings);
  public
    class procedure Send;
    class procedure Process;
  end;

implementation

uses
  Qollector.Main;

{ TParameterSender }

class procedure TParameterSender.AssignParams(const AStrings: TStrings);
var
  I: Integer;
begin
  AStrings.Clear;
  for I := 1 to ParamCount do
    AStrings.Add(ParamStr(I));
end;

class procedure TParameterSender.Process;
var
  Parameters: TStringList;
begin
  Parameters := TStringList.Create;
  AssignParams(Parameters);
  wQollectorMain.ProcessParameters(Parameters);
  Parameters.Free;
end;

class procedure TParameterSender.Send;
var
  HMainForm: HWND;
  Parameters: TStringList;
  ParamStr: String;
  AtomSend: Integer;
begin
  HMainForm := FindWindowEx(0, 0, 'TwQollectorMain', nil);

  if HMainForm <> 0 then
    begin
      ShowWindow(HMainForm, SW_NORMAL);
      SetForegroundWindow(HMainForm);

      if (ParamCount > 0) then
        begin
          Parameters := TStringList.Create;
          AssignParams(Parameters);
          ParamStr := Parameters.Text;

          AtomSend := GlobalAddAtom(PChar(ParamStr));
          try
            SendMessage(HMainForm, WM_PROCESSPARAMETERS,
              Length(ParamStr), AtomSend);
          finally
            GlobalDeleteAtom(AtomSend);
          end;

          Parameters.Free;
        end;
    end;
end;

end.
