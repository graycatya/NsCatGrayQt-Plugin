
; -----------------------------------------------------------------
; buildTheInstallationDirectory (params on stack):
;      define BUILDDIR_PATH        -       Build The Installation Directory
; -----------------------------------------------------------------
Function BuildTheInstallationDirectory
  SetOutPath "$INSTDIR"
  ; 放置文件
  File /r "${BUILDDIR_PATH}\*.*"
FunctionEnd

Function un.UninstallAll

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

FunctionEnd