#ifndef SupaServer_H
#define SupaServer_H

#include <QObject>
#include <QQmlEngine>
#include <QJsonObject>
#include <QUrlQuery>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QEventLoop>
#include <QJsonArray>

class SupaServer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString projectId READ projectId WRITE setProjectId NOTIFY projectIdChanged FINAL)
    Q_PROPERTY(QString key READ key WRITE setKey NOTIFY keyChanged FINAL)
    Q_PROPERTY(QString func READ func WRITE setFunc NOTIFY funcChanged FINAL)
    Q_PROPERTY(QJsonObject parameters READ parameters WRITE setParameters NOTIFY parametersChanged FINAL)
    Q_PROPERTY(bool isUrlValid READ isUrlValid WRITE setIsUrlValid NOTIFY isUrlValidChanged FINAL)
    Q_PROPERTY(QString authorization READ authorization WRITE setAuthorization NOTIFY authorizationChanged FINAL)
    QML_ELEMENT
public:
    explicit SupaServer(QObject *parent = nullptr);

    Q_INVOKABLE QVariant sendFunctionCall();
    Q_INVOKABLE QVariant sendQuery(QString table, QString query);

    QString key() const;
    void setKey(const QString &newKey);

    QJsonObject parameters() const;
    void setParameters(const QJsonObject &newParameters);

    bool isUrlValid() const;
    void setIsUrlValid(bool newIsUrlValid);


    QString func() const;
    void setFunc(const QString &newFunc);

    QString projectId() const;
    void setProjectId(const QString &newProjectId);

    QString authorization() const;
    void setAuthorization(const QString &newAuthorization);

signals:

    void messageReceived(QJsonObject message);
    void apiCallFailed(QString message);

    void keyChanged();

    void parametersChanged();

    void isUrlValidChanged();

    void funcChanged();

    void projectIdChanged();

    void authorizationChanged();

private:
    QUrl m_url;
    QString m_key;
    QJsonObject m_parameters;
    bool m_isUrlValid;
    QString m_func;
    QNetworkAccessManager m_manager;
    QNetworkRequest m_request;
    QString m_projectId;

    QString m_authorization;
};

#endif // SupaServer_H
