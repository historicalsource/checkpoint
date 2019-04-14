"MAIN for CHECKPOINT
Copyright (C) 1985 Infocom, Inc.  All rights reserved."

<ROUTINE GO ()
	<INIT-STATUS-LINE T>
	<SETG LIT T>
	<PUTB ,P-LEXV 0 59>
	<PUTB ,YES-LEXV 0 4>
	<SETG WINNER ,PLAYER>
	<ENABLE <QUEUE I-PROMPT 1>>
	<INTRO>
	<FSET ,HERE ,SEENBIT>
	<START-MOVEMENT>
	<V-LOOK>
	<MAIN-LOOP>
	<AGAIN>>    

<GLOBAL VARIATION 0>
<CONSTANT MAX-VAR 6>
"<GLOBAL LONG-INTRO <>>
<GLOBAL HARD? <>>
<GLOBAL EGO <>>"

<ROUTINE INTRO ("AUX" N)
	<SETG HERE ,GAME>
	<TELL
"Copyright (c) 1985 Infocom, Inc.  All rights reserved.|
|
Welcome to " D ,GAME " (TM) - interactive fiction from Infocom!|
|
">
	<TELL
"[Note to testers: this story has the command GO TO,
and the concept of not being able to see things behind your back.
The unit of currency in this story is the Frotzian slimpuk, whose
symbol is \"">
	<PRINTC ,CURRENCY-SYMBOL>
	<TELL "\".|
|
Messages in square brackets [] will not be in the final release.
|
Remember: you can shorten your words only to NINE (9) letters.|
But you can use C for COMPARTMENT, V for VESTIBULE, and F for FORWARD.]|
|
">
	<TELL "Do you want the viewpoint of the traveler or the spy? ">
	<SET N <READ-WORD ,W?TRAVELER ,W?SPY ,W?T ,W?S ,W?TRAVELLER>>
	<COND (<EQUAL? .N ,W?SPY ,W?S>
	       <SETG VARIATION 3>)
	      (T <SETG VARIATION 1>)>
	<REPEAT ()
		<TELL
