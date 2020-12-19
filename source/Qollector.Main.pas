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
  Qollector.Visualizers, Qollector.Events, Qollector.Forms, Vcl.VirtualImage,
  Vcl.StdCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.AppEvnts;

type
  TwMain = class(TForm)
    amActions: TActionManager;
    acHelpAbout: TAction;
    acFileExit: TFileExit;
    acFileOpen: TFileOpen;
    acSettings: TAction;
    tbpTitleBar: TTitleBarPanel;
    mbMain: TActionMainMenuBar;
    svSplitView: TSplitView;
    pnHeader: TPanel;
    imBurgerButton: TVirtualImage;
    pnNavigation: TPanel;
    txHeaderText: TLabel;
    sbStart: TSpeedButton;
    sbNotes: TSpeedButton;
    txVersion: TLabel;
    acSectionWelcome: TAction;
    acSectionNotes: TAction;
    vilIcons: TVirtualImageList;
    vilLargeIcons: TVirtualImageList;
    tiTrayIcon: TTrayIcon;
    aeApplicationEvents: TApplicationEvents;
    procedure FormDestroy(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure acSectionNotesExecute(Sender: TObject);
    procedure acSectionWelcomeExecute(Sender: TObject);
    procedure acSettingsExecute(Sender: TObject);
    procedure aeApplicationEventsMinimize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imBurgerButtonClick(Sender: TObject);
    procedure mbMainPaint(Sender: TObject);
    procedure tiTrayIconClick(Sender: TObject);
    procedure tiTrayIconDblClick(Sender: TObject);
  private
    FForms: TQollectorFormList;
    HotKeyID: ATOM;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure RegisterHotkeys;
    procedure UnRegisterHotkeys;
    procedure Restore;
    procedure Minimize;
  protected
    property Forms: TQollectorFormList read FForms;
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

procedure TwMain.acSectionNotesExecute(Sender: TObject);
begin
  FForms.ShowForm(qftNotes);
end;

procedure TwMain.acSectionWelcomeExecute(Sender: TObject);
begin
  FForms.ShowForm(qftWelcome);
end;

procedure TwMain.acSettingsExecute(Sender: TObject);
begin
  TwSettingsDialog.ExecuteDialog;
end;

procedure TwMain.aeApplicationEventsMinimize(Sender: TObject);
begin
  Minimize;
end;

procedure TwMain.FormCreate(Sender: TObject);
begin
  FForms := TQollectorFormList.Create(self);
  acSectionWelcome.Execute;
  GlobalEventBus.RegisterSubscriberForEvents(Self);
  dmCommon.MainFormCreated;
  dmCommon.LoadDatabase('');
  RegisterHotkeys;
end;

procedure TwMain.FormDestroy(Sender: TObject);
begin
  FForms.Free;
end;

procedure TwMain.imBurgerButtonClick(Sender: TObject);
begin
  svSplitView.Opened := not svSplitView.Opened;
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

procedure TwMain.Minimize;
begin
  Hide;
  WindowState := wsMinimized;
  tiTrayIcon.Visible := true;
end;

procedure TwMain.OnDatabaseLoad(AEvent: TDatabaseLoadEvent);
begin
  acSectionNotes.Execute;
  sbNotes.Down := true;
end;

procedure TwMain.OnThemeChange(AEvent: TThemeChangeEvent);
begin
  CustomTitleBar.SystemColors := AEvent.ThemeName = 'Windows';
  mbMain.Invalidate;
  imBurgerButton.ImageCollection := dmCommon.GetImageCollection;
  vilIcons.ImageCollection := dmCommon.GetImageCollection;
  vilLargeIcons.ImageCollection := dmCommon.GetImageCollection;
end;

procedure TwMain.RegisterHotkeys;
const
  VK_Q = $51;
begin
  HotKeyID := GlobalAddAtom('QollectorHotKey');
//  RegisterHotKey(Handle, HotKeyID, MOD_WIN + MOD_SHIFT, VK_Q);
  RegisterHotKey(Handle, HotKeyID, MOD_WIN, VK_NUMPAD0);
end;

procedure TwMain.Restore;
begin
  tiTrayIcon.Visible := false;
  Show;
  WindowState := wsNormal;
  Application.BringToFront;
end;

procedure TwMain.tiTrayIconClick(Sender: TObject);
begin
  Restore;
end;

procedure TwMain.tiTrayIconDblClick(Sender: TObject);
begin
  Restore;
end;

procedure TwMain.UnRegisterHotkeys;
begin
  UnRegisterHotKey(Handle, HotKeyID);
  GlobalDeleteAtom(HotKeyID);
  HotKeyID := 0;
end;

procedure TwMain.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if CustomTitleBar.Enabled and Assigned(mbMain) then
    mbMain.Invalidate;
end;

procedure TwMain.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = HotKeyID then
    begin
      if Application.Active then
        Minimize
      else
        Restore;
    end;
end;

procedure TwMain.WMSize(var Message: TWMSize);
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
