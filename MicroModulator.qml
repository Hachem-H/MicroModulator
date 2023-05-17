import QtQuick 2.2
import QtQuick.Dialogs 1.1

import MuseScore 3.0

MuseScore 
{
	id: microModulator
    version:  "1.0"
    description: qsTr("A MuseScore plugin which enables microtones")
	
    Component.onCompleted: 
    {
        if (mscoreMajorVersion >= 4) 
        {
            microModulator.title = "MicroModulator";
            microModulator.categoryCode = "composing-arranging-tools";
		}
    }
	
    onRun: 
    {
        console.log("Hello World!");
    }
}
