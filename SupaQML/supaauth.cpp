
#include "supaauth.h"

SupaAuth::SupaAuth(QObject *parent)
    : QObject{parent}
{}

void SupaAuth::sendAuth()
{
    setRequestInProgress(true);
    QString new_url = QString("https://%1.supabase.co/auth/v1").arg(m_projectId);

    switch (m_endpoint)
    {
    case SIGNUP:
        new_url.append("/signup");
        break;
    case SIGNIN:
        new_url.append("/token?grant_type=password");
        break;
    case REFRESH:
        new_url.append("/token?grant_type=refresh");
        break;
    case RECOVER:
        new_url.append("/recover");
        break;
    case USER:
        new_url.append("/user");
        break;
    case LOGOUT:
        new_url.append("/logout");
        break;
    default:
        return;
        break;
    }

    m_request.setRawHeader("apikey", m_key.toUtf8());
    m_request.setRawHeader("Authorization", QString("Bearer %1").arg(m_authorization).toUtf8());
    m_request.setUrl(QUrl(new_url));
    QJsonDocument doc(m_body);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QNetworkReply* reply;

    m_requestInProgress = true;
    switch (m_method) {
    case POST:
        reply = m_manager.post(m_request, data);
        break;
    case GET:
        reply = m_manager.get(m_request);
        break;
    case PUT:
        reply = m_manager.put(m_request, data);
    default:
        break;
    }

    QObject::connect(reply, &QNetworkReply::finished, this, [this, reply](){
        setRequestInProgress(false);
        //Credentials match
        if (reply->error() == QNetworkReply::NoError)
        {
            QByteArray response = reply->readAll();
            QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
            QJsonObject successObject = jsonDoc.object();
            successObject["supabase_status"] = 200;
            emit messageReceived(QJsonDocument(successObject).toVariant());
        }
        else
        {
            //No connection to supabase
            if (reply->error() == QNetworkReply::HostNotFoundError || reply->error() == QNetworkReply::UnknownNetworkError)
            {
                QJsonObject errorObject;
                errorObject["supabase_status"] = 404;
                emit messageReceived(QJsonDocument(errorObject).toVariant());
            }
            else
            {
                //Invalid operation
                qDebug() << reply->error();
                QByteArray response = reply->readAll();
                QJsonDocument jsonDoc = QJsonDocument::fromJson(response);

                QJsonObject errorObject = jsonDoc.object();
                errorObject["supabase_status"] = 400;
                emit messageReceived(QJsonDocument(errorObject).toVariant());
            }
        }
        reply->deleteLater();
    });
}

QString SupaAuth::projectId() const
{
    return m_projectId;
}

void SupaAuth::setProjectId(const QString &newProjectId)
{
    if (m_projectId == newProjectId)
        return;
    m_projectId = newProjectId;
    emit projectIdChanged();
}

QString SupaAuth::key() const
{
    return m_key;
}

void SupaAuth::setKey(const QString &newKey)
{
    if (m_key == newKey)
        return;
    m_key = newKey;
    emit keyChanged();
}

QString SupaAuth::authorization() const
{
    return m_authorization;
}

void SupaAuth::setAuthorization(const QString &newAuthorization)
{
    if (m_authorization == newAuthorization)
        return;
    m_authorization = newAuthorization;
    emit authorizationChanged();
}

QJsonObject SupaAuth::body() const
{
    return m_body;
}

void SupaAuth::setBody(const QJsonObject &newBody)
{
    if (m_body == newBody)
        return;
    m_body = newBody;
    emit bodyChanged();
}

SupaAuth::Endpoint SupaAuth::endpoint() const
{
    return m_endpoint;
}

void SupaAuth::setEndpoint(Endpoint newEndpoint)
{
    if (m_endpoint == newEndpoint)
        return;
    m_endpoint = newEndpoint;
    emit endpointChanged();
}

SupaAuth::METHOD SupaAuth::method() const
{
    return m_method;
}

void SupaAuth::setMethod(METHOD newMethod)
{
    if (m_method == newMethod)
        return;
    m_method = newMethod;
    emit methodChanged();
}

bool SupaAuth::requestInProgress() const
{
    return m_requestInProgress;
}

void SupaAuth::setRequestInProgress(bool newProgress)
{
    if (m_requestInProgress != newProgress) {
        m_requestInProgress = newProgress;
        emit requestInProgressChanged();
    }
}
