import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
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

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0

        Rectangle {
            color: "white"
            border.color: "lightblue"
            border.width: 2

            Button {
                text: "Scan QR Code"
                anchors.centerIn: parent // Center the button inside the Rectangle
                onClicked: {
                    if (camera.status !== Qt.PermissionStatus.Granted) {
                        camera.request()
                        console.log("Requesting camera permissions")
                    } else if (camera.status === Qt.PermissionStatus.Granted) {
                        stackView.push("ScanQRCodePage.qml")
                    }
                }
            }
        }

    }

    footer: Rectangle {
        color: "lightgray"
        height: 75
        RowLayout {
            anchors.fill: parent
            Image {
                id: qrImg
                source: "qrc:/imgs/scan-icon.png"
                Layout.alignment: Qt.AlignHCenter
                opacity: swipeView.currentIndex === 0 ? 1.0 : 0.5
            }

            Image {
                id: tagImg
                source: "qrc:/imgs/users-icon.png"
                Layout.alignment: Qt.AlignHCenter
                opacity: swipeView.currentIndex === 1 ? 1.0 : 0.5
            }
        }
    }

    CameraPermission {
        id: camera
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
