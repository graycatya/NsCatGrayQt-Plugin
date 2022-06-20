# ========================= User Defined Macro ==============================
# Most time you just need edit user defined macro


!define PRODUCT_NAME           "WidgetExamples"
!define EXE_NAME               "WidgetExamples.exe"
!define EXE_RELATIVE_PATH      "bin\WidgetExamples.exe"
!define PRODUCT_VERSION        "0.0.0.0"
!define PRODUCT_PUBLISHER      "WidgetExamples"
!define PRODUCT_LEGAL          "Copyright (C) 1999-2022 , All Rights Reserved"
!define INSTALL_ICON_PATH      "../Resource/logo.ico"
!define UNINSTALL_ICON_PATH    "../Resource/logo.ico"
!define DEFAULT_INSTALL_DIR    "$PROGRAMFILES\${PRODUCT_NAME}"
!define BUILDDIR_PATH "..\..\Include"

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

; !addincludedir "../../Include/"

; !include "CatGrayFunc.nsh"

# ICON
Icon              "${INSTALL_ICON_PATH}"
UninstallIcon     "${UNINSTALL_ICON_PATH}"

# UAC
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel admin

ShowInstDetails show

# Custom Install Page
Page custom QtUiPage


# Show Uninstall details
UninstPage instfiles
; ShowUnInstDetails show

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

Function ___ExtractFiles

    SetOutPath "$INSTDIR"
	${UI_PLUGIN_NAME}::SetInstallStepDescription "Clear" 0
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 5
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 10
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 15
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 20
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 25
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 30
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 35
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 40
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 45
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 50
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 55
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 60
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 65
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 70
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 75
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 80
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 85
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 90
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 92
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 94
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 96
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 97
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "" 98
	Sleep 500
	${UI_PLUGIN_NAME}::SetInstallStepDescription "Finished" 100
	Call OnAfterExtractFiles

FunctionEnd

Function OnAfterExtractFiles

	${UI_PLUGIN_NAME}::OutputDebugInfo "OnAfterExtractFiles"

	${UI_PLUGIN_NAME}::NsisExtractFilesFinished

	Call CreateUninstall

FunctionEnd


Function CreateUninstall
	WriteUninstaller "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\${EXE_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher" "$INSTDIR\${PRODUCT_PUBLISHER}"
FunctionEnd


# Add an empty section, avoid compile error.
Section "None"

SectionEnd

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
	
	CreateDirectory $PLUGINSDIR\audio
	File /oname=$PLUGINSDIR\audio\qtaudio_wasapi${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\audio\qtaudio_wasapi${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\audio\qtaudio_windows${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\audio\qtaudio_windows${QT_DLL_SUFFIX}.dll"

	CreateDirectory $PLUGINSDIR\platforms
	File /oname=$PLUGINSDIR\platforms\qwindows${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\platforms\qwindows${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\platforms\qminimal${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\platforms\qminimal${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\platforms\qdirect2d${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\platforms\qdirect2d${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\platforms\qoffscreen${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\platforms\qoffscreen${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\platforms\qwebgl${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\platforms\qwebgl${QT_DLL_SUFFIX}.dll"

	CreateDirectory $PLUGINSDIR\platformthemes
	File /oname=$PLUGINSDIR\platformthemes\qxdgdesktopportal${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\platformthemes\qxdgdesktopportal${QT_DLL_SUFFIX}.dll"
	
	CreateDirectory $PLUGINSDIR\styles
	File /oname=$PLUGINSDIR\styles\qwindowsvistastyle${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\styles\qwindowsvistastyle${QT_DLL_SUFFIX}.dll"
	
	CreateDirectory $PLUGINSDIR\imageformats
	File /oname=$PLUGINSDIR\imageformats\qgif${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qgif${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qicns${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qicns${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qico${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qico${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qjpeg${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qjpeg${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qsvg${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qsvg${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qtga${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qtga${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qtiff${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qtiff${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qwbmp${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qwbmp${QT_DLL_SUFFIX}.dll"
	File /oname=$PLUGINSDIR\imageformats\qwebp${QT_DLL_SUFFIX}.dll "$%QTDIR%\plugins\imageformats\qwebp${QT_DLL_SUFFIX}.dll"

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

; Function un.onInit

;     MessageBox MB_ICONQUESTION|MB_YESNO "Are you sure to uninstall ${PRODUCT_NAME}?" /SD IDYES IDYES +2 IDNO +1

;     Abort

; FunctionEnd



; Function un.onUninstSuccess



; FunctionEnd