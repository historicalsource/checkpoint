"VERBS for CHECKPOINT
Copyright (C) 1985 Infocom, Inc.  All rights reserved."

<ROUTINE TRANSCRIPT (STR)
	<TELL "Here " .STR "s a transcript of interaction with" CR>>

<ROUTINE V-SCRIPT ()
	<DIROUT 2>
	;<PUT 0 8 <BOR <GET 0 8> 1>>
	<TRANSCRIPT "begin">
	<V-VERSION>
	<RTRUE>>

<ROUTINE V-UNSCRIPT ()
	<TRANSCRIPT "end">
	<V-VERSION>
	<DIROUT -2>
	;<PUT 0 8 <BAND <GET 0 8> -2>>
	<RTRUE>>

<ROUTINE V-$ID ()
	<TELL "EZIP #">
	<PRINTN <GETB 0 30>>
	<TELL " (revision ">
	<PRINTC <GETB 0 31>>
	<TELL ")" CR>>

<ROUTINE V-$VERIFY ()
 <COND (,PRSO
	<COND (<AND <EQUAL? ,PRSO ,INTNUM>
		    <EQUAL? ,P-NUMBER 105>>
	       <TELL N ,SERIAL CR>)
	      (T <DONT-UNDERSTAND>)>)
       (T
	<V-$ID>
	<TELL "Verifying disk..." CR>
	<COND (<VERIFY> <TELL "The disk is correct." CR>)
	      (T <TELL
"Oh, oh! The disk seems to have a defect. Try verifying again. (If
you've already done that, the disk surely has a defect.)" CR>)>)>>

;<ROUTINE V-$AGAIN ("AUX" MSG)
	<TELL "WINNER=" N ,L-WINNER>
	<COND (<NOT <ZERO? ,L-WINNER>> <TELL " (" D ,L-WINNER ")">)>
	<TELL " PRSA=">
	%<COND (<GASSIGNED? PREDGEN> '<TELL N ,L-PRSA>)
	       (T '<PRINC <NTH ,ACTIONS <+ <* ,L-PRSA 2> 1>>>)>
	<TELL " PRSO=" N ,L-PRSO>
	<COND (<NOT <ZERO? ,L-PRSO>>
	       <TELL " ("> <TELL-D-LOC ,L-PRSO> <TELL ")">
	       <COND (<EQUAL? ,NOT-HERE-OBJECT ,L-PRSO>
		      <TELL " ("> <TELL-D-LOC ,L-PRSO-NOT-HERE> <TELL ")">)>)>
	<TELL " PRSI=" N ,L-PRSI>
	<COND (<NOT <ZERO? ,L-PRSI>>
	       <TELL " ("> <TELL-D-LOC ,L-PRSI> <TELL ")">
	       <COND (<EQUAL? ,NOT-HERE-OBJECT ,L-PRSI>
		      <TELL " ("> <TELL-D-LOC ,L-PRSI-NOT-HERE> <TELL ")">)>)>
	<CRLF>>

<ROUTINE V-$ANSWER ("AUX" MSG)
 <COND ;(<NOT ,DEBUG>
	<SET MSG <PICK-ONE ,UNKNOWN-MSGS>>
	<TELL <GET .MSG 0> "#answ" <GET .MSG 1> CR>)
       (T <TELL
"Pssst! The bad spy is the " D ,BAD-SPY ".|
The contact is the " D ,CONTACT>
	<COND (<NOT <ZERO? ,PICKPOCKET>>
	       <TELL ".|
The pickpocket is the " D ,PICKPOCKET>)>
	<TELL ".|
The password is \"" D ,PASSWORD ".\"|
The passobject is" THE ,PASSOBJECT "." CR>)>>

;<ROUTINE V-$CUSTOMS ()
	<SETG CUSTOMS-SWEEP <NOT ,CUSTOMS-SWEEP>>
	<COND (,CUSTOMS-SWEEP
	       <COND (,IN-STATION
		      <MOVE ,PLAQUE ,PLATFORM-B>
		      <FCLEAR ,CUSTOMS-AGENT ,NDESCBIT>
		      <FCLEAR ,CUSTOMS-AGENT ,TOUCHBIT>
		      <PUTP ,CUSTOMS-AGENT ,P?LDESC 31>
		      <MOVE ,CUSTOMS-AGENT ,PLATFORM-B>)
		     (T
		      <SETG SCENERY-OBJ ,STATION-GRNZ>
		      <ARRIVE-STATION>)>
	       <TELL "[here]" CR>)
	      (T
	       <MOVE ,PLAQUE ,LIMBO-FWD>
	       <FSET ,CUSTOMS-AGENT ,NDESCBIT>
	       <MOVE ,CUSTOMS-AGENT ,GLOBAL-OBJECTS>
	       <TELL "[gone]" CR>)>>

<ROUTINE V-$FCLEAR ("AUX" (F <>))
	<COND (<AND ,PRSO <EQUAL? ,PRSI ,INTNUM>>
	       <COND (<FSET? ,PRSO ,P-NUMBER> <SET F T>)>
	       <FCLEAR ,PRSO ,P-NUMBER>
	       <COND (.F <TELL "T" CR>)
		     (T <TELL "#FALSE ()" CR>)>)
	      (T <TELL "OOPS!" CR>)>>

<ROUTINE V-$FSET ("AUX" (F <>))
	<COND (<AND ,PRSO <EQUAL? ,PRSI ,INTNUM>>
	       <COND (<FSET? ,PRSO ,P-NUMBER> <SET F T>)>
	       <FSET ,PRSO ,P-NUMBER>
	       <COND (.F <TELL "T" CR>)
		     (T <TELL "#FALSE ()" CR>)>)
	      (T <TELL "OOPS!" CR>)>>

<ROUTINE V-$QFSET ()
	<COND (<AND ,PRSO <EQUAL? ,PRSI ,INTNUM>>
	       <COND (<FSET? ,PRSO ,P-NUMBER> <TELL "T" CR>)
		     (T <TELL "#FALSE ()" CR>)>)
	      (T <TELL "OOPS!" CR>)>>

<ROUTINE V-$GOAL ("AUX" (CNT 0) O L C S)
 <REPEAT ()
  <COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX>
	 <RETURN>)>
  <SET C <GET ,CHARACTER-TABLE .CNT>>
  <SET O <GET ,GOAL-TABLES .CNT>>
  <SET S <GET .O ,GOAL-S>>
  <COND (<AND <EQUAL? .CNT ,EXTRA-C ,STAR-C> <ZERO? .S>>
	 <TELL D .C ": ">
	 <SET L <INT I-EXTRA>>
	 <TELL N <GET .L ,C-TICK> " min">
	 <COND (<ZERO? <GET .L ,C-ENABLED?>>
		<TELL " (DISABLED)">)>
	 <CRLF>)
	(<AND <LOC .C> <NOT <ZERO? .S>>>
	 <TELL D .C ": " D .S>
	 <COND (<ON-PLATFORM? .S> <TELL " (" N <GETP .S ,P?CAR> ")">)>
	 <SET L <GET .O ,GOAL-F>>
	 <COND (<NOT <EQUAL? .S .L>>
		<TELL "/F:" D .L>
		<COND (<ON-PLATFORM? .L> <TELL " (" N <GETP .L ,P?CAR>")">)>)>
	 <SET L <GET .O ,GOAL-I>>
	 <COND (<NOT <ZERO? .L>>
		<SET L <GET ,TRANSFER-TABLE .L>>
		<COND (<ZERO? .L> <TELL "/I:0">)
		      (T
		       <TELL "/I:" D .L>
		       <COND (<ON-PLATFORM? .L>
			      <TELL " (" N <GETP .L ,P?CAR> ")">)>)>)>
	 <COND (<EQUAL? ,I-WALK-TRAIN <GET .O ,GOAL-FUNCTION>>
		<TELL "/Q:" D <GET .O ,GOAL-QUEUED>
		      "(car #" N <GET .O ,GOAL-CAR> ")">)>
	 <COND (<ZERO? <GET .O ,GOAL-ENABLE>>
		<TELL " (DISABLED)">)>
	 <PRINTC 32>
	 <APPLY <GET .O ,GOAL-FUNCTION> ,G-DEBUG>
	 <PRINTC 32>
	 <APPLY <GET .O ,GOAL-SCRIPT> ,G-DEBUG>
	 <CRLF>)>>>

<ROUTINE V-$QUEUE ("AUX" C E TICK)
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <REPEAT ()
		 <COND (<==? .C .E> <RETURN>)
		       (<AND <NOT <ZERO? <GET .C ,C-ENABLED?>>>
			     <NOT <ZERO? <SET TICK <GET .C ,C-TICK>>>>>
			<APPLY <GET .C ,C-RTN> ,G-DEBUG>
			<PRINTC 9>
			<TELL N .TICK CR>)>
		 <SET C <REST .C ,C-INTLEN>>>>

<ROUTINE V-$STATION ("AUX" TBL CNT)
	<COND (<SET CNT <ZMEMZ ,PRSO ,TRAIN-TABLE-A>>
	       <SET TBL ,TRAIN-TABLE-A>)
	      (<SET CNT <ZMEMZ ,PRSO ,TRAIN-TABLE-B>>
	       <SET TBL ,TRAIN-TABLE-B>)
	      (T
	       <TELL "[Not in timetable!]" CR>
	       <RTRUE>)>
	<SETG TRAIN-NAME <GET .TBL 0>>
	<SETG TRAIN-TABLE <REST .TBL <* 2 <- .CNT 1>>>>
	<ENABLE <QUEUE I-TRAIN-SCENERY 1>>
	<TELL "[okay]" CR>>

<ROUTINE V-$WHERE ("AUX" (CNT 0) O L MSG)
 <COND ;(<NOT ,DEBUG>
	<SET MSG <PICK-ONE ,UNKNOWN-MSGS>>
	<TELL <GET .MSG 0> "#wher" <GET .MSG 1> CR>)
       (,PRSI <MOVE ,PRSO ,PRSI>)
       (,PRSO <TELL-$WHERE ,PRSO>)
       (T
	 <REPEAT ()
		 <COND (<SET O <GET ,CHARACTER-TABLE .CNT>>
			;<SET L <LOC .O>>
			<TELL-$WHERE .O>)>
		 <COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX>
			<RETURN>)>>
	 <SET CNT <GET ,EXTRA-TABLE 0>>
	 <REPEAT ()
		 <COND (<SET O <GET ,EXTRA-TABLE .CNT>>
			;<SET L <LOC .O>>
			<TELL-$WHERE .O>)>
		 <COND (<L? <SET CNT <- .CNT 1>> 1>
			<RETURN>)>>)>>

<ROUTINE TELL-$WHERE (O "OPTIONAL" (L 0))
	<TELL D .O "	is ">
	<COND (<ZERO? .L> <SET L <LOC .O>>)>
	<COND (.L
	       <TELL "in">
	       <COND (<GETP .O ,P?CAR>
		      <TELL " (car #" N <GETP .O ,P?CAR> ")">)>
	       <TELL THE .L>
	       <COND (<ZMEMQ .L ,CAR-ROOMS-DINER>
		      <TELL " (diner)">)
		     (<ZMEMQ .L ,CAR-ROOMS-FANCY>
		      <TELL " (fancy)">)
		     (<ON-PLATFORM? .L>
		      <TELL " (" N <GETP .L ,P?CAR> ")">)>
	       <TELL "." CR>)
	      (T  <TELL "nowhere." CR>)>>

<GLOBAL DEBUG <>>
<GLOBAL IDEBUG <>>

<ROUTINE V-DEBUG ()
	 <COND (,PRSO
		<SETG IDEBUG <NOT ,IDEBUG>>
		<TELL "[" N ,IDEBUG "]" CR>)
	       (<SETG DEBUG <NOT ,DEBUG>>
		<TELL "Find them bugs, boss!" CR>)
	       (T <TELL "No bugs left, eh?" CR>)>>


"ZORK game commands"

"SUBTITLE SETTINGS FOR VARIOUS LEVELS OF DESCRIPTION"

<GLOBAL VERBOSE 1>	"0=SUPERB 1=BRIEF 2=VERBOS"
"<GLOBAL SUPER-BRIEF <>>
<GDECL (VERBOSE SUPER-BRIEF) <OR ATOM FALSE>>"

<ROUTINE YOU-WILL-GET (STR)
	<TELL "(Okay, you will get " .STR " descriptions.)" CR>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSE 1>
	 ;<SETG SUPER-BRIEF <>>
	 ;<SETG P-SPACE 1>
	 <YOU-WILL-GET "brief">>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG VERBOSE 0>
	 ;<SETG SUPER-BRIEF T>
	 ;<SETG P-SPACE 0>
	 <YOU-WILL-GET "superbrief">>

<ROUTINE V-VERBOSE ()
	<SETG VERBOSE 2>
	;<SETG SUPER-BRIEF <>>
	;<SETG P-SPACE 1>
	<YOU-WILL-GET "verbose">
	<V-LOOK>>

"<GLOBAL P-SPACE 1>"

<ROUTINE V-INVENTORY ("AUX" X)
	 <SET X <PRINT-CONT ,WINNER>>
	 <COND (<NOT .X>
	        ;<HE-SHE-IT ,WINNER T "is">
		<TELL CHE ,WINNER is " not holding anything.">)>
	 <COND (<AND <==? ,WINNER ,PLAYER>
		     <OR <FIRST? ,POCKET> <G? <GETP ,PLAYER ,P?SOUTH> 0>>>
		<THIS-IS-IT ,POCKET>
		<COND (.X <TELL "And">) (T <TELL " But">)>
		<TELL " there's something in " D ,POCKET ".">)>
	 <CRLF>>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T))
	 ;<V-SCORE>
	 <COND (<NOT .ASK?> <QUIT>)>
	 <COND (T ;<NOT ,SAVE-DISALLOWED>
		<TELL
"(If you want to continue from this point at another time, you must
\"SAVE\" first.)|
">)>
	 <TELL "Do you want to stop the story now?">
	 <COND (<YES?> <QUIT>)
	       (T <TELL "Okay." CR>)>>

<ROUTINE V-RESTART ()
	 ;<V-SCORE>
	 <TELL
"Do you want to start over from the beginning?">
	 <COND (<YES?>
		<RESTART>
		<TELL-FAILED>)>>

<ROUTINE TELL-FAILED ()
	<TELL
"(Sorry, but it didn't work. Maybe your instruction manual or Reference
Card can tell you why.)" CR>>

"<GLOBAL SAVE-DISALLOWED <>>"

<ROUTINE V-SAVE ("AUX" X)
	 ;<COND (,SAVE-DISALLOWED
		<TELL
"(Sorry, but in this variation you are \"walking a tightrope
without a safety net.\")" CR>
		<TELL
"[During testing, though, you may have to SAVE. Do you really need to?">
		<COND (<NOT <YES?>>
		       <TELL "Good for you!]" CR>
		       <RTRUE>)
		      (T <TELL "Ain't it fun to cheat?]" CR>)>)>
	 <TELL
"(In this variation, 1 minute will pass in the story before you can
type another command. Are you sure you want to SAVE now?">
	 <COND (<NOT <YES?>>
		<SETG CLOCK-WAIT T>
		<TELL "Okay.)" CR>
		<RTRUE>)
	       (T <TELL "Okay.)" CR>)>
	 ;<SPLIT 0>
	 <SET X <SAVE>>
	 ;<INIT-STATUS-LINE>
	 <COND (.X
	        <TELL "Okay." CR>
		<COND (<NOT <1? .X>>
		       <INIT-STATUS-LINE>
		       <CLEAR 0>
		       <V-FIRST-LOOK>)>)
	       (T
		<SETG CLOCK-WAIT T>
		<TELL-FAILED>)>
	 <RTRUE>>

<ROUTINE V-RESTORE ()
	 ;<SPLIT 0>
	 <COND (<NOT <RESTORE>>
		<TELL-FAILED>
		;<INIT-STATUS-LINE>
		<RFALSE>)>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (T
		<DESCRIBE-ROOM>
		<COND (<NOT <0? ,VERBOSE>>
		       ;<NOT ,SUPER-BRIEF>
		       <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-VERSION ("AUX" (CNT 17))
	 <TELL D ,GAME
"|
Infocom interactive fiction - a story of intrigue|
Copyright (c) 1985 by Infocom, Inc.  All rights reserved.|
">
	 ;<COND (<NOT <==? <BAND <GETB 0 1> 8> 0>>
		<TELL
"Licensed to Tandy Corporation.|
">)>
	 <TELL
D ,GAME " is a trademark of Infocom, Inc.|
Release ">
	 <PRINTN <BAND <GET 0 1> *3777*>>
	 <TELL " / Serial number ">
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> 23>
			<RETURN>)
		       (T
			<PRINTC <GETB 0 .CNT>>)>>
	 <COND (<NOT <0? ,VARIATION>>
		<TELL " / ">
		<COND (<EQUAL? ,VARIATION 1 2>
		       <TELL "Traveler">)
		      (T <TELL "Spy">)>
		<TELL "'s viewpoint, ">
		<COND (<0? <MOD ,VARIATION 2>>
		       <TELL "long">)
		      (T <TELL "short">)>
		<TELL " variation">)>
	 <CRLF>>

<GLOBAL YES-INBUF <ITABLE BYTE 12>>
<GLOBAL YES-LEXV  <ITABLE BYTE 10>>

<ROUTINE YES? ("AUX" WORD VAL)
	<REPEAT ()
		<PRINTI " >">
		<READ ,YES-INBUF ,YES-LEXV>
		<SET WORD  <GET  ,YES-LEXV ,P-LEXSTART>>
		<COND (<0? <GETB ,YES-LEXV ,P-LEXWORDS>> T)
		      (<NOT <ZERO? .WORD>>
		       <SET VAL <WT? .WORD ,PS?VERB ,P1?VERB>>
		       <COND (<EQUAL? .VAL ,ACT?YES>
			      <SET VAL T>
			      <RETURN>)
			     (<OR <EQUAL? .VAL ,ACT?NO>
				  <EQUAL? .WORD ,W?N>>
			      <SET VAL <>>
			      <RETURN>)>)>
		<TELL "(Please type YES or NO.)">>
	.VAL>

<ROUTINE YOU-CANT ("OPTIONAL" (STR <>) (WHILE <>) (STR1 <>))
	<SETG CLOCK-WAIT T>
	<TELL "(" CHE ,WINNER " can't ">
	<COND (.STR <TELL .STR>) (T <VERB-PRINT>)>
	<COND (<=? .STR "go"> <TELL " in that direction">)
	      (T
	       <COND (<EQUAL? .STR "turn off" "turn on">
		      <TELL THE ,PRSO>)
		     (T <TELL HIM ,PRSO>)>
	       <COND (.STR1
		      <TELL " while">
		      <COND (.WHILE
			     <TELL HE .WHILE is>
			     <THIS-IS-IT .WHILE>)
			    (T <TELL HE ,PRSO is>)>
		      <TELL C !\  .STR1>)
		     ;(T <TELL " now">)>)>
	<TELL ".)" CR>>

""

"SUBTITLE - GENERALLY USEFUL ROUTINES & CONSTANTS"

<ROUTINE DESCRIBE-OBJECT (OBJ ;V? LEVEL "AUX" (STR <>) ;AV)
	 <COND (<AND <0? .LEVEL>
		     <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		<THIS-IS-IT .OBJ>
		<RTRUE>)>
	 <THIS-IS-IT .OBJ>
	 <COND (<AND <0? .LEVEL>
		     <OR <AND <NOT <FSET? .OBJ ,TOUCHBIT>>
			      <SET STR <GETP .OBJ ,P?FDESC>>>
			 <SET STR <GETP .OBJ ,P?LDESC>>>>
		<TELL .STR CR>)
	       (<0? .LEVEL>
		<TELL "There's " A .OBJ " on the floor." CR>)
	       (ELSE
		;<TELL <GET ,INDENTS .LEVEL>>
		<TELL A .OBJ>
		<COND (<FSET? .OBJ ,WORNBIT>
		       <TELL " (being worn)">)>)>
	 <COND (<AND <SEE-INSIDE? .OBJ> <FIRST? .OBJ>>
		<TELL " (">
		<PRINT-CONT .OBJ ;.V? .LEVEL>
		<COND (<FSET? .OBJ ,SURFACEBIT> <TELL " sitting on it">)>
		<TELL ")">)>>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (V? <>))
 <COND (T ;,LIT
	<COND (<FIRST? ,HERE>
	       <COND (<AND <ZERO? .V?> <==? 2 ,VERBOSE>>
		      <SET V? T>)>
	       ;<SET V? <OR .V? ,VERBOSE>>
	       <PRINT-CONT ,HERE -1 .V?>)>)>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR L)
	 <COND (<ZERO? .LOOK?>
		<COND (<==? 2 ,VERBOSE> <SET V? T>)
		      (T <SET V? <>>)>)
	       (T <SET V? T>)>
	 ;<SET V? <OR .LOOK? ,VERBOSE>>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<SET V? T>)>
	 <COND (<IN? ,HERE ,ROOMS>
		<TELL "(" D ,HERE ")" CR>)>
	 <COND (<AND ,PLAYER-NOT-FACING
		     <OR .LOOK?
			 <NOT <==? ,PLAYER-NOT-FACING
				   ,PLAYER-NOT-FACING-OLD>>>>
		<COND (.LOOK? <TELL "(">) ;(T <TELL "[">)>
		<COND (.LOOK? ;T
		       <TELL "You're facing to ">
		       <DIR-PRINT <OPP-DIR ,PLAYER-NOT-FACING>>)>
		<COND (.LOOK? <TELL
", but you look in all directions for a moment">)>
		<COND (.LOOK? ;T
		       <TELL ".">)>
		<COND (.LOOK? <TELL ")">) ;(T <TELL "]">)>
		<COND (.LOOK? ;T
		       <CRLF>)>)>
	 <COND (.V?
		<COND (<FSET? <SET L <LOC ,WINNER>> ,VEHBIT>
		       <TELL "(You're ">
		       <COND (<FSET? .L ,SURFACEBIT>
			      <TELL "sitting o">)
			     (T <TELL "standing i">)>
		       <TELL "n" HIM .L ".)" CR>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       T)
		      (<AND .V? <SET STR <GETP ,HERE ,P?FDESC>>>
		       <TELL .STR CR>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
		<COND (<NOT <==? ,HERE .L>>
		       <APPLY <GETP .L ,P?ACTION> ,M-LOOK>)>)>
	 <COND (<GETP ,HERE ,P?CORRIDOR>
		<COND (.LOOK? <SETG COR-ALL-DIRS T>)>
		<CORRIDOR-LOOK>
		<SETG COR-ALL-DIRS <>>)>
	 <FSET ,HERE ,SEENBIT>
	 <FSET ,HERE ,TOUCHBIT>
	 T>

<ROUTINE FAR-AWAY? (L)
 <COND (<EQUAL? .L ,GLOBAL-OBJECTS>
	<RTRUE>)
       (<OR <ZMEMQ ,HERE ,CAR-ROOMS>
	    <AND <EQUAL? ,HERE ,BESIDE-TRACKS>
		 <NOT <EQUAL? ,CAR-HERE ,DINER-CAR ,FANCY-CAR>>>>
	<NOT <ZMEMQ .L ,CAR-ROOMS>>)
       (<OR <ZMEMQ ,HERE ,CAR-ROOMS-DINER>
	    <AND <EQUAL? ,HERE ,BESIDE-TRACKS>
		 <==? ,CAR-HERE ,DINER-CAR>>>
	<NOT <ZMEMQ .L ,CAR-ROOMS-DINER>>)
       (<OR <ZMEMQ ,HERE ,CAR-ROOMS-FANCY>
	    <AND <EQUAL? ,HERE ,BESIDE-TRACKS>
		 <==? ,CAR-HERE ,FANCY-CAR>>>
	<NOT <ZMEMQ .L ,CAR-ROOMS-FANCY>>)
       (<ZMEMQ ,HERE ,STATION-ROOMS>
	<COND (<NOT <ZMEMQ .L ,STATION-ROOMS>>
	       <RTRUE>)
	      (<NOT ,CUSTOMS-SWEEP>
	       <RFALSE>)
	      (<EQUAL? ,HERE ,PLATFORM-A>
	       <NOT <EQUAL? .L ,PLATFORM-A>>)
	      (T <EQUAL? .L ,PLATFORM-A>)>)
       (<EQUAL? ,HERE ,ROOF>
	<NOT <EQUAL? .L ,ROOF>>)
       (T <TELL "[Foo! Where is HERE?]" CR>)>>

"Lengths:"
<CONSTANT REXIT 0>
<CONSTANT UEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 2) (T 1)>>
	"Uncondl EXIT:	(dir TO rm)		 = rm"
<CONSTANT NEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 3) (T 2)>>
	"Non EXIT:	(dir SORRY string)	 = str-ing"
