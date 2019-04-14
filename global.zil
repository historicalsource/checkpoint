"GLOBALS for CHECKPOINT
Copyright (C) 1985 Infocom, Inc.  All rights reserved."

<OBJECT GLOBAL-OBJECTS
	(DESC "GO")
	(FDESC 0)
	(FLAGS	BUSYBIT CONTBIT DOORBIT FEMALE
		INVISIBLE LIGHTBIT LOCKED MUNGBIT
		NARTICLEBIT NDESCBIT ONBIT ;ON?BIT OPENBIT
		;PERSONBIT ;PLURAL READBIT RMUNGBIT
		SEARCHBIT ;SEENBIT SURFACEBIT
		TAKEBIT TOOLBIT TOUCHBIT TRANSBIT TRYTAKEBIT TURNBIT
		VEHBIT VOWELBIT WEAPONBIT WEARBIT WINDOWBIT WORNBIT)>

<OBJECT LOCAL-GLOBALS
	(LOC GLOBAL-OBJECTS)
	(DESC "LG")
	(SYNONYM ZZZZLG)	;"This synonym is necessary - God knows">

<ROUTINE DO-INSTEAD-OF (OBJ1 OBJ2)
	<COND (<EQUAL? ,PRSI .OBJ2> <PERFORM ,PRSA ,PRSO .OBJ1> <RTRUE>)
	      (<EQUAL? ,PRSO .OBJ2> <PERFORM ,PRSA .OBJ1 ,PRSI> <RTRUE>)
	      (<V-FOO>)>>

<OBJECT TURN
	(LOC GLOBAL-OBJECTS)
	(ADJECTIVE NUMBER FULL)
	(SYNONYM TURN TURNS MINUTE)
	(DESC "minute")
	(ACTION TURN-F)>

<ROUTINE TURN-F ()
 <COND (<VERB? USE>
	<PERFORM ,V?WAIT-FOR ,PRSO>
	<RTRUE>)>>

<OBJECT IT
	(LOC GLOBAL-OBJECTS)
	(SYNONYM IT THIS ;"FUCKER SUCKER")
	(DESC "it")
	(FLAGS VOWELBIT NARTICLEBIT)
	(ACTION IT-F)>

<ROUTINE IT-F ()
 <COND (<OR <AND <IOBJ? IT>
		 ;<FSET? ,PRSO ,PERSONBIT>
		 <VERB? ASK-ABOUT ASK-FOR SEARCH-FOR TELL-ABOUT>>
	    <AND <DOBJ? IT>
		 <VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR FIND WHAT>>>
	<PRODUCE-GIBBERISH>
	;<TELL "\"I'm not sure what you're talking about.\"" CR>)>>

<OBJECT FLOOR
	(LOC GLOBAL-OBJECTS)
	(DESC "floor")
	(SYNONYM FLOOR ;AREA GROUND)
	(ACTION FLOOR-F)>

<ROUTINE FLOOR-F ("AUX" OBJ)
 <COND ;(<REMOTE-VERB?> <RFALSE>)
       (<AND <VERB? PUT> <IOBJ? FLOOR>>
	<PERFORM ,V?DROP ,PRSO>
	<RTRUE>)
       (<VERB? EXAMINE SEARCH LOOK-ON>
	<COND (<SET OBJ <FIND-FLAG ,HERE ,NDESCBIT ,WINNER>>
	       <FCLEAR .OBJ ,NDESCBIT>
	       <THIS-IS-IT .OBJ>
	       <TELL "Something catches your eye: it's " A .OBJ "." CR>)
	      (T <TELL "You don't find anything new there." CR>)>)
       (<VERB? BRUSH TAKE>
	<COND (<IN? ,BLOOD-SPOT ,HERE>
	       <PERFORM ,V?BRUSH ,BLOOD-SPOT ,PRSI>
	       <RTRUE>)>)>>

;<OBJECT DANGER
	(LOC GLOBAL-OBJECTS)
	(DESC "danger")
	(SYNONYM DANGER THREAT)>

;<OBJECT MOTIVE
	(LOC GLOBAL-OBJECTS)
	(DESC "motive")
	;(ADJECTIVE YOUR)
	(SYNONYM MOTIVE)>

;<OBJECT PROBLEM
	(LOC GLOBAL-OBJECTS)
	(DESC "problem")
	(ADJECTIVE URGENT)
	(SYNONYM PROBLEM ;"WANT WRONG HAPPENING")>

;<OBJECT GLOBAL-WEAPON
	(LOC GLOBAL-OBJECTS)
	(DESC "weapon")
	(ADJECTIVE ;YOUR SOME)
	(SYNONYM WEAPON)>

;<OBJECT GLOBAL-EXPLOSIVE
	(LOC GLOBAL-OBJECTS)
	(DESC "explosive charge")
	(ADJECTIVE ;YOUR SOME EXPLOSIVE)
	(SYNONYM EXPLOSIVE CHARGE)
	(FLAGS VOWELBIT)>

;<OBJECT GLOBAL-SURFACE
	(LOC GLOBAL-OBJECTS)
	(DESC "surface")
	(SYNONYM SURFACE)>

<OBJECT DOLLARS
	(LOC GLOBAL-OBJECTS)
	(ADJECTIVE NUMBER)
	(SYNONYM SLIMPUK)
	(DESC "slimpuk")
	(ACTION DOLLARS-F)>

