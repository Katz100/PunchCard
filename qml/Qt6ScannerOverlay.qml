import QtQuick

/*!
  Area for scanning barcodes
  */
Item {
  id: root

  property rect captureRect

  Item {
    readonly property color borderColor: "#218165"
    readonly property color textColor: "#000000"
    id: captureZoneCorners

    x: parent.width * root.captureRect.x
    y: parent.height * root.captureRect.y

    width: parent.width * root.captureRect.width
    height: parent.height * root.captureRect.height

    Rectangle {
      id: topLeftCornerH

      anchors {
        top: parent.top
        left: parent.left
      }

      width: 20
      height: 5

      color: "#218165"
      radius: height / 2
    }

    Rectangle {
      id: topLeftCornerV

      anchors {
        top: parent.top
        left: parent.left
      }

      width: 5
      height: 20

      color: "#218165"
      radius: width / 2
    }

    // ----------------------
    Rectangle {
      id: bottomLeftCornerH

      anchors {
        bottom: parent.bottom
        left: parent.left
      }

      width: 20
      height: 5

      color: "#218165"
      radius: height / 2
    }

    Rectangle {
      id: bottomLeftCornerV

      anchors {
        bottom: parent.bottom
        left: parent.left
      }

      width: 5
      height: 20

      color: "#218165"
      radius: width / 2
    }

    // ----------------------
    Rectangle {
      id: topRightCornerH

      anchors {
        top: parent.top
        right: parent.right
      }

      width: 20
      height: 5

      color: "#218165"
      radius: height / 2
    }

    Rectangle {
      id: topRightCornerV

      anchors {
        top: parent.top
        right: parent.right
      }

      width: 5
      height: 20

      color: "#218165"
      radius: width / 2
    }

    // ----------------------
    Rectangle {
      id: bottomRightCornerH

      anchors {
        bottom: parent.bottom
        right: parent.right
      }

      width: 20
      height: 5

      color: "#218165"
      radius: height / 2
    }

    Rectangle {
      id: bottomRightCornerV

      anchors {
        bottom: parent.bottom
        right: parent.right
      }

      width: 5
      height: 20

      color: "#218165"
      radius: width / 2
    }

    Rectangle {
      id: scanIndicator

      anchors {
        horizontalCenter: parent.horizontalCenter
      }

      width: parent.width
      height: 1

      color: "#218165"

      SequentialAnimation {
        id: scanIndicatorAnimation

        loops: Animation.Infinite
        PropertyAnimation {
          id: toTopAnimation

          target: scanIndicator
          property: "y"
          duration: 2000
          to: captureZoneCorners.height
        }

        PropertyAnimation {
          id: toBottomAnimation

          target: scanIndicator
          property: "y"
          duration: 2000
          to: 0
        }
      }
    }


  }

  Text {
    id: scanCapsuleText

    anchors {
      verticalCenter: captureZoneCorners.bottom
      horizontalCenter: captureZoneCorners.horizontalCenter
    }

    text: qsTr("Scan barcode")
    color: "#218165"
  }

  onCaptureRectChanged: {
    scanIndicatorAnimation.start()
  }
}
