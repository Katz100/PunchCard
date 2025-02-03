import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import "userData.js" as Data
import SupaQML
import UserModel

Page {
    objectName: "CompanyHomePage"

    header: Rectangle {
        color: "lightgray"
        height: 55
        RowLayout {
            anchors.fill: parent
            Image {
                id: userImg
                source: "qrc:/imgs/user-icon.png"
                Layout.alignment: Qt.AlignRight
                Layout.topMargin: 20
                Layout.rightMargin: 40
                MouseArea {
                    anchors.fill: parent
                    onClicked: stackView.push("Settings.qml")
                }
            }
        }
    }

    UserFilterProxyModel {
        id: userModel
        sourceModel: customerListModel

    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0

        Rectangle {
            color: "white"
            border.color: "lightblue"
            border.width: 2

            Button {
                text: "Scan QR Code"
                anchors.centerIn: parent
                onClicked: {
                    if (camera.status !== Qt.PermissionStatus.Granted) {
                        camera.request()
                        console.log("Requesting camera permissions")
                    } else if (camera.status === Qt.PermissionStatus.Granted) {
                        stackView.push("ScanQRCodePage.qml")
                    }
                }
            }
        }

        Item {

            ColumnLayout {
                anchors.fill: parent
                spacing: 10


                TextField {
                    id: searchBar
                    placeholderText: "Search customers..."
                    Layout.topMargin: 20
                    Layout.fillWidth: true
                    onTextChanged: {
                        // Update the filter string in the C++ model.
                        userModel.filterString = text;
                        console.log("Filtering with:", text);
                        console.log(userModel.toString())
                    }
                }

                Label {
                    text: "You don't have any customers yet."
                    visible: customerListModel.count === 0
                    Layout.alignment: Qt.AlignCenter
                }

                ListView {
                    id: lv
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    model: userModel
                    spacing: 20
                    delegate: Rectangle {
                        id: delegateRect
                        width: parent.width - 40
                        height: 70
                        color: "white"
                        radius: 8
                        border.color: "lightgray"
                        border.width: 1
                        anchors.horizontalCenter: parent.horizontalCenter

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 10


                            Image {
                                id: customerIcon
                                source: "qrc:/imgs/user-icon.png"
                                width: 40
                                height: 40
                                fillMode: Image.PreserveAspectFit
                            }


                            ColumnLayout {
                                spacing: 4
                                Layout.alignment: Qt.AlignVCenter

                                Text {
                                    id: displayName
                                    text: customer_display_name
                                    font.pointSize: 16
                                    font.bold: true
                                    color: "#333333"
                                }

                                Text {
                                    id: lastStamp
                                    text: "Last Stamp: " + last_stamp
                                    font.pointSize: 12
                                    color: "#777777"
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.custId = customer_id
                                stackView.push("CustomerPunchCardPage.qml")
                            }
                        }
                    }
                }
            }
        }


    }

    footer: Rectangle {
        color: "lightgray"
        height: 75
        RowLayout {
            anchors.fill: parent
            Image {
                id: qrImg
                source: "qrc:/imgs/scan-icon.png"
                Layout.alignment: Qt.AlignHCenter
                opacity: swipeView.currentIndex === 0 ? 1.0 : 0.5
            }

            Image {
                id: tagImg
                source: "qrc:/imgs/users-icon.png"
                Layout.alignment: Qt.AlignHCenter
                opacity: swipeView.currentIndex === 1 ? 1.0 : 0.5
            }
        }
    }

    CameraPermission {
        id: camera
    }

    SupaServer {
        projectId: root.projectId
        key: root.key
        func: "get_user_company"
        parameters: {
            "user_id": Data.userDetails.user.identities[0].user_id
        }

        Component.onCompleted: {
            sendFunctionCall()
        }

        onMessageReceived: message => {
                               root.comId = message[0].com_id
                           }
    }

    SupaServer {
        id: server
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        func: "get_users_customers"

        Component.onCompleted: sendFunctionCall()

        onMessageReceived: message => {
                               console.log(JSON.stringify(message))
                               customerListModel.clear()
                               for (let item of message)
                               customerListModel.append({
                                                            customer_display_name: item.customer_display_name,
                                                            customer_id: item.customer_id,
                                                            last_stamp: item.last_stamp

                                                        }
                                                        )
                           }
    }

}
