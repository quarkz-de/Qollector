object wQollectorMain: TwQollectorMain
  Left = 0
  Top = 0
  Caption = 'Qollector'
  ClientHeight = 464
  ClientWidth = 1032
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  CustomTitleBar.Control = tbpTitleBar
  CustomTitleBar.Enabled = True
  CustomTitleBar.Height = 31
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
  ShowHint = True
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object tbpTitleBar: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 1032
    Height = 30
    CustomButtons = <>
    object mbMain: TActionMainMenuBar
      Left = 36
      Top = 0
      Width = 97
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
      StyleName = 'Windows'
      Spacing = 0
      OnPaint = mbMainPaint
    end
  end
  object svSplitView: TSplitView
    Left = 0
    Top = 30
    Width = 170
    Height = 434
    CloseStyle = svcCompact
    CompactWidth = 60
    OpenedWidth = 170
    Placement = svpLeft
    TabOrder = 1
    OnClosed = svSplitViewClosed
    OnOpened = svSplitViewOpened
    object pnHeader: TPanel
      Left = 0
      Top = 0
      Width = 170
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object imBurgerButton: TVirtualImage
        Left = 16
        Top = 6
        Width = 32
        Height = 32
        ImageCollection = dmCommon.icDarkIcons
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 6
        OnClick = imBurgerButtonClick
      end
    end
    object nvNavigation: TQzNavigationView
      Left = 0
      Top = 45
      Width = 170
      Height = 340
      Align = alClient
      BorderStyle = bsNone
      ButtonHeight = 48
      ButtonOptions = [nboAllowReorder, nboGroupStyle, nboShowCaptions]
      Images = vilLargeIcons
      Items = <
        item
          Action = acSectionWelcome
          AllowReorder = False
        end
        item
          Action = acSectionNotes
        end>
      ItemIndex = 0
      TabOrder = 1
      OnButtonClicked = nvNavigationButtonClicked
      ExplicitHeight = 289
    end
    object nvFooter: TQzNavigationView
      Left = 0
      Top = 385
      Width = 170
      Height = 49
      Align = alBottom
      BorderStyle = bsNone
      ButtonHeight = 48
      ButtonOptions = [nboGroupStyle, nboShowCaptions]
      Images = vilLargeIcons
      Items = <
        item
          Action = acSectionSettings
        end>
      TabOrder = 2
      OnButtonClicked = nvFooterButtonClicked
      ExplicitTop = 334
    end
  end
  object amActions: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = acFileOpen
                ImageIndex = 21
                ImageName = '021_Open_Collection'
                ShortCut = 16463
              end
              item
                Action = acFileNew
                ImageIndex = 22
                ImageName = '022_New_Collection'
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
                Action = acHelpAbout
              end>
            Caption = '&Hilfe'
          end>
        ActionBar = mbMain
      end>
    Images = vilIcons
    Left = 424
    Top = 40
    StyleName = 'Platform Default'
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
      Dialog.Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
      Dialog.Title = 'Sammlung '#246'ffnen'
      Hint = #214'ffnen|Vorhandene Datei '#246'ffnen'
      ImageIndex = 21
      ShortCut = 16463
      OnAccept = acFileOpenAccept
    end
    object acHelpAbout: TAction
      Category = 'Hilfe'
      Caption = '&'#220'ber...'
      OnExecute = acHelpAboutExecute
    end
    object acSectionWelcome: TAction
      Category = 'Bereich'
      AutoCheck = True
      Caption = 'Startseite'
      GroupIndex = 1
      ImageIndex = 7
      ImageName = '007_Home'
      OnExecute = acSectionWelcomeExecute
    end
    object acSectionNotes: TAction
      Category = 'Bereich'
      AutoCheck = True
      Caption = 'Notizen'
      GroupIndex = 1
      ImageIndex = 0
      ImageName = '000_Notebook'
      OnExecute = acSectionNotesExecute
    end
    object acSectionSettings: TAction
      Category = 'Bereich'
      Caption = 'Einstellungen'
      GroupIndex = 1
      ImageIndex = 8
      ImageName = '008_Settings'
      OnExecute = acSectionSettingsExecute
    end
    object acFileNew: TFileSaveAs
      Category = 'Datei'
      Caption = '&Neue Sammlung...'
      Dialog.DefaultExt = 'qollection'
      Dialog.Filter = 'Sammlungen (*.qollection)|*.qollection'
      Dialog.Title = 'Neue Sammlung beginnen'
      Hint = 'Speichern unter|Aktive Datei unter einem neuen Namen speichern'
      ImageIndex = 22
      OnAccept = acFileNewAccept
    end
  end
  object vilIcons: TVirtualImageList
    AutoFill = True
    Images = <
      item
        CollectionIndex = 0
        CollectionName = '000_Notebook'
        Name = '000_Notebook'
      end
      item
        CollectionIndex = 1
        CollectionName = '001_Note'
        Name = '001_Note'
      end
      item
        CollectionIndex = 2
        CollectionName = '002_Link'
        Name = '002_Link'
      end
      item
        CollectionIndex = 3
        CollectionName = '003_Bookmark'
        Name = '003_Bookmark'
      end
      item
        CollectionIndex = 4
        CollectionName = '004_Delete'
        Name = '004_Delete'
      end
      item
        CollectionIndex = 5
        CollectionName = '005_Edit'
        Name = '005_Edit'
      end
      item
        CollectionIndex = 6
        CollectionName = '006_Menu'
        Name = '006_Menu'
      end
      item
        CollectionIndex = 7
        CollectionName = '007_Home'
        Name = '007_Home'
      end
      item
        CollectionIndex = 8
        CollectionName = '008_Settings'
        Name = '008_Settings'
      end
      item
        CollectionIndex = 9
        CollectionName = '009_Collection'
        Name = '009_Collection'
      end
      item
        CollectionIndex = 10
        CollectionName = '010_Bold'
        Name = '010_Bold'
      end
      item
        CollectionIndex = 11
        CollectionName = '011_Italic'
        Name = '011_Italic'
      end
      item
        CollectionIndex = 12
        CollectionName = '012_Strikethrough'
        Name = '012_Strikethrough'
      end
      item
        CollectionIndex = 13
        CollectionName = '013_Header_1'
        Name = '013_Header_1'
      end
      item
        CollectionIndex = 14
        CollectionName = '014_Header_2'
        Name = '014_Header_2'
      end
      item
        CollectionIndex = 15
        CollectionName = '015_Header_3'
        Name = '015_Header_3'
      end
      item
        CollectionIndex = 16
        CollectionName = '016_Source_Code'
        Name = '016_Source_Code'
      end
      item
        CollectionIndex = 17
        CollectionName = '017_Horizontal_Line'
        Name = '017_Horizontal_Line'
      end
      item
        CollectionIndex = 18
        CollectionName = '018_Bulleted_List'
        Name = '018_Bulleted_List'
      end
      item
        CollectionIndex = 19
        CollectionName = '019_Numbered_List'
        Name = '019_Numbered_List'
      end
      item
        CollectionIndex = 20
        CollectionName = '020_Link'
        Name = '020_Link'
      end
      item
        CollectionIndex = 21
        CollectionName = '021_Open_Collection'
        Name = '021_Open_Collection'
      end
      item
        CollectionIndex = 22
        CollectionName = '022_New_Collection'
        Name = '022_New_Collection'
      end
      item
        CollectionIndex = 23
        CollectionName = '023_Last_Collection'
        Name = '023_Last_Collection'
      end>
    ImageCollection = dmCommon.icDarkIcons
    Left = 476
    Top = 40
  end
  object vilLargeIcons: TVirtualImageList
    AutoFill = True
    Images = <
      item
        CollectionIndex = 0
        CollectionName = '000_Notebook'
        Name = '000_Notebook'
      end
      item
        CollectionIndex = 1
        CollectionName = '001_Note'
        Name = '001_Note'
      end
      item
        CollectionIndex = 2
        CollectionName = '002_Link'
        Name = '002_Link'
      end
      item
        CollectionIndex = 3
        CollectionName = '003_Bookmark'
        Name = '003_Bookmark'
      end
      item
        CollectionIndex = 4
        CollectionName = '004_Delete'
        Name = '004_Delete'
      end
      item
        CollectionIndex = 5
        CollectionName = '005_Edit'
        Name = '005_Edit'
      end
      item
        CollectionIndex = 6
        CollectionName = '006_Menu'
        Name = '006_Menu'
      end
      item
        CollectionIndex = 7
        CollectionName = '007_Home'
        Name = '007_Home'
      end
      item
        CollectionIndex = 8
        CollectionName = '008_Settings'
        Name = '008_Settings'
      end
      item
        CollectionIndex = 9
        CollectionName = '009_Collection'
        Name = '009_Collection'
      end
      item
        CollectionIndex = 10
        CollectionName = '010_Bold'
        Name = '010_Bold'
      end
      item
        CollectionIndex = 11
        CollectionName = '011_Italic'
        Name = '011_Italic'
      end
      item
        CollectionIndex = 12
        CollectionName = '012_Strikethrough'
        Name = '012_Strikethrough'
      end
      item
        CollectionIndex = 13
        CollectionName = '013_Header_1'
        Name = '013_Header_1'
      end
      item
        CollectionIndex = 14
        CollectionName = '014_Header_2'
        Name = '014_Header_2'
      end
      item
        CollectionIndex = 15
        CollectionName = '015_Header_3'
        Name = '015_Header_3'
      end
      item
        CollectionIndex = 16
        CollectionName = '016_Source_Code'
        Name = '016_Source_Code'
      end
      item
        CollectionIndex = 17
        CollectionName = '017_Horizontal_Line'
        Name = '017_Horizontal_Line'
      end
      item
        CollectionIndex = 18
        CollectionName = '018_Bulleted_List'
        Name = '018_Bulleted_List'
      end
      item
        CollectionIndex = 19
        CollectionName = '019_Numbered_List'
        Name = '019_Numbered_List'
      end
      item
        CollectionIndex = 20
        CollectionName = '020_Link'
        Name = '020_Link'
      end
      item
        CollectionIndex = 21
        CollectionName = '021_Open_Collection'
        Name = '021_Open_Collection'
      end
      item
        CollectionIndex = 22
        CollectionName = '022_New_Collection'
        Name = '022_New_Collection'
      end
      item
        CollectionIndex = 23
        CollectionName = '023_Last_Collection'
        Name = '023_Last_Collection'
      end>
    ImageCollection = dmCommon.icDarkIcons
    Width = 32
    Height = 32
    Left = 524
    Top = 40
  end
  object tiTrayIcon: TTrayIcon
    Animate = True
    OnClick = tiTrayIconClick
    OnDblClick = tiTrayIconDblClick
    Left = 580
    Top = 40
  end
  object aeApplicationEvents: TApplicationEvents
    OnMinimize = aeApplicationEventsMinimize
    Left = 640
    Top = 40
  end
end
