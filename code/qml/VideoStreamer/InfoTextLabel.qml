/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1

// Just a conveniece element that defines the default font family,
// font size and font color. Text etc. has to be set from outside.
Text {
    font {
        family: visual.defaultFontFamily
        pixelSize: visual.generalFontSize
    }
    color: visual.defaultFontColor
}
