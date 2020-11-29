object frNoteFrame: TfrNoteFrame
  Left = 0
  Top = 0
  Width = 871
  Height = 543
  TabOrder = 0
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
    ActivePage = tsLinks
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
        Top = 22
        Width = 633
        Height = 475
        Align = alClient
        BorderStyle = bsNone
        DefaultNodeHeight = 19
        Header.AutoSizeIndex = 1
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Images = dmCommon.vilIcons
        PopupMenu = pmLinks
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
        OnDblClick = stLinksDblClick
        OnDragOver = stLinksDragOver
        OnDragDrop = stLinksDragDrop
        OnFocusChanged = stLinksFocusChanged
        OnKeyDown = stLinksKeyDown
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
      object tbBookmarks: TToolBar
        Left = 0
        Top = 0
        Width = 633
        Height = 22
        Caption = 'tbBookmarks'
        Images = dmCommon.vilIcons
        List = True
        TabOrder = 1
        object tbNewBookmark: TToolButton
          Left = 0
          Top = 0
          Action = acNewBookmark
        end
        object tbNewFavorite: TToolButton
          Left = 23
          Top = 0
          Action = acNewFavorite
        end
        object btEditLink: TToolButton
          Left = 46
          Top = 0
          Action = acEditLink
        end
        object btDeleteLink: TToolButton
          Left = 69
          Top = 0
          Action = acDeleteLink
        end
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
      object tbNotes: TToolBar
        Left = 123
        Top = 0
        Width = 98
        Height = 31
        Align = alRight
        ButtonHeight = 32
        ButtonWidth = 32
        Caption = 'tbNotes'
        Images = dmCommon.vilIcons
        TabOrder = 0
        object tbNewNotebook: TToolButton
          Left = 0
          Top = 0
          Action = acNewNotebook
        end
        object tbNewNote: TToolButton
          Left = 32
          Top = 0
          Action = acNewNote
        end
        object tbDeleteItem: TToolButton
          Left = 64
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
      Images = dmCommon.vilIcons
      PopupMenu = pmNotes
      TabOrder = 1
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
  object alActions: TActionList
    Images = dmCommon.vilIcons
    Left = 324
    Top = 212
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
  object pmNotes: TPopupMenu
    Images = dmCommon.vilIcons
    Left = 408
    Top = 212
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
    Images = dmCommon.vilIcons
    Left = 480
    Top = 212
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
end
