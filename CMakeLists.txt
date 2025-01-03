cmake_minimum_required(VERSION 3.16)

project(MyPunchCard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick WebSockets)

qt_standard_project_setup(REQUIRES 6.5)

add_subdirectory(SupaQML)

if(ANDROID)
    include(android_openssl/android_openssl.cmake)
endif()

qt_add_executable(appMyPunchCard
    main.cpp
    resources.qrc
)

if (ANDROID)
    add_android_openssl_libraries(appMyPunchCard)
endif()

qt_add_qml_module(appMyPunchCard
    URI MyPunchCard
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES qml/LoginPage.qml
        QML_FILES qml/SignUpPage.qml
        QML_FILES qml/CustomerHomePage.qml
        QML_FILES qml/Settings.qml
        QML_FILES qml/UpdateName.qml
        QML_FILES qml/UpdateEmail.qml
        QML_FILES qml/ChangePassword.qml
        QML_FILES qml/SignOut.qml
        QML_FILES qml/userData.js
        QML_FILES qml/ConfirmSignUpPage.qml
        RESOURCES android/AndroidManifest.xml android/build.gradle android/res/values/libs.xml android/res/xml/qtprovider_paths.xml
        SOURCES qrcode.h qrcode.cpp
)
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMyPunchCard PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMyPunchCard
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMyPunchCard
    PRIVATE Qt6::Quick
    PRIVATE Qt6::WebSockets
)

include(GNUInstallDirs)
install(TARGETS appMyPunchCard
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
