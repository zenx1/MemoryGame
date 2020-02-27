import Felgo 3.0
import QtQuick 2.0
import "Constants.js" as Constants

App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    NavigationStack {
        Page {
            id: mainPage

            // hide navigation bar
            navigationBarHidden: true

            // info text
            AppText {
                id: infoText
                anchors.top: parent.top
                anchors.margins: dp(25)
                width: mainPage.width
                wrapMode: AppText.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                text: "Select difficulty level to start the game"
            }

            // list with different options of game difficulty to choose from
            AppListView {
                id: difficultyList
                anchors.top: infoText.bottom
                anchors.margins: dp(25)
                // template of item in difficultyList
                delegate: SimpleRow {
                    AppText {
                        horizontalAlignment: Text.Center
                        anchors.fill: parent
                        text: modelData.difficulty
                    }
                    style.backgroundColor: "#800000FF"
                    onSelected: function(){
                        // start game with selected difficulty level
                        mainPage.navigationStack.push(Qt.resolvedUrl("Game.qml"), {difficulty: modelData.difficulty});
                    }
                }
                // data source of difficultyList
                model: [
                    { difficulty: Constants.DIFFICULTY_LEVEL.EASY },
                    { difficulty: Constants.DIFFICULTY_LEVEL.MEDIUM },
                    { difficulty: Constants.DIFFICULTY_LEVEL.EXPERT }
                ]
            }

            // 'Help' button
            FloatingActionButton {
                id: helpButton
                icon: IconType.question
                iconItem.size: dp(30)
                onClicked: function(){
                    // open Help page
                    mainPage.navigationStack.push(Qt.resolvedUrl("Help.qml"))
                }
                visible: true // show on all platforms, default is only Android
                width: dp(50)
                height: dp(50)
            }
        }
    }
}
