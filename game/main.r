; usage = ?do=game
; to see source = replpad-write as text! read %game/main.r
; replace all quoted syntax (e.g. "block") with links to documentation
; print appears to be adding extra line divs sometimes

random/seed now

map: []

js-do {
    var audioTimeout = null

    function playAudio(volume, frequency, duration) {
        if (!audioTimeout) {
            var ac = new AudioContext()
            
            acOscillator = ac.createOscillator()
            acGain = ac.createGain()

            acOscillator.connect(acGain)
            acOscillator.frequency.value = frequency
            acOscillator.type = 'square'

            acGain.connect(ac.destination)
            acGain.gain.value = volume * 0.01

            audioTimeout = setTimeout(function() {
                acOscillator.stop()
                audioTimeout = null
            }, duration)
            
            acOscillator.start()
        } else {
            setTimeout(function() { playAudio(volume, frequency, duration) }, 10)
        }
    }
    
    function playNote(note, duration) {
        frequency = 0
        
        switch (note) {
            case 'A' : frequency = 220.0000; break
            case 'B' : frequency = 246.9417; break
            case 'C' : frequency = 261.6256; break
            case 'D' : frequency = 293.6648; break
            case 'E' : frequency = 329.6276; break
            case 'F' : frequency = 349.2282; break
            case 'G' : frequency = 391.9954; break
        }
        
        playAudio(1000, frequency, duration)
    }
}

css-do {
    hr {
        position: relative;
        top: 10px;
    }
    
    code {
        background: #DDD;
        border: 1px solid #000;
        padding: 10px;
        position: relative;
        top: 8px;
    }
    
    fieldset {
        background: #DDD;
        border: 1px solid #000;
        padding: 0px 5px;
        max-width: 400px;
    }
    
    fieldset legend {
        font-weight: bold;
        font-family: 'Inconsolata', monospace;
    }
}

askUser: function [
    correct [text!]
    request [text!]
    success [text!]
    failure [block!]
    /failed
][
    if not failed [
        print rejoin [request "^/"]
    ]
    
    prin ">> " resp: input
    
    trim/lines resp
    
    if resp == "cheat" [
        do correct
        print rejoin ["^/" success]
        return
    ]
    
    either resp == correct [
        do resp
        print rejoin ["^/" success]
    ][
        
        print rejoin ["^/^/" pick failure random length? failure "^/"]            
        askUser/failed correct request success failure
    ]
]

askChoice: function [
    choices [block!]
    correct [block!]
    request [text!]
    success [text!]
    failure [block!]
    /failed
    return: [text!]
][
    if not failed [
        print rejoin [request "^/"]
    ]
    
    prin ">> " resp: input
    
    trim/lines resp
    
    either find correct resp [
        match: pick choices to integer! next find resp "/"
        print rejoin ["^/^/" success match "!"]
        return match
    ][
        print rejoin ["^/^/" pick failure random length? failure "^/"]
        askChoice/failed choices correct request success failure
    ]
]

