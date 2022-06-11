# ========================= User Defined Macro ==============================
# Most time you just need edit user defined macro
!define PRODUCT_NAME           "WidgetExamples"
!define EXE_NAME               "WidgetExamples.exe"
!define EXE_RELATIVE_PATH      "bin\WidgetExamples.exe"
!define PRODUCT_VERSION        ""
!define PRODUCT_PUBLISHER      "WidgetExamples"
!define PRODUCT_LEGAL          "Copyright (C) 1999-2022 , All Rights Reserved"
!define INSTALL_ICON_PATH      "../Resource/logo.ico"
!define UNINSTALL_ICON_PATH    "../Resource/logo.ico"
!define DEFAULT_INSTALL_DIR    "$PROGRAMFILES\${PRODUCT_NAME}"

!ifdef DEBUG
!define UI_PLUGIN_NAME         QtWidgetPlugind
!define VC_RUNTIME_DLL_SUFFIX  d
!define QT_DLL_SUFFIX          d
!else
!define UI_PLUGIN_NAME         QtWidgetPlugin
!define VC_RUNTIME_DLL_SUFFIX
!define QT_DLL_SUFFIX
!endif

# ========================= User Defined Macro End ============================

!include "LogicLib.nsh"
!include "nsDialogs.nsh"

# ===================== Setup Info =============================
VIProductVersion                    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion"    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName"       "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName"       "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion"       "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName"      "${EXE_NAME}"
VIAddVersionKey "FileDescription"   "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright"    "${PRODUCT_LEGAL}"

# ==================== NSIS Attribute ================================

Unicode True
SetCompressor LZMA
!ifdef DEBUG
Name "${PRODUCT_NAME} [Debug]"
OutFile "${PRODUCT_NAME}Setup-Debug.exe"
!else
Name "${PRODUCT_NAME}"
OutFile "${PRODUCT_NAME}Setup.exe"
!endif

# ICON
Icon              "${INSTALL_ICON_PATH}"
UninstallIcon     "${UNINSTALL_ICON_PATH}"

# UAC
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel admin

# Custom Install Page
Page custom QtUiPage


# Show Uninstall details
UninstPage instfiles

# ======================= Qt Page =========================
Function QtUiPage
	${UI_PLUGIN_NAME}::OutputDebugInfo "NSIS Plugin Dir: $PLUGINSDIR"
	
	GetFunctionAddress $0 OnUIPrepared
	${UI_PLUGIN_NAME}::BindInstallEventToNsisFunc "UI_PREPARED" $0
	
	GetFunctionAddress $0 OnStartExtractFiles
	${UI_PLUGIN_NAME}::BindInstallEventToNsisFunc "START_EXTRACT_FILES" $0
	
	GetFunctionAddress $0 OnBeforeFinished
	${UI_PLUGIN_NAME}::BindInstallEventToNsisFunc "BEFORE_FINISHED" $0
	
	GetFunctionAddress $0 OnUserCancelInstall
	${UI_PLUGIN_NAME}::BindInstallEventToNsisFunc "USER_CANCEL" $0
	
    ${UI_PLUGIN_NAME}::ShowSetupUI "${PRODUCT_NAME} Setup" "${DEFAULT_INSTALL_DIR}" "$PLUGINSDIR"
FunctionEnd

Function OnUIPrepared
	${UI_PLUGIN_NAME}::OutputDebugInfo "OnUIPrepared"
FunctionEnd

Function OnStartExtractFiles
	${UI_PLUGIN_NAME}::OutputDebugInfo "OnStartExtractFiles"
	
	${UI_PLUGIN_NAME}::GetInstallDirectory
	Pop $0
	StrCmp $0 "" InstallAbort 0
    StrCpy $INSTDIR "$0"
	${UI_PLUGIN_NAME}::OutputDebugInfo "Install Dir: $0"
	
	SetOutPath $INSTDIR
  
    GetFunctionAddress $0 ___ExtractFiles
    ${UI_PLUGIN_NAME}::BackgroundRun $0
		
InstallAbort:
FunctionEnd


Function OnUserCancelInstall
	${UI_PLUGIN_NAME}::OutputDebugInfo "OnUserCancelInstall"
	Abort
FunctionEnd


Function OnBeforeFinished
	${UI_PLUGIN_NAME}::OutputDebugInfo "OnBeforeFinished"
	
	SetShellVarContext all
	CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
	CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR${EXE_RELATIVE_PATH}"
	CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall ${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
	SetShellVarContext current
	
	# Create Desktop Shortcut
	${UI_PLUGIN_NAME}::IsCreateDesktopShortcutEnabled
	Pop $0
	${If} $0 == 1
		SetShellVarContext all
		CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR${EXE_RELATIVE_PATH}"
		SetShellVarContext current
	${EndIf}
	
	# Auto Startup On Boot
	${UI_PLUGIN_NAME}::IsAutoStartupOnBootEnabled
	Pop $0
	${If} $0 == 1
		WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME}" "$INSTDIR${EXE_RELATIVE_PATH}"
	${EndIf}
