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
  Qodelib.Instance,
  Qollector.Main in 'Qollector.Main.pas' {wQollectorMain},
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
  Qollector.SettingsForm in 'views\Qollector.SettingsForm.pas' {wSettingsForm},
  Qollector.DatabaseMigrations in 'core\Qollector.DatabaseMigrations.pas',
  Qollector.Parameters in 'core\Qollector.Parameters.pas',
  Qollector.Markdown in 'views\Qollector.Markdown.pas';

{$R *.res}

begin
{$ifdef DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$endif}
  if not CheckSingleInstance('{9B80F682-3B8C-4F55-9F40-5F1B5253415F}') then
    begin
      TParameterSender.Send;
      Halt(0);
    end;
  GlobalContainer.Build;
  Application.Initialize;
  Application.Title := 'Qollector';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmCommon, dmCommon);
  Application.CreateForm(TwQollectorMain, wQollectorMain);
  TParameterSender.Process;
  Application.Run;
end.
