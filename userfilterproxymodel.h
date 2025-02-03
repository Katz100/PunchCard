#ifndef USERFILTERPROXYMODEL_H
#define USERFILTERPROXYMODEL_H

#include <QObject>
#include <QSortFilterProxyModel>

class UserFilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QString filterString READ filterString WRITE setFilterString NOTIFY filterStringChanged FINAL)
public:
    explicit UserFilterProxyModel(QObject* parent = nullptr);


    QString filterString() const;
    void setFilterString(const QString &newFilterString);

public slots:

signals:

    void filterStringChanged();

protected:

private:

    QString m_filterString;
};

#endif // USERFILTERPROXYMODEL_H
