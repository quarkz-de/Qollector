unit Qollector.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.CategoryButtons, Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.ActnList,
  Vcl.StdActns,
  Qollector.Bereiche;

type
  TwMain = class(TForm)
    mmMenu: TMainMenu;
    svBereiche: TSplitView;
    catBereiche: TCategoryButtons;
    alActions: TActionList;
    acBereichNotizen: TAction;
    acBereichFavoriten: TAction;
    acBereichLesezeichen: TAction;
    acFileExit: TFileExit;
    miFile: TMenuItem;
    miFileExit: TMenuItem;
    acFileOpen: TFileOpen;
    N1: TMenuItem;
    miFileOpen: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure svBereicheResize(Sender: TObject);
  private
    FBereich: TDatenbereich;
    function GetBereich: TDatenbereich;
    procedure SetBereich(const Value: TDatenbereich);
  public
    property Bereich: TDatenbereich read GetBereich write SetBereich;
  end;

var
  wMain: TwMain;

implementation

{$R *.dfm}

uses
  Qollector.DataModule;

procedure TwMain.FormCreate(Sender: TObject);
begin
  Caption := 'Qollector - ' + dmCommon.Database.Filename;
  Bereich := dbNotizen;
end;

function TwMain.GetBereich: TDatenbereich;
begin
  Result := FBereich;
end;

procedure TwMain.SetBereich(const Value: TDatenbereich);
begin
  FBereich := Value;
  case FBereich of
    dbKein:
      catBereiche.SelectedItem := nil;
    dbNotizen:
      catBereiche.SelectedItem := catBereiche.Categories[0].Items[0];
    dbLesezeichen:
      catBereiche.SelectedItem := catBereiche.Categories[0].Items[1];
    dbFavoriten:
      catBereiche.SelectedItem := catBereiche.Categories[0].Items[2];
  end;
end;

procedure TwMain.svBereicheResize(Sender: TObject);
begin
  catBereiche.Width := svBereiche.Width;
  catBereiche.Height := svBereiche.Height + (catBereiche.Top * -1);
end;

end.
