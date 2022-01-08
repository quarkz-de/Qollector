object wNoteForm: TwNoteForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 543
  ClientWidth = 871
  Color = clBtnFace
  ParentFont = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 15
  object spSplitter: TSplitter
    Left = 221
    Top = 0
    Height = 543
    ExplicitTop = 16
    ExplicitHeight = 527
  end
  object pcNote: TPageControl
    AlignWithMargins = True
    Left = 227
    Top = 3
    Width = 641
    Height = 537
    ActivePage = tsEdit
    Align = alClient
    TabHeight = 30
    TabOrder = 0
    TabWidth = 80
    Visible = False
    OnChange = pcNoteChange
    object tsEdit: TTabSheet
      Caption = 'Bearbeiten'
      object edText: TSynEdit
        Left = 0
        Top = 27
        Width = 633
        Height = 470
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Pitch = fpFixed
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 0
        UseCodeFolding = False
        BorderStyle = bsNone
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Consolas'
        Gutter.Font.Style = []
        Gutter.ShowLineNumbers = True
        RightEdge = 0
        ExplicitTop = 24
        ExplicitHeight = 473
      end
      object tbEditor: TActionToolBar
        Left = 0
        Top = 0
        Width = 633
        Height = 27
        ActionManager = amActions
        Caption = 'tbEditor'
        Color = clMenuBar
        ColorMap.DisabledFontColor = 7171437
        ColorMap.HighlightColor = clWhite
        ColorMap.BtnSelectedFont = clBlack
        ColorMap.UnusedColor = clWhite
        EdgeBorders = [ebBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Spacing = 0
        ExplicitHeight = 24
      end
    end
    object tsView: TTabSheet
      Caption = 'Anzeige'
      ImageIndex = 1
      object hvText: THtmlViewer
        Left = 0
        Top = 0
        Width = 633
        Height = 497
        BorderStyle = htNone
        DefFontName = 'Segoe UI'
        DefFontSize = 10
        DefHotSpotColor = clHighlight
        DefOverLinkColor = clHighlight
        DefPreFontName = 'Consolas'
        DefVisitedLinkColor = clHighlight
        HistoryMaxCount = 0
        NoSelect = False
        PrintMarginBottom = 2.000000000000000000
        PrintMarginLeft = 2.000000000000000000
        PrintMarginRight = 2.000000000000000000
        PrintMarginTop = 2.000000000000000000
        PrintScale = 1.000000000000000000
        Text = ''
        OnHotSpotClick = hvTextHotSpotClick
        Align = alClient
        TabOrder = 0
        Touch.InteractiveGestures = [igPan]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia]
      end
    end
    object tsLinks: TTabSheet
      Caption = 'Lesezeichen'
      ImageIndex = 2
      object stLinks: TVirtualStringTree
        Left = 0
        Top = 23
        Width = 633
        Height = 474
        Align = alClient
        BorderStyle = bsNone
        DefaultNodeHeight = 19
        Header.AutoSizeIndex = 1
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Images = vilIcons
        PopupMenu = pmLinks
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toRightClickSelect]
        OnDblClick = stLinksDblClick
        OnDragOver = stLinksDragOver
        OnDragDrop = stLinksDragDrop
        OnFocusChanged = stLinksFocusChanged
        OnKeyDown = stLinksKeyDown
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        Columns = <
          item
            Position = 0
            Text = 'Bezeichung'
            Width = 200
          end
          item
            Position = 1
            Text = 'Ziel'
            Width = 433
          end>
      end
      object tbToolbar: TActionToolBar
        Left = 0
        Top = 0
        Width = 633
        Height = 23
        ActionManager = amActions
        Color = clMenuBar
        ColorMap.DisabledFontColor = 7171437
        ColorMap.HighlightColor = clWhite
        ColorMap.BtnSelectedFont = clBlack
        ColorMap.UnusedColor = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Spacing = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 221
    Height = 543
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 221
      Height = 31
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 6
        Width = 41
        Height = 15
        Caption = 'Notizen'
      end
      object ToolBar1: TToolBar
        Left = 128
        Top = 0
        Width = 93
        Height = 31
        Align = alRight
        ButtonHeight = 31
        ButtonWidth = 31
        Caption = 'ToolBar1'
        Images = vilIcons
        TabOrder = 0
        object tbNewNotebook: TToolButton
          Left = 0
          Top = 0
          Action = acNewNotebook
        end
        object tbNewNote: TToolButton
          Left = 31
          Top = 0
          Action = acNewNote
        end
        object tbDeleteItem: TToolButton
          Left = 62
          Top = 0
          Action = acDeleteItem
        end
      end
    end
    object stNotebooks: TVirtualStringTree
      Left = 0
      Top = 31
      Width = 221
      Height = 512
      Align = alClient
      BorderStyle = bsNone
      DefaultNodeHeight = 19
      DragOperations = [doMove]
      DragType = dtVCL
      Header.AutoSizeIndex = 0
      Header.MainColumn = -1
      Images = vilIcons
      PopupMenu = pmNotes
      TabOrder = 1
      TreeOptions.SelectionOptions = [toRightClickSelect]
      OnFocusChanged = stNotebooksFocusChanged
      OnFocusChanging = stNotebooksFocusChanging
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Columns = <>
    end
  end
  object Connectors: ThtConnectionManager
    Left = 184
    Top = 228
  end
  object FileConnector: ThtFileConnector
    ConnectionManager = Connectors
    Left = 184
    Top = 276
  end
  object ResourceConnector: ThtResourceConnector
    ConnectionManager = Connectors
    Left = 185
    Top = 324
  end
  object pmNotes: TPopupMenu
    Images = vilIcons
    Left = 184
    Top = 132
    object miNewNotebook: TMenuItem
      Action = acNewNotebook
    end
    object miNewNote: TMenuItem
      Action = acNewNote
    end
    object miDeleteItem: TMenuItem
      Action = acDeleteItem
    end
  end
  object pmLinks: TPopupMenu
    Images = vilIcons
    Left = 184
    Top = 176
    object miNewBookmark: TMenuItem
      Action = acNewBookmark
    end
    object miNewFavorite: TMenuItem
      Action = acNewFavorite
    end
    object miEditLink: TMenuItem
      Action = acEditLink
    end
    object miDeleteLink: TMenuItem
      Action = acDeleteLink
    end
  end
  object amActions: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = acNewBookmark
            ImageIndex = 3
            ImageName = '003_Bookmark'
          end
          item
            Action = acNewFavorite
            ImageIndex = 2
            ImageName = '002_Link'
          end
          item
            Action = acEditLink
            ImageIndex = 5
            ImageName = '005_Edit'
          end
          item
            Action = acDeleteLink
            Caption = 'L'#246'&schen'
            ImageIndex = 4
            ImageName = '004_Delete'
          end>
        ActionBar = tbToolbar
      end
      item
        Items = <
          item
            Action = acFormatBold
            ImageIndex = 10
            ImageName = '010_Bold'
            ShowCaption = False
            ShortCut = 16450
          end
          item
            Action = acFormatItalic
            ImageIndex = 11
            ImageName = '011_Italic'
            ShowCaption = False
            ShortCut = 16457
          end
          item
            Action = acFormatStrikeThrough
            ImageIndex = 12
            ImageName = '012_Strikethrough'
            ShowCaption = False
          end
          item
            Caption = '|'
            CommandStyle = csSeparator
            CommandProperties.Width = -1
            CommandProperties.Font.Charset = DEFAULT_CHARSET
            CommandProperties.Font.Color = clWindowText
            CommandProperties.Font.Height = -11
            CommandProperties.Font.Name = 'Tahoma'
            CommandProperties.Font.Style = []
            CommandProperties.ParentFont = False
          end
          item
            Action = acFormatHeading1
            ImageIndex = 13
            ImageName = '013_Header_1'
            ShowCaption = False
            ShortCut = 16433
          end
          item
            Action = acFormatHeading2
            ImageIndex = 14
            ImageName = '014_Header_2'
            ShowCaption = False
            ShortCut = 16434
          end
          item
            Action = acFormatHeading3
            ImageIndex = 15
            ImageName = '015_Header_3'
            ShowCaption = False
            ShortCut = 16435
          end
          item
            Caption = '|'
            CommandStyle = csSeparator
            CommandProperties.Width = -1
            CommandProperties.Font.Charset = DEFAULT_CHARSET
            CommandProperties.Font.Color = clWindowText
            CommandProperties.Font.Height = -11
            CommandProperties.Font.Name = 'Tahoma'
            CommandProperties.Font.Style = []
            CommandProperties.ParentFont = False
          end
          item
            Action = acFormatCode
            ImageIndex = 16
            ImageName = '016_Source_Code'
            ShowCaption = False
            ShortCut = 24643
          end
          item
            Action = acFormatBulletedList
            ImageIndex = 18
            ImageName = '018_Bulleted_List'
            ShowCaption = False
            ShortCut = 24661
          end
          item
            Action = acFormatNumberedList
            ImageIndex = 19
            ImageName = '019_Numbered_List'
            ShowCaption = False
            ShortCut = 24655
          end
          item
            Caption = '|'
            CommandStyle = csSeparator
            CommandProperties.Width = -1
            CommandProperties.Font.Charset = DEFAULT_CHARSET
            CommandProperties.Font.Color = clWindowText
            CommandProperties.Font.Height = -11
            CommandProperties.Font.Name = 'Tahoma'
            CommandProperties.Font.Style = []
            CommandProperties.ParentFont = False
          end
          item
            Action = acFormatInsertLink
            ImageIndex = 20
            ImageName = '020_Link'
            ShowCaption = False
            ShortCut = 24652
          end>
        ActionBar = tbEditor
      end>
    Images = vilIcons
    State = asSuspended
    Left = 185
    Top = 40
    StyleName = 'Platform Default'
    object acNewNotebook: TAction
      Category = 'Notes'
      Caption = 'Neues Notiz&buch'
      Hint = 'Neues Notizbuch'
      ImageIndex = 0
      ImageName = '000_Notebook'
      OnExecute = acNewNotebookExecute
    end
    object acNewNote: TAction
      Category = 'Notes'
      Caption = '&Neue Notiz'
      Hint = 'Neue Notiz'
      ImageIndex = 1
      ImageName = '001_Note'
      OnExecute = acNewNoteExecute
    end
    object acDeleteItem: TAction
      Category = 'Notes'
      Caption = '&L'#246'schen'
      Hint = 'Element l'#246'schen'
      ImageIndex = 4
      ImageName = '004_Delete'
      OnExecute = acDeleteItemExecute
    end
    object acNewBookmark: TAction
      Category = 'Bookmarks'
      Caption = 'Neues &Lesezeichen'
      Hint = 'Neues Lesezeichen'
      ImageIndex = 3
      ImageName = '003_Bookmark'
      OnExecute = acNewBookmarkExecute
    end
    object acNewFavorite: TFileOpen
      Category = 'Bookmarks'
      Caption = 'Neue &Datei anheften...'
      Dialog.Filter = 
        'Alle Dateien (*.*)|*.*|Dokumente (*.pdf;*.odt;*.ods;*.doc;*.docx' +
        ';*.xls;*.xlsx)|*.pdf;*.odt;*.ods;*.doc;*.docx;*.xls;*.xlsx'
      Dialog.Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
      Dialog.Title = 'Datei ausw'#228'hlen'
      Hint = 'Neue Datei anheften'
      ImageIndex = 2
      OnAccept = acNewFavoriteAccept
    end
    object acDeleteLink: TAction
      Category = 'Bookmarks'
      Caption = '&L'#246'schen'
      Hint = 'Lesezeichen l'#246'schen'
      ImageIndex = 4
      ImageName = '004_Delete'
      OnExecute = acDeleteLinkExecute
    end
    object acEditLink: TAction
      Category = 'Bookmarks'
      Caption = '&Bearbeiten'
      Hint = 'Lesezeichen bearbeiten'
      ImageIndex = 5
      ImageName = '005_Edit'
      OnExecute = acEditLinkExecute
    end
    object acFormatBold: TAction
      Category = 'Format'
      Caption = '&Fett'
      ImageIndex = 10
      ImageName = '010_Bold'
      ShortCut = 16450
      OnExecute = acFormatBoldExecute
    end
    object acFormatItalic: TAction
      Category = 'Format'
      Caption = '&Kursiv'
      ImageIndex = 11
      ImageName = '011_Italic'
      ShortCut = 16457
      OnExecute = acFormatItalicExecute
    end
    object acFormatStrikeThrough: TAction
      Category = 'Format'
      Caption = '&Durchgestrichen'
      ImageIndex = 12
      ImageName = '012_Strikethrough'
      OnExecute = acFormatStrikeThroughExecute
    end
    object acFormatHeading1: TAction
      Category = 'Format'
      Caption = #220'berschrift &1'
      ImageIndex = 13
      ImageName = '013_Header_1'
      ShortCut = 16433
      OnExecute = acFormatHeading1Execute
    end
    object acFormatHeading2: TAction
      Category = 'Format'
      Caption = #220'berschrift &2'
      ImageIndex = 14
      ImageName = '014_Header_2'
      ShortCut = 16434
      OnExecute = acFormatHeading2Execute
    end
    object acFormatHeading3: TAction
      Category = 'Format'
      Caption = #220'berschrift &3'
      ImageIndex = 15
      ImageName = '015_Header_3'
      ShortCut = 16435
      OnExecute = acFormatHeading3Execute
    end
    object acFormatCode: TAction
      Category = 'Format'
      Caption = '&Code'
      ImageIndex = 16
      ImageName = '016_Source_Code'
      ShortCut = 24643
      OnExecute = acFormatCodeExecute
    end
    object acFormatBulletedList: TAction
      Category = 'Format'
      Caption = 'Auf&z'#228'hlung'
      ImageIndex = 18
      ImageName = '018_Bulleted_List'
      ShortCut = 24661
      OnExecute = acFormatBulletedListExecute
    end
    object acFormatNumberedList: TAction
      Category = 'Format'
      Caption = 'Nummerierte &Liste'
      ImageIndex = 19
      ImageName = '019_Numbered_List'
      ShortCut = 24655
      OnExecute = acFormatNumberedListExecute
    end
    object acFormatInsertLink: TAction
      Category = 'Format'
      Caption = 'L&ink'
      ImageIndex = 20
      ImageName = '020_Link'
      ShortCut = 24652
      OnExecute = acFormatInsertLinkExecute
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
    Left = 184
    Top = 84
  end
end
