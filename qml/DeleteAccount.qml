import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SupaQML
import "userData.js" as Data

Page {
    ColumnLayout {
        anchors.fill: parent

        Image {
            source: "qrc:/imgs/royalty-card.png"
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 50
            sourceSize.width: 100
            sourceSize.height: 100
        }

        Label {
            text: "Are you sure you want to delete your account?"
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            text: "Delete Account"
            Layout.fillWidth: true
            onClicked: {
                server.sendFunctionCall()
                Data.userDetails = {}
                root.jwt = ""
                stackView.pop()
                stackView.pop()
                stackView.pop()
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    SupaServer {
        id: server
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        func: "delete_user"

        onMessageReceived: message => {
                               console.log(JSON.stringify(message, null, 2))
                           }


    }



}
