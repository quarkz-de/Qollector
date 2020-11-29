object wLinkEditor: TwLinkEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Bearbeiten'
  ClientHeight = 141
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object txName: TLabel
    Left = 20
    Top = 20
    Width = 64
    Height = 13
    Caption = 'Bezeichnung:'
  end
  object txFilename: TLabel
    Left = 20
    Top = 55
    Width = 55
    Height = 13
    Caption = 'Dateiname:'
  end
  object edName: TEdit
    Left = 96
    Top = 17
    Width = 437
    Height = 21
    TabOrder = 0
    Text = 'edName'
  end
  object edFilename: TEdit
    Left = 96
    Top = 52
    Width = 437
    Height = 21
    TabOrder = 1
    Text = 'edFilename'
  end
  object btOk: TButton
    Left = 377
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btCancel: TButton
    Left = 458
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 3
  end
end
