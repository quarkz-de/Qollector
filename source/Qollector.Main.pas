unit Qollector.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.CategoryButtons, Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.ActnList,
  Vcl.StdActns,
  VirtualTrees,
  Eventbus,
  Qollector.Visualizers, Qollector.Events;

type
  TwMain = class(TForm)
    mmMenu: TMainMenu;
    alActions: TActionList;
    acFileExit: TFileExit;
    miFile: TMenuItem;
    miFileExit: TMenuItem;
    acFileOpen: TFileOpen;
    N1: TMenuItem;
    miFileOpen: TMenuItem;
    stNotebooks: TVirtualStringTree;
    spSplitter: TSplitter;
    procedure FormCreate(Sender: TObject);
  private
    FTreeVisualizer: INotesTreeVisualizer;
  public
    [Subscribe(TThreadMode.Main)]
    procedure OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
  end;

var
  wMain: TwMain;

implementation

{$R *.dfm}

uses
  Spring.Container, Spring.Collections,
  Qollector.DataModule, Qollector.Notes;

procedure TwMain.FormCreate(Sender: TObject);
begin
  GlobalEventBus.RegisterSubscriberForEvents(Self);

  FTreeVisualizer := GlobalContainer.Resolve<INotesTreeVisualizer>;
  FTreeVisualizer.SetVirtualTree(stNotebooks);

  dmCommon.LoadDatabase('');
end;

procedure TwMain.OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
var
  Notebooks: IList<TNotebookItem>;
begin
  Caption := 'Qollector - ' + ExtractFilename(AEvent.Filename);

  Notebooks := dmCommon.Database.GetSession.FindAll<TNotebookItem>();
  FTreeVisualizer.SetNotebookItems(Notebooks);
  FTreeVisualizer.UpdateContent;
end;

end.
