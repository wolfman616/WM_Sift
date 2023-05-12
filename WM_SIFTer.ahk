#noenv
#Singleinstance,Force
SetBatchLines,	-1
SetWinDelay,	-1
SetControlDelay,-1
CoordMode,tooltip,Screen
Coordmode,Mouse,Screen
menu,tray,icon,% "C:\Icon\40_20 Ribbon\search144.ico"
SetWorkingDir,% (ahkexe:= splitpath(A_AhkPath)).dir
#include C:\Script\AHK\- _ _ LiB\GoogleLucky.ahk 
timer("hidetray",-30000)
gosub Menutray
gosub varz
gosub onmsg

LoadAll:
Top:= (Topmost? " +AlwaysOnTop ":"")
if (a_thislabel="loadall") {
	Win_Animate(G_hWnd,"hide blend",900)
	sleep,1000
	try,gui,m: destroy
	 fileread,const,lib\_const\constants.csv
} else,fileread,const,lib\_const\const.csv
Loop,Parse,const,","
	data.= data? "`n" A_LoopField : A_LoopField
Display:= data, Options:= "in"
col:= {}, colw:= ((c1:= 238) +(c2:= 66) +(c3:= 76) +nuffer:= 25)
col:= ({1 : c1 , 2 : c2 ,3 : c3 , "W" : colw })
gui,m:New,-dpiscale %titleitem% %Top% +hwndG_hWnd ;+e0x2000000 
gui,m:Add,Edit,x88 y+0 w161 h25 vQueryText gQuery +E0x8 +hwndedithwnd ;,
ww:= ("w" . col.w),	wt:=("w" . col.w+4), wz:=col.w
gui,m:Add,ListView,grid x0 y6 %wW% h600 r20 gLVGlabl vLVGlabl +hwndlvhwnd +e0x00224008, wMsg | Dec | Hex ;w380
SendMessage,0x1036,0,0x14031,,ahk_id %lvhwnd% ;stylex
LV_ModifyCol(1,"text "  . col.1), LV_ModifyCol(2,"number right " . col.2), LV_ModifyCol(3,"Left "  . col.3)
Loop,Parse,Data,`n
{
	rows++
	Array1:= StrSplit(A_Loopfield,",")
	LV_Add("",Array1[1],Array1[3],Array1[2])
} gui,m:+lastfound +Resize +MaxSize%wz%x%sizemaxx% +MinSize%wz%x%sizeminx%
sleep,80
winset,exstyle,-0x8000000
gui,m:Show,% "na hide " wt " x" a_screenwidth-450 " y120 h900",% MainGuititle
winset,style,-0x40000
sleep,80
Win_Animate(G_hWnd,"ACTIVATE slide hneg",420)
winset,style,+0x40000
sleep,750
winactivate,
G_:= gPos:= wingetpos(g_hwnd), Hmain:= gpos.h
controlget,lvheadwnd,hwnd,,SysHeader321,ahk_id %G_hWnd%
DllCall("SetParent","ptr",edithwnd,"ptr",lvheadwnd)
return,

ONMsg:
onexit("fade")
OnMessage(0x0101,"WM_KEYUP")
OnMessage(0x6,"WM_activ8")
OnMessage(0x0047,"WM_WINDOWPOSCHANGED")
;OnMessage(0x0202,"WM_LBUTTONUP")
return,

WM_activ8(){
	global actime:= a_tickcount
}

bmlg(bind="", wParam="",lParam="",bum="",hwnd="") { ; tt(hwnd:= Format("{:#x}",hwnd) " awda" )
	global
	bmlog.= bind "," ;a_thisfunc " " wParam " " lParam " "bum " "hwnd " n"
}

menhandl(){
	switch a_thismenuitem {
		case "Topmost": (Top:="+alwaysonTop"? Top:="" : Top:="+alwaysonTop")
		case "titlebar\tray" : (titlei? titleitem:= " +toolwindow -caption " : titleitem:= "")
}	}

lbltogl:
%a_thislabel%:= !%a_thislabel%
gosub,loadall
return,  

~+LBUTTON::
bmlog:=""
return,

~^!t::
msgbox % bmlog
return,

Query:
gui,m:Submit,NoHide
Display:= Sift_Regex(Data,QueryText,Options), DisplayRows:= 0
Loop,Parse,Display,`n
{
	displayRows++
	displayRow%a_index%:= a_loopfield
} loop,% rows {
	if(a_index<=displayRows) {
		Array2:= StrSplit(displayRow%a_index%,",")
		LV_Modify(a_index,,Array2[1],Array2[2],Array2[3])
	} else,LV_Modify(a_index,,"","","")
}
return,

