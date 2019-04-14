"PEOPLE for CHECKPOINT
Copyright (C) 1985 Infocom, Inc.  All rights reserved."

"Constants used as table offsets for each character who can have a
movement goal, including the player:"
<CONSTANT PLAYER-C 0>
<CONSTANT CONDUCTOR-C 1>
<CONSTANT WAITER-C 2>
<CONSTANT COOK-C 3>
<CONSTANT EXTRA-C 4>
<CONSTANT BOND-C 5>
<CONSTANT THIN-MAN-C 6>
<CONSTANT FAT-MAN-C 7>
<CONSTANT HUNK-C 8>
<CONSTANT PEEL-C 9>
<CONSTANT DUCHESS-C 10>
<CONSTANT NATASHA-C 11>
<CONSTANT GUARD-C 12>
<CONSTANT THUG-C 13>
<CONSTANT DEFECTOR-C 14>
<CONSTANT CHARACTER-MAX 14>
<GLOBAL STAR-C 0>

<OBJECT PLAYER
	(DESC "yourself")
	(LDESC 0)	;"for generality"
	;(LOC COMPARTMENT-1)
	(CAR 2)
	(SYNONYM ;"I" ME MYSELF)
	(ACTION PLAYER-F)
	(FLAGS NDESCBIT NARTICLEBIT TRANSBIT PERSONBIT
		LOCKED	;"implies ticket not punched")
	(CHARACTER 0)
	(SOUTH 49)	;"POCKET-CHANGE">

<GLOBAL PLAYER-NOT-FACING <>>
<GLOBAL PLAYER-NOT-FACING-OLD <>>
<GLOBAL PLAYER-SEATED <>>	"negative => lying down"
<GLOBAL PLAYER-SEATED-OLD <>>
<GLOBAL PLAYER-HIDING <>>

<ROUTINE PREVENTS-YOU? ("OPTIONAL" (L <>) (DIR <>) (PER <>))
 <COND (<ZERO? .L>	<SET L ,HERE>)>
 <COND (<ZERO? .DIR>	<SET DIR <EXIT-VERB?>>)>
 <COND (<ZERO? .PER>	<SET PER ,PLAYER>)>
 <COND (<NOT ,ON-TRAIN> <RFALSE>)
       (<AND ,TICKETS-PUNCHED?
	     <NOT ,CUSTOMS-SWEEP>>
	<RFALSE>)
       (<NOT <IN? ,CONDUCTOR .L>> <RFALSE>)
       (<NOT <EQUAL? .DIR ,P?NORTH ;,P?SOUTH>> <RFALSE>)
       (<FSET? .PER ,LOCKED> <RTRUE>)>>

<ROUTINE PLAYER-F ("OPTIONAL" (ARG <>) "AUX" (L <>))
 <COND (<NOT <==? .ARG ,M-WINNER>>
	<COND (<DOBJ? PLAYER>
	       <COND (<VERB? HELLO GOODBYE>
		      <HAR-HAR>)
		     (<VERB? EXAMINE SEARCH>
		      <PERFORM ,V?INVENTORY>
		      <RTRUE>)>)
	      (T <RFALSE>)>)>
 <COND (<AND ,KILLED-PERSON
	     <IN? ,KILLED-PERSON ,PLAYER>
	     <SET L <ANYONE-VISIBLE? ,KILLED-PERSON>>>
	<ARREST-PLAYER "homicide" .L T ,KILLED-PERSON>
	<RFATAL>)>
 ;<COND (<AND <SET L <EXIT-VERB?>>
	     <SET L <COMPASS-EQV ,HERE .L>>>
	;<SETG PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>
	<SETG PLAYER-NOT-FACING <OPP-DIR .L>>)>
 <COND (<AND <SPEAKING-VERB?>
	     <NOISY? ,HERE>>
	<SETG P-CONT <>>
	<TELL "You can't make yourself heard above the noise." CR>)
       (<PREVENTS-YOU?>
	<START-SENTENCE ,CONDUCTOR>
	<TELL " prevents you from passing him." CR>
	<RFATAL>)
       (<AND <NOT ,PLAYER-SEATED> <NOT ,PLAYER-HIDING>>
	<RFALSE>)
       (<EQUAL? ,PRSO <> ,ROOMS>
	<COND (<AND <OR <VERB? STAND> <EXIT-VERB?>>
		    <IN? ,BRIEFCASE ,PLAYER>
		    <FSET? ,BRIEFCASE ,OPENBIT>>
	       <FCLEAR ,BRIEFCASE ,OPENBIT>
	       <INSIDE-OBJ-TO ,BRIEFCASE-TBL ,BRIEFCASE 1>
	       <TELL "(You close the briefcase first.)" CR>)>
	<RFALSE>)
       (,P-WALK-DIR			<TOO-BAD-SIT-HIDE>)
       (<VERB? WALK-TO SEARCH SEARCH-FOR FIND>	<TOO-BAD-SIT-HIDE>)
       (<SPEAKING-VERB?>		<RFALSE>)
       (<GAME-VERB?>			<RFALSE>)
       (<REMOTE-VERB?>			<RFALSE>)
       (<VERB? AIM LOOK-ON NOD SHOOT SMILE>
					<RFALSE>)
       (<HELD? ,PRSO>			<RFALSE>)
       (<HELD? ,PRSO <TABLE? ,HERE>>	<RFALSE>)
       (<HELD? ,PRSO ,GLOBAL-OBJECTS>	<RFALSE>)
       (<AND <VERB? EXAMINE>
	     <NOT <==? ,P-ADVERB ,W?CAREFULLY>>>
					<RFALSE>)
       (<NOT <HELD? ,PRSO ,PLAYER-SEATED>>	<TOO-BAD-SIT-HIDE>)
       (<NOT ,PRSI>			<RFALSE>)
       (<HELD? ,PRSI>			<RFALSE>)
       (<HELD? ,PRSI ,GLOBAL-OBJECTS>	<RFALSE>)
       (<NOT <HELD? ,PRSI ,PLAYER-SEATED>>	<TOO-BAD-SIT-HIDE>)>>

<ROUTINE TOO-BAD-SIT-HIDE ()
 <COND (,PLAYER-SEATED
	<COND (<AND <VERB? LIE> <G? 0 ,PLAYER-SEATED>>
	       <ALREADY ,WINNER "lying down">)
	      (<AND <VERB? SIT> <L? 0 ,PLAYER-SEATED>>
	       <ALREADY ,WINNER "sitting down">)
	      (T
	       <SETG PLAYER-SEATED <>>
	       <TELL "(You ">
	       <COND (<AND <IN? ,BRIEFCASE ,PLAYER>
			   <FSET? ,BRIEFCASE ,OPENBIT>>
		      <TELL "close the briefcase and ">
		      <FCLEAR ,BRIEFCASE ,OPENBIT>
		      <INSIDE-OBJ-TO ,BRIEFCASE-TBL ,BRIEFCASE 1>)>
	       <TELL "stand up first.)" CR>
	       <RFALSE>)>)
       (,PLAYER-HIDING
	;<SETG P-CONT <>>
	<SETG CLOCK-WAIT T>
	<COND (<AND <VERB? HIDE-BEHIND> <ZERO? ,PRSI>>
	       <ALREADY ,WINNER "hiding">
	       ;<TELL "(You're already hiding.)" CR>)
	      (T <TELL "(You can't do that while you're hiding.)" CR>)>)>>

<OBJECT GLOBAL-CONDUCTOR
	(LOC GLOBAL-OBJECTS)
	(DESC "conductor")
	;(SYNONYM CONDUCTOR CONDUC COLLECTOR)
	(FLAGS PERSONBIT SEARCHBIT SEENBIT)
	(CHARACTER 1)
	(ACTION GLOBAL-PERSON)>

<OBJECT CONDUCTOR
	(LOC OTHER-VESTIBULE-FWD)
	(CAR 1)
	(DESC "conductor")
	(LDESC 19 ;"making his rounds")
	(ADJECTIVE TICKET)
	(SYNONYM CONDUCTOR CONDUC COLLECTOR)
	(FLAGS PERSONBIT SEARCHBIT SEENBIT)
	(CHARACTER 1)
	(ACTION CONDUCTOR-F)
	(DESCFCN CONDUCTOR-DESC)
	(NORTH 50)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"He's helpful but suspicious, and doesn't want trouble in HIS jurisdiction.")>

<ROUTINE CONDUCTOR-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,CONDUCTOR>)>>

<ROUTINE CONDUCTOR-GIVE-SHOW ()
 <COND (<VERB? GIVE>
	<RETURN ,PRSO>)
       (<VERB? SHOW>
	<RETURN ,PRSI>)>>

<ROUTINE CONDUCTOR-F ("OPTIONAL" (ARG <>) OBJ)
 <COND (<==? .ARG ,M-WINNER ;,CONDUCTOR>
	<PERSON-F ,CONDUCTOR .ARG>)
       (<PASS-OBJECT? ,MCGUFFIN>	;"? Conductor is armed?"
	<SHOW-MCGUFFIN ,CONDUCTOR>)
       (<AND <SET OBJ <CONDUCTOR-GIVE-SHOW>>
	     ;<OR <AND <VERB? GIVE> <SET OBJ ,PRSO>>
		 <AND <VERB? SHOW> <SET OBJ ,PRSI>>>
	     <OR <EQUAL? .OBJ ,PASSPORT ,BRIEFCASE>
		 <EQUAL? .OBJ ,TICKET ,TICKET-OTHER>>>
	<COND (<EQUAL? .OBJ ,PASSPORT ,BRIEFCASE>
	       <COND (,CUSTOMS-SWEEP
		      <TELL CHE ,CONDUCTOR " nods and points toward">
		      <COND (,ON-TRAIN <TELL HIM ,PLATFORM-GLOBAL>)
			    (T <TELL HIM ,CUSTOMS-AGENT>)>
		      <TELL "." CR>)>)
	      (T
	       <COND (<NOT ,ON-TRAIN> <RFALSE>)>
	       <START-SENTENCE ,CONDUCTOR>
	       <COND (<OR <AND <==? .OBJ ,TICKET>
			       <NOT <ZMEMZ ,TICKET-VIA ,TRAIN-TABLE>>
			       <NOT <ZMEMZ <GETP ,TICKET ,P?CAPACITY>
					   ,TRAIN-TABLE>>>
			  <AND <==? .OBJ ,TICKET-OTHER>
			       <NOT <ZMEMZ ,TICKET-OTHER-VIA ,TRAIN-TABLE>>
			       <NOT <ZMEMZ <GETP ,TICKET-OTHER ,P?CAPACITY>
					   ,TRAIN-TABLE>>>>
		      <ARREST-PLAYER "proper tickets">
		      <TELL " looks at" HIM .OBJ " and rushes away." CR>
		      <RTRUE>)
		     (<NOT <FSET? ,PLAYER ,LOCKED>>
		      <TELL " looks at">)
		     (T
		      <FCLEAR ,PLAYER ,LOCKED>
		      <SETG TICKET-COUNT 0>
		      <TELL " punches">)>
	       <MOVE .OBJ ,PLAYER>
	       <TELL THE .OBJ " and then gives it back to you." CR>)>)
       (T <PERSON-F ,CONDUCTOR .ARG>)>>

