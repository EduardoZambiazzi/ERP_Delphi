object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Pedidos'
  ClientHeight = 729
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnShow = FormShow
  TextHeight = 15
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 57
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'pnTop'
    ShowCaption = False
    TabOrder = 0
    object btNovoPedido: TButton
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 124
      Height = 45
      Cursor = crHandPoint
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Novo Pedido'
      HotImageIndex = 0
      ImageIndex = 0
      Images = dmIcones.il_30px
      TabOrder = 0
      OnClick = btNovoPedidoClick
    end
    object editPesquisar: TButtonedEdit
      AlignWithMargins = True
      Left = 137
      Top = 15
      Width = 846
      Height = 25
      Margins.Top = 15
      Margins.Right = 25
      Margins.Bottom = 15
      Align = alClient
      Images = dmIcones.il_20px
      NumbersOnly = True
      RightButton.DisabledImageIndex = 2
      RightButton.HotImageIndex = 2
      RightButton.ImageIndex = 2
      RightButton.PressedImageIndex = 2
      RightButton.Visible = True
      TabOrder = 1
      TextHint = 'Digite o n'#250'mero do pedido para pesquisar'
      OnKeyDown = editPesquisarKeyDown
      OnRightButtonClick = editPesquisarRightButtonClick
    end
  end
  object GridPedidos: TDBGrid
    Left = 0
    Top = 57
    Width = 1008
    Height = 672
    Align = alClient
    DataSource = dsPedidos
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = GridPedidosCellClick
    OnDrawColumnCell = GridPedidosDrawColumnCell
    OnMouseMove = GridPedidosMouseMove
    Columns = <
      item
        Expanded = False
        FieldName = 'numero'
        Title.Caption = 'N'#250'mero'
        Width = 73
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'data_emissao'
        Title.Caption = 'Emiss'#227'o'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'cliente_codigo'
        Title.Caption = 'C'#243'd. Cliente'
        Width = 98
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nome'
        Title.Caption = 'Nome Cliente'
        Width = 441
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'valor_total'
        Title.Caption = 'Valor Total'
        Width = 175
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'editar'
        Title.Caption = ' '
        Width = 26
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'deletar'
        Title.Caption = ' '
        Width = 23
        Visible = True
      end>
  end
  object qrPedidos: TFDQuery
    SQL.Strings = (
      'select '
      '  pedidos_geral.*, '
      '  clientes.nome,'
      '  cast('#39#39' as char(1)) editar,'
      '  cast('#39#39' as char(1)) deletar'
      'from pedidos_geral'
      
        'left join clientes on clientes.codigo = pedidos_geral.cliente_co' +
        'digo')
    Left = 288
    Top = 256
    object qrPedidosnumero: TFDAutoIncField
      FieldName = 'numero'
      Origin = 'numero'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qrPedidosdata_emissao: TDateTimeField
      FieldName = 'data_emissao'
      Origin = 'data_emissao'
      Required = True
    end
    object qrPedidoscliente_codigo: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'cliente_codigo'
      Origin = 'cliente_codigo'
    end
    object qrPedidosvalor_total: TFMTBCDField
      FieldName = 'valor_total'
      Origin = 'valor_total'
      Required = True
      currency = True
      Precision = 18
      Size = 2
    end
    object qrPedidosnome: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome'
      Origin = 'nome'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object qrPedidoseditar: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'editar'
      Origin = 'editar'
      ProviderFlags = []
      ReadOnly = True
      Size = 1
    end
    object qrPedidosdeletar: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'deletar'
      Origin = 'deletar'
      ProviderFlags = []
      ReadOnly = True
      Size = 1
    end
  end
  object dsPedidos: TDataSource
    DataSet = qrPedidos
    Left = 288
    Top = 320
  end
end
