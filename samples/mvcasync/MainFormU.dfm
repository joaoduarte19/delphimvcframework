object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MVCAsync Sample'
  ClientHeight = 181
  ClientWidth = 693
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object btnAsync1: TButton
    Left = 16
    Top = 16
    Width = 161
    Height = 41
    Caption = 'Async Test'
    TabOrder = 0
    OnClick = btnAsync1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 72
    Width = 161
    Height = 23
    TabOrder = 1
    Text = 'Edit1'
  end
  object btnWithEx: TButton
    Left = 504
    Top = 63
    Width = 161
    Height = 41
    Caption = 'Async Test With Custom Exception Handler'
    TabOrder = 2
    WordWrap = True
    OnClick = btnWithExClick
  end
  object btnWithExcDefault: TButton
    Left = 504
    Top = 16
    Width = 161
    Height = 41
    Caption = 'Async Test With Default Exception Handler'
    TabOrder = 3
    WordWrap = True
    OnClick = btnWithExcDefaultClick
  end
  object btnTestWithObject: TButton
    Left = 183
    Top = 16
    Width = 161
    Height = 41
    Caption = 'Async Test with Object'
    TabOrder = 4
    OnClick = btnTestWithObjectClick
  end
  object Memo1: TMemo
    Left = 183
    Top = 72
    Width = 161
    Height = 101
    Lines.Strings = (
      'Memo1')
    TabOrder = 5
  end
end
