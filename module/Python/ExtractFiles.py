#!/usr/bin/python
# -*- coding: UTF-8 -*-
import string
import sys
import os
import argparse

class AppParser:
    Parser = None

    def __init__(self) -> None:
        self.Parser = argparse.ArgumentParser(description='The Nsis script installs the function generator.')
        # self.Parser.parse_args()
        self.Parser.add_argument('--builddir', type=str, help = "Nsis package directory")
        self.Parser.add_argument('--safeuninstall', action="store_true", help = "Whether the Nsis script is unloaded in safe mode")
        self.Parser.add_argument('--outdir', type=str, help = "Nsis script output path")


class ExtractFile:
    Packagedirectory = ""
    Safeuninstall = False
    NsisScript = ""
    __NsisFile = None
    __BuilDirTotalDimensions = 0

    def __init__(self, packdir, nsisscript, safeuninstall) -> None:
        self.Packagedirectory = packdir
        self.NsisScript = nsisscript
        self.Safeuninstall = safeuninstall
        pass

    def Build(self):
        if self.NsisScript[-1] != '/':
            self.NsisScript += '/'
        self.__NsisFile = open(self.NsisScript + "CatGrayBuildFunc.nsh", "w")
        self.__Buildinstall()
        self.__NsisFile.write("\n")
        self.__BuildUninstall()
        self.__NsisFile.close()
        self.__NsisFile = None
        pass

    def __Buildinstall(self):
        print(os.listdir(self.Packagedirectory))
        print(os.stat(self.Packagedirectory))
        self.__NsisFile.write("Function ___ExtractFiles\n")
        self.__NsisFile.write("FunctionEnd\n")
        pass

    def __BuildTraversalinstall(self, listdir):
        pass

    def __BuildUninstall(self):
        if self.Safeuninstall:
            self.__BuildSafeUninstall()
        else:
            self.__BuildUnSafeUninstall()
        pass

    def __BuildSafeUninstall(self):
        pass 
    

    def __BuildUnSafeUninstall(self):
        self.__NsisFile.write("Function un.UninstallAll\n")
        self.__NsisFile.write("   SetShellVarContext all\n")
        self.__NsisFile.write("   Delete \"$SMPROGRAMS\\${PRODUCT_NAME}\\${PRODUCT_NAME}.lnk\"\n")
        self.__NsisFile.write("   Delete \"$SMPROGRAMS\\${PRODUCT_NAME}\\Uninstall ${PRODUCT_NAME}.lnk\"\n")
        self.__NsisFile.write("   RMDir \"$SMPROGRAMS\\${PRODUCT_NAME}\"\n")
        self.__NsisFile.write("   Delete \"$DESKTOP\\${PRODUCT_NAME}.lnk\"\n")
        self.__NsisFile.write("   SetShellVarContext current\n")
        self.__NsisFile.write("   SetOutPath \"$INSTDIR\"\n")
        self.__NsisFile.write("   ; Delete installed files\n")
        self.__NsisFile.write("   Delete \"$INSTDIR\\*.*\"\n")
        self.__NsisFile.write("   SetOutPath \"$DESKTOP\"\n")
        self.__NsisFile.write("   RMDir /r \"$INSTDIR\"\n")
        self.__NsisFile.write("   RMDir \"$INSTDIR\"\n")
        self.__NsisFile.write("FunctionEnd\n")



if __name__ == '__main__':
    appparser = AppParser()
    args = appparser.Parser.parse_args()
    
    if args.builddir == None:
        sys.exit()
    if not os.path.exists(args.builddir):
        print("builddir Invalid path")
        sys.exit()

    if args.outdir == None:
        args.outdir = './'

    if not os.path.exists(args.outdir):
        os.makedirs(args.outdir)
        if not os.path.isdir(args.outdir):
            print("outdir Invalid path")
            sys.exit()

    extractfile = ExtractFile(args.builddir, args.outdir, args.safeuninstall)
    extractfile.Build()

    print("quit")