object frmEditarPedido: TfrmEditarPedido
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Editar pedido'
  ClientHeight = 680
  ClientWidth = 974
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  WindowState = wsMaximized
  OnShow = FormShow
  TextHeight = 15
  object pnCliente: TPanel
    Left = 0
    Top = 0
    Width = 974
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnCliente'
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object Label1: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 37
      Height = 38
      Margins.Left = 10
      Align = alLeft
      Caption = 'Cliente'
      Layout = tlCenter
    end
    object cbCliente: TComboBox
      AlignWithMargins = True
      Left = 55
      Top = 10
      Width = 354
      Height = 23
      Margins.Left = 5
      Margins.Top = 10
      Margins.Bottom = 15
      Align = alLeft
      TabOrder = 0
      TextHint = 'Nenhum cliente selecionado'
      OnChange = cbClienteChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 974
    Height = 639
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 353
      Height = 639
      Align = alLeft
      BevelEdges = [beLeft, beTop, beBottom]
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = 'Panel2'
      Color = clWhite
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
      object lbNomeProduto: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 67
        Width = 331
        Height = 21
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object TLabel
        AlignWithMargins = True
        Left = 10
        Top = 91
        Width = 331
        Height = 17
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        Caption = 'Valor Unit'#225'rio'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object TLabel
        AlignWithMargins = True
        Left = 10
        Top = 153
        Width = 331
        Height = 17
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        Caption = 'Quantidade'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lbTotal: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 279
        Width = 331
        Height = 54
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Align = alTop
        Alignment = taRightJustify
        Caption = '0,00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -40
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object TLabel
        AlignWithMargins = True
        Left = 10
        Top = 252
        Width = 331
        Height = 17
        Margins.Left = 10
        Margins.Top = 40
        Margins.Right = 10
        Align = alTop
        Caption = 'Total'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object editCodigo: TLabeledEdit
        AlignWithMargins = True
        Left = 10
        Top = 25
        Width = 331
        Height = 36
        Hint = 'Digite o c'#243'digo do produto e pressione enter'
        Margins.Left = 10
        Margins.Top = 25
        Margins.Right = 10
        Align = alTop
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        EditLabel.Width = 85
        EditLabel.Height = 15
        EditLabel.Caption = 'C'#243'digo Produto'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        NumbersOnly = True
        ParentFont = False
        TabOrder = 0
        Text = ''
        TextHint = 'Digite o c'#243'digo do produto e pressione enter'
        OnKeyPress = edCodigoProdutoKeyPress
      end
      object editQuantidade: TEdit
        AlignWithMargins = True
        Left = 10
        Top = 173
        Width = 331
        Height = 36
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        Alignment = taRightJustify
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = '0,00'
        OnExit = editQuantidadeExit
      end
      object editValorUnitario: TEdit
        AlignWithMargins = True
        Left = 10
        Top = 111
        Width = 331
        Height = 36
        Margins.Left = 10
        Margins.Right = 10
        TabStop = False
        Align = alTop
        Alignment = taRightJustify
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        Text = '0,00'
      end
      object btnAdicionarItem: TButton
        AlignWithMargins = True
        Left = 70
        Top = 383
        Width = 211
        Height = 48
        Cursor = crHandPoint
        Margins.Left = 70
        Margins.Top = 50
        Margins.Right = 70
        Align = alTop
        Caption = 'Adicionar Item'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        HotImageIndex = 1
        ImageIndex = 1
        ImageMargins.Left = 30
        Images = dmIcones.il_30px
        ParentFont = False
        TabOrder = 2
        OnClick = btnAdicionarItemClick
      end
    end
    object Panel3: TPanel
      Left = 353
      Top = 0
      Width = 621
      Height = 639
      Align = alClient
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 1
      object Panel4: TPanel
        Left = 0
        Top = 576
        Width = 617
        Height = 59
        Align = alBottom
        BevelEdges = [beRight, beBottom]
        BevelOuter = bvNone
        Caption = 'Panel4'
        Color = clWhite
        ParentBackground = False
        ShowCaption = False
        TabOrder = 0
        object btSalvarPedido: TButton
          AlignWithMargins = True
          Left = 404
          Top = 5
          Width = 203
          Height = 49
          Cursor = crHandPoint
          Margins.Top = 5
          Margins.Right = 10
          Margins.Bottom = 5
          Align = alRight
          Caption = 'Salvar Pedido'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          HotImageIndex = 1
          ImageIndex = 1
          ImageMargins.Left = 30
          Images = dmIcones.il_30px
          ParentFont = False
          TabOrder = 0
          OnClick = btSalvarPedidoClick
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 617
        Height = 576
        Align = alClient
        BevelEdges = [beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'Panel4'
        ShowCaption = False
        TabOrder = 1
        object gridProdutos: TStringGrid
          Left = 0
          Top = 0
          Width = 617
          Height = 515
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
          TabOrder = 0
          OnKeyDown = gridProdutosKeyDown
          ColWidths = (
            67
            216
            85
            97
            132)
        end
        object Panel6: TPanel
          Left = 0
          Top = 515
          Width = 617
          Height = 59
          Align = alBottom
          BevelEdges = [beRight, beBottom]
          BevelOuter = bvNone
          Caption = 'Panel4'
          Color = clWhite
          ParentBackground = False
          ShowCaption = False
          TabOrder = 1
          object lbTotalPedido: TLabel
            AlignWithMargins = True
            Left = 238
            Top = 10
            Width = 369
            Height = 49
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Align = alRight
            Alignment = taRightJustify
            AutoSize = False
            Caption = '0,00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -40
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object TLabel
            Left = 0
            Top = 0
            Width = 218
            Height = 59
            Margins.Left = 10
            Margins.Top = 40
            Margins.Right = 10
            Align = alLeft
            Caption = 'Total Pedido'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -40
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
        end
      end
    end
  end
end