<GLOBAL CUSTOMS-SWEEP <>>

<OBJECT CUSTOMS-AGENT
	(LOC PLATFORM-B ;GLOBAL-OBJECTS)
	(CAR 2)
	(DESC "customs agent")
	(LDESC 31 ;"inspecting ...")
	(ADJECTIVE CUSTOMS)
	(SYNONYM AGENT INSPECTOR)
	(FLAGS PERSONBIT SEARCHBIT ;NDESCBIT)
	(CHARACTER 4)
	(ACTION CUSTOMS-AGENT-F)
	(DESCFCN CUSTOMS-AGENT-DESC)
	(NORTH 26)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"He's helpful but suspicious, and doesn't want trouble in HIS jurisdiction.")>

<ROUTINE CUSTOMS-AGENT-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,CUSTOMS-AGENT>)>>

<ROUTINE CUSTOMS-AGENT-F ("OPTIONAL" (ARG <>) "AUX" OBJ)
 <COND (<==? .ARG ,M-WINNER ;,CUSTOMS-AGENT>
	<PERSON-F ,CUSTOMS-AGENT .ARG>)
       (<VERB? PASS>
	<COND (<IN? ,CUSTOMS-AGENT ,HERE>
	       <DO-WALK ,P?NORTH>
	       <RTRUE>)>)
       (<AND <VERB? SHOW> <IOBJ? GLOBAL-MONEY>>
	<TELL CHE ,CUSTOMS-AGENT smile " approvingly." CR>)
       (<AND <SET OBJ <CONDUCTOR-GIVE-SHOW>>
	     ;<OR <AND <VERB? GIVE> <SET OBJ ,PRSO>>
		 <AND <VERB? SHOW> <SET OBJ ,PRSI>>>
	     <EQUAL? .OBJ ,PASSPORT ,BRIEFCASE ,MCGUFFIN>>
	<COND (<==? .OBJ ,PASSPORT>
	       <START-SENTENCE ,CUSTOMS-AGENT>
	       <COND (<FSET? ,PASSPORT ,LOCKED>
		      <FCLEAR ,PASSPORT ,LOCKED>
		      <TELL
" looks at you and " D ,PASSPORT ", barely suppresses a smirk, stamps it,
and then">)>
	       <MOVE ,PASSPORT ,PLAYER>
	       <TELL " gives it back to you." CR>
	       <COND (<AND <EQUAL? <LOC ,BRIEFCASE> ,HERE ,PLAYER>
			   <NOT ,BRIEFCASE-PASSED>>
		      <TELL
"Then" HE ,CUSTOMS-AGENT " notices the " D ,BRIEFCASE ", points to it
and says, \"Fleegle quidpro mushnets?\"" CR>)>
	       <RTRUE>)
	      (<==? .OBJ ,BRIEFCASE>
	       <TELL CHE ,CUSTOMS-AGENT>
	       <COND (,BRIEFCASE-PASSED
		      <TELL " gives it back to you." CR>)
		     (<NOT <FSET? ,BRIEFCASE ,OPENBIT>>
		      <TELL " refuses it, making an \"open it\" gesture." CR>)
		     (<IN? ,MCGUFFIN ,BRIEFCASE>
		      <CONFISCATE-MCGUFFIN>)
		     (T
		      <SETG BRIEFCASE-PASSED T>
		      <TELL " looks in it and then gives it back to you."CR>)>
	       <RTRUE>)
	      (<==? .OBJ ,MCGUFFIN>
	       <TELL CHE ,CUSTOMS-AGENT>
	       <CONFISCATE-MCGUFFIN>)>)
       (T <PERSON-F ,CUSTOMS-AGENT .ARG>)>>

<ROUTINE CONFISCATE-MCGUFFIN ()
	<TELL
" examines" HIM ,MCGUFFIN " for a moment, realizes its import, confiscates
it, and arrests you!" CR>
	<FINISH>>

<OBJECT GLOBAL-WAITER
	(LOC GLOBAL-OBJECTS)
	(DESC "waiter")
	;(SYNONYM WAITER)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 2)
	(ACTION GLOBAL-PERSON)>

<OBJECT WAITER
	(LOC PANTRY)
	(CAR 1)
	(DESC "waiter")
	(LDESC 26 ;"waiting")
	(SYNONYM WAITER)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 2)
	(ACTION WAITER-F)
	(DESCFCN WAITER-DESC)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"His bushy black moustache and neatly combed hair go perfectly with his
black formal jacket and bow tie, but his floor-length apron has seen
better days and a few spills already on this trip.")>

<ROUTINE WAITER-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,WAITER>)>>

<ROUTINE WAITER-F ("OPTIONAL" (ARG <>))
 <COND (<AND <EQUAL? ,HERE ,PANTRY>
	     <INVASION? ,WAITER>>
	<RTRUE>)
       (<==? .ARG ,M-WINNER ;,WAITER>
	<COND (<BRING-GIVE> <RTRUE>)
	      (T <PERSON-F ,WAITER .ARG>)>)
       (<VERB? THANKS GOODBYE>
	<ESTABLISH-GOAL-TRAIN ,WAITER ,PANTRY ,DINER-CAR>
	<RFALSE>)
       (T <PERSON-F ,WAITER .ARG>)>>

<ROUTINE BRING-GIVE ()
	<COND (<AND <IOBJ? PLAYER> <VERB? GIVE BRING>>
	       ;<SETG L-WINNER ,WINNER>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?BUY ,PRSO>
	       <RTRUE>)
	      (<AND <DOBJ? PLAYER> <VERB? SGIVE SBRING>>
	       ;<SETG L-WINNER ,WINNER>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?BUY ,PRSI>
	       <RTRUE>)>>

<OBJECT TOWEL-WAITER
	(DESC "waiter's towel")
	(ADJECTIVE WAITER)
	(SYNONYM TOWEL)
	(CAR 3)
	(SIZE 20)
	(FLAGS NDESCBIT)
	(LOC WAITER)>

<OBJECT GLOBAL-COOK
	(LOC GLOBAL-OBJECTS)
	(DESC "cook")
	;(SYNONYM COOK)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 3)
	(ACTION GLOBAL-PERSON)>

<OBJECT COOK
	(LOC GALLEY)
	(CAR 1)
	(DESC "cook")
	(LDESC 27 ;"cooking")
	(SYNONYM COOK)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 3)
	(ACTION COOK-F)
	(DESCFCN COOK-DESC)
	(SIZE 99)
	(NORTH 10)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE COOK-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,COOK>)>>

<ROUTINE COOK-F ("OPTIONAL" (ARG <>))
 <COND (<AND <EQUAL? ,HERE ,GALLEY>
	     <INVASION? ,COOK>>
	<RTRUE>)
       (<==? .ARG ,M-WINNER ;,COOK> <PERSON-F ,COOK .ARG>)
       (<VERB? EXAMINE>
	<TELL "He's dressed all in white, from a "
	      <COND (<IN? ,HAT-COOK ,COOK> "hat fashioned out of a napkin")
		    (T "torn T-shirt")>
	      " to his
well-worn sneakers. You can tell from the size of his gut that he likes
his own cooking." CR>
	<CARRY-CHECK ,COOK>
	<RTRUE>)
       (T <PERSON-F ,COOK .ARG>)>>       

<OBJECT HAT-COOK
	(DESC ;"cook's " "hat")
	(ADJECTIVE COOK\'S)
	(SYNONYM HAT)
	(CAR 3)
	(SIZE 20)
	(FLAGS NDESCBIT ;TRYTAKEBIT WEARBIT)
	(LOC COOK)
	(ACTION HAT-COOK-F)>

<ROUTINE HAT-COOK-F ()
 <COND (<AND <VERB? ASK-FOR TAKE> <IN? ,HAT-COOK ,COOK>>
	<COND (<NOT <BRIBED? ,COOK>>
	       <TELL CTHE ,COOK " won't give you his hat yet." CR>)
	      (T
	       <FSET ,HAT-COOK ,TAKEBIT>
	       ;<FCLEAR ,HAT-COOK ,TRYTAKEBIT>
	       <RFALSE>)>)>>

<ROUTINE BRIBED? (PER "AUX" N)
	<COND (<EQUAL? .PER ,BAD-SPY>
	       <RFALSE>)
	      (<ZERO? <SET N <GETP .PER ,P?NORTH>>>
	       <RFALSE>)
	      (<NOT <G? .N <GETP .PER ,P?SOUTH>>>
	       <RTRUE>)>>

<OBJECT CLERK
	(LOC TICKET-AREA)
	(CAR 0)	;"?"
	(DESC "clerk")
	(LDESC 6 ;"reading a book")
	(SYNONYM CLERK MAN)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 4)
	(ACTION CLERK-F)
	(DESCFCN CLERK-DESC)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"He has the uniform jacket of the Frotzian Railway, and a tie worn
loosely with an open collar, but blue jeans below. It seems a sensible
outfit for both selling tickets and hauling luggage.")>

<ROUTINE CLERK-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,CLERK>)>>

<ROUTINE CLERK-F ("OPTIONAL" (ARG <>) N)
 <COND (<==? .ARG ,M-WINNER ;,CLERK>
	<PERSON-F ,CLERK .ARG>)
       (<AND <VERB? ASK-ABOUT>
	     <IN? ,CLERK ,TICKET-AREA>
	     <ZMEMQ ,PRSI ,STATIONS>
	     <SET N <GETP ,PRSI ,P?NORTH>>>
	<TELL "\"Lizlong frmzi ">
	<PRINTC ,CURRENCY-SYMBOL>
	<TELL N .N ".\"" CR>)
       (T <PERSON-F ,CLERK .ARG>)>>

