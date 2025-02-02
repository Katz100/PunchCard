import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtNetwork
import SupaQML
import "userData.js" as Data

Page {
    title: qsTr("Sign In Page")
    property bool txtVisible: false
    property string errorTxt: ""
    property bool showPassword: false
    property bool invalidInformation: false
    property bool validEmail: false
    property bool validPassword: false
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
            text: errorTxt
            color: "red"
            visible: invalidInformation
            Layout.alignment: Qt.AlignCenter
        }

        RowLayout {
            Layout.fillWidth: true
            Image {
                source: !validEmail ? "qrc:/imgs/email-icon.png" : "qrc:/imgs/email-green-icon.png"
            }

            TextField {
                id: emailField
                text: "rkatz108@gmail.com"
                Layout.fillWidth: true
                placeholderText: qsTr("Email")
                inputMethodHints: Qt.ImhNoPredictiveText
                onTextChanged: {
                    const regex = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
                    if(regex.test(emailField.text)) {
                        validEmail = true
                    } else {
                        validEmail = false
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Image {
                source: !validPassword ? "qrc:/imgs/password-icon.png" : "qrc:/imgs/password-green-icon.png"
            }
            TextField {
                id: passwordField
                text: "mypassword"
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

                onTextChanged: {
                    if (passwordField.length >= 6) {
                        validPassword = true
                    } else {
                        validPassword = false
                    }
                }
            }
        }

        Label {
            text: "Forgot Password?"
            color: "blue"
            Layout.alignment: Qt.AlignRight
        }

        Button {
            id: signInButton
            text: qsTr("Sign In")
            Layout.fillWidth: true
            //enabled: validEmail && validPassword
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
                                   invalidInformation = false
                                   Data.userDetails = message
                                   root.jwt = Data.userDetails.access_token
                                   if (Data.userDetails.user.user_metadata.role === "customer") {
                                       stackView.push("CustomerHomePage.qml")
                                   } else {
                                       stackView.push("CompanyHomePage.qml")
                                   }
                               } else {
                                   invalidInformation = true
                                   console.log(JSON.stringify(message))
                                   errorTxt = JSON.stringify(message.msg)
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



