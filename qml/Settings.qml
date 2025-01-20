import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "userData.js" as Data

Page {
    ColumnLayout {
        anchors.fill: parent

        Image {
            id: userImg
            source: "qrc:/imgs/user-icon.png"
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            id: name
            text: Data.userDetails.user.user_metadata.display_name
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            id: email
            text: Data.userDetails.user.email
            Layout.alignment: Qt.AlignHCenter
        }
        Rectangle {
            id: updateNameRect
            color: "lightgray"
            height: 40
            radius: 8

            Layout.preferredWidth: parent.width * 0.9
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Image {
                    source: "qrc:/imgs/user-icon.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "Update Name"
                    Layout.alignment: Qt.AlignLeft
                    Layout.fillWidth: true
                }

                Image {
                    source: "qrc:/imgs/right-arrow-icon.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.push("UpdateName.qml")
                    }
                }
            }
        }

        Rectangle {
            id: updateEmailRect
            color: "lightgray"
            height: 40
            radius: 8

            Layout.preferredWidth: parent.width * 0.9
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Image {
                    source: "qrc:/imgs/email-icon.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "Update Email"
                    Layout.alignment: Qt.AlignLeft
                    Layout.fillWidth: true
                }

                Image {
                    source: "qrc:/imgs/right-arrow-icon.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.push("UpdateEmail.qml")
                    }
                }
            }
        }

        Rectangle {
            id: changePasswordRect
            color: "lightgray"
            height: 40
            radius: 8

            Layout.preferredWidth: parent.width * 0.9
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Image {
                    source: "qrc:/imgs/password-icon.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "Change Password"
                    Layout.alignment: Qt.AlignLeft
                    Layout.fillWidth: true
                }

                Image {
                    source: "qrc:/imgs/right-arrow-icon.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.push("UpdatePassword.qml")
                    }
                }
            }
        }

        Rectangle {
            id: signOutRect
            color: "lightgray"
            height: 40
            radius: 8

            Layout.preferredWidth: parent.width * 0.9
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Image {
                    source: "qrc:/imgs/sign-out-icon.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "Sign Out"
                    Layout.alignment: Qt.AlignLeft
                    Layout.fillWidth: true
                }

                Image {
                    source: "qrc:/imgs/right-arrow-icon.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.push("SignOut.qml")
                    }
                }
            }
        }

        Rectangle {
            id: deleteAccountRect
            color: "lightgray"
            height: 40
            radius: 8

            Layout.preferredWidth: parent.width * 0.9
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Image {
                    source: "qrc:/imgs/trash-icon.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "Delete Account"
                    Layout.alignment: Qt.AlignLeft
                    Layout.fillWidth: true
                }

                Image {
                    source: "qrc:/imgs/right-arrow-icon.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.push("DeleteAccount.qml")
                    }
                }
            }
        }
    }
}
