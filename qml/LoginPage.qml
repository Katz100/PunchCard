import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
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
            anchors {left: parent.left; right: parent.right; top: parent.top;
                    leftMargin: 20; rightMargin: 20}


            Image {
                source: ""
                width: 100
                height: 100
                Layout.alignment: Qt.AlignHCenter
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

            TextField {
                id: emailField
                Layout.fillWidth: true
                placeholderText: qsTr("Email")
                inputMethodHints: Qt.ImhNoPredictiveText
            }

            TextField {
                id: passwordField
                Layout.fillWidth: true
                placeholderText: qsTr("Password")
                inputMethodHints: Qt.ImhNoPredictiveText
            }


            Button {
                id: signInButton
                text: qsTr("Sign In")

                onClicked: {
                    auth.body = {
                        "email": emailField.text,
                        "password": passwordField.text
                    }

                    Data.userDetails = auth.sendAuth()
                    if (Data.userDetails.supabase_status === 200) {
                        root.jwt = Data.userDetails.access_token
                        stackView.push("CustomerHomePage.qml")
                    } else {
                        invalidInformation = true
                    }

                }
            }

        }
    }

    SupaAuth {
        id: auth
        projectId: root.projectId
        key: root.key
        method: SupaAuth.POST
        endpoint: SupaAuth.SIGNIN
    }

}
