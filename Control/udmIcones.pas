unit udmIcones;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls;

type
  TdmIcones = class(TDataModule)
    il_30px: TImageList;
    il_20px: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmIcones: TdmIcones;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
