import QtQuick 2.0
import Felgo 3.0
import "Constants.js" as Constants
import "Helpers.js" as Helpers
import "Game.js" as Game

Page {
    id: gamePage
    // hide navigation bar
    navigationBarHidden: true
    // image width and height property (calculated and set on Grid onCompleted event)
    property int calculatedImageSize: 0;
    // keep track of previously selected icon
    property var previouslySelectedAnimalIcon: null;
    // keeps track of how many animals user matched, in order to auto-match last pair
    property int matchedAnimalPairs: 0;
    // specifies if the game has been solved
    property bool solved: false;
    // selected difficulty setting
    property var difficulty;

    // data source for imageGrid
    ListModel {
        id: iconModel
    }

    // item template of imageGrid item/cell
    Rectangle {
        anchors.fill: parent
        Component {
            id: iconDelegate
            Item {
                // set width and height of item to fill Grid Cell
                width: imageGrid.cellWidth
                height: imageGrid.cellHeight
                // sets state of animalIcon to solved
                function solve(){
                    if(imagesColumn.state === Constants.ICON.STATES.SOLVED){
                        return;
                    }
                    imagesColumn.state = Constants.ICON.STATES.SOLVED;
                }
                Column {
                    id: imagesColumn
                    anchors.fill: parent
                    states: [
                        // hide mask icon and display solved icon instead of animal icon
                        State {
                            name: Constants.ICON.STATES.SOLVED
                            PropertyChanges { target: animalIcon; source: Constants.ICON.PATHS.SOLVED}
                            PropertyChanges { target: maskIcon; opacity: 0}
                        },
                        // hide animal icon and display 'mask' icon
                        State {
                            name: Constants.ICON.STATES.MASKED
                            PropertyChanges { target: animalIcon; opacity: 0}
                            PropertyChanges { target: maskIcon; opacity: 1}
                        },
                        // hide 'mask' icon and display animal icon
                        State {
                            name: Constants.ICON.STATES.SHOWN
                            PropertyChanges { target: animalIcon; opacity: 1}
                            PropertyChanges { target: maskIcon; opacity: 0}
                        }
                    ]

                    // fade in/out effect for icons
                    transitions: [
                        Transition {
                            NumberAnimation { property: "opacity"; easing.type: Easing.InOutQuad; duration: Game.getTransitionDuration(difficulty, imagesColumn.state) }
                        }
                    ]

                    // animal icon
                    Image {
                        id: animalIcon
                        smooth: true
                        anchors.centerIn: parent
                        source: animalIconPath
                        width: calculatedImageSize
                        height: calculatedImageSize
                    }

                    // image which is displayed on top of animal icon to hide it from user
                    Image {
                        id: maskIcon
                        smooth: true
                        anchors.centerIn: parent
                        source: Constants.ICON.PATHS.MASK
                        width: calculatedImageSize
                        height: calculatedImageSize
                    }

                    state: Constants.ICON.STATES.MASKED

                    MouseArea {
                        anchors.fill: parent
                        onClicked: function(){
                            // ignore if game has been solved
                            if (solved){
                                return;
                            }
                            // ignore selection of icons which have already been matched or which are currently shown
                            if(parent.state === Constants.ICON.STATES.SOLVED || parent.state === Constants.ICON.STATES.SHOWN){
                                return;
                            }
                            // show selected icon
                            parent.state = Constants.ICON.STATES.SHOWN;

                            if (!previouslySelectedAnimalIcon) {
                                // set currently selected icon to be next previously selected icon
                                previouslySelectedAnimalIcon = animalIcon;
                                return;
                            }

                            if(previouslySelectedAnimalIcon.source === animalIcon.source){
                                // keep track of how many matches user has made
                                matchedAnimalPairs++;

                                if (matchedAnimalPairs < 11){
                                    // user has selected 2 matching icons so set state of the icons as solved
                                    imagesColumn.state = Constants.ICON.STATES.SOLVED;
                                    previouslySelectedAnimalIcon.parent.state = Constants.ICON.STATES.SOLVED;
                                    previouslySelectedAnimalIcon = null;
                                    return;
                                }

                                // user has completed the game
                                // display celebration GIF
                                solved = true;
                                confettiGif.opacity = 1;
                                Helpers.setTimout(function(){
                                    // auto-solve last match
                                    for(var child in imageGrid.contentItem.children) {
                                        if(imageGrid.contentItem.children[child].solve){
                                            imageGrid.contentItem.children[child].solve();
                                        }
                                    }
                                }, 1000)

                                // provide some time for celebration GIF
                                Helpers.setTimout(navigationStack.popAllExceptFirst, 5000);
                                return;
                            }

                            // else, mask/hide previously selected icon and set currently selected icon to be next previously selected icon
                            previouslySelectedAnimalIcon.parent.state = Constants.ICON.STATES.MASKED;
                            previouslySelectedAnimalIcon = animalIcon;
                        }
                    }
                }
                // nice fadeIn effect on game start
                NumberAnimation on opacity {
                    id: createAnimation
                    from: 0
                    to: 1
                    duration: 2000
                }
            }
        }

        // GridView containing all the icons, essentially entire UI of the page
        GridView {
            id: imageGrid
            anchors.fill: parent
            anchors.margins: dp(10)
            model: iconModel
            delegate: iconDelegate
            focus: true
            Component.onCompleted: {
                console.log(gamePage.difficulty)
                // set cell width and height
                imageGrid.cellWidth = Math.floor(imageGrid.width / 4);
                imageGrid.cellHeight = Math.floor(imageGrid.height / 6);

                // calculate image size of icons
                calculatedImageSize = imageGrid.cellWidth - 25;

                // get array with randomly selected image paths of animals (always containing 12 unique pairs of animals)
                var randomIconPathCollection = Game.getRandomIconPathCollection();

                // fill iconModel, which will fill imageGrid since iconModel is it's data source
                for(var i = 0; i < 24; i++){
                    iconModel.set(i, { animalIconPath: randomIconPathCollection[i] });
                }
            }

        }

        AnimatedImage {
            id: confettiGif
            opacity: 0
            smooth: true
            anchors.centerIn: parent
            source: Constants.CONFETTI_GIF_PATH
            width: parent.width
            height: parent.height
        }
    }
}