<ROUTINE DOLLARS-F ()
 <COND (<VERB? COUNT>
	<DO-INSTEAD-OF ,GLOBAL-MONEY ,DOLLARS>
	<RTRUE>)
       (T
	<COND (,P-DOLLAR-FLAG
	       <COND (<0? ,P-AMOUNT> <SETG P-AMOUNT 1>)>)
	      (T
	       <SETG P-DOLLAR-FLAG T>
	       <COND (<0? ,P-NUMBER> <SETG P-AMOUNT 1>)>)>
	<DO-INSTEAD-OF ,INTNUM ,DOLLARS>
	<RTRUE>)>>

<OBJECT INTNUM
	(LOC GLOBAL-OBJECTS)
	(SYNONYM NUMBER)
	(DESC "number")
	(ACTION INTNUM-F)>

<ROUTINE INTNUM-F ()
	 <COND ;(<AND ;<VERB? GIVE WITHDRAW>
		     <NOT ,P-DOLLAR-FLAG>>
		<TELL "(Please use units with numbers.)" CR>
		<SETG CLOCK-WAIT T>
		<RFATAL>)
	       (,P-DOLLAR-FLAG
		<COND (<DIVESTMENT? ,PRSO>
		       <TELL-FLASHING-CASH>
		       <RTRUE>)
		      (<AND <NOT <VERB? ;WITHDRAW TAKE ASK-FOR>>
			    <==? ,WINNER ,PLAYER>
			    <G? ,P-AMOUNT <GETP ,PLAYER ,P?SOUTH>>>
		       <TELL "You don't have that much." CR>)>)>>

;<OBJECT GLOBAL-WATER
	(LOC GLOBAL-OBJECTS)
	(DESC "water")
	(SYNONYM WATER)
	(ACTION WATER-F)>

;<ROUTINE WATER-F ()
 <COND (<REMOTE-VERB?> <RFALSE>)
       (<VERB? SWIM THROUGH>
	<TELL "This is no time for a swim!" CR>)>>

<OBJECT YOU
	(LOC GLOBAL-OBJECTS)
	(SYNONYM YOU YOURSELF HIMSELF HERSELF)
	(DESC "himself or herself")
	(FLAGS ;NDESCBIT NARTICLEBIT)
	(ACTION YOU-F)>

<ROUTINE YOU-F ()
 <COND (<NOT <==? ,WINNER ,PLAYER>>
	<DO-INSTEAD-OF ,WINNER ,YOU>
	<RTRUE>)
       (<AND <VERB? ASK-ABOUT> <IOBJ? YOU>>
	<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSO>
	<RTRUE>)>>

;<OBJECT HINT
	(DESC "clue" ;"hint")
	(LOC GLOBAL-OBJECTS)
	(SYNONYM CLUE HINT HELP)
	(ACTION HINT-F)>

;<ROUTINE HINT-F ()
 <COND (<VERB? FIND>
	<HELP-TEXT>)
       (<VERB? ASK-FOR ASK-CONTEXT-FOR TAKE>
	<MORE-SPECIFIC>)>>

<OBJECT CORRIDOR-GLOBAL
	(LOC GLOBAL-OBJECTS)
	(DESC "corridor")
	(SYNONYM CORRIDOR)
	(ACTION CORRIDOR-GLOBAL-F)>

<ROUTINE CORRIDOR-GLOBAL-F ("AUX" RM)
 <COND (<VERB? ANALYZE EXAMINE LOOK-INSIDE LOOK-DOWN LOOK-UP>
	<COND (<NOT ,ON-TRAIN>
	       <RFALSE>)
	      (<ZMEMQ ,HERE ,CAR-ROOMS-CORRID>
	       <PERFORM ,V?LOOK>
	       <RTRUE>)
	      (<SET RM <NEXT-ROOM ,HERE ,P?OUT>>
	       <ROOM-PEEK .RM T>)>)>>

<OBJECT GLOBAL-HERE
	(LOC GLOBAL-OBJECTS)
	(DESC "here")
	(ADJECTIVE THIS)
	(SYNONYM HERE AREA ROOM PLACE)
	(FLAGS NARTICLEBIT)
	(ACTION GLOBAL-HERE-F)>

<ROUTINE GLOBAL-HERE-F ("AUX" (FLG <>) F HR TIM VAL)
	 <COND (<VERB? WALK-TO SIT>
		<DO-INSTEAD-OF ,HERE ,GLOBAL-HERE>
		<RTRUE>)
	       (<VERB? KNOCK>
		<TELL "Knocking on the walls reveals nothing unusual." CR>)
	       (<VERB? PUT PUT-IN TIE-TO>
		<MORE-SPECIFIC>)
	       (<VERB? SEARCH EXAMINE>
		<COND ;(<OUTSIDE? ,HERE>
		       <SET TIM 10>)
		      (<NOT <ZERO? <GETP ,HERE ,P?CORRIDOR>>>
		       <SET TIM 3>)
		      (T <SET TIM <+ 2 <GETP ,HERE ,P?SIZE>>>)>
		<COND (<==? ,P-ADVERB ,W?CAREFULLY> <SET TIM <* 2 .TIM>>)>
		<TELL
"(It's better to examine or search one thing at a time. It would take a
long time to search a whole room or area thoroughly. A ">
		<COND (<==? ,P-ADVERB ,W?CAREFULLY> <TELL "careful">)
		      (T <TELL "brief">)>
		<TELL " search would take
" N .TIM " minutes, and it might not reveal much. Would you like
to do it anyway?)">
		<COND (<YES?>
		       <COND (<==? ,M-FATAL <SET VAL <INT-WAIT .TIM>>>
			      <RTRUE>)
			     (.VAL
			      <TELL "Your ">
			      <COND (<==? ,P-ADVERB ,W?CAREFULLY>
				     <TELL "careful">)
				    (T <TELL "brief">)>
			      <TELL " search reveals">
			      <COND (<SET VAL <FOUND? ,HERE>>
				     <TELL THE .VAL " under the seat." CR>)
				    (T <TELL " nothing exciting." CR>)>)
			     (T
			      <TELL
"You didn't finish looking over the place." CR>)>)
		      (T
		       <SETG CLOCK-WAIT T>
		       <TELL "Okay." CR>)>)>>

