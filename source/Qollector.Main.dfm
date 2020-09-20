object wMain: TwMain
  Left = 0
  Top = 0
  Caption = 'Qollector'
  ClientHeight = 537
  ClientWidth = 903
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mmMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object spSplitter: TSplitter
    Left = 221
    Top = 0
    Height = 537
    ExplicitLeft = 664
    ExplicitTop = 416
    ExplicitHeight = 100
  end
  object stNotebooks: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 221
    Height = 537
    Align = alLeft
    DefaultNodeHeight = 19
    Header.AutoSizeIndex = 0
    Header.MainColumn = -1
    TabOrder = 0
    Columns = <>
  end
  object mmMenu: TMainMenu
    Left = 352
    Top = 36
    object miFile: TMenuItem
      Caption = '&Datei'
      object miFileOpen: TMenuItem
        Action = acFileOpen
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miFileExit: TMenuItem
        Action = acFileExit
      end
    end
  end
  object alActions: TActionList
    Images = dmCommon.vilIcons
    Left = 424
    Top = 36
    object acFileExit: TFileExit
      Category = 'Datei'
      Caption = '&Beenden'
      Hint = 'Beenden|Anwendung beenden'
    end
    object acFileOpen: TFileOpen
      Category = 'Datei'
      Caption = #214'&ffnen...'
      Dialog.DefaultExt = 'qollection'
      Dialog.Filter = 'Kollektionen (*.qollection)|*.qollection'
      Hint = #214'ffnen|Vorhandene Datei '#246'ffnen'
      ShortCut = 16463
    end
  end
end
