unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MVCFramework.AsyncTask, Vcl.StdCtrls;

type
  TMainForm = class(TForm)
    btnAsync1: TButton;
    Edit1: TEdit;
    btnWithEx: TButton;
    btnWithExcDefault: TButton;
    btnTestWithObject: TButton;
    Memo1: TMemo;
    procedure btnAsync1Click(Sender: TObject);
    procedure btnWithExClick(Sender: TObject);
    procedure btnWithExcDefaultClick(Sender: TObject);
    procedure btnTestWithObjectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btnAsync1Click(Sender: TObject);
begin
  btnAsync1.Enabled := False;
  MVCAsync.Run<String>(
    function: String
    begin
      Sleep(1000);
      Result := DateTimeToStr(Now);
    end,
    procedure(const Value: String)
    begin
      Edit1.Text := Value;
      btnAsync1.Enabled := True;
    end
  );
end;

procedure TMainForm.btnWithExClick(Sender: TObject);
begin
  var lSavedCaption := btnWithEx.Caption;
  btnWithEx.Caption := 'processing...';
  btnWithEx.Enabled := False;
  MVCAsync.Run<String>(
    function: String                              { background thread }
    begin
      Sleep(1000);
      raise Exception.Create('BOOOM!');
    end,
    procedure(const Value: String)                { main thread }
    begin
      //never called
    end,
    procedure(const Expt: Exception)              { main thread }
    begin
      ShowMessage(Expt.Message);
    end,
    procedure                                     { main thread }
    begin
      // always executed
      btnWithEx.Caption := lSavedCaption;
      btnWithEx.Enabled := True;
      btnWithEx.Update;
    end
  );
end;

procedure TMainForm.btnTestWithObjectClick(Sender: TObject);
begin
  btnTestWithObject.Enabled := False;
  MVCAsyncObject.Run<TStringList>(
    function: TStringList
    begin
      Sleep(1000);
      Result := TStringList.Create;
      Result.AddStrings(['hello','world']);
    end,
    procedure(const Value: TStringList)
    begin
      Memo1.Lines.Assign(Value);
      btnTestWithObject.Enabled := True;
    end
  );
end;

procedure TMainForm.btnWithExcDefaultClick(Sender: TObject);
begin
  var lSavedCaption := btnWithExcDefault.Caption;
  btnWithExcDefault.Caption := 'processing...';
  btnWithExcDefault.Enabled := False;
  MVCAsync.Run<String>(
    function: String
    begin
      Sleep(1000);
      raise Exception.Create('BOOOM!');
    end,
    procedure(const Value: String)
    begin
      //never called
    end,
    nil, //there isn't a exception handler - the default one is used
    procedure
    begin
      // always executed
      btnWithExcDefault.Caption := lSavedCaption;
      btnWithExcDefault.Enabled := True;
      btnWithExcDefault.Update;
    end
  );
end;

end.