<ROUTINE FOUND? (RM "AUX" X)
	<COND (<AND <SET X <ZMEMQ .RM ,CAR-ROOMS-COMPS>>
		    <SET X <FIRST? <GET ,CAR-ROOMS-UNDER .X>>>>
	       <RETURN .X>)
	      (<==? .RM ,BOOTH-1>
	       <FIRST? ,UNDER-BOOTH-1>)
	      (<==? .RM ,BOOTH-2>
	       <FIRST? ,UNDER-BOOTH-2>)
	      (<==? .RM ,BOOTH-3>
	       <FIRST? ,UNDER-BOOTH-3>)>>

<OBJECT AIR
	(LOC GLOBAL-OBJECTS)
	(DESC "air")
	(SYNONYM AIR ;"WIND" BREEZE OXYGEN)
	(FLAGS VOWELBIT)
	(ACTION AIR-F)>

<ROUTINE AIR-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "You can see through the air around you." CR>)
	       (<VERB? WALK-TO>
		<TELL "It's all around you!" CR>)
	       (<VERB? SMELL>
		<COND (<OUTSIDE? ,HERE>
		       <TELL "The air is clear and fresh." CR>)
		      (<FRESH-AIR? ,HERE> <RTRUE>)
		      (T <TELL "The air is rather musty." CR>)>)>>

;<ROUTINE TOO-FAR-AWAY (OBJ) <TOO-BAD-BUT .OBJ "too far away">>

<OBJECT CHAIR
	(LOC LOCAL-GLOBALS)
	(DESC "chair")
	(SYNONYM CHAIR ;CHAIRS SEAT BENCH STOOL)
	(FLAGS NDESCBIT ;FURNITURE VEHBIT)
	;(ACTION CHAIR-F)>

;<ROUTINE CHAIR-F ()
 <COND (<VERB? SIT LOOK-UNDER CLIMB-ON CLIMB-DOWN>
	<TELL "That's just a waste of time." CR>)>>

<OBJECT SOMETHING
	(LOC GLOBAL-OBJECTS)
	(DESC "(something)")
	(SYNONYM \(SOMETHING\) )
	(ACTION SOMETHING-F)>

<ROUTINE SOMETHING-F ()
	<SETG CLOCK-WAIT T>
	<TELL "(Type a real word instead of " D ,SOMETHING ".)" CR>>

;<OBJECT MORE
	(DESC "more")
	(LOC GLOBAL-OBJECTS)
	(SYNONYM MORE)
	(FLAGS NARTICLEBIT)>

;<OBJECT GLOBAL-SABOTAGE
	(LOC GLOBAL-OBJECTS)
	(DESC "sabotage")
	(SYNONYM SABOTAGE)>

[
<OBJECT FIXTURES
	(LOC LOCAL-GLOBALS)
	(DESC "bunch of fixtures")
	(SYNONYM BUNCH FIXTURE FIXTURES)>

<OBJECT TOILET
	(LOC LOCAL-GLOBALS)
	(DESC "toilet")
	(SYNONYM TOILET ;FIXTURE)
	(FLAGS NDESCBIT OPENBIT CONTBIT SEARCHBIT VEHBIT)
	(CAPACITY 33)
	(ACTION TOILET-F)>

<ROUTINE TOILET-F ()
	 <COND (<VERB? OPEN CLOSE>
		<YOU-CANT>)
	       (<VERB? PUT-IN>
		<COND (<IOBJ? TOILET>
		       <FSET ,PRSO ,MUNGBIT>
		       <RFALSE>)>)
	       (<VERB? FLUSH FLUSH-DOWN>
		<COND (<AND ,IN-STATION ,ON-TRAIN>
		       <TELL
"An old refrain comes to mind:|
\"Passengers will please refrain|
From flushing toilets while the train|
Is standing in the station. (I love you!)\"" CR>)
		      (T
		       <COND (<VERB? FLUSH-DOWN>
			      <COND (<NOT <==? <ITAKE> T>> <RTRUE>)>
			      ;<FSET ,TOILET ,OPENBIT>
			      <MOVE ,PRSO ,TOILET>)>
		       <COND (<FIRST? ,TOILET>
			      <TELL "Say goodbye to">
			      <ROB ,TOILET ,LIMBO-FWD T>)>
		       <TELL "\"Whhoooossshhhhh!\"" CR>)>)>>

<ROUTINE ROB (WHAT THIEF "OPTIONAL" (TELL? <>) "AUX" N X (TOLD? <>))
	 <SET X <FIRST? .WHAT>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <NOT .N> .TOLD? .TELL?>
			<TELL " and">)>
		 <SET TOLD? T>
		 <COND (.TELL?
			<TELL THE .X>
			<COND (.N <TELL ",">)
			      (T <TELL ". ">)>)>
		 <MOVE .X .THIEF>
		 <FCLEAR .X ,TAKEBIT>
		 <SET X .N>>>

<OBJECT SINK
	(LOC LOCAL-GLOBALS)
	(DESC "sink")
	(SYNONYM SINK BOWL BASIN FAUCET)
	(FLAGS NDESCBIT CONTBIT SEARCHBIT OPENBIT)
	(CAPACITY 15)
	(TEXT
"It's a metal sink, a bit dented and scratched, with only one faucet.")
	(ACTION SINK-F)>

