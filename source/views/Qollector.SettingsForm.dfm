object wSettingsForm: TwSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 468
  ClientWidth = 777
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  DesignSize = (
    777
    468)
  TextHeight = 13
  object txTheme: TLabel
    Left = 48
    Top = 64
    Width = 32
    Height = 13
    Caption = 'Thema'
  end
  object txEditorFont: TLabel
    Left = 48
    Top = 99
    Width = 72
    Height = 13
    Caption = 'Editorschriftart'
  end
  object txView: TLabel
    Left = 20
    Top = 20
    Width = 35
    Height = 13
    Caption = 'Ansicht'
  end
  object Bevel1: TBevel
    Left = 20
    Top = 43
    Width = 733
    Height = 6
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object cbTheme: TComboBox
    Left = 152
    Top = 61
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    OnChange = cbThemeChange
  end
  object cbEditorFont: TComboBox
    Left = 152
    Top = 96
    Width = 249
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnChange = cbEditorFontChange
  end
  object cbEditorFontSize: TComboBox
    Left = 416
    Top = 96
    Width = 73
    Height = 21
    TabOrder = 2
    OnChange = cbEditorFontSizeChange
  end
end
