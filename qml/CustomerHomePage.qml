import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "userData.js" as Data
import MyPunchCard
import SupaQML
Page {
    title: qsTr("Customer Home Page")
    objectName: "CustomerHomePage"
    header: Rectangle {
        color: "lightgray"
        height: 55
        RowLayout {
            anchors.fill: parent
            Image {
                id: userImg
                source: "qrc:/imgs/user-icon.png"
                Layout.alignment: Qt.AlignRight
                Layout.topMargin: 20
                Layout.rightMargin: 40
                MouseArea {
                    anchors.fill: parent
                    onClicked: stackView.push("Settings.qml")
                }
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0

        RowLayout {
            Image {
                id: img
                source: settings.qrCodeData
                Layout.alignment: Qt.AlignCenter
            }
        }

        Item {
            Label {
                text: "You don't have any loyalty cards yet."
                visible: punchCardListModel.count === 0
                anchors.centerIn: parent
            }

            ListView {
                id: lv
                anchors.fill: parent
                model: punchCardListModel
                spacing: 20
                delegate: RoyaltyCard {
                    anchors.horizontalCenter: parent.horizontalCenter
                    totalPunches: stamps_required
                    companyName: company_name
                    completedPunches: stamps_count
                    punchSize: 40
                    spacing: 12
                    columns: 6
                }
            }
        }
    }

    /*
    Label {
        text: "Hello " + Data.userDetails.user.email
    }*/

    QRCode {
        id: qrCode
        width: 150
        height: 150
        data: JSON.stringify(Data.userDetails.user.identities[0].user_id)

        onMessageReceived: message => {
                               settings.qrCodeData = "data:image/png;base64,"+message
                           }
    }
    Component.onCompleted: {
            qrCode.requestQRCode()
    }

    footer: Rectangle {
        color: "lightgray"
        height: 75
        RowLayout {
            anchors.fill: parent
            Image {
                id: qrImg
                source: "qrc:/imgs/qr-icon.png"
                Layout.alignment: Qt.AlignHCenter
                opacity: swipeView.currentIndex === 0 ? 1.0 : 0.5
            }

            Image {
                id: tagImg
                source: "qrc:/imgs/tag-icon.png"
                Layout.alignment: Qt.AlignHCenter
                opacity: swipeView.currentIndex === 1 ? 1.0 : 0.5
            }
        }
    }

    SupaServer {
        id: server
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        func: "get_user_punchcard_info"
        parameters: {
            "user_id": Data.userDetails.user.identities[0].user_id
        }

        Component.onCompleted: {
            sendFunctionCall()
        }

        onMessageReceived: message => {
                               punchCardListModel.clear()
                               for (let item of message) {
                                   punchCardListModel.append({
                                                                 company_name: item.company_name,
                                                                 stamps_required: item.stamps_required,
                                                                 stamps_count: item.stamps_count
                                                             });
                               }
                           }
    }

}
