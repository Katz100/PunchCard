import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: punchCard
    property int totalPunches: 10
    property int completedPunches: 0
    property int punchSize: 24
    property int spacing: 8

    radius: 12
    color: "#F5F5F5"
    border.color: "#CCCCCC"
    border.width: 2

    implicitWidth: (totalPunches * punchSize) + ((totalPunches - 1) * spacing) + 32
    implicitHeight: punchSize + 120

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        // Header Text
        Text {
            text: "Punch Card"
            font.pixelSize: 24
            font.bold: true
            color: "#000000"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        // Divider Line
        Rectangle {
            height: 1
            color: "#CCCCCC"
            Layout.fillWidth: true
        }

        // Punch Row
        RowLayout {
            id: punchRow
            spacing: punchCard.spacing
            Layout.alignment: Qt.AlignHCenter

            Repeater {
                model: punchCard.totalPunches
                delegate: Rectangle {
                    width: punchCard.punchSize
                    height: punchCard.punchSize
                    radius: punchCard.punchSize / 2
                    color: index < punchCard.completedPunches ? "#4CAF50" : "#E0E0E0" // Green for completed, gray for empty
                    border.color: "#9E9E9E"
                    border.width: 1
                }
            }
        }

        // Footer Text
        Text {
            text: completedPunches + "/" + totalPunches + " punches completed"
            font.pixelSize: 16
            color: "#757575"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

    }
}





