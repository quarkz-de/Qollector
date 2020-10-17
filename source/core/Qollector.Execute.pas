unit Qollector.Execute;

interface

uses
  Winapi.Windows,
  Winapi.ShellApi,
  Vcl.Forms,
  Qollector.Notes;

type
  TShellExecute = class
  public
    class function Open(const AItem: String): Boolean; overload;
    class function Open(const AItem: TLinkItem): Boolean; overload;
  end;

implementation

{ TShellExecute }

class function TShellExecute.Open(const AItem: TLinkItem): Boolean;
begin
  if AItem <> nil then
    Result := Open(AItem.Filename)
  else
    Result := false;
end;

class function TShellExecute.Open(const AItem: String): Boolean;
begin
  Result := ShellExecute(Application.Handle, 'open', PChar(AItem), nil, nil, SW_SHOWNORMAL) > 32;
end;

end.
