// randomly shuffles items in array
function shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
}

// imports QtQuick 2.0 Timer object
function Timer() {
    return Qt.createQmlObject("import QtQuick 2.0; Timer {}", root);
}

// setTimout polyfill
var setTimout = function(callback, delay){
    var timer = new Timer();
    timer.interval = delay;
    timer.repeat = false;
    timer.triggered.connect(function () {
        callback();
    });
    timer.start();
};
