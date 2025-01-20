import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "userData.js" as Data
import SupaQML

Page {
    title: qsTr("Sign Up Page")
    property bool txtVisible: false
    property string errorTxt: ""

    property bool showPassword: false
    property bool invalidInformation: false
    property bool validEmail: false
    property bool validPassword: false
    property bool validName: false

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
                source: !validName? "qrc:/imgs/user-icon.png" : "qrc:/imgs/user-green-icon.png"
            }

            TextField {
                id: nameField
                Layout.fillWidth: true
                placeholderText: qsTr("Name")
                inputMethodHints: Qt.ImhNoPredictiveText
                onTextChanged: {
                    if (nameField.text !== "") {
                        validName = true
                    } else {
                        validName = false
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Image {
                source: !validEmail ? "qrc:/imgs/email-icon.png" : "qrc:/imgs/email-green-icon.png"
            }

            TextField {
                id: emailField
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

        RowLayout {
            Layout.fillWidth: true
            Image {
                source: "qrc:/imgs/store-icon.png"
            }
            TextField {
                id: storeField
                Layout.fillWidth: true
                placeholderText: qsTr("Company Name")
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Image {
                source: "qrc:/imgs/phone-icon.png"
            }
            TextField {
                id: phoneField
                Layout.fillWidth: true
                placeholderText: qsTr("Phone Number")
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Image {
                source: "qrc:/imgs/address-icon.png"
            }
            TextField {
                id: addressField
                Layout.fillWidth: true
                placeholderText: qsTr("Address")
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Image {
                source: "qrc:/imgs/website-icon.png"
            }
            TextField {
                id: websiteField
                Layout.fillWidth: true
                placeholderText: qsTr("Website")
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Image {
                source: "qrc:/imgs/gift-icon.png"
            }
            TextField {
                id: rewardField
                Layout.fillWidth: true
                placeholderText: qsTr("Reward Name (e.g. free pizza)")
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Image {
                source: "qrc:/imgs/stamp-icon.png"
            }
            TextField {
                id: stampsField
                Layout.fillWidth: true
                placeholderText: qsTr("Stamps Required")
            }
        }



        Button {
            id: signUpButton
            text: qsTr("Sign Up")
            Layout.fillWidth: true
            enabled: validEmail && validPassword && validName
            onClicked: {
                auth.body = {
                    "email": emailField.text,
                    "password": passwordField.text,
                    "data": {
                        "role": "customer",
                        "display_name": nameField.text
                    }
                }

                auth.sendAuth()
            }
        }

        Label {
            text: "Already have an account?"
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Sign in"
            color: "blue"
            Layout.alignment: Qt.AlignHCenter
            MouseArea {
                anchors.fill: parent
                onClicked: stackView.pop()
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
        endpoint: SupaAuth.SIGNUP
        onMessageReceived: message => {
                               if(message.supabase_status === 404) {
                                   dialog.open()
                               } else if (message.supabase_status === 200) {
                                   if (message.identities.length === 0) {
                                       invalidInformation = true
                                       errorTxt = "Email already in use."
                                   } else {
                                       root.tempId = message.id
                                       root.tempEmail = emailField.text
                                       root.tempPassword = passwordField.text

                                       settings.store = storeField.text
                                       settings.phone = phoneField.text
                                       settings.address = addressField.text
                                       settings.website = websiteField.text
                                       settings.reward = rewardField.text
                                       settings.stamps = parseInt(stampsField.text)

                                       stackView.push("ConfirmSignUpPage.qml")
                                   }
                               } else {
                                   invalidInformation = true
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
