object wSettingsDialog: TwSettingsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Einstellungen'
  ClientHeight = 103
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    267
    103)
  PixelsPerInch = 96
  TextHeight = 13
  object txTheme: TLabel
    Left = 20
    Top = 24
    Width = 32
    Height = 13
    Caption = 'Thema'
  end
  object cbTheme: TComboBox
    Left = 88
    Top = 21
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 0
  end
  object btOk: TButton
    Left = 97
    Top = 66
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
    ExplicitLeft = 475
    ExplicitTop = 272
  end
  object btCancel: TButton
    Left = 178
    Top = 66
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
    ExplicitLeft = 556
    ExplicitTop = 272
  end
end
