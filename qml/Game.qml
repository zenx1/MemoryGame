import QtQuick 2.0
import Felgo 3.0
import "Helpers.js" as Helpers

Page {
    id: gamePage
    navigationBarHidden: true

    ListModel {
        id: contactModel
    }

    Rectangle {
        anchors.fill: parent
        Component {
            id: contactDelegate
            Item {
                width: imageGrid.cellWidth
                height: imageGrid.cellHeight
                Column {
                    anchors.fill: parent
                    Image {
                        source: icon;
                        anchors.centerIn: parent
                        width: imageGrid.cellWidth - 25
                        height: imageGrid.cellWidth - 25
                    }
                }
                NumberAnimation on opacity {
                    id: createAnimation
                    from: 0
                    to: 1
                    duration: 2000
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: function(){
                        var currentIndex = index;
                        var previousIndex = Helpers.lastSelectedIndex;

                        if(previousIndex === currentIndex || contactModel.get(currentIndex).solved){
                            return;
                        }

                        var currentSelectedIcon = contactModel.get(currentIndex).hiddenIcon;
                        contactModel.set(currentIndex, { icon: currentSelectedIcon })

                        if (previousIndex === null){
                            Helpers.lastSelectedIndex = currentIndex;
                            return;
                        }

                        var previousSelectedIcon = contactModel.get(previousIndex).hiddenIcon;
                        Helpers.lastSelectedIndex = currentIndex;
                        if(previousSelectedIcon === currentSelectedIcon){
                            contactModel.set(currentIndex, { icon: Helpers.solvedIcon, solved: true });
                            contactModel.set(previousIndex, { icon: Helpers.solvedIcon, solved: true });
                            Helpers.lastSelectedIndex = null;
                        } else {
                            Helpers.setTimout(function(){
                                contactModel.set(previousIndex,{ icon:  Helpers.maskIcon });
                            },1000);
                        }
                    }
                }
            }
        }

        GridView {
            id: imageGrid
            anchors.fill: parent
            anchors.margins: dp(10)
            model: contactModel
            delegate: contactDelegate
            focus: true
            Component.onCompleted: {
                // fill the grid with icons on start
                imageGrid.cellWidth = Math.floor(imageGrid.width/4);
                imageGrid.cellHeight = Math.floor(imageGrid.height/6);
                var randomIntGenerator = new Helpers.UniqueRandomIntGenerator(0, 24);

                var i;
                for(i = 0; i<24; i++){
                    contactModel.append({ icon: Helpers.maskIcon });
                }

                function insertIcons(){
                    for(var j = 1; j < 13; j++){
                        contactModel.set(randomIntGenerator.getNext(), {
                                             hiddenIcon: "../assets/icons/"+j+".png",
                                             icon: Helpers.maskIcon});
                    }
                }

                // populating grid with icons in two steps allows for more random distribution
                // populating in a single step results in less random distribution
                for(i = 0; i < 2; i++){
                    insertIcons();
                }
            }

        }
    }
}
