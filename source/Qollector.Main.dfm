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
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mmMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object svBereiche: TSplitView
    Left = 0
    Top = 0
    Width = 150
    Height = 537
    OpenedWidth = 150
    Placement = svpLeft
    TabOrder = 0
    OnResize = svBereicheResize
    object catBereiche: TCategoryButtons
      Left = 0
      Top = -20
      Width = 150
      Height = 177
      BorderStyle = bsNone
      ButtonFlow = cbfVertical
      ButtonHeight = 40
      ButtonWidth = 100
      ButtonOptions = [boFullSize, boShowCaptions, boCaptionOnlyBorder]
      Categories = <
        item
          Color = clNone
          Collapsed = False
          Items = <
            item
              Action = acBereichNotizen
            end
            item
              Action = acBereichFavoriten
            end
            item
              Action = acBereichLesezeichen
            end>
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      HotButtonColor = 12477460
      Images = dmCommon.vilLargeIcons
      RegularButtonColor = clNone
      SelectedButtonColor = clNone
      TabOrder = 0
    end
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
    object acBereichNotizen: TAction
      Category = 'Bereiche'
      Caption = 'Notizen'
      ImageIndex = 0
      ImageName = 'icons8_copybook_96px'
    end
    object acBereichFavoriten: TAction
      Category = 'Bereiche'
      Caption = 'Favoriten'
      ImageIndex = 2
      ImageName = 'icons8_window_favorite_96px'
    end
    object acBereichLesezeichen: TAction
      Category = 'Bereiche'
      Caption = 'Lesezeichen'
      ImageIndex = 1
      ImageName = 'icons8_bookmark_book_96px'
    end
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