<ROUTINE SINK-F ()
	 <COND (<VERB? OPEN CLOSE>
		<YOU-CANT>)
	       (<VERB? LAMP-ON>
		<TELL
"You push on the handle, and water runs until you let go. A silly idea
comes into your head: what is the sound of one hand washing?" CR>)>>

<OBJECT TOWEL-FIXTURE
	(LOC LOCAL-GLOBALS)
	(DESC "towel dispenser")
	(ADJECTIVE TOWEL)
	(SYNONYM DISPENSER ;FIXTURE HOLDER)
	(FLAGS NDESCBIT)>

<OBJECT TOWEL-FIXTURE-BROKEN
	;(LOC OTHER-REST-ROOM-REAR)
	(CAR 0)
	(DESC "towel dispenser")
	(ADJECTIVE TOWEL)
	(SYNONYM DISPENSER ;FIXTURE HOLDER)
	(FLAGS NDESCBIT)>

<OBJECT TOWEL-LOOP
	(LOC LOCAL-GLOBALS ;TOWEL-FIXTURE)
	(DESC "towel")
	(ADJECTIVE CLOTH FRESH)
	(SYNONYM TOWEL PORTION)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION TOWEL-LOOP-F)>

<OBJECT TOWEL-LOOP-BROKEN
	(CAR 0)
	(DESC "towel remnant")
	(ADJECTIVE CLOTH FRESH)
	(SYNONYM TOWEL PORTION REMNANT)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION TOWEL-LOOP-BROKEN-F)>

