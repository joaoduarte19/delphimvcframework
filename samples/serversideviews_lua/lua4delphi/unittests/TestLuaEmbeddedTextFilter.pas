unit TestLuaEmbeddedTextFilter;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework,
  System.Classes,
  TestLuaWrapper,
  System.SysUtils,
  LuaBind,
  LuaBind.Intf,
  System.Rtti;

type
  TTestEmbeddedTextFilter = class(TTestCase)
  strict private
    FLuaEngine: TLuaEngine;

  public
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure TestDoAllTests;
    procedure TestHelperExecAndGet01;
    procedure TestHelperExecAndGetMultiThread;
  end;

implementation

uses
  System.IOUtils,
  LuaBind.Filters.Text,
  System.Generics.collections,
  System.Types;

{ TTestEmbeddedTextFilter }

procedure TTestEmbeddedTextFilter.SetUp;
begin
  inherited;
  FLuaEngine := TLuaEngine.Create;
end;

procedure TTestEmbeddedTextFilter.TearDown;
begin
  FLuaEngine.Free;
  inherited;
end;

procedure TTestEmbeddedTextFilter.TestDoAllTests;
var
  luafiles: TStringDynArray;
  f       : string;
  Filter  : TLuaEmbeddedTextFilter;
begin
  luafiles := TDirectory.GetFiles('embeddedtextfiltertests', '*.elua');
  TArray.Sort<string>(luafiles);
  for f in luafiles do
  begin
    Filter := TLuaEmbeddedTextFilter.Create;
    try
      Filter.OutputFunction := 'io.write';
      Filter.TemplateCode := TFile.ReadAllText(f);
      Filter.Execute;
      TFile.WriteAllText(ChangeFileExt(f, '.lua'), Filter.LuaCode);
      try
        FLuaEngine.LoadScript(Filter.LuaCode);
        FLuaEngine.Execute; // only check if is ok the syntax
      except
        on E: Exception do
        begin
          Fail('File ' + f + ' - ' + E.Message);
        end;
      end;
    finally
      Filter.Free;
    end;
  end;
end;

procedure TTestEmbeddedTextFilter.TestHelperExecAndGet01;
var
  r: string;
begin
  r := TLuaEmbeddedTextFilter.ExecuteWithResult('hello',
    ['nome', 'cognome'],
    ['Daniele', 'Teti']);
  CheckEquals('hello', r);

  r := TLuaEmbeddedTextFilter.ExecuteWithResult('Hello <?lua=nome ?>,<?lua=cognome ?>, how are you?',
    ['nome', 'cognome'],
    ['Daniele', 'Teti']);
  CheckEquals('Hello Daniele,Teti, how are you?', r);

  r := TLuaEmbeddedTextFilter.ExecuteWithResult
    ('Hello <?lua=nome ?>,<?lua=cognome ?>, <?lua for i=1,100 do _out("*") end?> how are you?',
    ['nome', 'cognome'],
    ['Daniele', 'Teti']);
  CheckEquals('Hello Daniele,Teti, ' +
    StringOfChar('*', 100)
    + ' how are you?', r)
end;

procedure TTestEmbeddedTextFilter.TestHelperExecAndGetMultiThread;
var
  p         : TProc;
  t1        : TThread;
  I         : Integer;
  ThreadList: TList<TThread>;
  ooo       : string;
begin
  p :=
    procedure
    var
      r: string;
    begin
      r := TLuaEmbeddedTextFilter.ExecuteWithResult
        ('Hello <?lua=nome ?>,<?lua=cognome ?>, <?lua for i=1,100 do _out("*") end?> how are you?',
        ['nome', 'cognome'],
        ['Daniele', 'Teti']);
      TThread.Synchronize(nil,
        procedure
        begin
          ooo := ooo +
            BoolToStr('Hello Daniele,Teti, ' +
            StringOfChar('*', 100)
            + ' how are you?' = r)[1];
        end);
    end;
  ooo := '';
  ThreadList := TList<TThread>.Create;
  try
    for I := 1 to 50 do
    begin
      t1 := TThread.CreateAnonymousThread(p);
      t1.FreeOnTerminate := false;
      t1.Start;
      ThreadList.Add(t1);
    end;

    while ThreadList.Count > 0 do
    begin
      ThreadList[0].WaitFor;
      ThreadList[0].Free;
      ThreadList.Delete(0);
    end;
    CheckEquals(StringOfChar('T', 50), ooo);
  finally
    ThreadList.Free;
  end;
end;

initialization

// Register any test cases with the test runner
RegisterTest(TTestEmbeddedTextFilter.Suite);

end.