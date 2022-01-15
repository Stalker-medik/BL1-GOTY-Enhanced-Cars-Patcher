unit Unit1;

interface

uses Winapi.Windows, ShellApi,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    Memo2: TMemo;
    Button1: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);


    procedure Decompress (FileName:string);
    procedure FilesMove (FileName:string);
    procedure FilesDelete (FileName:string);
    procedure FilesRename (FileName:string);

    procedure StartPatch;
    procedure UPKPatch(FileName:string; ReplaceType: string);

    procedure StringReplace(FileToPatch, OutDir: string; SearchString, ReplaceString : AnsiString);

    procedure GetFileList;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  StopPatch:Boolean;
  Rollback:Boolean;
  Nolog:Boolean;
  Stage: integer;
  FileListStrings : TStringList;
const
  BUFSIZE = 8192;


//������ 'Out rider' �� '������'

InterludeSearchArray: array [0..1] of array of byte =
([$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $4F, $75, $74, $20, $52, $69, $64, $65, $72, $00, $54, $0E, $00, $00, $00, $00, $00, $00, $2A, $13, $00, $00, $00, $00, $00],
[$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $4F, $75, $74, $20, $52, $69, $64, $65, $72, $00, $54, $0E, $00, $00, $00, $00, $00, $00, $2A, $13, $00, $00, $00, $00, $00]);


InterludeReplaceArray: array [0..1]  of array of byte =
([$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $CA, $F3, $F0, $FC, $E5, $F0, $20, $20, $20, $00, $54, $0E, $00, $00, $00, $00, $00, $00, $2A, $13, $00, $00, $00, $00, $00],
[$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $CA, $F3, $F0, $FC, $E5, $F0, $20, $20, $20, $00, $54, $0E, $00, $00, $00, $00, $00, $00, $2A, $13, $00, $00, $00, $00, $00]);


//������ 'Chew Paw' �� '�������'

LakebedSearchArray: array [0..1]  of array of byte =
([$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $43, $68, $65, $74, $61, $20, $50, $61, $77, $00, $89, $25, $00, $00, $00, $00, $00, $00, $34, $1C, $00, $00, $00, $00, $00],
[$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $43, $68, $65, $74, $61, $20, $50, $61, $77, $00, $89, $25, $00, $00, $00, $00, $00, $00, $34, $1C, $00, $00, $00, $00, $00]);

LakebedReplaceArray: array [0..1]  of array of byte =
([$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $C3, $E5, $EF, $E0, $F0, $E4, $20, $20, $20, $00, $89, $25, $00, $00, $00, $00, $00, $00, $34, $1C, $00, $00, $00, $00, $00],
[$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $C3, $E5, $EF, $E0, $F0, $E4, $20, $20, $20, $00, $89, $25, $00, $00, $00, $00, $00, $00, $34, $1C, $00, $00, $00, $00, $00]);


SouthlakeSearchArray: array [0..1]  of array of byte =
([$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $43, $68, $65, $74, $61, $20, $50, $61, $77, $00, $88, $26, $00, $00, $00, $00, $00, $00, $38, $1D, $00, $00, $00, $00, $00],
[$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $43, $68, $65, $74, $61, $20, $50, $61, $77, $00, $88, $26, $00, $00, $00, $00, $00, $00, $38, $1D, $00, $00, $00, $00, $00]);

SouthlakeReplaceArray: array [0..1]  of array of byte =
([$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $C3, $E5, $EF, $E0, $F0, $E4, $20, $20, $20, $00, $88, $26, $00, $00, $00, $00, $00, $00, $38, $1D, $00, $00, $00, $00, $00],
[$00, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $C3, $E5, $EF, $E0, $F0, $E4, $20, $20, $20, $00, $88, $26, $00, $00, $00, $00, $00, $00, $38, $1D, $00, $00, $00, $00, $00]);


//������ 'Crimson Lance' �� '���� ������'

NLanceStripSearchArray: array [0..0]  of array of byte =
([$00, $00, $00, $00, $13, $00, $00, $00, $00, $00, $00, $00, $0F, $00, $00, $00, $43, $72, $69, $6D, $73, $6F, $6E, $20, $4C, $61, $6E, $63, $65, $72, $00, $47, $25, $00, $00, $00, $00, $00, $00, $3F, $1C, $00, $00, $00, $00, $00]);

