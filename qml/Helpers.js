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
function setTimout(callback, delay){
    var timer = new Timer();
    timer.interval = delay;
    timer.repeat = false;
    timer.triggered.connect(function () {
        callback();
    });
    timer.start();
}

// calculates best fitting grid cell width and height, so that cell is as close to square as possible
// presumes a grid which contains even number of cells
function calculateCellSize(gridWidth, gridHeight, cellCount){
    if (cellCount < 0){
        throw 'cellCount is not a positive number!';
    }
    if (cellCount % 2){
        throw 'cellCount is not even number!';
    }

    // find numbers of possible rows or columns (depending on which is smaller in pixel size)
    var validDividers = [1, 2];
    var i;
    for (i = 3 ; i < cellCount; i++){
        if (cellCount / i < i){
            break;
        }
        if(cellCount % i === 0){
            validDividers.push(i);
        }
    }

    // find grid width and height dividers where difference is smallest after division
    var biggerSide = gridWidth > gridHeight ? gridWidth : gridHeight;
    var smallerSide = gridWidth < gridHeight ? gridWidth : gridHeight;
    var biggerDivider = 0;
    var smallerDivider = 0;
    var lastDifference = null;
    for (i = 0; i < validDividers.length; i++){
        smallerDivider = validDividers[i];
        biggerDivider = cellCount / smallerDivider;
        var difference = (smallerSide / smallerDivider) - (biggerSide / biggerDivider);

        difference = difference > 0 ? difference : -difference;
        if (lastDifference === null){
            lastDifference = difference;
            continue;
        }
        if(lastDifference < difference){
            smallerDivider = validDividers[i - 1];
            biggerDivider = cellCount / smallerDivider;
            break;
        }
        lastDifference = difference;
    }

    // assign dividers as column count and row count based on grid width and height
    var columnCount = gridWidth < gridHeight ? smallerDivider : biggerDivider;
    var rowCount = gridWidth > gridHeight ? smallerDivider : biggerDivider;

    // calculate and return cell width and height
    return {
        width : Math.floor(gridWidth / columnCount),
        height : Math.floor(gridHeight / rowCount)
    };
}
