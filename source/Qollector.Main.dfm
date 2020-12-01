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
  ShowHint = True
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
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
  object svSplitView: TSplitView
    Left = 0
    Top = 30
    Width = 200
    Height = 527
    CloseStyle = svcCompact
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 1
    object pnHeader: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object imBurgerButton: TVirtualImage
        Left = 8
        Top = 6
        Width = 32
        Height = 32
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 6
        OnClick = imBurgerButtonClick
      end
      object txHeaderText: TLabel
        Left = 52
        Top = 12
        Width = 64
        Height = 21
        Caption = 'Qollector'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object txVersion: TLabel
        Left = 136
        Top = 16
        Width = 17
        Height = 17
        Caption = '1.0'
      end
    end
    object pnNavigation: TPanel
      Left = 0
      Top = 45
      Width = 200
      Height = 482
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object sbStart: TSpeedButton
        Left = 0
        Top = 0
        Width = 200
        Height = 38
        Action = acSectionWelcome
        Align = alTop
        GroupIndex = 1
        Down = True
        Images = dmCommon.vilLargeIcons
        Margin = 14
        ExplicitTop = -6
      end
      object sbNotes: TSpeedButton
        Left = 0
        Top = 38
        Width = 200
        Height = 38
        Action = acSectionNotes
        Align = alTop
        GroupIndex = 1
        Images = dmCommon.vilLargeIcons
        Margin = 14
        ExplicitTop = 4
      end
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
                Action = acHelpAbout
              end>
            Caption = '&Hilfe'
          end>
        ActionBar = mbMain
      end>
    Images = dmCommon.vilIcons
    Left = 416
    Top = 36
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
  end
end