<CONSTANT FEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 4) (T 3)>>
	"Fcnl EXIT:	(dir PER rtn)		 = rou-tine, 0"
<CONSTANT CEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 5) (T 4)>>
	"Condl EXIT:	(dir TO rm IF f)	 = rm, f, str-ing"
<CONSTANT DEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 6) (T 5)>>
	"Door EXIT:	(dir TO rm IF dr IS OPEN)= rm, dr, str-ing, 0"

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 4) (T 1)>>	"GET/B"
<CONSTANT CEXITSTR 1>		"GET"
<CONSTANT DEXITOBJ 1>		"GET/B"
<CONSTANT DEXITSTR %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 2) (T 1)>>	"GET"

<ROUTINE COMPASS-EQV (RM DIR "AUX" DIRTBL DIRL P L TBL (VAL <>))
 <COND (<OR <EQUAL? .DIR ,P?NORTH ,P?EAST>
	    <EQUAL? .DIR ,P?SOUTH ,P?WEST>>
	<RETURN .DIR>)>
 <SET DIRTBL <GETPT .RM .DIR>>
 <SET DIRL <PTSIZE .DIRTBL>>
 <SET P 0>
 <REPEAT ()
	 <COND (.VAL <RETURN .VAL>)
	       (<0? <SET P <NEXTP .RM .P>>> <RFALSE>)
	       (<AND <NOT <EQUAL? .P ,P?NORTH ,P?EAST>>
		     <NOT <EQUAL? .P ,P?SOUTH ,P?WEST>>>
		<AGAIN>)
	       (<NOT <L? .P ,LOW-DIRECTION>>
		<SET TBL <GETPT .RM .P>>
		<SET L <PTSIZE .TBL>>
		<COND (<NOT <==? .L .DIRL>> <AGAIN>)>
		<DEC L>
		<REPEAT ()
			<COND (<NOT <==? <GETB .TBL .L> <GETB .DIRTBL .L>>>
			       <RETURN>)
			      (<DLESS? L 0>
			       <SET VAL .P>
			       <RETURN>)>>)>>>

<ROUTINE FIRSTER (OBJ LEVEL "AUX" (VAL T))
	 <COND (<==? .OBJ ,PLAYER>
		<TELL "You're holding ">)
	       (<NOT <ZERO? <GETP .OBJ ,P?CHARACTER>>>;<FSET? .OBJ ,PERSONBIT>
		<TELL CHE .OBJ is " holding ">)
	       (<NOT <IN? .OBJ ,ROOMS>>
		<COND (<FSET? .OBJ ,SURFACEBIT>
		       <COND (<G? .LEVEL 0>
			      <TELL "which has ">
			      <RFATAL>)
			     (T
			      <TELL "Sitting on" HIM .OBJ C !\ >
			      <COND (<ZERO? <NEXT? <FIRST? .OBJ>>>
				     <TELL "is ">)
				    (T <TELL "are ">)>)>)
		      (ELSE
		       <COND (<G? .LEVEL 0>
			      <TELL "which">
			      <SET VAL ,M-FATAL>)
			     (T
			      <TELL CTHE .OBJ>)>
		       <TELL " contains ">
		       <RETURN .VAL>)>)>>

;<ROUTINE GO-NEXT (TBL "AUX" VAL)
	 <COND (<SET VAL <LKP ,HERE .TBL>>
		<GOTO .VAL>)>>

<ROUTINE HAR-HAR () <TELL <PICK-ONE-NEW ,YUKS> CR>>

<ROUTINE NOT-HOLDING? (OBJ)
	<COND (<AND <NOT <IN? .OBJ ,WINNER>>
		    <NOT <IN? <LOC .OBJ> ,WINNER>>>
	       ;<HE-SHE-IT ,WINNER T "is">
	       <TELL CHE ,WINNER is " not holding" HIM .OBJ "." CR>)>>

;<ROUTINE LKP (ITM TBL "AUX" (CNT 0) (LEN <GET .TBL 0>))
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RFALSE>)
		       (<EQUAL? <GET .TBL .CNT> .ITM>
			<COND (<EQUAL? .CNT .LEN> <RFALSE>)
			      (T
			       <RETURN <GET .TBL <+ .CNT 1>>>)>)>>>

<ROUTINE GOTO (RM "OPTIONAL" (V? T) "AUX" L)
	<COND (<AND <IN? ,WINNER .RM> <NOT <==? .RM ,ROOF>>>
	       <HAR-HAR>
	       <RFALSE>)>
	;<SET L <LOC ,WINNER>>
	<MOVE ,WINNER .RM>
	<SETG LIT T>
	<COND (<==? ,WINNER ,PLAYER>
	       <COND (<AND <SET L <DIR-FROM ,HERE .RM>>
			   <SET L <COMPASS-EQV ,HERE .L>>>
		      ;<SETG PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>
		      <SETG PLAYER-NOT-FACING <OPP-DIR .L>>)>
	       <SETG LAST-PLAYER-LOC ,HERE>
	       <SETG HERE .RM>
	       <APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	       <COND (.V? <V-FIRST-LOOK>)>
	       <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
	<RTRUE>>

<ROUTINE HACK-HACK (STR)
	 <TELL .STR HIM ,PRSO <PICK-ONE ,HO-HUM> CR>>

<GLOBAL HO-HUM
	<PLTABLE
	 " won't help any."
	 " is a waste of time.">>

;<ROUTINE HELD? (OBJ "OPTIONAL" (CONT <>))
	 <COND (<NOT .CONT> <SET CONT ,WINNER>)>
	 <COND (<NOT .OBJ>
		<RFALSE>)
	       (<IN? .OBJ .CONT>
		<RTRUE>)
	       (<EQUAL? <LOC .OBJ> ,ROOMS ,GLOBAL-OBJECTS>
		<RFALSE>)
	       (T
		<HELD? <LOC .OBJ> .CONT>)>>

<ROUTINE HELD? (OBJ "OPTIONAL" (CONT <>) "AUX" L X)
	 <COND (<NOT .CONT> <SET CONT ,PLAYER ;,WINNER>)>
	 <COND (<EQUAL? .OBJ ,BRIEFCASE-LATCH ,BRIEFCASE-HANDLE>
		<SET OBJ ,BRIEFCASE>)>
	 <REPEAT ()
		 <SET L <LOC .OBJ>>
		 <COND (<NOT .L> <RFALSE>)
		       (<EQUAL? .L .CONT> <RTRUE>)
		       (<EQUAL? .CONT ,PLAYER ;,WINNER>
			<SET X <GETP ,PLAYER ,P?SOUTH>>
			<COND (<EQUAL? .OBJ ,GLOBAL-MONEY>
			       <COND (<L? 0 .X> <RTRUE>)
				     (T <RFALSE>)>)
			      (<EQUAL? .OBJ ,DOLLARS>
			       <COND (,P-DOLLAR-FLAG
				      <COND (<L? .X ,P-AMOUNT>
					     <RFALSE>)
					    (T <RTRUE>)>)
				     (<0? ,P-NUMBER>
				      <COND (<L? .X 1>
					     <RFALSE>)
					    (T <RTRUE>)>)
				     (T
				      <COND (<L? .X ,P-NUMBER>
					     <RFALSE>)
					    (T <RTRUE>)>)>)
			      (<EQUAL? .OBJ ,INTNUM>
			       <COND (<NOT ,P-DOLLAR-FLAG> <RFALSE>)
				     (<L? .X ,P-AMOUNT> <RFALSE>)
				     (T <RTRUE>)>)
			      (T <SET OBJ .L>)>)
		       (<EQUAL? .L ,ROOMS ,GLOBAL-OBJECTS> <RFALSE>)
		       (T <SET OBJ .L>)>>>

<ROUTINE IDROP ()
	 <COND ;(<FSET? ,PRSO ,PERSONBIT>
		<TELL CTHE ,PRSO " wouldn't enjoy that." CR>
		<RFALSE>)
	       (<NOT-HOLDING? ,PRSO>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TOO-BAD-BUT <LOC ,PRSO> "closed">
		<RFALSE>)
	       (T
		<MOVE ,PRSO ,HERE ;"<LOC ,WINNER>">
		<FCLEAR ,PRSO ,WORNBIT>
		<FCLEAR ,PRSO ,NDESCBIT>
		<FCLEAR ,PRSO ,INVISIBLE>
		<RTRUE>)>>

;<GLOBAL INDENTS
	<PTABLE ""
	       "  "
	       "    "
	       "      "
	       "        "
	       "          ">>

<GLOBAL FUMBLE-NUMBER 7>
<GLOBAL FUMBLE-PROB 8>
<GLOBAL ITAKE-LOC <>>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ L)
	 <SET L <LOC ,PRSO>>
	 <COND (<OR <FSET? .L ,PERSONBIT>
		    <AND <EQUAL? .L ,BRIEFCASE>
			 <FSET? <SET L <LOC .L>> ,PERSONBIT>>>
		<COND (<AND <NOT <FSET? ,PRSO ,TAKEBIT>>
			    <NOT <FSET? .L ,MUNGBIT>>
			    <NOT <BRIBED? .L>>>
		       <COND (.VB
			      <TELL
CHE .L hold HIM ,PRSO " more tightly and" V .L look " at you ">
			      <THIS-IS-IT .L>
			      <UNSNOOZE .L>
			      <COND (<ZERO? <GETP .L ,P?SOUTH>>
				     <TELL "defiant">)
				    (T <TELL "hopeful">)>
			      <TELL "ly." CR>)>
		       <RFALSE>)
		      (T <FSET ,PRSO ,TAKEBIT>)>)>
	 <COND (<AND <DOBJ? GLOBAL-MONEY>
		     <NOT <L? <GETP ,PLAYER ,P?SOUTH> ,P-AMOUNT>>>
		<RTRUE>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB <YOU-CANT "take">)>
		<RFALSE>)
	       (<AND <==? ,NOW-LURCHING ,PRESENT-TIME> ,TRAIN-MOVING>
		<COND (.VB <LURCH-MISS ,PRSO>)>
		<RFALSE>)
	       (<AND <DOBJ? KILLED-PERSON>
		     <SET CNT <FIRST? ,WINNER>>
		     <NOT <EQUAL? .CNT ,POCKET ,POCKET-C>>>
		<TELL
"You try to pick up the body, but" THE .CNT " keeps getting in the way." CR>
		<RFALSE>)
	       (<AND <G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
		     <PROB <* .CNT ,FUMBLE-PROB>>>
		<SET OBJ <FIRST? ,WINNER>>
		;<SET OBJ <NEXT? .OBJ>>
		<TOO-BAD-BUT .OBJ>
		<TELL
" slips from" HIS ,WINNER " arms while" HE ,WINNER is " taking" HIM ,PRSO
", and both tumble " <GROUND-DESC> "." CR>
		<MOVE .OBJ ,HERE>	;<PERFORM ,V?DROP .OBJ>
		<MOVE-FROM ,PRSO ,HERE>
		<RFATAL>)
	       (T
		<COND (<AND <EQUAL? ,PRSO ,FILM>
			    <EQUAL? .L ,CAMERA>
			    ,CAMERA-COCKED>
		       <SETG CAMERA-COCKED <>>
		       <PUT ,FILM-TBL ,PICTURE-NUMBER ,GLOBAL-OBJECTS>)>
		<SETG ITAKE-LOC <>>
		<COND (<FSET? .L ,PERSONBIT>
		       <COND (<NOT .VB> <SETG ITAKE-LOC .L>)>)>
		<MOVE-FROM ,PRSO ,WINNER>
		<FSET ,PRSO ,TOUCHBIT>
		<FCLEAR ,PRSO ,NDESCBIT>
		<FCLEAR ,PRSO ,INVISIBLE>
		;<COND (<==? ,WINNER ,PLAYER> <SCORE-OBJ ,PRSO>)>
		<RTRUE>)>>

<ROUTINE LURCH-MISS (OBJ)
	<TELL
"The train's lurching puts you off balance, and you miss" HIM .OBJ "." CR>>

<ROUTINE MOVE-FROM (OBJ HERE "AUX" P)
	<COND (<AND <EQUAL? .OBJ ,NEWSPAPER ,CIGARETTE>
		    <FSET? <SET P <LOC .OBJ>> ,PERSONBIT>
		    <EQUAL? <GETP .P ,P?LDESC> 5 6 7>>
	       <FCLEAR .P ,TOUCHBIT>
	       <PUTP .P ,P?LDESC 1>)>
	<MOVE .OBJ .HERE>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<COND (<NOT <FSET? .X ,WORNBIT>>
			       <SET CNT <+ .CNT 1>>)>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

<ROUTINE CHECK-DOOR (DR)
	<TELL CTHE .DR " is ">
	<COND (<FSET? .DR ,OPENBIT> <TELL "open">)
	      (T
	       <TELL "closed and ">
	       <COND (<NOT <FSET? .DR ,LOCKED>> <TELL "un">)>
	       <TELL "locked">)>
	<TELL "." CR>>

;<ROUTINE CHECK-ON-OFF ()
	<TELL CTHE ,PRSO " is o"
	      <COND (<FSET? ,PRSO ,ONBIT> "n") (T "ff")>
	      "." CR>>

<ROUTINE PRINT-CONT (OBJ "OPTIONAL" (LEVEL 0) (V? <>)
	"AUX" Y 1ST? ;AV (STR <>) ;(PV? <>) (INV? <>) (VAL <>) (LAST <>))
 <COND (<NOT <SET Y <FIRST? .OBJ>>> <RFALSE>)>
 ;<COND (<AND <SET AV <LOC ,WINNER>> <FSET? .AV ,VEHBIT>>
	T)
       (ELSE <SET AV <>>)>
 <SET 1ST? T>
 <COND (<EQUAL? ,WINNER .OBJ <LOC .OBJ>>
	<SET INV? T>)>
 <COND
       (ELSE
	<REPEAT ()
	 <COND (<NOT .Y> <RETURN ;<NOT .1ST?>>)
	       ;(<==? .Y .AV> <SET PV? T>)
	       (<EQUAL? .Y ,WINNER ,POCKET>)
	       (<AND <==? .OBJ ,HERE>
		     <FSET? .Y ,PERSONBIT>
		     <IN-MOTION? .Y>>	;"to be described later"
		<FSET .Y ,ONBIT>
		<MOVE .Y ,LAST-OBJECT>)
	       (<AND <OR <NOT <FSET? .Y ,INVISIBLE>>
			 <AND ,DEBUG <TELL "[invisible] ">>>
		     <NOT <FSET? .Y ,TOUCHBIT>>
		     <SET STR <GETP .Y ,P?FDESC>>
		     <NOT <GETP .Y ,P?DESCFCN>>>
		<COND (<OR <NOT <FSET? .Y ,NDESCBIT>>
			   <AND ,DEBUG <TELL "[ndescbit] ">>>
		       <SET 1ST? <>>
		       <SET LEVEL 0>
		       <COND (.STR
			      <TELL .STR CR>
			      <SET STR <>>
			      <SET VAL T>
			      <THIS-IS-IT .Y>)>)>
		<COND (<AND <SEE-INSIDE? .Y>
			    <NOT <GETP <LOC .Y> ,P?DESCFCN>>
			    <FIRST? .Y>>
		       <COND (<PRINT-CONT .Y 0 .V?> <SET VAL T>)>)>)>
	 <COND (<AND <NOT <FSET? .Y ,INVISIBLE>>
		     <NOT <FSET? .Y ,NDESCBIT>>
		     ;<NOT <EQUAL? .Y ,WINNER ,POCKET>>>
		<SET LAST .Y>)>
	 <SET Y <NEXT? .Y>>>)>
 <SET Y <FIRST? .OBJ>>
 <REPEAT ()
	 <COND (<NOT .Y>
		;<COND (<AND .PV? .AV <FIRST? .AV>>
		       <COND (<PRINT-CONT .AV .LEVEL .V?> <SET VAL T>)>)>
		<RETURN ;.VAL ;<NOT .1ST?>>)
	       (<EQUAL? .Y ;.AV ,PLAYER ,POCKET>)
	       (<AND <OR <NOT <FSET? .Y ,INVISIBLE>>
			 <AND ,DEBUG <TELL "[invisible] ">>>
		     <OR .INV?
			 <FSET? .Y ,TOUCHBIT>
			 <NOT <GETP .Y ,P?FDESC>>>>
		<COND (<OR <NOT <FSET? .Y ,NDESCBIT>>
			   <AND ,DEBUG <TELL "[ndescbit] ">>>
		       <SET VAL T>
		       <COND (.1ST?
			      <SET 1ST? <>>
			      <COND (<SET STR <FIRSTER .OBJ .LEVEL>>
				     <COND (<L? .LEVEL 0> <SET LEVEL 0>)>)>
			      <SET LEVEL <+ 1 .LEVEL>>)
			     (<NOT <IN? .OBJ ,ROOMS>>
			      <COND (<==? .Y .LAST> <TELL "and ">)>)>
		       <DESCRIBE-OBJECT .Y ;.V? .LEVEL>
		       <COND (<==? .Y .LAST>
			      <COND (<OR ;<AND <0? .LEVEL>
					      <NOT <FSET? .OBJ ,NDESCBIT>>>
					 <==? .STR ,TRUE-VALUE>
					 <AND <L? 0 .LEVEL>
					      <FSET? .OBJ ,NDESCBIT>>>
				     <TELL "." CR>)>)
			     (<NOT <IN? .OBJ ,ROOMS>>
			      <TELL ", ">)>)
		      (<AND <FIRST? .Y> <SEE-INSIDE? .Y>>
		       <COND (<PRINT-CONT .Y .LEVEL .V?> <SET VAL T>)>)>)>
	 <SET Y <NEXT? .Y>>>
 <REPEAT ()
	 <COND (<SET Y <FIRST? ,LAST-OBJECT>>	;"people in motion"
		;"<SET VAL T>
		<DESCRIBE-OBJECT .Y 0>"		;"moved to MOVE-PERSON"
		<MOVE .Y ,HERE>)
	       (T <RETURN>)>>
 .VAL>