NLanceStripReplaceArray: array [0..0]  of array of byte =
([$00, $00, $00, $00, $13, $00, $00, $00, $00, $00, $00, $00, $0F, $00, $00, $00, $C0, $EB, $FB, $E9, $20, $CB, $E0, $ED, $F1, $E5, $F0, $20, $20, $20, $00, $47, $25, $00, $00, $00, $00, $00, $00, $3F, $1C, $00, $00, $00, $00, $00]);


SLanceStripSearchArray: array [0..0]  of array of byte =
([$00, $00, $00, $00, $13, $00, $00, $00, $00, $00, $00, $00, $0F, $00, $00, $00, $43, $72, $69, $6D, $73, $6F, $6E, $20, $4C, $61, $6E, $63, $65, $72, $00, $27, $21, $00, $00, $00, $00, $00, $00, $23, $19, $00, $00, $00, $00, $00]);

SLanceStripReplaceArray: array [0..0]  of array of byte =
([$00, $00, $00, $00, $13, $00, $00, $00, $00, $00, $00, $00, $0F, $00, $00, $00, $C0, $EB, $FB, $E9, $20, $CB, $E0, $ED, $F1, $E5, $F0, $20, $20, $20, $00, $27, $21, $00, $00, $00, $00, $00, $00, $23, $19, $00, $00, $00, $00, $00]);


CircleSearchArray: array [0..0]  of array of byte =
([$00, $00, $00, $00, $13, $00, $00, $00, $00, $00, $00, $00, $0F, $00, $00, $00, $43, $72, $69, $6D, $73, $6F, $6E, $20, $4C, $61, $6E, $63, $65, $72, $00, $29, $1D, $00, $00, $00, $00, $00, $00, $BE, $15, $00, $00, $00, $00, $00]);

CircleReplaceArray: array [0..0]  of array of byte =
([$00, $00, $00, $00, $13, $00, $00, $00, $00, $00, $00, $00, $0F, $00, $00, $00, $C0, $EB, $FB, $E9, $20, $CB, $E0, $ED, $F1, $E5, $F0, $20, $20, $20, $00, $29, $1D, $00, $00, $00, $00, $00, $00, $BE, $15, $00, $00, $00, $00, $00]);


implementation

{$R *.fmx}

function IndexStr2(const AText: string; const AValues: array of string): Integer;
var
 I: Integer;
begin
    Result := -1;
    for I := Low(AValues) to High(AValues) do
    if AText = AValues[I]
    then begin
        Result := I;
        Break;
    end;
end;

procedure AddLog(s: string; AddTStamp: boolean);  overload;
var ErrLogFile : TextFile;
begin
    if not NoLog
    then begin
        AssignFile(ErrLogFile, ExtractFileDir(Paramstr(0)) + PathDelim +'carsPatchLog.txt');
        if not FileExists(ExtractFileDir(Paramstr(0)) + PathDelim +'carsPatchLog.txt')
        then begin
            Rewrite(ErrLogFile);
            if AddTStamp
            then Writeln(ErrLogFile, Formatdatetime('YYYY-MM-DD HH:MM:SS', Now) +'     '+ s )
            else Writeln(ErrLogFile, s );
            CloseFile(ErrLogFile)
        end
        else begin
            Append(ErrLogFile);
            if AddTStamp
            then Writeln(ErrLogFile, Formatdatetime('YYYY-MM-DD HH:MM:SS', Now) +'     '+ s )
            else Writeln(ErrLogFile, s );
            CloseFile(ErrLogFile);
        end;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i: integer;
begin
    StopPatch:=False;
    Rollback:=False;
    Nolog:=False;
    for i := 1 to ParamCount-1 do
    begin
        if Paramstr(i)='-rollback'
        then Rollback:=True;
        if Paramstr(i)='-nolog'
        then NoLog:=True;
    end;

    Label1.Text:='��������� ������� ������ ����� �������� � ������ ����� 1 ������. ���������.';
    Stage:=0;
    Timer1.Enabled:=True;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
    Timer1.Enabled:=False;
    if Stage=0
    then begin
        GetFileList;
        AddLog     ('***********************************', false);
        if (Rollback)
        then AddLog('***����� �������� �������� �����***', false)
        else Addlog('***����� �������� �������� �����***', false);
        AddLog     ('***********************************', false);
        StartPatch;
        Timer1.Enabled:=True;
    end
    else begin
        Application.Terminate;
    end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
		SelButton : Integer;
