cmake_minimum_required(VERSION 3.10)

project(QtWidgetPlugin LANGUAGES CXX)

MESSAGE(STATUS "operation system is ${CMAKE_SYSTEM}")

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(QT_QMAKE_EXECUTABLE ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../module/cmake")

include(GrayCatQt)

load_name_static(STATIC_NAME) 
message(STATUS ${STATIC_NAME})

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../../NsCatGrayQtCore/)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Gui Core Widgets REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Gui Core Widgets REQUIRED)

set(PROJECT_QRC_SOURCE_FILES ${PROJECT_SOURCE_DIR}/Resources/Resource.qrc)

qt5_add_resources(PROJECT_QRC_FILES ${PROJECT_QRC_SOURCE_FILES})




file(GLOB SRC_HEAD_LIST "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
file(GLOB SRC_UI_LIST "${CMAKE_CURRENT_SOURCE_DIR}/*.ui")

filtration_aux_source_directory(CURPATH_DIR_LIB_SRCS)

if(CMAKE_BUILD_TYPE AND (CMAKE_BUILD_TYPE STREQUAL "Debug"))
    add_library(${PROJECT_NAME}d MODULE ${CURPATH_DIR_LIB_SRCS}
                                        ${PROJECT_QRC_FILES}
                                        ${SRC_HEAD_LIST}
                                        ${SRC_UI_LIST})
    set_target_properties(${PROJECT_NAME}d PROPERTIES COMPILE_FLAGS "-m32" LINK_FLAGS "-m32")
    target_link_libraries(${PROJECT_NAME}d
      PRIVATE Qt${QT_VERSION_MAJOR}::Core
              Qt${QT_VERSION_MAJOR}::Gui
              Qt${QT_VERSION_MAJOR}::Widgets)

    target_link_libraries(${PROJECT_NAME}d PRIVATE dwmapi user32 shell32 advapi32)

    target_link_libraries(${PROJECT_NAME}d PRIVATE NsCatGrayQtCore)

    target_include_directories(${PROJECT_NAME}d PUBLIC ${PROJECT_SOURCE_DIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/CatQtPlugins/WidgetPlugin/${PROJECT_NAME}d.dll)

    set(NSIS_DIR $ENV{NSIS_DIR}/Plugins/x86-unicode/${PROJECT_NAME}d.dll)

    execute_process(COMMAND ${CMAKE_COMMAND} -E
    copy "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}"  "${NSIS_DIR}"
    )

elseif(CMAKE_BUILD_TYPE AND (CMAKE_BUILD_TYPE STREQUAL "Release"))
    add_library(${PROJECT_NAME} MODULE ${CURPATH_DIR_LIB_SRCS}
                                        ${PROJECT_QRC_FILES}
                                        ${SRC_HEAD_LIST}
                                        ${SRC_UI_LIST})
    set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "-m32" LINK_FLAGS "-m32")
    target_link_libraries(${PROJECT_NAME}
      PRIVATE Qt${QT_VERSION_MAJOR}::Core
              Qt${QT_VERSION_MAJOR}::Gui
              Qt${QT_VERSION_MAJOR}::Widgets)

    target_link_libraries(${PROJECT_NAME} PRIVATE dwmapi user32 shell32 advapi32)

    target_link_libraries(${PROJECT_NAME} PRIVATE NsCatGrayQtCore)

    target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/CatQtPlugins/WidgetPlugin/${PROJECT_NAME}.dll)

    set(NSIS_DIR $ENV{NSIS_DIR}/Plugins/x86-unicode/${PROJECT_NAME}.dll)

    execute_process(COMMAND ${CMAKE_COMMAND} -E
    copy "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}"  "${NSIS_DIR}"
    )

else()
endif()

message(STATUS ${CMAKE_BINARY_DIR})


