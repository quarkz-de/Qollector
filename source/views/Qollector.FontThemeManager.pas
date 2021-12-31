unit Qollector.FontThemeManager;

interface

uses
  System.SysUtils, System.Generics.Collections,
  Vcl.Controls, Vcl.Graphics;

type
  TFontTheme = (ftNormal, ftLarger, ftHeading);

  TFontThemedControl = class
  private
    FControl: TControl;
    FTheme: TFontTheme;
  public
    constructor Create(const AControl: TControl; ATheme: TFontTheme);
    property Control: TControl read FControl;
    property Theme: TFontTheme read FTheme;
  end;

  TFontThemeManager = class
  private
    FControlList: TObjectList<TFontThemedControl>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddControl(const AControl: TControl; ATheme: TFontTheme);
    procedure StyleControls;
  end;

implementation

type
  TExposedControl = class(TControl)
  public
    property Font;
  end;

{ TFontThemedControl }

constructor TFontThemedControl.Create(const AControl: TControl;
  ATheme: TFontTheme);
begin
  inherited Create;
  FControl := AControl;
  FTheme := ATheme;
end;

{ TFontThemeManager }

procedure TFontThemeManager.AddControl(const AControl: TControl;
  ATheme: TFontTheme);
begin
  FControlList.Add(TFontThemedControl.Create(AControl, ATheme));
end;

constructor TFontThemeManager.Create;
begin
  inherited Create;
  FControlList := TObjectList<TFontThemedControl>.Create;
end;

destructor TFontThemeManager.Destroy;
begin
  FControlList.Free;
  inherited Destroy;
end;

procedure TFontThemeManager.StyleControls;
var
  Item: TFontThemedControl;
  Control: TExposedControl;
  CurrentSize: Integer;
begin
  for Item in FControlList do
    begin
      Control := TExposedControl(Item.Control);
      if Control.ParentFont then
        CurrentSize := Control.Font.Size
      else
        CurrentSize := TExposedControl(Control.Parent).Font.Size;

      case Item.Theme of
        ftNormal:
          begin
            Control.Font.Style := [];
          end;
        ftLarger:
          begin
            Control.Font.Style := [];
            Control.Font.Size := CurrentSize + 1;
          end;
        ftHeading:
          begin
            Control.Font.Style := [fsBold];
            Control.Font.Size := CurrentSize + 1;
          end;
      end;
    end;
end;

end.