"Do you want the short variation or the long one? "
;"Please type a number to choose the one you want this time. ">
		<SET N <READ-WORD ,W?SHORT ,W?LONG ,W?S ,W?L>>
		;<TELL "Is variation #">
		;<COND (<L? .N 10> <PRINTC %<ASCII !\0>>)>
		;<TELL N .N " the one you want?">
		<COND (T ;<YES?> <RETURN>)>>
	<TELL "Then let the story begin!" CR>
	<COND (<EQUAL? .N ,W?L ,W?LONG>
	       <INC VARIATION>
	       <PUT ,BRIEFCASE-TBL <ZMEMZ ,MCGUFFIN ,BRIEFCASE-TBL> 0>
	       <FSET ,MCGUFFIN ,NDESCBIT>
	       <FCLEAR ,MCGUFFIN ,TAKEBIT>
	       ;"<SETG HARD? T>")>
	<TAKE-YOUR-PLACES>
	<COND (<HARD?>
	       <MOVE ,MCGUFFIN ,LIMBO-REAR ;"non-spoiler">)>
	<START-TRAIN>
	;<COND (<==? ,TRAIN-NAME <GET ,TRAIN-TABLE-B 0>>
	       <PUTP ,COAT ,P?CAR ,PLATFORM-MAX>)
	      (T <MOVE ,COAT ,LIMBO-FWD>)>
	;<CRLF>
	<CLEAR 0>
	<COND (<SPY?>	;<EQUAL? ,VARIATION 3 4>
	       <REMOVE ,BOND>
	       <MOVE ,BOND-OTHER ,HERE>
	       ;"<PUTP ,BOND-OTHER ,P?LDESC 33>
	       <FCLEAR ,BOND-OTHER ,TOUCHBIT>"
	       <ENABLE <QUEUE I-BOND-OTHER -1>>
	       <TELL
"Why did you want to be a spy anyway? You could have had a nice restful
job, like an air-traffic controller. You could have tended flowers
behind a white picket fence around your country cottage. At least they
could let you grab a few winks between one job and the next. But no --
you finish debriefing in some dirty little city in Frotzerland, and
before you can even find a phone book, let alone a hotel, they volunteer
you for another assignment.|
|
\"You've got to intercept " A ,MCGUFFIN "!\" they told you. \"Then
deliver it to our agent in Gola so the leak can be traced.
We don't know where it is for sure,
but we think it's in a briefcase that's leaving town on the next train.
You're the only agent that's close enough and experienced enough to be
sent after it. And at the end of the trip, there will be a plane ticket
to home waiting for you.\"|
|
So that's why you're climbing all over this stupid train. Finding the
briefcase was easy enough, but the dude carrying it was something else.
Even your well-placed bullet didn't make him drop. Now, if only he'll take
the bait and follow you up here, you can .... Wait! Here he comes from
the forward end! But he's not carrying the case!|
|
">)
	      (T
	       <TELL
"With your business deal behind you, you want only to get out of this
bleak corner of Eastern Europe. The frontier is now only a few hours
away, and from there it's not far to Vienna, and
civilization....|
|
The ride seems endless, and you're dozing off again. The
wheels of the train are ticking like a clock, ticking off the segments
of track you're passing, and the compartment is rocking you back and
forth, back and forth, making your eyelids slowly close.|
|
Your slumber is cut short as a man staggers into your compartment,
panting strangely. From his demeanor, you guess that he has drunk too
much. But before you can dismiss him, you notice that he's grasping a
bright red spot on his shirt. He speaks quietly, but in a hurry.|
|
\"I've got only a moment, so listen carefully! Since you were reading
the International Herald over lunch, I assume you're an
American. I am an agent of our government, and I've been sent to ">
	       <COND (<HARD?>
		      <TELL
"pick up some kind of " D ,MCGUFFIN " in Frbz and take it">)
		     (T <TELL "deliver a " D ,MCGUFFIN>)>
	       <TELL " to our special agent in
Gola. An enemy agent spotted me on the train, and I only barely managed
to escape.\" He groans softly, examining his wound.|
|
\"The best I can do now is throw the enemy off the scent, but I need
you, and your country needs you, to carry out my assignment.\" You start
to interrupt, a thousand questions racing through your mind. \"There's
no time! Here! Take my briefcase, but be careful with it!
Our enemies are all around us! My contact in ">
	       <COND (<HARD?> <PRINTD ,STATION-FRBZ>)
		     (T <PRINTD ,STATION-GOLA>)>
	       <TELL " is ">
	       <TELL A ,CONTACT ", and I was to display ">
	       <COND (<NOT <HARD?>>
		      <TELL A ,PASSOBJECT ", then use the word">
		      <COND (<EQUAL? ,PASSWORD ,CAMERA ,HANKY ,SCARF>
			     <TELL "s">)>
		      <TELL " '" D ,PASSWORD "' ">)>
	       <TELL
"....\" Then he stops and listens.
Before you can say anything, he checks the corridor and races out.|
|
">
	       <ENABLE <QUEUE I-BOND 1>>)>
	<V-VERSION>
	<CRLF>
	<INIT-STATUS-LINE>>

<ROUTINE READ-WORD (WD1 WD2 "OPTIONAL" (WD3 <>) (WD4 <>) (WD5 <>) "AUX" N L)
	<TELL ">">
	<READ ,P-INBUF ,P-LEXV>
	<COND (<0? <GETB ,P-LEXV ,P-LEXWORDS>>
	       <PLEASE-TYPE-OR .WD1 .WD2>
	       <AGAIN>)>
	<SET L ,P-LEXSTART>
	<REPEAT ()
		<SET N <GET ,P-LEXV .L>>
		<COND (<NOT <WT? .N ,PS?BUZZ-WORD>> <RETURN>)>
		<SET L <+ .L ,P-LEXELEN>>>
	<COND (<OR <EQUAL? .N .WD1 .WD2>
		   <EQUAL? .N .WD3 .WD4 .WD5>>
	       <RETURN .N>)>
	<SET N <WT? .N ,PS?VERB ,P1?VERB>>
	<COND (<EQUAL? .N ,ACT?QUIT>
	       <QUIT>
	       <TELL-FAILED>
	       <AGAIN>)
	      (<EQUAL? .N ,ACT?RESTART>
	       <RESTART>
	       <TELL-FAILED>
	       <AGAIN>)
	      (<EQUAL? .N ,ACT?$VERIFY>
	       <V-$VERIFY>
	       <AGAIN>)
	      (<EQUAL? .N ,ACT?RELEASE>
	       <V-VERSION>
	       <AGAIN>)
	      (<EQUAL? .N ,ACT?RESTORE>
	       <COND (<V-RESTORE>
		      <TELL-FAILED>)>
	       <AGAIN>)>
	<PLEASE-TYPE-OR .WD1 .WD2>
	<AGAIN>>

<ROUTINE PLEASE-TYPE-OR (WD1 WD2)
	<TELL "Please type \"">
	<PRINTB .WD1>
	<TELL "\" or \"">
	<PRINTB .WD2>
	<TELL "\". ">>

;<ROUTINE READ-NUM ("AUX" N)
	<TELL ">">
	<READ ,P-INBUF ,P-LEXV>
	<COND (<0? <GETB ,P-LEXV ,P-LEXWORDS>>
	       <TELL "I beg your pardon?" CR>
	       <AGAIN>)>
	<COND (<NUMBER? ,P-LEXSTART>
	       <COND (<==? ,P-NUMBER ,MAX-VAR>
		      <RETURN ,P-NUMBER>)
		     (<L? 0 ,P-NUMBER>
		      <RETURN <MOD ,P-NUMBER ,MAX-VAR>>)>)
	      (<NOT <ZERO? <SET N <GET ,P-LEXV ,P-LEXSTART>>>>
	       <SET N <WT? .N ,PS?VERB ,P1?VERB>>
	       <COND (<EQUAL? .N ,ACT?RESTART>
		      <RESTART>
		      <TELL-FAILED>
		      <AGAIN>)
		     (<EQUAL? .N ,ACT?$VERIFY>
		      <V-$VERIFY>
		      <AGAIN>)
		     (<EQUAL? .N ,ACT?RELEASE>
		      <V-VERSION>
		      <AGAIN>)
		     (<EQUAL? .N ,ACT?RESTORE>
		      <COND (<V-RESTORE>
			     <TELL-FAILED>
			     <AGAIN>)
			    (T
			     <AGAIN>)>)>)>
	<TELL "Please type a number between 1 and " N ,MAX-VAR ". ">
	<AGAIN>>

"<GLOBAL RSEED 6969>

<ROUTINE RANDOM-PER-VAR (N)	;'lower digits w/ correction'
	<SETG RSEED <MOD <* <+ 2 ,VARIATION> <+ 2 ,RSEED>>
			 10000>>
	;<SETG RSEED <+ <+ 1 ,VARIATION> ,RSEED>>
	%<COND (<NOT <GASSIGNED? PREDGEN>>
		'<COND (<GASSIGNED? RSEED-LIST>
			<COND (<MEMQ ,RSEED ,RSEED-LIST>
			       <TELL '[Dup. seed=' N ,RSEED ']' CR>)
			      (T <SETG RSEED-LIST (,RSEED !,RSEED-LIST)>)>)
		       (T <SETG RSEED-LIST (,RSEED)>)>)
	       (T '<COND (,DEBUG <TELL '[Seed=' N ,RSEED ']' CR>)>)>
	<+ 1 <MOD ,RSEED .N>>>"

<ROUTINE RANDOM-PER-VAR (L "AUX" N)
	<SET N <+ 1 </ <* ,VARIATION .L> ,MAX-VAR>>>
	<COND (<G? .N .L> .L) (T .N)>>

<ROUTINE TAKE-YOUR-PLACES ("AUX" P N L)
	;<TELL CR "(Take your places ..." CR>
	<PUTP ,WAITER ,P?CAR ,DINER-CAR>
	<PUTP ,COOK ,P?CAR ,DINER-CAR>
	<SETG COMPARTMENT-START <PICK-ONE ,CAR-ROOMS-COMPS>>
	<COND (<SPY?> <SETG CAR-HERE <+ 1 ,CAR-START>>)>
	<TAKE-YOUR-PLACES-CAST ,EXTRA-TABLE>
	<TAKE-YOUR-PLACES-CAST ,SPY-TABLE>
	<TAKE-YOUR-PLACES-CAST ,MARKS-TABLE <> <> <>>

	<SETG BAD-SPY <GET ,SPY-TABLE <RANDOM-PER-VAR <GET ,SPY-TABLE 0>>>>
	<SETG BAD-SPY-C <GETP ,BAD-SPY ,P?CHARACTER>>
	<SETG BAD-SPY-DEFAULT-F <GETP ,BAD-SPY ,P?ACTION>>
	<COND (<NOT <SPY?>> ;<EQUAL? ,VARIATION 1 2>
	       <SETG HERE ,COMPARTMENT-START>
	       <SETG PLAYER-SEATED <GENERIC-SEAT-F 0>>
	       <MOVE ,BLOOD-SPOT ,HERE>
	       ;"<MOVE ,RACK ,HERE>
	       <MOVE ,OTHER-RACK <GETP ,HERE ,P?OTHER>>"
	       <MOVE ,BRIEFCASE ,PLAYER-SEATED>
	       <PUTP ,BRIEFCASE ,P?CAR ,CAR-HERE>
	       <PUTP ,BAD-SPY ,P?ACTION ,BAD-SPY-F>
	       <PUTP ,BAD-SPY ,P?CAR <+ 1 ,CAR-START>>
	       <MOVE ,BAD-SPY ,OTHER-ROOF>
	       ;"<MOVE ,GUN ,BAD-SPY>")
	      (T ;<EQUAL? ,VARIATION 3 4>
	       ;"<SETG EGO ,BAD-SPY>"
	       ;<SETG CAR-HERE <+ 1 ,CAR-START>>
	       <SETG HERE ,ROOF>
	       <PUTP ,PLAYER ,P?CAR ,CAR-HERE>
	       <MOVE ,BRIEFCASE ,BAD-SPY>
	       <PUTP ,BRIEFCASE ,P?CAR ,CAR-START>
	       <FCLEAR ,BRIEFCASE ,TAKEBIT>
	       <SET N 0>
	       <SET L <GET ,BRIEFCASE-TBL 0>>
	       <REPEAT ()
		 <COND (<IGRTR? N .L> <RETURN>)
		       (<NOT <ZERO? <SET P <GET ,BRIEFCASE-TBL .N>>>>
			<FCLEAR .P ,TAKEBIT>)>>
	       <ENABLE <QUEUE I-TRAVELER-TO-GRNZ <+ 9 <RANDOM 6>>>>
	       <PUTP ,BAD-SPY ,P?ACTION ,TRAVELER-F>
	       <PUTP ,BAD-SPY ,P?CAR ,CAR-START>
	       <PUTP ,BAD-SPY ,P?LDESC 35 ;"deep in thought">
	       <SET L <GETP ,COMPARTMENT-START ,P?OTHER>>
	       <MOVE ,BAD-SPY .L ;,OTHER-COMPARTMENT-1>
	       <SETG BAD-SPY-DONE-PEEKING T>
	       <MOVE ,BLOOD-SPOT .L>
	       <FCLEAR ,GUN ,NDESCBIT>
	       <FSET ,GUN ,TAKEBIT>
	       <MOVE ,GUN ,POCKET ;,PLAYER>)>
	<MOVE ,PLAYER ,HERE>
	;<SETG LAST-PLAYER-LOC ,HERE>
	<SETG LAST-CAR-HERE ,CAR-HERE>

	<SETG CONTACT <GET ,EXTRA-TABLE
			    <- <+ 1 ,CONTACT-MAX>
			       <RANDOM-PER-VAR ,CONTACT-MAX>>>>
	<SETG CONTACT-DEFAULT-F <GETP ,CONTACT ,P?ACTION>>
	<PUTP ,CONTACT ,P?ACTION ,CONTACT-F>
	<COND (<HARD?>
	       <MOVE-CONTACT>
	       <PUTP ,TICKET ,P?CAPACITY ,STATION-WIEN>
	       <PUTP ,TICKET-OTHER ,P?CAPACITY ,STATION-WIEN>
	       <SETG LATCH-TURNED <>>
	       <SETG PICKPOCKET <PICK-ONE-NOT ,SPY-TABLE ,BAD-SPY>>
	       <SETG PEEKER <PICK-ONE-NOT ,SPY-TABLE ,BAD-SPY ;,PICKPOCKET>>
	       <PUTP ,PEEKER ,P?CAR <+ 2 ,CAR-START>>
	       <MOVE ,PEEKER ,OTHER-VESTIBULE-REAR>
	       <PUT <GT-O ,PEEKER> ,GOAL-ENABLE 1>
	       <ESTABLISH-GOAL-TRAIN ,PEEKER ,VESTIBULE-FWD 1>
	       <PUTP ,PEEKER ,P?LDESC ,PEEKING-CODE>)>
	<SET-PASSES>
	;"<TELL CR 'Lights ...' CR>
	<SET N <* 15 ,VARIATION>>
	<SETG SCORE </ .N 60>>
	<SETG MOVES <MOD .N 60>>
	<SETG PRESENT-TIME <+ ,MOVES <* ,SCORE 60>>>
	<TELL CR 'Action!)' CR>">

<ROUTINE SET-PASSES ("OPTIONAL" (NUM 0) "AUX" L N P)
	<SETG PASSWORD-GIVEN <>>
	<SETG PASSWORD-GIVEN-OTHER <>>
	<SETG PASSOBJECT-GIVEN <>>
	<SETG PASSOBJECT-GIVEN-OTHER <>>
	<COND (<NOT <ZERO? .NUM>> <FSET ,SPY-LIST ,MUNGBIT>)>
	<SET L 6 ;<GET ,PASS-TABLE 0>>
	<SET P <+ .NUM ,VARIATION>
	       ;<+ 1 <MOD <- ,VARIATION 1> .L>> ;<RANDOM-PER-VAR .L>>
	<SETG PASSOBJECT <GET ,PASS-TABLE .P>>
	<SET N <+ .NUM <RANDOM-PER-VAR .L>>>
	<COND (<==? .P .N>
	       <COND (<IGRTR? N .L> <SET N 1>)>)>
	<SETG PASSWORD <GET ,PASS-TABLE .N>>>

<ROUTINE TAKE-YOUR-PLACES-CAST
	(TBL "OPTIONAL" (NEW? <>) (STA-ONLY? <>) (PEOPLE? T)
	     "AUX" P OBJ N L M X)
	<SET P <GET .TBL 0>>
	<SET M <GET ,CAR-ROOMS 0>>
	<REPEAT ()
		;<COND (<AND ;,LONG-INTRO <NOT .NEW?>> <CRLF> <CRLF>)>
		<SET OBJ <GET .TBL .P>>
		<COND (.PEOPLE? <FSET .OBJ ,LOCKED>)>	;"ticket not punched"
		<SET L <GET ,CAR-ROOMS <RANDOM ;-PER-VAR .M>>>
		<SET N <RANDOM ;-PER-VAR ,CAR-MAX>>
		<COND (<EQUAL? .N ,DINER-CAR ,FANCY-CAR>
		       <DEC N>)>
		<COND (<ZERO? .PEOPLE?> T)
		      (<AND <NOT .NEW?>
			    <EQUAL? .L ,COMPARTMENT-START>
			    <EQUAL? .N ,CAR-START>>
		       <DEC N>)
		      (<ZMEMQ .L ,CAR-ROOMS-REST>
		       <COND (<OR <FSET? .OBJ ,PLURALBIT>
				  <OCCUPIED? .L .N>>
			      <SET L <GET-REXIT-ROOM <GETPT .L ,P?OUT>>>)
			     (<==? .N ,CAR-HERE>
			      <FSET <FIND-FLAG-LG .L ,DOORBIT> ,LOCKED>)
			     (T <FCLEAR <FIND-FLAG-LG .L ,DOORBIT>,LOCKED>)>)>
		<COND (<OR <ZERO? .PEOPLE?>
			   <TAKE-YOUR-PLACE-TEST .OBJ .STA-ONLY?>>
		       <COND (<EQUAL? .N ,CAR-HERE ,DINER-CAR ,FANCY-CAR>
			      <MOVE .OBJ .L>)
			     (<SET X <GETP .L ,P?OTHER>>
			      <MOVE .OBJ .X>)>
		       <PUTP .OBJ ,P?CAR .N>)>
		<COND (<AND .NEW? .PEOPLE?>
		       <COND (<SET X <ZMEMQ .OBJ ,EXTRA-TABLE>>
			      <PUT ,EXTRA-SEEN-TABLE
				   .X
				   <- 0 <GET ,EXTRA-SEEN-TABLE .X>>>)>
		       <COND (<NOT <EQUAL? .OBJ ,BAD-SPY>>
			      <FCLEAR .OBJ ,SEENBIT>
			      <FCLEAR .OBJ ,TOUCHBIT>
			      <PUTP .OBJ ,P?LDESC 0>)>)>
		<COND (<DLESS? P 1> <RETURN>)>>>

<ROUTINE TAKE-YOUR-PLACE-TEST (OBJ STA-ONLY? "AUX" X)
	<COND (<EQUAL? .OBJ ,CONTACT> <RFALSE>)
	      (<IN-MOTION? .OBJ T> <RFALSE>)>
	<SET X <ZMEMQ <META-LOC .OBJ> ,STATION-ROOMS>>
	<COND (.STA-ONLY? .X)
	      (<NOT .X> <RTRUE>)>>

<ROUTINE OCCUPIED? (L N)
	<COND (<AND <==? .L ,GAS-CAR-RM>
		    <==? .N ,GAS-CAR>>
	       <RTRUE>)
	      (<NOT <EQUAL? .N ,CAR-HERE ,DINER-CAR ,FANCY-CAR>>
	       <SET L <GETP .L ,P?OTHER>>)>
	<FIND-FLAG-CAR .L .N ,PERSONBIT>>

<ROUTINE MOVE-CONTACT ("AUX" N)
	<SET N <+ 1 <RANDOM <- ,PLATFORM-MAX 1>>>>
	<PUTP ,CONTACT ,P?CAR .N>
	<MOVE ,CONTACT <GET ,STATION-ROOMS .N>>
	<FSET ,CONTACT ,NDESCBIT>
	<FCLEAR ,CONTACT ,TOUCHBIT>
	<PUTP ,CONTACT ,P?LDESC 10 ;"looking platform">>

<CONSTANT H-NORMAL 0>
<CONSTANT H-INVERSE 1>

<CONSTANT D-NORMAL 0>
<CONSTANT D-TABLE 1>

<ROUTINE INIT-STATUS-LINE ("OPTIONAL" (FIRST <>))
	 <COND (<ZERO? <GETB 0 18>>	;"not ZIP"
		<RTRUE>)>
	 <COND (.FIRST
		<CLEAR -1>
		<SPLIT 2>)>
	 <SCREEN 1>
	 <BUFOUT <>>
	 <INVERSE-LINE 1>
	 <HLIGHT ,H-INVERSE>
	 <COND (.FIRST
		<CURSET 1 </ <- <GETB 0 33> 10> 2>>
		<TELL D ,GAME>)
	       (T
		<CURSET 1 1>
		<TELL "You are ">
		<CURSET 1 63>
		<TELL "It is now ">)>
	 <SETG PLAYER-NOT-FACING-OLD 99>	;"to ensure USL"
	 <BUFOUT T>
	 <HLIGHT ,H-NORMAL>
	 <SCREEN 0>>

<ROUTINE INVERSE-LINE (LIN "AUX" (CNT 79))
	 <CURSET .LIN 1>
	 <HLIGHT ,H-INVERSE>
	 <PRINT-SPACES .CNT>
	 <HLIGHT ,H-NORMAL>>

<ROUTINE PRINT-SPACES (CNT)
	 <REPEAT ()
		 <COND (<DLESS? CNT 0> <RETURN>) (T <PRINTC 32>)>>>

<GLOBAL SL-BUFFER <ITABLE NONE 80>>

<ROUTINE STATUS-LINE ("AUX" LEN (X <>))
	<COND (<ZERO? <GETB 0 18>>	;"not ZIP"
	       <RTRUE>)>
	<COND (<OR <NOT <==? ,LAST-PLAYER-LOC ,HERE>>
		   <NOT <==? ,PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>>
		   <NOT <==? ,PLAYER-SEATED-OLD ,PLAYER-SEATED>>>
	       <SET X T>)>
	<COND (<AND <ZERO? .X>
		    <OR ;<NOT ,P-WON> ,CLOCK-WAIT>>
	       <RTRUE>)>
	<BUFOUT <>>
	<SCREEN 1>
	<HLIGHT ,H-INVERSE>
	<COND (.X
	       <SETG LAST-PLAYER-LOC ,HERE>
	       <SETG PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>
	       <SETG PLAYER-SEATED-OLD ,PLAYER-SEATED>
	       <DIROUT -1>
	       <DIROUT 3 ;,D-TABLE ,SL-BUFFER>
	       <TELL-LOCATION>
	       <DIROUT -3>
	       <DIROUT 1 ;,D-NORMAL>
	       <SET LEN <GET ,SL-BUFFER 0>>
	       <CURSET 1 9>
	       <TELL-LOCATION>
	       <PRINT-SPACES <- %<- 64 10> .LEN>>)>
	<CURSET 1 73>
	<TIME-PRINT ,PRESENT-TIME>
	<PRINTI ". ">
	<SCREEN 0>
	;<CURSET <- <GETB 0 32> 1> 1>	;<CURSET 23 1>
	<BUFOUT T>
	<HLIGHT ,H-NORMAL>>

<ROUTINE TELL-LOCATION ("AUX" DIR)
	<COND (<EQUAL? ,HERE ,UNCONSCIOUS>
	       <TELL "unconscious.">
	       <RTRUE>)>
	<COND (<ZERO? ,PLAYER-SEATED>	T)
	      (<L? 0 ,PLAYER-SEATED>	<TELL "sitting ">)
	      (T 			<TELL "lying ">)>
	<COND (<FSET? ,HERE ,SURFACEBIT>
	       <TELL "on">)
	      (<NOT <EQUAL? ,HERE ,BESIDE-TRACKS>>
	       <TELL "in">)>
	<TELL THE ,HERE>
	<COND (<NOT <ZERO? ,PLAYER-NOT-FACING>>
	       <TELL ", facing ">
	       <SET DIR <OPP-DIR ,PLAYER-NOT-FACING>>
	       <COND (<AND <==? .DIR ,P?EAST> ,ON-TRAIN>
		      <TELL "the right side" ;" of the train">)
		     (<AND <==? .DIR ,P?WEST> ,ON-TRAIN>
		      <TELL "the left side" ;" of the train">)
		     (T <DIR-PRINT .DIR>)>)
	      ;(<NOT <ZERO? ,PLAYER-SEATED>>
	       <TELL ", ">
	       <COND (<L? 0 ,PLAYER-SEATED>
		      <TELL "sitting on" THE ,PLAYER-SEATED>)
		     (T <TELL "lying on" THE <- 0 ,PLAYER-SEATED>>)>)>
	<TELL ".">>
