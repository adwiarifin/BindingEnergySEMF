unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Math, TeeProcs, TeEngine, Chart, DB,
  DBCtrls, DbChart, ADODB, Series, BubbleCh;

type
  TForm1 = class(TForm)
    lbAtom: TLabel;
    Memo1: TMemo;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DBChart1: TDBChart;
    DataSource1: TDataSource;
    DBLookupListBox1: TDBLookupListBox;
    ADOQuery1: TADOQuery;
    Series2: TLineSeries;
    Series1: TPointSeries;
    procedure DBLookupListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBChart1Click(Sender: TObject);
  private
    { Private declarations }
    function volume(varA: Real): real;
    function surface(varA: Real): real;
    function coulomb(varA: Real; varZ: integer): real;
    function asymmetry(varA: Real; varZ: integer): real;
    function pairing(varA: Real; varZ: integer): real;
    function getSEMF(varA: Real; varZ: Integer): real;
    procedure generateChart();
  public
    { Public declarations }
    Z: Integer;
    A: Real;
  end;

const
  av = 15.5;
  ass = 17.8;
  ac = 0.691;
  aa = 23;
  ap = 34;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.volume(varA: Real): real;
var output: real;
begin
  output := av * varA;
  volume := output;
  Memo1.Lines.Add('Volume      : '+FloatToStr(output));
end;

function TForm1.surface(varA: Real): real;
var output: real;
begin
  output := ass * power(varA, 2/3);
  surface := output;
  Memo1.Lines.Add('Surface     : '+FloatToStr(output));
end;

function TForm1.coulomb(varA: Real; varZ: integer): real;
var output: real;
begin
  output := ac * varZ * (varZ - 1) * power(varA,-1/3);
  coulomb := output;
  Memo1.Lines.Add('Coulomb    : '+FloatToStr(output));
end;

function TForm1.asymmetry(varA: Real; varZ: integer): real;
var output: real;
begin
  output := ass * power(varA-2*varZ,2) / varA;
  asymmetry := output;
  Memo1.Lines.Add('Asymmetry : '+FloatToStr(output));
end;

function TForm1.getSEMF(varA: Real; varZ: Integer): real;
var output: real;
begin
  output := volume(A) - surface(A) - coulomb(A,Z) - asymmetry(A,Z) + pairing(A,Z);
  getSEMF := output;
end;

procedure TForm1.generateChart;
var SEMF: real;
begin
  DBChart1.Series[0].Clear;
  ADOTable1.First;

  while not ADOTable1.Eof do
  begin
    Z := ADOTable1.FieldByName('Z').AsInteger;
    A := ADOTable1.FieldByName('A').AsFloat;
    SEMF := getSEMF(A,Z);
    DBChart1.Series[0].AddXY(A, SEMF/A);
    ADOTable1.Next;
  end;
end;

function TForm1.pairing(varA: Real; varZ: integer): real;
var p,n,pm,nm: integer;
    output: real;
begin
  p := varZ;
  n := (floor(varA) - varZ);
  pm := p mod 2;
  nm := n mod 2;
  Memo1.Lines.Add('Proton       : '+IntToStr(p));
  Memo1.Lines.Add('Netron       : '+IntToStr(n));
  if(pm <> nm) then
    output := 0
  else
    output := ap * power(varA, -3/4);
  if(pm = 1) then
    output := -output;
  pairing := output;
  Memo1.Lines.Add('Pairing       : '+FloatToStr(output));
end;

procedure TForm1.DBLookupListBox1Click(Sender: TObject);
var id: integer;
    SEMF: real;
begin
  id := DBLookupListBox1.KeyValue;
  ADOQuery1.SQL.Text := 'SELECT A,Z FROM Atom WHERE ID = '+IntToStr(id);
  ADOQuery1.Active := true;

  A := ADOQuery1.FieldByName('A').AsFloat;
  Z := ADOQuery1.FieldByName('Z').AsInteger;

  Memo1.Lines.Clear;
  Memo1.Lines.Add('Nomor Atom       : '+IntToStr(Z));
  Memo1.Lines.Add('Nomor Massa     : '+FloatToStr(A));
  SEMF := getSEMF(A,Z);
  Memo1.Lines.Add('SEMF        : '+FloatToStr(SEMF));
  Memo1.Lines.Add('B/A           : '+FloatToStr(SEMF/A));

  DBChart1.Series[1].Clear;
  DBChart1.Series[1].AddXY(A,SEMF/A);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  generateChart;
  Memo1.Lines.Clear;
end;

procedure TForm1.DBChart1Click(Sender: TObject);
begin
  ShowMessage('Program ini dibugat dalam rangka iseng-iseng bersama Sahori setelah mengerjakan tugas orang.. :)');
end;

end.
