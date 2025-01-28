import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SupaQML

Page {
    property int punches: 0
    property string comName: ""
    property int count: 0
    property int rewards_count: 0


    RoyaltyCard {
        id: card
        anchors.horizontalCenter: parent.horizontalCenter
        totalPunches: punches
        companyName: comName
        completedPunches: count
        rewards: rewards_count
        punchSize: 40
        spacing: 12
        columns: 6
    }

    Button {
        id: punchButton
        anchors {top: card.bottom; left: card.left; topMargin: 20}
        text: "Punch Card"
        onClicked: {
            server2.parameters = {
                "user_id": root.custId,
                "company": root.comId
            }
            server2.sendFunctionCall()
        }
    }

    Button {
        id: claimButton
        anchors {top: card.bottom; right: card.right; topMargin: 20}
        text: "Claim Reward"
        onClicked: {
            claimServer.parameters = {
                "user_id": root.custId,
                "com": root.comId
            }
            claimServer.sendFunctionCall()
        }
    }

    SupaServer {
        id: server
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        func: "get_user_punchcard_info_for"
        parameters: {
            "user_id": root.custId,
            "com_id": root.comId
        }

        Component.onCompleted: {
            sendFunctionCall()
        }

        onMessageReceived: message => {
                               console.log("user info received")
                               console.log(JSON.stringify(message,null,2))
                               punches = message[0].stamps_required
                               comName = message[0].company_name
                               count = message[0].stamps_count
                               rewards_count = message[0].reward_count
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
                               server.sendFunctionCall()
                           }
    }

    SupaServer {
        id: claimServer
        projectId: root.projectId
        key: root.key
        authorization: root.jwt
        func: "redeem_customer_reward"

        onMessageReceived: message => {
                               console.log("Reward Claimed")
                               server.sendFunctionCall()
                           }
    }
}
