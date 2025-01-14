import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SupaQML
import "userData.js" as Data

Page {

    property bool showPassword: false

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
                source: "qrc:/imgs/password-icon.png"
            }

            TextField {
                id: passField
                Layout.fillWidth: true
                placeholderText: qsTr("Password")
                inputMethodHints: Qt.ImhNoPredictiveText
                echoMode: showPassword ? TextInput.Normal : TextInput.Password
                Image {
                    source: showPassword ? "qrc:/imgs/show-pass-icon.png" : "qrc:/imgs/hide-pass-icon.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: showPassword = !showPassword
                    }

                    anchors {right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 5}
                }
            }
        }

        Button {
            text: "Change Password"
            Layout.fillWidth: true
            onClicked: {
                auth.body = {
                    "data": {
                        "password": passField.text
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
