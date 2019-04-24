; do read %game.r
; replace all "" with <b> or links to documentation

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
}

askUser: function [
    correct [text!]
    request [text!]
    success [text!]
    failure [block!]
    /failed
][
    if not failed [
        print request
    ]
    
    prin ">> " resp: input
    
    either resp == correct [
        do resp
        print rejoin ["^/^/" success]
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
        "All adventurers need a ^"backpack^" to carry their supplies. Let's create an empty one now using the syntax you just learned.^/"
        "Excellent, you have created a backpack!"
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
    
    js-do { beep(999, 100, 1000) }
    
    prin "^/Press any key to continue ..." input
    
    print "In Rebol, the ^"probe^" command allows you to see inside variables."
    print/html "<code>var: ^"123^" probe var</code>"
    
    ; askUser 
    ;    "probe backpack"
    ;    "^/This is your backpack. Type probe backpack"
    ;    "^/There is nothing in your backpack."
]

begin