<ROUTINE PRINT-CONTENTS (OBJ "AUX" F N (1ST? T))
	 <COND (<SET F <FIRST? .OBJ>>
		<REPEAT ()
			<SET N <NEXT? .F>>
			<COND (.1ST? <SET 1ST? <>>)
			      (ELSE
			       <TELL ", ">
			       <COND (<NOT .N> <TELL "and ">)>)>
			<TELL A .F>
			<THIS-IS-IT .F>
			<SET F .N>
			<COND (<NOT .F> <RETURN>)>>)>>

<ROUTINE ROOM-CHECK ("AUX" P)
	 <SET P ,PRSO>
	 <COND (<IN? .P ,ROOMS>
		<COND (<EQUAL? .P ,HERE ;,GLOBAL-HERE>
		       ;<PERFORM ,PRSA ,GLOBAL-HERE ,PRSI>
		       <RFALSE>)
		      (<EQUAL? .P <NEXT-ROOM ,HERE ,P?IN>>
		       <RFALSE>)
		      (<EQUAL? .P <NEXT-ROOM ,HERE ,P?OUT>>
		       <RFALSE>)
		      (T
		       <SETG CLOCK-WAIT T>
		       <TELL "(You aren't close enough to" HIM .P "!)" CR>
		       <RTRUE>)>)
	       (<OR ;<==? .P ,PSEUDO-OBJECT>
		    <EQUAL? <META-LOC .P>
			    ,HERE ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>>
		<RFALSE>)
	       (<NOT <VISIBLE? .P>>
		<COND (<AND <GETP .P ,P?CHARACTER>	;<FSET? .P ,PERSONBIT>
			    <IN? .P ,GLOBAL-OBJECTS>>
		       <SET P <GET ,CHARACTER-TABLE<GETP .P ,P?CHARACTER>>>
		       <COND (<NOT <VISIBLE? .P> ;<CORRIDOR-LOOK .P>>
			      <NOT-HERE .P>)>)
		      (T <NOT-HERE .P>)>)>>

<ROUTINE SEE-INSIDE? (OBJ "OPTIONAL" (ONLY-IN <>))
	<COND (<FSET? .OBJ ,INVISIBLE> <RFALSE>)
	      (<FSET? .OBJ ,TRANSBIT> <RTRUE>)
	      (<FSET? .OBJ ,OPENBIT> <RTRUE>)
	      (.ONLY-IN <RFALSE>)
	      (<FSET? .OBJ ,PERSONBIT>
	       <COND (<NOT <EQUAL? .OBJ ,PLAYER>>
		      <RTRUE>)>)
	      (<FSET? .OBJ ,SURFACEBIT> <RTRUE>)>>

<ROUTINE ARENT-TALKING ()
	<TELL "You aren't talking to anyone!" CR>>

<ROUTINE ALREADY (OBJ "OPTIONAL" (STR <>))
	<SETG CLOCK-WAIT T>
	<TELL "(" CHE .OBJ is " already ">
	<COND (.STR <TELL .STR "!)" CR>)>
	<RTRUE>>

<ROUTINE NOT-CLEAR-WHOM ("OPTIONAL" (GEST 0))
	<SETG QUOTE-FLAG <>>
	<SETG P-CONT <>>
	<TELL "(It's not clear whom you're ">
	<COND (<ZERO? .GEST> <TELL "talk">) (T <TELL "gestur">)>
	<TELL "ing to.)"
;"(To talk to someone, type their name, then a comma, then what you want
them to do.)" CR>>

<ROUTINE OKAY ("OPTIONAL" (OBJ <>) (STR <>))
	<COND (<==? ,WINNER ,PLAYER>
	       <COND (<VERB? THROUGH WALK WALK-TO>
		      <RTRUE>)>)
	      (T <PRODUCE-GIBBERISH> <RTRUE>)>
	<TELL "Okay">
	<COND (.OBJ
	       <TELL "," HE .OBJ>
	       <COND (.STR <TELL " is now " .STR>)>
	       <COND (<=? .STR "on">	<FSET .OBJ ,ONBIT>)
		     (<=? .STR "off">	<FCLEAR .OBJ ,ONBIT>)
		     (<=? .STR "open">		<FSET .OBJ ,OPENBIT>)
		     (<=? .STR "closed">	<FCLEAR .OBJ ,OPENBIT>)
		     (<=? .STR "locked">	<FSET .OBJ ,LOCKED>)
		     (<=? .STR "unlocked">	<FCLEAR .OBJ ,LOCKED>)>)>
	<COND (<OR .STR <NOT .OBJ>>
	       <TELL ".">
	       ;<COND (<NOT <==? ,WINNER ,PLAYER>> <TELL "\"">)>
	       <CRLF>)>
	<RTRUE>>

<ROUTINE WONT-HELP-TO-TALK-TO (OBJ)
	<TELL
"You talk to" HIM .OBJ " for a minute before you realize that" HE .OBJ
" won't respond." CR>>

<ROUTINE TOO-BAD-BUT (OBJ "OPTIONAL" (STR <>))
	<TELL "Too bad, but" HE .OBJ>
	<THIS-IS-IT .OBJ>
	<COND (.STR <TELL V .OBJ is C !\  .STR "." CR>)>
	<RTRUE>>

<ROUTINE TOO-DARK () <TELL "(It's too dark to see!)" CR>>

"<ROUTINE NOT-ACCESSIBLE? (OBJ)
 <COND (<EQUAL? <META-LOC .OBJ> ,WINNER ,HERE ,GLOBAL-OBJECTS> <RFALSE>)
       (<VISIBLE? .OBJ> <RFALSE>)
       (T <RTRUE>)>>"

<ROUTINE VISIBLE? ;"can player SEE object?"
		  (OBJ "OPTIONAL" (ALL-DIR <>) "AUX" L LL (X <>))
	 <COND (<NOT .OBJ> <RFALSE>)
	       (<ACCESSIBLE? .OBJ> <RTRUE>)
	       (<AND <==? .OBJ ,SCENERY-OBJ>
		     <OR <NOT ,ON-TRAIN>
			 <FIND-FLAG-LG ,HERE ,WINDOWBIT>>>
		<RTRUE>)>
	 <SET LL ,COR-ALL-DIRS>
	 <SETG COR-ALL-DIRS .ALL-DIR>
	 <SET X <CORRIDOR-LOOK .OBJ>>
	 <SETG COR-ALL-DIRS .LL>
	 <COND (<NOT <ZERO? .X>>
		<COND (<NOT <ZERO? .ALL-DIR>>
		       <RETURN .X>)
		      (<NOT <==? .X ,PLAYER-NOT-FACING>>
		       <RETURN .X>)
		      (T <RFALSE>)>)>
	 <SET L <LOC .OBJ>>
	 <COND (<SEE-INSIDE? .L> <VISIBLE? .L>)>>

<ROUTINE ACCESSIBLE? (OBJ "AUX" L)	;"can player TOUCH object?"
	 <COND (<NOT .OBJ> <RFALSE>)
	       (T <SET L <LOC .OBJ>>)>
	 <COND (<FSET? .OBJ ,INVISIBLE>
		<RFALSE>)
	       ;(<EQUAL? .OBJ ,PSEUDO-OBJECT>
		<COND (<EQUAL? ,LAST-PSEUDO-LOC ,HERE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<NOT .L>
		<RFALSE>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS ;,ROOMS ;,POCKET>
		<RTRUE>)	       
	       (<EQUAL? .L ,LOCAL-GLOBALS>
		<RETURN <GLOBAL-IN? .OBJ ,HERE>>)
	       (<AND ;<==? .OBJ ,ROOF> <==? ,HERE .OBJ>>
		<RTRUE>)
	       (<NOT <EQUAL? <META-LOC .OBJ> ,HERE>>
		<RFALSE>)
	       (<EQUAL? .L ,WINNER ,HERE>
		<RTRUE>)
	       (<AND <OR <FSET? .L ,OPENBIT>
			 <NOT <ZERO? <GETP .L ,P?CHARACTER>>>
			 ;<FSET? .L ,PERSONBIT>>
		     <ACCESSIBLE? .L>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE META-LOC (OBJ "OPTIONAL" (INV <>) "AUX" L)
	<SET L <LOC .OBJ>>
	<REPEAT ()
		<COND (<NOT .L>
		       <RFALSE>)
		      ;(<EQUAL? .L ,POCKET>
		       <RETURN ,HERE>)
		      (<EQUAL? .L ,LOCAL-GLOBALS ,GLOBAL-OBJECTS>
		       <RETURN .L>)
		      (<IN? .OBJ ,ROOMS>
		       <RETURN .OBJ>)
		      (T
		       <COND (<AND .INV <FSET? .OBJ ,INVISIBLE>>
			      <RFALSE>)>
		       <SET OBJ .L>
		       <SET L <LOC .OBJ>>)>>>

"WEIGHT:  Get sum of SIZEs of supplied object, recursing to the nth level."

<ROUTINE WEIGHT (OBJ "AUX" CONT (WT 0))
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<COND (<AND <EQUAL? .OBJ ,PLAYER>
				    <FSET? .CONT ,WORNBIT>>
			       <SET WT <+ .WT 1>>)
			              ;"worn things shouldn't count"
			      (<AND <EQUAL? .OBJ ,PLAYER>
				    <FSET? <LOC .CONT> ,WORNBIT>>
			       <SET WT <+ .WT 1>>)
			              ;"things in worn things shouldn't count"
			      (T
			       <SET WT <+ .WT <WEIGHT .CONT>>>)>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 <+ .WT <GETP .OBJ ,P?SIZE>>>

<CONSTANT WHO-CARES-LENGTH 4>

<GLOBAL WHO-CARES-VERB
	<PLTABLE "do" "do" "let" "seem">>

<GLOBAL WHO-CARES-TBL
	<PLTABLE "n't appear interested"
		"n't care"
		" out a loud yawn"
		" impatient">>

<ROUTINE WHO-CARES ("AUX" N)
	<SET N <RANDOM ,WHO-CARES-LENGTH>>
	<HE-SHE-IT ,PRSO T <GET ,WHO-CARES-VERB .N>>
	<TELL <GET ,WHO-CARES-TBL .N> "." CR>>

<GLOBAL YUKS
	<LTABLE 0
		"That's ridiculous!"
		"Surely you jest."
		"Not a chance."
		"Not bloody likely."
		"What a fruitcake!"
		"What a screwball!"
		"What a concept!"
		"Like, totally grody, for sure."
		"You can't be serious!">>
""
"SUBTITLE REAL VERBS"

;<ROUTINE V-AGAIN ("AUX" (OBJ <>) (N <>))
	 <COND (<NOT ,L-PRSA>
		<SETG CLOCK-WAIT T>
		<TELL "(What do you want to do again?)" CR>
		<RTRUE>)
	       ;(<AND <NOT <EQUAL? ,L-PRSA ,V?WAIT-FOR ,V?WALK-TO>>
		     <OR <PRSO-VERB? ,L-PRSA ,L-WINNER>
			 <PRSI-VERB? ,L-PRSA ,L-WINNER>>>
		<SETG CLOCK-WAIT T>
		<TELL "(Sorry, but you can't use AGAIN now.)" CR>
		<RTRUE>)>
	 <COND (<EQUAL? ,NOT-HERE-OBJECT ,L-PRSO>
		<COND (<OR <REMOTE-VERB?>
			   ;<VERB? WAIT-FOR WAIT-UNTIL WALK-TO BUY>
			   <VISIBLE? ,L-PRSO-NOT-HERE>>
		       <SETG L-PRSO ,L-PRSO-NOT-HERE>)
		      (T
		       <SETG CLOCK-WAIT T>
		       <TELL "(You can't see that here.)" CR>
		       <RTRUE>)>)>
	 <COND (<EQUAL? ,NOT-HERE-OBJECT ,L-PRSI>
		<COND (<OR <REMOTE-VERB?>
			   ;<VERB? WAIT-FOR WAIT-UNTIL WALK-TO BUY>
			   <VISIBLE? ,L-PRSI-NOT-HERE>>
		       <SETG L-PRSI ,L-PRSI-NOT-HERE>)
		      (T
		       <SETG CLOCK-WAIT T>
		       <TELL "(You can't see that here.)" CR>
		       <RTRUE>)>)>
	 <COND (<EQUAL? ,L-PRSA ,V?WALK>
		<SETG WINNER ,L-WINNER>
		<DO-WALK ,L-PRSO>
		<RTRUE>)>
	 <COND (<AND ,L-PRSO <NOT <VISIBLE? ,L-PRSO>>>
		<SET OBJ ,L-PRSO>)
	       (<AND ,L-PRSI <NOT <VISIBLE? ,L-PRSI>>>
		<SET OBJ ,L-PRSI>)>
	 <COND (<AND .OBJ 
		     <NOT <REMOTE-VERB? ,L-PRSA>>
		     ;<NOT <EQUAL? ,L-PRSA ,V?WAIT-UNTIL>>
		     <NOT <EQUAL? .OBJ ,ROOMS>>>
		<SETG CLOCK-WAIT T>
		<TELL "(You can't see">
		<COND (.N <TELL " any " D .OBJ " here.)" CR>)
		      (T  <TELL HIM .OBJ " any more.)" CR>)>
		<RFATAL>)
	       (T
		<SETG WINNER ,L-WINNER>
		<PERFORM ,L-PRSA ,L-PRSO ,L-PRSI>)>>

<ROUTINE PRE-SAIM () <PERFORM ,V?AIM ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SAIM () <V-FOO>>

<ROUTINE V-AIM () <YOU-CANT ;"aim">>

<ROUTINE PRE-SANALYZE () <PERFORM ,V?ANALYZE ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SANALYZE () <V-FOO>>

<ROUTINE PRE-ANALYZE () <ROOM-CHECK>>

<ROUTINE V-ANALYZE ()
 <COND (<FSET? ,PRSO ,PERSONBIT> <TELL "How?" CR>)
       ;(<FSET? ,PRSO ,ON?BIT> <CHECK-ON-OFF>)
       (<FSET? ,PRSO ,DOORBIT> <CHECK-DOOR ,PRSO>)
       (T <TELL CHE ,PRSO look " normal." CR> ;<YOU-CANT "check">)>>

<ROUTINE V-ANSWER ()
	 <TELL "Nobody seems to be waiting for an answer." CR>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-REPLY ()
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT> <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<WAITING-FOR-YOU-TO-SPEAK>)
	       (T <YOU-CANT ;"answer">)>> 

<ROUTINE WAITING-FOR-YOU-TO-SPEAK ()
	;<HE-SHE-IT ,PRSO T "seem">
	<TELL CHE ,PRSO seem " to be waiting for you to speak." CR>>

"<ROUTINE PRE-ARREST ()
	 <COND (<EQUAL? ,PRSI ,ROOMS>
		<SETG PRSI <>>)>
	 <COND (<OR <NOT <FSET? ,PRSO ,PERSONBIT>>
		    ,PRSI>
		<TELL 'What a brilliant spy! \'Quick! Arrest that ' D ,PRSO>
		<COND (,PRSI <TELL ' for ' D ,PRSI>)>
		<TELL ' before' HE ,PRSO escape '!\'' CR>)
	       (T
		<TELL 'For what? You have no evidence of a crime yet.' CR>)>>

<ROUTINE V-ARREST ()
	<TELL
'You don't have enough evidence to arrest' HIM ,PRSO '.' CR>>"

<ROUTINE PRE-ASK () <PRE-ASK-ABOUT>>

<ROUTINE V-ASK ()
 <COND (<AND ,P-CONT
	     <FSET? ,PRSO ,PERSONBIT>
	     <NOT <FSET? ,PRSO ,MUNGBIT>>>
	;<SETG L-WINNER ,WINNER>
	<SETG WINNER ,PRSO>
	<SETG QCONTEXT ,PRSO>
	<SETG QCONTEXT-ROOM ,HERE>)
       (T <V-ASK-ABOUT>)>>

<ROUTINE PRE-ASK-ABOUT ("AUX" L)
 <COND (<OR <NOT <FSET? ,PRSO ,PERSONBIT>>
	    <FSET? ,PRSO ,MUNGBIT>>
	<TELL CHE ,PRSO do "n't respond at the moment." CR>)
       (T
	<UNSNOOZE ,PRSO>
	<SET L <META-LOC ,PRSO>>
	<COND (<EQUAL? .L ,HERE> <RFALSE>)
	      (<GLOBAL-IN? ,PRSO ,HERE> <RFALSE>)>
	<NOT-HERE-PERSON ,PRSO>
	<RTRUE>)>>

<ROUTINE V-ASK-ABOUT ()
	 <COND (<OR <==? ,PRSO ,PLAYER>
		    <NOT <FSET? ,PRSO ,PERSONBIT>>
		    <FSET? ,PRSO ,MUNGBIT>>
		<WONT-HELP-TO-TALK-TO ,PRSO>
		<RFATAL>)
	       (<VERB? ASK>
		<PRODUCE-GIBBERISH>
		;<TELL "\"Ask me about something in particular.\"" CR>)
	       (T
		<TELL CHE ,PRSO do "n't seem to know about"HIM ,PRSI"." CR>)>>

<ROUTINE PRE-ASK-CONTEXT-ABOUT ("AUX" P)
 <COND (<QCONTEXT-GOOD?>
	<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<TELL ,I-ASSUME " ask" THE .P ".)" CR>
	<PERFORM ,V?ASK-ABOUT .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-ASK-CONTEXT-ABOUT () <ARENT-TALKING>>

<ROUTINE PRE-ASK-FOR () <PRE-ASK-ABOUT>>

<ROUTINE V-ASK-FOR ()
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>
		     <NOT <==? ,PRSO ,PLAYER>>>
		<PRODUCE-GIBBERISH>)
	       (T <HAR-HAR>)>>

<ROUTINE PRE-ASK-CONTEXT-FOR ("AUX" P)
 <COND (<QCONTEXT-GOOD?>
	<PERFORM ,V?ASK-FOR ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<TELL ,I-ASSUME " ask" THE .P ".)" CR>
	<PERFORM ,V?ASK-FOR .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-ASK-CONTEXT-FOR () <ARENT-TALKING>>

<ROUTINE V-ATTACK () <IKILL "attack">>

<ROUTINE PRE-BRING ()
 <COND (<NOT <EQUAL? ,PRSI <> ,PLAYER ,GLOBAL-HERE>>
	<SETG CLOCK-WAIT T>
	<TELL "(Sorry, but I don't understand.)" CR>)>>

<ROUTINE V-BRING () <V-TAKE> ;<YOU-CANT ;"bring">>

<ROUTINE PRE-SBRING () <PERFORM ,V?BRING ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SBRING () <V-FOO>>

<ROUTINE V-BRUSH ()
 <TELL "You try for a minute and then decide it's an endless task." CR>>

<ROUTINE TELL-NO-PRSI ()
	 <SETG CLOCK-WAIT T>
	 <TELL "(You didn't say with what!)" CR>>

<ROUTINE PRE-BURN ()
	 <COND (<ZERO? ,PRSI>
		<TELL-NO-PRSI>)
	       (<EQUAL? ,PRSI ,LIGHTER>
	        <RFALSE>)
	       (T
	        <SETG CLOCK-WAIT T>
		<TELL "(With a " D ,PRSI "??!?)" CR>)>>

<ROUTINE V-BURN ()
	 <COND (<DOBJ? TICKET PASSPORT TIMETABLE CHECK
		       MCGUFFIN SPY-LIST NEWSPAPER CIGARETTE>
		<REMOVE-CAREFULLY ,PRSO>
		<TELL CHE ,PRSO catch " fire and is consumed." CR>)
	       (T <YOU-CANT>)>>

<ROUTINE REMOVE-CAREFULLY (OBJ "AUX" OLIT)
	 <NOT-IT .OBJ>
	 <SET OLIT ,LIT>
	 <REMOVE .OBJ>
	 <SETG LIT <LIT? ,HERE>>
	 <COND (<AND .OLIT <NOT <EQUAL? .OLIT ,LIT>>>
		<TELL "You are left in the dark...." CR>)>
	 T>

"<GLOBAL POCKET-CHANGE 49>"

<ROUTINE PRE-BUY ()
 <COND (<AND <NOT <IN? ,MACHINE ,HERE>>
	     <NOT <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>>
	<SETG CLOCK-WAIT T>
	<COND (<VISIBLE? ,WAITER>
	       <TELL CHE ,WAITER is "n't close enough!)" CR>)
	      (T
	       <TELL "(There's no one here to serve you!)" CR>)>)>>

<ROUTINE PRE-BUY-TICKET ()
 <COND (<NOT <EQUAL? ,HERE ,TICKET-AREA>>
	<SETG CLOCK-WAIT T>
	<TELL "(You can't buy that here.)" CR>)>>

<ROUTINE V-BUY-TICKET () <YOU-CANT>>

<ROUTINE V-BUY ("AUX" COST X)
 <COND (<NOT <EQUAL? ,HERE ,CAFE>>
	<SETG CLOCK-WAIT T>
	<TELL "(You can't buy " A ,PRSO " here.)" CR>)
       (<AND <NOT <IN? ,PRSO ,ROOMS>>
	     <L? 0 <SET COST <GETP ,PRSO ,P?NORTH>>>
	     <NOT <FSET? ,PRSO ,PERSONBIT>>>
	<SET X <GETP ,PLAYER ,P?SOUTH>>
	<COND (<G? .COST .X>
	       <TELL "You don't have enough money." CR>)
	      (T
	       <PUTP ,PLAYER ,P?SOUTH <- .X .COST>>
	       <PUTP ,PRSO ,P?NORTH -1>
	       <FSET ,PRSO ,TAKEBIT>
	       <FCLEAR ,PRSO ,NDESCBIT>
	       <COND ;(<OR <NOT <EQUAL? ,HERE ,CAFE>>
			  ;<G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>>
			      ,LOAD-ALLOWED>
			  <G? <CCOUNT ,WINNER> ,FUMBLE-NUMBER>>
		      <MOVE ,PRSO ,COUNTER>)
		     (T <MOVE ,PRSO ,WINNER>)>
	       <TELL "You have bought " A ,PRSO " for ">
	       <PRINTC ,CURRENCY-SYMBOL>
	       <TELL N .COST>
	       ;<COND (<AND <IN? ,PRSO ,COUNTER> <EQUAL? ,HERE ,CAFE>>
		      <TELL
". Since you can't carry it now, the waitress leaves it on the counter">)>
	       <TELL "." CR>)>)
       (<==? .COST -1>
	<TELL "You've already bought" HIM ,PRSO "." CR>)
       (T ;<HE-SHE-IT ,PRSO T "is"> <TELL CHE ,PRSO is " not for sale." CR>)>>

"<ROUTINE V-CALL-LOSE ()
	<TELL '(I couldn't find a verb in that sentence!)' CR>>"

<ROUTINE V-$CALL ("AUX" PER (MOT <>) C)
	 <SET PER ,PRSO>
	 <COND (<OR <NOT <FSET? .PER ,PERSONBIT>>
		    <FSET? .PER ,MUNGBIT>
		    <==? .PER ,PLAYER>>
		<WONT-HELP-TO-TALK-TO .PER>
		<RTRUE>)>
	 <UNSNOOZE .PER>
	 <COND (<SET C <GETP .PER ,P?CHARACTER>> ;<FSET? .PER ,PERSONBIT>
		;<COND (T ;<NOT <==? .PER ,REMOTE-PERSON>>
		       <SET PER <GET ,CHARACTER-TABLE .C>>)>
		<COND (<IN-MOTION? .PER> <SET MOT T>)>
		<COND (<==? <META-LOC .PER> ,HERE>
		       <TELL CTHE .PER>
		       <COND (<GRAB-ATTENTION .PER>
			      <FCLEAR .PER ,TOUCHBIT>
			      <PUTP .PER ,P?LDESC 21 ;"listening to you">
			      <COND (.MOT
				     <TELL
V .PER stop " and" V .PER turn " toward you." CR>)
			      	    (T <TELL V .PER is " listening." CR>)>)
			     (T
			      <TELL V .PER ignore " you." CR>)>)
		      (<CORRIDOR-LOOK .PER>
		       <COND (<COR-GRAB-ATTENTION ;.PER>
			      <RTRUE>)
			     (T
			      <TELL CTHE .PER V .PER ignore " you." CR>)>)
		      (T <NOT-HERE .PER>)>)
	       (T <SETG CLOCK-WAIT T> <MISSING-VERB>)>>

<ROUTINE PRE-PHONE ("AUX" P PP)
 <COND (<AND ,PRSI ;<NOT <IOBJ? TELEPHONE>>>
	<COND (T
	       <TOO-BAD-BUT ,PRSI "not wired for phoning">)>)
       (<AND <FSET? ,PRSO ,PERSONBIT>
	     <IN? ,PRSO ,HERE>
	     <NOT <FSET? ,PRSO ,NDESCBIT>>>
	<BITE-YOU>)
       (<DOBJ? PLAYER>
	<HAR-HAR>)
       (<NOT ,PRSI>
	<TELL "There's nothing to phone with here." CR>)>>

<ROUTINE V-PHONE ("AUX" PER)
 <COND (<AND <SET PER <GETP ,PRSO ,P?CHARACTER>> ;<FSET? ,PRSO ,PERSONBIT>
	     <SET PER <GET ,CHARACTER-TABLE .PER>>
	     <OR <==? <META-LOC .PER> ,HERE> <CORRIDOR-LOOK .PER>>>
	<PERFORM ,V?$CALL ,PRSO>
	<RTRUE>)
       (<NOT <==? -1 ,P-NUMBER>> ;<DOBJ? INTNUM>
	<TELL "There's no point in calling that number." CR>)
       ;(<DOBJ? TELEPHONE>
	<TELL "You didn't say whom to call." CR>)
       (<NOT <FSET? ,PRSO ,PERSONBIT>>
	<TOO-BAD-BUT ,PRSO>
	<TELL " has no phone." CR>)
       (<AND <EQUAL? <META-LOC ,PRSO> ,HERE>
	     <NOT <FSET? ,PRSO ,NDESCBIT>>>
	<BITE-YOU>)
       (T <TELL "There's no sense in phoning" HIM ,PRSO "." CR>)>>

<ROUTINE V-CHANGE () <YOU-CANT ;"change">>

<ROUTINE V-CHASTISE ()
	<COND (<NOT <EQUAL? ,PRSO ,INTDIR>>
	       <TELL
,I-ASSUME " look at" HIM ,PRSO ", not look in" HIM ,PRSO " nor look for"
HIM ,PRSO " nor any other preposition.)" CR>)>
	<PERFORM ,V?EXAMINE ,PRSO>
	<RTRUE>>

<ROUTINE V-BOARD ()
	<COND (<OR <IN? ,PRSO ,ROOMS> <FSET? ,PRSO ,DOORBIT>>
	       <V-THROUGH>)
	      (T <YOU-CANT "get in">)>>

<ROUTINE V-CLIMB-ON () <YOU-CANT "climb onto">>

<ROUTINE V-CLIMB-UP ("OPTIONAL" (DIR ,P?UP) (OBJ <>) "AUX" X)
	 <COND (<GETPT ,HERE .DIR>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<NOT .OBJ>
		<YOU-CANT "go">)
	       (ELSE <HAR-HAR>)>>

<ROUTINE V-CLIMB-DOWN () <V-CLIMB-UP ,P?DOWN>>

<ROUTINE V-CLOSE ()
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <FSET? ,PRSO ,WINDOWBIT>>>
		<YOU-CANT ;"close">)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,WINDOWBIT>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <COND (<FSET? ,PRSO ,MUNGBIT>
			      <TELL
"It won't stay closed. The latch is broken." CR>)
			     (T
			      <COND (<FSET? ,PRSO ,LOCKED>
				     <COND (<OR;<ZMEMQ ,HERE ,CAR-ROOMS-COMPS>
						<ZMEMQ ,HERE ,CAR-ROOMS-REST>>
					    ;<FSET ,PRSO ,LOCKED>
					    <TELL
"(You lock" HIM ,PRSO " too.)" CR>)>)>
			      <OKAY ,PRSO "closed">)>)
		      (T <ALREADY ,PRSO "closed">)>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <0? <GETP ,PRSO ,P?CAPACITY>>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <OKAY ,PRSO "closed">)
		      (T <ALREADY ,PRSO "closed">)>)
	       (T <YOU-CANT ;"close">)>>

