!if "${NSIS_CHAR_SIZE}" = 1 
!define __WNDSUBCLASS_NSISVEROK 
!endif 
!include "WndSubclass.nsh"
!include "LogicLib.nsh"

var SubProc
XPStyle on
page instfiles "" instshow
ShowInstDetails nevershow
OutFile "Nsistest.exe"
Name "test"
Section "Test"
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
Sleep 500
SectionEnd

Function instshow
#借用WndSubclass插件设定timer函数地址(尝试过直接为settimer设定函数地址,但没有插件支持很困难)
${WndSubclass_Subclass} $HWNDPARENT SubProc $SubProc $SubProc
System::Call user32::SetTimer(i$HWNDPARENT,i1,i500,i0)
FunctionEnd

Function SubProc
FindWindow $0 "#32770" "" $HWNDPARENT
GetDlgItem $0 $0 1004
SendMessage $0 0x0407 0 0 $1
SendMessage $0 0x0408 0 0 $2
IntOp $2 $2 * 100
IntOp $1 $2 / $1
DetailPrint $1%
MessageBox MB_OK "$1%"
${if} $1 = 100
System::Call user32::KillTimer(i$HWNDPARENT,i1)
${Endif}
FunctionEnd