begin
    SelButton := MessageDlg('������ ������ ���������� �������� ����� ����?',TMsgDlgType.mtWarning , mbYesNo, 0);
    if SelButton = mrYes
    then begin
        StopPatch:=True;
    end;
    if SelButton = mrNo
    then ShowMessage('��-�� ��. ����� � ��������.');
end;

procedure TForm1.GetFileList;
	var  RS: TResourceStream;
  begin
      try
          RS := TResourceStream.Create(HInstance, 'Res1', RT_RCDATA);
      finally

      end;

      try
          FileListStrings:= TStringList.Create;
          FileListStrings.LoadFromStream(RS);
          FreeAndNil(RS);
          //FreeAndNil(TransStrings);
      except on e:exception do

      end;
  end;

procedure TForm1.StartPatch;
var
  i: Integer; WGUName, WGUName2: string;
  CurrentFile: string;
  CurrentType: string;
begin
    Stage:=1;
    try
        ProgressBar1.Value := 0 ;
        Label2.Text:='0%';
        try
            if not (DirectoryExists('temp'))
            then MkDir('Temp')
        except
            AddLog('�� ������� ������� ��������� �����', true);
        end;

        Application.ProcessMessages;

        FileListStrings.Clear;
        FileListStrings.Add('\WillowGame\CookedPC\DLC3\Maps\dlc3_circle_p.umap');
        FileListStrings.Add('\WillowGame\CookedPC\DLC3\Maps\dlc3_lakebed_p.umap');
        FileListStrings.Add('\WillowGame\CookedPC\DLC3\Maps\dlc3_NLanceStrip_p.umap');
        FileListStrings.Add('\WillowGame\CookedPC\DLC3\Maps\dlc3_SLanceStrip_p.umap');
        FileListStrings.Add('\WillowGame\CookedPC\DLC3\Maps\dlc3_southlake_p.umap');
        FileListStrings.Add('\WillowGame\CookedPC\Maps\Interlude_1\Interlude_1_P.umap');

        for i:=0 to FileListStrings.Count-1 do

        if not StopPatch then begin
            case IndexStr2(FileListStrings[i], ['\WillowGame\CookedPC\DLC3\Maps\dlc3_circle_p.umap', '\WillowGame\CookedPC\DLC3\Maps\dlc3_lakebed_p.umap', '\WillowGame\CookedPC\DLC3\Maps\dlc3_NLanceStrip_p.umap', '\WillowGame\CookedPC\DLC3\Maps\dlc3_SLanceStrip_p.umap', '\WillowGame\CookedPC\DLC3\Maps\dlc3_southlake_p.umap', '\WillowGame\CookedPC\Maps\Interlude_1\Interlude_1_P.umap']) of
                0: CurrentType:= 'circle';
                1: CurrentType:= 'lakebed';
                2: CurrentType:= 'NLanceStrip';
                3: CurrentType:= 'SLanceStrip';
                4: CurrentType:= 'southlake';
                5: CurrentType:= 'Interlude_1';
                else begin
                    AddLog('������', true);
                    break;
                end;
            end;
            if FileExists(ExtractFileDir(Paramstr(0))+FileListStrings[i])
            then begin
                Label1.Text:='��������� ����� '+FileListStrings[i];
                AddLog('������ ��������� '+ExtractFileName(Paramstr(0)+FileListStrings[i]), true);
                Application.ProcessMessages;
                decompress(FileListStrings[i]);
                FilesMove(FileListStrings[i]);
                UPKPatch(FileListStrings[i], CurrentType);
                ProgressBar1.Value := ((i+1) * 100) div (FileListStrings.Count) ;
                Label2.Text:=inttostr(Round(ProgressBar1.Value))+'%   ';
            end
            else begin
                Label1.Text:='�� ������ ���� '+FileListStrings[i];
                AddLog('�� ������ ���� '+ExtractFileName(Paramstr(0)+FileListStrings[i]), true);
            end;
            Application.ProcessMessages;
        end;

        ProgressBar1.Value := 100;
        Label2.Text:='100%   ';
        Application.ProcessMessages;

        if StopPatch
        then begin
            AddLog('***************************************************', false);
            AddLog('***********��������� ������ �����������.***********', false);
            AddLog('***************************************************', false);
        end;
    except on e:exception do
    		AddLog('�������������� ������ '+e.Message, true);
    end;

    Button1.Visible:=False;
    Application.ProcessMessages;

    if RemoveDir('Temp')
    then begin
        Label1.Text:='������. ��������.';
        AddLog('��������� ��������� ������', true);
    end
    else begin
        Label1.Text:=('�� ������� ������� ��������� �����. ��������, �������� ����.'+IntToStr(GetLastError));
        AddLog('�� ������� ������� ��������� ����� ', true);
    end;

    Application.ProcessMessages;
