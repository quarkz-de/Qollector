object frNoteFrame: TfrNoteFrame
  Left = 0
  Top = 0
  Width = 501
  Height = 362
  TabOrder = 0
  object pcNote: TPageControl
    Left = 0
    Top = 0
    Width = 501
    Height = 362
    ActivePage = tsView
    Align = alClient
    TabOrder = 0
    OnChange = pcNoteChange
    object tsEdit: TTabSheet
      Caption = 'Bearbeiten'
      object edText: TSynEdit
        Left = 0
        Top = 0
        Width = 493
        Height = 334
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
        Width = 493
        Height = 334
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
        Top = 0
        Width = 493
        Height = 334
        Align = alClient
        BorderStyle = bsNone
        DefaultNodeHeight = 19
        Header.AutoSizeIndex = 1
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Images = dmCommon.vilIcons
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
        OnDblClick = stLinksDblClick
        OnDragOver = stLinksDragOver
        OnDragDrop = stLinksDragDrop
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
            Width = 293
          end>
      end
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
end
