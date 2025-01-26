import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "userData.js" as Data
import SupaQML

Page {
    objectName: "CompanyHomePage"

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

    Button {
        text: "Scan QR Code"
        anchors.centerIn: parent
        onClicked: {
            stackView.push("ScanQRCodePage.qml")
        }
    }

    SupaServer {
        projectId: root.projectId
        key: root.key
        func: "get_user_company"
        parameters: {
            "user_id": Data.userDetails.user.identities[0].user_id
        }

        Component.onCompleted: {
            sendFunctionCall()
        }

        onMessageReceived: message => {
                               root.comId = message[0].com_id
                           }
    }
}