<ROUTINE PRE-COME-WITH ()
	<PERFORM ,V?WALK-TO ,PRSI>
	<RTRUE>>

<ROUTINE V-COME-WITH () <V-FOO>>

<ROUTINE V-CONFRONT ()
	 <COND (<==? ,PRSO ,PLAYER>
		<ARENT-TALKING>)
	       (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<TELL "Wow! That ought to put a scare into" HIM ,PRSO "!" CR>)
	       (T <WHO-CARES>)>>

<ROUTINE V-COUNT () <TELL "Uhhh... ONE!" CR>>

<ROUTINE V-CUT () <YOU-CANT ;"cut">>

<ROUTINE V-MUNG ()
	 <COND (<AND <FSET? ,PRSO ,DOORBIT> <NOT ,PRSI>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL
"You'd fly through the open door if you tried." CR>)
		      (T <TELL "Why don't you just open it instead?" CR>)>)
	       (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<IF-SPY>)
	       (<NOT ,PRSI>
		<TELL
"Trying to destroy" HIM ,PRSO " with your bare hands is suicidal." CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL "You can't destroy" HIM ,PRSO " with" HIM ,PRSI "!" CR>)
	       (T <YOU-CANT ;"destroy">)>>

"<ROUTINE V-DEVELOP () <YOU-CANT>>"

<ROUTINE V-DIAGNOSE ()
 <COND (,PRSO <YOU-CANT ;"diagnose">)
       (T <TELL "You're wide awake and in good health." CR>)>>

<ROUTINE PRE-DISCUSS ()
	<COND (<NOT ,PRSI> <SETG PRSI ,PLAYER>)>
	<PERFORM ,V?TELL-ABOUT ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-DISCUSS () <V-FOO>>

<ROUTINE V-DRINK () <YOU-CANT ;"drink">>

<ROUTINE V-DROP ()
	 <COND ;(<ROOM-CHECK> <RTRUE>)
	       ;(<EQUAL? ,PRSO ,GLOBAL-HERE <META-LOC ,WINNER>>
		<DO-WALK ,P?OUT>
		<RTRUE>)
	       (<IDROP>
		<OKAY ,PRSO <GROUND-DESC>>)>>

<ROUTINE GROUND-DESC ()
	 <COND (<EQUAL? ,HERE ,ROOF> "on the roof")
	       (<EQUAL? ,HERE ,BESIDE-TRACKS> "on the ground")
	       (T "on the floor")>>

<ROUTINE V-EAT () <TELL "It's hard to believe that you're that hungry." CR>>

<ROUTINE PRE-EMPTY ()
	<COND (<NOT <FIRST? ,PRSO>>
	       <ALREADY ,PRSO "empty">)>>

<ROUTINE V-EMPTY ()
	 <COND ;(<NOT ,PRSI>
		<PERFORM ,V?EMPTY ,PRSO ,GLOBAL-WATER>
		<RTRUE>)
	       (T <V-FILL>)>>

<ROUTINE V-ENTER ()
	<DO-WALK ,P?IN>
	<RTRUE>>

<ROUTINE V-THROUGH ("OPTIONAL" (OBJ <>) "AUX" RM DIR)
	<COND (<IN? ,PRSO ,ROOMS>
	       <PERFORM ,V?WALK-TO ,PRSO>
	       <RTRUE>)
	      (<AND <FSET? ,PRSO ,DOORBIT> <FSET? ,PRSO ,OPENBIT>>
	       <COND (<AND <SET RM <DOOR-ROOM ,HERE ,PRSO>>
			   <GOTO .RM>>
		      <OKAY>)
		     (T <TELL
"Sorry, but the \"" D ,PRSO "\" must be somewhere else." CR>)>)
	      (<AND <NOT .OBJ> <NOT <FSET? ,PRSO ,TAKEBIT>>>
	       ;<HE-SHE-IT ,WINNER T "bang">
	       <TELL
CHE ,WINNER bang " into it trying to go through" HIM ,PRSO "." CR>)
	      (.OBJ <TELL "You can't do that!" CR>)
	      (<IN? ,PRSO ,WINNER>
	       <TELL "You must think you're a contortionist!" CR>)
	      (ELSE <HAR-HAR>)>>

<ROUTINE PRE-EXAMINE ("AUX" VAL)
	 <COND (<ROOM-CHECK> <RTRUE>)
	       (<==? ,P-ADVERB ,W?CAREFULLY>
		<COND (<NOT <SET VAL <INT-WAIT 3>>>
		       <TELL
"You never got to finish examining" HIM ,PRSO "." CR>)
		      (<==? .VAL ,M-FATAL> <RTRUE>)>)>>

<ROUTINE V-EXAMINE ("AUX" TXT P)
	 <COND (<DOBJ? INTDIR>
		<SETG CLOCK-WAIT T>
		<TELL
"(If you want to see what's there, face that way or go there!)" CR>)
	       (<DOBJ? HEAD HANDS>
		<NOTHING-SPECIAL>)
	       (<AND <IN? ,PRSO ,GLOBAL-OBJECTS>
		     <NOT <CORRIDOR-LOOK ,PRSO
			  ;<GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>>>
		<NOT-HERE ,PRSO>
		<RTRUE>)
	       (<IN? ,PRSO ,ROOMS>	;<FSET? ,PRSO ,RLANDBIT>
		<ROOM-PEEK ,PRSO>)
	       (<NOT <EQUAL? <META-LOC ,PRSO> ,HERE ,LOCAL-GLOBALS>>
		<TOO-BAD-BUT ,PRSO "too far away">)
	       (<SET TXT <GETP ,PRSO ,P?TEXT>>
		<TELL .TXT CR>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    ;<FSET? ,PRSO ,DOORBIT>
		    ;<FSET? ,PRSO ,WINDOWBIT>>
		<V-LOOK-INSIDE>)
	       ;(<FSET? ,PRSO ,ON?BIT> <CHECK-ON-OFF>)
	       (<FSET? ,PRSO ,DOORBIT> <CHECK-DOOR ,PRSO>)
	       (T
		<NOTHING-SPECIAL>)>>