fade(){
	global
	winset,style,-0x40000,ahk_id %G_hWnd%
	sleep,500
	return,Win_Animate(G_hWnd,"hide slide hpos",420)
	sleep,2000
}

WM_WINDOWPOSCHANGED() {
	global lvhwnd,g_hwnd
	sleep,4
	Hmain:= (gpos:= wingetpos(g_hwnd)).h
	if !(inith=gpos.h) {
		dd:= Hmain -55
		guiControl,Move,% lvhwnd,h%dd%
		inith:=Hmain
}	}

LVGlabl: 
fbillg:="learn windows", eventi:= A_EventInfo
switch,A_guiControlEvent {
	case,"R" : LV_GetText(t1,A_EventInfo,1), LV_GetText(t2,A_EventInfo,3), LV_GetText(t3,A_EventInfo,2)
		clipboard:=name:= t1 . " " . t2 . " " . t3  ;try,Run,% URL:= googlelucky(t1) ;msgbox % URL 	;tt("Constant name: " (clipboard:=name) "`r`n(on clipboard also")
		return,
	case,"DoubleClick" :
		if(a_tickcount-actime)<800
			return
		LV_GetText(t1,A_EventInfo,1), LV_GetText(t2,A_EventInfo,3), LV_GetText(t3,A_EventInfo,2)
		, clipboard:=number:= t1 . " " . t2 . " " . t3 
		try,Run,% URL:= googlelucky(t1) 
		return, 	;default: tt(A_guiControlEvent "`n" A_EventInfo,3) ;return,
}
LV_GetText(t1,A_EventInfo,1)
return,

WM_lBUTTONDOWN(byref wParam,byref lParam) {
	global lbutton_cooldown, lbd, gpos, TrigG_L:= lhwnd:=false
	static rDPI:= A_ScreenDPI/96
	static rECT:= VarSetCapacity(RECT,16)
	mousegetpos,mmx,mmy
	ys:= hiword(lParam), xs:= loword(lParam), gpos:= wingetpos(g_hwnd)
	Coordmode,Mouse,window
	mousegetpos,mx,my,lhwnd
	if(lhwnd!=G_hWnd) {
		tt("not gui")
		return,
	} if(!GetKeyState("lbutton","P")) 
		return,
	While(LbD:=GetKeyState("lbutton","P")) {
		DllCall("GetCursorPos","Uint",&RECT)
		vWinX:= NumGet(&RECT,0,"Int")-mx, vWinY:= NumGet(&RECT,4,"Int")-my 
		win_move(g_hWnd,vWinX,vWiny,gpos.w,gpos.h,0x4001)
	} return,1
}

ldisgrace:
   lgrace:
return,

WM_LBUTTONup(wParam="", lParam="") { ;toggles maximise fill
	global TrigG_L,reslt:=LbD:=""
	mousegetpos,mmx,mmy,lhwnd ;tooltip,lbuulbuulbuulbuulbuu,mmx-200,mmy,2
	((reslt:= ((!TrigG_L)? "" : true))?( (tt("lclick"))) : (tt("moved")))
	TrigG_L:=""
	return, ;((reslt)?1:"")
}

WM_RBUTTONDOWN(byref wParam,byref lParam) {
	global RBUTTON_cooldown, rbd, gpos, TrigG_r,rhwnd:=false
	static rDPI:= A_ScreenDPI/96
	static rECT:= VarSetCapacity(RECT,16)
	Coordmode,Mouse,window
	mousegetpos,mx,my,rhwnd
	if(rhwnd!=G_hWnd)
		return,
	settimer,rgrace,-20
	ys:= hiword(lParam), xs:= loword(lParam), gpos:= wingetpos(g_hwnd)
	if(rbD:=GetKeyState("RBUTTON","P")) 
		settimer,rdisgrace,-150	;else,return,
	While(rbD:=GetKeyState("RBUTTON","P")) {
		((!rbd)? rbd:= true)
		DllCall("GetCursorPos","Uint",&RECT)
		vWinX:= NumGet(&RECT,0,"Int")-mx, vWinY:= NumGet(&RECT,4,"Int")-my 	; if(!TrigG_r) ; settimer,rdisgrace,150
		win_move(g_hWnd,vWinX,vWiny,gpos.w,gpos.h,0x4001)
	} if(!TrigG_r)
		return,1
			settimer,GuiMenu,-1
	return,
}

rgrace:
rdisgrace:
TrigG_r:= (instr(a_thislabel,"rdis")? "" : true)
return,

