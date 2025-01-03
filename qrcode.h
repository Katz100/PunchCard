#ifndef QRCODE_H
#define QRCODE_H

#include <QObject>
#include <QQmlEngine>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class QRCode : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY widthChanged FINAL)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY heightChanged FINAL)
    Q_PROPERTY(QString data READ data WRITE setData NOTIFY dataChanged FINAL)
    QML_ELEMENT
public:
    explicit QRCode(QObject *parent = nullptr);

    Q_INVOKABLE void requestQRCode();

    int width() const;
    void setWidth(int newWidth);

    int height() const;
    void setHeight(int newHeight);

    QString data() const;
    void setData(const QString &newData);

signals:

    void messageReceived(QString message);

    void widthChanged();
    void heightChanged();

    void dataChanged();

private:
    int m_width;
    int m_height;
    QString m_data;

    QNetworkAccessManager m_manager;
    QNetworkRequest m_request;
};

#endif // QRCODE_H