<OBJECT GLOBAL-BOND
	(LOC GLOBAL-OBJECTS)
	(DESC "stranger")
	(FLAGS PERSONBIT)
	(CHARACTER 5)
	(ACTION GLOBAL-PERSON)>

<OBJECT BOND
	(LOC HALL-5)
	(CAR 2)
	(DESC "stranger")
	(LDESC 28 ;"hurrying away")
	(SYNONYM SPY STRANGER MAN)
	(FLAGS PERSONBIT SEARCHBIT SEENBIT TOUCHBIT)
	(CHARACTER 5)
	(SIZE 99)
	(ACTION BOND-F)
	(DESCFCN BOND-DESC)>

<OBJECT GLOBAL-BOND-OTHER
	(LOC GLOBAL-OBJECTS)
	(DESC "other spy")
	(FLAGS PERSONBIT)
	(CHARACTER 5)
	(ACTION GLOBAL-PERSON)>

<OBJECT BOND-OTHER
	(CAR 2)
	(DESC "other spy")
	(LDESC 33)
	(ADJECTIVE OTHER)
	(SYNONYM SPY STRANGER MAN)
	(FLAGS PERSONBIT SEARCHBIT SEENBIT)
	(CHARACTER 5)
	(SIZE 99)
	(ACTION BOND-OTHER-F)
	(DESCFCN BOND-OTHER-DESC)>

<ROUTINE BOND-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,BOND>)>>

<ROUTINE BOND-OTHER-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,BOND-OTHER>)>>

<ROUTINE BOND-F ("OPTIONAL" (ARG <>)) <PERSON-F ,BOND .ARG>>

<ROUTINE BOND-OTHER-F ("OPTIONAL" (ARG <>))
 <COND (<==? .ARG ,M-WINNER>
	<PERSON-F ,BOND-OTHER .ARG>)
       (<AND <VERB? SHOW> <DOBJ? BOND-OTHER> <IOBJ? GUN>>
	<SETG SUPPRESS-INTERRUPT T>
	<TELL
CHE ,BOND-OTHER " bobs and weaves, trying to avoid your aim." CR>)
       (<VERB? ATTACK KILL MOVE-DIR MUNG PUSH SHOOT SLAP>
	<SETG SUPPRESS-INTERRUPT T>
	<COND (<PROB 33>
	       <COND (<OR <VERB? SHOOT> <IOBJ? GUN>>
		      <COND (<IN? ,GUN ,POCKET>
			     <MOVE ,GUN ,PLAYER>)>
		      <TELL "Your shot goes wild. ">)
		     (T <TELL "You go for him, but he dodges. ">)>
	       <TELL CHE ,BOND-OTHER " hesitates, ">
	       <COND (<PROB 50>
		      <TELL "then lunges at you!" CR>)
		     (T <TELL "preparing his next move." CR>)>)
	      (<AND <PROB 50> <ZERO? ,PLAYER-SEATED>>
	       <TELL
CHE ,BOND-OTHER " dodges away. A sudden lurch knocks you off balance, and
your last sight is the ground speeding up to meet you." CR>
	       <FINISH>)
	      (T
	       <MOVE ,BOND-OTHER ,LIMBO-FWD>
	       <QUEUE I-BOND-OTHER 0>
	       <SETG SUPPRESS-INTERRUPT <>>
	       <COND (<OR <VERB? SHOOT> <IOBJ? GUN>>
		      <COND (<IN? ,GUN ,POCKET>
			     <MOVE ,GUN ,PLAYER>)>
		      <TELL
"Your shot almost misses, but it wings him and he ">)
		     (T <TELL
"You lunge at him and almost miss, but he loses footing and ">)>
	       <TELL
"falls off the edge of the roof! The train quickly leaves his body behind."
CR>)>)
       (T <PERSON-F ,BOND-OTHER .ARG>)>>

<OBJECT GLOBAL-THIN-MAN
	(LOC GLOBAL-OBJECTS)
	(DESC "thin man")
	;(ADJECTIVE THIN TALL SILENT)
	;(SYNONYM MAN)
	;(GENERIC GENERIC-MAN-F)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 6)
	(ACTION GLOBAL-PERSON)>

<OBJECT THIN-MAN
	(CAR 2)
	(DESC "thin man")
	(LDESC 0)
	(ADJECTIVE THIN TALL SILENT)
	(SYNONYM MAN)
	;(GENERIC GENERIC-MAN-F)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 6)
	(ACTION THIN-MAN-F)
	(DESCFCN THIN-MAN-DESC)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"For this guy, the word \"thin\" was invented: thin hair, narrow eyes,
thin lips, pale bluish skin. If his expression weren't so pleasant, he'd
look really menacing.")>

<ROUTINE THIN-MAN-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,THIN-MAN>)>>

<ROUTINE THIN-MAN-F ("OPTIONAL" (ARG <>)) <PERSON-F ,THIN-MAN .ARG>>

<OBJECT GLOBAL-FAT-MAN
	(LOC GLOBAL-OBJECTS)
	(DESC "fat man")
	;(ADJECTIVE FAT JOVIAL SMOOTH)
	;(SYNONYM MAN)
	;(GENERIC GENERIC-MAN-F)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 7)
	(ACTION GLOBAL-PERSON)>

<OBJECT FAT-MAN
	(CAR 2)
	(DESC "fat man")
	(LDESC 0)
	(ADJECTIVE FAT JOVIAL SMOOTH)
	(SYNONYM MAN)
	;(GENERIC GENERIC-MAN-F)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 7)
	(ACTION FAT-MAN-F)
	(DESCFCN FAT-MAN-DESC)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"For this guy, the word \"fat\" was invented: oily hair, puffy eyes,
fat lips, pudgy pink skin. If his expression weren't so menacing, he'd
look rather pleasant.")>

<ROUTINE FAT-MAN-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,FAT-MAN>)>>

<ROUTINE FAT-MAN-F ("OPTIONAL" (ARG <>)) <PERSON-F ,FAT-MAN .ARG>>

<OBJECT GLOBAL-HUNK
	(LOC GLOBAL-OBJECTS)
	(DESC "attractive man")
	;(ADJECTIVE ATTRACTIVE HANDSOME PRETTY)
	;(SYNONYM MAN)
	;(GENERIC GENERIC-MAN-F)
	(FLAGS PERSONBIT SEARCHBIT VOWELBIT)
	(CHARACTER 8)
	(ACTION GLOBAL-PERSON)>

<OBJECT HUNK
	(CAR 2)
	(DESC "attractive man")
	(LDESC 0)
	(ADJECTIVE ATTRACTIVE HANDSOME PRETTY)
	(SYNONYM MAN)
	;(GENERIC GENERIC-MAN-F)
	(FLAGS PERSONBIT SEARCHBIT VOWELBIT)
	(CHARACTER 8)
	(ACTION HUNK-F)
	(DESCFCN HUNK-DESC)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"He looks almost too good for a nowhere country like this: sparkling
eyes, good bone structure, clear skin, tall and smooth. Of course, it's
hard to tell whether or not he can think in complete sentences.")>

<ROUTINE HUNK-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,HUNK>)>>

<ROUTINE HUNK-F ("OPTIONAL" (ARG <>)) <PERSON-F ,HUNK .ARG>>

<OBJECT GLOBAL-PEEL
	(LOC GLOBAL-OBJECTS)
	(DESC "attractive woman")
	;(ADJECTIVE ATTRACTIVE HANDSOME PRETTY)
	;(SYNONYM WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT VOWELBIT FEMALE)
	(CHARACTER 9)
	(ACTION GLOBAL-PERSON)>

<OBJECT PEEL
	(CAR 2)
	(DESC "attractive woman")
	(LDESC 0)
	(ADJECTIVE ATTRACTIVE HANDSOME PRETTY)
	(SYNONYM WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT VOWELBIT FEMALE)
	(CHARACTER 9)
	(ACTION PEEL-F)
	(DESCFCN PEEL-DESC)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"She looks almost too good for a nowhere country like this: sparkling
eyes, good bone structure, clear skin, tall and smooth. Of course, it's
hard to tell whether or not she can think in complete sentences.")>

<ROUTINE PEEL-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,PEEL>)>>

<ROUTINE PEEL-F ("OPTIONAL" (ARG <>)) <PERSON-F ,PEEL .ARG>>

<OBJECT GLOBAL-DUCHESS
	(LOC GLOBAL-OBJECTS)
	(DESC "regal woman")
	;(ADJECTIVE REGAL)
	;(SYNONYM WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT FEMALE)
	(CHARACTER 10)
	(ACTION GLOBAL-PERSON)>

<OBJECT DUCHESS
	(CAR 2)
	(DESC "regal woman")
	(LDESC 0)
	(ADJECTIVE REGAL)
	(SYNONYM WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT FEMALE)
	(CHARACTER 10)
	(ACTION DUCHESS-F)
	(DESCFCN DUCHESS-DESC)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"She was clearly beautiful as a young woman. Now her heavy make-up and
cologne, her fur piece and black net veil make her beauty a matter of
personal preference.")>

<ROUTINE DUCHESS-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,DUCHESS>)>>

<ROUTINE DUCHESS-F ("OPTIONAL" (ARG <>)) <PERSON-F ,DUCHESS .ARG>>

<OBJECT GLOBAL-NATASHA
	(LOC GLOBAL-OBJECTS)
	(DESC "thin woman")
	;(ADJECTIVE THIN)
	;(SYNONYM WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT FEMALE)
	(CHARACTER 11)
	(ACTION GLOBAL-PERSON)>

<OBJECT NATASHA
	(CAR 2)
	(DESC "thin woman")
	(LDESC 0)
	(ADJECTIVE THIN)
	(SYNONYM WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT FEMALE)
	(CHARACTER 11)
	(ACTION NATASHA-F)
	(DESCFCN NATASHA-DESC)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"For this gal, the word \"thin\" was invented: thin hair, narrow eyes,
thin lips, pale bluish skin. If her expression weren't so pleasant,
she'd look really menacing.")>

<ROUTINE NATASHA-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,NATASHA>)>>

<ROUTINE NATASHA-F ("OPTIONAL" (ARG <>)) <PERSON-F ,NATASHA .ARG>>

<OBJECT GLOBAL-GUARD
	(LOC GLOBAL-OBJECTS)
	(DESC "guard")
	;(SYNONYM GUARD WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT FEMALE)
	(CHARACTER 12)
	(ACTION GLOBAL-PERSON)>

