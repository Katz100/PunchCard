#ifndef SUPASOCKET_H
#define SUPASOCKET_H

#include <QObject>
#include <QQmlEngine>
#include <QWebSocket>
#include <QJsonObject>
#include <QJsonDocument>
#include <QTimer>

class SupaSocket : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString projectId READ projectId WRITE setProjectId NOTIFY projectIdChanged FINAL)
    Q_PROPERTY(QString key READ key WRITE setKey NOTIFY keyChanged FINAL)
    Q_PROPERTY(QString authorization READ authorization WRITE setAuthorization NOTIFY authorizationChanged FINAL)
    Q_PROPERTY(QJsonObject payload READ payload WRITE setPayload NOTIFY payloadChanged FINAL)
    Q_PROPERTY(bool sendHeartbeatMessage READ sendHeartbeatMessage WRITE setSendHeartbeatMessage NOTIFY sendHeartbeatMessageChanged FINAL)
    QML_ELEMENT
public:
    explicit SupaSocket(QObject *parent = nullptr);
    ~SupaSocket();

    Q_INVOKABLE void openConnection();
    Q_INVOKABLE void sendTextMessage(QJsonObject payload);
    Q_INVOKABLE void closeConnection();


    QString projectId() const;
    void setProjectId(const QString &newProjectId);

    QString key() const;
    void setKey(const QString &newKey);

    QJsonObject payload() const;
    void setPayload(const QJsonObject &newPayload);

    bool sendHeartbeatMessage() const;
    void setSendHeartbeatMessage(bool newSendHeartbeatMessage);

    QString authorization() const;
    void setAuthorization(const QString &newAuthorization);

signals:
    void messageReceived(QVariant message);
    void projectIdChanged();
    void keyChanged();

    void payloadChanged();

    void sendHeartbeatMessageChanged();

    void authorizationChanged();

private:
    QString m_projectId;
    QString m_key;
    QJsonObject m_payload;
    QWebSocket m_webSocket;
    QTimer* timer;
    bool m_sendHeartbeatMessage;
    QString m_authorization;
};

#endif // SUPASOCKET_H
