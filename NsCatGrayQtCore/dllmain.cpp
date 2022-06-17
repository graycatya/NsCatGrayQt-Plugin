/*******************************************************************************************************************************************************
  #@@        *@    *@@%#@@#    &@    #@%@@,         @(        &@   .@.     @@@@@@@%     @         @(        &@     .@@@%&@@&     &@    @@#        %@
  #@/@       *@   *@      @%   &@   %@      @/      @(        &@   .@.     @,     ,@    @         @(        &@    @@        @*   &@    @,&@       %@
  #@  @(     *@   ,@           &@   #@              @(        &@   .@.     @,      @*   @         @(        &@   @&              &@    @, *@      %@
  #@   &@    *@     @@@,       &@    *@@%           @(        &@   .@.     @,     &@    @         @(        &@   @,              &@    @,   @(    %@
  #@    ,@   *@         .@@.   &@         (@@       @(        &@   .@.     @@@@@@%      @         @(        &@   @,     @@@@@&   &@    @,    @@   %@
  #@      @/ *@           *@   &@           &@      @(        @@   .@.     @,           @         @(        @@   @&         &&   &@    @,     (@. %@
  #@       @@,@   @@      (@   &@   @#      &@      (@       (@.   .@.     @,           @         (@       (@.    @@        &&   &@    @,       @%%@
  #@        *@@    (@@%#&@&    &@    %@@#%@@(         @@@%&@@(     .@.     @,           @@@@@@@@    @@@%&@@(        @@@%&@@@     &@    @,        %@@

* Copyright (C) 2018 - 2020, winsoft666, <winsoft666@outlook.com>.
*
* THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
* EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
*
* Expect bugs
*
* Please use and enjoy.
* Please let me know of any bugs/improvements that you have found/implemented and I will fix/incorporate them into this file.
********************************************************************************************************************************************************/


#include "stdafx.h"
#include<fstream>

BOOL APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved) {
    std::ofstream ofs;
    ofs.open("./DllMain.txt", std::ios::out | std::ios::app);
    ofs << "DllMain" << std::endl;
    switch (ul_reason_for_call) {
        case DLL_PROCESS_ATTACH: {
            ofs << "DLL_PROCESS_ATTACH" << std::endl;
            PluginContext::Instance()->SetPluginHandle(hModule);
            break;
        }
        case DLL_THREAD_ATTACH: {
            ofs << "DLL_THREAD_ATTACH" << std::endl;
            PluginContext::Instance()->SetPluginHandle(hModule);
            break;
        }
        case DLL_THREAD_DETACH: {
            ofs << "DLL_THREAD_DETACH" << std::endl;
            PluginContext::Instance()->SetPluginHandle(hModule);
            break;
        }
        case DLL_PROCESS_DETACH: {
            ofs << "DLL_PROCESS_DETACH" << std::endl;
            PluginContext::Instance()->SetPluginHandle(hModule);
            break;
        }
    }

    ofs.close();
    return TRUE;
}

