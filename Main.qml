import QtQuick
import QtQuick.Controls
import QtCore
import SupaQML

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    property string projectId: "affixqvkrgfahaizxrhl"
    property string key: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmZml4cXZrcmdmYWhhaXp4cmhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMyNjE0NTIsImV4cCI6MjA0ODgzNzQ1Mn0.eyahwokwXcpwpWdYGCpskVcswqNh9ZzxHpsdiV8gxoM"
    property string jwt: ""
    Settings {
        id: settings
        property string username: ""
        property string password: ""
        property int checkValue: Qt.Unchecked
    }
    /*
    SupaSocket {
        id: socket
        sendHeartbeatMessage: true
        projectId: "affixqvkrgfahaizxrhl"
        key: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmZml4cXZrcmdmYWhhaXp4cmhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMyNjE0NTIsImV4cCI6MjA0ODgzNzQ1Mn0.eyahwokwXcpwpWdYGCpskVcswqNh9ZzxHpsdiV8gxoM"
        Component.onCompleted: {
             socket.openConnection()
        }
        payload: {
            "event": "phx_join",
            "topic": "realtime:public:customer_stamps",
            "ref": "1",
            "payload": {
                "schema": "public",
                "table": "customer_stamps"
            }
        }
    }
    */

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "qml/LoginPage.qml"
    }
}
