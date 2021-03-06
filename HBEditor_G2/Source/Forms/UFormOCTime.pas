{*******************************************************************************
  作者: dmzn@163.com 2009-11-10
  描述: 设置自动开关屏幕
*******************************************************************************}
unit UFormOCTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ULibFun, UDataModule, USysConst, UProtocol, StdCtrls, Mask, UMgrLang;

type
  TfFormOCTime = class(TForm)
    GroupBox1: TGroupBox;
    BtnTest: TButton;
    BtnExit: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EditScreen: TComboBox;
    EditDevice: TComboBox;
    GroupBox2: TGroupBox;
    Check1: TCheckBox;
    Label3: TLabel;
    EditStart: TMaskEdit;
    EditEnd: TMaskEdit;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure EditScreenChange(Sender: TObject);
    procedure BtnTestClick(Sender: TObject);
    procedure Check1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowOCTimeForm: Boolean;
//入口函数

implementation

{$R *.dfm}

//Desc: 屏幕自动开关窗口
function ShowOCTimeForm: Boolean;
begin
  with TfFormOCTime.Create(Application) do
  begin
    Caption := ML('开关屏幕');
    Result := ShowModal = mrOk;
    Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormOCTime.FormCreate(Sender: TObject);
var i,nCount: integer;
    nItem: PScreenItem;
begin
  LoadFormConfig(Self);
  gMultiLangManager.SectionID := Name;
  gMultiLangManager.TranslateAllCtrl(Self);
  
  EditScreen.Clear;
  nCount := gScreenList.Count - 1;

  for i:=0 to nCount do
  begin
    nItem := gScreenList[i];
    EditScreen.Items.Add(Format('%d-%s', [nItem.FID, nItem.FName]));
  end;

  if EditScreen.Items.Count > 0 then
  begin
    EditScreen.ItemIndex := 0;
    EditScreenChange(nil);
  end;
end;

procedure TfFormOCTime.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormOCTime.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Desc: 读取设备号
procedure TfFormOCTime.EditScreenChange(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nItem: PScreenItem;
begin
  EditDevice.Clear;
  if EditScreen.ItemIndex < 0 then Exit;

  EditDevice.Items.Add(ML('全部设备'));
  nItem := gScreenList[EditScreen.ItemIndex];

  for nIdx:=Low(nItem.FDevice) to High(nItem.FDevice) do
  begin
    nStr := Format('%d-%s', [nItem.FDevice[nIdx].FID, nItem.FDevice[nIdx].FName]);
    EditDevice.Items.Add(nStr);
  end;

  EditDevice.ItemIndex := 0;
end;

procedure TfFormOCTime.Check1Click(Sender: TObject);
begin
  EditStart.Enabled := Check1.Checked;
  EditEnd.Enabled := Check1.Checked;
end;

//Desc: 测试
procedure TfFormOCTime.BtnTestClick(Sender: TObject);
var nStr: string;
    nPos: Integer;
    nItem: PScreenItem;
    nData: THead_Send_OCTime;
    nRespond: THead_Respond_OCTime;
begin
  if EditScreen.ItemIndex < 0 then
  begin
    EditScreen.SetFocus;
    ShowMsg(ML('请选择待设置的屏幕'), sHint); Exit;
  end;

  nItem := gScreenList[EditScreen.ItemIndex];
  FillChar(nData, cSize_Head_Send_OCTime, #0);

  if Check1.Checked then
  try
    nStr := EditStart.Text;
    nPos := Pos(':', nStr);

    nData.FTimeBegin[0] := StrToInt(Copy(nStr, 1, nPos - 1));
    System.Delete(nStr, 1, nPos);
    nData.FTimeBegin[1] := StrToInt(nStr);
  except
    EditStart.SetFocus;
    ShowMsg(ML('请输入有效的起始时间'), sHint); Exit;
  end;

  if Check1.Checked then
  try
    nStr := EditEnd.Text;
    nPos := Pos(':', nStr);

    nData.FTimeEnd[0] := StrToInt(Copy(nStr, 1, nPos - 1));
    System.Delete(nStr, 1, nPos);
    nData.FTimeEnd[1] := StrToInt(nStr);
  except
    EditEnd.SetFocus;
    ShowMsg(ML('请输入有效的结束时间'), sHint); Exit;
  end;

  nData.FHead := Swap(cHead_DataSend);
  nData.FLen := Swap(cSize_Head_Send_OCTime);
  nData.FCardType := nItem.FCard;

  if EditDevice.ItemIndex > 0 then
       nData.FDevice := Swap(nItem.FDevice[EditDevice.ItemIndex - 1].FID)
  else nData.FDevice := sFlag_BroadCast;

  nData.FCommand := cCmd_OCTime;
  if Check1.Checked then nData.FFlag := 1;
  
  with FDM do
  try
    BtnTest.Enabled := False;
    nStr := '与控制器通信失败';

    Comm1.StopComm;
    Comm1.CommName := nItem.FPort;
    Comm1.BaudRate := nItem.FBote;

    Comm1.StartComm;
    Sleep(500);

    nStr := '发送数据失败';
    FWaitCommand := nData.FCommand;
    Comm1.WriteCommData(@nData, cSize_Head_Send_OCTime);

    if not WaitForTimeOut(nStr) then
      raise Exception.Create('');
    //xxxxx

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_OCTime);
    if nRespond.FFlag = sFlag_OK then
    begin
      ModalResult := mrOk;
      ShowMsg(ML('屏幕开关设置成功'), sHint);
    end else ShowMsg(ML('屏幕开关设置失败'), sHint);

    BtnTest.Enabled := True;
  except
    BtnTest.Enabled := True;
    ShowMsg(ML(nStr), sHint);
  end;
end;

end.
