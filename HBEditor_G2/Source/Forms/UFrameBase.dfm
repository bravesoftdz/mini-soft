object fFrameBase: TfFrameBase
  Left = 0
  Top = 0
  Width = 597
  Height = 158
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Group1: TGroupBox
    Left = 12
    Top = 12
    Width = 220
    Height = 137
    Caption = #21306#22495#23646#24615
    TabOrder = 0
    object Edit_Name: TLabeledEdit
      Left = 56
      Top = 30
      Width = 155
      Height = 20
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #21517#31216':'
      LabelPosition = lpLeft
      MaxLength = 15
      TabOrder = 0
      OnExit = Edit_NameExit
      OnKeyPress = Edit_NameKeyPress
    end
    object Edit_X: TLabeledEdit
      Left = 56
      Top = 62
      Width = 50
      Height = 20
      EditLabel.Width = 36
      EditLabel.Height = 12
      EditLabel.Caption = #36215#28857'x:'
      LabelPosition = lpLeft
      MaxLength = 5
      TabOrder = 1
      OnExit = Edit_XExit
      OnKeyPress = Edit_XKeyPress
    end
    object Edit_Y: TLabeledEdit
      Left = 56
      Top = 95
      Width = 50
      Height = 20
      EditLabel.Width = 36
      EditLabel.Height = 12
      EditLabel.Caption = #36215#28857'y:'
      LabelPosition = lpLeft
      MaxLength = 5
      TabOrder = 3
      OnExit = Edit_XExit
      OnKeyPress = Edit_XKeyPress
    end
    object Edit_H: TLabeledEdit
      Left = 155
      Top = 62
      Width = 50
      Height = 20
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #39640#24230':'
      LabelPosition = lpLeft
      MaxLength = 5
      TabOrder = 2
      OnExit = Edit_XExit
      OnKeyPress = Edit_XKeyPress
    end
    object Edit_W: TLabeledEdit
      Left = 155
      Top = 95
      Width = 50
      Height = 20
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #23485#24230':'
      LabelPosition = lpLeft
      MaxLength = 5
      TabOrder = 4
      OnExit = Edit_XExit
      OnKeyPress = Edit_XKeyPress
    end
  end
end
