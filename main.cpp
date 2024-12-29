#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSslSocket>
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Katz Company");
    qDebug() << "******************Supports ssl: " << QSslSocket::supportsSsl();
    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MyPunchCard", "Main");

    return app.exec();
}
