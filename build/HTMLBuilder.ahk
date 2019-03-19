#NoTrayIcon
FileEncoding,UTF-8-RAW 
_ini_Path:=A_ScriptDir . "\HTMLBuilder.ini"

Gui,+Resize +HwndMain +MinSize
Gui,Font,,微软雅黑
Gui,Add,ListView,x5 y45 w250 NoSort Grid -Multi gg_List vg_List,#|文章列表
Gui,Font,s10,
Gui,Add,Edit,x260 y45 hwndBox Multi ReadOnly vg_Box,
Gui,Add,Edit,x260 r1 w200 ReadOnly vg_Time,
Gui,Add,Edit,x465 r1 ReadOnly vg_Keys,
Gui,Font,s9,
Gui,Add,Button,x5 y6 w55 h30 gbtnMan vid_New,写文章
Gui,Add,Button,x65 y6 w55 h30 gbtnMan vid_Rename,重命名
Gui,Add,Button,x125 y6 w60 h30 gbtnMan vid_Del,删除文章
Gui,Add,Button,x190 y6 w65 h30 gbtnMan vid_Set,路径设置
Gui,Font,Bold,
Gui,Add,Button,x260 y6 w30 h30 Disabled gbtn vid_B,B
Gui,Add,Button,x295 y6 w30 h30 Disabled gbtn vid_i,I
Gui,Add,Button,x330 y6 w30 h30 Disabled gbtn vid_color,C
Gui,Add,Button,x365 y6 w40 h30 Disabled gbtn vid_ul,Ul
Gui,Add,Button,x410 y6 w40 h30 Disabled gbtn vid_ol,Ol
Gui,Add,Button,x455 y6 w30 h30 Disabled gbtn vid_a,a
Gui,Add,Button,x490 y6 w40 h30 Disabled gbtn vid_img,img
Gui,Add,Button,x535 y6 w50 h30 Disabled gbtn vid_span,Span
Gui,Add,Button,x590 y6 w40 h30 Disabled gbtn vid_div,Div
Gui,Add,Button,x635 y6 w50 h30 Disabled gbtn vid_block,Pre
Gui,Add,Button,x690 y6 w50 h30 Disabled gbtn vid_audio,Audio
Gui,Add,Button,x745 y6 w50 h30 Disabled gbtn vid_video,Video
Gui,Font,norm,
Gui,Add,Button,x875 y6 w50 h30 Disabled gbtnSys vid_Preview,预览
Gui,Add,Button,x930 y6 w50 h30 Disabled gbtnSys vid_Save,保存
Gui,Add,Button,x810 y6 w60 h30 gbtnSys vid_Option,标签选项
Gui,Add,Button,x985 y6 w70 h30 gbtnSys vid_Update,更新首页
Gui,Show,w1060 h800,HTML 编辑器
IniRead,b_AutoNewIndex,%_ini_Path%,General,AutoUpdateIndex,0
If b_AutoNewIndex Not In 0,1
	b_AutoNewIndex:=0
IniRead,str_Options,%_ini_Path%,General,Options,1111110
str_Options=%str_Options%
If !RegexMatch(str_Options,"^\d{7}$")
	str_Options:="1111110"
arr_Option:=StrSplit(str_Options),errFlag:=0
If !FileExist(_ini_Path)
	errFlag:=1
Else{
	IniRead,strPath_Template,%_ini_Path%,General,path_Template,%A_Space%
	strPath_Template=%strPath_Template%
	If (strPath_Template="") Or !InStr(FileExist(strPath_Template),"D")
		errFlag:=1,strPath_Template:=""
	IniRead,strPath_Post,%_ini_Path%,General,path_Post,%A_Space%
	strPath_Post=%strPath_Post%
	If (strPath_Post="") Or !InStr(FileExist(strPath_Post),"D")
		errFlag:=1,strPath_Post:=""
	IniRead,strPath_Index,%_ini_Path%,General,path_Index,%A_Space%
	strPath_Index=%strPath_Index%
	If (strPath_Index="") Or !InStr(FileExist(strPath_Index),"D")
		errFlag:=1,strPath_Index:=""
}
If errFlag
	Gosub globalSet
