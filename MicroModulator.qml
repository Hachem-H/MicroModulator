import QtQuick 2.2
import QtQuick.Dialogs 1.1

import MuseScore 3.0

MuseScore 
{
	id: microModulator
    version: "1.0"
    description: qsTr("A MuseScore plugin which enables microtones")

    property var tuning: [
           0.00,    0.00,    0.00,    0.00, 
           0.00,    0.00,    0.00,    0.00,    
           0.00,    0.00,    0.00,  -50.00, 
        -150.00,   50.00,  -50.00,  150.00, 
          50.00,  250.00,  150.00, -150.00,
        -250.00,  -50.00,   50.00,  -50.00,

        -150.00,   50.00,  150.00,  -41.06,
         -70.67,   70.67,  141.30,  221.51,
        -121.51,  -21.51,   78.49,  178.49,
        -178.49,  -78.49,   21.51,  121.51,
         221.51, -221.51, -143.02,  -43.02,
          56.98,  156.98, -156.98,  -56.98,

          43.02,  143.02,  243.02, -243.02,
        -164.53,  -64.53,   35.47,  135.47,
        -135.47,  -35.47,   64.53,  164.53,
         264.53,  -21.51,   21.51,  -43.02,
          43.02,  -29.58,   29.58,  -23.08,
          23.08, -200.00, -100.00,    0.00,

         100.00,  200.00,  -50.00,   50.00,
          -8.72,    8.72,   -3.37,    3.37, 
         -49.17,   49.17,  -54.96,   54.96, 
         -22.64,   22.64,   50.00,  -50.00,
         -83.33,   83.33,  -91.67,   91.67, 
          -8.33,    8.33,  -16.67,   16.67,

         -25.00,   25.00,  -33.33,   33.33,
         -41.67,   41.67,  -50.00,   50.00, 
         -58.33,   58.33,  -66.67,   66.67,
         -75.00,   75.00,  -41.13,   41.13,
         -23.46,   23.46,  -27.66,   27.66,
         -48.77,   48.77,  -68.68,   68.68,

         -21.51,   21.51,  -43.04,   43.04,
         -75.96,   75.96,   -9.34,    9.34, 
          -5.34,    5.34,   -7.16,    7.16, 
         -71.43,   71.43, -117.00,  117.00, 
         -22.60,   22.60,  -45.30,   45.40,
         -68.00,   68.00,  -90.70,  113.40,
      ]

    function tune(element) 
    {
        let notes = element.notes
        for (let i = 0; i < notes.length; i++)
        {
            let note = notes[i]
            let accidental = note.accidentalType.valueOf()

            if (accidental <= tuning.length)
            {
                note.tuning = tuning[accidental]
                console.log(note.tuning)
            }
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
        applyEffect(tune)
    }
}
