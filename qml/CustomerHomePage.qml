import QtQuick
import QtQuick.Controls
import "userData.js" as Data
Page {
    Label {
        text: "Hello " + Data.userDetails.user.email
    }

    Component.onCompleted: {
        console.log(JSON.stringify(Data.userDetails, null, 2))
    }
}
