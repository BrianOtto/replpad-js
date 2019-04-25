; ?do=game
; replpad-write as text! read %game/main.r
; replace all quoted syntax (e.g. "block") with links to documentation
; print appears to be adding extra line divs sometimes

random/seed now

js-do {
    var beepTimeout = null

    function beep(volume, frequency, duration) {
        if (!beepTimeout) {
            var ac = new AudioContext()
            
            acOscillator = ac.createOscillator()
            acGain = ac.createGain()

            acOscillator.connect(acGain)
            acOscillator.frequency.value = frequency
            acOscillator.type = 'square'

            acGain.connect(ac.destination)
            acGain.gain.value = volume * 0.01

            beepTimeout = setTimeout(function() {
                acOscillator.stop()
                beepTimeout = null
            }, duration)
            
            acOscillator.start()
        } else {
            setTimeout(function() { beep(volume, frequency, duration) }, 100)
        }
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
    
    trim resp
    
    either resp == correct [
        do resp
        print rejoin ["^/" success]
    ][
        
        print rejoin ["^/^/" pick failure random length? failure "^/"]            
        askUser/failed correct request success failure
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
        "All adventurers need a backpack to carry their supplies. Let's create an empty one now using the syntax you just learned."
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
    
    js-do { beep(999, 100, 1500) }
    
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
       "Great job, but it looks like there is nothing in your backpack!"
       ["Hmm, the eye is not working. Maybe you're not looking at it correctly. Try again!"]
    
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
    print "This causes the word to not be evaluated and instead the literal value is returned."
    
    askUser 
       "probe 'bread"
       "^/Try to ^"probe^" the bread and see what you get."
       "As you can see, the literal value is returned"
       ["No, the bread you baffoon. I told you this journey required wits!" "Nope! Hint: Remember to prefix the single quote."]
    
    prin "^/Press any key to continue ... " input
    
    print/html "<hr>"
    prin "Level 3"
    print/html "<hr>"
    
    print/html "<img src='/game/icons/map.png' width='100'>"
    
    print "Congratulations! You have everything you need to venture outside."
    print "Let's pack our things and map a route to our next destination."
    
    js-do { beep(999, 100, 750) }
    js-do { beep(999, 500, 750) }
    
    prin "^/Press any key to continue ... " input
]

begin