<ROUTINE TOWEL-LOOP-F ()
 <COND (<VERB? CUT>
	<COND (<IOBJ? KNIFE>
	       <MOVE ,SCARF ,PLAYER>
	       <FSET ,SCARF ,TAKEBIT>
	       <PUTP ,SCARF ,P?CAR ,CAR-HERE>
	       <MOVE ,TOWEL-FIXTURE-BROKEN ,HERE>
	       <PUTP ,TOWEL-FIXTURE-BROKEN ,P?CAR ,CAR-HERE>
	       <MOVE ,TOWEL-LOOP-BROKEN ,HERE>
	       <PUTP ,TOWEL-LOOP-BROKEN ,P?CAR ,CAR-HERE>
	       <THIS-IS-IT ,TOWEL-LOOP-BROKEN>
	       <TELL
"Well done! You now have a government-issue " D ,SCARF ", and the janitor
has a mess to repair." CR>)>)
       (<VERB? EXAMINE>
	<TELL
"This cloth towel must be very long, but most of it is rolled up
inside the dispenser. Only about a meter hangs below it in a \"U\" shape."
CR>)
       (<VERB? MOVE MOVE-DIR USE TAKE>
	<TELL
"As you pull on the towel, a fresh portion appears from a slot, and
the used portion starts to disappear into the dispenser." CR>)>>

<ROUTINE TOWEL-LOOP-BROKEN-F ()
 <COND (<VERB? EXAMINE>
	<TELL
"This cloth towel must be very long, but most of it is rolled up
inside the dispenser. The part that should hang below is cut away." CR>)
       (<VERB? CUT MOVE MOVE-DIR USE TAKE>
	<TELL "There's not enough left!" CR>)>>

<OBJECT PAPER-FIXTURE
	;(LOC LOCAL-GLOBALS)
	(DESC "paper dispenser")
	(ADJECTIVE ;TOILET PAPER TISSUE)
	(SYNONYM DISPENSER ;FIXTURE HOLDER)
	(FLAGS NDESCBIT OPENBIT CONTBIT SEARCHBIT)
	(CAPACITY 3)
	(ACTION PAPER-FIXTURE-F)>

<ROUTINE PAPER-FIXTURE-F ()
 <COND (<VERB? LOOK-INSIDE>
	<FCLEAR ,PAPER-LOOP ,NDESCBIT>
	<RFALSE>)>>

<OBJECT PAPER-LOOP
	(LOC PAPER-FIXTURE)
	(CAR 0)
	(DESC "paper")
	(ADJECTIVE TOILET)
	(SYNONYM PAPER TISSUE PORTION)
	(FLAGS NARTICLEBIT NDESCBIT ;TRYTAKEBIT)
	(SIZE 3)
	(ACTION PAPER-LOOP-F)>

<ROUTINE PAPER-LOOP-F ()
 <COND (<VERB? MOVE MOVE-DIR USE TAKE>
	<TELL "Whatever you have in mind, it'll never work!" CR>)>>

<OBJECT MIRROR
	(LOC LOCAL-GLOBALS)
	(DESC "mirror")
	(SYNONYM MIRROR)
	(ACTION MIRROR-F)>

<ROUTINE MIRROR-F ()
	 <COND (<VERB? MUNG>
		<TELL "You don't need any bad luck!"
;"According to superstition, it's bad luck to break mirrors." CR>)
	       (<VERB? LOOK-INSIDE EXAMINE>
		<TELL "A harried and weary "
		      <COND (<SPY?> "spy") (T "traveler")>
		      " looks back at you, with a
look that seems to say, \"I don't need this aggravation!\"" CR>)>>
]
<OBJECT POCKET
	(LOC PLAYER ;GLOBAL-OBJECTS)
	(DESC "your pocket")
	(ADJECTIVE MY)
	(SYNONYM POCKET POCKETS)
	(FLAGS CONTBIT OPENBIT NARTICLEBIT NDESCBIT SEARCHBIT)
	(CAPACITY 15)
	(ACTION POCKET-F)>

<ROUTINE POCKET-F ("AUX" X)
	 <COND (<DIVESTMENT? ,POCKET>
		<HAR-HAR>)
	       ;(<AND <VERB? TAKE>
		     <DOBJ? GLOBAL-MONEY>>
		<TELL-FLASHING-CASH>)
	       (<VERB? LOOK-INSIDE LOOK-THROUGH>
		<SET X <PRINT-CONT ,POCKET ;T>>
		<COND (<AND <==? ,WINNER ,PLAYER>
			    <G? <GETP ,PLAYER ,P?SOUTH> 0>>
		       <THIS-IS-IT ,GLOBAL-MONEY>
		       <COND (.X <TELL "And some money." CR>)
			     (T
			      <TELL "You have some money in your pocket.">
			      <COND (<IN? ,CUSTOMS-AGENT ,HERE>
				     <TELL
" But" HE ,CUSTOMS-AGENT " won't mind.">)>
			      <CRLF>)>)
		      (<NOT .X> <TELL "Your pocket is empty." CR>)>
		<RTRUE>)
	       (<VERB? EMPTY>
		<COND (<FIRST? ,POCKET>
		       <TELL "You are now holding">
		       <ROB ,POCKET ,PLAYER T>
		       <CRLF>)>)
	       (<VERB? OPEN CLOSE>
		<TELL "You don't need to do that." CR>)
	       (<AND <VERB? PUT-IN>
		     <IOBJ? POCKET>>
		<COND (<OR <DOBJ? GLOBAL-MONEY>
			   <AND <DOBJ? INTNUM> ,P-DOLLAR-FLAG>>
		       <TELL "It's already there." CR>)
		      (<DOBJ? CAMERA>
		       <COND (<FSET? ,PRSO ,OPENBIT>
			      <FCLEAR ,PRSO ,OPENBIT>
			      <TELL "(You close" HIM ,PRSO " first.)" CR>
			      <RFALSE>)>)>)>>

<OBJECT POCKET-C
	(LOC CONDUCTOR ;GLOBAL-OBJECTS)
	(DESC "conductor's pocket")
	(ADJECTIVE CONDUCTOR CONDUC COLLECTOR)
	(SYNONYM POCKET POCKETS)
	(FLAGS CONTBIT OPENBIT NDESCBIT SEARCHBIT)
	(CAPACITY 15)
	(ACTION POCKET-C-F)>

<ROUTINE POCKET-C-F ("AUX" X)
	 <COND (<DIVESTMENT? ,POCKET-C>
		<HAR-HAR>)
	       (<VERB? LOOK-INSIDE LOOK-THROUGH>
		<COND (<OR <FSET? ,CONDUCTOR ,MUNGBIT>
			   <NOT <FSET? ,CONDUCTOR ,PERSONBIT>>>
		       <SET X <PRINT-CONT ,POCKET-C ;T>>)
		      (T <TELL
CHE ,CONDUCTOR " brushes your hand away without even looking." CR>)>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<TELL "You don't need to do that." CR>)
	       (<AND <VERB? PUT-IN>
		     <IOBJ? POCKET-C>>
		<COND (<DOBJ? CAMERA>
		       <COND (<FSET? ,PRSO ,OPENBIT>
			      <FCLEAR ,PRSO ,OPENBIT>
			      <TELL "(You close" HIM ,PRSO " first.)" CR>
			      <RFALSE>)>)>)>>

<ROUTINE TELL-FLASHING-CASH ()
	 <TELL "Flashing your bankroll is not a good idea." CR>>

<OBJECT GLOBAL-MONEY
	(LOC GLOBAL-OBJECTS)
	(ADJECTIVE SOME MY)
	(SYNONYM MONEY CASH \*)
	(DESC "money")
	(FLAGS NARTICLEBIT)
	(ACTION GLOBAL-MONEY-F)>

<ROUTINE GLOBAL-MONEY-F ()
	 <COND (<VERB? FIND>
		<TELL "It's not that easy!" CR>
		<RTRUE>)
	       (<REMOTE-VERB?>
		<RFALSE>)
	       (<AND <VERB? PUT PUT-IN> <DOBJ? GLOBAL-MONEY>>
		<MORE-SPECIFIC>)
	       (<G? <GETP ,PLAYER ,P?SOUTH> 0>
		<COND (<VERB? COUNT EXAMINE>
		       <TELL "You are carrying ">
		       <PRINTC ,CURRENCY-SYMBOL>
		       <TELL N <GETP ,PLAYER ,P?SOUTH> "." CR>)
		      (<VERB? GIVE>
		       <SETG CLOCK-WAIT T>
		       <TELL "(You didn't say how much money to give.)" CR>)
		      (<AND <VERB? TAKE> ,PRSI ;<FSET? ,PRSI ,PERSONBIT>>
		       <TELL "You can't see any money on" HIM ,PRSI "." CR>)
		      (<AND <VERB? SHOW> ;<DOBJ? CUSTOMS-AGENT>>
		       <RFALSE>)
		      (T <TELL-FLASHING-CASH>)>)
	       (T <NOT-HERE ,GLOBAL-MONEY>)>>

<OBJECT MENU
	(DESC "menu")
	(LOC LOCAL-GLOBALS)
	(FLAGS READBIT)
	(SYNONYM MENU)
	(ACTION MENU-F)
	(TEXT
"A sign on the wall has a long list of mysterious Frotzian phrases,
printed in ornate letters. All you can decipher is unpleasant things
like fish heads and lice, or rumpled stilt's skin. Wait! There's an
American phrase: Eggs McGuffin!")>

<ROUTINE MENU-F ()
	 <COND (<VERB? ANALYZE EXAMINE READ>
		<TELL <GETP ,MENU ,P?TEXT> CR>)>>

<OBJECT ITEMS
	(DESC "item")
	(LOC LOCAL-GLOBALS)
	(FLAGS READBIT VOWELBIT)
	(ADJECTIVE ;FIRST SECOND THIRD FOURTH FIFTH)
	(SYNONYM ITEM)
	(ACTION ITEMS-F)>

<ROUTINE ITEMS-F ()
	 <COND (<VERB? ASK-FOR BUY>
		<COND ;(<EQUAL? ,P-ADJ ;N ,W?FIRST>
		       <DO-INSTEAD-OF ,FOOD ,ITEMS>
		       <RTRUE>)
		      (T
		       <DO-INSTEAD-OF ,FOOD-2 ,ITEMS>
		       <RTRUE>)>)
	       (<VERB? ANALYZE EXAMINE READ>
		<TELL <GETP ,MENU ,P?TEXT> CR>)>>

<OBJECT FOOD-GLOBAL
	(DESC "food")
	(LOC GLOBAL-OBJECTS)
	(SYNONYM FOOD)
	(FLAGS NARTICLEBIT)
	(ACTION FOOD-GLOBAL-F)>

<ROUTINE FOOD-GLOBAL-F ()
	<COND (<VERB? ASK-FOR BUY SMELL>
	       <DO-INSTEAD-OF ,FOOD ,FOOD-GLOBAL>
	       <RTRUE>)
	      (<REMOTE-VERB?> <RFALSE>)
	      (T <NOT-HERE ,FOOD-GLOBAL>)>>

<OBJECT DRINK-GLOBAL
	(DESC "drink")
	(LOC GLOBAL-OBJECTS)
	(SYNONYM DRINK)
	(FLAGS NARTICLEBIT)
	(ACTION DRINK-F)>

<ROUTINE DRINK-F () <FOOD-F T>>

<OBJECT DRINK-1
	(DESC "drink")
	(LOC GLOBAL-OBJECTS)
	(SYNONYM TEA BEER COFFEE)
	(FLAGS NARTICLEBIT)
	(ACTION DRINK-1-F)>

<ROUTINE DRINK-1-F ()
	<DO-INSTEAD-OF ,DRINK-GLOBAL ,DRINK-1>
	<RTRUE>>

;<ROUTINE GENERIC-FOOD-F (X)
 <COND (<==? ,HERE <META-LOC ,FOOD>> ,FOOD)
       (T ,FOOD-GLOBAL)>>

<OBJECT FOOD-CAFE
	(DESC "food")
	(LOC CAFE)
	(SYNONYM FOOD)
	(FLAGS NDESCBIT NARTICLEBIT)
	(ACTION FOOD-F)>

<OBJECT FOOD	;"Make this similar to WINE-xxx."
	(DESC "plate of thin gruel")
	(LOC GALLEY)
	(CAR 3)
	(ADJECTIVE THIN FIRST)
	(SYNONYM GRUEL PLATE DISH FOOD ITEM)
	(FLAGS NDESCBIT SEARCHBIT)
	(SIZE 20)
	(ACTION FOOD-F)>

<CONSTANT FOOD-SIZE 4>
<CONSTANT FOOD-HALF-SIZE 2>

<ROUTINE FOOD-F ("OPTIONAL" (DRINK? <>) "AUX" PER OBJ X)
	<COND (<VERB? EAT SMELL DRINK>
	       <COND (<OR <VERB? SMELL>
			  <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>
			  ;<DOBJ? FOOD WINE-RED WINE-WHITE>>
		      <TELL "It's pungent but not very flavorful.">
		      <COND (<NOT <VERB? SMELL>>
			     <SET X <GETP ,PRSO ,P?SIZE>>
			     <PUTP ,PRSO ,P?SIZE .X>
			     <COND (<==? .X ,FOOD-HALF-SIZE>
				    <TELL " And it's half gone.">)
				   (<ZERO? .X>
				    <MOVE ,PRSO ,GLOBAL-OBJECTS>
				    <TELL " And it's gone.">)>)>
		      <COND (<SPY?>
			     <TELL
" You've had better in some mighty dank corners of the world.">)>
		      <CRLF>)
		     (T <TELL "That wouldn't be very polite." CR>)>)
	      (<VERB? POUR PUT PUT-IN MUNG>
	       <COND (<IOBJ? TOILET>
		      <RFALSE>)
		     (<AND <NOT <VERB? POUR>>
			   <IOBJ? TABLE-1 TABLE-2 TABLE-3>>
		      <RFALSE>)
		     (T <TELL "What a mess that would make!" CR>)>)
	      (<VERB? ASK-FOR BUY>
	       <COND (<AND <EQUAL? ,HERE ,PANTRY>
			   <INVASION? ,WAITER>>
		      <RTRUE>)>
	       <COND (,ON-TRAIN <SET PER ,WAITER>)
		     (T <SET PER ,WAITRESS>)>
	       <COND (.DRINK? <SET OBJ ,WINE-RED>)
		     (T <SET OBJ ,FOOD>)>
	       <COND (.DRINK?
		      <COND (<OR <FSET? ,WINE-RED ,TOUCHBIT>
				 <FSET? ,WINE-WHITE ,TOUCHBIT>>
			     <TELL "You've bought enough to drink already."CR>
			     <RTRUE>)>)
		     (<FSET? ,FOOD ,TOUCHBIT>	;<IN? ,FOOD ,HERE>
		      <TELL "You've bought enough to eat already." CR>
		      <RTRUE>)>
	       <COND (<0? <GETP ,PLAYER ,P?SOUTH>>
		      <TELL "You don't have enough money." CR>)
		     (<NOT <IN? .PER ,HERE>>
		      <TELL "You'd better talk to " A .PER " first." CR>)
		     (T
		      <PUTP ,PLAYER ,P?SOUTH <- <GETP ,PLAYER ,P?SOUTH> 1>>
		      <COND (<EQUAL? .OBJ ,WINE-RED ,WINE-WHITE>
			     <SET X <OR <CALL-FOR-PROP ,CUP-A ,WAITER>
					<CALL-FOR-PROP ,CUP-B ,WAITER>>>
			     <MOVE .OBJ .X>
			     <PUTP .OBJ ,P?CAR ,CAR-HERE>
			     <PUTP .OBJ ,P?SIZE ,FOOD-SIZE>
			     <FSET .OBJ ,TOUCHBIT>
			     <SET OBJ .X>)
			    (T <PUTP .OBJ ,P?SIZE ,FOOD-SIZE>)>
		      <MOVE .OBJ <OR <TABLE? ,HERE> ,HERE>>
		      <PUTP .OBJ ,P?CAR ,CAR-HERE>
		      <FSET .OBJ ,TAKEBIT>
		      <FSET .OBJ ,TOUCHBIT>
		      <FCLEAR .OBJ ,NDESCBIT>
		      <FCLEAR .PER ,TOUCHBIT>
		      <PUTP .PER ,P?LDESC 29>
		      <TELL
CHE .PER " returns in an instant with " A .OBJ " and takes ">
		      <PRINTC ,CURRENCY-SYMBOL>
		      <TELL "1 from you." CR>)>)>>

<OBJECT CUP-A
	(LOC GLOBAL-OBJECTS)
	(CAR 3)
	(DESC "china cup")
	(ADJECTIVE CHINA)
	(SYNONYM CUP)
	(FLAGS CONTBIT OPENBIT SEARCHBIT)
	(CAPACITY 15)
	(SIZE 20)
	(ACTION CUP-F)>

<OBJECT CUP-B
	(LOC GLOBAL-OBJECTS)
	(CAR 3)
	(DESC "enamel cup")
	(ADJECTIVE ENAMEL)
	(SYNONYM CUP)
	(FLAGS CONTBIT OPENBIT SEARCHBIT VOWELBIT)
	(CAPACITY 15)
	(SIZE 20)
	(ACTION CUP-F)>

<ROUTINE CUP-F ()
 <COND (<VERB? THROW-AT THROW-THROUGH EMPTY>
	<COND (<EQUAL? <LOC ,WINE-RED> ,PRSO ,PRSI>
	       <MOVE ,WINE-RED ,GLOBAL-OBJECTS>)>
	<COND (<EQUAL? <LOC ,WINE-WHITE> ,PRSO ,PRSI>
	       <MOVE ,WINE-WHITE ,GLOBAL-OBJECTS>)>
	<ROB ,PRSO ,HERE>
	<ROB ,PRSI ,HERE>
	<COND (<VERB? EMPTY> <TELL "Okay." CR>)
	      (T <RFALSE>)>)
       (<AND <VERB? PUT-IN>
	     <DOBJ? SCARF NAPKIN TOWEL-WAITER>
	     <IOBJ? CUP-A CUP-B>
	     <IN? ,WINE-RED ,PRSI>>
	<DO-INSTEAD-OF ,WINE-RED ,PRSI>
	<RTRUE>)>>

<OBJECT WINE-RED
	(LOC GLOBAL-OBJECTS)
	(CAR 3)
	(DESC ;"cup of " "purple wine")
	(ADJECTIVE PURPLE RED)
	(SYNONYM WINE ;CUP)
	(FLAGS NARTICLEBIT TRYTAKEBIT SEARCHBIT)
	(SIZE 10)
	(ACTION WINE-F)>

<OBJECT WINE-WHITE
	(LOC GLOBAL-OBJECTS)
	(CAR 3)
	(DESC ;"cup of " "yellow wine")
	(ADJECTIVE YELLOW WHITE)
	(SYNONYM WINE ;CUP)
	(FLAGS NARTICLEBIT TRYTAKEBIT SEARCHBIT)
	(SIZE 10)
	(ACTION WINE-F)>

<ROUTINE WINE-PUT? ()
 <COND (<VERB? PUT>
	<COND (<AND <IOBJ? SCARF NAPKIN TOWEL-WAITER>
		    <DOBJ? WINE-RED>>
	       <RETURN ,PRSI>)>)
       (<VERB? PUT-IN>
	<COND (<AND <DOBJ? SCARF NAPKIN TOWEL-WAITER>
		    <IOBJ? WINE-RED>>
	       <RETURN ,PRSO>)>)>>

<ROUTINE WINE-F ("AUX" OBJ)
 <COND (<AND <VERB? TAKE> <EQUAL? <LOC ,PRSO> ,CUP-A ,CUP-B>>
	<PERFORM ,PRSA <LOC ,PRSO> ,PRSI>
	<RTRUE>)
       (<SET OBJ <WINE-PUT?>>
	;<OR <AND <VERB? PUT>
		 <IOBJ? SCARF NAPKIN TOWEL-WAITER>
		 <DOBJ? WINE-RED>
		 <SET OBJ ,PRSI>>
	    <AND <VERB? PUT-IN>
		 <DOBJ? SCARF NAPKIN TOWEL-WAITER>
		 <IOBJ? WINE-RED>
		 <SET OBJ ,PRSO>>>
	<MOVE ,HANKY <LOC .OBJ>>
	<FSET ,HANKY ,TAKEBIT>
	<MOVE .OBJ ,LIMBO-FWD ;,GLOBAL-OBJECTS>
	<FCLEAR .OBJ ,TAKEBIT>
	<MOVE ,WINE-RED ,GLOBAL-OBJECTS>
	<TELL
"The " D .OBJ " soaks up the wine, and the stain spreads to every nook
and cranny. Within a minute, you have a decent imitation of a " D ,HANKY
"." CR>)
       (T <FOOD-F T>)>>

<OBJECT FOOD-1
	(DESC "food")
	(LOC GLOBAL-OBJECTS)
	(ADJECTIVE FISH RUMPLED STILT'S)
	(SYNONYM FISH HEADS LICE SKIN)
	(FLAGS NARTICLEBIT)
	(ACTION NO-FOOD-F)>

<OBJECT FOOD-2
	(DESC "food")
	(LOC GLOBAL-OBJECTS)
	(ADJECTIVE EGGS)
	(SYNONYM ;FOOD EGGS MCGUFFIN MACGUFFIN ;ITEM)
	(FLAGS NARTICLEBIT)
	(ACTION NO-FOOD-F)>

<OBJECT FOOD-3
	(DESC "food")
	(LOC GLOBAL-OBJECTS)
	(SYNONYM MEAL SNACK BREAKFAST LUNCH DINNER SANDWICH BREAD)
	(FLAGS NARTICLEBIT)
	(ACTION NO-FOOD-F)>

<ROUTINE NO-FOOD-F ("AUX" PER)
	<COND (,ON-TRAIN <SET PER ,WAITER>)
	      (T <SET PER ,WAITRESS>)>
	<COND (<VERB? ASK-ABOUT BUY>
	       <TELL CTHE .PER " shakes" HIS .PER>
	       <THIS-IS-IT ,FOOD>
	       <THIS-IS-IT .PER>
	       <TELL
" head and points to the first item on the menu, which you find unreadable."
CR>)>>

<ROUTINE TABLE? (RM)
 <COND (<==? .RM ,CAFE> ,COUNTER-CAFE)
       (<==? .RM ,BOOTH-1> ,TABLE-1)
       (<==? .RM ,BOOTH-2> ,TABLE-2)
       (<==? .RM ,BOOTH-3> ,TABLE-3)>>

<OBJECT LANGUAGE
	(LOC GLOBAL-OBJECTS)
	(DESC "language")
	(ADJECTIVE FROTZIAN FOREIGN THEIR HIS ;HER)
	(SYNONYM LANGUAGE FROTZIAN)
	(ACTION LANGUAGE-F)>

<ROUTINE LANGUAGE-F ()
 <COND (<VERB? ANALYZE LEARN>
	<TELL
"Maybe you should have taken your company's offer to pay for language
lessons before you started this trip. After all, English isn't spoken
everywhere." CR>)>>

<OBJECT GESTURE
	(LOC GLOBAL-OBJECTS)
	(DESC "gesture")
	(ADJECTIVE FROTZIAN FOREIGN THEIR HIS ;HER NASTY)
	(SYNONYM GESTURE)
	(ACTION GESTURE-F)>

<ROUTINE GESTURE-F ("AUX" P)
 <COND (<VERB? ANALYZE LEARN>
	<TELL
"Maybe you should have taken your company's offer to pay for gesture
lessons before you started this trip. After all, English gestures aren't used
everywhere." CR>)
       (<VERB? MAKE>
	<COND (<AND ,PRSI <FSET? ,PRSI ,PERSONBIT>>
	       <SET P ,PRSI>)
	      (<QCONTEXT-GOOD?> <SET P ,QCONTEXT>)
	      (<NOT <SET P <FIND-FLAG ,HERE ,PERSONBIT ,WINNER>>>
	       <NOT-CLEAR-WHOM T>
	       <RTRUE>)>
	<TELL
CTHE .P V .P make " a gesture right back. Somehow it looks nastier than
yours." CR>)>>

<OBJECT LIGHT-GLOBAL 
	(LOC GLOBAL-OBJECTS)
	(DESC "light")
	(SYNONYM LIGHT SUNLIGHT MOONLIGHT)>

<OBJECT GAME
	(LOC GLOBAL-OBJECTS)
	(DESC ;"STEAM AND VARIATIONS" "CHECKPOINT" ;"SEVEN SHADOWS")
	(ADJECTIVE SPY SHORT LONG)
	(SYNONYM THRILLER GAME CHECKPOINT)
	(FLAGS NARTICLEBIT)
	(ACTION GAME-F)>

<ROUTINE GAME-F ()
 	 <COND (<VERB? EXAMINE PLAY READ>
	        ;<COND (<EQUAL? ,P-ADJ ;N ,W?SHORT> )>
		<SETG CLOCK-WAIT T>
	        <TELL "(You're doing it now!)" CR>)>>

<OBJECT HANDS
	(LOC GLOBAL-OBJECTS)
	(DESC "your hands")
	(SYNONYM HANDS)
	(ADJECTIVE ;YOUR MY BARE)
	(FLAGS NARTICLEBIT PLURALBIT)>

<OBJECT HEAD
	(LOC GLOBAL-OBJECTS)
	(DESC "your head")
	(SYNONYM HEAD ;FACE)
	(ADJECTIVE ;YOUR MY)
	(FLAGS NARTICLEBIT)
	(ACTION HEAD-F)>

<ROUTINE HEAD-F ()
 <COND (<VERB? NOD>
	<PERFORM ,V?YES>
	<RTRUE>)
       (<VERB? SHAKE>
	<PERFORM ,V?NO>
	<RTRUE>)>>
