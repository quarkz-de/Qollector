unit Qollector.Database;

interface

uses
  System.SysUtils, System.Classes,
  Spring.Persistence.Core.DatabaseManager,
  Spring.Persistence.Core.ConnectionFactory,
  Spring.Persistence.Core.Session,
  Spring.Persistence.Core.Interfaces,
  Spring.Persistence.Adapters.SQLite,
  Spring.Persistence.SQL.Interfaces;

type
  IQollectorDatabase = interface
    ['{8DEC4252-2E6E-4641-9246-10BC7A8D24B1}']
    { Property Accessors }
    function GetSession: TSession;
    function GetConnection: IDBConnection;
    function GetFilename: String;
    function Load: Boolean; overload;
    function Load(const AFilename: String): Boolean; overload;
    procedure Close;
    property Session: TSession read GetSession;
    property Connection: IDBConnection read GetConnection;
    property Filename: String read GetFilename;
  end;

implementation

uses
  System.IOUtils,
  Spring.Container,
  SQLiteTable3,
  Qollector.DatabaseMigrator,
  Qollector.Notes;

type
  TQollectorDatabase = class(TInterfacedObject, IQollectorDatabase)
  private
    FFilename: String;
    FDatabase: TSQLiteDatabase;
    FConnection: IDBConnection;
    FSession: TSession;
    procedure BuildDatabase;
  protected
    function GetSession: TSession;
    function GetConnection: IDBConnection;
    function GetFilename: String;
  public
    constructor Create;
    destructor Destroy; override;
    function Load: Boolean; overload;
    function Load(const AFilename: String): Boolean; overload;
    procedure Close;
    function IsLoaded: Boolean;
    property Session: TSession read GetSession;
    property Connection: IDBConnection read GetConnection;
    property Filename: String read GetFilename;
  end;

{ TQollectorDatabase }

procedure TQollectorDatabase.BuildDatabase;
var
  Migrator: IDatabaseMigrator;
begin
  Migrator :=  GlobalContainer.Resolve<IDatabaseMigrator>;
  Migrator.Execute(FConnection);
end;

procedure TQollectorDatabase.Close;
begin
  FreeAndNil(FSession);
  FreeAndNil(FDatabase);
end;

constructor TQollectorDatabase.Create;
begin
  inherited;
  FSession := nil;
  FDatabase := nil;
end;

destructor TQollectorDatabase.Destroy;
begin
  Close;
  inherited;
end;

function TQollectorDatabase.GetConnection: IDBConnection;
begin
  Result := FConnection;
end;

function TQollectorDatabase.GetFilename: String;
begin
  Result := FFilename;
end;

function TQollectorDatabase.GetSession: TSession;
begin
  Result := FSession;
end;

function TQollectorDatabase.IsLoaded: Boolean;
begin
  Result := FSession <> nil;
end;

function TQollectorDatabase.Load(const AFilename: String): Boolean;
begin
  Close;

  FFilename := ExpandFilename(AFilename);
  FDatabase := TSQLiteDatabase.Create(nil);
  FDatabase.Filename := Filename;
  FConnection := TSQLiteConnectionAdapter.Create(FDatabase);
  FConnection.AutoFreeConnection := false;
  FConnection.Connect;
  FSession := TSession.Create(FConnection);

  BuildDatabase;

  Result := FileExists(Filename);
end;

function TQollectorDatabase.Load: Boolean;
begin
  Result := Load(TPath.Combine(TPath.GetDocumentsPath, 'Qollector.qollection'));
end;

initialization
  GlobalContainer.RegisterType<TQollectorDatabase>.Implements<IQollectorDatabase>.AsSingleton;
end.
