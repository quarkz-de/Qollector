object wMain: TwMain
  Left = 0
  Top = 0
  Caption = 'Qollector'
  ClientHeight = 557
  ClientWidth = 903
  Color = clBtnFace
  CustomTitleBar.Control = tbpTitleBar
  CustomTitleBar.Enabled = True
  CustomTitleBar.Height = 31
  CustomTitleBar.ShowCaption = False
  CustomTitleBar.SystemColors = False
  CustomTitleBar.BackgroundColor = 14123008
  CustomTitleBar.ForegroundColor = clWhite
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = clWhite
  CustomTitleBar.ButtonBackgroundColor = 14123008
  CustomTitleBar.ButtonHoverForegroundColor = clWhite
  CustomTitleBar.ButtonHoverBackgroundColor = 11364608
  CustomTitleBar.ButtonPressedForegroundColor = clWhite
  CustomTitleBar.ButtonPressedBackgroundColor = 7160320
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clWhite
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 31
  OldCreateOrder = False
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object spSplitter: TSplitter
    Left = 221
    Top = 30
    Height = 527
    ExplicitLeft = 664
    ExplicitTop = 416
    ExplicitHeight = 100
  end
  object stNotebooks: TVirtualStringTree
    Left = 0
    Top = 30
    Width = 221
    Height = 527
    Align = alLeft
    DefaultNodeHeight = 19
    Header.AutoSizeIndex = 0
    Header.MainColumn = -1
    Images = dmCommon.vilIcons
    TabOrder = 0
    OnFocusChanged = stNotebooksFocusChanged
    OnFocusChanging = stNotebooksFocusChanging
    ExplicitLeft = 3
    Columns = <>
  end
  object tbpTitleBar: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 903
    Height = 30
    CustomButtons = <>
    object mbMain: TActionMainMenuBar
      Left = 32
      Top = 0
      Width = 257
      Height = 24
      UseSystemFont = False
      ActionManager = amActions
      Align = alNone
      Caption = 'mbMain'
      Color = clMenuBar
      ColorMap.DisabledFontColor = 7171437
      ColorMap.HighlightColor = clWhite
      ColorMap.BtnSelectedFont = clBlack
      ColorMap.UnusedColor = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      Spacing = 0
      OnPaint = mbMainPaint
    end
  end
  object odBookmark: TOpenDialog
    Filter = 
      'Alle Dateien (*.*)|*.*|Dokumente (*.pdf;*.odt;*.ods;*.doc;*.docx' +
      ';*.xls;*.xlsx)|*.pdf;*.odt;*.ods;*.doc;*.docx;*.xls;*.xlsx'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 496
    Top = 36
  end
  object amActions: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = acFileOpen
                ShortCut = 16463
              end
              item
                Caption = '-'
              end
              item
                Action = acSettings
              end
              item
                Caption = '-'
              end
              item
                Action = acFileExit
              end>
            Caption = '&Datei'
          end
          item
            Items = <
              item
                Action = acNewNotebook
                ImageIndex = 0
                ImageName = '000_Notebook'
                ShortCut = 16450
              end
              item
                Action = acNewNote
                ImageIndex = 1
                ImageName = '001_Note'
                ShortCut = 16462
              end
              item
                Action = acNewBookmark
                ImageIndex = 3
                ImageName = '003_Bookmark'
                ShortCut = 16460
              end
              item
                Action = acNewFavorite
                ShortCut = 16454
              end
              item
                Caption = '-'
              end
              item
                Action = acDeleteNote
                Caption = 'L'#246'&schen'
                ImageIndex = 4
                ImageName = '004_Delete'
              end>
            Caption = '&Notizen'
          end
          item
            Items = <
              item
                Action = acHelpAbout
              end>
            Caption = '&Hilfe'
          end>
        ActionBar = mbMain
      end
      item
      end>
    Images = dmCommon.vilIcons
    Left = 416
    Top = 36
    StyleName = 'Platform Default'
    object acNewNotebook: TAction
      Category = 'Notizen'
      Caption = 'Neues Notiz&buch'
      ImageIndex = 0
      ImageName = '000_Notebook'
      ShortCut = 16450
      OnExecute = acNewNotebookExecute
    end
    object acNewNote: TAction
      Category = 'Notizen'
      Caption = '&Neue Notiz'
      ImageIndex = 1
      ImageName = '001_Note'
      ShortCut = 16462
      OnExecute = acNewNoteExecute
    end
    object acDeleteNote: TAction
      Category = 'Notizen'
      Caption = '&L'#246'schen'
      ImageIndex = 4
      ImageName = '004_Delete'
      OnExecute = acDeleteNoteExecute
    end
    object acNewBookmark: TAction
      Category = 'Notizen'
      Caption = 'Neues &Lesezeichen'
      ImageIndex = 3
      ImageName = '003_Bookmark'
      ShortCut = 16460
      OnExecute = acNewBookmarkExecute
    end
    object acNewFavorite: TFileOpen
      Category = 'Notizen'
      Caption = 'Neue &Datei anheften...'
      Dialog.Filter = 
        'Alle Dateien (*.*)|*.*|Dokumente (*.pdf;*.odt;*.ods;*.doc;*.docx' +
        ';*.xls;*.xlsx)|*.pdf;*.odt;*.ods;*.doc;*.docx;*.xls;*.xlsx'
      Dialog.Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
      Dialog.Title = 'Datei ausw'#228'hlen'
      Hint = #214'ffnen|Vorhandene Datei '#246'ffnen'
      ImageIndex = 2
      ShortCut = 16454
      OnAccept = acNewFavoriteAccept
    end
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
    object acSettings: TAction
      Category = 'Datei'
      Caption = '&Einstellungen...'
      OnExecute = acSettingsExecute
    end
    object acHelpAbout: TAction
      Category = 'Hilfe'
      Caption = '&'#220'ber...'
      OnExecute = acHelpAboutExecute
    end
  end
end