WM_rBUTTONup(wParam="", lParam="") { ;toggles maximise fill
	global TrigG_r,reslt:=RbD:=""
	mousegetpos,mmx,mmy,lhwnd ;tooltip,rbuurbuurbuurbuurbuu,mmx-200,mmy,2
	tt(((reslt:= ((!TrigG_r)? "" : true))? "menu" : "moved"))
	TrigG_r:= ""
	return,(reslt)? 1:("")
}

GuiMenu() { 
	LV_GetText(t1,eventi,1)
	msgbox % t1
	try,menu,new,delete
	menu,new,add,MSDN Documentation,googlelucky("learn.microsoft.com/en-us/windows/ +")
	menu,new,show
}

WM_KEYUP(wParam, lParam){
	global hWnd_Par
	static pp0:=MAKELONG(loword(36),hiword(62)) 
	switch,wParam {
		case,"27 ": ;esc
			settimer,guiclose,-1
			return,
		case,"13": ;enter
			gui,m: submit,nohide
			guiControl,Show,% lvhwnd ;goSub("editx")	; goSub("edity")	; goSub("Timertest2")
			send,{tab}
			sleep,70
			send,^{home}
			sleep,70
			loop,2
				sendmessage, 0x0200,0,%pp0%, SysHeader321,ahk_id %lvhwnd%
		default:
			;tt(wParam "`n" Format("{1:#x}",lParam))
			LV_Modify(1, "Vis")
			return,
}	}

menu(){
	menu,new,add, cunts, donothing
	menu,new,show
}

HiWord(Dword,Hex=0){
	BITS:=0x10,WORD:=0xFFFF
	return,(!Hex)?((Dword>>BITS)&WORD):Format("{1:#x}",((Dword>>BITS)&WORD))
}

LoWord(Dword,Hex=0){
	WORD:=0xFFFF
	return,(!Hex)?(Dword&WORD):Format("{1:#x}",(Dword&WORD))
}

MAKELONG(LOWORD,HIWORD,Hex=0){
	BITS:=0x10,WORD:=0xFFFF
	return,(!Hex)?((HIWORD<<BITS)|(LOWORD&WORD)):Format("{1:#x}",((HIWORD<<BITS)|(LOWORD&WORD)))
}

;{ Sift
; Fanatic Guru; 2015 04 30; Version 1.00;; LIBRARY to sift through a string or array and return items that match sift criteria.
;
; Functions: ; Sift_Regex(Haystack, Needle, Options, Delimiter)
;
;   Parameters:;   1) {Haystack}	String or array of information to search, ByRef for efficiency but Haystack is not changed by function
;
;   2) {Needle}		String providing search text or criteria, ByRef for efficiency but Needle is not changed by function
;
;	3) {Options}
;			IN		Needle anywhere IN Haystack item (Default = IN)
;			LEFT	Needle is to LEFT or beginning of Haystack item
;			RIGHT	Needle is to RIGHT or end of Haystack item
;			EXACT	Needle is an EXACT match to Haystack item
;			REGEX	Needle is an REGEX expression to check against Haystack item
;			OC		Needle is ORDERED CHARACTERS to be searched for even non-consecutively but in the given order in Haystack item 
;			OW		Needle is ORDERED WORDS to be searched for even non-consecutively but in the given order in Haystack item
;			UC		Needle is UNORDERED CHARACTERS to be search for even non-consecutively and in any order in Haystack item
;			UW		Needle is UNORDERED WORDS to be search for even non-consecutively and in any order in Haystack item
;
;			If an Option is all lower case then the search will be case insensitive
;
;	4)  {Delimiter}	Single character Delimiter of each item in a Haystack string (Default = `n)
;
;	Returns: 
;		If Haystack is string then a string is returned of found Haystack items delimited by the Delimiter
; 		If Haystack is an array then an array is returned of found Haystack items
;
; 	Note:
;		Sift_Regex searchs are all RegExMatch seaches with Needles crafted based on the options chosen
;
; Sift_Ngram(Haystack, Needle, Delta, Haystack_Matrix, Ngram Size, Format)
;
;	Parameters:
;	1) {Haystack}		String or array of information to search, ByRef for efficiency but Haystack is not changed by function
;
;   2) {Needle}			String providing search text or criteria, ByRef for efficiency but Needle is not changed by function
;
;	3) {Delta}			(Default = .7) Fuzzy match coefficient, 1 is a prefect match, 0 is no match at all, only results above the Delta are returned
;
;	4) {Haystack_Matrix} (Default = false)	
;			An object containing the preprocessing of the Haystack for Ngrams content
;			If a non-object is passed the Haystack is processed for Ngram content and the results are returned by ByRef
;			If an object is passed then that is used as the processed Ngram content of Haystack
;			If multiply calls to the function are made with no change to the Haystack then a previous processing of Haystack for Ngram content 
;				can be passed back to the function to avoid reprocessing the same Haystack again in order to increase efficiency.
;	5) {Ngram Size}		(Default = 3) The length of Ngram used.  Generally Ngrams made of 3 letters called a Trigram is good
;	6) {Format}			(Default = S`n)
;			S				Return Object with results Sorted
;			U				Return Object with results Unsorted
;			S%%%			Return Sorted string delimited by characters after S
;			U%%%			Return Unsorted string delimited by characters after U
;								Sorted results are by best match first
;	Returns:
;		A string or array depending on Format parameter.
;		If string then it is delimited based on Format parameter.
;		If array then an array of object is returned where each element is of the structure: {Object}.Delta and {Object}.Data
;			Example Code to access object returned:
;				for key, element in Sift_Ngram(Data, QueryText, NgramLimit, Data_Ngram_Matrix, NgramSize)
;						Display .= element.delta "`t" element.data "`n"
;	Dependencies: Sift_Ngram_Get, Sift_Ngram_Compare, Sift_Ngram_Matrix, Sift_SortResults
;		These are helper functions that are generally not called directly.  Although Sift_Ngram_Matrix could be useful to call directly to preprocess a large static Haystack
; 	Note:
;		The string "dog house" would produce these Trigrams: dog|og |g h| ho|hou|ous|use
;		Sift_Ngram breaks the needle and each item of the Haystack up into Ngrams.
;		Then all the Needle Ngrams are looked for in the Haystack items Ngrams resulting in a percentage of Needle Ngrams found
;

