object wNoteForm: TwNoteForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 543
  ClientWidth = 871
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
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
        Top = 0
        Width = 633
        Height = 497
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
        OnCommandProcessed = edTextCommandProcessed
      end
    end
    object tsView: TTabSheet
      Caption = 'Anzeige'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
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
        ExplicitTop = 26
        ExplicitHeight = 471
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
        Width = 36
        Height = 13
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
      DefaultNodeHeight = 19
      Header.AutoSizeIndex = 0
      Header.MainColumn = -1
      Images = vilIcons
      PopupMenu = pmNotes
      TabOrder = 1
      TreeOptions.SelectionOptions = [toRightClickSelect]
      OnFocusChanged = stNotebooksFocusChanged
      OnFocusChanging = stNotebooksFocusChanging
      Columns = <>
    end
  end
  object Connectors: ThtConnectionManager
    Left = 328
    Top = 56
  end
  object FileConnector: ThtFileConnector
    ConnectionManager = Connectors
    Left = 328
    Top = 108
  end
  object ResourceConnector: ThtResourceConnector
    ConnectionManager = Connectors
    Left = 325
    Top = 156
  end
  object pmNotes: TPopupMenu
    Images = vilIcons
    Left = 408
    Top = 212
    object miNewNotebook: TMenuItem
      Caption = 'Neues Notiz&buch'
      Hint = 'Neues Notizbuch'
      ImageIndex = 0
      ImageName = '000_Notebook'
      OnClick = acNewNotebookExecute
    end
    object miNewNote: TMenuItem
      Caption = '&Neue Notiz'
      Hint = 'Neue Notiz'
      ImageIndex = 1
      ImageName = '001_Note'
      OnClick = acNewNoteExecute
    end
    object miDeleteItem: TMenuItem
      Caption = '&L'#246'schen'
      Hint = 'Element l'#246'schen'
      ImageIndex = 4
      ImageName = '004_Delete'
      OnClick = acDeleteItemExecute
    end
  end
  object pmLinks: TPopupMenu
    Images = vilIcons
    Left = 480
    Top = 212
    object miNewBookmark: TMenuItem
      Caption = 'Neues &Lesezeichen'
      Hint = 'Neues Lesezeichen'
      ImageIndex = 3
      ImageName = '003_Bookmark'
      OnClick = acNewBookmarkExecute
    end
    object miNewFavorite: TMenuItem
      Caption = 'Neue &Datei anheften...'
      Hint = 'Neue Datei anheften'
      ImageIndex = 2
      ImageName = '002_Link'
    end
    object miEditLink: TMenuItem
      Caption = '&Bearbeiten'
      Hint = 'Lesezeichen bearbeiten'
      ImageIndex = 5
      ImageName = '005_Edit'
      OnClick = acEditLinkExecute
    end
    object miDeleteLink: TMenuItem
      Caption = '&L'#246'schen'
      Hint = 'Lesezeichen l'#246'schen'
      ImageIndex = 4
      ImageName = '004_Delete'
      OnClick = acDeleteLinkExecute
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
            Action = acNewNotebook
            ImageIndex = 0
            ImageName = '000_Notebook'
          end
          item
            Action = acNewNote
            ImageIndex = 1
            ImageName = '001_Note'
          end
          item
            Action = acDeleteItem
            ImageIndex = 4
            ImageName = '004_Delete'
          end>
      end>
    Images = vilIcons
    Left = 321
    Top = 280
    StyleName = 'Platform Default'
    object acNewNotebook: TAction
      Caption = 'Neues Notiz&buch'
      Hint = 'Neues Notizbuch'
      ImageIndex = 0
      ImageName = '000_Notebook'
      OnExecute = acNewNotebookExecute
    end
    object acNewNote: TAction
      Caption = '&Neue Notiz'
      Hint = 'Neue Notiz'
      ImageIndex = 1
      ImageName = '001_Note'
      OnExecute = acNewNoteExecute
    end
    object acDeleteItem: TAction
      Caption = '&L'#246'schen'
      Hint = 'Element l'#246'schen'
      ImageIndex = 4
      ImageName = '004_Delete'
      OnExecute = acDeleteItemExecute
    end
    object acNewBookmark: TAction
      Caption = 'Neues &Lesezeichen'
      Hint = 'Neues Lesezeichen'
      ImageIndex = 3
      ImageName = '003_Bookmark'
      OnExecute = acNewBookmarkExecute
    end
    object acNewFavorite: TFileOpen
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
      Caption = '&L'#246'schen'
      Hint = 'Lesezeichen l'#246'schen'
      ImageIndex = 4
      ImageName = '004_Delete'
      OnExecute = acDeleteLinkExecute
    end
    object acEditLink: TAction
      Caption = '&Bearbeiten'
      Hint = 'Lesezeichen bearbeiten'
      ImageIndex = 5
      ImageName = '005_Edit'
      OnExecute = acEditLinkExecute
    end
  end
  object vilIcons: TVirtualImageList
    AutoFill = True
    DisabledGrayscale = False
    DisabledSuffix = '_Disabled'
    Images = <
      item
        CollectionIndex = 0
        CollectionName = '000_Notebook'
        Disabled = False
        Name = '000_Notebook'
      end
      item
        CollectionIndex = 1
        CollectionName = '001_Note'
        Disabled = False
        Name = '001_Note'
      end
      item
        CollectionIndex = 2
        CollectionName = '002_Link'
        Disabled = False
        Name = '002_Link'
      end
      item
        CollectionIndex = 3
        CollectionName = '003_Bookmark'
        Disabled = False
        Name = '003_Bookmark'
      end
      item
        CollectionIndex = 4
        CollectionName = '004_Delete'
        Disabled = False
        Name = '004_Delete'
      end
      item
        CollectionIndex = 5
        CollectionName = '005_Edit'
        Disabled = False
        Name = '005_Edit'
      end
      item
        CollectionIndex = 6
        CollectionName = '006_Menu'
        Disabled = False
        Name = '006_Menu'
      end
      item
        CollectionIndex = 7
        CollectionName = '007_Home'
        Disabled = False
        Name = '007_Home'
      end
      item
        CollectionIndex = 8
        CollectionName = '008_Settings'
        Disabled = False
        Name = '008_Settings'
      end>
    ImageCollection = dmCommon.icDarkIcons
    Left = 404
    Top = 272
  end
end