<ROUTINE NOTHING-SPECIAL ()
	<TELL "Yup. That's " A ,PRSO ", all right." CR>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" TBL)
	 <COND (<SET TBL <GETPT .OBJ2 ,P?GLOBAL>>
		%<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
			'<ZMEMQ  .OBJ1 .TBL <RMGL-SIZE .TBL>>)
		       (T
			'<ZMEMQB .OBJ1 .TBL <RMGL-SIZE .TBL>>)>)>>

<ROUTINE V-$FACE ()
 <COND (<NOT ,PLAYER-NOT-FACING>
	<TELL "0" CR>)
       (T
	<TELL "not ">
	<DIR-PRINT ,PLAYER-NOT-FACING>
	<CRLF>)>>

<ROUTINE V-FACE ("AUX" P)
	<COND (<NOT ,P-WALK-DIR>
	       <SETG CLOCK-WAIT T>
	       <TELL "(I can't figure out what direction that is.)" CR>
	       <RFATAL>)
	      (<NOT <SET P <COMPASS-EQV ,HERE ,PRSO>>>
	       <SETG CLOCK-WAIT T>
	       <TELL "(You can't face that way!)" CR>
	       <RFATAL>)>
	;<SETG PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>
	<SETG PLAYER-NOT-FACING <OPP-DIR .P>>
	<TELL "Okay, you're now facing to ">
	<DIR-PRINT .P>
	<TELL "." CR>
	<COND (<GETP ,HERE ,P?CORRIDOR>
	       <CORRIDOR-LOOK>)>
	<RTRUE>>

<ROUTINE V-FAINT ()
	<TELL "As you wish.">
	<UNCONSCIOUS-FCN ;<+ 9 <RANDOM 6>>>>

<ROUTINE PRE-FILL ()
 <COND (<AND ,PRSI ;<NOT <EQUAL? ,PRSI ,GLOBAL-WATER>>>
	<HAR-HAR>)>>

<ROUTINE V-FILL ()
	 <TELL "You may know how to do that, but this story doesn't." CR>>

<ROUTINE PRE-FIND ("AUX" CHR)
	 <COND (<DOBJ? PLAYER> <RFALSE>)>
	 <COND (<IN? ,PRSO ,ROOMS>
		<COND (<==? ,PRSO ,HERE>
		       <ALREADY ,PLAYER "here">)
		      (<FSET? ,PRSO ,TOUCHBIT>
		       <TELL "You should know - you've been there!" CR>)
		      (T
		       <TELL "You'll have to figure that out." CR>)>)
	       (<SET CHR <GETP ,PRSO ,P?CHARACTER>> ;<FSET? ,PRSO ,PERSONBIT>
		;<COND (<IN? ,PRSO ,GLOBAL-OBJECTS>
		       <SETG PRSO <GET ,CHARACTER-TABLE .CHR>>)>
		<COND (<AND <==? <META-LOC ,WINNER> <META-LOC ,PRSO>>
			    <NOT <FSET? ,PRSO ,NDESCBIT>>>
		       <BITE-YOU>
		       <RTRUE>)
		      (T ;<OR <NOT <LOC ,PRSO>> <FAR-AWAY? <LOC ,PRSO>>>
		       <WHO-KNOWS? ,PRSO>
		       <RTRUE>)>)>>

<ROUTINE BITE-YOU ()
	<TELL "If" HE ,PRSO " were any closer," HE ,PRSO "'d bite you!" CR>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL "You're right here, ">
		<TELL-LOCATION>
		<CRLF>)
	       (<HELD? ,PRSO>
		<TELL "You have it." CR>)
	       (<OR <AND <EQUAL? .L ,LOCAL-GLOBALS>
			 <GLOBAL-IN? ,PRSO ,HERE>>
		    <AND <EQUAL? <META-LOC ,PRSO> ,HERE>
			 <VISIBLE? ,PRSO>>
		    ;<IN? ,PRSO ,HERE>
		    ;<==? ,PRSO ,PSEUDO-OBJECT>>
		<TELL "It's right here." CR>)
	       (<AND <NOT <FSET? ,PRSO ,TOUCHBIT>>
		     <OR <IN? ,PRSO ,ROOMS> <FSET? ,PRSO ,PERSONBIT>>
		     <NOT <FSET? ,PRSO ,SEENBIT>>>
		;<NOT-HERE ,PRSO>
		<TELL "You can't see any " D ,PRSO " here." CR>)
	       (<OR <EQUAL? .L ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>
		    <EQUAL? .L ,UNDER-SEAT-1 ,UNDER-SEAT-2 ,UNDER-SEAT-3>
		    <EQUAL? .L ,UNDER-SEAT-4 ,UNDER-SEAT-5>>
		<TELL "It's around somewhere." CR>)
	       (<FAR-AWAY? <META-LOC ,PRSO>>
		<TELL "It's far away from here." CR>)
	       (<FSET? .L ,PERSONBIT>
		<TELL CTHE .L " probably has it." CR>)
	       (<FSET? .L ,SURFACEBIT>
		<TELL "It's probably on" THE .L "." CR>)
	       (<OR <FSET? .L ,CONTBIT>
		    <IN? .L ,ROOMS>>
		<TELL "It's probably in" THE .L "." CR>)
	       (ELSE
		<TELL "It's nowhere in particular." CR>)>>

<ROUTINE V-FIND-WITH () <V-FIND>>

<ROUTINE V-FIX () <MORE-SPECIFIC>>

;<ROUTINE () <TELL "Whatever do you have in mind?" CR>>

<ROUTINE V-FLUSH ()
 <COND (<GLOBAL-IN? ,TOILET ,HERE>
	<PERFORM ,V?FLUSH ,PRSO ,TOILET>
	<RTRUE>)
       (T <TELL "You look around for a toilet but find none." CR>)>>

<ROUTINE V-FLUSH-AWAY () <V-FLUSH>>

<ROUTINE V-FLUSH-DOWN () <V-FLUSH>>

<ROUTINE V-FOLLOW ("AUX" CN CHR COR PCOR L)
	 <COND (<==? ,PRSO ,PLAYER>
		<NOT-CLEAR-WHOM>)
	       (<NOT <SET CN <GETP ,PRSO ,P?CHARACTER>>
		     ;<FSET? ,PRSO ,PERSONBIT>>
		<TELL
"How tragic to see a would-be spy stalking " A ,PRSO "!" CR>)
	       (<==? ,HERE
		     <SET L <META-LOC <SET CHR <GET ,CHARACTER-TABLE .CN>>>>>
		<TELL "You're in the same place as" HE ,PRSO "!" CR>)
	       (<OR <NOT .L> ;<==? .L ,LIMBO>>
		<TELL CTHE ,PRSO " has left the story." CR>)
	       (T
		<PERFORM ,V?WALK-TO .CHR>
		<RTRUE>)>>

<ROUTINE V-FOO ()
	 <TELL "[Foo!! This is a bug!!]" CR>>

<ROUTINE PRE-GESTURE ()
	<PERFORM ,V?MAKE ,GESTURE ,PRSO>
	<RTRUE>>

<ROUTINE V-GESTURE () <V-FOO>>

<ROUTINE PRE-GIVE ()
	 <COND (<OR <AND <FSET? ,PRSO ,PERSONBIT>
			 <NOT <FSET? ,PRSO ,MUNGBIT>>>
		    <DOBJ? GLOBAL-MONEY>>
		<MORE-SPECIFIC>)
	       (<AND ,P-DOLLAR-FLAG <DOBJ? INTNUM>>
		<COND (<G? ,P-AMOUNT <GETP ,PLAYER ,P?SOUTH>>
		       <TELL "You don't have that much." CR>)>)
	       (<AND <NOT <HELD? ,PRSO>> <NOT <EQUAL? ,PRSI ,PLAYER>>>
		<TELL "That's easy for you to say, since ">
		;<HE-SHE-IT ,WINNER <> "is"> 
		<TELL HE ,WINNER is "n't holding" HIM ,PRSO "." CR>)>>

<ROUTINE V-GIVE ()
	 <COND (<NOT ,PRSI> <YOU-CANT ;"give">)
	       (<NOT <FSET? ,PRSI ,PERSONBIT>>
		<TELL "You can't give " A ,PRSO " to " A ,PRSI "!" CR>)
	       (<FSET? ,PRSI ,MUNGBIT>
		<TELL CHE ,PRSI do "n't respond." CR>)
	       (<IOBJ? PLAYER>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<TELL CTHE ,PRSI " accepts the offer." CR>)>>

<ROUTINE PRE-SGIVE () <PERFORM ,V?GIVE ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SGIVE () <V-FOO>>

<ROUTINE PRE-GOODBYE () <PRE-HELLO>>

<ROUTINE V-GOODBYE () <V-HELLO <>>>

<ROUTINE PRE-HANGUP ()
 <COND (<NOT <DOBJ? ROOMS ;TELEPHONE>>
	<TOO-BAD-BUT ,PRSO "not wired for phoning">)>>

<ROUTINE V-HANGUP ()
 <COND ;(,REMOTE-PERSON
	<PERFORM ,V?GOODBYE>
	<RTRUE>)
       (T <TELL "You're not talking to anyone!" CR>)>>

<ROUTINE PRE-HEAT () <PRE-BURN>>

<ROUTINE V-HEAT () <TELL CHE ,PRSO " gets a little bit hotter." CR>>

<ROUTINE PRE-HELLO ("AUX" P)
 <COND (,PRSO <UNSNOOZE ,PRSO> <RFALSE>)
       (<QCONTEXT-GOOD?>
	<PERFORM ,PRSA ,QCONTEXT>
	<RTRUE>)
       (<AND <EQUAL? ,WINNER ,PLAYER>
	     <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	     <NOT <FSET? .P ,INVISIBLE>>>
	<TELL ,I-ASSUME " hello " D .P ".)" CR>
	<PERFORM ,PRSA .P>
	<RTRUE>)
       (T <NOT-CLEAR-WHOM>)>>

<ROUTINE V-HELLO ("OPTIONAL" (HELL T))
 <COND (<GETP ,PRSO ,P?CHARACTER>
	<COND (<AND <FSET? ,PRSO ,PERSONBIT> <NOT <FSET? ,PRSO ,MUNGBIT>>>
	       <TELL CHE ,PRSO nod " at you." CR>)
	      (T <WONT-HELP-TO-TALK-TO ,PRSO>)>)
       (,PRSO
	<TELL "Only nuts say \""
		<COND (.HELL "Hello") (T "Good-bye")>
		"\" to " A ,PRSO "." CR>)
       (T <NOT-CLEAR-WHOM>)>>

<ROUTINE V-HELP ()
 <COND (<EQUAL? ,PRSO <> ,PLAYER>
	<HELP-TEXT>)
       (T <MORE-SPECIFIC>)>>

<ROUTINE HELP-TEXT ()
	<SETG CLOCK-WAIT T>
	<TELL
"(You'll find plenty of help in your " D ,GAME " package.|
If you're really stuck, you can order an InvisiClues (TM) hint booklet and map
from your dealer or via mail with the form in your package.)" CR>>

<ROUTINE V-HIDE ()
	 <COND ;(<EQUAL? ,HERE ,OFFICE>
		<TELL "You could hide behind the lounge." CR>)
	       (T <TELL "There's no good hiding place here." CR>)>>

<ROUTINE V-HIDE-BEHIND ()
 <COND (<FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>
	<TELL "As you start to hide">
	<COND (,PRSI <HIM-HER-IT ,PRSO>)>
	<TELL ", you realize that someone may be watching you." CR>)
       ;(<DOBJ? LOUNGE>
	<SETG PLAYER-HIDING ,PRSO>
	;<SETG PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>
	<SETG PLAYER-NOT-FACING <>>
	<TELL "Okeh, you're now crouching down behind the lounge." CR>)
       (T
	<TELL "There's no room to hide">
	<COND (,PRSI <HIM-HER-IT ,PRSO>)>
	<TELL " behind">
	<COND (,PRSI <HIM-HER-IT ,PRSI>) (T <HIM-HER-IT ,PRSO>)>
	<TELL "." CR>)>>

<ROUTINE PRE-HOLD-OVER () <PERFORM ,V?HOLD-UNDER ,PRSI ,PRSO> <RTRUE>>
<ROUTINE V-HOLD-OVER () <V-FOO>>

<ROUTINE V-HOLD-UNDER ("AUX" X)
	<COND (<SET X <ANYONE-VISIBLE?>>
	       <UNSNOOZE .X>
	       <TELL CHE .X applaud " sarcastically for your feat." CR>)
	      (T <TELL "Nothing happens." CR>)>>

;<ROUTINE V-KICK () <HACK-HACK "Kicking">>

<ROUTINE V-KILL () <IKILL "kill">>

<ROUTINE IKILL (STR)
	 <COND (<NOT ,PRSO> <TELL "There's nothing here to " .STR "." CR>)
	       (<AND <NOT ,PRSI> <FSET? ,PRSO ,WEAPONBIT>>
		<TELL "You didn't say what to " .STR " at." CR>)
	       (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<HAR-HAR>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<TELL "You can't do it from here." CR>)
	       (T <TELL
"You think it over. It's not worth the hassle." CR>)>>

<ROUTINE V-KISS ()
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT> <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<FACE-RED "kiss">)
	       (T <TELL "What a (ahem!) strange idea!" CR>)>>

<ROUTINE V-KNOCK ("AUX" P)
 <COND (<OR <FSET? ,PRSO ,DOORBIT>
	    <FSET? ,PRSO ,WINDOWBIT>>
	<COND (<SET P <FIND-FLAG <DOOR-ROOM ,HERE ,PRSO> ,PERSONBIT ,PLAYER>>
	       <UNSNOOZE .P>
	       <TELL "Someone shouts, ">
	       <PRODUCE-GIBBERISH>)
	      (T <TELL "There's no answer." CR>)>)
       (ELSE
	<TELL "Why knock on " A ,PRSO "?" CR>)>>

<ROUTINE V-STAND ("AUX" P)
	 <COND (,PLAYER-SEATED
		;<MOVE ,WINNER ,HERE>
		<SETG PLAYER-SEATED <>>
		<TELL "You're on your own feet again." CR>)
	       (T
		<ALREADY ,PLAYER "standing up">)>>

<ROUTINE V-LEAP ()
	 <COND (<AND ,PRSO
		     <NOT <DOBJ? INTDIR>>>
		<PERFORM ,V?BOARD ,PRSO>
		<RTRUE>)
	       (<GETPT ,HERE ,P?DOWN>
		<TELL "This was not a very safe place to try jumping.">
		<FINISH>)
	       (T <V-SKIP>)>>

<ROUTINE V-SKIP ()
	 <COND (<FSET? <LOC ,PLAYER> ,VEHBIT>
		<TELL "That would be tough from your current position." CR>)
	       (T <WHEE>)>>

<ROUTINE WHEE ("AUX" X)
	<SET X <RANDOM 5>>
	<COND (<==? 1 .X>
	       <TELL "Very good. Now you can go to the second grade." CR>)
	      (<==? 2 .X>
	       <TELL "I hope you enjoyed that more than I did." CR>)
	      (<==? 3 .X>
	       <TELL "Are you enjoying yourself?" CR>)
	      (<==? 4 .X>
	       <TELL "Wheeeeeeeeee!!!!!" CR>)
	      (T <TELL "Do you expect someone to applaud?" CR>)>>

<ROUTINE V-LEARN () <YOU-CANT>>

<ROUTINE V-LEAVE ()
 <COND (<EQUAL? <LOC ,PRSO> ,PLAYER ,POCKET>
	<PERFORM ,V?DROP ,PRSO>
	<RTRUE>)
       (<AND ,PRSO <NOT <==? <LOC ,WINNER> ,PRSO>>>
	<TELL "You're not in" HIM ,PRSO "!" CR>
	<RFATAL>)
       (<AND ,ON-TRAIN
	     <OR ;<NOT ,PRSO> <EQUAL? ,PRSO ,TRAIN>>>
	<PERFORM ,V?WALK-TO ,PLATFORM-GLOBAL>
	<RTRUE>)
       (T <DO-WALK ,P?OUT> <RTRUE>)>>

<ROUTINE PRE-LIE () <ROOM-CHECK>>

<ROUTINE V-LIE () <V-SIT T>>

<ROUTINE V-LISTEN ()
 <COND (<AND <FSET? ,PRSO ,PERSONBIT> <NOT <FSET? ,PRSO ,MUNGBIT>>>
	<WAITING-FOR-YOU-TO-SPEAK>
	<RTRUE>)
       (T
	<TOO-BAD-BUT ,PRSO>
	<TELL V ,PRSO make " no sound." CR>)>>

<ROUTINE V-LOCK ()
 <COND (<FSET? ,PRSO ,DOORBIT>
	<COND (<OR <ZMEMQ ,HERE ,CAR-ROOMS-COMPS>
		   <ZMEMQ ,HERE ,CAR-ROOMS-REST>>
	       <COND (<FSET? ,PRSO ,OPENBIT>
		      <FCLEAR ,PRSO ,OPENBIT>
		      <TELL "(You close" HIM ,PRSO " first.)" CR>)>
	       <OKAY ,PRSO "locked">)
	      (T
	       <TELL "You search for a way to lock it ">
	       <COND (<NOT <DOBJ? VESTIBULE-FWD-DOOR VESTIBULE-REAR-DOOR>>
		      <TELL "from the outside ">)>
	       <TELL "but find none." CR>)>)
       (T <YOU-CANT>)>>

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS T>
		<CRLF>)>>

<ROUTINE V-LOOK-BEHIND ()
 <COND (<AND <FSET? ,PRSO ,DOORBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
	<TOO-BAD-BUT ,PRSO "closed">)
       (T <TELL "There's nothing behind" HIM ,PRSO "." CR>)>>

<ROUTINE V-LOOK-DOWN ()
 <COND (<==? ,PRSO ,ROOMS>
	<COND (<==? ,P-ADVERB ,W?CAREFULLY>
	       <PERFORM ,V?SEARCH ,FLOOR>
	       <RTRUE>)
	      (T <TELL
"A quick look reveals nothing interesting " <GROUND-DESC> "." CR>)>)
       (T <HAR-HAR>)>>

<ROUTINE PRE-LOOK-INSIDE () <ROOM-CHECK>>

<ROUTINE V-LOOK-INSIDE ("OPTIONAL" (DIR ,P?IN) "AUX" RM)
	 <COND (<DOBJ? ROOMS>
		<COND (<==? .DIR ,P?OUT>
		       <COND (<SET RM <FIND-FLAG-LG ,HERE ,WINDOWBIT>>
			      <TELL ,I-ASSUME THE .RM ;" a window" ".)" CR>
			      <PERFORM ,PRSA .RM ,PRSI>
			      <RTRUE>)>)
		      (T
		       <COND (<OR <SET RM <FIND-FLAG-LG ,HERE ,CONTBIT>>
				  <SET RM <FIND-FLAG-LG ,HERE ,WINDOWBIT>>
				  <SET RM <FIND-FLAG-LG ,HERE ,DOORBIT>>>
			      <TELL ,I-ASSUME THE .RM ".)" CR>
			      <PERFORM ,PRSA .RM ,PRSI>
			      <RTRUE>)>)>)>
	 <COND (<DOBJ? GLOBAL-HERE>
		<PERFORM ,V?LOOK>
		<RTRUE>)
	       (<IN? ,PRSO ,ROOMS>	;<FSET? ,PRSO ,RLANDBIT>
		<ROOM-PEEK ,PRSO>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<NOT <SEE-INSIDE? ,PRSO T>>
		       <FSET ,PRSO ,OPENBIT>
		       <TELL "(You open" HIM ,PRSO " first.)" CR>)>
		<COND (<AND <FIRST? ,PRSO> <PRINT-CONT ,PRSO>>
		       <RTRUE>)
		      (T <TOO-BAD-BUT ,PRSO "empty">)>)
	       (<FSET? ,PRSO ,SURFACEBIT>
		<COND (<AND <FIRST? ,PRSO> <PRINT-CONT ,PRSO>>
		       <RTRUE>)
		      (T <TELL "There's nothing on" HIM ,PRSO "."CR>)>)
	       (<V-LOOK-THROUGH T> <RTRUE>)
	       (<==? .DIR ,P?IN> <YOU-CANT "look inside">)
	       (T ;<==? .DIR ,P?OUT> <YOU-CANT "look outside">)>>

<ROUTINE V-LOOK-THROUGH ("OPTIONAL" (INSIDE <>) "AUX" RM)
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<OR <FSET? ,PRSO ,OPENBIT> <FSET? ,PRSO ,TRANSBIT>>
		       <COND (<SET RM <DOOR-ROOM ,HERE ,PRSO>>
			      <ROOM-PEEK .RM T>)
			     (T <TELL
"You can't tell what's beyond" HIM ,PRSO "." CR>)>)
		      (T
		       <TOO-BAD-BUT ,PRSO "closed">)>)
	       (<FSET? ,PRSO ,WINDOWBIT>
		<COND ;(<SET RM <WINDOW-ROOM ,HERE ,PRSO>>
		       <ROOM-PEEK .RM T>)
		      (T <TELL
"You can't tell what's beyond" HIM ,PRSO "." CR>)>)
	       (<FSET? ,PRSO ,PERSONBIT>
		<TELL "You forgot to bring your X-ray glasses." CR>)
	       (.INSIDE <RFALSE>)
	       (T <YOU-CANT "look through">)>>

<ROUTINE ROOM-PEEK (RM "OPTIONAL" (SAFE <>) "AUX" (X <>) OLD-HERE TXT)
	 <SET OLD-HERE ,HERE>
	 <COND (<OR .SAFE <SEE-INTO? .RM>>
		<COND (<AND <NOT ,PLAYER-SEATED>
			    <NOT ,PLAYER-HIDING>
			    <SET TXT <COMPASS-EQV ,HERE<DIR-FROM ,HERE .RM>>>>
		       <SETG PLAYER-NOT-FACING <OPP-DIR .TXT>>)>
		<SETG HERE .RM>
		<TELL "You take a quick peek into" HIM .RM ":" CR>
		<COND (<NOT <==? ,PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>>
		       <TELL "[You're facing to ">
		       <DIR-PRINT <OPP-DIR ,PLAYER-NOT-FACING>>
		       <TELL ".]" CR>)>
		<COND (<DESCRIBE-OBJECTS T> <SET X T>)
		      (<SET TXT <GETP .RM ,P?LDESC>>
		       <SET X T>
		       <TELL .TXT CR>)>
		;<COND (<CORRIDOR-LOOK> <SET X T>)>
		<COND (<NOT .X>
		       <TELL "You can't see anything interesting." CR>)>
		<SETG HERE .OLD-HERE>)>>

<ROUTINE SEE-INTO? (THERE "AUX" P L TBL O)
	 <SET P 0>
	 <REPEAT ()
		 <COND (<0? <SET P <NEXTP ,HERE .P>>>
			<TELL
"You can't seem to find that room." CR>
			<RFALSE>)
		       ;(<EQUAL? .P ,P?IN ,P?OUT> <RTRUE>)
		       (<NOT <L? .P ,LOW-DIRECTION>>
			<SET TBL <GETPT ,HERE .P>>
			<SET L <PTSIZE .TBL>>
			<COND (<AND <==? .L ,UEXIT>
				    <==? <GET-REXIT-ROOM .TBL> .THERE>>
			       <RTRUE>)
			      (<AND <==? .L ,DEXIT>
				    <==? <GET-REXIT-ROOM .TBL> .THERE>>
			       <COND (<FSET? <GET-DOOR-OBJ .TBL> ,OPENBIT>
				      <RTRUE>)
				     (T
				      <TELL
"(The door to that room is closed.)" CR>
				      <RTRUE ;RFALSE>)>)
			      (<AND <==? .L ,CEXIT>
				    <==? <GET-REXIT-ROOM .TBL> .THERE>>
			       <COND (<VALUE <GETB .TBL ,CEXITFLAG>>
				      <RTRUE>)
				     (T
				      <TELL
"You can't seem to find that room." CR>
				      <RFALSE>)>)>)>>>

