import QtQuick
import QtQuick.Controls
import QtCore

//TODO: password recovery endpoint
//TODO: change qr code for different login
Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("My Punch Card")

    property string projectId: "affixqvkrgfahaizxrhl"
    property string key: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmZml4cXZrcmdmYWhhaXp4cmhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMyNjE0NTIsImV4cCI6MjA0ODgzNzQ1Mn0.eyahwokwXcpwpWdYGCpskVcswqNh9ZzxHpsdiV8gxoM"
    property string jwt: ""

    property string tempId: ""
    property string tempEmail: ""
    property string tempPassword: ""

    Settings {
        id: settings
        property string username: ""
        property string password: ""
        property int checkValue: Qt.Unchecked
        property string qrCodeData: ""
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "qml/LoginPage.qml"
    }

    onClosing: close => {
            if(stackView.depth > 1){
                close.accepted = false
                stackView.pop();
            }else{
                return;
            }
        }
}
