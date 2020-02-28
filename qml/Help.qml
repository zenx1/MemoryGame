import Felgo 3.0
import QtQuick 2.0

Page {
    id: helpPage
    title: "Help"

    // make helpText scrollable
    AppFlickable {
        anchors.fill: parent
        // set margins so that text is not displayed from end to end of screen
        anchors.margins: dp(15)
        // set content width and height to helpText width and height
        contentWidth: helpText.width
        contentHeight: helpText.height

        AppText {
            id: helpText
            // set width reduced by dp(30) to account for margins
            width: helpPage.width - dp(30)
            wrapMode: AppText.WrapAtWordBoundaryOrAnywhere
            // describe how to play game and list credits
            text: "How to play\n\n" +
                  "In order to start the game select one of the difficulty levels (Easy, Medium or Expert).\n" +
                  "Screen with 24 squares containing question mark (?) will appear.\n" +
                  "You can tap on any square to see which animal is hidden beneath.\n" +
                  "Next, tap any other square to see if it contains same animal.\n"  +
                  "If this square doesn't contain same animal as previous one, " +
                  "animal in previously tapped square will get hidden again.\n" +
                  "Next, tap another square to see if that square contains same animal as previously tapped square, etc.\n"+
                  "When you've found two squares with same animals those two squares will be marked as solved with checkmark (✓).\n" +
                  "You then continue on to find the next pair of same animals " +
                  "and then the next pair, etc, until you've found all the pairs, " +
                  "at which point you've successfully completed the game.\n\n\n" +
                  "Credits\n\n" +
                  "All animal icons, question mark icon and checkmark icon made by Freepik from www.flaticon.com\n\n" +
                  "Sound effects obtained from https://www.zapsplat.com\n\n" +
                  "Confetti GIF Powered By GIPHY"
        }
    }
}
