#include "qrcode.h"

QRCode::QRCode(QObject *parent)
    : QObject{parent}
{}

void QRCode::requestQRCode()
{
    QString url = QString("https://api.qrserver.com/v1/create-qr-code/?size=%1x%2&data=%3").arg(m_width).arg(m_height).arg(m_data);
    m_request.setUrl(QUrl(url));
    qDebug() << url;
    QNetworkReply* reply = m_manager.get(m_request);

    QObject::connect(reply, &QNetworkReply::finished, this, [this, reply](){
        if (reply->error() == QNetworkReply::NoError)
        {
            QString img = reply->readAll().toBase64();
            qDebug() << img;
            emit messageReceived(img);
        }
        else
            {
            qDebug() << reply->error();
        }
    });
}

int QRCode::width() const
{
    return m_width;
}

void QRCode::setWidth(int newWidth)
{
    if (m_width == newWidth)
        return;
    m_width = newWidth;
    emit widthChanged();
}

int QRCode::height() const
{
    return m_height;
}

void QRCode::setHeight(int newHeight)
{
    if (m_height == newHeight)
        return;
    m_height = newHeight;
    emit heightChanged();
}

QString QRCode::data() const
{
    return m_data;
}

void QRCode::setData(const QString &newData)
{
    if (m_data == newData)
        return;
    m_data = newData;
    emit dataChanged();
}
