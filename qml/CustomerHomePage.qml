import QtQuick
import QtQuick.Controls
import "userData.js" as Data
import MyPunchCard
Page {

    property string imgSource: ""
    Label {
        text: "Hello " + Data.userDetails.user.email
    }

    Image {
        id: img
        anchors.centerIn: parent
        source: imgSource
    }

    QRCode {
        id: qrCode
        width: 150
        height: 150
        data: JSON.stringify(Data.userDetails.user.identities[0].user_id)

        onMessageReceived: message => {
                               imgSource = "data:image/png;base64,"+message
                           }
    }
    Component.onCompleted: {
        qrCode.requestQRCode()
    }
}
