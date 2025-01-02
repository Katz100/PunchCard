import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtNetwork
import SupaQML
import "userData.js" as Data

Page {
    title: qsTr("Sign In Page")
    property bool txtVisible: false
    property bool showPassword: false
    property bool invalidInformation: false

    Rectangle {
        anchors.fill: parent
        ColumnLayout {
            id: mainLayout
            spacing: 20
            anchors {left: parent.left; right: parent.right; top: parent.top;
                leftMargin: 20; rightMargin: 20}

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
                id: invalidTxt
                text: qsTr("Invalid Credentials")
                color: "red"
                visible: invalidInformation
                Layout.alignment: Qt.AlignCenter
            }

            RowLayout {
                Layout.fillWidth: true
                Image {
                    source: "qrc:/imgs/email-icon.png"
                }

                TextField {
                    id: emailField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Email")
                    inputMethodHints: Qt.ImhNoPredictiveText
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Image {
                    source: "qrc:/imgs/password-icon.png"
                }
                TextField {
                    id: passwordField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Password")
                    inputMethodHints: Qt.ImhNoPredictiveText
                    echoMode: showPassword ? TextInput.Normal : TextInput.Password
                    rightPadding: 40
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
                id: signInButton
                text: qsTr("Sign In")
                Layout.fillWidth: true
                onClicked: {
                    auth.body = {
                        "email": emailField.text,
                        "password": passwordField.text
                    }
                    auth.sendAuth()
                }
            }

            Label {
                text: "Don't have an account?"
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: "Sign up"
                color: "blue"
                Layout.alignment: Qt.AlignHCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: stackView.push("SignUpPage.qml")
                }
            }

            BusyIndicator {
                id: busyIndicator
                running: auth.requestInProgress
                Layout.alignment: Qt.AlignHCenter
            }

        }
    }

    SupaAuth {
        id: auth
        projectId: root.projectId
        key: root.key
        method: SupaAuth.POST
        endpoint: SupaAuth.SIGNIN
        onMessageReceived: message => {
                               if (message.supabase_status === 404) {
                                   dialog.open()
                               } else if (message.supabase_status === 200) {
                                   Data.userDetails = message
                                   root.jwt = Data.userDetails.access_token
                                   stackView.push("CustomerHomePage.qml")
                               } else {
                                   invalidInformation = true
                               }
                           }
    }

    Dialog {
        id: dialog
        title: "Connection Error"
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
    }
}