Sift_Regex(ByRef Haystack, ByRef Needle, Options := "IN", Delimit := "`n") {
	Sifted:= {}
	switch Options {
		case "IN" : Needle_Temp:= "\Q" Needle "\E"
		case "LEFT" : Needle_Temp:= "^\Q" Needle "\E"
		case "RIGHT" : Needle_Temp:= "\Q" Needle "\E$"
		case "EXACT" : Needle_Temp:= "^\Q" Needle "\E$"
		case "REGEX" : Needle_Temp:= Needle
		case "OC" : Needle_Temp:= RegExReplace(Needle,"(.)","\Q$1\E.*")
		case "OW" : Needle_Temp:= RegExReplace(Needle,"( )","\Q$1\E.*")
		case "UW" : Loop,Parse,Needle, " "
			Needle_Temp .= "(?=.*\Q" A_LoopField "\E)"
		case "UC" : Loop,Parse,Needle
			Needle_Temp .= "(?=.*\Q" A_LoopField "\E)"
	}
	if Options is lower
		Needle_Temp:= "i)" Needle_Temp
	if IsObject(Haystack)	{
		for,key,Hay in Haystack
			RegExMatch(Hay,Needle_Temp)? Sifted.Insert(Hay) : ()
	} else {
		Loop,Parse,Haystack,%Delimit%
			RegExMatch(A_LoopField,Needle_Temp)? Sifted .= A_LoopField Delimit : ()
		Sifted:= SubStr(Sifted,1,-1)
	}
	return,Sifted
}

Sift_Ngram(ByRef Haystack, ByRef Needle,Delta:= .7, ByRef Haystack_Matrix:= false, n:= 3, Format:= "S`n" ) {
	(!IsObject(Haystack_Matrix)? Haystack_Matrix:= Sift_Ngram_Matrix(Haystack,n))
	Needle_Ngram:= Sift_Ngram_Get(Needle,n)
	if IsObject(Haystack)	{
		Search_Results:= {}
		for,key,Hay_Ngram in Haystack_Matrix
			(!((Result:= Sift_Ngram_Compare(Hay_Ngram,Needle_Ngram)) < Delta)? 
		,	Search_Results[key,"Delta"]:= Result, Search_Results[key,"Data"]:= Haystack[key])
	} else {
		Search_Results:= {}
		Loop,Parse,Haystack,`n,`r
			(!((Result:= Sift_Ngram_Compare(Haystack_Matrix[A_Index], Needle_Ngram)) < Delta)?
		,	Search_Results[A_Index,"Delta"]:= Result, Search_Results[A_Index,"Data"]:= A_LoopField)
	}
	(Format ~= "i)^S")? Sift_SortResults(Search_Results) : ()
	if RegExMatch(Format,"i)^(S|U)(.+)$",Match)	{
		for,key,element in Search_Results
			String_Results .= element.data Match2
		return,SubStr(String_Results,1,-StrLen(Match2))
	}
	else,return,Search_Results
}

