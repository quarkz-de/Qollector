unit Qollector.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.CategoryButtons, Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.ActnList,
  Vcl.StdActns, Vcl.Clipbrd,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.TitleBarCtrls,
  VirtualTrees,
  Eventbus,
  Qollector.Visualizers, Qollector.Events, Qollector.Frames;

type
  TwMain = class(TForm)
    amActions: TActionManager;
    acHelpAbout: TAction;
    acFileExit: TFileExit;
    acFileOpen: TFileOpen;
    acSettings: TAction;
    tbpTitleBar: TTitleBarPanel;
    mbMain: TActionMainMenuBar;
    procedure FormDestroy(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure acSettingsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mbMainPaint(Sender: TObject);
  private
    FFrames: TQollectorFrameList;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WmSize(var Message: TWMSize); message WM_SIZE;
  protected
    property Frames: TQollectorFrameList read FFrames;
  public
    [Subscribe(TThreadMode.Main)]
    procedure OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
    [Subscribe(TThreadMode.Main)]
    procedure OnThemeChange(AEvent: TThemeChangeEvent);
  end;

var
  wMain: TwMain;

implementation

{$R *.dfm}

uses
  Spring.Container, Spring.Collections,
  Qollector.DataModule, Qollector.Notes, Qollector.About,
  Qollector.SettingsDialog, Qollector.Execute;

procedure TwMain.acHelpAboutExecute(Sender: TObject);
begin
  TwAbout.ExecuteDialog;
end;

procedure TwMain.acSettingsExecute(Sender: TObject);
begin
  TwSettingsDialog.ExecuteDialog;
end;

procedure TwMain.FormCreate(Sender: TObject);
begin
  FFrames := TQollectorFrameList.Create(self);
  GlobalEventBus.RegisterSubscriberForEvents(Self);
  dmCommon.MainFormCreated;
  dmCommon.LoadDatabase('');
end;

procedure TwMain.FormDestroy(Sender: TObject);
begin
  FFrames.Free;
end;

procedure TwMain.mbMainPaint(Sender: TObject);
var
  Color: TColor;
begin
  if CustomTitleBar.Enabled and not CustomTitleBar.SystemColors then
    begin
      if Active then
        Color := CustomTitleBar.BackgroundColor
      else
        Color := CustomTitleBar.InactiveBackgroundColor;
      mbMain.Canvas.Brush.Color := Color;
      mbMain.Canvas.FillRect(mbMain.ClientRect);
    end;
end;

procedure TwMain.OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
begin
//  Caption := 'Qollector - ' + ExtractFilename(AEvent.Filename);
  Frames.ShowFrame(Frames.NoteFrame);
end;

procedure TwMain.OnThemeChange(AEvent: TThemeChangeEvent);
begin
  CustomTitleBar.SystemColors := AEvent.ThemeName = 'Windows';
  mbMain.Invalidate;
end;

procedure TwMain.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if CustomTitleBar.Enabled and Assigned(mbMain) then
    mbMain.Invalidate;
end;

procedure TwMain.WmSize(var Message: TWMSize);
begin
  inherited;
  if Assigned(mbMain) then
    begin
      case Message.SizeType of
        SIZE_MAXIMIZED:
          mbMain.Top := 0;
        SIZE_RESTORED:
          mbMain.Top := (CustomTitleBar.Height - mbMain.Height) div 2;
      end;
    end;
end;

end.
