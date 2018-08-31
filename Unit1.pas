unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit,

  System.RegularExpressions, FMX.StdCtrls;

type
  TTipoValidacao = (tvCPF, tvEmail);

const
  {Expressões Regulares}
  C_EXP_CPF        = '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}'     +
                     '[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}'    +
                     '[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})' ;

  C_EXP_EMAIL      = '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*' +
                     '|"((?=[\x01-\x7f])[^"\\]|\\[\x01-\x7f])*"\' +
                     'x20*)*(?<angle><))?((?!\.)(?>\.?[a-zA-Z\d!' +
                     '#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])' +
                     '[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\' +
                     '-]+(?<!-)\.)+[a-zA-Z]{2,}|\[(((?(?<!\[)\.)' +
                     '(25[0-5]|2[0-4]\d|[01]?\d?\d)){4}|[a-zA-Z\' +
                     'd\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|' +
                     '\\[\x01-\x7f])+)\])(?(angle)>)$';

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Line1: TLine;
    Line2: TLine;
    Button1: TButton;
    procedure Edit1ChangeTracking(Sender: TObject);
    procedure Edit2ChangeTracking(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ValidarCampo(const ACampo: TEdit; const ALinha: TLine;
      const ATipoValidacao: TTipoValidacao);
    function ValidaCPF(const ACPF: String): Boolean;
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  if ValidaCPF(Edit1.Text) then
    ShowMessage('CPF válido')
  else
    ShowMessage('CPF inválido');
end;

function TForm1.ValidaCPF(const ACPF: String): Boolean;
Var
  d1, d4, xx, nCount, resto, digito1, digito2: integer;
  Check: String;
Begin
  if (Length(ACPF) <> 11) then
    Exit(False);

  d1 := 0;
  d4 := 0;
  xx := 1;
  for nCount := 1 to Length(ACPF) - 2 do
  begin
    if Pos(Copy(ACPF, nCount, 1), '/-.') = 0 then
    begin
      d1 := d1 + (11 - xx) * StrToInt(Copy(ACPF, nCount, 1));
      d4 := d4 + (12 - xx) * StrToInt(Copy(ACPF, nCount, 1));
      xx := xx + 1;
    end;
  end;
  resto := (d1 mod 11);
  if resto < 2 then
  begin
    digito1 := 0;
  end
  else
  begin
    digito1 := 11 - resto;
  end;
  d4 := d4 + 2 * digito1;
  resto := (d4 mod 11);
  if resto < 2 then
  begin
    digito2 := 0;
  end
  else
  begin
    digito2 := 11 - resto;
  end;
  Check := IntToStr(digito1) + IntToStr(digito2);
  if Check <> Copy(ACPF, succ(Length(ACPF) - 2), 2) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TForm1.Edit1ChangeTracking(Sender: TObject);
begin
  ValidarCampo(Edit1, Line1, tvCPF);
end;

procedure TForm1.Edit2ChangeTracking(Sender: TObject);
begin
  ValidarCampo(Edit2, Line2, tvEmail);
end;

procedure TForm1.ValidarCampo(const ACampo: TEdit; const ALinha: TLine;
  const ATipoValidacao: TTipoValidacao);
begin
  case ATipoValidacao of
    tvCPF :
      begin
        if TEdit(ACampo).Text.Equals(EmptyStr) then
          ALinha.Stroke.Color := TAlphaColors.White
        else if TRegEx.IsMatch(TEdit(ACampo).Text, C_EXP_CPF) then
          ALinha.Stroke.Color := TAlphaColors.Springgreen
        else
          ALinha.Stroke.Color := TAlphaColors.Red;
      end;
    tvEmail :
      begin
        if TEdit(ACampo).Text.Equals(EmptyStr) then
          ALinha.Stroke.Color := TAlphaColors.White
        else if TRegEx.IsMatch(TEdit(ACampo).Text, C_EXP_EMAIL) then
          ALinha.Stroke.Color := TAlphaColors.Springgreen
        else
          ALinha.Stroke.Color := TAlphaColors.Red;
      end;
  end;
end;

end.