end;


{$REGION '�������� ��������'}

procedure TForm1.Decompress (FileName:string);
var
Rlst: LongBool; //��������� ����������
StartUpInfo: TStartUpInfo; //��������� �������� ��������
ProcessInfo: TProcessInformation; //������������ ����������
app, CurrDir:string; //������� �����
Error:integer; //����� �������
SendFail,ExitCode: Cardinal; //��� ����������

parameter:String;
SecAtrrs: TSecurityAttributes;
begin
    CurrDir:=ExtractFileDir(Paramstr(0));
    with SecAtrrs do begin
        nLength := SizeOf(SecAtrrs);
        bInheritHandle := True;
        lpSecurityDescriptor := nil;
    end;

    FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);    //���������� ������ ����� StartUpInfo.
    with StartUpInfo do
    begin
        cb := SizeOf(TStartUpInfo);
        dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK; //���������� ����, ������ - ������.
        wShowWindow := SW_HIDE; //���������� ��� ������ ��������� ���� ����������� ����������.
    end;

    app := CurrDir+'\decompress.exe';

    if not FileExists (app) then
    begin
        Label1.Text:='�� ������ '+ExtractFileName(app);
        AddLog('�� ������ ���� '+ExtractFileName(app), true);
        exit;
    end;

    Application.ProcessMessages;
    parameter:=' -lzo "'+CurrDir+FileName+'" -out="'+CurrDir+'\Temp"';
    if FileExists(CurrDir+FileName)
    then begin
        Rlst:= CreateProcess(PChar(app), PChar(parameter),nil, nil, false,0,nil, nil, StartUpInfo, ProcessInfo);

        //����������� ����������.
        if Rlst
        then begin   //���� ������ �������
            with ProcessInfo do
            begin
                WaitForInputIdle(hProcess, INFINITE);     //���� ���������� �������������.
                 WaitforSingleObject(ProcessInfo.hProcess, INFINITE);    //���� ���������� ��������.
                 GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);    //�������� ��� ����������.
                 CloseHandle(hThread);    //��������� ���������� ��������.
                 CloseHandle(hProcess);    //��������� ���������� ������.
            end;
        end

        else begin
            Error := GetLastError;  //�������� ��� � ������ ������
        end;
        SendFail:=ExitCode;
        Application.ProcessMessages;
        if (SendFail<>0)
        then begin
           Label1.Text:='������ ��� ����������: '+FileName+' /'+inttostr(SendFail)+' /'+inttostr(Error);
           AddLog('������ ��� ���������� '+ExtractFileName(Paramstr(0)+(FileName)), true);
        end
        else begin
           Label1.Text:='����������: '+FileName;
           AddLog('���������� '+ExtractFileName(Paramstr(0)+(FileName)), true);
        end;
    end
    else begin
        Label1.Text:='���� �� ������: '+FileName;
        AddLog('�� ������ ���� '+ExtractFileName(Paramstr(0)+(FileName)), true);
    end;
    Application.ProcessMessages;
end;

