#include "SBarcodeScanner.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSslSocket>
#include <QPermissions>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Katz Company");
    QQmlApplicationEngine engine;
    \
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
        qmlRegisterType<SBarcodeFilter>("com.scythestudio.scodes", 1, 0, "SBarcodeScanner");
#else
        qmlRegisterType<SBarcodeScanner>("com.scythestudio.scodes", 1, 0, "SBarcodeScanner");
#endif

        qApp->requestPermission(QCameraPermission{}, [](const QPermission &permission) {
        });
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MyPunchCard", "Main");

    return app.exec();
}