<OBJECT GUARD
	(LOC PLATFORM-A)
	(CAR 2)
	(DESC "guard")
	(LDESC 0)
	(ADJECTIVE PLATFORM)
	(SYNONYM GUARD WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT FEMALE)
	(CHARACTER 12)
	(ACTION GUARD-F)
	(DESCFCN GUARD-DESC)
	(NORTH 50)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"She wears a military-style uniform proudly, even though it fits her
poorly. She seems to be watching for suspicious activities, such as
people looking at her or at other people too much.")>

<ROUTINE GUARD-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,GUARD>)>>

<ROUTINE GUARD-F ("OPTIONAL" (ARG <>) "AUX" OBJ)
 <COND (<==? .ARG ,M-WINNER ;,GUARD>
	<PERSON-F ,GUARD .ARG>)
       (<PASS-OBJECT? ,MCGUFFIN>
	<SHOW-MCGUFFIN ,GUARD>)
       (<AND <SET OBJ <CONDUCTOR-GIVE-SHOW>>
	     ;<OR <AND <VERB? GIVE> <SET OBJ ,PRSO>>
		 <AND <VERB? SHOW> <SET OBJ ,PRSI>>>
	     <==? .OBJ ,PASSPORT>>
	<SETG GUARD-SAW-PASSPORT T>
	<SETG GUARD-SUSPICION 0>
	<START-SENTENCE ,GUARD>
	<MOVE ,PASSPORT ,PLAYER>
	<TELL
" looks at you and " D ,PASSPORT ", barely suppresses a smirk,
then gives it back to you." CR>
	<RTRUE>)
       (T <PERSON-F ,GUARD .ARG>)>>

<GLOBAL GUARD-SUSPICION 0>

<OBJECT THUG
	;(LOC HALL-3-FANCY)
	(CAR 2)
	(DESC "large man")
	(LDESC 0)
	(ADJECTIVE LARGE)
	(SYNONYM THUG GORILLA MAN)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 13)
	(ACTION THUG-F)
	(DESCFCN THUG-DESC)
	(NORTH 99)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"He seems almost too big to fit into normal clothes, yet his clothes are
impeccably tailored and he wears them perfectly.")>

<ROUTINE THUG-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,THUG>)>>

<ROUTINE THUG-F ("OPTIONAL" (ARG <>) "AUX" OBJ)
 <COND ;(<==? .ARG ,M-WINNER ;,THUG>
	<PERSON-F ,THUG .ARG>)
       (T <PERSON-F ,THUG .ARG>)>>

<OBJECT DEFECTOR
	(LOC SUITE-3)
	(CAR 2)
	(DESC "small man")
	(LDESC 0)
	(ADJECTIVE SMALL)
	(SYNONYM DEFECTOR MAN)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 14)
	(ACTION DEFECTOR-F)
	(DESCFCN DEFECTOR-DESC)
	(NORTH 99)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"His small size makes him seem mostly harmless, yet there is something
about the intensity of his glances that makes you uneasy.")>

<ROUTINE DEFECTOR-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,DEFECTOR>)>>

<ROUTINE DEFECTOR-F ("OPTIONAL" (ARG <>) "AUX" OBJ)
 <COND ;(<==? .ARG ,M-WINNER ;,DEFECTOR>
	<PERSON-F ,DEFECTOR .ARG>)
       (T <PERSON-F ,DEFECTOR .ARG>)>>

<OBJECT WAITRESS
	(LOC CAFE)
	(CAR 0)	;"?"
	(DESC "waitress")
	(LDESC 26 ;"waiting")
	(SYNONYM WAITRESS)
	(FLAGS PERSONBIT SEARCHBIT FEMALE SEENBIT)
	;(CHARACTER 6)
	(ACTION WAITRESS-F)
	(DESCFCN WAITRESS-DESC)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far"
	(SIZE 99)
	(TEXT
"Her wad of gum could choke a yak. In fact she's the only one here with
anything decent to chew on.")>

<ROUTINE WAITRESS-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,WAITRESS>)>>

<ROUTINE WAITRESS-F ("OPTIONAL" (ARG <>))
 <COND (<==? .ARG ,M-WINNER ;,WAITRESS>
	<COND (<BRING-GIVE> <RTRUE>)
	      (T <PERSON-F ,WAITRESS .ARG>)>)
       (T <PERSON-F ,WAITRESS .ARG>)>>

<OBJECT OFFICER
	(LOC SIDEWALK)
	;(CAR 2)
	(DESC "police officer")
	(LDESC 1)
	(ADJECTIVE POLICE)
	(SYNONYM OFFICER MAN)
	(FLAGS PERSONBIT SEARCHBIT NDESCBIT)
	(CHARACTER 4)
	(ACTION OFFICER-F)
	(DESCFCN OFFICER-DESC)
	(SIZE 99)
	(NORTH 99)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE OFFICER-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC>
	       <FCLEAR ,OFFICER ,NDESCBIT>
	       <DESCRIBE-PERSON ,OFFICER>)>>

<ROUTINE OFFICER-F ("OPTIONAL" (ARG <>))
 <FCLEAR ,OFFICER ,NDESCBIT>
 <COND (<==? .ARG ,M-WINNER ;,OFFICER>
	<PERSON-F ,OFFICER .ARG>)
       (<PASS-OBJECT? ,MCGUFFIN>
	<SHOW-MCGUFFIN ,OFFICER>)
       (T <PERSON-F ,OFFICER .ARG>)>>

<OBJECT YOUNG-MAN
	;(LOC HALL-1)
	(CAR 1)
	(DESC "young man")
	(LDESC 0)
	(ADJECTIVE YOUNG)
	(SYNONYM MAN)
	;(GENERIC GENERIC-MAN-F)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 4)
	(ACTION YOUNG-MAN-F)
	(DESCFCN YOUNG-MAN-DESC)
	(SIZE 99)
	(NORTH 10)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE YOUNG-MAN-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,YOUNG-MAN>)>>

<ROUTINE YOUNG-MAN-F ("OPTIONAL" (ARG <>)) <PERSON-F ,YOUNG-MAN .ARG>>

<OBJECT YOUNG-WOMAN
	;(LOC HALL-1)
	(CAR 1)
	(DESC "young woman")
	(LDESC 0)
	(ADJECTIVE YOUNG)
	(SYNONYM WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT FEMALE)
	(CHARACTER 4)
	(ACTION YOUNG-WOMAN-F)
	(DESCFCN YOUNG-WOMAN-DESC)
	(SIZE 99)
	(NORTH 10)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE YOUNG-WOMAN-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,YOUNG-WOMAN>)>>

<ROUTINE YOUNG-WOMAN-F ("OPTIONAL" (ARG <>)) <PERSON-F ,YOUNG-WOMAN .ARG>>

<OBJECT BOY
	;(LOC HALL-1)
	(CAR 1)
	(DESC "boy")
	(LDESC 0)
	(SYNONYM BOY)
	(FLAGS PERSONBIT SEARCHBIT)
	(CHARACTER 4)
	(ACTION BOY-F)
	(DESCFCN BOY-DESC)
	(SIZE 99)
	(NORTH 10)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE BOY-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,BOY>)>>

<ROUTINE BOY-F ("OPTIONAL" (ARG <>)) <PERSON-F ,BOY .ARG>>

<OBJECT GIRL
	;(LOC HALL-1)
	(CAR 1)
	(DESC "girl")
	(LDESC 0)
	(SYNONYM GIRL)
	(FLAGS PERSONBIT SEARCHBIT FEMALE)
	(CHARACTER 4)
	(ACTION GIRL-F)
	(DESCFCN GIRL-DESC)
	(SIZE 99)
	(NORTH 10)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE GIRL-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,GIRL>)>>

<ROUTINE GIRL-F ("OPTIONAL" (ARG <>)) <PERSON-F ,GIRL .ARG>>

<OBJECT OLD-MAN
	;(LOC HALL-1)
	(CAR 1)
	(DESC "old man")
	(LDESC 0)
	(ADJECTIVE OLD)
	(SYNONYM MAN)
	;(GENERIC GENERIC-MAN-F)
	(FLAGS PERSONBIT SEARCHBIT VOWELBIT)
	(CHARACTER 4)
	(ACTION OLD-MAN-F)
	(DESCFCN OLD-MAN-DESC)
	(SIZE 99)
	(NORTH 10)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE OLD-MAN-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,OLD-MAN>)>>

<ROUTINE OLD-MAN-F ("OPTIONAL" (ARG <>)) <PERSON-F ,OLD-MAN .ARG>>

<OBJECT OLD-WOMAN
	;(LOC HALL-1)
	(CAR 1)
	(DESC "old woman")
	(LDESC 0)
	(ADJECTIVE OLD)
	(SYNONYM WOMAN)
	;(GENERIC GENERIC-WOMAN-F)
	(FLAGS PERSONBIT SEARCHBIT VOWELBIT FEMALE)
	(CHARACTER 4)
	(ACTION OLD-WOMAN-F)
	(DESCFCN OLD-WOMAN-DESC)
	(SIZE 99)
	(NORTH 10)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE OLD-WOMAN-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,OLD-WOMAN>)>>

<ROUTINE OLD-WOMAN-F ("OPTIONAL" (ARG <>)) <PERSON-F ,OLD-WOMAN .ARG>>

<OBJECT YOUNG-COUPLE
	(CAR 1)
	(DESC "young couple")
	(LDESC 0)
	(ADJECTIVE YOUNG)
	(SYNONYM COUPLE ;"MAN WOMAN")
	;(GENERIC GENERIC-COUPLE-F)
	(FLAGS PERSONBIT SEARCHBIT PLURALBIT)
	(CHARACTER 4)
	(ACTION YOUNG-COUPLE-F)
	(DESCFCN YOUNG-COUPLE-DESC)
	(SIZE 199)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE YOUNG-COUPLE-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,YOUNG-COUPLE>)>>

<ROUTINE YOUNG-COUPLE-F ("OPTIONAL" (ARG <>)) <PERSON-F ,YOUNG-COUPLE .ARG>>

<OBJECT MIDDLE-COUPLE
	(CAR 1)
	(DESC "middle-aged couple")
	(LDESC 0)
	(ADJECTIVE MIDDLE AGED MIDDLE-AGED)
	(SYNONYM COUPLE ;"MAN WOMAN")
	;(GENERIC GENERIC-COUPLE-F)
	(FLAGS PERSONBIT SEARCHBIT PLURALBIT)
	(CHARACTER 4)
	(ACTION MIDDLE-COUPLE-F)
	(DESCFCN MIDDLE-COUPLE-DESC)
	(SIZE 199)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE MIDDLE-COUPLE-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,MIDDLE-COUPLE>)>>

