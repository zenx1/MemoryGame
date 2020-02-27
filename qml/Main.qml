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
            navigationBarHidden: true

            AppText {
              id: infoText
              text: "Select difficulty level to start the game"
              anchors.top: parent.top
              anchors.margins: dp(25)
              width: mainPage.width
              wrapMode: AppText.WrapAtWordBoundaryOrAnywhere
              horizontalAlignment: Text.AlignHCenter
            }

            AppListView {
              delegate: SimpleRow {
                  AppText {
                    id: maxMinTempHeader
                    horizontalAlignment: Text.Center
                    width: parent.width
                    height: parent.height
                    text: modelData.difficulty
                  }
                  style.backgroundColor: "#800000FF"
                  onSelected: function(){
                      mainPage.navigationStack.push(Qt.resolvedUrl("Game.qml"), {difficulty: modelData.difficulty});
                  }
              }
              model: [
                  { difficulty: Constants.DIFFICULTY_LEVEL.EASY },
                  { difficulty: Constants.DIFFICULTY_LEVEL.MEDIUM },
                  { difficulty: Constants.DIFFICULTY_LEVEL.EXPERT }
              ]
              anchors.top: infoText.bottom
              anchors.margins: dp(25)
            }

            FloatingActionButton {
              id: helpButton
              icon: IconType.question

              iconItem.size: dp(12)
              onClicked: function(){
                   mainPage.navigationStack.push(Qt.resolvedUrl("Help.qml"))
              }
              visible: true // show on all platforms, default is only Android
              width: dp(30)
              height: dp(30)
            }
        }
    }
}