Else{
	strPath_Template:=Trim(strPath_Template,"\"),strPath_Post:=Trim(strPath_Post,"\"),strPath_Index:=Trim(strPath_Index,"\")
	Gosub _GetList
}
errFlag:=style_Block:=""
Return

^1::Reload

GuiSize:
GuiControl,MoveDraw,g_Box,% "w" A_GuiWidth-265 "h" A_GuiHeight-82
GuiControl,MoveDraw,g_Time,% "y" A_GuiHeight-32
GuiControl,MoveDraw,g_Keys,% "w" A_GuiWidth-470 "y" A_GuiHeight-32
GuiControl,MoveDraw,g_List,% "h" A_GuiHeight-50
Return

g_List:
If A_GuiEvent In DoubleClick
{
	If _Is_NewPost
	{
		Gui,+OwnDialogs
		MsgBox,262192,切换文章,请先保存当前文章！
		GuiControl,Focus,g_List
		Lv_Modify(1,"Select Focus")
		Return
	}
	tempStr:=Lv_GetNext()
	If (tempStr=0)
		Return
	Lv_GetText(tempText,tempStr,2),sPath:=strPath_Post . "\" . tempText . ".txt",tempStr:=""
	Loop,Read,%sPath%
	{
		If (A_Index=1)
			getStr1:=A_LoopReadLine
		If (A_Index=2)
			getStr2:=A_LoopReadLine
		If (A_Index>3)
			tempStr .= A_LoopReadLine . "`n"
	}
	GuiControl,,g_Box,% strReplace(SubStr(tempStr,1,-1),"<br />","`n")
	GuiControl,,g_Time,% SubStr(getStr1,6)
	GuiControl,,g_Keys,% SubStr(getStr2,6)
	Gui,Show,,HTML 编辑器 - [%tempText%]
	tempText:=tempStr:=getStr1:=getStr2:="",_Is_Preview:=0,_Btn_Switch(1)
	GuiControl,-ReadOnly,g_Box
	GuiControl,-ReadOnly,g_Time
	GuiControl,-ReadOnly,g_Keys
	GuiControl,Focus,g_Box
	GuiControl,Enabled,id_Del
	GuiControl,Text,id_Preview,预览
}
Return

_GetList:
tempStr:="",nCount:=0
Loop,Files,%strPath_Post%\*.txt
{
	FileReadLine,tempText,%A_LoopFileFullPath%,1
	tempText:=RegexReplace(SubStr(Trim(tempText,"`t `r`n"),6),"[\s/:]"),tempStr .= tempText . A_Tab . A_LoopFileName . "`n"
}
Sort,tempStr,R
Loop,Parse,tempStr,`n
{
	If (A_LoopField="")
		Continue
	arr_Temp:=StrSplit(A_LoopField,A_Tab),tempText:=SubStr(arr_Temp[2],1,-4),nCount+=1,Lv_Add("",nCount,tempText),arr_Temp:=[]
}
tempStr:=tempText:=""
Return

btnMan:
If (A_GuiControl="id_New"){
	Gui,+OwnDialogs
	If _Is_NewPost
	{
		MsgBox,262192,新建文章,请先保存当前文章！
		Return
	}
	InputBox,tempStr,新建文章/输入文章标题,,,300,100,,,,,新文章_%A_Now%
	If ErrorLevel
		Return
	tempStr=%tempStr%
	If (tempStr="")
		Return
	sPath:=strPath_Post . "\" . StrReplace(tempStr,A_Space,"-") . ".txt"
	Lv_Modify(0,"-select"),Lv_Insert(1,"Select focus","*",tempStr),_Btn_Switch(1)
	GuiControl,Text,id_Preview,预览
	Gui,Show,,HTML 编辑器 - [%tempStr%]
	GuiControl,,g_Box,
	GuiControl,-ReadOnly,g_Box
	GuiControl,-ReadOnly,g_Time
	GuiControl,-ReadOnly,g_Keys
	GuiControl,Focus,g_Box
	tempStr:="",_Is_NewPost:=1
}Else If (A_GuiControl="id_Del"){
	If _Is_NewPost
	{
		Gui,+OwnDialogs
		MsgBox,262180,删除文章,当前文章尚未保存，是否删除？
		IfMsgBox,No
			Return
		GuiControl,,g_Box,
		GuiControl,+ReadOnly,g_Box
		GuiControl,+ReadOnly,g_Time
		GuiControl,+ReadOnly,g_Keys
		Gui,Show,,HTML 编辑器
		Lv_Delete(1),_Btn_Switch(0),_Is_NewPost:=0
		Return
	}
	tempStr:=Lv_GetNext()
	If (tempStr=0)
		Return
	Lv_GetText(tempText,tempStr,2)
	If !FileExist(strPath_Post . "\" . tempText . ".txt")
		Return
	Gui,+OwnDialogs
	MsgBox,262180,删除文章,确定删除文章“%tempText%”?
	IfMsgBox,No
		Return
	FileDelete,%strPath_Post%\%tempText%.txt
	If (ErrorLevel=0){
		GuiControl,,g_Box
		GuiControl,+ReadOnly,g_Box
		GuiControl,+ReadOnly,g_Time
		GuiControl,+ReadOnly,g_Keys
		Lv_Delete(tempStr),_Btn_Switch(0)
		Gui,Show,,HTML 编辑器
		MsgBox,262208,删除文章,文章“%tempText%”已成功删除!
		Gosub gs_Number
	}Else
		MsgBox,262192,删除文章,删除文章失败，请检查后重试!
	tempStr:=tempText:=""
}Else If (A_GuiControl="id_Rename"){
	tempStr:=Lv_GetNext()
	If (tempStr=0)
		Return
	Lv_GetText(tempText,tempStr,2)
	Gui,+OwnDialogs
	InputBox,tempNew,新建文章/输入文章标题,,,300,100,,,,,%tempText%
	If ErrorLevel
	{
		GuiControl,Focus,g_List
		Return
	}
	tempNew=%tempNew%
	If (tempNew="") Or (tempNew=tempText)
	{
		GuiControl,Focus,g_List
		Return
	}
	FileMove,%strPath_Post%\%tempText%.txt,%strPath_Post%\%tempNew%.txt
	Lv_Modify(tempStr,"COL2",tempNew),tempStr:=tempText:=tempNew:=""
	GuiControl,Focus,g_List
}Else
	Gosub globalSet
Return

btn:
ControlGet,tempStr,Selected,,,Ahk_Id %Box%
tempStr:=Trim(tempStr),bFlag:=(!ErrorLevel And (tempStr=""))?0:1,outStr:=""
If (A_GuiControl="id_B")
	outStr:="<b>" . tempStr . "</b>"
Else If (A_GuiControl="id_I")
	outStr:="<i>" . tempStr . "</i>"
Else If (A_GuiControl="id_color"){
	outStr:=tempStr
	Gosub _Get_Color
	Return
}Else If A_GuiControl In id_ul,id_ol
{
	outStr:="<" . SubStr(A_GuiControl,4) . ">`r`n"
	If bFlag
	{
		Loop,Parse,tempStr,`n
			outStr .= "<li>" . A_LoopField . "</li>`r`n"
	}Else
		outStr .= "<li></li>`r`n"
	outStr .= (A_GuiControl="id_ul")?"</ul>":"</ol>"
}Else If (A_GuiControl="id_a")
	outStr:=bFlag?("<a href=""""" . (arr_Option[1]?" target=""_blank""":"") . ">" . tempStr . "</a>"):("<a href=""""" . (arr_Option[1]?" target=""_blank""":"") . "></a>")
