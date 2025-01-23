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

        captureRect: Qt.rect(1 / 4, 1 / 4, 1 / 2, 1 / 2)

        onCapturedChanged: function (captured) {
            console.log("Captured")
            isScanning = false
            userId = captured.replace(/"/g, "");
            console.log(userId)
            console.log(root.comId)
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
                               console.log(JSON.stringify(message))
                               if(message) {
                                    server2.parameters = {
                                       "user_id": userId,
                                       "company": root.comId
                                   }
                                   server2.sendFunctionCall()
                               } else {
                                   console.log("not in company")
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
                                console.log(JSON.stringify(message))
                           }
    }
}
