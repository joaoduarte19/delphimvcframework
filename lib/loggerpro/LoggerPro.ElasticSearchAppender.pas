// *************************************************************************** }
//
// LoggerPro
//
// Copyright (c) 2010-2025 Daniele Teti
//
// https://github.com/danieleteti/loggerpro
//
// ***************************************************************************
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ***************************************************************************

unit LoggerPro.ElasticSearchAppender;

interface

uses
  LoggerPro,
  System.SysUtils,
  LoggerPro.RESTAppender;

type

  {
    Log appender for an ElasticSearch 6.4+ endpoint
    Author: Daniele Teti (https://github.com/danieleteti/) and Salvatore Sparacino
  }

  TLoggerProElasticSearchAppender = class(TLoggerProRESTAppender)
  public
    constructor Create(aElasticHost: string; aElasticPort: integer;
      aElasticIndex: string); reintroduce;
    destructor Destroy; override;
    procedure Setup; override;
    procedure TearDown; override;
    procedure TryToRestart(var Restarted: Boolean); override;
    procedure WriteLog(const aLogItem: TLogItem); override;
  end;

implementation

uses
  System.Json,
  System.DateUtils,
  System.Classes;

{ TLoggerProElasticSearchAppender }

constructor TLoggerProElasticSearchAppender.Create(aElasticHost: string;
  aElasticPort: integer; aElasticIndex: string);
var
  lUrl: string;
begin
  lUrl := Format('%s:%d/%s/_doc', [aElasticHost, aElasticPort, aElasticIndex.ToLower]);
  inherited Create(lUrl, 'application/json');
end;

destructor TLoggerProElasticSearchAppender.Destroy;
begin
  inherited;
end;

procedure TLoggerProElasticSearchAppender.Setup;
begin
  inherited;
end;

procedure TLoggerProElasticSearchAppender.TearDown;
begin
  inherited;
end;

procedure TLoggerProElasticSearchAppender.TryToRestart(var Restarted: Boolean);
begin
  inherited;
  Restarted := True;
end;

procedure TLoggerProElasticSearchAppender.WriteLog(const aLogItem: TLogItem);
var
  lRequestBody: TStringStream;
  lJSON: TJSONObject;
begin
  lJSON := TJSONObject.Create;
  try
    lJSON.AddPair('log_tag', TJSONString.Create(aLogItem.LogTag));
    lJSON.AddPair('log_level', TJSONString.Create(aLogItem.LogTypeAsString));
    lJSON.AddPair('log_message', TJSONString.Create(aLogItem.LogMessage));
    lJSON.AddPair('log_datetime', TJSONString.Create(DateToISO8601(aLogItem.TimeStamp)));
    lJSON.AddPair('timestamp', TJSONString.Create(DateToISO8601(aLogItem.TimeStamp)));

    lRequestBody := TStringStream.Create(lJSON.ToString);
    try
      InternalWriteLog(GetRESTUrl, aLogItem, lRequestBody);
    finally
      lRequestBody.Free
    end;
  finally
    lJSON.Free;
  end;
end;

end.
