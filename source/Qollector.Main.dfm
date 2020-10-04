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
  OnDestroy = FormDestroy
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
    Images = dmCommon.vilIcons
    TabOrder = 0
    OnFocusChanged = stNotebooksFocusChanged
    OnFocusChanging = stNotebooksFocusChanging
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
    object miNotes: TMenuItem
      Caption = '&Notizen'
      object miNewNotebook: TMenuItem
        Action = acNewNotebook
      end
      object miNewNote: TMenuItem
        Action = acNewNote
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miDeleteNode: TMenuItem
        Action = acDeleteNote
      end
    end
    object miHelp: TMenuItem
      Caption = '&Hilfe'
      object miHelpAbout: TMenuItem
        Action = acHelpAbout
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
      Caption = 'Sammlung '#246'&ffnen...'
      Dialog.DefaultExt = 'qollection'
      Dialog.Filter = 'Sammlungen (*.qollection)|*.qollection'
      Hint = #214'ffnen|Vorhandene Datei '#246'ffnen'
      ShortCut = 16463
    end
    object acNewNotebook: TAction
      Category = 'Notizen'
      Caption = 'Neues Notiz&buch'
      ShortCut = 16450
      OnExecute = acNewNotebookExecute
    end
    object acNewNote: TAction
      Category = 'Notizen'
      Caption = '&Neue Notiz'
      ShortCut = 16462
      OnExecute = acNewNoteExecute
    end
    object acDeleteNote: TAction
      Category = 'Notizen'
      Caption = '&L'#246'schen'
      OnExecute = acDeleteNoteExecute
    end
    object acHelpAbout: TAction
      Category = 'Hilfe'
      Caption = '&'#220'ber...'
      OnExecute = acHelpAboutExecute
    end
  end
end
