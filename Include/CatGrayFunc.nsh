
; -----------------------------------------------------------------
; BuildTheInstallationDirectory (params on stack):
;      define BUILDDIR_PATH        -       Build The Installation Directory
; -----------------------------------------------------------------
Function BuildTheInstallationDirectory
  SetOutPath $INSTDIR
  ; 放置文件
  File /r "${BUILDDIR_PATH}\*.*"
FunctionEnd