begin: function [] [
    print "^/Welcome, brave adventurer! You are about to embark into the curious world of Rebol."
    print "It is a place where few venture. It will require wits, courage and perseverance!"
    
    prin "^/Are you ready for this challenge? [n/Y] "
    
    resp: input
    
    if resp == "n" [
        print "^/^/Come back when you are ready. We will be waiting for you!"
        
        return
    ]
    
    print/html "<hr>"
    prin "Level 1"
    print/html "<hr>"
    
    print "In Rebol, variables are called ^"words^" and you assign ^"values^" to them using a colon."
    print/html "<code>name: ^"Carl Sassenrath^"</code>"
    
    prin "^/Press any key to continue ... " input
    
    print "^/"
    print "One of the most common datatypes you'll see is called a ^"block^". They are used to store a collection of words and values."
    print/html "<code>pioneers: [^"John McCarthy^" name ^"Niklaus Wirth^"]</code>"
    
    prin "^/Press any key to continue ... " input
    
    print "^/"
    
    askUser 
        "backpack: []"
        "All adventurers need a backpack to carry their supplies. Let's create one now using the syntax you just learned."
        "^/Excellent, you have created a backpack!"
        [
            "Nope! Hint: It should be a block so that it can hold multiple items."
            "Nope! Hint: Try naming it ^"backpack^"."
        ]
    
    print/html "<img src='/game/icons/backpack.png' width='100'>"
    
    prin "Did you hear something? (turn up the volume and press any key) ... " input
    
    print/html "<hr>"
    prin "Level 2"
    print/html "<hr>"
    
    print/html "<img src='/game/icons/probe.png' width='100'>"
    
    print "Congratulations! You have been given the power of the all-seeing eye!"
    print "It allows you to probe into the mysterious unknown."
    
    js-do {
        // Bohemian Rhapsody
        playNote('D', 250) // eas-
        playNote('D', 250) // y
        playNote('C', 500) // come
        
        playNote('B', 250) // eas-
        playNote('B', 250) // y
        playNote('C', 500) // go
    }
    
    prin "^/Press any key to continue ... " input
    
    print "^/"
    print "In Rebol, the ^"probe^" command allows you to see the unevaluated ^"value^" that a ^"word^" contains."
    print "This is useful for debugging, and it can be placed anywhere a value is returned."
    
    print "^/Here is an example."
    
    print/html "<code>probe pioneers</code>"
    print/html "<fieldset><legend>Result</legend><pre>[^"John McCarthy^" name ^"Niklaus Wirth^"]</pre></fieldset>"
    
    askUser 
        "probe backpack"
        "^/Try the ^"probe^" command now, and let's see what is inside your backpack."
        "Great job, but there is nothing in your backpack!"
        ["Hmm, your power is weak. The eye is not working. Try again!"]
    
    print "^/Laying on the floor is a few items for your journey."
    
    prin "^/Press any key to take a look ... " input
    
    prin "^/"
    
    print/html "<img src='/game/icons/bread.png' width='100'>"
    print "'bread"
    
    print/html "<img src='/game/icons/rope.png' width='100'>"
    print "'rope"
    
    print/html "<img src='/game/icons/sword.png' width='100'>"
    print "'sword"
    
    print "^/In Rebol, a ^"word^" can be used as a symbol. You do this by prefixing it with a single quote."
    print "This causes the word to return its literal value instead of being evaluated."
    
    askUser 
        "probe 'bread"
        "^/Try to ^"probe^" the bread and see what you get."
        "As you can see, the literal value is returned."
        [
            "No, the bread you baffoon. I told you this journey required wits!"
            "Nope! Hint: Remember to prefix the single quote."
        ]
    
    prin "^/Press any key to continue ... " input
    
    print/html "<hr>"
    prin "Level 3"
    print/html "<hr>"
    
    print/html "<img src='/game/icons/map.png' width='100'>"
    
    print "Congratulations! You have everything you need to venture outside."
    print "Let's pack our things and map a route to our next destination."
    
    js-do {
        // Star Wars Theme
        playNote('D', 333)
        playNote('D', 333)
        playNote('D', 333)
        
        playNote('G', 1000)
        playNote('D', 1000)
        
        playNote('C', 166)
        playNote('B', 166)
        playNote('A', 166)
        playNote('G', 1000)
        playNote('D', 500)
        
        playNote('C', 166)
        playNote('B', 166)
        playNote('A', 166)
        playNote('G', 1000)
        playNote('D', 500)
        
        playNote('C', 166)
        playNote('B', 166)
        playNote('C', 166)
        playNote('A', 1000)
    }
    
    prin "^/Press any key to continue ... " input
    
    print "^/"
    
    print "In Rebol, you can add words or values to a ^"block^" by inserting them."
    
    print "^/Here is an example."
    
    print/html "<code>languages: [^"Lisp^" ^"Pascal^"]</code>"
    print/html "<code>insert languages ^"Rebol^"</code>"
    
    print "^/Where do you think it will get inserted?"
    prin "^/Press any key to see ... " input
    
    prin "^/"
    
    print/html "<fieldset><legend>Result</legend><pre>[^"Rebol^" ^"Lisp^" ^"Pascal^"]</pre></fieldset>"
    
    print "It gets inserted at the beginning."
    print "^/If you want to insert it at the end, or tail, of the ^"block^" then you would do this ... "
    print/html "<code>insert tail languages ^"Rebol^"</code>"
    
    prin "^/Press any key to see ... " input
    
    prin "^/"
    print/html "<fieldset><legend>Result</legend><pre>[^"Lisp^" ^"Pascal^" ^"Rebol^"]</pre></fieldset>"
    
    print "If you want to insert it as the second, or next, position then you would do this ... "
    print/html "<code>insert next languages ^"Rebol^"</code>"
    
    prin "^/Press any key to see ... " input
    
    prin "^/"
    print/html "<fieldset><legend>Result</legend><pre>[^"Lisp^" ^"Rebol^" ^"Pascal^"]</pre></fieldset>"
    
    print "All blocks have a starting position that defaults to the beginning."
    print "You must change this position to insert data there, and this is what ^"tail^" and ^"next^" do."
    
    askUser 
        "insert backpack 'bread"
        "^/Now try placing the bread into your backpack."
        "^/Excellent, you now have something to eat on your journey!"
        [
            "Nope! Hint: There is no need to worry about the position when inserting the first item."
            "Nope! Hint: Remember to use the literal value of the word."
        ]
    
    askUser 
        "insert tail backpack 'rope"
        "^/Next put your rope into the backpack, but place it at the bottom so you don't ruin your bread."
        "^/Excellent, you never know when rope will come in handy!"
        ["Well, don't go hanging yourself just yet! Persevere and you will succeed."]
    
    askUser 
        "insert next backpack 'sword"
        "^/Huh, what did you say? No, no, no! Of course there is room for the sword.^/Try placing it next to the rope. You will see."
        "^/Excellent, you are now ready for anything!"
        ["Uhm, I asked you to place it *next* to the rope!"]
    
    print "^/Let's verify we have everything in our backpack before we leave."
    
    askUser 
        "probe backpack"
        "^/Do you remember how to do that?"
        "Perfect, we are set!"
        ["Hmm, this must be embarrassing for you. Are you sure you can handle the all-seeing eye?"]
    
    prin "^/Press any key to continue ... " input
    
    prin "^/"
    
    print "^/Ok, brave adventurer. Now it's time to choose!"
    print "^/In Rebol, you can retrieve values from a ^"block^" by specifying a ^"path^" to its position."
    print "Just remember the starting position is always 1."
    
    print "^/Here is an example."
    
    print/html "<code>coins: [^"copper^" ^"silver^" ^"gold^"]</code>"
    print/html "<code>coins/2</code>"
    print/html "<fieldset><legend>Result</legend><pre>^"silver^"</pre></fieldset>"
    
    prin "Press any key to continue ... " input
    
    prin "^/"
    
    print "^/The map has several paths to choose from. Pick one!^/"
    
    ; Richard Bartle's Player Types
    map: [
        "collect ancient treasure" ; Achiever
        "explore the lost ruins"   ; Explorer
        "talk with the wise men"   ; Socializer
        "battle undead creatures"  ; Killer
    ]
    
    probe map
    
    path: askChoice 
        map
        ["map/1" "map/2" "map/3" "map/4"]
        "^/Where do you want to go?"
        "You have choosen to "
        ["Nope! Hint: Try using the word ^"map^""]
    
    prin "^/Press any key to continue ... " input
    
    if path != map/4 [
        print "^/^/So, uhm, my mistake. This is just a demo and that path is not available yet."
        prin "How about we do something else instead? Press any key to continue ... " input
    ]
    
    print/html "<hr>"
    prin "Level 4"
    print/html "<hr>"
    
    print/html "<img src='/game/icons/monster.png' width='100'>"
    
    print "It's time to BATTLE UNDEAD CREATURES !!!!"
    
    js-do {
        // Fur Elise
        playNote('E', 250)
        playNote('D', 250)
        
        playNote('E', 250)
        playNote('D', 250)
        playNote('E', 250)
        playNote('B', 250)
        playNote('D', 250)
        playNote('C', 250)
        
        playNote('A', 625)
    }
    
    prin "^/Are you ready? [n/Y] "
    
    resp: input
    
    if resp == "n" [
        print "^/^/Too bad, you can't turn back now!"
        prin "^/Press any key to continue ... " input
    ]
]

begin