<ROUTINE MIDDLE-COUPLE-F ("OPTIONAL" (ARG <>)) <PERSON-F ,MIDDLE-COUPLE .ARG>>

<OBJECT OLD-COUPLE
	(CAR 1)
	(DESC "old couple")
	(LDESC 0)
	(ADJECTIVE OLD)
	(SYNONYM COUPLE ;"MAN WOMAN")
	;(GENERIC GENERIC-COUPLE-F)
	(FLAGS PERSONBIT SEARCHBIT VOWELBIT PLURALBIT)
	(CHARACTER 4)
	(ACTION OLD-COUPLE-F)
	(DESCFCN OLD-COUPLE-DESC)
	(SIZE 199)
	(NORTH 20)	;"amount needed to bribe"
	(SOUTH 0)	;"amount given so far">

<ROUTINE OLD-COUPLE-DESC (ARG)
	<COND (<==? .ARG ,M-OBJDESC> <DESCRIBE-PERSON ,OLD-COUPLE>)>>

<ROUTINE OLD-COUPLE-F ("OPTIONAL" (ARG <>)) <PERSON-F ,OLD-COUPLE .ARG>>

<ROUTINE ELIMINATE (TBL CNT N)
	<COND (<NOT <L? .CNT .N>> <RFALSE>)>
	<REPEAT ()
		<PUT .TBL .CNT <GET .TBL <+ 1 .CNT>>>
		<COND (<IGRTR? CNT .N> <RETURN>)>>>

<GLOBAL CELEBS
	<LTABLE	0
		"Mikel Jaxon"	"Ronald Raygun"
		"Jhon Lenin"	"Magi Thacher"
		"Duglas Adamz"	"Stevn Apple">>

<ROUTINE MONEY? ()
 <COND (<DOBJ? DOLLARS> <RETURN ,P-NUMBER>)
       (<DOBJ? INTNUM>
	<COND (,P-DOLLAR-FLAG <RETURN ,P-AMOUNT>)>)>>

<ROUTINE PERSON-F (PER ARG "AUX" OBJ X Y Z L C N)
 <SET L <LOC .PER>>
 <SET C <GETP .PER ,P?CHARACTER>>
 <COND (<IN? .PER ,GLOBAL-OBJECTS>
	<RETURN <GLOBAL-PERSON .PER>>)
       (<AND <NOT <==? ,HERE <META-LOC .PER>>>
	     <NOT <==? ,EXTRA-C .C>>>
	<SET PER <GET ,GLOBAL-CHARACTER-TABLE .C>>)>
 <COND (<==? .ARG ,M-WINNER ;.PER>
	<COND (<NOT <GRAB-ATTENTION .PER>> <RTRUE>)
	      (<SET X <COM-CHECK .PER>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T
	       <PRODUCE-SOMETHING .PER>
	       <RTRUE ;RFATAL>)>)
       (<VERB? ALARM>
	<COND (<UNSNOOZE .PER>
	       <TELL CHE .PER is " startled to see you so close!" CR>)>)
       (<VERB? GIVE>
	<COND (<AND <EQUAL? ,PRSI .PER> <HELD? ,PRSO>>
	       <COND (<NOT <GRAB-ATTENTION .PER>> <RTRUE>)>
	       <SET X 0>
	       <SET Y <GETP .PER ,P?NORTH>>
	       <SET Z <GETP .PER ,P?SOUTH>>
	       <COND (<SET N <MONEY?>>
		      ;<OR <AND <DOBJ? DOLLARS>
			       <SET N ,P-NUMBER>>
			  <AND ,P-DOLLAR-FLAG
			       <DOBJ? INTNUM>
			       <SET N ,P-AMOUNT>>>
		      <SET X <+ .N .Z>>
		      <PUTP .PER ,P?SOUTH .X>
		      <PUTP ,PLAYER ,P?SOUTH <- <GETP ,PLAYER ,P?SOUTH> .N>>)
		     (T
		      <COND (<EQUAL? ,PRSO ,MCGUFFIN>
			     <FCLEAR ,PRSO ,TAKEBIT>)>
		      <MOVE ,PRSO .PER>)>
	       <TELL CHE .PER accept " your gift and" V .PER smile C !\ >
	       <COND (<G? .Y <+ .X .X>>	<TELL "briefly." CR>)
		     (<G? .Y .X>
		      <COND (<ZERO? .Z>	<TELL "hopefully." CR>)
			    (T		<TELL "longer." CR>)>)
		     (T			<TELL "broadly." CR>)>)>)
       (<VERB? LISTEN>
	<COND (<EQUAL? <SET X <GETP .PER ,P?LDESC>> 8>
	       <PRODUCE-GIBBERISH>
	       <RTRUE>)>)
       (<VERB? MUNG SLAP>
	<COND (<AND <ZMEMQ .PER ,SPY-TABLE>
		    <ZERO? ,MUNGED-PERSON>>
	       <COND (<NOT <GRAB-ATTENTION .PER>> <RTRUE>)>
	       <COND (<PROB 33>
		      <FSET .PER ,MUNGBIT>
		      <SETG MUNGED-PERSON .PER>
		      <SETG MUNGED-ENABLE <GET <GT-O .PER> ,GOAL-ENABLE>>
		      <ENABLE <QUEUE I-COME-TO <+ 9 <RANDOM 6>>>>
		      <PUTP .PER ,P?LDESC 34>
		      <IMMOBILIZE .PER>
		      <COND (<SET X <ANYONE-VISIBLE? .PER>>
			     <ARREST-PLAYER "battery" .X T .PER>)>
		      <RTRUE>)>
	       <TELL CHE .PER block " your thrust and">
	       <COND (<PROB 50>
		      <TELL V .PER deliver " a chop to your ">
		      <COND (<PROB 50> <TELL "nose." CR>)
			    (T <TELL "breadbasket." CR>)>)
		     (T
		      <TELL V .PER knock " you unconscious.">
		      <SET X <GENERIC-REST-ROOM-F 0>>
		      <MOVE .PER .X>
		      <COND (<SET Y <FIND-FLAG-LG .X ,DOORBIT>>
			     <FSET .Y ,LOCKED>)>
		      <UNCONSCIOUS-FCN ;<+ 9 <RANDOM 6>>>
		      <RTRUE>)>)>)
       (<VERB? KILL SHOOT>
	<COND (<AND <ZMEMQ .PER ,SPY-TABLE>
		    <IOBJ? GUN KNIFE>
		    <FSET? .PER ,PERSONBIT>
		    <ZERO? ,KILLED-PERSON>>
	       <FSET ;FCLEAR .PER ,LOCKED>
	       <SETG KILLED-PERSON .PER>
	       <COND (<EQUAL? ,MUNGED-PERSON .PER>
		      <SETG MUNGED-PERSON <>>
		      <QUEUE I-COME-TO 0>)>
	       <PUTP .PER ,P?LDESC 36>
	       <IMMOBILIZE .PER>
	       <COND (<SET X <ANYONE-VISIBLE? .PER>>
		      <ARREST-PLAYER "homicide" .X T .PER>)>
	       <FCLEAR .PER ,PERSONBIT>	;"This is last for pronouns."
	       <RTRUE>)>)
       (<VERB? SEARCH SEARCH-FOR>
	<COND (<AND <==? .PER ,PRSO>
		    <FSET? .PER ,PERSONBIT>
		    <NOT <FSET? .PER ,MUNGBIT>>>
	       <TELL CHE .PER push " you away and" V .PER mutter ", ">
	       <PRODUCE-GIBBERISH>
	       <RTRUE>)>)
       (<VERB? SHOW>
	<COND (<==? .PER ,PRSO>
	       <COND (<NOT <GRAB-ATTENTION .PER>> <RTRUE>)
		     (<IOBJ? GUN>
		      <COND (<OR <EQUAL? .PER ,CONDUCTOR ,GUARD ,WAITER>
				 ;<EQUAL? .PER ,CUSTOMS-AGENT>>
			     <ARREST-PLAYER "carrying weapons" .PER T ,GUN>
			     <RTRUE>)
			    (<SET X <ANYONE-VISIBLE? .PER>>
			     <ARREST-PLAYER "carrying weapons" .X T ,GUN>)>
		      <ESTABLISH-GOAL .PER <GENERIC-REST-ROOM-F 0>>
		      <COND (<==? .PER ,BAD-SPY>
			     <SETG BAD-SPY-KNOWS-YOU T>
			     <PUT <GET ,GOAL-TABLES ,BAD-SPY-C>
				  ,GOAL-FUNCTION
				  ,TRAVELER-FLEES>
			     <DISABLE <INT I-TRAVELER>>)>
		      <TELL
CHE .PER open HIS .PER " eyes wider and" V .PER say ", ">
		      <PRODUCE-GIBBERISH>
		      <RTRUE>)
		     (<AND <IOBJ? CIGARETTE>
			   <OR <IN? ,LIGHTER ,PRSO>
			       <AND <DOBJ? WAITER WAITRESS>
				    <CALL-FOR-PROP ,LIGHTER ,PRSO>>>
			   <NOT <==? ,PRSO ,BAD-SPY>>>
		      <FSET ,LIGHTER ,TAKEBIT>
		      <FSET ,LIGHTER ,TOUCHBIT>
		      <MOVE ,LIGHTER ,PLAYER>
		      <TELL
CHE .PER " kindly" V .PER lend " you a " D ,LIGHTER "."CR>
		      <RTRUE>)>)>)
       (<SET OBJ <ASK-WHAT? .PER>>
	;<OR <AND ,PRSI <SET OBJ ,PRSI>
		 <VERB? ASK-ABOUT CONFRONT> <EQUAL? ,PRSO .PER>>
	    <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		 <VERB? FIND WHAT>>>
	<COND (<NOT <GRAB-ATTENTION .PER>> <RTRUE>)>
	<SAID-TO .PER>
	<COND (<AND <NOT ,ON-TRAIN>
		    <ZMEMZ .OBJ ,TRAIN-TABLE>
		    <EQUAL? .PER ,CONDUCTOR ,GUARD>>
	       <TELL CHE ,PRSI point " to this train track." CR>
	       <RTRUE>)
	      ;(<SET X <COMMON-ASK-ABOUT .PER .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <DONT-KNOW .PER .OBJ>)>)
       (T <COMMON-OTHER .PER>)>>

