import QtQuick
import QtQuick.Controls
import QtCore
import SupaQML
import com.scythestudio.scodes 1.0
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
        property string qrCodeData: ""

        property string store: ""
        property string phone: ""
        property string address: ""
        property string website: ""
        property string reward: ""
        property int stamps: 0
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "qml/LoginPage.qml"
    }

    ListModel {
        id: punchCardListModel
    }


    onClosing: close => {
                   if(stackView.depth > 1 && (stackView.currentItem.objectName !== "CustomerHomePage")){
                       close.accepted = false
                       stackView.pop();
                   }else{
                       return;
                   }
               }
}
