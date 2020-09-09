program Qollector;

uses
  Vcl.Forms,
  Qollector.Main in 'Qollector.Main.pas' {wMain},
  Vcl.Themes,
  Vcl.Styles,
  Qollector.DataModule in 'Qollector.DataModule.pas' {dmCommon: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 BlackPearl');
  Application.Title := 'Qollector';
  Application.CreateForm(TdmCommon, dmCommon);
  Application.CreateForm(TwMain, wMain);
  Application.Run;
end.