<ROUTINE ASK-WHAT? (PER)
 <COND (<VERB? ASK-ABOUT CONFRONT>
	<COND (<AND ,PRSI <EQUAL? ,PRSO .PER>>
	       <RETURN ,PRSI>)>)
       (<VERB? FIND WHAT>
	<COND (<AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS>>
	       <RETURN ,PRSO>)>)>>

<ROUTINE IMMOBILIZE (PER "AUX" X)
	<SET X <GT-O .PER>>
	<PUT .X ,GOAL-ENABLE 0>
	<FSET .PER ,OPENBIT>	;"to take/refer to their holdings"
	<FSET .PER ,TAKEBIT>
	<FCLEAR .PER ,TOUCHBIT>
	<COND (<AND <==? .PER ,BAD-SPY>
		    <IN? ,GUN ,OTHER-LIMBO-FWD>>
	       <MOVE ,GUN .PER>)>
	<SET X <FIRST? .PER>>
	<REPEAT ()		;"to take to their holdings"
		<COND (<ZERO? .X> <RETURN>)
		      (T <FSET .X ,TAKEBIT> <SET X <NEXT? .X>>)>>
	<TELL CHE .PER>
	<COND (<IN? ,BRIEFCASE .PER>
	       <MOVE ,BRIEFCASE <LOC .PER>>
	       <TELL V .PER drop HIM ,BRIEFCASE " and">)>
	<TELL V .PER slump C !\  <GROUND-DESC> "." CR>>

<ROOM UNCONSCIOUS
	(LOC ROOMS)
	(DESC "limbo")
	(FLAGS NARTICLEBIT)>

<ROUTINE UNCONSCIOUS-FCN ("OPTIONAL" (TIM 0) "AUX" HR ;PS)
	<COND (<0? .TIM> <SET TIM <+ 9 <RANDOM 6>>>)>
	<SETG MUNGED-PERSON ,PLAYER>
	<SET HR ,HERE>
	<MOVE ,PLAYER ,UNCONSCIOUS>
	<SETG HERE ,UNCONSCIOUS>
	;"<SET PS ,PLAYER-SEATED>
	<SETG PLAYER-SEATED <>>
	<SETG PLAYER-NOT-FACING <>>"
	<TELL "...|
|
">
	<STATUS-LINE>
	<ENABLE <QUEUE I-COME-TO .TIM>>
	<V-WAIT .TIM <> T>
	;<INT-WAIT .TIM>
	<MOVE ,PLAYER .HR>
	<SETG HERE .HR>
	<COND (<ZERO? ,PLAYER-SEATED>
	       <SETG PLAYER-SEATED <- 0 ,HERE> ;.PS>)>
	<RTRUE>>

<ROUTINE ANYONE-VISIBLE? ("OPTIONAL" (VICTIM <>) "AUX" CNT X (VAL <>))
 <SET X ,COR-ALL-DIRS>
 <SETG COR-ALL-DIRS T>
 <SET CNT 0>
 <REPEAT ()
	 <COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX>
		<SET VAL <>>
		<RETURN>)
	       (<EQUAL? .VICTIM <SET VAL <GET ,CHARACTER-TABLE .CNT>>>
		<AGAIN>)
	       (<VISIBLE? .VAL>
		<RETURN>)>>
 <COND (<NOT <ZERO? .VAL>>
	<SETG COR-ALL-DIRS .X>
	<RETURN .VAL>)>
 <SET CNT <GET ,EXTRA-TABLE 0>>
 <REPEAT ()
	 <COND (<EQUAL? .VICTIM <SET VAL <GET ,EXTRA-TABLE .CNT>>>
		<AGAIN>)
	       (<VISIBLE? .VAL>
		<RETURN>)
	       (<L? <SET CNT <- .CNT 1>> 1>
		<SET VAL <>>
		<RETURN>)>>
 <SETG COR-ALL-DIRS .X>
 .VAL>

;<OBJECT CONTACT-OBJ
	(LOC GLOBAL-OBJECTS)
	(DESC "contact")
	(SYNONYM CONTACT AGENT)
	(ACTION CONTACT-OBJ-F)>

;<ROUTINE CONTACT-OBJ-F ()
 <COND (,CONTACT-KNOWN
	<DO-INSTEAD-OF ,CONTACT ,CONTACT-OBJ>
	<RTRUE>)>>

<OBJECT BODY
	(LOC GLOBAL-OBJECTS)
	(DESC "dead body")
	;(ADJECTIVE DEAD)	;"You can't see any dead woman here!"
	(SYNONYM BODY CORPSE STIFF)
	(ACTION BODY-F)>

<ROUTINE BODY-F ()
 <COND (<OR <ZERO? ,KILLED-PERSON>
	    ;<NOT <VISIBLE? ,KILLED-PERSON>>>
	<NOT-HERE ,BODY>)
       (T
	<DO-INSTEAD-OF ,KILLED-PERSON ,BODY>
	<RTRUE>)>>

<GLOBAL KILLED-PERSON <>>
<GLOBAL MUNGED-PERSON <>>
<GLOBAL MUNGED-ENABLE <>>

