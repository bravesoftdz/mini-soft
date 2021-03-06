{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用函数定义单元
*******************************************************************************}
unit USysFun;

interface

uses
  Windows, Classes, ComCtrls, Forms, SysUtils, IniFiles, TypInfo, ULibFun,
  USysConst;

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//在状态栏显示信息

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure LoadSysParameter(const nIni: TIniFile = nil);
//载入系统配置参数

procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
//载入列表表头宽度
function MakeListViewColumnInfo(const nLv: TListView): string;
//组合列表表头宽度信息

procedure GetOrdTypeInfo(nTypeInfo: PTypeInfo; nList: TStrings);
//获取序列类型运行时信息

implementation

//---------------------------------- 配置运行环境 ------------------------------
//Date: 2007-01-09
//Desc: 初始化运行环境
procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: 载入系统配置参数
procedure LoadSysParameter(const nIni: TIniFile = nil);
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    with gSysParam, nTmp do
    begin
      FProgID := ReadString(sConfigSec, 'ProgID', sProgID);
      //程序标识决定以下所有参数
      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;

  nTmp := TIniFile.Create(gPath + sDBConfig);
  try
    with gSysParam, nTmp do
    begin
      FTableEntity := ReadString(sTableSec, 'TableEntity', sTable_Entity);
      FTableDict := ReadString(sTableSec, 'TableDictItem', sTable_Dict);
    end;
  finally
    nTmp.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 在全局状态栏最后一个Panel上显示nMsg消息
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: 在索引nIdx的Panel上显示nMsg消息
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > nIdx) and
     (nIdx > -1) then
  begin
    gStatusBar.Panels[nIdx].Text := nMsg;
    gStatusBar.Panels[nIdx].Width := gStatusBar.Canvas.TextWidth(nMsg) + 20;
    Application.ProcessMessages;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2007-11-30
//Parm: 宽度信息;列表
//Desc: 载入nList的表头宽度
procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
var nList: TStrings;
    i,nCount: integer;
begin
  if nLv.Columns.Count > 0 then
  begin
    nList := TStringList.Create;
    try
      if SplitStr(nWidths, nList, nLv.Columns.Count, ';') And
         (nLv.Columns.Count = nList.Count) then
      begin
        nCount := nList.Count - 1;
        for i:=0 to nCount do
         if IsNumber(nList[i], False) then
          nLv.Columns[i].Width := StrToInt(nList[i]);
      end;
    finally
      nList.Free;
    end;
  end;
end;

//Date: 2007-11-30
//Parm: 列表
//Desc: 组合nLv的表头宽度信息
function MakeListViewColumnInfo(const nLv: TListView): string;
var i,nCount: integer;
begin
  Result := '';
  nCount := nLv.Columns.Count - 1;

  for i:=0 to nCount do
  if i = nCount then
       Result := Result + IntToStr(nLv.Columns[i].Width)
  else Result := Result + IntToStr(nLv.Columns[i].Width) + ';';
end;

//Desc: 获取nTypeInfo的运行时数据,存入nList中
procedure GetOrdTypeInfo(nTypeInfo: PTypeInfo; nList: TStrings);
var nIdx: integer;
    nData: PTypeData;
begin
  nList.Clear;
  nData := GetTypeData(nTypeInfo);

  if nTypeInfo^.Kind = tkEnumeration then
   for nIdx:=nData^.MinValue to nData^.MaxValue do
    nList.Add(Format('%d=%d.%s', [nIdx, nIdx, GetEnumName(nTypeInfo, nIdx)]));
end;

end.


