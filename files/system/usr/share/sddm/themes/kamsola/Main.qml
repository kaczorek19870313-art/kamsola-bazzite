import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 1920
    height: 1080
    color: "#0A0A0A"

    Image {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
    }

    Image {
        id: logo
        source: "logo.png"
        width: parent.width * 0.26
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.10
    }

    Rectangle {
        id: loginBox
        width: 340
        height: 260
        radius: 14
        color: "#0A0A0A"
        opacity: 0.88
        border.color: "#F5C400"
        border.width: 2
        anchors.centerIn: parent

        Column {
            anchors.centerIn: parent
            spacing: 14

            ComboBox {
                id: user
                width: 260
                model: userModel
                index: userModel.lastIndex
            }

            PasswordBox {
                id: password
                width: 260
                font.pixelSize: 14
                color: "white"
                focus: true
                onAccepted: sddm.login(user.currentText, password.text, session.index)
            }

            ComboBox {
                id: session
                width: 260
                model: sessionModel
                index: sessionModel.lastIndex
            }

            Button {
                width: 260
                text: "Zaloguj"
                onClicked: sddm.login(user.currentText, password.text, session.index)
            }
        }
    }

    Connections {
        target: sddm
        onLoginFailed: {
            password.text = ""
        }
    }
}
