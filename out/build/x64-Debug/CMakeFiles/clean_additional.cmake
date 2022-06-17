# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CatQtPlugins\\QuickPlugin\\CMakeFiles\\QtQuickPlugind_autogen.dir\\AutogenUsed.txt"
  "CatQtPlugins\\QuickPlugin\\CMakeFiles\\QtQuickPlugind_autogen.dir\\ParseCache.txt"
  "CatQtPlugins\\QuickPlugin\\QtQuickPlugind_autogen"
  "CatQtPlugins\\WidgetPlugin\\CMakeFiles\\QtWidgetPlugind_autogen.dir\\AutogenUsed.txt"
  "CatQtPlugins\\WidgetPlugin\\CMakeFiles\\QtWidgetPlugind_autogen.dir\\ParseCache.txt"
  "CatQtPlugins\\WidgetPlugin\\QtWidgetPlugind_autogen"
  )
endif()
