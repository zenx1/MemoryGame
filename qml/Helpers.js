var UniqueRandomIntGenerator = function(min, max){
    // min is inclusive, max is exclusive
    var sortedIndexArray = [];
    for (var i = min; i < max;i++){
        sortedIndexArray.push(i);
    }
    return {
        getNext: function(){
            var randomIndex = Math.floor(Math.random() * (sortedIndexArray.length - min)) + min;;
            var randomItem = sortedIndexArray[randomIndex];
            sortedIndexArray.splice(randomIndex, 1);
            return randomItem;
        }
     };
};

function Timer() {
    return Qt.createQmlObject("import QtQuick 2.0; Timer {}", root);
}

var setTimout = function(callback, delay){
    var timer = new Helpers.Timer();
    timer.interval = delay;
    timer.repeat = false;
    timer.triggered.connect(function () {
        callback();
    });
    timer.start();
};

var lastSelectedIndex = null;

var solvedIcon = "../assets/icons/solved.png";
var maskIcon = "../assets/icons/mask.png";
