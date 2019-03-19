Gui,+Resize +minsize
Gui,Font,,Fixedsys
Gui,Add,Edit,x10 y55 Multi vc_Box,
Gui,Font,,微软雅黑
Gui,Add,GroupBox,x10 y0 w600 h50
Gui,Add,Radio,x20 y20 gc_Sel vc_t1,世界史(&W)
Gui,Add,Radio,x120 y20 gc_Sel vc_t2,中国史(&Z)
Gui,Add,Radio,x220 y20 gc_Sel vc_t3,汽车台(&C)
Gui,Add,Radio,x320 y20 gc_Sel vc_t4,小百科(&K)
Gui,Add,Button,x420 y16 w70 h25 gc_btn vc_Save,保存(&S)
Gui,Add,Button,x495 y16 w90 h25 gc_btn vc_Build,生成网页(&G)
Gui,Show,h650 w800,stone 漫画网页生成器
Return

^1::Reload

GuiSize:
GuiControl,MoveDraw,c_Box,% "w" A_GuiWidth-20 "h" A_GuiHeight-60
Return

c_Sel:
sPath:=A_ScriptDir . "\" . _GetCurr() . ".txt"
FileRead,tempStr,*P65001 %sPath%
GuiControl,,c_Box,%tempStr%
GuiControl,Focus,c_Box
SendInput ^{End}{Enter}
tempStr=
Return

c_btn:
Gui,+OwnDialogs
If (A_GuiControl="c_Save"){
	GuiControlGet,tempStr,,c_Box
	tempStr:=Trim(tempStr,"`r`n `t")
	sPath:=A_ScriptDir . "\" . _GetCurr() . ".txt"
	If FileExist(sPath)
		FileDelete,%sPath%
	FileAppend,%tempStr%,%sPath%,UTF-8-Raw
	If !ErrorLevel
		MsgBox,262208,保存文件,文件已保存到：`n%sPath%
	tempStr:=sPath:=""
}Else{
	arr_Cat:=["世界史","中国史","汽车台","小百科"],outStr:=""
	For s1,s2 In arr_Cat
	{
		outStr .= "`n`t<div class=""cat"">`n`t`t<div class=""title"">" . s1 . " - " . s2 . "</div>`n`t`t<div class=""list""><ul>`n",sPath:=A_ScriptDir . "\" . s1 . ".txt",arr_Box:=[]
		FileRead,tempStr,*P65001 %sPath%
		Loop,Parse,tempStr,`n
		{
			tempText:=Trim(A_LoopField,"`r`n `t")
			If (tempText="")
				Continue
			arr_Box.InsertAt(1,tempText)
		}
		For getStr1,getStr2 In arr_Box
		{

			Loop,Parse,getStr2,csv
				s%A_Index%:=Trim(A_LoopField)
			outStr .= "`t`t`t<li data=""" . s2 . """>" . getStr1 . "." . A_Space . s1 . "</li>`n"
		}
		outStr .= "`t`t</ul></div>`n`t</div>",arr_Box:=[]
	}
	FileRead,getStr1,*P65001 %A_ScriptDir%\header.html
	FileRead,getStr2,*P65001 %A_ScriptDir%\footer.html
	sPath:="..\index.html"
	If FileExist(sPath)
		FileDelete,%sPath%
	FileAppend,%getStr1%%outStr%%getStr2%,%sPath%,UTF-8-Raw
	MsgBox,262208,生成网页,成功生成网页！
}
Return

_GetCurr(){
	Loop,4
	{
		GuiControlGet,tempStr,,c_t%A_Index%
		If tempStr
		{
			str_Curr:=A_Index
			Break
		}
	}
	Return str_Curr
}

GuiClose:
ExitApp