import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "userData.js" as Data
import MyPunchCard
Page {
    title: qsTr("Customer Home Page")

    SwipeView {
        id: swipeView
    }

    Label {
        text: "Hello " + Data.userDetails.user.email
    }

    Image {
        id: img
        anchors.centerIn: parent
        source: settings.qrCodeData
    }

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
        //Generate QR code for first time login.
        if (settings.qrCodeData === "") {
            qrCode.requestQRCode()
        }
    }

    footer: Rectangle {
        color: "gray"
        height: 75
        RowLayout {
            anchors.fill: parent
            Image {
                id: qrImg
                source: "qrc:/imgs/qr-icon.png"
                Layout.alignment: Qt.AlignHCenter
            }

            Image {
                id: tagImg
                source: "qrc:/imgs/tag-icon.png"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

}
