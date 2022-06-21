#!/usr/bin/python
# -*- coding: UTF-8 -*-
import string
import sys
import os
import argparse
from queue import LifoQueue

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
    __BuilFileTotalDimensions = 0
    __CurScriptIndex = 0
    __UnStack = LifoQueue()

    def __init__(self, packdir, nsisscript, safeuninstall) -> None:
        self.Packagedirectory = packdir
        self.NsisScript = nsisscript
        self.Safeuninstall = safeuninstall
        pass

    def Build(self):
        if self.NsisScript[-1] != '/':
            self.NsisScript += '/'
        
        self.__NsisFile = open(self.NsisScript + "CatGrayBuildFunc.nsh", "w")
        self.__CurScriptIndex = 0
        self.__BuildPathStatistics(self.Packagedirectory)
        self.__Buildinstall()
        self.__NsisFile.write("\n")
        self.__CurScriptIndex = 0
        self.__BuildUninstall()
        self.__NsisFile.close()
        self.__NsisFile = None

        pass

    def __Buildinstall(self):
        self.__NsisFile.write("Function ___ExtractFiles\n")
        self.__BuildTraversalinstall(self.Packagedirectory)
        self.__NsisFile.write("FunctionEnd\n")
        pass

    def __BuildTraversalinstall(self, dir):
        if not os.path.isdir(dir):
            return
        
        for fi in os.listdir(dir):
            full_path = os.path.join(dir, fi)

            if os.path.isdir(full_path):
                sub_dir = full_path[len(self.Packagedirectory):]
                self.__CurScriptIndex += 1
                self.__NsisFile.write('   CreateDirectory "$INSTDIR{0}"\n'.format(sub_dir))
                self.__NsisFile.write('   {0}::SetInstallStepDescription "Create Directory: {1}" {2}\n'
                                             .format('${UI_PLUGIN_NAME}', '$INSTDIR' + sub_dir,
                                                     self.__CurScriptIndex * 100 / (self.__BuilDirTotalDimensions + self.__BuilFileTotalDimensions)))
                self.__BuildTraversalinstall(full_path)
            else:
                self.__CurScriptIndex += 1
                self.__NsisFile.write('   SetOutPath "$INSTDIR{0}"\n'.format(dir[len(self.Packagedirectory):]))
                self.__NsisFile.write('   File "{0}"\n'.format(full_path))
                self.__NsisFile.write('   {0}::SetInstallStepDescription "Extract File: $INSTDIR{1}" {2}\n'
                                             .format('${UI_PLUGIN_NAME}', full_path[len(self.Packagedirectory):], 
                                             self.__CurScriptIndex * 100 / (self.__BuilDirTotalDimensions + self.__BuilFileTotalDimensions)))
        pass

    def __BuildUninstall(self):
        if self.Safeuninstall:
            self.__NsisFile.write("Function un.UninstallAll\n")
            self.__BuildSafeUninstall(self.Packagedirectory)
            while not self.__UnStack.empty(): 
                self.__NsisFile.write(self.__UnStack.get())
            self.__NsisFile.write('   RMDir "$INSTDIR"\n')
            self.__NsisFile.write('   {0}::SetUnInstallStepDescription "Delete Folder: $INSTDIR" {1}\n' \
                                             .format('${UI_PLUGIN_NAME}', 
                                             100))
            self.__NsisFile.write("FunctionEnd\n")
        else:
            self.__BuildUnSafeUninstall()
        pass

    def __BuildSafeUninstall(self, dir):

        if not os.path.isdir(dir):
            return
        for fi in os.listdir(dir):
            full_path = os.path.join(dir, fi)

            if os.path.isdir(full_path):
                sub_dir = full_path[len(self.Packagedirectory):]
                self.__CurScriptIndex += 1
                script = '   RMDir "$INSTDIR{0}"\n'.format(sub_dir)
                script += '   {0}::SetUnInstallStepDescription "Delete Folder: $INSTDIR{1}" {2}\n' \
                                             .format('${UI_PLUGIN_NAME}', full_path[len(self.Packagedirectory):], 
                                             100 - (self.__CurScriptIndex * 100 / (self.__BuilDirTotalDimensions + self.__BuilFileTotalDimensions)))
                self.__UnStack.put(script)
                self.__BuildSafeUninstall(full_path)
                pass
            else:
                self.__CurScriptIndex += 1
                script = '   Delete "$INSTDIR{0}"\n'.format(full_path[len(self.Packagedirectory):])
                script += '   {0}::SetUnInstallStepDescription "Delete File: $INSTDIR{1}" {2}\n' \
                                             .format('${UI_PLUGIN_NAME}', full_path[len(self.Packagedirectory):], 
                                             100 - (self.__CurScriptIndex * 100 / (self.__BuilDirTotalDimensions + self.__BuilFileTotalDimensions)))
                self.__UnStack.put(script)
                
                pass

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

    def __BuildPathStatistics(self, path):
        if not os.path.isdir(path):
            return 
        
        files = os.listdir(path)
        for fi_index in files:
            fi_d = os.path.join(path, fi_index)
            if os.path.isdir(fi_d):
                self.__BuilDirTotalDimensions += 1
                self.__BuildPathStatistics(fi_d)
            else:
                self.__BuilFileTotalDimensions += 1




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