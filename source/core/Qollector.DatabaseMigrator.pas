unit Qollector.DatabaseMigrator;

interface

uses
  Spring.Persistence.Core.Interfaces,
  Spring.Persistence.Core.DatabaseManager;

type
  IDatabaseMigrator = interface
    ['{4D503781-06E6-496E-9D2E-6F2CAD50BB04}']
    function Execute(const AConnection: IDBConnection): Boolean;
  end;

implementation

uses
  Spring.Container,
  Spring.Collections,
  Spring.Persistence.Core.Session,
  Spring.Persistence.SQL.Commands.CreateTable,
  Qollector.Notes,
  Qollector.Migrations;

const
  MigrationPending = 0;
  MigrationSuccessful = 1;

  MigrationCreateMigrationTable = 1;

type
  TDatabaseMigrator = class(TInterfacedObject, IDatabaseMigrator)
  private
    FConnection: IDBConnection;
    DBManager: TDatabaseManager;
    Session: TSession;
    function CreateNewDatabase: Boolean;
    function ExecuteMigrations: Boolean;
    procedure CreateMigrationTable;
  public
    function Execute(const AConnection: IDBConnection): Boolean;
  end;

{ TDatabaseMigrator }

procedure TDatabaseMigrator.CreateMigrationTable;
var
  Command: IDDLCommand;
begin
  Command := TCreateTableExecutor.Create(FConnection);
  Command.Build(TMigration);
  Command.Execute;
end;

function TDatabaseMigrator.CreateNewDatabase: Boolean;
begin
  Result := false;

  if not DBManager.EntityExists(TMigration) and
    not DBManager.EntityExists(TNoteItem) then
    begin
      DBManager.BuildDatabase;
      Result := true;
    end;
end;

function TDatabaseMigrator.Execute(const AConnection: IDBConnection): Boolean;
begin
  FConnection := AConnection;
  DBManager := TDatabaseManager.Create(FConnection);
  Session := TSession.Create(FConnection);
  try
    Result := CreateNewDatabase;
    if not Result then
      Result := ExecuteMigrations;
  finally
    Session.Free;
    DBManager.Free;
  end;
end;

function TDatabaseMigrator.ExecuteMigrations: Boolean;
var
  MigrationList: IList<TMigration>;
  Migration: TMigration;
begin
  Result := true;

  if not DBManager.EntityExists(TMigration) then
    begin
      CreateMigrationTable;
      Migration := TMigration.Create;
      Migration.Migration := MigrationCreateMigrationTable;
      Migration.Status := MigrationSuccessful;
      Session.Save(Migration);
    end;

  MigrationList := Session.FindAll<TMigration>();
end;

initialization
  GlobalContainer.RegisterType<TDatabaseMigrator>.Implements<IDatabaseMigrator>;
end.