<ROUTINE V-LOOK-ON ()
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<V-LOOK-INSIDE>)
	       (T <TELL "There's no good surface on" HIM ,PRSO "." CR>)>>

<ROUTINE V-LOOK-OUTSIDE () <V-LOOK-INSIDE ,P?OUT>>

<ROUTINE V-LOOK-UNDER ()
	 <COND (<HELD? ,PRSO>
		<COND (<FSET? ,PRSO ,WORNBIT>
		       <TELL "You're wearing it!" CR>)
		      (T
		       <TELL "You're holding it!" CR>)>)
	       (<FSET? ,PRSO ,PERSONBIT>
		<TELL "Nope. Nothing hiding under" HIM ,PRSO "." CR>)
	       (<EQUAL? <LOC ,PRSO> ,HERE ,LOCAL-GLOBALS ;,GLOBAL-OBJECTS>
		<TELL "There's nothing there but dust." CR>)
	       (T
		<TELL "That's not a bit useful." CR>)>>

<ROUTINE V-LOOK-UP ("AUX" HR)
	 <COND (,PRSI
		<TELL "There's no information in" HIM ,PRSI " about that."CR>)
	       (<DOBJ? ROOMS>
		<COND (<OUTSIDE? ,HERE>
		       <SET HR <MOD </ ,PRESENT-TIME 60> 24>>
		       <COND (<AND <G? .HR 6> <L? .HR 18>>
			      <TELL "The sun">)
			     (T <TELL "The moon">)>
		       <TELL " is shining with all its might." CR>)
		      (<ZMEMQ ,HERE ,STATION-ROOMS>
		       <COND (<ON-PLATFORM? ,HERE>
			      <TELL "The overhanging roof">)
			     (T <TELL "The ceiling">)>
		       <TELL
" is constructed on a grand scale, with crossed beams and numerous
chandeliers." CR>)
		      (T <TELL
"The ceiling has seen better years, but a little soot removal would do
wonders." CR>)>)
	       (<IN? ,TIMETABLE ,WINNER>
		<PERFORM ,V?LOOK-UP ,PRSO ,TIMETABLE>
		<RTRUE>)
	       (T
		<TELL "Huh? Without the " D ,TIMETABLE "?" CR>
		<RTRUE>)>>

<ROUTINE V-MAKE ()
	<TELL
"\"Eat, drink, and make merry, for tomorrow we shall die!\"" CR>>

<ROUTINE PRE-MOVE ()
	 <COND (<HELD? ,PRSO>
		<TELL "Juggling isn't one of your talents." CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving" HIM ,PRSO " reveals nothing." CR>)
	       (T <YOU-CANT ;"move">)>>

<ROUTINE PRE-MOVE-DIR ()
 <COND ;(<IOBJ? INTDIR OFF SLOW MEDIUM FAST> <RFALSE>)
       (T
	<SETG CLOCK-WAIT T>
	<TELL "(Sorry, but I don't understand that sentence.)" CR>)>>

<ROUTINE V-MOVE-DIR ()
	<TELL "You can't move" HIM ,PRSO " in any particular direction." CR>>

<ROUTINE V-NOD () <YOU-CANT>>

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <FSET? ,PRSO ,WINDOWBIT>>>
		<YOU-CANT ;"open">)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,WINDOWBIT>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<OR <FSET? ,PRSO ,LOCKED>
			   >
		       <COND (<AND <NOT <ZMEMQ ,HERE ,CAR-ROOMS-COMPS>>
				   <NOT <ZMEMQ ,HERE ,CAR-ROOMS-REST>>>
			      <TOO-BAD-BUT ,PRSO "locked">
			      <RTRUE>)
			     (T
			      <FCLEAR ,PRSO ,LOCKED>
			      <TELL "(You unlock" HIM ,PRSO " first.)" CR>)>)>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <ALREADY ,PRSO "open">)
		      (<FSET? ,PRSO ,MUNGBIT>
		       <TELL
"You can't open it. The latch is broken." CR>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<OR <FSET? ,PRSO ,DOORBIT>
				  <FSET? ,PRSO ,WINDOWBIT>
				  <NOT <FIRST? ,PRSO>>
				  <FSET? ,PRSO ,TRANSBIT>>
			      <OKAY ,PRSO "open">)
			     (<AND <SET F <FIRST? ,PRSO>>
				   <NOT <NEXT? .F>>
				   <SET STR <GETP .F ,P?FDESC>>>
			      <TELL "You open" HIM ,PRSO "." CR>
			      <TELL .STR CR>)
			     (T
			      <TELL "You open" HIM ,PRSO " and see ">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL "." CR>)>)>)
	       (T <YOU-CANT ;"open">)>>

<ROUTINE PRE-OPEN-WITH ()
 <COND (<NOT-HOLDING? ,PRSI> <RTRUE>)>>

<ROUTINE V-OPEN-WITH () <PERFORM ,V?OPEN ,PRSO> <RTRUE>>

<ROUTINE V-PASS () <PERFORM ,V?WALK-TO ,PRSO> <RTRUE>>

<ROUTINE PRE-PHOTO ()
	<COND (<AND ,PRSI <NOT <==? ,PRSI ,CAMERA>>>
	       <HAR-HAR>
	       <RTRUE>)
	      (<NOT-HOLDING? ,CAMERA>
	       <RTRUE>)
	      (<FSET? ,CAMERA ,OPENBIT>
	       <TOO-BAD-BUT ,CAMERA "open">
	       <RTRUE>)
	      (,LENS-CRACKED
	       <TELL "The lens is cracked." CR>
	       <RTRUE>)
	      (<OR <NOT <EQUAL? <LOC ,FILM> ,CAMERA>>
		   <NOT ,CAMERA-COCKED>>
	       <TELL "You push the button, but it won't move." CR>
	       <RTRUE>)>>

<ROUTINE TAKE-PICTURE (OBJ)
	<COND (<EQUAL? .OBJ ,PLAYER>
	       <SETG LENS-CRACKED T>
	       <SET OBJ ,GLOBAL-OBJECTS>
	       <TELL 
"This camera was designed to work on the ocean floor or in outer space, in
arctic cold or tropical heat. It has photographed nuclear explosions without
the slightest difficulty. Your face, however, has cracked its lens!" CR>)>
	<SETG CAMERA-COCKED <>>
	<COND (<AND <==? .OBJ ,MCGUFFIN> <FSET? ,MCGUFFIN ,LOCKED>>
	       <FSET ,FILM ,LOCKED>)>	;"altered!"
	<PUT ,FILM-TBL ,PICTURE-NUMBER .OBJ>>

<ROUTINE V-PHOTO ()
 <COND (<DOBJ? CAMERA FILM>
	<HAR-HAR>)
       (T
	<TAKE-PICTURE ,PRSO>
	<TELL "\"Click!\"" CR>
	<RTRUE>)>>

<ROUTINE V-PLAY ()
	 <SETG CLOCK-WAIT T>
	 <TELL
"(Speaking of playing, you ought to try Infocom's other products, too!)" CR>>

<ROUTINE PRE-POCKET () <PERFORM ,V?PUT-IN ,PRSO ,POCKET> <RTRUE>>
<ROUTINE   V-POCKET () <V-FOO>>

<ROUTINE V-POUR () <YOU-CANT>>

<ROUTINE V-PUSH () <HACK-HACK "Pushing">>

<ROUTINE PRE-PUT ()
	 <COND (<DOBJ? GLOBAL-MONEY>
		<TELL ,I-ASSUME>
		<PRINTC 32>
		<PRINTC ,CURRENCY-SYMBOL>
		<TELL "1.)" CR>
		<SETG P-DOLLAR-FLAG T>
		<SETG P-AMOUNT 1>
		<RFALSE>)
	       (<HELD? ,PRSO>
		<RFALSE>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<YOU-CANT "pick up">)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (<IOBJ? FLOOR GLOBAL-HERE ;GLOBAL-WATER ;POCKET>
		<RFALSE>)
	       (<IN? ,PRSI ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSI>)>>

<ROUTINE PRE-SPUT-IN () <PERFORM ,V?PUT-IN ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SPUT-IN () <V-FOO>>

<ROUTINE PRE-PUT-IN ()
 <COND (<AND <IOBJ? WINE-RED WINE-WHITE> <EQUAL? <LOC ,PRSI> ,CUP-A ,CUP-B>>
	<PRE-PUT> ;<SETG PRSI ,CUP>)
       (<AND <IOBJ? FOOD> ;<EQUAL? <LOC ,PRSI> ,CUP-A ,CUP-B>>
	<PRE-PUT> ;<SETG PRSI ,CUP>)
       (<IOBJ? CHAIR>
	<PRE-PUT>)
       (<NOT <FSET? ,PRSI ,CONTBIT>>
	<TELL "You search for an opening in" HIM ,PRSI " but find none." CR>)
       (<NOT <FSET? ,PRSI ,OPENBIT>>
	<TOO-BAD-BUT ,PRSI "closed">)
       (T
	<PRE-PUT>)>>

<ROUTINE V-PUT-IN () <V-PUT>>

<ROUTINE V-PUT ()
	 <COND (<IOBJ? PLAYER>
		<PERFORM ,V?WEAR ,PRSO>
		<RTRUE>)
	       (<IOBJ? FOOD WINE-RED WINE-WHITE>
		T)
	       (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,SURFACEBIT>>
		     <NOT <FSET? ,PRSI ,VEHBIT>>>
		<COND (<OPENABLE? ,PRSI>
		       <TOO-BAD-BUT ,PRSI "closed">)
		      (<NOT <FSET? ,PRSI ,SURFACEBIT>>
		       <TELL "There's no good surface on" HIM ,PRSI "." CR>)
		      (T <TELL "You can't open" HIM ,PRSI "." CR>)>
		<RTRUE>)>
	 <COND (<NOT ,PRSI> <YOU-CANT ;"put">)
	       (<==? ,PRSI ,PRSO>
		<HAR-HAR>)
	       (<IN? ,PRSO ,PRSI>
		<TOO-BAD-BUT ,PRSO>
		<TELL V ,PRSO is " already "
			<COND (<FSET? ,PRSI ,SURFACEBIT> "on") (T "in")>
			HIM ,PRSI "!" CR>)
	       ;(<AND <NOT <FSET? ,PRSI ,SURFACEBIT>>
		     <NOT <FSET? ,PRSI ,OPENBIT>>>
		<TOO-BAD-BUT ,PRSI "closed">)
	       (<G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
		       <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL "There's not enough room." CR>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <ITAKE>>>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<COND (<IOBJ? FOOD WINE-RED WINE-WHITE>
		       <FSET ,PRSO ,MUNGBIT>)>
		<TELL "Okay." CR>)>>

<ROUTINE V-PUT-UNDER ()
         <TELL "There's not enough room." CR>>

<ROUTINE V-RAISE () <PERFORM ,V?TAKE ,PRSO> <RTRUE>>

<GLOBAL LIT <>>

<ROUTINE PRE-READ ("AUX" VAL)
	 <COND (<NOT ,LIT> <TOO-DARK> <RTRUE>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (<AND ,PRSI
		     <NOT <FSET? ,PRSI ,TRANSBIT>>
		     <==? -1 ,P-NUMBER>>	;"? INTNUM?"
		<TELL
"You must have a swell method of looking through" HIM ,PRSI "." CR>)
	       (<==? ,P-ADVERB ,W?CAREFULLY>
		<COND (<NOT <SET VAL <INT-WAIT 3>>>
		       <TELL
"You never got to finish reading" HIM ,PRSO "." CR>)
		      (<==? .VAL ,M-FATAL> <RTRUE>)>)>>

<ROUTINE V-READ ()
	 <COND (<NOT <FSET? ,PRSO ,READBIT>> <YOU-CANT ;"read">)
	       (ELSE <TELL <GETP ,PRSO ,P?TEXT> CR>)>>

<ROUTINE V-REMOVE ()
	 <COND (<FSET? ,PRSO ,WEARBIT>
		<PERFORM ,V?TAKE-OFF ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-RING () <TELL "\"DING-DONG!\"" CR>>

<ROUTINE V-RIP () <YOU-CANT>>

<ROUTINE V-RISE ()
	<DO-WALK ,P?UP>
	<RTRUE>>

<ROUTINE V-RUB () <HACK-HACK "Fiddling with">>

<ROUTINE PRE-RUB-OVER ()
	 <PERFORM ,V?RUB ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-RUB-OVER () <V-FOO>>

<ROUTINE V-SAY ("AUX" P)
 <COND (<QCONTEXT-GOOD?>
	<PERFORM ,V?TELL ,QCONTEXT>
	<RTRUE>)
       (<OR <IN? <SET P ,CONTACT> ,HERE>
	    <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>>
	<TELL ,I-ASSUME " say to" THE .P ".)" CR>
	<PERFORM ,V?TELL .P>
	<RTRUE>)
       (T
	<NOT-CLEAR-WHOM>)>>

<ROUTINE PRE-SAY-INTO ()
 <COND ;(<DOBJ? INTERCOM> <RFALSE>)
       (<NOT <FSET? ,PRSO ,ONBIT>>
	<TELL "Sorry, but" HE ,PRSO is "n't on!" CR>)>>

<ROUTINE V-SAY-INTO () <YOU-CANT "talk into">>

<ROUTINE PRE-SEARCH () <ROOM-CHECK>>

<ROUTINE V-SEARCH ("AUX" OBJ)
	 <COND (<NOT <ZERO? <GETP ,PRSO ,P?CHARACTER>>>
		;<FSET? ,PRSO ,PERSONBIT>
		<COND (<SET OBJ <FIRST? ,PRSO>>
		       <FSET .OBJ ,TAKEBIT>
		       <FCLEAR .OBJ ,NDESCBIT>
		       <THIS-IS-IT .OBJ>
		       <MOVE .OBJ ,PLAYER>
		       <TELL "You find " A .OBJ " and take it." CR>)
		      (<SET OBJ <GETP ,PRSO ,P?SOUTH>>
		       <THIS-IS-IT ,GLOBAL-MONEY>
		       <PUTP ,PLAYER ,P?SOUTH<+ <GETP ,PLAYER ,P?SOUTH> .OBJ>>
		       <TELL "You find ">
		       <PRINTC ,CURRENCY-SYMBOL>
		       <TELL N .OBJ " and take it." CR>)
		      (T <TELL "You don't find anything interesting." CR>)>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<NOT <FSET? ,PRSO ,OPENBIT>>
		       <TOO-BAD-BUT ,PRSO "closed">
		       <RTRUE>)
		      (T
		       <PERFORM ,V?LOOK-INSIDE ,PRSO>
		       <RTRUE>)>)
	       (<AND <IN? ,BLOOD-SPOT ,PRSO>
		     <FSET? ,BLOOD-SPOT ,NDESCBIT>>
		<FCLEAR ,BLOOD-SPOT ,NDESCBIT>
		<TELL <GETP ,BLOOD-SPOT ,P?FDESC> CR>)
	       (T <TELL "You find nothing unusual." CR>)>>

<ROUTINE PRE-SSEARCH-FOR () <PERFORM ,V?SEARCH-FOR ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SSEARCH-FOR () <V-FOO>>

<ROUTINE PRE-SEARCH-FOR ("AUX" OBJ)
 <COND (<ROOM-CHECK> <RTRUE>)
       ;(<AND <IN? ,PRSI ,PLAYER>
	     ;<GETP ,PRSI ,P?GENERIC>
	     <SET OBJ <APPLY <GETP ,PRSI ,P?GENERIC> ,PRSI>>>
	<SETG PRSI .OBJ>)>
 <COND (<DOBJ? ;GLOBAL-ROOM GLOBAL-HERE>
	<SETG PRSO ,HERE>)>
 <RFALSE>>

<ROUTINE V-SEARCH-FOR ()
	 <COND (<FSET? ,PRSO ,PERSONBIT>
		<COND (<IN? ,PRSI ,PRSO>
		       <TELL "Indeed," HE ,PRSO has HIM ,PRSI "." CR>)
		      (T
		       <TELL CTHE ,PRSO V ,PRSO do "n't have">
		       <COND (<IN? ,PRSI ,GLOBAL-OBJECTS>
			      <TELL " " A ,PRSI "." CR>)
			     (<NOT ,PRSI>
			      <TELL " that." CR>)
			     (T
			      <TELL
HIM ,PRSI " concealed on" HIS ,PRSO " person." CR>)>)>)
	       (<AND <FSET? ,PRSO ,CONTBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
		<TELL "You'll have to open" HIM ,PRSO " first." CR>)
	       (<IN? ,PRSI ,PRSO>
		<TELL "How observant you are! There ">
		;<HE-SHE-IT ,PRSI <> "is">
		<TELL HE ,PRSI is "!" CR>)
	       (<NOT ,PRSI> <YOU-CANT ;"search">)
	       (T <TELL "You don't find" HIM ,PRSI " there." CR>)>>

<ROUTINE V-SEND () <YOU-CANT ;"send">>

<ROUTINE PRE-SSEND () <PERFORM ,V?SEND ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SSEND () <V-FOO>>

<ROUTINE V-SEND-OUT () <V-SEND>>

<ROUTINE PRE-SEND-TO ()
 <COND (<EQUAL? ,PRSI <> ,PLAYER ,GLOBAL-HERE>
	<RFALSE>)
       (<FSET? ,PRSO ,PERSONBIT>
	<PERFORM ,V?$CALL ,PRSO>
	<COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
	       <PERFORM ,V?WALK-TO ,PRSI>)>
	<RTRUE>)
       (T
	<SETG CLOCK-WAIT T>
	<TELL "(Sorry, but I don't understand.)" CR>)>>

<ROUTINE V-SEND-TO () <V-SEND>>

<ROUTINE V-SHAKE ("AUX" X)
	 <COND ;(<FSET? ,PRSO ,VILLAIN>
		<TELL "This seems to have no effect." CR>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<SETG CLOCK-WAIT T>
		<TELL "(You can't shake it if you can't take it!)" CR>)
	       (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
		     <FIRST? ,PRSO>>
		<TELL
"It sounds as if there is something inside" HIM ,PRSO "." CR>)
	       (<AND <FSET? ,PRSO ,OPENBIT> <SET X <FIRST? ,PRSO>>>
		<TELL "Onto the ">
		<COND (<EQUAL? ,HERE ,ROOF> <TELL "roof">)
		      (<EQUAL? ,HERE ,BESIDE-TRACKS> <TELL "ground">)
		      (T <TELL "floor">)>
		<TELL " spill">
		<COND (<ZERO? <NEXT? .X>> <TELL "s">)>
		<ROB ,PRSO ,HERE T>
	        <CRLF>)
	       (T <TELL "You hear nothing inside" HIM ,PRSO "." CR>)>>

<ROUTINE PRE-SHOOT ()
	<COND (<NOT ,PRSI>
	       <COND (<IN? ,CAMERA ,WINNER>
		      <SETG PRSI ,CAMERA>)
		     (<IN? ,GUN ,WINNER>
		      <SETG PRSI ,GUN>)>
	       <COND (,PRSI
		      <TELL "(with" THE ,PRSI ")" CR>)>)>
	<RFALSE>>

<ROUTINE V-SHOOT ()
 <COND (<AND <NOT <EQUAL? <LOC ,PRSI> ,WINNER ,POCKET>>
	     <NOT <FIND-FLAG ,WINNER ,WEAPONBIT>>
	     <NOT <FIND-FLAG ,POCKET ,WEAPONBIT>>>
	<TELL "You're not holding anything to shoot with." CR>)
       (T <IKILL "shoot">)>>

<ROUTINE PRE-SSHOOT () <PERFORM ,V?SHOOT ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SSHOOT () <V-FOO>>

<ROUTINE V-SHOW ()
	 <COND (<==? ,PRSO ,PLAYER>
		;<SETG L-WINNER ,WINNER>
		<SETG WINNER ,PLAYER>
		<COND (<VISIBLE? ,PRSO> <PERFORM ,V?EXAMINE ,PRSI>)
		      (T <PERFORM ,V?FIND ,PRSI>)>
		<RTRUE>)
	       (<OR <NOT <FSET? ,PRSO ,PERSONBIT>> <FSET? ,PRSO ,MUNGBIT>>
		<TELL "Don't wait for" HIM ,PRSO " to applaud." CR>)
	       (T <WHO-CARES>)>>

<ROUTINE PRE-SSHOW ("AUX" P)
  <COND (,PRSI
	 <SETG P-MERGED T>
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 <RTRUE>)
	(<NOT <HELD? ,PRSO>>
	 <COND (<FSET? <LOC ,PRSO> ,PERSONBIT>
		<PERFORM ,V?TAKE ,PRSO>)
	       (T
		<PERFORM ,V?ASK-CONTEXT-FOR ,PRSO>)>
	 <RTRUE>)
	(<QCONTEXT-GOOD?>
	 <PERFORM ,V?SHOW ,QCONTEXT ,PRSO>
	 <RTRUE>)
	(<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	 <TELL ,I-ASSUME " show" THE .P ".)" CR>
	 <PERFORM ,V?SHOW .P ,PRSO>
	 <RTRUE>)
	(T
	 <TELL ,I-ASSUME " show" THE ,PLAYER ".)" CR>
	 <PERFORM ,V?SHOW ,PLAYER ,PRSO>
	 <RTRUE>)>>

<ROUTINE V-SSHOW () <RTRUE>>

<ROUTINE V-SIGN () <TELL "You can't sign " A ,PRSO " with " A ,PRSI "!" CR>>

<ROUTINE PRE-SIT () <ROOM-CHECK>>

<ROUTINE V-SIT ("OPTIONAL" (LIE? <>))
 <COND (<OR <FSET? ,PRSO ,VEHBIT>
	    <AND <DOBJ? GLOBAL-HERE HERE FLOOR> ;<FSET? ,HERE ,SURFACEBIT>>>
	<SETG PLAYER-NOT-FACING <>>
	<TELL "You're now ">
	<COND (<ZERO? .LIE?>
	       <SETG PLAYER-SEATED ,PRSO>
	       <TELL "sitt">)
	      (T
	       <SETG PLAYER-SEATED <- 0 ,PRSO>>
	       <TELL "ly">)>
	<TELL "ing on" HIM ,PRSO "." CR>)
       (T <YOU-CANT>
	;<SETG CLOCK-WAIT T>
	;<TELL "(That won't help your mission!)" CR>)>>

<ROUTINE V-SIT-AT () <V-SIT>>

<ROUTINE V-SLAP ()
 <COND (<IOBJ? ROOMS> <SETG PRSI <>>)>
 <COND ;(<AND ,PRSI <NOT-HOLDING? ,PRSI>>
	<RTRUE>)
       (<DOBJ? PLAYER>
	<TELL
"That sounds like a sign that you could wear on your back." CR>)
       (<NOT <FSET? ,PRSO ,PERSONBIT>>
	<IF-SPY>)
       (<FSET? ,PRSO ,MUNGBIT>
	<TELL
"If" HE ,PRSO " could," HE ,PRSO " would slap you right back." CR>)
       (T <FACE-RED "slap">)>>

<ROUTINE IF-SPY ()
	;<COND (<NOT <FSET? ,PRSO ,PERSONBIT>> <TELL "break">)
	      (T <TELL "drop">)>
	<COND (<ZERO? ,PRSI>
	       <TELL "You give" HIM ,PRSO " a swift hand chop">)
	      (T <TELL "You swing" HIM ,PRSI " at" HIM ,PRSO>)>
	<THIS-IS-IT ,PRSO>
	<TELL ", but" HE ,PRSO " seems indestructible. If only you were a ">
	<COND (<SPY?> <TELL "better">) (T <TELL "real">)>
	<TELL " spy!" CR>>

<ROUTINE FACE-RED (STR)
	<UNSNOOZE ,PRSO>
	<HE-SHE-IT ,PRSO T "slap" ;.STR>
	<TELL " you right back. Wow, is your face red!" CR>>

<ROUTINE V-SLIDE () <YOU-CANT>>

<ROUTINE V-SMELL ()
	;<HE-SHE-IT ,PRSO T "smell">
	<TELL CHE ,PRSO smell " just like " A ,PRSO "!" CR>>

<ROUTINE V-SMILE ()
 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
	     <NOT <FSET? ,PRSO ,MUNGBIT>>
	     <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>>
	<TELL CHE ,PRSO smile " back at you." CR>)
       (T <HAR-HAR>)>>

