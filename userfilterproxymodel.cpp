#include "userfilterproxymodel.h"


UserFilterProxyModel::UserFilterProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)

{
    setFilterCaseSensitivity(Qt::CaseInsensitive);
}

QString UserFilterProxyModel::filterString() const
{
    return m_filterString;
}

void UserFilterProxyModel::setFilterString(const QString &newFilterString)
{
    if (m_filterString == newFilterString)
        return;
    m_filterString = newFilterString;
    setFilterFixedString(m_filterString);
    emit filterStringChanged();
}
