#include "SupaServer.h"

SupaServer::SupaServer(QObject *parent)
    : QObject{parent}
{}

QString SupaServer::key() const
{
    return m_key;
}

void SupaServer::setKey(const QString &newKey)
{
    if (m_key == newKey)
        return;
    m_key = newKey;
    emit keyChanged();
}

QJsonObject SupaServer::parameters() const
{
    return m_parameters;
}

void SupaServer::setParameters(const QJsonObject &newParameters)
{
    if (m_parameters == newParameters)
        return;
    m_parameters = newParameters;
    emit parametersChanged();
}

bool SupaServer::isUrlValid() const
{
    return m_isUrlValid;
}

void SupaServer::setIsUrlValid(bool newIsUrlValid)
{
    if (m_isUrlValid == newIsUrlValid)
        return;
    m_isUrlValid = newIsUrlValid;
    emit isUrlValidChanged();
}

void SupaServer::sendFunctionCall()
{
    QString new_url = QString("https://%1.supabase.co/rest/v1/rpc").arg(m_projectId) + "/" + m_func;
    m_request.setRawHeader("apikey", m_key.toUtf8());
    m_request.setRawHeader("Authorization", QString("Bearer %1").arg(m_authorization).toUtf8());
    m_request.setUrl(QUrl(new_url));
    QJsonDocument doc(m_parameters);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QNetworkReply* reply = m_manager.post(m_request, data);

    QObject::connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        QByteArray response = reply->readAll();
        QString responseString = QString::fromUtf8(response).trimmed();

        if (reply->error() == QNetworkReply::NoError) {
            if (responseString == "true") {
                emit messageReceived(QVariant(true));
            } else if (responseString == "false") {
                emit messageReceived(QVariant(false));
            } else {
                QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
                if (jsonDoc.isNull()) {
                    qDebug() << "Invalid JSON response:" << responseString;
                    emit messageReceived(QVariant());
                } else {
                    emit messageReceived(jsonDoc.toVariant());
                }
            }
        } else {
            QJsonObject errorObject;
            if (reply->error() == QNetworkReply::HostNotFoundError || reply->error() == QNetworkReply::UnknownNetworkError) {
                errorObject["supabase_status"] = 404;
            } else {
                qDebug() << "Error:" << reply->error();
                QJsonDocument errorDoc = QJsonDocument::fromJson(response);
                errorObject = errorDoc.object();
                errorObject["supabase_status"] = 400;
            }

            emit messageReceived(QJsonDocument(errorObject).toVariant()); // Emit error as JSON
        }

        reply->deleteLater();
    });


}

QVariant SupaServer::sendQuery(QString table, QString query)
{
    QString new_url = QString("https://%1.supabase.co/rest/v1/%2?%3").arg(m_projectId, table, query);
    m_request.setRawHeader("apikey", m_key.toUtf8());
    m_request.setRawHeader("Authorization", QString("Bearer %1").arg(m_authorization).toUtf8());
    m_request.setUrl(QUrl(new_url));

    QNetworkReply* reply = m_manager.get(m_request);

    QEventLoop eventLoop;
    QObject::connect(reply, &QNetworkReply::finished, &eventLoop, &QEventLoop::quit);
    eventLoop.exec();

    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray response = reply->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
        reply->deleteLater();
        return jsonDoc.toVariant();
    }
    else
    {
        reply->deleteLater();
        return QVariant();
    }

    return QVariant();
}


QString SupaServer::func() const
{
    return m_func;
}

void SupaServer::setFunc(const QString &newFunc)
{
    if (m_func == newFunc)
        return;
    m_func = newFunc;
    emit funcChanged();
}

QString SupaServer::projectId() const
{
    return m_projectId;
}

void SupaServer::setProjectId(const QString &newProjectId)
{
    if (m_projectId == newProjectId)
        return;
    m_projectId = newProjectId;
    emit projectIdChanged();
}

QString SupaServer::authorization() const
{
    return m_authorization;
}

void SupaServer::setAuthorization(const QString &newAuthorization)
{
    if (m_authorization == newAuthorization)
        return;
    m_authorization = newAuthorization;
    emit authorizationChanged();
}
