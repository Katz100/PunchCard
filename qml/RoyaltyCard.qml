import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: punchCard
    property string companyName: "Company"
    property int totalPunches: 12
    property int completedPunches: 7
    property int punchSize: 40
    property int spacing: 12
    property int columns: 4

    radius: 12
    color: "#F5F5F5"
    border.color: "#CCCCCC"
    border.width: 2

    // Dynamically calculate the size
    implicitWidth: (columns * punchSize) + ((columns - 1) * spacing) + 32
    implicitHeight: (Math.ceil(totalPunches / columns) * punchSize) + ((Math.ceil(totalPunches / columns) - 1) * spacing) + 120

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        // Header Text
        Text {
            text: companyName
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

        // Punch Grid
        GridLayout {
            id: punchGrid
            columns: punchCard.columns
            rowSpacing: punchCard.spacing
            columnSpacing: punchCard.spacing
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







