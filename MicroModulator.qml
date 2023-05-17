import QtQuick 2.2
import QtQuick.Dialogs 1.1

import MuseScore 3.0

MuseScore 
{
	id: microModulator
    version:  "1.0"
    description: qsTr("A MuseScore plugin which enables microtones")

    function listProperty(item)
    {
        for (var prop in item)
            if(typeof item[prop] != "function")
                if(prop != "objectName")
                    console.log(prop + ":" + item[prop])
    }

    function tune(element) 
    {
        let notes = element.notes
        for (let i = 0; i < notes.length; i++)
        {
            let note = notes[i]

            console.log(" ===== NEW NOTE ===== ");
            console.log("Accidental Type: " + note.accidentalType)
            console.log("Pitch: " + note.pitch)
        }
    }

    function applyEffect(effect) 
    {
        let cursor = curScore.newCursor()
        let fullScore = false
        cursor.rewind(1)

        let startStaff
        let endStaff
        let endTick

        if (!cursor.segment) 
        {
            fullScore = true
            startStaff = 0
            endStaff = curScore.nstaves - 1
        } else 
        {
            startStaff = cursor.staffIdx;
            cursor.rewind(2)
            if (cursor.tick == 0)
                endTick = curScore.lastSegment.tick + 1
            else
                endTick = cursor.tick
            endStaff = cursor.staffIdx
        }
      
        for (let staff = startStaff; staff <= endStaff; staff++) 
        {
            for (let voice = 0; voice < 4; voice++) 
            {
                cursor.rewind(1)
                cursor.voice = voice
                cursor.staffIdx = staff

                if (fullScore)
                    cursor.rewind(0)

                while (cursor.segment && (fullScore || cursor.tick < endTick)) 
                {
                    if (cursor.element.type == Element.CHORD) 
                        effect(cursor.element)

                    cursor.next()
               }
            }
         }
      }

	
    Component.onCompleted: 
    {
        if (mscoreMajorVersion >= 4) 
        {
            microModulator.title = "MicroModulator"
            microModulator.categoryCode = "composing-arranging-tools"
		}
    }
	
    onRun: 
    {
        console.log("Hello World!")
        applyEffect(tune)
    }
}
