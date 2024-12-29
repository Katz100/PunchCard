cmake_minimum_required(VERSION 3.16)

find_package(Qt6 REQUIRED COMPONENTS Core WebSockets)

project(SupaQML)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

qt_add_library(${PROJECT_NAME} STATIC)
qt_add_qml_module(${PROJECT_NAME}
    URI ${PROJECT_NAME}
    SOURCES
    supaserver.h
    supaserver.cpp
    supasocket.h
    supasocket.cpp
    supaauth.h
    supaauth.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::WebSockets
)
