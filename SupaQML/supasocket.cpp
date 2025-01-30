#include "supasocket.h"

SupaSocket::SupaSocket(QObject *parent)
    : QObject{parent}
{

    timer = new QTimer(this);
    QObject::connect(timer, &QTimer::timeout, this, [this](){
        if (m_sendHeartbeatMessage && m_webSocket.state() == QAbstractSocket::ConnectedState)
        {
            QJsonObject payload;
            payload["event"] = "heartbeat";
            payload["topic"] = "phoenix";
            QJsonObject empty;
            payload["payload"] = empty;
            payload["ref"] = QString::number(QDateTime::currentMSecsSinceEpoch());
            sendTextMessage(payload);
        }

    });
    timer->start(30000);
    QObject::connect(&m_webSocket, &QWebSocket::connected, this, [this](){
        sendTextMessage(m_payload);
        if (m_authorization != "")
        {
            QJsonObject access;
            access["event"] = "access_token";
            access["topic"] = m_payload["topic"];
            QJsonObject payloadItem;
            payloadItem["access_token"] = m_authorization;
            access["payload"] = payloadItem;
            access["ref"] = QString::number(QDateTime::currentMSecsSinceEpoch());
            sendTextMessage(access);
        }
    });

    QObject::connect(&m_webSocket, &QWebSocket::disconnected, this, [](){
        qDebug() << "disconnected";
    });

    QObject::connect(&m_webSocket, &QWebSocket::errorOccurred, this, [](QAbstractSocket::SocketError error){
        qDebug() << error;
    });

    QObject::connect(&m_webSocket, &QWebSocket::textMessageReceived, this, [this](const QString& message){
        QJsonDocument jsonDoc = QJsonDocument::fromJson(message.toUtf8());
        if (!jsonDoc.isNull() && jsonDoc.isObject()) {
            emit messageReceived(jsonDoc.toVariant());
        } else {
            qWarning() << "Invalid JSON message received:" << message;
        }
    });

    QObject::connect(&m_webSocket, &QWebSocket::stateChanged, this, [](QAbstractSocket::SocketState state){
        qDebug() << state;
    });

    QObject::connect(&m_webSocket, &QWebSocket::binaryMessageReceived, this, [](const QByteArray message){
        qDebug() << message;
    });
}
SupaSocket::~SupaSocket()
{
    qDebug() << "destructor called....";
    m_webSocket.close();
}

void SupaSocket::openConnection()
{
    QUrl url = QString("wss://%1.supabase.co/realtime/v1/websocket?apikey=%2&log_level=info&vsn=1.0.0").arg(m_projectId, m_key);
    m_webSocket.open(url);
}

void SupaSocket::sendTextMessage(QJsonObject payload)
{
    QJsonDocument doc(payload);
    QString strJson(doc.toJson(QJsonDocument::Compact));
    qDebug() << doc;
    m_webSocket.sendTextMessage(strJson);
}

void SupaSocket::closeConnection()
{
    m_webSocket.close();
}

QString SupaSocket::projectId() const
{
    return m_projectId;
}

void SupaSocket::setProjectId(const QString &newProjectId)
{
    if (m_projectId == newProjectId)
        return;
    m_projectId = newProjectId;
    emit projectIdChanged();
}

QString SupaSocket::key() const
{
    return m_key;
}

void SupaSocket::setKey(const QString &newKey)
{
    if (m_key == newKey)
        return;
    m_key = newKey;
    emit keyChanged();
}

QJsonObject SupaSocket::payload() const
{
    return m_payload;
}

void SupaSocket::setPayload(const QJsonObject &newPayload)
{
    if (m_payload == newPayload)
        return;
    m_payload = newPayload;
    emit payloadChanged();
}

bool SupaSocket::sendHeartbeatMessage() const
{
    return m_sendHeartbeatMessage;
}

void SupaSocket::setSendHeartbeatMessage(bool newSendHeartbeatMessage)
{
    if (m_sendHeartbeatMessage == newSendHeartbeatMessage)
        return;
    m_sendHeartbeatMessage = newSendHeartbeatMessage;
    emit sendHeartbeatMessageChanged();
}

QString SupaSocket::authorization() const
{
    return m_authorization;
}

void SupaSocket::setAuthorization(const QString &newAuthorization)
{
    if (m_authorization == newAuthorization)
        return;
    m_authorization = newAuthorization;
    emit authorizationChanged();
}
