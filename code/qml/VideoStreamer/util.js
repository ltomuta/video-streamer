.pragma library

function milliSecondsToString(milliseconds) {
    var timeInSeconds = Math.floor(milliseconds / 1000)
    var minutes = Math.floor(timeInSeconds / 60)
    var minutesString = minutes < 10 ? "0" + minutes : minutes
    var seconds = Math.floor(timeInSeconds % 60)
    var secondsString = seconds < 10 ? "0" + seconds : seconds
    return minutesString + ":" + secondsString
}
