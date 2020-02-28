.import "Constants.js" as Constants
.import "Helpers.js" as Helpers

// returns icon fade in/out duration based on the icon state and difficulty level
function getTransitionDuration(difficulty, state){
    if (state === Constants.ICON.STATES.SHOWN){
        return 0;
    }
    if (state === Constants.ICON.STATES.SOLVED){
        return 1000;
    }
    if (difficulty === Constants.DIFFICULTY_LEVEL.EASY){
        return 3000;
    }
    if (difficulty === Constants.DIFFICULTY_LEVEL.MEDIUM){
        return 1000;
    }
    // case when difficulty === Expert
    return 0;
};

// returns an array with 12 randomly selected animal icon paths
function selectRandomIcons() {
    var iconPathsArray = [];
    for (var i = 1; i < 25; i++) {
        iconPathsArray.push("../assets/icons/" + i + ".png");
    }

    Helpers.shuffleArray(iconPathsArray);
    return iconPathsArray.slice(0, 12);
}

// returns an array with 12 pairs of animal icon paths randomly placed in the array
function getRandomIconPathCollection() {
    var randomIcons = selectRandomIcons();
    var randomIconCollection = randomIcons.concat(randomIcons);
    Helpers.shuffleArray(randomIconCollection);
    return randomIconCollection;
}