FunctionEnd


Function CreateUninstall
	WriteUninstaller "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\${EXE_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher" "$INSTDIR\${PRODUCT_PUBLISHER}"
FunctionEnd

# Add an empty section, avoid compile error.
var SubProc
XPStyle on
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
${if} $1 = 100
System::Call user32::KillTimer(i$HWNDPARENT,i1)
${Endif}
FunctionEnd


# Uninstall Section
Section "Uninstall"
  SetShellVarContext all
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall ${PRODUCT_NAME}.lnk"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}\"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  SetShellVarContext current
  
  SetOutPath "$INSTDIR"

  ; Delete installed files
  Delete "$INSTDIR\*.*"

  SetOutPath "$DESKTOP"

  RMDir /r "$INSTDIR"
  RMDir "$INSTDIR"
  
  SetAutoClose true
SectionEnd

Function .onInit
	# makesure plugin directory exist
	InitPluginsDir
	
	# place Qt dlls to plugin directory
    File /oname=$PLUGINSDIR\Qt5Core${QT_DLL_SUFFIX}.dll "$%QTDIR%\bin\Qt5Core${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\Qt5Gui${QT_DLL_SUFFIX}.dll "$%QTDIR%\bin\Qt5Gui${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\Qt5Widgets${QT_DLL_SUFFIX}.dll "$%QTDIR%\bin\Qt5Widgets${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\Qt5Svg${QT_DLL_SUFFIX}.dll "$%QTDIR%\bin\Qt5Svg${QT_DLL_SUFFIX}.dll"
	
	CreateDirectory $PLUGINSDIR\platforms
	File /oname=$PLUGINSDIR\platforms\qwindows${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\platforms\qwindows${QT_DLL_SUFFIX}.dll"
	
	CreateDirectory $PLUGINSDIR\styles
	File /oname=$PLUGINSDIR\styles\qwindowsvistastyle${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\styles\qwindowsvistastyle${QT_DLL_SUFFIX}.dll"
	
	CreateDirectory $PLUGINSDIR\imageformats
	File /oname=$PLUGINSDIR\imageformats\qgif${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qgif${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qicns${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qicns${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qico${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qico${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qjpeg${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qjpeg${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qsvg${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qsvg${QT_DLL_SUFFIX}.dll"
	CreateDirectory $PLUGINSDIR\iconengines
	
	File /oname=$PLUGINSDIR\iconengines\qsvgicon${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\iconengines\qsvgicon${QT_DLL_SUFFIX}.dll"
	
	# place vc runtime dlls to plugin directory
	File /oname=$PLUGINSDIR\concrt140${VC_RUNTIME_DLL_SUFFIX}.dll "..\..\VCRuntimeDLL\concrt140${VC_RUNTIME_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\msvcp140${VC_RUNTIME_DLL_SUFFIX}.dll "..\..\VCRuntimeDLL\msvcp140${VC_RUNTIME_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\msvcp140_1${VC_RUNTIME_DLL_SUFFIX}.dll "..\..\VCRuntimeDLL\msvcp140_1${VC_RUNTIME_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\msvcp140_2${VC_RUNTIME_DLL_SUFFIX}.dll "..\..\VCRuntimeDLL\msvcp140_2${VC_RUNTIME_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\ucrtbase${VC_RUNTIME_DLL_SUFFIX}.dll "..\..\VCRuntimeDLL\ucrtbase${VC_RUNTIME_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\vccorlib140${VC_RUNTIME_DLL_SUFFIX}.dll "..\..\VCRuntimeDLL\vccorlib140${VC_RUNTIME_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\vcruntime140${VC_RUNTIME_DLL_SUFFIX}.dll "..\..\VCRuntimeDLL\vcruntime140${VC_RUNTIME_DLL_SUFFIX}.dll"
FunctionEnd

Function .onInstSuccess

FunctionEnd


Function .onInstFailed
    MessageBox MB_ICONQUESTION|MB_YESNO "Install Failed!" /SD IDYES IDYES +2 IDNO +1
FunctionEnd



# Before Uninstall
Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO "Are you sure to uninstall ${PRODUCT_NAME}?" /SD IDYES IDYES +2 IDNO +1
    Abort
FunctionEnd

Function un.onUninstSuccess

FunctionEnd