import QtQuick
import QtQuick.Controls
import QtMultimedia
import com.scythestudio.scodes 1.0
import SupaQML
Page {
    property bool isScanning: true
    property string userId: ""
    SBarcodeScanner {
        id: barcodeScanner

        forwardVideoSink: videoOutput.videoSink
        scanning: isScanning

        captureRect: Qt.rect(0, 0, 1, 1)

        onCapturedChanged: function (captured) {
            console.log("Captured")
            isScanning = false
            userId = captured.replace(/"/g, "");
            server.parameters = {
                "user_id": userId,
                "com_id": root.comId
            }
            server.sendFunctionCall()
        }
    }

    VideoOutput {
        id: videoOutput

        anchors.fill: parent

        width: root.width

        focus: visible
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Qt6ScannerOverlay {
        id: scannerOverlay

        anchors.fill: parent

        captureRect: barcodeScanner.captureRect
    }

    SupaServer {
        id: server
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        func: "is_user_in_company"

        onMessageReceived: message => {
                               //user in company
                               if(message) {
                                    console.log("user in company")
                                    server2.parameters = {
                                       "user_id": userId,
                                       "company": root.comId
                                   }
                                   server2.sendFunctionCall()
                               } else {
                                   console.log("user not in company")
                                   addUserServer.parameters = {
                                       "user_id": userId,
                                       "com_id": root.comId
                                   }
                                   addUserServer.sendFunctionCall()
                               }
                           }
    }

    SupaServer {
        id: server2
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        func: "increment_customer_stamps"

        onMessageReceived: message => {
                               console.log("user stamps incremented")
                               root.custId = userId
                               stackView.pop()
                               stackView.push("CustomerPunchCardPage.qml")
                           }
    }

    SupaServer {
        id: addUserServer
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        func: "add_user_to_company"

        onMessageReceived: message => {
                               console.log("user added to company")
                               server2.parameters = {
                                  "user_id": userId,
                                  "company": root.comId
                              }
                              server2.sendFunctionCall()
                           }
    }
}