<ROUTINE V-SMOKE () <YOU-CANT ;"burn">>

<ROUTINE V-STOP ()
	<COND (<EQUAL? ,PRSO <> ,GLOBAL-HERE>
	       <TELL "Hey, no problem." CR>)
	      (<FSET? ,PRSO ,PERSONBIT>
	       <PERFORM ,V?$CALL ,PRSO>
	       <RTRUE>)
	      (T
	       <PERFORM ,V?LAMP-OFF ,PRSO>
	       <RTRUE>)>>

<ROUTINE V-SWIM ()
	 <TELL "You can't swim ">
	 <COND (,PRSO
	        <TELL "in" HIM ,PRSO "." CR>)
	       (T
		<TELL <GROUND-DESC> "." CR>)>>

<ROUTINE PRE-TAKE ("AUX" L)
	 <SET L <LOC ,PRSO>>
	 <COND (<DOBJ? BRIEFCASE-LATCH BRIEFCASE-HANDLE>
		<SET L <LOC ,BRIEFCASE>>)>
	 <COND (<OR <AND ,P-DOLLAR-FLAG <DOBJ? INTNUM>>
		    <DOBJ? GLOBAL-MONEY DOLLARS>>
		<COND (<AND <EQUAL? ,PRSI <> ,POCKET>
			    <L? 0 <GETP ,PLAYER ,P?SOUTH>>>
		       <TELL-FLASHING-CASH>)>)
	       (<AND <DOBJ? FOOD-GLOBAL>
		     <EQUAL? ,HERE ,GALLEY ,CAFE>>
		<YOU-CANT>)
	       (<DOBJ? PICTURE-GLOBAL>
		<MORE-SPECIFIC>)
	       (<DOBJ? TRAIN>
		<RFALSE>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (<EQUAL? .L ,WINNER ;,POCKET>
		<SETG CLOCK-WAIT T>
		<TELL "(You already have it!)" CR>)
	       (<IN? ,WINNER ,PRSO>
		<TELL "You're in it, nitwit!" CR>)
	       (<AND .L
		     <FSET? .L ,CONTBIT>
		     <NOT <FSET? .L ,OPENBIT>>>
		<TOO-BAD-BUT .L "closed">
		<RTRUE>)
	       (,PRSI
		<COND (<EQUAL? ,PRSI ,POCKET .L>
		       <SETG PRSI <>>
		       <RFALSE>)
		      (<AND <NOT <FSET? ,PRSI ,SURFACEBIT>>
			    <NOT <FSET? ,PRSI ,OPENBIT>>
			    <ZERO? <GETP ,PRSI ,P?CHARACTER>>
			    ;<NOT <FSET? ,PRSI ,PERSONBIT>>>
		       <TOO-BAD-BUT ,PRSI "closed">
		       <RTRUE>)
		      (<NOT <==? ,PRSI .L>>
		       <COND (<NOT <FSET? ,PRSI ,PERSONBIT>>
			      <TELL CHE ,PRSO is " not in that!" CR>)
			     (T
			      <TELL
CHE ,PRSI do "n't have" HIM ,PRSO "!" CR>)>)>)
	       (T <PRE-TAKE-WITH>)>>

<ROUTINE PRE-TAKE-WITH ("AUX" X)
	 <COND (<DOBJ? YOU>
		<RFALSE>)
	       (<DOBJ? PICTURE-GLOBAL>
		<COND (<NOT-HOLDING? ,CAMERA>
		       <RTRUE>)
		      (T
		       <PERFORM ,V?PHOTO ,PRSI>
		       <RTRUE>)>)
	       (<AND <DOBJ? FOOD-GLOBAL>
		     <EQUAL? ,HERE ,GALLEY ,CAFE>>
		<YOU-CANT>)
	       (<AND <EQUAL? ,HERE ,CAFE>
		     <NOT <IN? ,PRSO ,ROOMS>>
		     <NOT <FSET? ,PRSO ,PERSONBIT>>
		     <G? <GETP ,PRSO ,P?NORTH> 0>>
		<TELL
CTHE ,WAITRESS " makes a gesture, asking for some money." CR>)
	       (<EQUAL? <META-LOC ,PRSO> ,GLOBAL-OBJECTS>
		<COND (<AND <NOT <HELD? ,PRSO>>
			    <NOT <FSET? ,PRSO ,PERSONBIT>>>
		       <NOT-HERE ,PRSO>)>)
	       (<IN? ,PRSO ,WINNER>
		<ALREADY ,PLAYER "holding it">)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<YOU-CANT "reach">)
	       (<==? ,PRSO <LOC ,WINNER>>
		<TELL "You're in it, nitwit!" CR>)>>

<ROUTINE V-TAKE ()
	 <COND (<==? <ITAKE> T>
		<COND (<DOBJ? KILLED-PERSON>
		       <TELL
"It's not easy, but you manage to throw" HIM ,PRSO " over your shoulder." CR>)
		      (T <TELL
CHE ,WINNER is " now holding" HIM ,PRSO "." CR>)>)>>

<ROUTINE V-TAKE-OFF ()
	 <COND (<FSET? ,PRSO ,WORNBIT>
		<FCLEAR ,PRSO ,WORNBIT>
		<TELL
"Okay," HE ,WINNER is " no longer wearing" HIM ,PRSO "." CR>)
	       (T
		<TELL "You aren't wearing that!" CR>)>>

<ROUTINE V-TAKE-TO ()	;"Parser should have ITAKEn PRSO."
	<PERFORM ,V?WALK-TO ,PRSI>
	<RTRUE>>

<ROUTINE V-TAKE-WITH ()
	<TELL "You can't remove" HIM ,PRSO " with" HIM ,PRSI "!" CR>>

<ROUTINE V-DISEMBARK ()
	 <COND (<==? <LOC ,PRSO> ,WINNER>
		<TELL
"You don't need to take" HIM ,PRSO " out to use" HIM ,PRSO "." CR>)
	       (<==? <LOC ,PRSO> ,POCKET>
		<MOVE ,PRSO ,WINNER>
		;<HE-SHE-IT ,WINNER T "is">
		<TELL CHE ,WINNER is " now holding" HIM ,PRSO "." CR>)
	       (<DOBJ? ROOMS HERE GLOBAL-HERE ;GLOBAL-WATER>
		<DO-WALK ,P?OUT>
		<RTRUE>)
	       (<NOT <==? <LOC ,WINNER> ,PRSO>>
		<TELL "You're not in" HIM ,PRSO "!" CR>
		<RFATAL>)
	       (T
		<OWN-FEET>)>>

<ROUTINE OWN-FEET ()
	 <MOVE ,WINNER ,HERE>
	 <TELL "You're on your own feet again." CR>>

<ROUTINE V-HOLD-UP ()
 <COND (<DOBJ? ROOMS>
	<PERFORM ,V?STAND>
	<RTRUE>)
       (T <TELL "That doesn't seem to help at all." CR>)>>

<ROUTINE V-TELL ("AUX" P)
	 <COND (<==? ,PRSO ,PLAYER>
		<COND (<NOT <==? ,WINNER ,PLAYER>>
		       <SET P ,WINNER>
		       ;<SETG L-WINNER ,WINNER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .P>
		       <RTRUE>)
		      (,QCONTEXT
		       <SETG QCONTEXT <>>
		       <COND (,P-CONT
			      ;<SETG L-WINNER ,WINNER>
			      <SETG WINNER ,PLAYER>)
			     (T <TELL
"Okay, you're not talking to anyone else." CR>)>)
		      (T
		       <WONT-HELP-TO-TALK-TO ,PLAYER>
		       <SETG QUOTE-FLAG <>>
		       <SETG P-CONT <>>
		       <RFATAL>)>)
	       (<AND <FSET? ,PRSO ,PERSONBIT> <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<UNSNOOZE ,PRSO>
		<SETG QCONTEXT ,PRSO>
		<SETG QCONTEXT-ROOM ,HERE>
		<COND (,P-CONT
		       <SETG CLOCK-WAIT T>
		       ;<SETG L-WINNER ,WINNER>
		       <SETG WINNER ,PRSO>)
		      (T
		       <TELL CHE ,PRSO is " listening." CR>)>)
	       (T
		<WONT-HELP-TO-TALK-TO ,PRSO>
		;<YOU-CANT "talk to">
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)>>

<ROUTINE PRE-STELL-ABOUT () <PERFORM ,V?TELL-ABOUT ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-STELL-ABOUT () <V-FOO>>

<ROUTINE PRE-TELL-ABOUT ("AUX" P)
 <COND (<AND <QCONTEXT-GOOD?>
	     <DOBJ? PLAYER>>
	<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSI>
	<RTRUE>)
       (<AND <DOBJ? PLAYER>
	     <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	     <NOT <FSET? .P ,INVISIBLE>>>
	<TELL ,I-ASSUME " ask" THE .P ".)" CR>
	<PERFORM ,V?ASK-ABOUT .P ,PRSI>
	<RTRUE>)
       (T <PRE-ASK-ABOUT>)>>

<ROUTINE V-TELL-ABOUT ("AUX" P)
 <COND (<GETP ,PRSI ,P?TEXT> <TELL <GETP ,PRSI ,P?TEXT> CR>)
       (<DOBJ? PLAYER> <ARENT-TALKING>)
       (T <PERFORM ,V?ASK-ABOUT ,PRSO ,PRSI> <RTRUE>)>>

<ROUTINE PRE-TALK-ABOUT ("AUX" P)
 <COND (<NOT <==? ,WINNER ,PLAYER>>
	<PERFORM ,V?TELL-ABOUT ,PLAYER ,PRSO>
	<RTRUE>)
       (<QCONTEXT-GOOD?>
	<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<TELL ,I-ASSUME " to" THE .P ".)" CR>
	<PERFORM ,V?ASK-ABOUT .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-TALK-ABOUT () <ARENT-TALKING>>

<ROUTINE V-THANKS ("AUX" P)
	 <COND (<AND ,PRSO
		     <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<THANKS-ACT ,PRSO>)
	       (<QCONTEXT-GOOD?>
		<THANKS-ACT ,QCONTEXT>)
	       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
		<THANKS-ACT .P>)
	       (T <TELL "You're more than welcome." CR>)>>

<ROUTINE THANKS-ACT (P)
	<TELL CHE .P acknowledge " your thanks." CR>>

<ROUTINE V-THROW () <COND (<IDROP> <TELL "Thrown." CR>)>>

<ROUTINE V-THROW-AT ()
	 <COND (<NOT <IDROP>>
		<RTRUE>)>
	 <COND (<AND <FSET? ,PRSI ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<TELL CHE ,PRSI duck>)
	       (T <TELL CHE ,PRSI do "n't duck">)>
	 <TELL " as" HE ,PRSO " flies by." CR>>

<ROUTINE V-THROW-OFF ("AUX" X)
 <COND (<IOBJ? TRAIN ROOF>
	<COND (<NOT ,ON-TRAIN>
	       <HAR-HAR>)
	      (<SET X <WINDOW-IN? ,HERE>>
	       <PERFORM ,V?THROW-THROUGH ,PRSO .X>
	       <RTRUE>)
	      (<NOT <==? ,HERE ,ROOF>>
	       <TELL "You look for a window but find none." CR>)
	      (<NOT ,TRAIN-MOVING>
	       <MOVE ,PRSO <GET ,STATION-ROOMS ,HERE>>
	       <TELL CTHE ,PRSO " drops out of sight." CR>)
	      (T
	       <MOVE ,PRSO ,LIMBO-FWD>
	       <TELL CTHE ,PRSO " is gone with the wind." CR>)>)>>

<ROUTINE V-THROW-THROUGH ()
	 <COND (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<TELL "Let's not resort to vandalism, please." CR>)
	       (T <V-THROW>)>>

<ROUTINE PRE-TIE-TO ()
	 <COND (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<TELL "That won't do any good." CR>)>>

<ROUTINE V-TIE-TO ()
	<TELL "You can't tie" HIM ,PRSO " to that." CR>>

<ROUTINE PRE-TIE-WITH ()
	 <COND (<OR <NOT <FSET? ,PRSO ,PERSONBIT>>
		    <NOT <FSET? ,PRSI ,TOOLBIT>>>
		<TELL "That won't do any good." CR>)>>

<ROUTINE V-TIE-WITH () <PRODUCE-GIBBERISH>>

<ROUTINE V-TIME ()
	 <STATUS-LINE>
	 <TELL "The time is now ">
	 <TIME-PRINT ,PRESENT-TIME>
	 <TELL ".">
	 <CRLF>>

<ROUTINE TIME-PRINT (NUM "AUX" HR)
	 <SET HR <MOD </ .NUM 60> 24>>
	 <COND (<L? .HR 10>
		<TELL "0">)>
	 <PRINTN .HR>
	 <TELL "." ;":">
	 <COND (<L? <SET HR <MOD .NUM 60>> 10>
		<TELL "0">)>
	 <TELL N .HR>>

<ROUTINE V-TURN ()
 <COND ;(<EQUAL? <META-LOC ,PRSO> ,GLOBAL-OBJECTS>
	<NOT-HERE ,PRSO>)
       (<AND <FSET? ,PRSO ,DOORBIT> <FSET? ,PRSO ,OPENBIT>>
	<PERFORM ,V?CLOSE ,PRSO>
	<RTRUE>)
       (T <TELL "What do you want that to do?" CR>)>>

<ROUTINE V-TURN-AROUND ()
 <COND (<NOT ,PLAYER-NOT-FACING>
	<TELL "It's not clear which way you're facing." CR>)
       (T
	<SETG P-WALK-DIR ,PLAYER-NOT-FACING>
	<PERFORM ,V?FACE ,PLAYER-NOT-FACING>
	<RTRUE>)>>

<ROUTINE V-LAMP-OFF ()
	 <COND (<FSET? ,PRSO ,PERSONBIT>
		<TELL "Your vulgar ways would turn anyone off." CR>)
	       (T ;<NOT <FSET? ,PRSO ,ON?BIT>>
		<YOU-CANT "turn off">)
	       ;(<NOT <FSET? ,PRSO ,ONBIT>>
		<ALREADY ,PRSO "off">)
	       ;(T
		<OKAY ,PRSO "off">)>>

<ROUTINE V-LAMP-ON ()
	 <COND (<FSET? ,PRSO ,ONBIT>
		<ALREADY ,PRSO "on">)
	       ;(<FSET? ,PRSO ,ON?BIT>
		<OKAY ,PRSO "on">)
	       (<FSET? ,PRSO ,PERSONBIT>
		<HAR-HAR>)
	       (T <YOU-CANT "turn on">)>>

<ROUTINE V-UNLOCK ()
	 <COND (<OR <FSET? ,PRSO ,DOORBIT>
		    ;<AND <FSET? ,PRSO ,CONTBIT>
			 <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>>
		<COND (<AND <NOT <ZMEMQ ,HERE ,CAR-ROOMS-COMPS>>
			    <NOT <ZMEMQ ,HERE ,CAR-ROOMS-REST>>>
		       <TELL "You can't unlock" HIM ,PRSO " from here." CR>)
		      (<NOT <FSET? ,PRSO ,LOCKED>>
		       <ALREADY ,PRSO "unlocked">)
		      (T
		       <COND (<FSET? ,PRSO ,OPENBIT>
			      <FCLEAR ,PRSO ,OPENBIT>
			      <TELL "(You close" HIM ,PRSO " first.)" CR>)>
		       <FCLEAR ,PRSO ,LOCKED>
		       <OKAY ,PRSO "unlocked">)>)
	       (T
		<SETG CLOCK-WAIT T>
		<TELL "(" CHE ,PRSO is "n't locked!)" CR>)>>

<ROUTINE V-UNTIE ()
 <TELL "You can't tie" HIM ,PRSO ", so you can't untie" HIM ,PRSO "!" CR>>

<ROUTINE MORE-SPECIFIC ()
	<SETG CLOCK-WAIT T>
	<TELL "(Please be more specific.)" CR>>

<ROUTINE V-USE () <MORE-SPECIFIC>>

<ROUTINE V-USE-AGAINST () <MORE-SPECIFIC>>

"V-WAIT has three modes, depending on the arguments:
1) If only one argument is given, it will wait for that many moves.
2) If a second argument is given, it will wait the least of the first
   argument number of moves and the time at which the second argument
   (an object) is in the room with the player.