Sift_Ngram_Get(ByRef String,n:= 3) {
	Pos:= 1, Grams:= {}
	Loop, % (1 + StrLen(String) -n)
		gram:= SubStr(String, A_Index,n), Grams[gram] ? Grams[gram] ++ : Grams[gram]:= 1
	return,Grams
}

Sift_Ngram_Compare(ByRef Hay,ByRef Needle) {
	for,gram,Needle_Count in Needle
	{
		Needle_Total += Needle_Count
		Match += (Hay[gram] > Needle_Count? Needle_Count : Hay[gram])
	}
	return,Match / Needle_Total
}

Sift_Ngram_Matrix(ByRef Data,n:= 3) {
	if IsObject(Data) {
		Matrix:= {}
		for,key,string in Data
			Matrix.Insert(Sift_Ngram_Get(string,n))
	} else {
		Matrix:= {}
		Loop,Parse,Data,`n
			Matrix.Insert(Sift_Ngram_Get(A_LoopField,n))
	}
	return,Matrix
}

Sift_SortResults(ByRef Data) {
	Data_Temp:= {}
	for,key,element in Data
		Data_Temp[element.Delta SubStr("0000000000" key, -9)]:= element
	Data:= {}
	for,key,element in Data_Temp
		Data.InsertAt(1,element)
	return,
}
MenuPost(wMsgEnum="") {	;PostMessage,0x0111,% wMsgEnum,,,% A_ScriptName " - AutoHotkey"
	return,DllCall("PostMessage","Ptr",a_scripthwnd,"UInt",0x0111,"int",wMsgEnum,"int",0) 
}

Win_Animate(Hwnd,Type="",Time=100) {
	static AW_ACTIVATE = 0x20000,AW_BLEND=0x80000,AW_CENTER=0x10,AW_HIDE=0x10000
		, AW_HNEG=0x2,AW_HPOS=0x1,AW_SLIDE=0x40000,AW_VNEG=0x8,AW_VPOS=0x4
	hFlags:= 0
	loop,parse,Type,%A_Tab%%A_Space%,%A_Tab%%A_Space%
		ifEqual,A_LoopField,,continue
		else,hFlags |= AW_%A_LoopField%
	ifEqual,hFlags,,return "Err: Some of the types are invalid"
	dllcall("AnimateWindow","uint",Hwnd,"uint",Time,"uint",hFlags)
}

MenHandla(Enum="") {
	(Enum=""? (A_Thismenuitem? Enum:= A_Thismenuitem : msgb0x("a_thislabel")))
	switch,Enum {
		case,"Preserve Position Characteristics": opt_movecenter:= !opt_movecenter
			menu,Tray,icon,% opt_movecenter? "Move Center":(),% opt_movecenter? "C:\Icon\256\ticAMIGA.ico":()
			return,
		case,"65303-65307","65407" : return,MenuPost(a_thislabel) ;PostMessage,0x0111,% (%a_thislabel%),,,% A_ScriptName " - AutoHotkey"
		case,"Open"        : return,MenuPost(65407)
		case,"Edit Script" : return,MenuPost(65304)
		case,"Pause"       : return,MenuPost(65306)
		case,"Suspend VKs" : return,MenuPost(65305)
		case,"Reload"      : return,MenuPost(65303)
		case,"Exit"        : return,MenuPost(65307)
	}
}

menutray:
menu,tray,add,% "All Constants",% "loadall"
menu,tray,add,% "hide trayicon",% "hidetray"
menu,tray,icon,% "hide trayicon",% "C:\Icon\32\32.ico"
menu,tray,add,% "dont hide tray this time",% "donthidetray"
menu,tray,icon,% "dont hide tray this time",% "C:\Icon\32\32.ico"
menu,tray,add,% "Topmost",menhandl
menu,tray,icon,% "Topmost",% "C:\Icon\32\32.ico"
menu,tray,add,% "titlebar\tray",menhandl
menu,tray,icon,% "titlebar\tray",% "C:\Icon\32\32.ico"
return,

varz:
global MainGuititle:= "WM_FIND-SIFT"
,rect,G_hWnd,lvhwnd,dd,TrigG_L,TrigG_R,LbD,RbD,lbutton_cooldown,rbutton_cooldown,Hmain,Top,t1,t2,t3,bmlog
, sizemaxx:= 1144,	sizeminx:= 140, actime
, titleitem:= " +toolwindow -caption "
Topmost:= False
return,
hidetray:
donthidetray:
switch a_thislabel {
	case "donthidetray"	:	timer("hidetray",off)
	case "hidetray"		:	menu,tray,noicon
} donothing:
return,

guiescape:
guiClose:
ExitApp,