procedure TForm1.FilesMove (FileName:string);
  var CurrDir:String;
  begin
      try
          CurrDir:=ExtractFileDir(Paramstr(0));
          MoveFileEx(pchar(CurrDir+'\Temp\'+ExtractFileName(Paramstr(0)+(FileName))),
                    pchar(ExtractFileDir( CurrDir+FileName)+'\'+ExtractFileName(Paramstr(0)+FileName)), MOVEFILE_REPLACE_EXISTING);
          Label1.Text:='���������: '+FileName;
          AddLog('��������� �� ��������� ����� '+ExtractFileName(Paramstr(0)+(FileName)), true);
          Application.ProcessMessages;
      except on e:exception do
          AddLog('�� ������� ����������� �� ��������� ����� '+ExtractFileName(Paramstr(0)+(FileName)), true);
      end;
  end;

  procedure TForm1.FilesDelete (FileName:string);
  var CurrDir:String;
  begin
      try
          CurrDir:=ExtractFileDir(Paramstr(0));

          if DeleteFile(CurrDir+'\'+fileName)
          then begin
              Label1.Text:='������ '+fileName;
              AddLog('������ '+ExtractFileName(Paramstr(0)+(FileName)), true);
          end
          else begin
              Label1.Text:='��������� ������ ��� �������� '+ fileName;
              AddLog('��������� ������ '+IntToStr(GetLastError)+' ��� �������� '+ExtractFileName(Paramstr(0)+(FileName)), true);
          end;
      except on e:exception do
          AddLog('�� ������� ������� ���� '+ExtractFileName(Paramstr(0)+(FileName)), true);
      end;
      Application.ProcessMessages;
  end;

  procedure TForm1.FilesRename (FileName:string);
  var CurrDir, oldName, newName:String;
  begin
      try
          CurrDir:=ExtractFileDir(Paramstr(0));
          oldName := CurrDir+'\'+fileName;
          newName := ChangeFileExt(oldName, '.upk');
          if RenameFile(oldName, newName)

          then begin
              Label1.Text:='������������ '+fileName;
              AddLog('������������ '+ExtractFileName(Paramstr(0)+(FileName)), true);
          end
          else begin
              Label1.Text:='��������� ������ ��� �������������� '+ fileName;
              AddLog('��������� ������ '+IntToStr(GetLastError)+' ��� �������������� '+ExtractFileName(Paramstr(0)+(FileName)), true);
          end;
      except on e:exception do
          AddLog('�� ������� ������������� ���� '+ExtractFileName(Paramstr(0)+(FileName)), true);
      end;
      Application.ProcessMessages;
  end;
{$ENDREGION}

procedure TForm1.UPKPatch(FileName:string; ReplaceType: string);
var k:integer;
SearchString, ReplaceString: AnsiString;
SearchArray, ReplaceArray: Tstrings;

begin
    if not assigned(SearchArray) then
    SearchArray:=TstringList.Create;
    if not assigned(ReplaceArray) then
    ReplaceArray:=TstringList.Create;

    SearchArray.Text:='';
    ReplaceArray.Text:='';

    case IndexStr2(ReplaceType, ['circle', 'lakebed', 'NLanceStrip', 'SLanceStrip', 'southlake', 'Interlude_1']) of
        0: begin
            for k:= Low(CircleReplaceArray) to High(CircleReplaceArray) do
            begin
                SetString(SearchString, PAnsiChar(@CircleSearchArray[k][0]), Length(CircleSearchArray[k]));
                SearchArray.Add(SearchString);
                SetString(ReplaceString, PAnsiChar(@CircleReplaceArray[k][0]), Length(CircleReplaceArray[k]));
                ReplaceArray.Add(ReplaceString);
            end;
        end;
        1: begin
            //setlength(ReplaceArray,Length(HexReplaceArray));
            for k:= Low(LakebedReplaceArray) to High(LakebedReplaceArray) do
            begin
                SetString(SearchString, PAnsiChar(@LakebedSearchArray[k][0]), Length(LakebedSearchArray[k]));
                SearchArray.Add(SearchString);
                SetString(ReplaceString, PAnsiChar(@LakebedReplaceArray[k][0]), Length(LakebedReplaceArray[k]));
                ReplaceArray.Add(ReplaceString);
            end;
        end;
        2: begin
            //setlength(ReplaceArray,Length(HexReplaceArray));
            for k:= Low(NLanceStripReplaceArray) to High(NLanceStripReplaceArray) do
            begin
                SetString(SearchString, PAnsiChar(@NLanceStripSearchArray[k][0]), Length(NLanceStripSearchArray[k]));
                SearchArray.Add(SearchString);
                SetString(ReplaceString, PAnsiChar(@NLanceStripReplaceArray[k][0]), Length(NLanceStripReplaceArray[k]));
                ReplaceArray.Add(ReplaceString);
            end;
        end;
        3: begin
            //setlength(ReplaceArray,Length(HexReplaceArray));
            for k:= Low(SLanceStripReplaceArray) to High(SLanceStripReplaceArray) do
            begin
                SetString(SearchString, PAnsiChar(@SLanceStripSearchArray[k][0]), Length(SLanceStripSearchArray[k]));
                SearchArray.Add(SearchString);
                SetString(ReplaceString, PAnsiChar(@SLanceStripReplaceArray[k][0]), Length(SLanceStripReplaceArray[k]));
                ReplaceArray.Add(ReplaceString);
            end;
        end;
        4: begin
            //setlength(ReplaceArray,Length(HexReplaceArray));
            for k:= Low(SouthlakeReplaceArray) to High(SouthlakeReplaceArray) do
            begin
                SetString(SearchString, PAnsiChar(@SouthlakeSearchArray[k][0]), Length(SouthlakeSearchArray[k]));
                SearchArray.Add(SearchString);
                SetString(ReplaceString, PAnsiChar(@SouthlakeReplaceArray[k][0]), Length(SouthlakeReplaceArray[k]));
                ReplaceArray.Add(ReplaceString);
            end;
        end;
        5: begin
            //setlength(ReplaceArray,Length(HexReplaceArray));
            for k:= Low(InterludeReplaceArray) to High(InterludeReplaceArray) do
            begin
                SetString(SearchString, PAnsiChar(@InterludeSearchArray[k][0]), Length(InterludeSearchArray[k]));
                SearchArray.Add(SearchString);
                SetString(ReplaceString, PAnsiChar(@InterludeReplaceArray[k][0]), Length(InterludeReplaceArray[k]));
                ReplaceArray.Add(ReplaceString);
            end;
        end;
    end;

    if not (Rollback)
    then begin
        for k:= 0 to SearchArray.Count-1 do begin
            Label1.Text:='��������� '+ExtractFilename(ExtractFileDir(Paramstr(0))+FileName);
            Application.ProcessMessages;
            StringReplace ( ExtractFileDir(Paramstr(0))+FileName, ExtractFileDir(Paramstr(0)+FileName), SearchArray[k], ReplaceArray[k] );
        end;

    end
    else begin
        for k:= 0 to ReplaceArray.Count-1 do begin
            Label1.Text:='������� ��������� '+ExtractFilename(ExtractFileDir(Paramstr(0))+FileName);
            Application.ProcessMessages;
            StringReplace ( ExtractFileDir(Paramstr(0))+FileName, ExtractFileDir(Paramstr(0)+FileName), ReplaceArray[k], SearchArray[k] );
        end;
    end;
end;


procedure TForm1.StringReplace(FileToPatch, OutDir: string; SearchString, ReplaceString : AnsiString);
var
  Fs : TFileStream;
  FileName : String;
  SBuff : AnsiString; //AnsiString - ���, ����������� ������ ����������� ��������.
  Offs : Int64;
begin
    FileName := FileToPatch; //���� � �����.
    //������ ��������� ��������� ������ � ��������� ���� � ������ ������ � ������
    //(fmOpenReadWrite), � �������� �� ������ �� ������ ��������� (fmShareDenyWrite).
    Fs := TFileStream.Create(FileName, fmOpenReadWrite + fmShareDenyWrite);
    try
        SetLength(SBuff, Fs.Size); //�������� ������ ��� ������.
        Fs.Read(SBuff[1], Length(SBuff)); //��������� � ����� ������ ��������� ������.
        //����� � ������ SBuff ������� ��������� ��������� Sf. ��������� �������� � ���� ��������.
        Offs := Pos(SearchString, SBuff) - 1;
        if Offs > -1 then //���� ��������� �������.
        begin
          Fs.Position := Offs; //���������� ��������� ������ � ��������� ���������.
          Fs.Write(ReplaceString[1], Length(ReplaceString)); //���������� ����� ������������������ ������.
        end;
    finally
        FreeAndNil(Fs); //���������� ��������� ��������� ������ � ��������� ����.
    end;

    if Offs > -1 then begin
        Label1.Text:=ExtractFilename(FileName)+' �������� = ' + IntToStr(Offs);
        AddLog('������� �������� '+Inttostr(offs)+' � ����� '+ExtractFileName(Paramstr(0)+(FileName)), true);
    end
    else begin
        Label1.Text:=ExtractFilename(FileName)+' ������ �� �������';
        AddLog('�� ������� �������� � ����� '+ExtractFileName(Paramstr(0)+(FileName)), true);
    end;
    Application.ProcessMessages;
end;

end.