3) If the third argument is given, the second should be FALSE.  It will
   wait <first argument> number of moves (or at least try to).  The
   third argument means that an 'internal wait' is happening (e.g. for
   a 'careful' search)."

<GLOBAL WHO-WAIT 0>

<ROUTINE HAS-ARRIVED (OBJ)
	<NOT-IT .OBJ>
	<TELL CTHE .OBJ ", for wh"
	      <COND (<FSET? .OBJ ,PERSONBIT> "om") (T "ich")>
	      " you're waiting," V .OBJ has " arrived." CR>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM -1) (WHO <>) (INT <>)
		 "AUX" VAL HR (RESULT T))
	 <COND (<==? -1 .NUM>
		<SET NUM 10>
		<TELL ,I-ASSUME " wait 10 minutes.)" CR>)>
	 <SET HR ,HERE>
	 <SETG WHO-WAIT 0>
	 <COND (<NOT .INT> <TELL "Time passes..." CR>)>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0> <RETURN>)
		       (<SET VAL <CLOCKER>>
			<COND (<OR <==? .VAL ,M-FATAL>
				   <NOT <==? .HR ,HERE>>>
			       <SET RESULT ,M-FATAL>
			       <RETURN>)
			      (<AND .WHO
				    <OR <==? ,HERE <META-LOC .WHO>>
					<==? ,SCENERY-OBJ .WHO>
					<AND <==? .WHO ,TRAIN> ,IN-STATION>>>
			       <HAS-ARRIVED .WHO>
			       <RETURN>)
			      ;(<0? .NUM> <RETURN>)
			      (T
			       <SETG WHO-WAIT <+ ,WHO-WAIT 1>>
			       ;<COND (<NOT <==? <BAND <GETB 0 1> 16> 0>>
				      <TELL "(">
				      <TIME-PRINT ,PRESENT-TIME>
				      <TELL ") ">)>
			       <COND (<IN? ,PLAYER ,UNCONSCIOUS>
				      <RETURN>)>
			       <TELL "Do you want to ">
			       <COND (.INT
				      <TELL "continue what you were doing?">)
				     (T <TELL "keep waiting?">)>
			       <COND (<NOT <YES?>> <RETURN>)
				     (T <STATUS-LINE>)>)>)
		       (<AND .WHO <IN? .WHO ,HERE>>
			<HAS-ARRIVED .WHO>
			<RETURN>)
		       (<AND .WHO <G? <SETG WHO-WAIT <+ ,WHO-WAIT 1>> 30>>
			<TELL
CTHE .WHO " still" V .WHO has "n't arrived.  Do you want to keep waiting?">
			<COND (<NOT <YES?>> <RETURN>)>
			<SETG WHO-WAIT 0>
			<STATUS-LINE>)
		       (T <STATUS-LINE>)>>
	 <SETG CLOCK-WAIT T>
	 <COND (<NOT .INT> <V-TIME>)>
	 .RESULT>

<ROUTINE INT-WAIT (N "AUX" TIM REQ VAL)
	 <SET TIM ,PRESENT-TIME>
	 <COND (<==? ,M-FATAL <V-WAIT <SET REQ <RANDOM <* .N 2>>> <> T>>
		<RFATAL>)
	       (<NOT <L? <- ,PRESENT-TIME .TIM> .REQ>>
		<RTRUE>)
	       (T <RFALSE>)>>

<ROUTINE V-WAIT-FOR ("AUX" WHO)
	 <COND (<AND <NOT <==? -1 ,P-NUMBER>>
		     <DOBJ? ROOMS TURN INTNUM>>
		<COND ;(<G? ,P-NUMBER ,PRESENT-TIME> <V-WAIT-UNTIL> <RTRUE>)
		      ;(<G? ,P-NUMBER 180>
		       <TELL "That's too long to wait." CR>)
		      (T <V-WAIT ,P-NUMBER>)>)
	       (<DOBJ? ROOMS TURN GLOBAL-HERE>
		<V-WAIT>
		<RTRUE>)
	       (<DOBJ? PLAYER>
		<ALREADY ,PLAYER "here">)
	       (<SET WHO <GETP ,PRSO ,P?CHARACTER>> ;<FSET? ,PRSO ,PERSONBIT>
		<SET WHO <GET ,CHARACTER-TABLE .WHO>>
		<COND (<==? <META-LOC .WHO> ,HERE>
		       <ALREADY .WHO "here">)
		      (T <V-WAIT 10000 .WHO>)>)
	       (<AND <ZMEMZ ,PRSO ,TRAIN-TABLE> ,ON-TRAIN>
		<COND (<EQUAL? ,PRSO ,SCENERY-OBJ> <ALREADY ,PRSO "here">)
		      (T <V-WAIT 10000 ,PRSO>)>)
	       (<DOBJ? TRAIN>
		<COND (,ON-TRAIN <HAR-HAR>)
		      (,IN-STATION <ALREADY ,PRSO "here">)
		      (T <V-WAIT 10000 ,PRSO>)>)
	       (T <TELL "Not a good idea. You might wait forever." CR>)>>

<ROUTINE V-WAIT-UNTIL ()
	 <COND (<AND <NOT <==? -1 ,P-NUMBER>> <EQUAL? ,PRSO ,TURN ,INTNUM>>
		<COND (<ZERO? ,P-CENT-FLAG>
		       <COND (<L? ,P-NUMBER 24>
			      <SETG P-NUMBER <* ,P-NUMBER 60>>)
			     (<G? ,P-NUMBER 99>
			      <SETG P-NUMBER <+ <MOD ,P-NUMBER 100>
						<*</ ,P-NUMBER 100> 60>>>)>
		       <TELL ,I-ASSUME " ">
		       <TIME-PRINT ,P-NUMBER>
		       <TELL ".)" CR>)>
		<COND (<G? ,P-NUMBER ,PRESENT-TIME>
		       <V-WAIT <- ,P-NUMBER ,PRESENT-TIME>>)
		      (T
		       <SETG CLOCK-WAIT T>
		       <TELL "(It's already past that time!)" CR>)>)
	       (T <YOU-CANT "wait until">)>>

<ROUTINE V-ALARM ()
	 <COND (<==? ,PRSO ,ROOMS> <SETG PRSO ,WINNER>)>
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT> <NOT <FSET? ,PRSO ,MUNGBIT>>>
		;<HE-SHE-IT ,PRSO T "is">
		<TELL CHE ,PRSO is " wide awake, or haven't you noticed?" CR>)
	       (T
		<TOO-BAD-BUT ,PRSO "not asleep">)>>

<ROUTINE DO-WALK (DIR ;"OPTIONAL" ;(V 0) "AUX" P)
	 <COND ;(<ZERO? .V> <SET V ,V?WALK>)
	       (<SET P <COMPASS-EQV ,HERE .DIR>>
		;<SETG PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>
		<SETG PLAYER-NOT-FACING <OPP-DIR .P>>)>
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK ;.V .DIR>>

<ROUTINE V-WALK ("AUX" PT PTS STR RM)
	 <COND ;(<DOBJ? LEFT RIGHT>
		<PERFORM ,V?TURN ,PRSO>
		<RTRUE>)
	       (<NOT ,P-WALK-DIR>
		<V-WALK-AROUND>
		<RFATAL>)
	       ;(<NOT ,PRSO>
		;<COND (,DEBUG <TELL "[1] ">)>
		<YOU-CANT "go">
		<RTRUE>)>
	 ;<COND (,DEBUG <TELL "[PRSO=" N ,PRSO "] ">)>
	 ;<COND (<SET PT <COMPASS-EQV ,HERE ,PRSO>>
		;<SETG PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>
		<SETG PLAYER-NOT-FACING <OPP-DIR .PT>>)>
	 <COND (<SET PT <GETPT <LOC ,WINNER> ,PRSO>>
		;<COND (,DEBUG <TELL "[GETPT OK] ">)>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <SET RM <GET-REXIT-ROOM .PT>>
		       <COND (<GOTO .RM> <OKAY>)>
		       <RTRUE>)
		      (<==? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<==? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <COND (<GOTO .RM> <OKAY>)>
			      <RTRUE>)
			     (T
			      <RFATAL>)>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <COND (<GOTO <GET-REXIT-ROOM .PT>> <OKAY>)>
			      <RTRUE>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      ;<COND (,DEBUG <TELL "[2] ">)>
			      <YOU-CANT "go">
			      <RFATAL>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (<WALK-THRU-DOOR? .PT>
			      <COND (<GOTO <GET-REXIT-ROOM .PT>> <OKAY>)>
			      <RTRUE>)
			     (T <RFATAL>)>)>)
	       (<EQUAL? ,PRSO ,P?IN ,P?OUT>
		<V-WALK-AROUND>)
	       (T
		;<COND (,DEBUG <TELL "[4] ">)>
		<YOU-CANT "go">
		<RFATAL>)>>

<ROUTINE WALK-THRU-DOOR? (PT "AUX" OBJ RM)
	<SET OBJ <GET-DOOR-OBJ .PT>>
	<SET RM <GET-REXIT-ROOM .PT>>
	<COND (<AND ,CUSTOMS-SWEEP
		    <FSET? ,PASSPORT ,LOCKED>
		    ,ON-TRAIN
		    <NOT <ZMEMQ .RM ,CAR-ROOMS-VESTIB>>
		    <NOT <ZMEMQ .RM ,CAR-ROOMS-CORRID>>>
	       <COND (<VISIBLE? ,CONDUCTOR T>
		      <TELL
CHE ,CONDUCTOR " gestures for you to leave the train.">)
		     (T <TELL
"You should leave the train now to pass customs.">)>
	       <CRLF>
	       <RFALSE>)
	      (<FSET? .OBJ ,OPENBIT> <RTRUE>)>
	<COND (<==? .RM ,GAS-CAR-RM>
	       <COND (<==? ,CAR-HERE ,GAS-CAR>
		      <FSET .OBJ ,LOCKED>)
		     (T <FCLEAR .OBJ ,LOCKED>)>)
	      (<ZMEMQ .RM ,CAR-ROOMS-REST>
	       <COND (<OCCUPIED? .RM ,CAR-HERE>
		      <FSET .OBJ ,LOCKED>)
		     (T <FCLEAR .OBJ ,LOCKED>)>)>
	<COND (<NOT <FSET? .OBJ ,LOCKED>>
	       <COND (<NOT <VERB? WALK-TO>>
		      <TELL
"(You open" HIM .OBJ " and close it again.)" ;" for a moment.)" CR>)>
	       <RTRUE>)
	      (<OR <ZMEMQ <LOC ,WINNER> ,CAR-ROOMS-REST>
		   <ZMEMQ <LOC ,WINNER> ,CAR-ROOMS-COMPS>>
	       <FCLEAR .OBJ ,LOCKED>
	       <COND (<NOT <VERB? WALK-TO>>
		      <TELL
"(You unlock and open" HIM .OBJ " and close it again.)" CR>)>
	       <RTRUE>)
	      (<SET RM <GET .PT ,DEXITSTR>>
	       <TELL .RM CR>
	       <RFALSE>)
	      (T
	       <TOO-BAD-BUT .OBJ "locked">
	       <RFALSE>)>>

<ROUTINE V-WALK-AROUND ()
	 <SETG CLOCK-WAIT T>
	 <TELL "(What " D ,INTDIR " do you want to go in?)" CR>
	 <RFATAL>>

<ROUTINE WHO-KNOWS? (OBJ)
	<SETG CLOCK-WAIT T>
	<TELL "(Who knows where">
	;<HE-SHE-IT .OBJ <> "is">
	<TELL HE .OBJ is " now?)" CR>>

<ROUTINE V-WALK-TO ("AUX" O L)
 <SET O ,PRSO>
 <COND (<AND <SET L <GETP .O ,P?CHARACTER>>	;<FSET? .O ,PERSONBIT>
	     <FSET? .O ,SEENBIT>
	     <IN? .O ,GLOBAL-OBJECTS>>
	<SET O <GET ,CHARACTER-TABLE .L>>)>
 <SET L <META-LOC .O>>
 ;<COND (,DEBUG <TELL "[WALK-TO: " D .O "/" D .L "]" CR>)>
 <COND (<AND <EQUAL? ,HERE <LOC ,WINNER>>
	     <OR <EQUAL? .L ,HERE>
		 <AND <EQUAL? .L ,LOCAL-GLOBALS> <GLOBAL-IN? .O ,HERE>>>>
	<SETG CLOCK-WAIT T>
	<TELL "(">
	;<HE-SHE-IT ,WINNER T "do">
	<TELL CHE ,WINNER do "n't need to walk around within a place.)" CR>)
       (<EQUAL? .L ,LOCAL-GLOBALS>
	<COND (<DOBJ? SCENERY-OBJ>
	       <TOO-BAD-BUT ,PRSO "too far away">)
	      (T <MORE-SPECIFIC>)>)
       (<DOBJ? INTDIR>
	<V-WALK-AROUND>)
       (<ZMEMQ .O ,STATIONS>
	<COND (<==? .O ,SCENERY-OBJ ;,STATION-NAME>
	       <SETG CLOCK-WAIT T>
	       <TELL "(You're already in " D .O "!)" CR>)
	      (<ZMEMQ .O ,TRAIN-TABLE>
	       <TELL "The train will take you there if you're patient." CR>)
	      (T
	       <TELL "You'll have to take a ">
	       <COND (<NOT ,IN-STATION> <TELL "different ">)>
	       <TELL "train." CR>)>)
       (<OR <AND <FSET? .O ,PERSONBIT>
		 <FSET? .O ,NDESCBIT>>
	    <AND <NOT <IN? .L ;.O ,ROOMS>>
		 <NOT <FSET? .O ,TOUCHBIT>>>>
	<WHO-KNOWS? .O>
	<RTRUE>)
       (<AND <EQUAL? .L ,ROOF>
	     <EQUAL? ,HERE ,VESTIBULE-REAR-DINER
			   ,VESTIBULE-REAR-FANCY ,VESTIBULE-REAR>>
	<DO-WALK ,P?UP>
	<RTRUE>)
       (<FAR-AWAY? .L>
	<SETG CLOCK-WAIT T>
	<TELL "(" CHE ,WINNER " can't get there from here">
	<COND (<NOT <EQUAL? .L ,GLOBAL-OBJECTS>>
	       <TELL ", at least not directly">)>
	<TELL ".)" CR>)
       (T
	;<PUT <GET ,GOAL-TABLES ,PLAYER-C> ,GOAL-ENABLE 1>
	<ESTABLISH-GOAL ,PLAYER .L>
	<SETG LAST-PLAYER-LOC ,HERE>
	<FSET ,PLAYER ,INVISIBLE>
	<REPEAT () <COND (<FOLLOW-GOAL ,PLAYER> <RETURN>)>>
	<FCLEAR ,PLAYER ,INVISIBLE>
	<COND (<NOT <==? ,LAST-PLAYER-LOC ,HERE>>
	       <SETG LIT T>
	       <APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	       <V-FIRST-LOOK>
	       <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
	<RTRUE>)>>

<ROUTINE V-WALK-UNDER () <YOU-CANT "go under">>

<ROUTINE V-RUN-OVER () <TELL "That doesn't make much sense." CR>>

<ROUTINE V-WEAR ()
	 <COND (<NOT <FSET? ,PRSO ,WEARBIT>>
		<TELL "You can't wear" HIM ,PRSO "." CR>)
	       (<FSET? ,PRSO ,WORNBIT>
		<ALREADY ,PRSO "being worn">)
	       (T
		<MOVE ,PRSO ,PLAYER>
		<FSET ,PRSO ,WORNBIT>
		<TELL "You are now wearing" HIM ,PRSO "." CR>)>>

<ROUTINE V-WHAT ("AUX" P)
	 <COND (<DOBJ? PLAYER>
		<TELL "You're the ">
		<COND (<SPY?> <TELL "good spy!" CR>)
		      (T <TELL "innocent traveler!" CR>)>)
	       (<OR <AND <QCONTEXT-GOOD?>
			 <FSET? <SET P ,QCONTEXT> ,PERSONBIT>
			 <NOT <FSET? .P ,MUNGBIT>>>
		    <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>>
		<TELL ,I-ASSUME " ask" THE .P ".)" CR>
		<PERFORM ,V?ASK-ABOUT .P ,PRSO>)
	       (<FSET? ,PRSO ,PERSONBIT>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
	       (T <WONT-HELP-TO-TALK-TO ,PLAYER>)>>

<ROUTINE V-WIND () <YOU-CANT>>

<ROUTINE V-YELL () <V-YES>>

<ROUTINE V-YELL-FOR () <V-YES>>

<ROUTINE V-YES ("OPTIONAL" (NO? <>))
	 <COND (<AND <QCONTEXT-GOOD?> <==? ,WINNER ,PLAYER>>
		;<SETG L-WINNER ,WINNER>
		<SETG WINNER ,QCONTEXT>
		<COND (.NO? <PERFORM ,V?NO>) (T <PERFORM ,V?YES>)>
		<RTRUE>)
	       (T <ARENT-TALKING>)>>

<ROUTINE V-NO () <V-YES T>>

<ROUTINE FINISH ("OPTIONAL" (REPEATING <>) VAL)
	 <COND (,DEBUG <RTRUE>)>
	 <CRLF>
	 <CRLF>
	 ;<COND (<NOT .REPEATING>
		<V-SCORE>
		<CRLF>)>
	 <TELL
"Would you like to:|
   RESTORE your place from where you saved it,|
   RESTART the story from the beginning, or|
   QUIT for now?|
">
	<REPEAT ()
	 <TELL ">">
	 <READ ,P-INBUF ,P-LEXV>
	 <SET VAL <GET ,P-LEXV ,P-LEXSTART>>
	 <COND (<NOT <0? .VAL>>
		<SET VAL <WT? .VAL ,PS?VERB ,P1?VERB>>
		<COND (<EQUAL? .VAL ,ACT?RESTART>
		       <RESTART>
		       ;<TELL-FAILED>
		       <FINISH T>)
		      (<EQUAL? .VAL ,ACT?RESTORE>
		       <COND (<V-RESTORE> <RETURN>)>
		       <FINISH T>)
		      (<EQUAL? .VAL ,ACT?QUIT>
		       <QUIT>)>)>
	 <TELL "(Type RESTORE, RESTART, or QUIT.) ">>>

<ROUTINE DIVESTMENT? (OBJ)
	<AND <==? ,PRSO .OBJ>
	     <VERB? DROP GIVE POUR PUT PUT-IN THROW-AT THROW-THROUGH>>>

<ROUTINE EXIT-VERB? ("AUX" P)
 <COND (<VERB? WALK> <RETURN ,PRSO>)
       (<VERB? WALK-TO FOLLOW THROUGH>
	<SET P <META-LOC ,PRSO>>
	<COND (<==? ,HERE .P> <RFALSE>)
	      (<VERB? WALK-TO>
	       <FOLLOW-GOAL-DIR ,HERE .P>)
	      (T <DIR-FROM ,HERE .P>)>)>>

<ROUTINE REMOTE-VERB? ("OPTIONAL" (V 0))
	<COND (<0? .V> <SET V ,PRSA>)>
	<COND (<EQUAL? .V,V?ASK-ABOUT ,V?ASK-CONTEXT-ABOUT ,V?ASK-CONTEXT-FOR>
	       <RTRUE>)
	      (<EQUAL? .V ,V?ASK-FOR ,V?BUY ,V?DISEMBARK>
	       <RTRUE>)
	      (<EQUAL? .V ,V?FIND ,V?LEAVE ,V?LOOK-UP>
	       <RTRUE>)
	      (<EQUAL? .V ,V?MAKE ,V?SEARCH ,V?SEARCH-FOR>
	       <RTRUE>)
	      (<EQUAL? .V ,V?TALK-ABOUT ,V?TELL-ABOUT ,V?WAIT-FOR>
	       <RTRUE>)
	      (<EQUAL? .V ,V?WAIT-UNTIL>
	       <RTRUE>)
	      (<EQUAL? .V ,V?WALK-TO ,V?WHAT ,V?$WHERE>
	       <RTRUE>)
	      (<EQUAL? .V ,V?$FCLEAR ,V?$FSET ,V?$QFSET>
	       <RTRUE>)
	      (T <RFALSE>)>>
