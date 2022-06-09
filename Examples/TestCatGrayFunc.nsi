; This is just an example of TestCatGrayFunc Plugin
; 

!define PRODUCT_NAME "TestCatGrayFunc"
!define PRODUCT_VERSION ""
!define PRODUCT_PUBLISHER "TestCatGrayFunc"
!define BUILDDIR_PATH "..\Include"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

Name "TestCatGrayFunc Example"
OutFile "TestCatGrayFunc.exe"
RequestExecutionLevel User
Unicode True

!addincludedir "../Include/"

!include "CatGrayFunc.nsh"

Section "Ordinal"
    Call buildTheInstallationDirectory
SectionEnd