Else If (A_GuiControl="id_img")
	outStr:= "<img src=""""" . (arr_Option[6]?" alt=""""":"") . (arr_Option[7]?" title=""""":"") . ">"
Else If (A_GuiControl="id_span")
	outStr:=bFlag?("<span" . (arr_Option[4]?" class=""""":"") . (arr_Option[5]?" id=""""":"") . ">" . tempStr . "</span>"):("<span" . (arr_Option[4]?" class=""""":"") . (arr_Option[5]?" id=""""":"") . "></span>")
Else If (A_GuiControl="id_div")
	outStr:=bFlag?("<div" . (arr_Option[2]?" class=""""":"") . (arr_Option[3]?" id=""""":"") . ">" . tempStr . "</div>"):("<div" . (arr_Option[2]?" class=""""":"") . (arr_Option[3]?" id=""""":"") . "></div>")
Else If (A_GuiControl="id_block")
	outStr:="<pre>`r`n" . tempStr . "`r`n</pre>"
Else If (A_GuiControl="id_audio")
	outStr:="<audio controls=""controls"" preload=""none"" loop=""loop""><source src=""""/></audio>"
Else If (A_GuiControl="id_video")
	outStr:="<video controls=""controls"" src=""""></video>"
GuiControl,Focus,g_Box
Control,EditPaste,%outStr%,,Ahk_Id %Box%
If A_GuiControl In id_block
	SendInput {Up}
If ((A_GuiControl="id_ul") Or (A_GuiControl="id_ol")) And !bFlag
	SendInput {Up}{Left}
If (A_GuiControl="id_a") And bFlag
{
	tempStr:=22+StrLen(tempStr)
	SendInput {Left %tempStr%}
}
If (A_GuiControl="id_img"){
	If arr_Option[6] And arr_Option[7]
		SendInput {Left 18}
	Else{
		tempStr:=arr_Option[6]?9:11
		SendInput {Left %tempStr%}
	}
}
If (A_GuiControl="id_audio")
	SendInput {Left 11}
If (A_GuiControl="id_video")
	SendInput {Left 10}
tempStr=
Return

btnSys:
If (A_GuiControl="id_Option")
	Gosub _Get_Options
Else{
	If !FileExist(_ini_Path) Or (nCount=0)
		Return
	If (A_GuiControl="id_Update"){
		Gosub _Generate_Index
		Gui,+OwnDialogs
		MsgBox,262208,更新首页,已成功更新首页：`n%strPath_Index%\index.html
		Return
	}
	GuiControlGet,tempStr,,g_Box
	tempStr=%tempStr%
	If (tempStr="")
		Return
	If (A_GuiControl="id_Preview"){
		GuiControl,,g_box,% _Is_Preview?strReplace(tempStr,"<br />","`n"):RegexReplace(tempStr,"([^<>]+?)`n([^<>]+?)","$1<br />$2")
		_Is_Preview:=1-_Is_Preview
		GuiControl,Text,id_Preview,% _Is_Preview?"返回":"预览"
	}
	If (A_GuiControl="id_Save"){
		If !_Is_NewPost And FileExist(sPath)
			FileDelete,%sPath%
		GuiControlGet,getStr1,,g_Time
		getStr1=%getStr1%
		If (getStr1="")
			getStr1:=TimeFormat(A_Now)
		GuiControlGet,getStr2,,g_Keys
		getStr2:=RegexReplace(Trim(getStr2),"\s*,\s*",",")
		FileAppend,% "time:" . getStr1 . "`nkeys:" . getStr2 . "`n<txt>`n" . RegexReplace(tempStr,"([^<>]+?)`n([^<>]+?)","$1<br />$2"),%sPath%
		If !ErrorLevel
		{
			MsgBox,262208,保存文章,% "文章已保存到：`n" . sPath . (b_AutoNewIndex?"`n`n已刷新首页：`n" . strPath_Index . "\index.html":"")。
			If _Is_NewPost
			{
				Gosub gs_Number
				_Is_NewPost:=0
			}
			If b_AutoNewIndex
				Gosub _Generate_Index
			GuiControl,,g_Keys,%getStr2%
		}Else
			MsgBox,262192,保存文章,文章保存到：%sPath% 出错！
	}
	tempStr=
}
Return

gs_Number:
Loop,% Lv_GetCount()
	Lv_Modify(A_Index,"Col1",A_Index)
Return

_Btn_Switch(nFlag){
	GuiControl,% nFlag?"Enable":"Disable",id_B
	GuiControl,% nFlag?"Enable":"Disable",id_I
	GuiControl,% nFlag?"Enable":"Disable",id_color
	GuiControl,% nFlag?"Enable":"Disable",id_ul
	GuiControl,% nFlag?"Enable":"Disable",id_ol
	GuiControl,% nFlag?"Enable":"Disable",id_a
	GuiControl,% nFlag?"Enable":"Disable",id_img
	GuiControl,% nFlag?"Enable":"Disable",id_span
	GuiControl,% nFlag?"Enable":"Disable",id_div
	GuiControl,% nFlag?"Enable":"Disable",id_block
	GuiControl,% nFlag?"Enable":"Disable",id_audio
	GuiControl,% nFlag?"Enable":"Disable",id_video
	GuiControl,% nFlag?"Enable":"Disable",id_Preview
	GuiControl,% nFlag?"Enable":"Disable",id_Save
}

;;--------------字体颜色代码模块----------------

_Get_Color:
Gui,%Main%:+Disabled
Gui,color_Set:New
Gui,color_Set:-MinimizeBox +Owner%Main%
Gui,color_Set:Font,,微软雅黑
Gui,color_Set:Add,Text,x15 y15,字体颜色
Gui,color_Set:Add,Edit,x75 y12 w100 vc_fc,#000000
Gui,color_Set:Add,Text,x15 y45,背景颜色
Gui,color_Set:Add,Edit,x75 y42 w100 vc_bc,
Gui,color_Set:Add,Text,x15 y75,额外设置
Gui,color_Set:Add,CheckBox,x75 y75 vc_bold,粗体
Gui,color_Set:Add,CheckBox,x130 y75 vc_italic,斜体
Gui,color_Set:Add,Button,x15 y105 w160 h30 Default gc_Save,OK
Gui,color_Set:Show,,颜色
Return

c_Save:
GuiControlGet,getStr1,color_Set:,c_fc
GuiControlGet,getStr2,color_Set:,c_bc
GuiControlGet,getStr3,color_Set:,c_bold
GuiControlGet,getStr4,color_Set:,c_italic
style_Block:="<span style=""" . ((getStr1="")?"":("color:" . getStr1 . ";")) . ((getStr2="")?"":("background-color:" . getStr2 . ";")) . (getStr3?"font-weight:bold;":"") . (getStr4?"font-style:italic;":"") . """>"
Gui,%Main%:-Disabled
Gui,color_Set:Destroy
GuiControl,Focus,g_Box
outStr:=style_Block . outStr . "</span>"
Control,EditPaste,%outStr%,,Ahk_Id %Box%
outStr=
Return

color_SetGuiClose:
color_SetGuiEscape:
Gui,%Main%:-Disabled
Gui,color_Set:Destroy
style_Block=
GuiControl,%Main%:Focus,g_Box
Return

;;------------标签元素选项------------------

_Get_Options:
Gui,%Main%:+Disabled
Gui,w_Set:New
Gui,w_Set:-MinimizeBox +Owner%Main%
Gui,w_Set:Font,,微软雅黑
Gui,w_Set:Add,GroupBox,x10 y5 w220 h220,生成选项
Gui,w_Set:Add,CheckBox,x20 y30 w180 h20 vset_1,<a> 链接在新窗口打开
Gui,w_Set:Add,Text,x20 y60,<Div>标签
Gui,w_Set:Add,CheckBox,x40 y85 vset_2,使用 class
Gui,w_Set:Add,CheckBox,x150 y85 vset_3,使用 id
Gui,w_Set:Add,Text,x20 y115,<Span>标签
Gui,w_Set:Add,CheckBox,x40 y140 vset_4,使用 class
Gui,w_Set:Add,CheckBox,x150 y140 vset_5,使用 Id
Gui,w_Set:Add,Text,x20 y170,<Img>标签
Gui,w_Set:Add,CheckBox,x40 y195 vset_6,使用 alt
Gui,w_Set:Add,CheckBox,x150 y195 vset_7,使用 title
Gui,w_Set:Add,Button,x10 y235 w220 h30 Default gset_Save,保存设置
Loop,7
	GuiControl,w_Set:,set_%A_Index%,% arr_Option[A_Index]
Gui,w_Set:Show,,标签元素选项
Return

set_Save:
Loop,7
{
	GuiControlGet,tempStr,w_Set:,set_%A_Index%
	arr_Option[A_Index]:=tempStr
}
Gosub w_SetGuiClose
Return

w_SetGuiClose:
w_SetGuiEscape:
tempStr=
Loop,7
	tempStr .= arr_Option[A_Index]
If (tempStr<>str_Options){
	IniWrite,%tempStr%,%_ini_Path%,General,Options
	str_Options:=tempStr
}
tempStr=
Gui,%Main%:-Disabled
Gui,w_Set:Destroy
Return

;;------------全局设置------------------

globalSet:
Gui,Global_Set:New
Gui,%Main%:+Disabled
Gui,Global_Set:-MinimizeBox +Owner%Main%
Gui,Global_Set:Font,,微软雅黑
Gui,Global_Set:Add,Text,x10 y20,HTML模板目录
Gui,Global_Set:Add,Edit,x100 y15 w250 vpath_P1,%strPath_Template%
Gui,Global_Set:Add,Button,x355 y15 w30 h25 ggs_AddPath vgs_P1,...
Gui,Global_Set:Add,Text,x10 y60,文章保存目录
Gui,Global_Set:Add,Edit,x100 y55 w250 vpath_P2,%strPath_Post%
Gui,Global_Set:Add,Button,x355 y55 w30 h25 ggs_AddPath vgs_P2,...
Gui,Global_Set:Add,Text,x10 y100,主页生成目录
Gui,Global_Set:Add,Edit,x100 y95 w250 vpath_P3,%strPath_Index%
Gui,Global_Set:Add,Button,x355 y95 w30 h25 ggs_AddPath vgs_P3,...
Gui,Global_Set:Add,CheckBox,x15 y148 Checked%b_AutoNewIndex% vgs_AutoIndex,保存后自动更新首页
Gui,Global_Set:Add,Button,x180 y140 w100 h30 Default ggs_Save,确定
Gui,Global_Set:Add,Button,x285 y140 w100 h30 ggs_Cancel,取消
Gui,Global_Set:Show,,路径设置
Return

gs_AddPath:
Gui,Global_Set:+OwnDialogs
FileSelectFolder,tempStr,*%A_ScriptDir%,,选择路径
tempStr=%tempStr%
If ErrorLevel Or (tempStr="")
	Return
GuiControl,Global_Set:,% "path_" . SubStr(A_GuiControl,-1),%tempStr%
tempStr=
Return

gs_Save:
getStr1:=getStr2:=getStr3:=""
Loop,3
	GuiControlGet,getStr%A_Index%,Global_Set:,path_P%A_Index%
Gui,Global_Set:+OwnDialogs
If (getStr1="") Or (getStr2="") Or (getStr3="")
{
	MsgBox,262192,提示,必须指定所有目录位置！如目录不存在则会自动创建。
	Return
}
Loop,3
{
	If !FileExist(getStr%A_Index%)
		FileCreateDir,% getStr%A_Index%
}
getStr1:=Trim(getStr1,"\"),getStr2:=Trim(getStr2,"\"),getStr3:=Trim(getStr3,"\")
IniWrite,%getStr1%,%_ini_Path%,General,path_Template
IniWrite,%getStr2%,%_ini_Path%,General,path_Post
IniWrite,%getStr3%,%_ini_Path%,General,path_Index
GuiControlGet,b_AutoNewIndex,,gs_AutoIndex
IniWrite,%b_AutoNewIndex%,%_ini_Path%,General,AutoUpdateIndex
errFlag:=(strPath_Post="")?1:0
strPath_Template:=getStr1,strPath_Post:=getStr2,strPath_Index:=getStr3,getStr1:=getStr2:=getStr3:=""
Gosub Global_SetGuiClose
Gui,%Main%:Default
If errFlag
	Gosub _GetList
Return

gs_Cancel:
Global_SetGuiClose:
Global_SetGuiEscape:
Gui,%Main%:-Disabled
Gui,Global_Set:Destroy
Return

;;-------------生成首页-----------------

_Generate_Index:
tempStr:="",str_Tags:="|",arr_Tags:=[],nCount:=tagCount:=0
Loop,Files,%strPath_Post%\*.txt
{
	FileReadLine,getStr1,%A_LoopFileFullPath%,1
	FileReadLine,getStr2,%A_LoopFileFullPath%,2
	getStr2:=SubStr(Trim(getStr2,"`t `r`n"),6),getStr1:=RegexReplace(SubStr(Trim(getStr1,"`t `r`n"),6),"[\s/:]"),tempStr .= getStr1 . A_Tab . A_LoopFileName . A_Tab . getStr2 . "`n",nCount+=1
	Loop,Parse,getStr2,`,
	{
		If !InStr(str_Tags,"|" . A_LoopField . "|")
			str_Tags .= A_LoopField . "|",arr_Tags[A_LoopField]:=1
		Else
			tagCount:=arr_Tags[A_LoopField],tagCount+=1,arr_Tags[A_LoopField]:=tagCount
	}
}
tempText=
Loop,Parse,str_Tags,|
{
	If (A_LoopField="")
		Continue
	tempText .= "<span>" . A_LoopField . " (" .  arr_Tags[A_LoopField] . ")</span>"
}
outHTML:="`t<div id=""tags"">`n`t`t" . tempText . "`n`t</div>`n</div>`n",str_Tags:=tagCount:="",arr_Tags:=[]
Sort,tempStr,R
Loop,Parse,tempStr,`n
{
	If (A_LoopField="")
		Continue
	arr_Files:=StrSplit(A_LoopField,A_Tab),arr_key:=StrSplit(RegexReplace(arr_Files[3],"\s*,\s*"," ")," "),tempKey:=""
	For getStr1,getStr2 In arr_key
		tempKey .= "<span>" . getStr2 . "</span>"
	tempText:=SubStr(arr_Files[2],1,-4),outHTML .= "<div class=""box"" id=""s" . nCount . """>`n`t<div class=""f_t"">" . tempText . "</div>`n`t<div class=""f_i""><a href=""?s" . nCount . """>" . nCount .  "</a>" . TimeFormat(arr_Files[1]) . "`n`t`t<span class=""kt"">&nbsp;&bull; " . tempKey . "</span>`n`t</div>`n`t<div class=""f_c"" sflag=""0""></div>`n</div>`n",nCount-=1,arr_Files:=[]
}
FileRead,tempStr,%strPath_Template%\header.html
tempStr .= outHTML
FileRead,tempText,%strPath_Template%\footer.html
tempStr .= tempText
FileDelete,%strPath_Index%\index.html
FileAppend,%tempStr%,%strPath_Index%\index.html
tempStr:=tempText:=tempKey:=getStr1:=getStr2:=""
Return

TimeFormat(strIn){
	Return SubStr(strIn,1,4) . "/" . SubStr(strIn,5,2) . "/" . SubStr(strIn,7,2) . A_Space .  SubStr(strIn,9,2) . ":" . SubStr(strIn,11,2) . ":" . SubStr(strIn,13,2)
}

;;------------------------------

GuiClose:
ExitApp