<ROUTINE I-COME-TO ("OPTIONAL" (GARG <>) "AUX" P L V X)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-COME-TO:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<ZERO? <SET P ,MUNGED-PERSON>>
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)
       (T
	<SETG MUNGED-PERSON <>>
	<COND (<EQUAL? .P ,PLAYER>
	       <TELL "You shake your head and come to." CR>
	       <RFATAL>)>
	<MOVE .P <META-LOC .P>>
	<FCLEAR .P ,TAKEBIT>
	<FCLEAR .P ,MUNGBIT>
	<FCLEAR .P ,TOUCHBIT>
	<PUTP .P ,P?LDESC 1>
	<PUT <GT-O .P> ,GOAL-ENABLE ,MUNGED-ENABLE>
	<SET X <FIRST? .P>>
	<REPEAT ()		;"to not take to their holdings"
		<COND (<ZERO? .X> <RETURN>)
		      (T <FCLEAR .X ,TAKEBIT> <SET X <NEXT? .X>>)>>
	<COND (<AND <==? .P ,BAD-SPY>
		    <IN? ,GUN .P>>
	       <MOVE ,GUN ,OTHER-LIMBO-FWD>)>
	<SET V <VISIBLE? .P>>
	<COND (<OR .V ,DEBUG>
	       <COND (<NOT .V> <PRINTC %<ASCII !\[>>)>
	       <TELL CTHE .P>
	       <COND (<WHERE? .P> <TELL ",">)>
	       <TELL " shakes" HIS .P " head and comes to." CR>)>
	<COND (<==? .P ,CONTACT>
	       <ARREST-PLAYER "battery" ,CONTACT .V ,PLAYER>)
	      (<==? .P ,BAD-SPY>
	       <SETG BAD-SPY-KNOWS-YOU T>
	       <SET L <LOC .P>>
	       <COND (<MCG-SAFE? ,MCGUFFIN .L>
		      <COND (<==? .L ,HERE>
			     <TELL
"Then" HE .P " sees you, jumps up, and lands a haymaker on you.">
			     <UNCONSCIOUS-FCN>)>)
		     (T
		      <FCLEAR ,BAD-SPY ,TOUCHBIT>
		      <SETG BAD-SPY-DONE-PEEKING <>>
		      <SET X <GET ,GOAL-TABLES ,BAD-SPY-C>>
		      <PUT .X ,GOAL-SCRIPT ,I-BAD-SPY>
		      <PUT .X ,GOAL-ENABLE 1>
		      <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,HERE ,CAR-HERE>)>)>
	<COND (,IDEBUG <TELL N .V "]" CR>)>
	.V)>>

<ROUTINE MCG-SAFE? (OBJ L)	;"object 'safe'?"
 <COND (<IN? .OBJ ,CONTACT>
	<RTRUE>)
       (<EQUAL? .L <META-LOC .OBJ>>
	<COND (<NOT <FSET? <LOC .OBJ> ,PERSONBIT>>
	       <RTRUE>)>)
       (<ZMEMQ .OBJ ,FILM-TBL>
	<COND (<MCG-SAFE? ,FILM .L>
	       <RTRUE>)>)
       (<ZMEMQ .OBJ ,BRIEFCASE-TBL>
	<COND (<IN? ,BRIEFCASE ,CONTACT>
	       <RTRUE>)
	      (<EQUAL? .L <META-LOC ,BRIEFCASE>>
	       <COND (<NOT <FSET? <LOC ,BRIEFCASE> ,PERSONBIT>>
		      <RTRUE>)>)>)>>

<CONSTANT CONTACT-MAX 4>
<GLOBAL EXTRA-TABLE
	<PLTABLE YOUNG-MAN YOUNG-WOMAN OLD-MAN OLD-WOMAN BOY GIRL
		 YOUNG-COUPLE MIDDLE-COUPLE OLD-COUPLE>>
<GLOBAL EXTRA-SEEN-TABLE <LTABLE 0 0 0 0 0 0 0 0 0>>

"<CONSTANT BAD-SPY-MAX 6>"
<GLOBAL SPY-TABLE
	<PLTABLE THIN-MAN FAT-MAN HUNK PEEL DUCHESS NATASHA ;THIN-MAN>>

<GLOBAL CHARACTER-TABLE
	<TABLE PLAYER CONDUCTOR WAITER COOK CLERK BOND
	THIN-MAN FAT-MAN HUNK PEEL DUCHESS NATASHA GUARD THUG DEFECTOR>>

<GLOBAL GLOBAL-CHARACTER-TABLE
	<TABLE	PLAYER			GLOBAL-CONDUCTOR
		GLOBAL-WAITER		GLOBAL-COOK
		CLERK			GLOBAL-BOND
		GLOBAL-THIN-MAN		GLOBAL-FAT-MAN
		GLOBAL-HUNK		GLOBAL-PEEL
		GLOBAL-DUCHESS		GLOBAL-NATASHA
		GLOBAL-GUARD		THUG DEFECTOR>>

<GLOBAL CHAR-CARS <TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>>
<GLOBAL CHAR-LOCS <TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>>

"People Functions"

<ROUTINE CARRY-CHECK (PER) <PRINT-CONT .PER 0 T>>

<ROUTINE COM-CHECK (PER)
 	 <COND (<VERB? WALK-TO ;COME>
		<COND (T ;<DOBJ? GLOBAL-HERE>
		       <PRODUCE-SOMETHING .PER>)>)
	       ;(<VERB? FIND>
		<RFATAL>)
	       (<VERB? THANKS> <RFATAL>)
	       (<VERB? BRING SEND SEND-TO TAKE ;GET>
		<COND (<IN? ,PRSO ,PLAYER>
		       ;<SETG L-WINNER ,WINNER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?GIVE ,PRSO .PER>
		       <RTRUE>)>)
	       (<VERB? EXAMINE>
		;<SETG L-WINNER ,WINNER>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?SHOW .PER ,PRSO>
		<RTRUE>)
	       (<AND <VERB? GIVE> <IOBJ? PLAYER>>
		;<SETG L-WINNER ,WINNER>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?TAKE ,PRSO .PER>
		<RTRUE>)
	       (<AND <VERB? SGIVE> <DOBJ? PLAYER>>
		;<SETG L-WINNER ,WINNER>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?TAKE ,PRSI .PER>
		<RTRUE>)
	       (<VERB? HELLO GOODBYE>
		<COND (<OR <NOT ,PRSO> <==? ,PRSO .PER>>
		       ;<SETG L-WINNER ,WINNER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,PRSA .PER>
		       <RTRUE>)>)
	       ;(<VERB? HELP>
		<COND (<EQUAL? ,PRSO <> ,PLAYER>
		       ;<SETG L-WINNER ,WINNER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .PER>
		       <RTRUE>)
		      (T <RFATAL>)>)
	       (<VERB? INVENTORY>
		<COND (<NOT <CARRY-CHECK .PER>>
		       <TELL CHE .PER is "n't holding anything." CR>)>
		<RTRUE>)
	       ;(<VERB? SHOW>
		<COND (<DOBJ? PLAYER>
		       <COND (<IN? ,PRSI .PER>
			      ;<SETG L-WINNER ,WINNER>
			      <SETG WINNER ,PLAYER>
			      <PERFORM ,V?TAKE ,PRSI .PER>
			      <RTRUE>)>)>)
	       ;(<VERB? TELL>
		<COND (<DOBJ? PLAYER>
		       ;<SETG L-WINNER ,WINNER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .PER>
		       <RTRUE>)>)
	       (<VERB? TELL-ABOUT>
		<COND (<DOBJ? PLAYER>
		       ;<SETG L-WINNER ,WINNER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK-ABOUT .PER ,PRSI>
		       <RTRUE>)>)
	       (<OR ;<VERB? WAIT>
		    <AND <VERB? WAIT-FOR> <DOBJ? PLAYER ROOMS>>>
		;<SETG L-WINNER ,WINNER>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?$CALL .PER>
		<RTRUE>)
	       (<VERB? WHAT TALK-ABOUT>
		;<SETG L-WINNER ,WINNER>
		<SETG WINNER ,PLAYER>
	        <PERFORM ,V?ASK-ABOUT .PER ,PRSO>
		<RTRUE>)>>

<ROUTINE COMMON-OTHER (PER "AUX" (LPER <>) X N)
 <COND (<IN? .PER ,GLOBAL-OBJECTS>
	<SET LPER <GET ,CHARACTER-TABLE <GETP .PER ,P?CHARACTER>>>)
       (T <SET LPER .PER>)>
 <COND (<VERB? ASK> <RFALSE>)
       (<VERB? EXAMINE>
	<COND (<SET X <GETP .LPER ,P?TEXT>>
	       <TELL .X CR>)
	      (<SET X <ZMEMQ .LPER ,EXTRA-TABLE>>
	       <SET N <GET ,EXTRA-SEEN-TABLE .X>>
	       <COND (<NOT <L? 0 .N>>
		      <PUT ,EXTRA-SEEN-TABLE .X <SET N <+ 1 <- 0 .N>>>>)>
	       <SET N <+ .N .X>>
	       <TELL CHE .LPER is
		     " dressed for " <PICK-THIS ,DRESSED-FOR-TBL .N>
		     ", in shades of " <PICK-THIS ,COLOR-TBL .N>
		     ", with " <PICK-THIS ,ACCESS-TBL .N> ". " ;CR>
	       <SET X <GETP .LPER ,P?LDESC>>
	       <COND (<OR <NOT <IN? .LPER ,HERE>>
			  <EQUAL? .X  2 ;"snoozing"
				     32 ;"slumped on the floor"
				     33 ;"preparing to knock you off">
			  <EQUAL? .X 34 ;"out cold"
				     36 ;"dead">>
		      <CRLF>)
		     (T <APPLY <PICK-THIS ,REMARKS-TBL .N> .LPER>)>
	       <RTRUE>)>
	<THIS-IS-IT .LPER>
	<COND (<IN? .LPER ,HERE>
	       <COND (<CARRY-CHECK .LPER>
		      <SET X T>)>)>
	<COND (<FSET? .LPER ,MUNGBIT>
	       <COND (<NOT <ZERO? .X>> <TELL "And">)>
	       <HE-SHE-IT .LPER <NOT .X> "is">
	       <SET X T>
	       <TELL " out cold." CR>)
	      (<NOT <FSET? .LPER ,PERSONBIT>>
	       <COND (<NOT <ZERO? .X>> <TELL "And">)>
	       <FSET .LPER ,PERSONBIT>
	       <HE-SHE-IT .LPER <NOT .X> "is">
	       <FCLEAR .LPER ,PERSONBIT>
	       <SET X T>
	       <TELL " dead." CR>)>
	<RETURN .X>)
       (<AND <EQUAL? ,PRSO .PER> <VERB? SHOW>>
	<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSI>
	<RTRUE>)>>

<ROUTINE PICK-THIS (FROB N)
	 <GET .FROB <+ 1 <MOD .N <GET .FROB 0>>>>>

<GLOBAL DRESSED-FOR-TBL
	<PLTABLE "a holiday" "an outing" "business" "a long trip">>
<GLOBAL COLOR-TBL
	<PLTABLE "brown" "red" "green" "blue" "gray" "purple">>
<GLOBAL ACCESS-TBL
	<PLTABLE "a brown-paper package" "a string bag" "a beret"
		 "a strange odor" "facial sores" "a cane" "an umbrella">>

<GLOBAL REMARKS-TBL
	<PLTABLE REM-NULL REM-EYES-BLK REM-EYES-BLU
		 REM-FINGER REM-MARK REM-WART>>

<ROUTINE REM-NULL (PER) <CRLF>>

<ROUTINE REM-EYES-BLK (PER)
	<TELL
CHIS .PER " glittering black eyes turn away whenever you try to look
into them." CR>>

<ROUTINE REM-EYES-BLU (PER)
	<TELL
CHIS .PER " lucid blue eyes look straight into yours, without a flinch." CR>>

<ROUTINE REM-FINGER (PER)
	<TELL
CHIS .PER " teeth and fingers are well-stained with nicotine." CR>>

<ROUTINE REM-MARK (PER)
	<TELL
CHE .PER has " a birthmark on one cheek like a wine stain." CR>>

<ROUTINE REM-WART (PER)
	<TELL
CHE .PER has " a wart that's hard to avoid looking at." CR>>

<GLOBAL TOURIST-ACTS	<PLTABLE 1 2 3 4 5 6>>
<GLOBAL PLURAL-ACTS	<PLTABLE 1 2 7 8 9>>
<GLOBAL STATION-ACTS	<PLTABLE 1 2 5 6 11 12>>
<GLOBAL PLATFORM-ACTS	<PLTABLE 1 6 10 11 12>>

<CONSTANT PEEKING-CODE 69>
<GLOBAL ACT-STRINGS
 <PLTABLE		"looking at you with suspicion"
			"snoozing"
		;3	"gazing out the window"
			"chewing gum"
			"smoking a cigarette"
		;6	"reading a newspaper"
			"reading a newspaper"
			"talking quietly"
		;9	"exchanging kisses"
			"looking up and down the platform"
			"re-arranging luggage"
		;12	"checking a timetable"
			"about to leave"	;"preparing to walk"
			"walking along"
		;15	"waiting for the train to start"
			"waiting with him"
			"walking to the front of the train"
		;18	"looking triumphant"
			"making his rounds"
			"searching out the window"
		;21	"listening to you"
			"listening to you expectantly"
			"looking at you expectantly"
		;24	"waiting for you"
			"waiting for your order"
			"waiting"
		;27	"cooking"
			"hurrying away"
			"waiting for another order"
		;30	"looking in your direction"
			"inspecting luggage and passports"
			"slumped on the floor"
		;33	"preparing to knock you off"
			"out cold"
			"deep in thought"
		;36	"dead">>

<ROUTINE NEW-LDESC (OBJ "OPTIONAL" (STR 0) "AUX" HERE)
	<SET HERE <LOC .OBJ>>
	<COND (<NOT <FSET? .OBJ ,PERSONBIT>>
	       <SET STR 36>)
	      (<FSET? .OBJ ,MUNGBIT>
	       <SET STR 34>)
	      (<NOT <ZERO? .STR>> T)
	      (<ON-PLATFORM? .HERE>
	       <SET STR <PICK-ONE ,PLATFORM-ACTS>>)
	      (<ZMEMQ .HERE ,STATION-ROOMS>
	       <SET STR <PICK-ONE ,STATION-ACTS>>)
	      (<FSET? .OBJ ,PLURALBIT>
	       <SET STR <PICK-ONE ,PLURAL-ACTS>>)
	      (T
	       <SET STR <PICK-ONE ,TOURIST-ACTS>>)>
	<COND (<=? .STR 2 ;"snoozing">
	       <COND (<OR <EQUAL? .OBJ ,BAD-SPY>
			  <ZMEMQ .HERE ,CAR-ROOMS-CORRID>>
		      <SET STR 3 ;"gazing out the window">)
		     (<ZMEMQ .HERE ,CAR-ROOMS-VESTIB>
		      <SET STR 1 ;"looking at you susp.">)>)
	      (<=? .STR 5 ;"smoking a cigarette">
	       ;<FSET .OBJ ,SEARCHBIT>
	       <COND (<NOT <CALL-FOR-PROP ,LIGHTER .OBJ>>
		      <SET STR 4 ;"chewing gum">)>
	       <COND (<NOT <CALL-FOR-PROP ,CIGARETTE .OBJ>>
		      <SET STR 4 ;"chewing gum">)>)
	      (<EQUAL? .STR 6 7>
	       ;<FSET .OBJ ,SEARCHBIT>
	       <COND (<NOT <CALL-FOR-PROP ,NEWSPAPER .OBJ>>
		      <SET STR 4 ;"chewing gum">)>)
	      (<EQUAL? .STR 11 31>
	       ;<FSET .OBJ ,SEARCHBIT>
	       <COND (<NOT <CALL-FOR-PROP ,LUGGAGE .OBJ>>
		      <SET STR 12 ;"checking timetable">)>)>
	<COND (<NOT <==? .STR <GETP .OBJ ,P?LDESC>>>
	       <FCLEAR .OBJ ,TOUCHBIT>)>
	<PUTP .OBJ ,P?LDESC .STR>
	.STR>

<ROUTINE CALL-FOR-PROP (OBJ PER)
	<COND (<==? .PER ,PLAYER>
	       <RFALSE>)
	      (<FSET? .OBJ ,TOUCHBIT>
	       <RFALSE>)
	      (<FSET? <META-LOC .OBJ> ,SEENBIT>
	       <RFALSE>)
	      (T
	       <FCLEAR .OBJ ,TAKEBIT>
	       <MOVE .OBJ .PER>
	       <PUTP .OBJ ,P?CAR <GETP .PER ,P?CAR>>
	       <RETURN .OBJ>)>>

<ROUTINE UNSNOOZE (PER)
	<COND (<=? <GETP .PER ,P?LDESC> 2 ;"snoozing">
	       <FCLEAR .PER ,TOUCHBIT>
	       <PUTP .PER ,P?LDESC 1 ;"looking at you susp.">)>>

<ROUTINE DESCRIBE-PERSON (OBJ "AUX" (STR <>) GOBJ RM DR)
	<COND (<FSET? .OBJ ,NDESCBIT>
	       <RFALSE>)
	      (<AND <==? .OBJ ,BAD-SPY>
		    <QUEUED? ,I-TRAVELER>>
	       <I-TRAVELER T>
	       <SETG SUPPRESS-INTERRUPT T>
	       <RTRUE>)
	      (<FSET? .OBJ ,SEENBIT>
	       <TELL CTHE .OBJ V .OBJ is>)
	      (T
	       <TELL "There's " A .OBJ>)>
	<TELL " here, ">
	<SET STR <GETP .OBJ ,P?LDESC>>
	<COND (<ZERO? .STR>
	       <SET STR <NEW-LDESC .OBJ>>)
	      (<AND <FSET? .OBJ ,TOUCHBIT>
		    <NOT <EQUAL? .STR 36 ;"dead">>>
	       <TELL "still ">)>
	<COND (<IN? ,BRIEFCASE .OBJ>
	       <TELL "holding the " D ,BRIEFCASE " and ">)>
	<COND (<NOT <==? .STR ,PEEKING-CODE>>
	       <COND (<EQUAL? .STR 5 ;"smoking a cigarette">
		      <THIS-IS-IT ,CIGARETTE>)
		     (<EQUAL? .STR 6 7 ;"reading a newspaper">
		      <THIS-IS-IT ,NEWSPAPER>)
		     (<EQUAL? .STR 11 ;"re-arranging luggage">
		      <THIS-IS-IT ,LUGGAGE>)
		     (<EQUAL? .STR 12 ;"checking a timetable">
		      <THIS-IS-IT ,TIMETABLE>)
		     (<EQUAL? .STR 31 ;"inspecting luggage and passports">
		      <THIS-IS-IT ,PASSPORT>)>
	       <TELL <GET ,ACT-STRINGS .STR>>)
	      (<SET RM <GETPT <LOC .OBJ> ,P?IN>>
	       <COND (<==? <PTSIZE .RM> ,DEXIT>
		      <SET DR <GET-DOOR-OBJ .RM>>)>
	       <COND (<AND .DR <FSET? .DR ,LOCKED>>
		      <TELL "trying" HIM .DR>)
		     (T <TELL "peeking into" THE ;HIM <GET-REXIT-ROOM .RM>>)>)
	      (T <TELL "looking around">)>
	<FSET .OBJ ,TOUCHBIT>
	<FSET .OBJ ,SEENBIT>
	<COND (<SET GOBJ <GETP .OBJ ,P?CHARACTER>>
	       <SET GOBJ <GET ,GLOBAL-CHARACTER-TABLE .GOBJ>>
	       <COND (<NOT <==? .OBJ .GOBJ>>
		      <FSET .GOBJ ,TOUCHBIT>
		      <FSET .GOBJ ,SEENBIT>)>)>
	<TELL ".">
	<COND (<OR <EQUAL? .STR 14 ;"walking along"
				17 ;"walking to the front of the train">
		   <EQUAL? .STR 19 ;"making his rounds"
				28 ;"hurrying away">>
	       <PRINTC 32>)
	      (T <CRLF>)>>

<ROUTINE DONT-KNOW (PER OBJ)
	<PRODUCE-SOMETHING .PER>
	<RTRUE>>

<ROUTINE GLOBAL-PERSON ("OPTIONAL" (ARG <>) "AUX" L)
 <COND (<VERB? ;ARREST FIND FOLLOW LOOK-UP ;$CALL PHONE WAIT-FOR WALK-TO WHAT>
	<RFALSE>)
       (<VERB? $WHERE>
	<COND (<ZERO? .ARG>
	       <SETG PRSO <GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>)>
	<RFALSE>)
       (<AND <VERB? EXAMINE>
	     <SET L <GETP ,PRSO ,P?CHARACTER>>	;<FSET? ,PRSO ,PERSONBIT>
	     <SET L <OR .ARG <GET ,CHARACTER-TABLE .L>>>>
	<COND (<NOT <CORRIDOR-LOOK .L>>
	       <NOT-HERE ,PRSO>)>)
       (<AND <VERB? ASK-ABOUT ASK-FOR HELLO REPLY TELL TELL-ABOUT>
	     ,PRSO
	     <FSET? ,PRSO ,PERSONBIT>
	     <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>>
	<COND (<VERB? REPLY> <SETG PRSA ,V?TELL>)>
	<RFALSE>)
       (<AND <VERB? ASK-ABOUT TELL-ABOUT>
	     ,PRSI
	     <SET L <GETP ,PRSI ,P?CHARACTER>>	;<FSET? ,PRSI ,PERSONBIT>
	     <IN? ,PRSI ,GLOBAL-OBJECTS>>
	<PERFORM ,PRSA ,PRSO <OR .ARG <GET ,CHARACTER-TABLE .L>>>
	<RTRUE>)
       (T
	<SETG P-CONT <>>
	<COND (<OR <VERB? ASK-ABOUT TELL-ABOUT>
		   <NOT ,NOW-PRSI>>
	       <NOT-HERE-PERSON ,PRSO>)
	      (,PRSI <NOT-HERE-PERSON ,PRSI>)
	      (T <NOT-HERE-PERSON ,WINNER>)>
	<RTRUE>)>>

<ROUTINE NOT-HERE-PERSON (PER "AUX" L)
	<SETG CLOCK-WAIT T>
	<TELL "(" CHE .PER is>
	<COND (<SET L <GETP .PER ,P?CHARACTER>>	;<FSET? .PER ,PERSONBIT>
	       <SET PER <GET ,CHARACTER-TABLE .L>>)
	      ;(T <SET L <LOC .PER>>)>
	<COND (<VISIBLE? .PER>
	       <TELL "n't close enough">
	       <COND (<SPEAKING-VERB?> <TELL " to hear you">)>
	       <TELL ".">)
	      (T <TELL "n't here!">)>
	<TELL ")" CR>>

"<ROUTINE POPULATION (RM 'OPTIONAL' (NOT1 <>) (NOT2 <>) 'AUX' (CNT 0) OBJ)
 <COND (<NOT <SET OBJ <FIRST? .RM>>> <RETURN .CNT>)>
 <REPEAT ()
	 <COND (<AND <FSET? .OBJ ,PERSONBIT>
		     <NOT <FSET? .OBJ ,INVISIBLE>>
		     <OR <NOT .NOT1> <NOT <EQUAL? .OBJ .NOT1>>>
		     <OR <NOT .NOT2> <NOT <EQUAL? .OBJ .NOT2>>>>
		<SET CNT <+ .CNT 1>>)
	       (<FSET? .OBJ ,CONTBIT>
		<SET CNT <+ .CNT <POPULATION .OBJ .NOT1 .NOT2>>>)>
	 <SET OBJ <NEXT? .OBJ>>
	 <COND (<NOT .OBJ> <RETURN .CNT>)>>>"

<ROUTINE PRODUCE-SOMETHING (PER)
 <COND (<OR <EQUAL? .PER ,CONDUCTOR ,GUARD ,THUG ;,WAITER>
	    <PROB 50>>
	<PRODUCE-GIBBERISH>)
       (<PROB 50>
	<TELL CHE .PER look " around fearfully but" V .PER say" nothing." CR>)
       (T <TELL"\"Mrzni Amerikan? Globfrp " <PICK-ONE-NEW ,CELEBS> "?\""CR>)>>

<ROUTINE PRODUCE-GIBBERISH ("OPTIONAL" (N 0) "AUX" COUNT SUPER-COUNTER)
	 <COND (<ZERO? .N>
		<COND (<PROB 50> <SET N 1>) (T <SET N 2>)>)>
	 <PRINTC %<ASCII !\">>
	 <PRINTC <PICK-ONE-NEW ,VOWELS>>
	 <SET SUPER-COUNTER 0>
	 <REPEAT ()
		 <SET SUPER-COUNTER <+ .SUPER-COUNTER 1>>
		 <SET COUNT 0>
		 <REPEAT ()
			 <SET COUNT <+ .COUNT 1>>
			 <TELL <PICK-ONE-NEW ,GIBBERISH>>
			 <COND (<EQUAL? .COUNT 5 ;10>
				;<COND (<NOT <EQUAL? .SUPER-COUNTER .N>>
				       <TELL " o">)>
				<RETURN>)>>
		 <COND (<EQUAL? .SUPER-COUNTER .N>
			<COND (<PROB 50> <TELL ".\"" CR>) (T <TELL "?\"" CR>)>
			<RETURN>)>>
	 <RTRUE>>

<GLOBAL VOWELS <MAPF ,LTABLE ,ASCII " AEIOUY">>

<GLOBAL GIBBERISH
	<LTABLE	0
" gorm"	"nash"	" floo"	"snap"	" nom"	"nets"	" mush"	"pro"
" frob"	"zit"	" qwa"	"mrk"	" vub"	"ulp"	" liz"	"ni"
" cho"	"glip"	" quid"	"zrk"	" fim"	"nosh"	" glob"	"frp"
" jon"	"stu"	" dav"	"bob"	" jef"	"jer"	" bri"	"stev">>
