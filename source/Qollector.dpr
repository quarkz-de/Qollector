program Qollector;

uses
  Spring.Container,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Vcl.Styles.Hooks,
  Vcl.Styles.UxTheme,
  Vcl.Styles.Utils.Menus,
  Vcl.Styles.Utils.Forms,
  Vcl.Styles.Utils.ComCtrls,
  Vcl.Styles.Utils.ScreenTips,
  Qollector.Main in 'Qollector.Main.pas' {wMain},
  Qollector.DataModule in 'Qollector.DataModule.pas' {dmCommon: TDataModule},
  Qollector.Database in 'core\Qollector.Database.pas',
  Qollector.Notes in 'models\Qollector.Notes.pas',
  Qollector.Visualizers in 'views\Qollector.Visualizers.pas',
  Qollector.Events in 'core\Qollector.Events.pas',
  Qollector.NoteFrame in 'views\Qollector.NoteFrame.pas' {frNoteFrame: TFrame},
  Qollector.Frames in 'views\Qollector.Frames.pas',
  Qollector.About in 'views\Qollector.About.pas' {wAbout};

{$R *.res}

begin
  GlobalContainer.Build;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 BlackPearl');
  Application.Title := 'Qollector';
  Application.CreateForm(TdmCommon, dmCommon);
  Application.CreateForm(TwMain, wMain);
  Application.CreateForm(TwAbout, wAbout);
  Application.Run;
end.
