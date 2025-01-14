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

        RowLayout {
            Image {
                id: userIconImg
                source: "qrc:/imgs/email-icon.png"
            }

            TextField {
                id: emailField
                text: Data.userDetails.user.email
                Layout.fillWidth: true
            }
        }

        Button {
            text: "Update Email"
            Layout.fillWidth: true
            onClicked: {
                auth.body = {
                    "data": {
                        "email": emailField.text
                    }
                }
                auth.sendAuth()
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    SupaAuth {
        id: auth
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        method: SupaAuth.PUT
        endpoint: SupaAuth.USER

        onMessageReceived: message => {
                               refreshAuth.body = {
                                   "refresh_token": Data.userDetails.refresh_token
                               }
                               refreshAuth.sendAuth()
                           }
    }

    SupaAuth {
        id: refreshAuth
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        method: SupaAuth.POST
        endpoint: SupaAuth.REFRESH

        onMessageReceived: message => {
                               Data.userDetails = {}
                               Data.userDetails = message
                               root.jwt = Data.userDetails.access_token
                               stackView.pop()
                               stackView.pop()
                           }
    }
}
