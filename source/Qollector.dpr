program Qollector;

uses
  Spring.Container,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Qollector.Main in 'Qollector.Main.pas' {wMain},
  Qollector.DataModule in 'Qollector.DataModule.pas' {dmCommon: TDataModule},
  Qollector.Bereiche in 'core\Qollector.Bereiche.pas',
  Qollector.Database in 'core\Qollector.Database.pas';

{$R *.res}

begin
  GlobalContainer.Build;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 BlackPearl');
  Application.Title := 'Qollector';
  Application.CreateForm(TdmCommon, dmCommon);
  Application.CreateForm(TwMain, wMain);
  Application.Run;
end.
