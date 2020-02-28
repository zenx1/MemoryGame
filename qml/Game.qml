import QtQuick 2.0
import Felgo 3.0
import QtMultimedia 5.0
import "Constants.js" as Constants
import "Helpers.js" as Helpers
import "Game.js" as Game

Page {
    id: gamePage
    // hide navigation bar
    navigationBarHidden: true
    // icon container width and height property (calculated and set on Grid onCompleted event)
    property int iconContainerWidth: 0;
    property int iconContainerHeight: 0;
    // keep track of previously selected icon
    property var previouslySelectedAnimalIcon: null;
    // keeps track of how many animals user matched, in order to auto-match last pair
    property int matchedAnimalPairs: 0;
    // specifies if the game has been solved
    property bool solved: false;
    // selected difficulty setting, set by Main page
    property var difficulty;

    // 'solved' audio, to be played when user finds 2 matching animal icons
    Audio {
        id: solvedSound
        volume: 0.5
        source: Constants.SOLVED_SOUND_FILE_PATH
    }

    // 'cheers' audio, to be played on game completion
    Audio {
        id: cheersSound
        volume: 0.5
        source: Constants.CHEERS_SOUND_FILE_PATH
    }

    Rectangle {
        anchors.fill: parent

        // item template of imageGrid item
        Component {
            id: iconDelegate
            Item {
                // sets state of selected imagesColumn(s) to 'solved'
                function setAsSolved(){
                    if (imagesColumn.state === Constants.ICON.STATES.SOLVED) {
                        return;
                    }
                    imagesColumn.state = Constants.ICON.STATES.SOLVED;

                    if(previouslySelectedAnimalIcon){
                        previouslySelectedAnimalIcon.parent.parent.state = Constants.ICON.STATES.SOLVED;
                    }
                }

                // performs 'celebration' and does a return back to Main page
                function gameCompleted(){
                    // user has completed the game
                    solved = true;
                    // display celebration GIF
                    confettiGif.opacity = 1;
                    // play 'cheers' sound
                    cheersSound.play();
                    // auto-solve last match after a small delay (to get a smooth visual effect)
                    Helpers.setTimout(function(){
                        for(var child in imageGrid.contentItem.children) {
                            if(imageGrid.contentItem.children[child].setAsSolved){
                                imageGrid.contentItem.children[child].setAsSolved();
                            }
                        }
                    }, 1500)

                    // provide some time for celebration GIF and sound
                    Helpers.setTimout(navigationStack.popAllExceptFirst, 9000);
                }

                // plays sound and sets state of last 2 selected icons as 'solved'
                function matchFound() {
                    solvedSound.stop();
                    solvedSound.play();
                    setAsSolved();
                    previouslySelectedAnimalIcon = null;
                }

                // sets state of previously selected icon to 'masked'
                function matchNotFound() {
                    // mask/hide previously selected icon and set currently selected icon to be next previously selected icon
                    previouslySelectedAnimalIcon.parent.parent.state = Constants.ICON.STATES.MASKED;
                    previouslySelectedAnimalIcon = animalIcon;
                }

                Column {
                    id: imagesColumn
                    anchors.fill: parent
                    states: [
                        // hide 'mask' icon and display 'solved' icon instead of animal icon
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

                    // container for animal and 'mask' icons
                    Rectangle {
                        color: "#d4d4d4"
                        width: iconContainerWidth
                        height: iconContainerHeight
                        radius: 4

                        // animal icon
                        Image {
                            id: animalIcon
                            smooth: true
                            anchors.centerIn: parent
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            anchors.margins: dp(5)
                            source: animalIconPath
                        }

                        // icon which is displayed by default instead of animal icon
                        Image {
                            id: maskIcon
                            smooth: true
                            anchors.centerIn: parent
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            anchors.margins: dp(5)
                            source: Constants.ICON.PATHS.MASK
                        }

                        // listens for tap/click on icon container
                        MouseArea {
                            anchors.fill: parent
                            onClicked: function(){
                                // ignore if game has been solved
                                if (solved){
                                    return;
                                }

                                // ignore selection of icons which have already been matched or which are currently shown
                                if(imagesColumn.state === Constants.ICON.STATES.SOLVED || imagesColumn.state === Constants.ICON.STATES.SHOWN){
                                    return;
                                }

                                // show selected icon
                                imagesColumn.state = Constants.ICON.STATES.SHOWN;

                                if (!previouslySelectedAnimalIcon) {
                                    // there is no previously selected icon
                                    // set currently selected icon to be next previously selected icon
                                    previouslySelectedAnimalIcon = animalIcon;
                                    return;
                                }

                                if(previouslySelectedAnimalIcon.source === animalIcon.source){
                                    // user has selected 2 matching animal icons
                                    matchFound();

                                    // keep track of how many matches user has made
                                    matchedAnimalPairs++;
                                    if (matchedAnimalPairs === 11){
                                        // game has been completed
                                        gameCompleted();
                                    }
                                } else {
                                    // user has selected 2 non-matching animal icons
                                    matchNotFound();
                                }
                            }
                        }
                    }

                    // set default state of icon to 'masked' so that user doesn't see animal icon
                    state: Constants.ICON.STATES.MASKED
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

        // resizes imageGrid cell elements based on imageGrid width and height
        function resizeIcons(){
            var cellSize =  Helpers.calculateCellSize(imageGrid.width, imageGrid.height, 24);
            // set cell width and height
            imageGrid.cellWidth = cellSize.width;
            imageGrid.cellHeight = cellSize.height;

            // calculate size of icon container
            iconContainerWidth = imageGrid.cellWidth - dp(2);
            iconContainerHeight = imageGrid.cellHeight - dp(2);
        }


        // resize imageGrid cell elements on width or height change (on game start and possible screen rotation, etc)
        onWidthChanged: {
            resizeIcons();
        }
        onHeightChanged: {
            resizeIcons();
        }

        // GridView containing all the icons, essentially entire UI of the page
        GridView {
            id: imageGrid
            anchors.fill: parent
            // disable grid scroll/swipe
            interactive: false
            // set margins so that ui is not displayed from end to end of screen
            anchors.margins: dp(5)
            // set data source
            model: ListModel {
                id: iconModel
            }

            // set template from which grid item should be created
            delegate: iconDelegate
            Component.onCompleted: {
                // get array with randomly selected image paths of animals (always containing 12 unique pairs of animals)
                var randomIconPathCollection = Game.getRandomIconPathCollection();

                // fill iconModel, which will fill imageGrid since iconModel is it's data source
                for(var i = 0; i < 24; i++){
                    iconModel.set(i, { animalIconPath: randomIconPathCollection[i] });
                }
            }
        }

        // game completed celebration GIF
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
