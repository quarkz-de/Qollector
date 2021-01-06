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
  Qollector.NoteForm in 'views\Qollector.NoteForm.pas' {wNoteForm},
  Qollector.Forms in 'views\Qollector.Forms.pas',
  Qollector.About in 'views\Qollector.About.pas' {wAbout},
  Qollector.Settings in 'core\Qollector.Settings.pas',
  Qollector.Execute in 'core\Qollector.Execute.pas',
  Qollector.Migrations in 'models\Qollector.Migrations.pas',
  Qollector.DatabaseMigrator in 'core\Qollector.DatabaseMigrator.pas',
  Qollector.EditLink in 'views\Qollector.EditLink.pas' {wLinkEditor},
  Qollector.WelcomeForm in 'views\Qollector.WelcomeForm.pas' {wWelcomeForm},
  Qollector.SettingsForm in 'views\Qollector.SettingsForm.pas' {wSettingsForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  GlobalContainer.Build;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Qollector';
  Application.CreateForm(TdmCommon, dmCommon);
  Application.CreateForm(TwMain, wMain);
  Application.Run;
end.
