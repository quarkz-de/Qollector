unit Qollector.Execute;

interface

uses
  Qollector.Notes;

type
  TShellExecute = class
  public
    class function Open(const AItem: String): Boolean; overload;
    class function Open(const AItem: TLinkItem): Boolean; overload;
    class function IsUrl(const AValue: String): Boolean;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.ShellApi,
  Vcl.Forms,
  System.RegularExpressions;

{ TShellExecute }

class function TShellExecute.IsUrl(const AValue: String): Boolean;
begin
  Result := TRegEx.IsMatch(AValue, '^(ht|f)tp(s?)\:\/\/[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*(:(0-9)*)*(\/?)([a-zA-Z0-9\-\.\?\,\''\/\\\+&%\$#_]*)?$');
end;

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
