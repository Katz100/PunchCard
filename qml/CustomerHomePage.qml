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
                    rewards: reward_count
                    punchSize: 40
                    spacing: 12
                    columns: 6

                    Text {
                        text: reward_name
                    }
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
        width: 250
        height: 250
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
                                                                 stamps_count: item.stamps_count,
                                                                 reward_count: item.reward_count,
                                                                 reward_name: item.reward
                                                             });
                               }
                           }
    }

    SupaSocket {
        id: socket
        sendHeartbeatMessage: true
        projectId: "affixqvkrgfahaizxrhl"
        key: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmZml4cXZrcmdmYWhhaXp4cmhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMyNjE0NTIsImV4cCI6MjA0ODgzNzQ1Mn0.eyahwokwXcpwpWdYGCpskVcswqNh9ZzxHpsdiV8gxoM"
        authorization: root.jwt
        Component.onCompleted: {
            socket.openConnection()
        }
        payload: {
            "event": "phx_join",
            "topic": "realtime:public:customer_stamps",
            "ref": "1",
            "payload": {
                "schema": "public",
                "table": "customer_stamps"
            }
        }

        onMessageReceived: message => {
                               if (message.event === "UPDATE") {
                                   if (message.payload.record.profile_id === Data.userDetails.user.identities[0].user_id) {
                                       server.sendFunctionCall()
                                       root.comId = message.payload.record.company_id
                                       root.custId = Data.userDetails.user.identities[0].user_id
                                       if (stackView.currentItem.objectName !== "CustomerPunchCard") {
                                           stackView.push("CustomerPunchCardPage.qml")
                                       }
                                   }
                               }
                           }
    }



}
