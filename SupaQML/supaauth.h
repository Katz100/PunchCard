#ifndef SUPAAUTH_H
#define SUPAAUTH_H

#include <QObject>
#include <QQmlEngine>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QEventLoop>

class SupaAuth : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString projectId READ projectId WRITE setProjectId NOTIFY projectIdChanged FINAL)
    Q_PROPERTY(QString key READ key WRITE setKey NOTIFY keyChanged FINAL)
    Q_PROPERTY(QString authorization READ authorization WRITE setAuthorization NOTIFY authorizationChanged FINAL)
    Q_PROPERTY(METHOD method READ method WRITE setMethod NOTIFY methodChanged FINAL)
    Q_PROPERTY(QJsonObject body READ body WRITE setBody NOTIFY bodyChanged FINAL)
    Q_PROPERTY(Endpoint endpoint READ endpoint WRITE setEndpoint NOTIFY endpointChanged FINAL)
    QML_ELEMENT
public:
    explicit SupaAuth(QObject *parent = nullptr);

    Q_INVOKABLE QVariant sendAuth();

    enum METHOD
    {
        GET,
        POST,
        PUT
    };
    Q_ENUM(METHOD)

    enum Endpoint
    {
        SIGNUP,
        SIGNIN,
        REFRESH,
        RECOVER,
        LOGOUT,
        USER
        //to be added
    };
    Q_ENUM(Endpoint)

    QString projectId() const;
    void setProjectId(const QString &newProjectId);

    QString key() const;
    void setKey(const QString &newKey);

    QString authorization() const;
    void setAuthorization(const QString &newAuthorization);

    QJsonObject body() const;
    void setBody(const QJsonObject &newBody);

    SupaAuth::Endpoint endpoint() const;
    void setEndpoint(Endpoint newEndpoint);

    SupaAuth::METHOD method() const;
    void setMethod(METHOD newMethod);

signals:
    void projectIdChanged();
    void keyChanged();

    void authorizationChanged();

    void bodyChanged();

    void endpointChanged();

    void methodChanged();

private:
    QString m_projectId;
    QString m_key;
    QString m_authorization;
    QJsonObject m_body;
    Endpoint m_endpoint;
    METHOD m_method;

    QNetworkAccessManager m_manager;
    QNetworkRequest m_request;
};

#endif // SUPAAUTH_H
