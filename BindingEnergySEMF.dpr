program BindingEnergySEMF;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Fisika Inti';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.