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
  end
end
