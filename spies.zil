"SPIES for CHECKPOINT
Copyright (C) 1985 Infocom, Inc.  All rights reserved."

<OBJECT GUN
	(CAR 2)
	(DESC "gun")
	(SYNONYM GUN)
	(FLAGS NDESCBIT WEAPONBIT ;TRYTAKEBIT)
	(SIZE 9)
	(ACTION GUN-F)>

<ROUTINE GUN-F ()
	<COND (<VERB? AIM>
	       <PERFORM ,V?SHOW ,PRSI ,PRSO>
	       <RTRUE>)
	      (<AND <VERB? SHOW> <IOBJ? GUN>>
	       <COND (<VISIBLE? ,CONDUCTOR>
		      <ARREST-PLAYER "carrying weapons" ,CONDUCTOR T ,GUN>)
		     (<VISIBLE? ,GUARD>
		      <ARREST-PLAYER "carrying weapons" ,GUARD T ,GUN>)
		     (<VISIBLE? ,WAITER>
		      <ARREST-PLAYER "carrying weapons" ,WAITER T ,GUN>)
		     (T <RFALSE>)>)>>

"The bad spy (BS) begins by looking for the briefcase. BS knows it's
in your car or the one behind it, so s/he goes only one room per turn,
'looking around and peeking into' compartments, etc."

<ROUTINE START-BAD-SPY ("AUX" VAL GT CAR)
	<SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
	;<PUT .GT ,GOAL-FUNCTION  ,I-BAD-SPY>
	<PUT .GT ,GOAL-SCRIPT ,I-BAD-SPY>
	<SET CAR <GETP ,BAD-SPY ,P?CAR>>
	<COND (<G? .CAR ,CAR-MAX>
	       <SET CAR ,CAR-MAX>)>
	<SET VAL <MOVE-PERSON ,BAD-SPY <V-REAR .CAR>>>
	<PUTP ,BAD-SPY ,P?CAR .CAR>
	<PUT .GT ,GOAL-ENABLE 1>
	<ESTABLISH-GOAL-TRAIN ,BAD-SPY ,COMPARTMENT-START ,CAR-START>
	.VAL>

<GLOBAL BAD-SPY-KNOWS-YOU <>>
<GLOBAL BAD-SPY-DONE-PEEKING <>>
<GLOBAL BRIEFCASE-WAS-OPEN <>>	"when BS took it"

<ROUTINE I-BAD-SPY ("OPTIONAL" (GARG <>) "AUX" L V BR BL RM (VAL <>))
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-BAD-SPY:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-BAD-SPY> <RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <SET BR <META-LOC ,BRIEFCASE>>
 <SET BL <LOC ,BLOOD-SPOT>>
 <COND (<==? .GARG ,G-ENROUTE>
	<SET RM <GET-REXIT-ROOM <GETPT .L ,P?IN>>>
	<COND (<AND <EQUAL? .BR .L .RM>
		    <NOT <HIDDEN? ,BRIEFCASE>>
		    <NOT <IN? ,BRIEFCASE ,BAD-SPY>>>
	       <ESTABLISH-GOAL ,BAD-SPY .BR>)
	      (<EQUAL? .BL .L .RM>
	       <ESTABLISH-GOAL ,BAD-SPY .BL>)
	      (<NOT .V>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)
	      (<AND <EQUAL? ,HERE .BR>
		    <NOT <HIDDEN? ,BRIEFCASE>>
		    <NOT <IN? ,BRIEFCASE ,BAD-SPY>>>	;"BS sees you & case"
	       <NEW-LDESC ,BAD-SPY 30 ;"looking in your direction">
	       <SETG BAD-SPY-DONE-PEEKING T>
	       <PUT <GET ,GOAL-TABLES ,BAD-SPY-C>
		    ,GOAL-SCRIPT
		    ,I-BAD-SPY-W-YOU>
	       ;<PUT <GET ,GOAL-TABLES ,BAD-SPY-C>
		    ,GOAL-FUNCTION
		    ,I-BAD-SPY-W-YOU>
	       <SETG BAD-SPY-KNOWS-YOU T>
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,HERE ,CAR-HERE>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)
	      (T
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)
       (<AND <NOT <SPY?>> ;<ZERO? ,EGO>
	     <==? .GARG ,G-REACHED>>	;"BS reached 'your' compartment"
	<NEW-LDESC ,BAD-SPY 30 ;"looking in your direction">
	<SETG BAD-SPY-DONE-PEEKING T>
	<COND (.V <TELL CHE ,BAD-SPY " enters, looks around, and ">)>
	<COND (<==? .BL .L>	;"BS knows stranger was here"
	       <COND (.V		;"BS thinks you have McG"
		      <PUT <GET ,GOAL-TABLES ,BAD-SPY-C>
			   ,GOAL-SCRIPT
			   ,I-BAD-SPY-W-YOU>
		      <PUT <GET ,GOAL-TABLES ,BAD-SPY-C>
			   ,GOAL-FUNCTION
			   ,I-BAD-SPY-W-YOU>
		      <SETG BAD-SPY-KNOWS-YOU T>
		      <TELL "sits down." CR>)>
	       <COND (<OR <HIDDEN? ,BRIEFCASE>
			  <NOT <==? .L .BR>>>
		      <NEW-LDESC ,BAD-SPY 18 ;"looking triumphant">
		      <COND (,IDEBUG <TELL N .V C !\] CR>)>
		      <RETURN .V>)>)
	      (T <COND (.V <TELL "pauses a minute." CR>)>)>
	<COND (<OR <IN? ,BRIEFCASE ,PLAYER>
		   <HIDDEN? ,BRIEFCASE>
		   <NOT <==? .L .BR>>>
	       <ENABLE <QUEUE I-BAD-SPY 1>>)	;"See end of routine."
	      (T
	       <SPY-TAKES-CASE>
	       <COND (.V <TELL
"Then" HE ,BAD-SPY notice HIM ,BRIEFCASE " and takes it." CR>)>)>
	<COND (,IDEBUG <TELL N .V C !\] CR>)>
	<RETURN .V>)
       (<NOT .GARG>	;"called by CLOCKER when BS learns nothing"
	<ESTABLISH-GOAL-TRAIN ,BAD-SPY ,COMPARTMENT-1 <+ 1 ,DINER-CAR>>
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)>>

<ROUTINE SPY-TAKES-CASE ()
	<FCLEAR ,BRIEFCASE ,TAKEBIT>
	<FCLEAR ,BRIEFCASE ,SEENBIT>	;"so START-SENTENCE will mention it"
	<COND (<FSET? ,BRIEFCASE ,OPENBIT>
	       <SETG BRIEFCASE-WAS-OPEN T>
	       <FCLEAR ,BRIEFCASE-LATCH ,OPENBIT>
	       <FCLEAR ,BRIEFCASE ,OPENBIT>
	       <INSIDE-OBJ-TO ,BRIEFCASE-TBL ,BRIEFCASE 1>)>
	<MOVE ,BRIEFCASE ,BAD-SPY>
	<PUT <GET ,GOAL-TABLES ,BAD-SPY-C>
	     ,GOAL-SCRIPT
	     ,I-BAD-SPY-W-CASE>
	;<PUT <GET ,GOAL-TABLES ,BAD-SPY-C>
	     ,GOAL-FUNCTION
	     ,I-BAD-SPY-W-CASE>
	<ENABLE <QUEUE I-BAD-SPY-W-CASE 1>>>

<ROUTINE I-BAD-SPY-W-CASE ("OPTIONAL" (GARG <>) "AUX" V L GT DR N)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-BAD-SPY-W-CASE:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-BAD-SPY-W-CASE> <RFALSE>)>
 <COND (<NOT .GARG>	;"called by CLOCKER"
	<ESTABLISH-GOAL-TRAIN ,BAD-SPY ,COMPARTMENT-5 ,PLATFORM-MAX>
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<AND <NOT .V> <IN? ,BRIEFCASE ,BAD-SPY>>
	<FCLEAR ,BRIEFCASE ,SEENBIT>)>	;"so START-SENTENCE will mention it"
 <COND (<==? .GARG ,G-ENROUTE>
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)
       (<==? .GARG ,G-REACHED>		;"BS reached 'own' compartment"
	<SET L <LOC ,BAD-SPY>>
	<NEW-LDESC ,BAD-SPY 35 ;"deep in thought">
	<SET DR <FIND-FLAG-LG .L ,DOORBIT>>
	<FSET .DR ,LOCKED>		;"locks comp. door"
	<COND (<NOT ,BRIEFCASE-WAS-OPEN>
	       <FSET ,BRIEFCASE-LATCH ,OPENBIT>
	       <FSET ,BRIEFCASE ,OPENBIT>
	       <TBL-TO-INSIDE ,BRIEFCASE ,BRIEFCASE-TBL 1>)>
	<COND (.V <TELL CHE ,BAD-SPY " quickly opens" HIM ,BRIEFCASE>)>
	<COND (<OR <HARD?> ,LATCH-TURNED>	;"no gas for this spy!"
	       <SETG LATCH-TURNED T>
	       <SETG BAD-SPY-OPENED-CASE T>
	       <SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
	       <COND (<IN? ,MCGUFFIN ,BRIEFCASE> T)
		     (<IN? ,SPY-LIST ,BRIEFCASE>
		      <SETG LIST-RUBBED T>
		      <COND (<IN? ,PASSOBJECT ,BAD-SPY> T)
			    (<==? ,PASSOBJECT ,KNIFE>
			     <FCLEAR .DR ,LOCKED>
			     <PUT .GT ,GOAL-SCRIPT ,I-TRAVELER-SEEKS-KNIFE>
			     <ESTABLISH-GOAL-TRAIN ,BAD-SPY
						   ,VESTIBULE-REAR-DINER
						   ,DINER-CAR>)
			    (<==? ,PASSOBJECT ,FLOWER-GLOBAL>
			     <FCLEAR .DR ,LOCKED>
			     <PUT .GT ,GOAL-FUNCTION ,I-TRAVELER-SEEKS-FLOWER>
			     <COND (<NOT <EQUAL? .L ,REST-ROOM-REAR-DINER
						    ,REST-ROOM-REAR
						    ,OTHER-REST-ROOM-REAR>>
				    <ESTABLISH-GOAL ,BAD-SPY
					 <V-REAR <GETP ,BAD-SPY ,P?CAR>>>)>)>)
		     (,BAD-SPY-KNOWS-YOU	;"still thinks you have McG"
		      <PUT .GT ,GOAL-SCRIPT ,I-BAD-SPY-W-YOU>
		      <FCLEAR .DR ,LOCKED>
		      <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,HERE ,CAR-HERE>)
		     (T				;"thinks contact has McG"
		      ;<FCLEAR .DR ,LOCKED>
		      <COND (<NOT ,BRIEFCASE-WAS-OPEN>
			     <FCLEAR ,BRIEFCASE-LATCH ,OPENBIT>
			     <FCLEAR ,BRIEFCASE ,OPENBIT>
			     <INSIDE-OBJ-TO ,BRIEFCASE-TBL ,BRIEFCASE 1>)>
		      <PUT .GT ,GOAL-FUNCTION  ,I-BAD-SPY-IMITATES>
		      <PUT .GT ,GOAL-SCRIPT ,I-BAD-SPY-IMITATES>)>
	       <COND (.V <TELL C !\. CR>)>)
	      (T		;"BS takes gas!"
	       <COND (<==? ,CAR-HERE ,PLATFORM-MAX>
		      <COND (<==? ,HERE ,COMPARTMENT-5>
			     <TELL-GAS>)>
		      <MOVE ,BRIEFCASE ,SEAT-5>)
		     (T
		      <MOVE ,BRIEFCASE ,OTHER-SEAT-5>)>
	       <FSET ,BRIEFCASE ,TAKEBIT>
	       <FCLEAR ,BAD-SPY ,PERSONBIT>
	       <NEW-LDESC ,BAD-SPY 32 ;"slumped">
	       <SET N <GETP ,BAD-SPY ,P?CAR>>
	       <REPEAT ()		;"innocent people take gas!"
		   <COND (<SET DR <FIND-FLAG-CAR .L .N ,PERSONBIT>>
			  <FCLEAR .DR ,PERSONBIT>
			  <NEW-LDESC .DR 32 ;"slumped">)
			 (T <RETURN>)>>
	       <SETG GAS-CAR-RM ,COMPARTMENT-5>
	       <SETG GAS-CAR ,PLATFORM-MAX ;<GETP ,BAD-SPY ,P?CAR>>
	       <COND (.V <TELL " and succumbs to the poison gas." CR>)>)>
	<COND (,IDEBUG <TELL N .V C !\] CR>)>
	.V)>>

<GLOBAL BAD-SPY-OPENED-CASE <>>
<GLOBAL GAS-CAR <>>
<GLOBAL GAS-CAR-RM <>>

"Here's what BS does when train arrives at a station:"

<ROUTINE ARRIVE-AT-STATION-BAD-SPY ("AUX" GT X)
	<SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
	<COND (<AND <SPY?>
		    <EQUAL? ,SCENERY-OBJ ,STATION-FRBZ ,STATION-GOLA>>
	       <PUT .GT ,GOAL-SCRIPT ,I-TRAVELER-FINDS-CONTACT>
	       <CLEAR-TRAIN-PERSON ,BAD-SPY-C>)
	      (<AND <SPY?>
		    <EQUAL? ,SCENERY-OBJ ,STATION-KNUT>
		    <IN? ,PASSOBJECT ,BAD-SPY>>
	       <COND (<AND <NOT ,ON-TRAIN>
			   <ON-PLATFORM? <LOC ,BAD-SPY>>>
		      <PUT .GT ,GOAL-FUNCTION ,I-TRAVELER-TO-GRNZ>
		      <SET X <GETP <LOC ,BAD-SPY> ,P?CAR>>
		      <PUTP ,BAD-SPY ,P?CAR .X>
		      <MOVE-PERSON ,BAD-SPY <V-REAR .X>>
		      <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,COMPARTMENT-5 .X>)
		     (T
		      <PUT .GT ,GOAL-FUNCTION ,I-TRAVELER-SEEKS-TICKET>
		      <ESTABLISH-GOAL ,BAD-SPY
				      <V-REAR <GETP ,BAD-SPY ,P?CAR>>>)>)
	      (<==? ,I-BAD-SPY-IMITATES <GET .GT ,GOAL-SCRIPT>>
	       <ESTABLISH-GOAL ,BAD-SPY <V-REAR <GETP ,BAD-SPY ,P?CAR>> ;2>)>>

"Here's what BS does when train departs from a station:"

<ROUTINE DEPART-FROM-STATION-BAD-SPY ()
	<COND (<AND ,BAD-SPY-KNOWS-YOU <NOT ,GAS-CAR>>
	       <I-BAD-SPY-TO-YOU>)>>

"BS tries to imitate you to get McG:"

<ROUTINE I-BAD-SPY-IMITATES ("OPTIONAL" (GARG <>) "AUX" L V CAR X)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-BAD-SPY-IMITATES:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-BAD-SPY-IMITATES> <RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<AND <NOT .V> <IN? ,BRIEFCASE ,BAD-SPY>>
	<FCLEAR ,BRIEFCASE ,SEENBIT>)>
 <COND (<==? .GARG ,G-ENROUTE>
	<COND (<ON-PLATFORM? .L>
	       <COND (.V
		      <TELL CTHE ,BAD-SPY>
		      <COND (<WHERE? ,BAD-SPY> <TELL C !\,>)>
		      <TELL " searches the crowd." CR>)>)>)
       (<==? .GARG ,G-REACHED>
	<NEW-LDESC ,BAD-SPY 10>
	<SET CAR <GETP ,BAD-SPY ,P?CAR>>
	<COND (<==? .L <V-REAR .CAR>>		;"first goal is rear vestib."
	       <MOVE ,BAD-SPY <GET ,STATION-ROOMS .CAR>>
	       <COND (<OR .V <VISIBLE? ,BAD-SPY>>
		      <BAD-SPY-LEAVES-BOARDS "leav">)>
	       <ESTABLISH-GOAL ,BAD-SPY ,PLATFORM-A ;2>)
	      (<OR ,CUSTOMS-SWEEP <==? .L ,PLATFORM-E>>	;"third goal is train"
	       <SET X <GETP .L ,P?CAR> ;,PLATFORM-MAX>
	       <MOVE ,BAD-SPY <V-REAR .X>>
	       <PUTP ,BAD-SPY ,P?CAR .X>
	       <COND (<OR .V <VISIBLE? ,BAD-SPY>>
		      <BAD-SPY-LEAVES-BOARDS "board">)>
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,COMPARTMENT-5 ,PLATFORM-MAX>)
	      (<==? .L ,PLATFORM-A>	;"second goal is far end of platform"
	       <ESTABLISH-GOAL ,BAD-SPY ,PLATFORM-E ;2>
	       <COND (.V <TELL CHE ,BAD-SPY " searches the crowd." CR>)>)>)>
 <COND (,IDEBUG <TELL N .V C !\] CR>)>
 .V>

"BS follows you:"

<ROUTINE I-BAD-SPY-W-YOU ("OPTIONAL" (GARG <>) "AUX" (VAL <>) L V)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-BAD-SPY-W-YOU:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-BAD-SPY-W-YOU> <RFALSE>)>
 <SET V <VISIBLE? ,BAD-SPY>>
 <SET L <LOC ,BAD-SPY>>
 <COND (<==? .GARG ,G-ENROUTE>
	<COND (<AND <NOT ,BAD-SPY-OPENED-CASE>
		    <NOT <IN? ,BRIEFCASE ,PLAYER>>
		    <NOT <HIDDEN? ,BRIEFCASE>>
		    <==? .L <META-LOC ,BRIEFCASE>>>	;"BS found case"
	       <SPY-TAKES-CASE>
	       <COND (.V
		      <SET VAL T>
		      <TELL
CHE ,BAD-SPY notice HIM ,BRIEFCASE " and takes it." CR>)>)
	      (<NOT .V ;<EQUAL? ,HERE ,LAST-PLAYER-LOC>>
	       <SET VAL <I-BAD-SPY-TO-YOU>>)>)
       (<==? .GARG ,G-REACHED>
	<NEW-LDESC ,BAD-SPY 30 ;"looking in your direction">
	<ENABLE <QUEUE I-BAD-SPY-W-YOU -1>>	;"until you move again"
	<COND (<EQUAL? ,HERE <GET <GET ,GOAL-TABLES ,BAD-SPY-C> ,GOAL-F>>
	       <COND (<OR <ZMEMQ ,HERE ,CAR-ROOMS-COMPS>
			  <ZMEMQ ,HERE ,CAR-ROOMS-COMPS-DINER>>
		      <SET VAL T>
		      <COND (.V
			     <TELL CHE ,BAD-SPY " enters and sits down.">
			     <COND (<NOT <FIND-FLAG-HERE ,PERSONBIT
							 ,PLAYER ,BAD-SPY>>
				    <BAD-SPY-GUN-THREAT>)>
			     <CRLF>)
			    (T <TELL "You hear a knock on the door." CR>)>)
		     (.V
		      <SET VAL T>
		      <NEW-LDESC ,BAD-SPY 3 ;"gazing window">
		      <TELL CHE ,BAD-SPY pause>
		      <COND (<==? .L ,HERE> <TELL " here">)>
		      <TELL "." CR>)>)>)
       (<ZERO? .GARG>
	<COND (<AND .V	;"<EQUAL? ,HERE ,LAST-PLAYER-LOC>"
		    <OR <ZMEMQ ,HERE ,CAR-ROOMS-COMPS>
			<ZMEMQ ,HERE ,CAR-ROOMS-COMPS-DINER>
			<ZMEMQ ,HERE ,CAR-ROOMS-REST>>>
	       <COND (<IN? ,GUN ,BAD-SPY>
		      <TELL
"The sound of the gunshot is not loud enough to be carried beyond
this room. But the pain is so great that you don't notice the details." CR>
		      <FINISH>)
		     (<NOT <FIND-FLAG-HERE ,PERSONBIT ,PLAYER ,BAD-SPY>>
		      <SET VAL T>
		      <TELL
CHE ,BAD-SPY " peeks into the corridor for a moment.">
		      <BAD-SPY-GUN-THREAT>
		      <CRLF>)>)
	      (T
	       <MOVE ,GUN ,OTHER-LIMBO-FWD>
	       ;<REMOVE ,GUN>
	       <COND (<NOT .V>
		      <QUEUE I-BAD-SPY-W-YOU 0>
		      <SET VAL <I-BAD-SPY-TO-YOU>>)>)>)>
 <COND (,IDEBUG <TELL N .VAL C !\] CR>)>
 <RETURN .VAL>>

<ROUTINE BAD-SPY-GUN-THREAT ()
	<MOVE ,GUN ,BAD-SPY>
	<TELL
" Then" HE ,BAD-SPY " displays a gun and motions for you to give"
HIM ,BAD-SPY " something.">>

"BS gets new goal for following you:"

<ROUTINE I-BAD-SPY-TO-YOU ("OPTIONAL" (GARG <>) "AUX" L STA V (VAL <>))
	<COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	       <TELL "[I-BAD-SPY-TO-YOU:">
	       <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
	<COND (<PAUSE-SCRIPT?  I-BAD-SPY> <RFALSE>)>
	<SET V <VISIBLE? ,BAD-SPY>>
	<SET STA <ZMEMQ <LOC ,BAD-SPY> ,STATION-ROOMS>>
	<COND (,ON-TRAIN
	       <COND (.STA
		      <MOVE ,BAD-SPY <V-REAR ,CAR-HERE>>
		      <PUTP ,BAD-SPY ,P?CAR ,CAR-HERE>
		      <COND (<OR .V
				 <VISIBLE? ,BAD-SPY>
				 <VISIBLE? <GET ,STATION-ROOMS ,CAR-HERE>>>
			     <SET VAL T>
			     <BAD-SPY-LEAVES-BOARDS "board">)>)>
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,HERE ,CAR-HERE>)
	      (T
	       <COND (<NOT .STA>
		      <SET L <GET ,STATION-ROOMS <GETP ,BAD-SPY ,P?CAR>>>
		      <MOVE ,BAD-SPY .L>
		      <COND (<OR .V <VISIBLE? ,BAD-SPY>>
			     <SET VAL T>
			     <BAD-SPY-LEAVES-BOARDS "leav">)>)>
	       <ESTABLISH-GOAL ,BAD-SPY ,HERE ;2>)>
	.VAL>

<ROUTINE BAD-SPY-LEAVES-BOARDS (STR)
	<TELL
"Out of the corner of your eye, you see" HIM ,BAD-SPY C !\  .STR
"ing the train." CR>>

<ROUTINE HIDDEN? (OBJ "AUX" L)
	<SET L <LOC .OBJ>>
	<COND (<EQUAL? .L ,BRIEFCASE>
	       <COND (<FSET? ,BRIEFCASE ,OPENBIT> <RFALSE>)
		     (T <RTRUE>)>)
	      (<EQUAL? .L ,UNDER-SEAT-1 ,OTHER-UNDER-SEAT-1 ,POCKET> <RTRUE>)
	      (<EQUAL? .L ,UNDER-SEAT-2 ,OTHER-UNDER-SEAT-2> <RTRUE>)
	      (<EQUAL? .L ,UNDER-SEAT-3 ,OTHER-UNDER-SEAT-3> <RTRUE>)
	      (<EQUAL? .L ,UNDER-SEAT-4 ,OTHER-UNDER-SEAT-4> <RTRUE>)
	      (<EQUAL? .L ,UNDER-SEAT-5 ,OTHER-UNDER-SEAT-5> <RTRUE>)
	      (<EQUAL? .L ,UNDER-BOOTH-1 ,UNDER-BOOTH-2 ,UNDER-BOOTH-3>
	       <RTRUE>)>>

"Here are ACTION routines for BS and contact:"

<GLOBAL CONTACT 0>		"SETG'ed to OBJECT who is contact"
<GLOBAL CONTACT-DEFAULT-F 0>	"Saves normal ACTION routine for contact"
<GLOBAL BAD-SPY 0>
<GLOBAL BAD-SPY-C 0>
<GLOBAL BAD-SPY-DEFAULT-F 0>
<GLOBAL PICKPOCKET 0>
<GLOBAL PEEKER 0>

"Test for 'displaying' passobject:"

<ROUTINE PASS-OBJECT? ("OPTIONAL" (O <>))
 <COND (<NOT .O> <SET O ,PASSOBJECT>)>
 <COND (<VERB? GIVE>
	<COND (<EQUAL? ,PRSO .O> <RTRUE>)
	      (<AND <DOBJ? NAPKIN> <EQUAL? .O ,SCARF ,TOWEL-WAITER>>
	       <RTRUE>)
	      (<AND <DOBJ? FLOWER-1 FLOWER-2> <EQUAL? .O ,FLOWER-GLOBAL>>
	       <RTRUE>)>)
       (<VERB? SHOW>
	<COND (<EQUAL? ,PRSI .O> <RTRUE>)
	      (<AND <IOBJ? NAPKIN> <EQUAL? .O ,SCARF ,TOWEL-WAITER>>
	       <RTRUE>)
	      (<AND <IOBJ? FLOWER-1 FLOWER-2> <EQUAL? .O ,FLOWER-GLOBAL>>
	       <RTRUE>)>)>>

<GLOBAL CONTACT-SUSPICION 0>	"contact suspicious if you flub"

<ROUTINE CONTACT-F ("OPTIONAL" (ARG <>) "AUX" X (WON T))
 <COND (<==? .ARG ,M-WINNER ;,CONTACT>
	<COND (<VERB? $CALL>
	       <COND (<DOBJ? PASSWORD>	;"'use' password"
		      <GIVE-PASSWORD>
		      <RTRUE>)
		     (T
		      <GIVE-WRONG-PASS-X>)>)
	      (T <APPLY ,CONTACT-DEFAULT-F .ARG>)>)
       (<VERB? GIVE SHOW>
	<GUARD-NOTICES>
	<COND (<SET X <GIVE-MCGUFFIN?>>
	       <TELL CHE ,CONTACT " quickly inspects" THE .X " and then ">
	       <COND (<EQUAL? ,CONTACT ,GUARD ,CLERK ,WAITRESS>
		      <COND (<NOT <==? .X ,MCGUFFIN>>
			     <TELL
"says, \"This will not do. We already know what the plan is; you should
have obtained the actual " D ,MCGUFFIN " so that we could analyze it and
find the source of the leak. I'm afraid I'll have to complete your mission
myself.\"" CR>
			     <FINISH>)
			    (T
			     <MOVE ,CONTACT ,LIMBO-FWD>
			     <TELL
"says, \"Excellent work! But there's one more part to your mission.
You may have noticed the special car at the end of the train. There's
an important defector aboard it, and we intend to capture him back.
You must ride this train until you observe a flare shot into the sky.
Then you must make the train stop so we can capture him. Good luck!\"
Then" HE ,CONTACT " vanishes into the crowd." CR>
			     <RTRUE>)>)>
	       <COND (<AND <EQUAL? .X ,FILM>
			   <NOT <ZMEMQ ,MCGUFFIN ,FILM-TBL>>>
		      <TELL "looks at you quizzically." CR>
		      <RTRUE>)>
	       <TELL "pumps your hand with obvious gratitude. ">
	       <COND (<NOT <SPY?>>
		      <TELL
"\"Only a few people will ever know the great
value of the service you've just performed. Probably even you don't
know the full implications. But be assured that you deserve the thanks
of the whole world.\"" CR>)
		     (T <PRODUCE-GIBBERISH>)>
	       <COND (<FSET? .X ,LOCKED>
		      <TELL CR
"However, events in the next few days show that" THE .X " completely
misled those charged with ">
		      <COND (<NOT <SPY?>> <TELL "foiling">)
			    (T <TELL "carrying out">)>
		      <TELL
" the plot. Apparently" THE ,MCGUFFIN " was altered by some clever hand." CR>
		      <CRLF>
		      <COND (<NOT <SPY?>>
			     <SET WON <>>
			     <TELL "CONDOLENCES!">)
			    (T <TELL "CONGRATULATIONS!">)>
		      <CRLF>)>
	       <COND (<AND .WON <HARD?>> <AWARD>)>
	       <FINISH>)
	      (<PASS-OBJECT?>
	       <COND (<IN? ,MCGUFFIN ,LIMBO-REAR>
		      <MOVE ,MCGUFFIN ,CONTACT>)>
	       <START-SENTENCE ,CONTACT>
	       <COND (,PASSWORD-GIVEN
		      <WHISPER-PLAN>
		      <RTRUE>)
		     (T
		      <SETG PASSOBJECT-GIVEN T>
		      <SAID-TO ,CONTACT>
		      <FCLEAR ,CONTACT ,NDESCBIT>
		      <NEW-LDESC ,CONTACT 22 ;"listening to you ...">
		      <TELL " listens to you expectantly." CR>)>)
	      (T <GIVE-WRONG-PASS-X>)>)
       (<VERB? ASK-ABOUT ASK-FOR TELL-ABOUT>	;"'use' password"
	<COND (<IOBJ? PASSWORD>
	       <GIVE-PASSWORD>
	       <RTRUE>)
	      (T
	       <GIVE-WRONG-PASS-X>)>)
       (T <APPLY ,CONTACT-DEFAULT-F .ARG>)>>

<ROUTINE GIVE-MCGUFFIN? ()
 <COND (<AND ,PASSWORD
	     <NOT ,PASSWORD-GIVEN>>
	<RFALSE>)
       (<AND ,PASSOBJECT
	     <NOT ,PASSOBJECT-GIVEN>
	     <OR <NOT <IN? ,PASSOBJECT ,PLAYER>>
		 <NOT <FSET? ,PASSOBJECT ,WORNBIT>>>>
	<RFALSE>)
       (<NOT <VERB? GIVE>> <RFALSE>)
       (<DOBJ? MCGUFFIN> <RETURN ,PRSO>)
       (<OR <DOBJ? FILM>
	    <AND <DOBJ? CAMERA> <IN? ,FILM ,CAMERA>>>
	<RETURN ,FILM>)>>

<ROUTINE GIVE-WRONG-PASS-X ("AUX" N)
	<SETG CONTACT-SUSPICION <+ 1 ,CONTACT-SUSPICION>>
	;<SETG PASSOBJECT-GIVEN <>>
	<NEW-LDESC ,CONTACT 1 ;"looking w/ suspicion">
	<TELL CHE ,CONTACT " looks ">
	<COND (<G? 2 ,CONTACT-SUSPICION>
	       <TELL "confused for a moment and says, ">
	       <PRODUCE-GIBBERISH>)
	      (T
	       <SET N <GETP ,HERE ,P?CAR>>
	       <COND (<==? .N ,PLATFORM-MAX>
		      <DEC N>)
		     (T <INC N>)>
	       <MOVE ,CONTACT <GET ,STATION-ROOMS .N>>
	       <FSET ,CONTACT ,NDESCBIT>
	       <TELL "alarmed and vanishes into the crowd." CR>)>>

<ROUTINE GIVE-PASSWORD ()
	<SETG PASSWORD-GIVEN T>
	<COND (<IN? ,MCGUFFIN ,LIMBO-REAR>
	       <MOVE ,MCGUFFIN ,CONTACT>)>
	<GUARD-NOTICES>
	<START-SENTENCE ,CONTACT>
	<COND (<NOT <0? ,CONTACT-SUSPICION>>
	       <TELL " hesitates for a moment and then">)>
	<COND (<OR ,PASSOBJECT-GIVEN
		   <AND <IN? ,PASSOBJECT ,PLAYER>
			<FSET? ,PASSOBJECT ,WORNBIT>>> ;"'display' passobject"
	       <WHISPER-PLAN>
	       <RTRUE>)
	      (T
	       <FCLEAR ,CONTACT ,NDESCBIT>
	       <NEW-LDESC ,CONTACT 23 ;"looking at you expectantly">
	       <TELL " looks at you expectantly." CR>)>>

<ROUTINE WHISPER-PLAN ()
	<TELL " whispers, ">
	<COND (<SPY?> ;<NOT <ZERO? ,EGO>>
	       <PRODUCE-GIBBERISH 2>)
	      (<NOT <EQUAL? ,SCENERY-OBJ ;,STATION-NAME ,STATION-GOLA>>
	       <TELL "\"Here too many people. Meet me in restroom.\"" CR>)
	      (T
	       <NEW-LDESC ,CONTACT 26 ;"waiting">
	       <TELL
"\"I was expecting someone else, but you must be the courier.
Please give me the " D ,MCGUFFIN " now.\"" CR>
	       <RTRUE>)>
	<COND (<NOT <EQUAL? ,SCENERY-OBJ ;,STATION-NAME ,STATION-GOLA>>
	       <COND (<FSET? ,CONTACT ,FEMALE>
		      <MOVE ,CONTACT ,REST-ROOM-WOMEN>)
		     (T <MOVE ,CONTACT ,REST-ROOM-MEN>)>
	       <FCLEAR ,CONTACT ,NDESCBIT>
	       <NEW-LDESC ,CONTACT 24 ;"waiting for you">
	       <TELL "Then" HE ,CONTACT " vanishes into the crowd." CR>
	       <RTRUE>)>>

<ROUTINE WHISPER-PLAN-OTHER ("AUX" L)
	<QUEUE I-TRAVELER-FINDS-CONTACT 0>
	<COND (<FSET? ,CONTACT ,FEMALE>
	       <SET L ,REST-ROOM-WOMEN>)
	      (T <SET L ,REST-ROOM-MEN>)>
	<COND (<OR <IN? ,CONTACT ,HERE> ,DEBUG>
	       <COND (<NOT <IN? ,CONTACT ,HERE>> <TELL C !\[>)>
	       <TELL
CHE ,CONTACT " whispers something to" HIM ,BAD-SPY " and vanishes into
the crowd." CR>)>
	<MOVE ,CONTACT .L>
	<FCLEAR ,CONTACT ,NDESCBIT>
	<NEW-LDESC ,CONTACT 26 ;"waiting">
	<PUT <GET ,GOAL-TABLES ,BAD-SPY-C> ,GOAL-ENABLE 1>
	<ESTABLISH-GOAL ,BAD-SPY .L>
	<COND (<OR <IN? ,CONTACT ,HERE> ,DEBUG>
	       <COND (<NOT <IN? ,CONTACT ,HERE>> <TELL C !\[>)>
	       <TELL CHE ,CONTACT " enters and looks around nervously." CR>)>
	<RTRUE>>

<ROUTINE I-AGENT-COMES ("OPTIONAL" (GARG <>) "AUX" PER)
	<COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	       <TELL "[I-AGENT-COMES:">
	       <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
	<SET PER <RANDOM 3>>
	<COND (<==? 1 .PER> <SET PER ,GUARD>)
	      (<==? 2 .PER> <SET PER ,CLERK>)
	      (T <SET PER ,WAITRESS>)>
	<NEW-CONTACT .PER>
	<NEW-LDESC .PER 26 ;"waiting">
	<SETG PASSWORD <>>
	<SETG PASSOBJECT <>>
	<TELL CHE .PER>
	<COND (<NOT <IN? .PER ,HERE>>
	       <MOVE .PER ,HERE>
	       <TELL " appears and">)>
	<TELL
" says, \"I was ordered to contact you here. Please give me the " D ,MCGUFFIN
" now.\"" CR>
	;<TELL "I can tell that you ">
	;<COND (<HOLDING? ,PLAYER ,MCGUFFIN>
	       <TELL "have" HIM ,MCGUFFIN ". Congrats!">)
	      (T <TELL "don't have" HIM ,MCGUFFIN". Better luck next time!">)>
	;<CRLF>
	;<FINISH>>

;<ROUTINE HOLDING? (PER OBJ)
 <COND (<IN? .OBJ .PER> <RTRUE>)
       (<IN? ,BRIEFCASE .PER>
	<COND (<FSET? ,BRIEFCASE ,CONTBIT>
	       <COND (<IN? .OBJ ,BRIEFCASE> <RTRUE>)
		     (T <RFALSE>)>)
	      (T
	       <COND (<ZMEMQ .OBJ ,BRIEFCASE-TBL> <RTRUE>)
		     (T <RFALSE>)>)>)
       (T <RFALSE>)>>

<GLOBAL GUARD-SAW-PASSPORT <>>
<ROUTINE GUARD-NOTICES ()
 <COND (<AND <NOT <==? ,CONTACT ,GUARD>>
	     <ON-PLATFORM? ,HERE>
	     <ON-PLATFORM? <LOC ,GUARD>>>
	<SETG GUARD-SUSPICION <+ 1 ,GUARD-SUSPICION>>
	<FCLEAR ,GUARD ,NDESCBIT>
	<TELL CTHE ,GUARD>
	<FCLEAR ,HIM ,TOUCHBIT>	;"so 'he' doesn't follow 'guard'"
	<COND (<==? 1 ,GUARD-SUSPICION>
	       <TELL " seems to notice your actions." CR>)
	      (T
	       <COND ;(<VERB? TELL SAY> T)
		     (<==? ,GUARD-SUSPICION <GET ,GESTURE-TABLE 0>>
		      <ARREST-PLAYER "passports" ,GUARD>
		      <TELL " throws up her hands and hurries away." CR>
		      <RTRUE>)>
	       <NEW-LDESC ,GUARD 26 ;"waiting">
	       <COND (<NOT <IN? ,GUARD ,HERE>>
		      <MOVE ,GUARD ,HERE>
		      <TELL " approaches you and">)>
	       <TELL " makes a gesture">
	       <COND (<NOT <==? 2 ,GUARD-SUSPICION>>
		      <TELL <GET ,GESTURE-TABLE ,GUARD-SUSPICION>>)>
	       <COND (<G? 5 ,GUARD-SUSPICION> <TELL ", asking for ">)
		     (T <TELL ", demanding ">)>
	       <THIS-IS-IT ,PASSPORT>
	       <TELL D ,PASSPORT "." CR>
	       <RTRUE>)>)>>

<ROUTINE TRAVELER-F ("OPTIONAL" (ARG <>)) <APPLY ,BAD-SPY-F .ARG>>

<ROUTINE BAD-SPY-F ("OPTIONAL" (ARG <>) "AUX" GT X)
 <COND (<==? .ARG ,M-WINNER ;,BAD-SPY>
	<APPLY ,BAD-SPY-DEFAULT-F .ARG>)
       (<AND <PASS-OBJECT? ,MCGUFFIN> <NOT <SPY?>>>
	<SHOW-MCGUFFIN ,BAD-SPY>)
       (<VERB? $CALL>
	<SETG BAD-SPY-KNOWS-YOU T>
	<SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
	<COND (<==? ,I-BAD-SPY-W-CASE <GET .GT ,GOAL-SCRIPT>>
	       <TELL CHE ,BAD-SPY>
	       <COND (<L? ,CAR-HERE <GET .GT ,GOAL-CAR>>
		      <MOVE ,BAD-SPY <V-REAR ,CAR-HERE>>
		      <TELL " hurries away to the rear." CR>)
		     (<G? ,CAR-HERE <GET .GT ,GOAL-CAR>>
		      <MOVE ,BAD-SPY <V-FWD ,CAR-HERE>>
		      <TELL " hurries away to the front." CR>)
		     (<==? <LOC ,BAD-SPY> <SET X <GET .GT ,GOAL-S>>>
		      <TELL " ignores you." CR>)
		     (T
		      <MOVE ,BAD-SPY .X>
		      <TELL " hurries away." CR>)>)>)
       (T <APPLY ,BAD-SPY-DEFAULT-F .ARG>)>>

<ROUTINE SHOW-MCGUFFIN (P)
	<TELL CHE .P " looks at" HIM ,MCGUFFIN " and then ">
	<COND (<AND <EQUAL? .P ,BAD-SPY>
		    <IN? ,GUN ,BAD-SPY>>
	       <TELL "takes aim at you.">)
	      (T <TELL "pulls out a gun with a silencer.">)>
	<TELL
" Before you can react, pain fills your heart, and it's all over." CR>
	<FINISH ;JIGS-UP>>

<GLOBAL TRAVELER-CHECKED-CASE <>>

<ROUTINE PAUSE-SCRIPT? (INT "OPTIONAL" (A 0))
 <COND (<ZERO? .A> <SET A ,BAD-SPY>)>
 <COND (<NOT <ZERO? ,SUPPRESS-INTERRUPT>>
	<SETG SUPPRESS-INTERRUPT <>>
	<COND (,IDEBUG <TELL "[PS:SI]" CR>)>
	<RTRUE>)
       (<NOT <FSET? .A ,PERSONBIT>>
	<QUEUE .INT 0>
	<COND (,IDEBUG <TELL "[PS:NP " D .A "]" CR>)>
	<RTRUE>)
       (<FSET? .A ,MUNGBIT>
	<COND (,IDEBUG <TELL "[PS:MU " D .A "]" CR>)>
	<RTRUE>)
       (<IN-MOTION? .A T>
	<COND (,IDEBUG <TELL "[PS:IM " D .A "]" CR>)>
	<RTRUE>)>>

<ROUTINE I-TRAVELER ("OPTIONAL" (V <>) "AUX" STR OBJ GT L LC)
 <COND (<PAUSE-SCRIPT?  I-TRAVELER> <RFALSE>)>
 <COND (<OR ,IDEBUG <==? .V ,G-DEBUG>>
	<TELL "[I-TRAVELER:">
	<COND (<==? .V ,G-DEBUG>
	       ;<COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)>
 <COND (<ZERO? .V>
	<SET V <VISIBLE? ,BAD-SPY>>)>
 <SET L <LOC ,BAD-SPY>>
 <SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
 <COND (<NOT <IN? ,BRIEFCASE ,BAD-SPY>>
	<COND (<IN? ,BRIEFCASE <META-LOC ,BAD-SPY>>
	       <SET STR " takes">
	       <SET OBJ ,BRIEFCASE>
	       <MOVE ,BRIEFCASE ,BAD-SPY>)
	      (<==? <META-LOC ,BRIEFCASE> <META-LOC ,BAD-SPY>>
	       <SET STR " tries to take">
	       <SET OBJ ,BRIEFCASE>)
	      (T
	       <PUT .GT ,GOAL-SCRIPT ,I-BAD-SPY-W-YOU>
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,HERE ,CAR-HERE>)>)
       (<ZERO? ,TRAVELER-CHECKED-CASE>
	<SET LC <LOC ,CONDUCTOR>>
	<COND (<EQUAL? .LC .L <GETP .L ,P?STATION>>
	       <COND (<FSET? ,BRIEFCASE ,OPENBIT>
		      <SET STR " closes">
		      <SET OBJ ,BRIEFCASE>
		      <FCLEAR ,BRIEFCASE ,OPENBIT>
		      <INSIDE-OBJ-TO ,BRIEFCASE-TBL ,BRIEFCASE 1>)
		     (T
		      <COND (,IDEBUG <TELL "(0)]" CR>)>
		      <RFALSE>)>)
	      (<NOT <FSET? ,BRIEFCASE-LATCH ,SEENBIT>>
	       <SET STR " examines">
	       <SET OBJ ,BRIEFCASE-LATCH>
	       <FSET ,BRIEFCASE-LATCH ,SEENBIT>)
	      (<ZERO? ,LATCH-TURNED>
	       <COND (<NOT <ZERO? ,DEBUG>> <TELL "[1] ">)>
	       <SET STR " turns">
	       <SET OBJ ,BRIEFCASE-LATCH>
	       <SETG LATCH-TURNED T>)
	      (<NOT <FSET? ,BRIEFCASE-LATCH ,OPENBIT>>
	       <SET STR " opens">
	       <SET OBJ ,BRIEFCASE-LATCH>
	       <FSET ,BRIEFCASE-LATCH ,OPENBIT>)
	      (<NOT <FSET? ,BRIEFCASE ,OPENBIT>>
	       <SET STR " opens">
	       <SET OBJ ,BRIEFCASE>
	       <FSET ,BRIEFCASE ,OPENBIT>
	       <TBL-TO-INSIDE ,BRIEFCASE ,BRIEFCASE-TBL 1>)
	      (<NOT <FSET? ,SPY-LIST ,SEENBIT>>
	       <SET STR " examines">
	       <SET OBJ ,SPY-LIST>
	       <FSET ,SPY-LIST ,SEENBIT>)
	      ;(<IN? ,SPY-LIST ,BRIEFCASE>
	       <SET STR " holds up">
	       <SET OBJ ,SPY-LIST>
	       <MOVE ,SPY-LIST ,BAD-SPY>)
	      ;(<IN? ,SPY-LIST ,BAD-SPY>
	       <SET STR " eats">
	       <SET OBJ ,SPY-LIST>
	       <MOVE ,SPY-LIST ,LIMBO-FWD>)
	      (<NOT <IN? ,MCGUFFIN ,BRIEFCASE>>
	       <SET STR " examines">
	       <SET OBJ ,BRIEFCASE>
	       <SETG TRAVELER-CHECKED-CASE T>)
	      (<ZERO? ,PICTURE-NUMBER>
	       <COND (<NOT <IN? ,FILM ,CAMERA>>
		      <COND (<NOT <IN? ,CAMERA ,BAD-SPY>>
			     <SET STR " takes">
			     <SET OBJ ,CAMERA>
			     <MOVE ,CAMERA ,BAD-SPY>)
			    (<NOT <FSET? ,CAMERA ,SEENBIT>>
			     <SET STR " examines">
			     <SET OBJ ,CAMERA>
			     <FSET ,CAMERA ,SEENBIT>)
			    (<NOT <FSET? ,CAMERA ,OPENBIT>>
			     <COND (<NOT <ZERO? ,DEBUG>> <TELL "[1] ">)>
			     <SET STR " opens">
			     <SET OBJ ,CAMERA>
			     <FSET ,CAMERA ,OPENBIT>)
			    (<NOT <FSET? ,FILM ,SEENBIT>>
			     <SET STR " examines">
			     <SET OBJ ,FILM>
			     <FSET ,FILM ,SEENBIT>)
			    (T
			     <SET STR " loads">
			     <SET OBJ ,CAMERA>
			     <MOVE ,FILM ,CAMERA>)>)
		     (<FSET? ,CAMERA ,OPENBIT>
		      <SET STR " closes">
		      <SET OBJ ,CAMERA>
		      <FCLEAR ,CAMERA ,OPENBIT>)
		     (T ;<ZERO? ,CAMERA-COCKED>
		      <SET STR " cocks">
		      <SET OBJ ,CAMERA>
		      <SETG PICTURE-NUMBER <+ ,PICTURE-NUMBER 1>>
		      <SETG CAMERA-COCKED T>)>)
	      (T
	       <COND (<NOT <ZMEMQ ,MCGUFFIN ,FILM-TBL>>
		      <SET STR " takes">
		      <SET OBJ ,PICTURE-GLOBAL>
		      <TAKE-PICTURE ,MCGUFFIN>)
		     (<NOT <FSET? ,CAMERA ,OPENBIT>>
		      <COND (<NOT <ZERO? ,DEBUG>> <TELL "[2] ">)>
		      <SET STR " opens">
		      <SET OBJ ,CAMERA>
		      <FSET ,CAMERA ,OPENBIT>)
		     (<IN? ,FILM ,CAMERA>
		      <SET STR " pockets">
		      <SET OBJ ,FILM>
		      <FSET ,FILM ,NDESCBIT>
		      <MOVE ,FILM ,BAD-SPY>)
		     (T ;<IN? ,CAMERA ,BAD-SPY>
		      <SETG TRAVELER-CHECKED-CASE T>
		      <SET STR " puts away">
		      <SET OBJ ,CAMERA>
		      <MOVE ,CAMERA ,BRIEFCASE>)>)>)
       (T
	<COND (<FSET? ,BRIEFCASE ,OPENBIT>
	       <SET STR " closes">
	       <SET OBJ ,BRIEFCASE>
	       <FCLEAR ,BRIEFCASE ,OPENBIT>
	       <INSIDE-OBJ-TO ,BRIEFCASE-TBL ,BRIEFCASE 1>)
	      (<FSET? ,BRIEFCASE-LATCH ,OPENBIT>
	       <SET STR " closes">
	       <SET OBJ ,BRIEFCASE-LATCH>
	       <FCLEAR ,BRIEFCASE-LATCH ,OPENBIT>)
	      (<AND <HARD?> <NOT <ZERO? ,LATCH-TURNED>>>
	       <COND (<NOT <ZERO? ,DEBUG>> <TELL "[2] ">)>
	       <SET STR " turns">
	       <SET OBJ ,BRIEFCASE-LATCH>
	       <SETG LATCH-TURNED <>>)
	      (T
	       <QUEUE I-TRAVELER 0>
	       <COND (<IN? ,PASSOBJECT ,BAD-SPY> T)
		     (<==? ,PASSOBJECT ,KNIFE>
		      <PUT .GT ,GOAL-SCRIPT ,I-TRAVELER-SEEKS-KNIFE>
		      <ESTABLISH-GOAL-TRAIN ,BAD-SPY
					    ,VESTIBULE-REAR-DINER ,DINER-CAR>)
		     (<==? ,PASSOBJECT ,FLOWER-GLOBAL>
		      <PUT .GT ,GOAL-FUNCTION ,I-TRAVELER-SEEKS-FLOWER>
		      <COND (<NOT <EQUAL? .L ,REST-ROOM-REAR-DINER
					,REST-ROOM-REAR ,OTHER-REST-ROOM-REAR>
				  ;<ZMEMQ .L ,CAR-ROOMS-REST>>
			     <ESTABLISH-GOAL ,BAD-SPY
					   <V-REAR <GETP ,BAD-SPY ,P?CAR>>>)>)
		     (T
		      <PUT .GT ,GOAL-FUNCTION ,TRAVELER-FLUSHES-MCGUFFIN>
		      <ESTABLISH-GOAL ,BAD-SPY
			  <GENERIC-REST-ROOM-F 0 <GETP ,BAD-SPY ,P?CAR> .L>>)>
	       <SET STR " picks up">
	       <SET OBJ ,BRIEFCASE>
	       <MOVE ,BRIEFCASE ,BAD-SPY>)>)>
 <COND (<OR <NOT <ZERO? .V>> ,DEBUG ,IDEBUG>
	<COND (<ZERO? .V> <TELL C !\[>)>
	<TELL CHE ,BAD-SPY .STR HIM .OBJ "." CR>)>>

<ROUTINE TRAVELER-FLUSHES-MCGUFFIN ("OPTIONAL" (GARG <>) "AUX" V STR OBJ GT L)
 <COND (<==? .GARG ,G-DEBUG>
	<TELL "[TRAVELER-FLUSHES-MCGUFFIN:">
	<RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<==? .GARG ,G-REACHED>
	<NEW-LDESC ,BAD-SPY 4 ;"chewing gum">
	<COND (<AND <NOT <EQUAL? .L ,REST-ROOM-FWD  ,REST-ROOM-FWD-DINER>>
		    <NOT <EQUAL? .L ,REST-ROOM-REAR ,REST-ROOM-REAR-DINER>>>
	       <RFALSE>	;"? WHAT NOW?")
	      (<IN? ,MCGUFFIN ,BAD-SPY>
	       <MOVE ,MCGUFFIN ,LIMBO-FWD>)>
	<NEW-LDESC ,BAD-SPY 26 ;"waiting">
	<RFALSE>)>>

<ROUTINE TRAVELER-FLEES ("OPTIONAL" (GARG <>) "AUX" V STR OBJ GT L)
 <COND (<==? .GARG ,G-DEBUG>
	<TELL "[TRAVELER-FLEES:">
	<RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<==? .GARG ,G-REACHED>
	<NEW-LDESC ,BAD-SPY 4 ;"chewing gum">
	<COND (<AND <NOT <EQUAL? .L ,REST-ROOM-FWD  ,REST-ROOM-FWD-DINER>>
		    <NOT <EQUAL? .L ,REST-ROOM-REAR ,REST-ROOM-REAR-DINER>>>
	       <RFALSE>	;"? WHAT NOW?")
	      (<IN? ,BRIEFCASE ,BAD-SPY>
	       <ENABLE <QUEUE I-TRAVELER -1>>)>
	<NEW-LDESC ,BAD-SPY 26 ;"waiting">
	<RFALSE>)>>

<ROUTINE I-TRAVELER-SEEKS-FLOWER ("OPTIONAL" (GARG <>) "AUX" V STR OBJ GT L)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-TRAVELER-SEEKS-FLOWER:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-TRAVELER-SEEKS-FLOWER> <RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<==? .GARG ,G-REACHED>
	<NEW-LDESC ,BAD-SPY 26 ;"waiting">
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)
       (<NOT <ZERO? .GARG>>
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)
       (<AND <NOT <IN? ,FLOWER-1 ,BAD-SPY>>
	     <NOT <IN? ,FLOWER-2 ,BAD-SPY>>>
	<COND (<EQUAL? .L ,REST-ROOM-REAR ,REST-ROOM-REAR-DINER
			  ,OTHER-REST-ROOM-REAR>
	       <SET GT <MOVE-PERSON ,BAD-SPY <V-REAR <GETP ,BAD-SPY ,P?CAR>>>>
	       <ENABLE <QUEUE I-TRAVELER-SEEKS-FLOWER -1>>
	       <COND (,IDEBUG <TELL N .GT C !\] CR>)>
	       <RETURN .GT>)
	      (<OR <EQUAL? .L ,VESTIBULE-REAR ,VESTIBULE-REAR-DINER>
		   <EQUAL? .L ,OTHER-VESTIBULE-REAR ,VESTIBULE-REAR-FANCY>>
	       ;<SET GT <MOVE-PERSON ,BAD-SPY ,BESIDE-TRACKS>>
	       <SETG LEAVE-TRAIN-PERSON ,BAD-SPY>
	       <ENABLE <QUEUE I-LEAVE-TRAIN 1>>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE ;GT>)
	      (<FSET? ,FLOWER-1 ,NDESCBIT>
	       <SET STR " finds and picks ">
	       <SET OBJ ,FLOWER-1>
	       <MOVE ,FLOWER-1 ,BAD-SPY>
	       <FCLEAR ,FLOWER-1 ,TAKEBIT>
	       <FCLEAR ,FLOWER-1 ,NDESCBIT>)
	      (<FSET? ,FLOWER-2 ,NDESCBIT>
	       <SET STR " finds and picks ">
	       <SET OBJ ,FLOWER-2>
	       <MOVE ,FLOWER-2 ,BAD-SPY>
	       <FCLEAR ,FLOWER-2 ,TAKEBIT>
	       <FCLEAR ,FLOWER-2 ,NDESCBIT>)>)
       (T
	<COND (<EQUAL? .L ,BESIDE-TRACKS ,OTHER-BESIDE-TRACKS>
	       ;<SET GT<MOVE-PERSON ,BAD-SPY <V-REAR <GETP ,BAD-SPY ,P?CAR>>>>
	       <SETG LEAVE-TRAIN-PERSON -1>
	       <ENABLE <QUEUE I-LEAVE-TRAIN 1>>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE ;GT>)
	      (T
	       ;<ESTABLISH-GOAL-TRAIN ,BAD-SPY ,COMPARTMENT-START ,CAR-START>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)>
 <COND (<OR <NOT <ZERO? .V>> ,DEBUG ,IDEBUG>
	<COND (<ZERO? .V> <TELL C !\[>)>
	<TELL CHE ,BAD-SPY .STR ;HIM A .OBJ "." CR>)>>

<ROUTINE I-TRAVELER-SEEKS-TICKET ("OPTIONAL" (GARG <>) "AUX" V STR OBJ GT L)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-TRAVELER-SEEKS-TICKET:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-TRAVELER-SEEKS-TICKET> <RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<==? .GARG ,G-REACHED>
	<COND (<OR <EQUAL? .L ,VESTIBULE-REAR ,VESTIBULE-REAR-DINER>
		   <EQUAL? .L ,OTHER-VESTIBULE-REAR ,VESTIBULE-REAR-FANCY>>
	       ;<SET V <MOVE-PERSON ,BAD-SPY
				 <GET ,STATION-ROOMS <GETP ,BAD-SPY ,P?CAR>>>>
	       <ESTABLISH-GOAL ,BAD-SPY ,TICKET-AREA>
	       <SETG LEAVE-TRAIN-PERSON ,BAD-SPY>
	       <ENABLE <QUEUE I-LEAVE-TRAIN 1>>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE ;GT>)
	      (<EQUAL? .L ,TICKET-AREA>
	       <PUTP ,TICKET-OTHER ,P?CAPACITY ,STATION-GOLA>
	       <MOVE ,TICKET-OTHER ,BAD-SPY>
	       <FCLEAR ,TICKET-OTHER ,TAKEBIT>
	       <ESTABLISH-GOAL ,BAD-SPY ,PLATFORM-C>
	       <SET STR " buys">
	       <SET OBJ ,TICKET-OTHER>)
	      (T
	       <NEW-LDESC ,BAD-SPY 26 ;"waiting">
	       ;"<SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
	       <PUT .GT ,GOAL-FUNCTION ,I-TRAVELER-TO-GRNZ>"
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)
       (<ZERO? .GARG>
	<COND (<EQUAL? .L ,REST-ROOM-REAR ,REST-ROOM-REAR-DINER
			  ,OTHER-REST-ROOM-REAR>
	       <SET GT <MOVE-PERSON ,BAD-SPY <V-REAR <GETP ,BAD-SPY ,P?CAR>>>>
	       <COND (<I-TRAVELER-SEEKS-TICKET ,G-REACHED>
		      <SET GT T>)>
	       <COND (,IDEBUG <TELL N .GT C !\] CR>)>
	       <RETURN .GT>)
	      (T
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)
       (T
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)>
 <COND (<OR <NOT <ZERO? .V>> ,DEBUG ,IDEBUG>
	<COND (<ZERO? .V> <TELL C !\[>)>
	<TELL CHE ,BAD-SPY .STR HIM .OBJ "." CR>)>>

<ROUTINE I-TRAVELER-PASSED-CUSTOMS ("OPTIONAL" (GARG <>) "AUX" V STR OBJ GT L)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-TRAVELER-PASSED-CUSTOMS:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-TRAVELER-PASSED-CUSTOMS> <RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<==? .GARG ,G-REACHED>
	<COND (<EQUAL? .L ,VESTIBULE-REAR-DINER>
	       <SET STR " kicks">
	       <SET OBJ ,MACHINE>
	       <SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
	       <PUT .GT ,GOAL-SCRIPT ,I-TRAVELER-SEEKS-LIGHTER>
	       <PUT .GT ,GOAL-ENABLE 1>
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,VESTIBULE-FWD 1>
	       <CALL-FOR-PROP ,CIGARETTE ,BAD-SPY>)
	      (<EQUAL? ,PASSOBJECT ,LIGHTER>
	       <ESTABLISH-GOAL-TRAIN,BAD-SPY ,VESTIBULE-REAR-DINER ,DINER-CAR>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)
	      (<EQUAL? ,PASSOBJECT ,FLOWER-GLOBAL>
	       <SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
	       <PUT .GT ,GOAL-SCRIPT ,STOP-WALKING-F>
	       <PUT .GT ,GOAL-ENABLE 1>
	       <ESTABLISH-GOAL ,BAD-SPY <V-REAR <GETP ,BAD-SPY ,P?CAR>>>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)
	      (T
	       <NEW-LDESC ,BAD-SPY 35 ;"deep in thought">
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)
       (T
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)>
 <COND (<OR .V ,DEBUG ,IDEBUG>
	<COND (<ZERO? .V> <TELL C !\[>)>
	<TELL CHE ,BAD-SPY .STR HIM .OBJ "." CR>)>>

<ROUTINE STOP-WALKING-F ("OPTIONAL" (GARG <>))
 <COND (<==? .GARG ,G-DEBUG>
	<TELL "[STOP-WALKING-F:">
	<RFALSE>)>
 <COND (<PAUSE-SCRIPT? STOP-WALKING-F> <RFALSE>)>
 <COND (<OR <ZERO? .GARG> <==? .GARG ,G-REACHED>>
	<NEW-LDESC ,BAD-SPY 1 ;"looking at you with suspicion">
	<RFALSE>)>>

<ROUTINE I-TRAVELER-TO-GRNZ ("OPTIONAL" (GARG <>))
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-TRAVELER-TO-GRNZ:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT? I-TRAVELER-TO-GRNZ> <RFALSE>)
       (<OR <ZERO? .GARG> <==? .GARG ,G-REACHED>>
	<NEW-LDESC ,BAD-SPY 1 ;"looking at you with suspicion">
	<ENABLE <QUEUE I-TRAVELER -1>>)>
 <COND (,IDEBUG <TELL "0]" CR>)>
 <RFALSE>>

<ROUTINE I-TRAVELER-SEEKS-LIGHTER ("OPTIONAL" (GARG <>) "AUX" V STR OBJ GT L)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-TRAVELER-SEEKS-LIGHTER:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-TRAVELER-SEEKS-LIGHTER> <RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<==? .GARG ,G-REACHED>
	<COND (<==? .L <V-FWD 1>>
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,VESTIBULE-REAR ,CAR-MAX>)
	      (T
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,VESTIBULE-FWD 1>)>
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)
       (<==? .GARG ,G-ENROUTE>
	<COND (<OR <==? .L <META-LOC ,LIGHTER>>
		   <AND <ZERO? .V>
			<NOT <FSET? .L ,SEENBIT>>
			<CALL-FOR-PROP ,LIGHTER ,BAD-SPY>>>
	       <SET STR " acquires ">
	       <SET OBJ ,LIGHTER>
	       <FCLEAR ,LIGHTER ,TAKEBIT>
	       <MOVE ,LIGHTER ,BAD-SPY>
	       <SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
	       <PUT .GT ,GOAL-SCRIPT ,STOP-WALKING-F>
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,VESTIBULE-REAR ,CAR-MAX>)
	      (T
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)>
 <COND (<OR <NOT <ZERO? .V>> ,DEBUG ,IDEBUG>
	<COND (<ZERO? .V> <TELL C !\[>)>
	<TELL CHE ,BAD-SPY .STR A .OBJ "." CR>)>>

<ROUTINE I-TRAVELER-SEEKS-KNIFE ("OPTIONAL" (GARG <>) "AUX" V STR OBJ GT L)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-TRAVELER-SEEKS-KNIFE:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-TRAVELER-SEEKS-KNIFE> <RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<==? .GARG ,G-REACHED>
	<COND (<==? .L ,VESTIBULE-REAR-DINER>
	       <SET STR " pulls">
	       <SET OBJ ,STOP-CORD>
	       <ESTABLISH-GOAL ,BAD-SPY ,GALLEY>)
	      (<==? .L ,GALLEY>
	       <SET STR " finds">
	       <SET OBJ ,KNIFE>
	       <FCLEAR ,KNIFE ,TAKEBIT>
	       <MOVE ,KNIFE ,BAD-SPY>
	       <PUT <GET ,GOAL-TABLES ,BAD-SPY-C>
		    ,GOAL-FUNCTION
		    ,STOP-WALKING-F>
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,COMPARTMENT-1<+ 1 ,DINER-CAR>>)
	      (T
	       <NEW-LDESC ,BAD-SPY 26 ;"waiting">
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)
       (T
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)>
 <COND (<OR <NOT <ZERO? .V>> ,DEBUG ,IDEBUG>
	<COND (<ZERO? .V> <TELL C !\[>)>
	<TELL CHE ,BAD-SPY " appears and" .STR HIM .OBJ C !\. CR>)>
 <COND (<==? .OBJ ,STOP-CORD>
	<STOP-CORD-F T>
	<COND (,IDEBUG <TELL "(1)]" CR>)>
	<RTRUE>)>
 <COND (,IDEBUG <TELL N .V C !\] CR>)>
 .V>

<ROUTINE I-TRAVELER-FINDS-CONTACT ("OPTIONAL" (GARG <>) "AUX" V STR OBJ GT L)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-TRAVELER-FINDS-CONTACT:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT?  I-TRAVELER-FINDS-CONTACT> <RFALSE>)>
 <SET L <LOC ,BAD-SPY>>
 <SET V <VISIBLE? ,BAD-SPY>>
 <COND (<==? .GARG ,G-REACHED>
	<COND (<EQUAL? .L ,REST-ROOM-MEN ,REST-ROOM-WOMEN>
	       <ESTABLISH-GOAL ,BAD-SPY ,PLATFORM-B>
	       <SET V <REST-ROOM-STATION-F ,M-OTHER>>
	       <COND (,IDEBUG <TELL N .V C !\] CR>)>
	       <RETURN .V>)
	      (<==? .L ,PLATFORM-B>
	       ;<SET V <MOVE-PERSON ,BAD-SPY <V-REAR 2>>>
	       <ESTABLISH-GOAL-TRAIN ,BAD-SPY ,COMPARTMENT-START ,CAR-START>
	       <SETG LEAVE-TRAIN-PERSON -1>
	       <ENABLE <QUEUE I-LEAVE-TRAIN 1>>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE ;GT>)
	      (<EQUAL? .L,COMPARTMENT-START<GETP ,COMPARTMENT-START ,P?OTHER>>
	       <FCLEAR ,BAD-SPY ,TOUCHBIT>
	       <PUTP ,BAD-SPY ,P?LDESC 4 ;"chewing gum">
	       <ENABLE <QUEUE I-TRAVELER -1>>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)
	      (<==? .L ,PLATFORM-A>
	       <ESTABLISH-GOAL ,BAD-SPY ,PLATFORM-E>)
	     (T<ESTABLISH-GOAL ,BAD-SPY ,PLATFORM-A>)>
	<SET V <I-TRAVELER-FINDS-CONTACT ,G-ENROUTE>>
	<COND (,IDEBUG <TELL N .V C !\] CR>)>
	<RETURN .V>)
       (<==? .GARG ,G-ENROUTE>
	<COND (<==? .L <LOC ,CONTACT>>
	       <FCLEAR ,CONTACT ,NDESCBIT>
	       <SET STR " finds">
	       <SET OBJ ,CONTACT>
	       <SET GT <GET ,GOAL-TABLES ,BAD-SPY-C>>
	       <PUT .GT ,GOAL-ENABLE 0>
	       <ENABLE <QUEUE I-TRAVELER-FINDS-CONTACT -1>>)
	      (T
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)
       (<ZERO? .GARG>
	<COND (<ZERO? ,PASSOBJECT-GIVEN-OTHER>
	       <SETG PASSOBJECT-GIVEN-OTHER T>
	       <FCLEAR ,CONTACT ,TOUCHBIT>
	       <PUTP ,CONTACT ,P?LDESC 1 ;"looking at you susp.">
	       <SET STR " shows">
	       <SET OBJ ,PASSOBJECT>)
	      (<ZERO? ,PASSWORD-GIVEN-OTHER>
	       <SETG PASSWORD-GIVEN-OTHER T>
	       <FCLEAR ,BAD-SPY ,TOUCHBIT>
	       <PUTP ,BAD-SPY ,P?LDESC 1 ;"looking at you susp.">
	       <SET STR " talks to">
	       <SET OBJ ,CONTACT>)
	      (<NOT <EQUAL? ,SCENERY-OBJ ;,STATION-NAME ,STATION-GOLA>>
	       <WHISPER-PLAN-OTHER>
	       <COND (,IDEBUG <TELL "(1)]" CR>)>
	       <RTRUE>)
	      (<IN? ,FILM ,BAD-SPY>
	       <MOVE ,FILM ,CONTACT>
	       <SET STR " hands over">
	       <SET OBJ ,FILM>)
	      (T
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)>
 <COND (<OR <NOT <ZERO? .V>> ,DEBUG ,IDEBUG>
	<COND (<ZERO? .V> <TELL C !\[>)>
	<TELL CHE ,BAD-SPY .STR HIM .OBJ C !\. CR>
	<COND (<==? .OBJ ,FILM>
	       <TELL
CHE ,CONTACT " quickly inspects" HIM .OBJ " and then pumps" ;" the "
HIS ;D ,BAD-SPY ;"'s" " hand with obvious gratitude." CR>)>)>
 <COND (<==? .OBJ ,FILM>
	<TELL
"(In case you hadn't noticed, I'll tell you that the " D ,BAD-SPY>
	<THIS-IS-IT ,BAD-SPY>
	<TELL
" just completed" HIS ,BAD-SPY " mission. There's no point in
continuing this story, but better luck next time!)" CR>
	<FINISH>)>
 <COND (,IDEBUG <TELL N .V C !\] CR>)>
 .V>

<ROUTINE G-FINISH ("OPTIONAL" (GARG <>) "AUX" V STR OBJ GT L)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[G-FINISH:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<PAUSE-SCRIPT? G-FINISH ,CONTACT> <RFALSE>)>
 <SET L <LOC ,CONTACT>>
 <SET V <VISIBLE? ,CONTACT>>
 <COND (<==? .GARG ,G-REACHED>
	<TELL "(At this point," THE ,CONTACT>
	<THIS-IS-IT ,CONTACT>
	<COND (<==? ,SCENERY-OBJ ,STATION-FRBZ>
	       <TELL
" has given up on passing on" THE ,MCGUFFIN " as" HE ,CONTACT "expected.">)
	      (T
	       <TELL
" has given up on receiving" THE ,MCGUFFIN " as" HE ,CONTACT "expected. "
CHE ,CONTACT " is going to contact those who sent" THE ,MCGUFFIN " in the
first place, and they will arrange for an alternate courier, who will,
in the end, ">
	       <COND (<SPY?>
		      <TELL
"succeed. In other words, you have, in the end, failed.">)
		     (T <TELL "fail, just as you have.">)>)>
	<TELL " Better luck next time!)" CR>
	<FINISH>)>>

<ROUTINE FINAL-SCENE ("AUX" X)
	<SET X <FIND-FLAG-LG ,HERE ,WINDOWBIT>>
	<COND (.X <TELL
"You can see two agents leave" HIM ,VEHICLE " and board the train." CR>)>
	<COND (<==? ,CAR-HERE ,FANCY-CAR>
	       <COND (.X <TELL "They">) (T <TELL "Two agents">)>
	       <TELL
" appear, dispatch" HIM ,THUG ", and escort" HIM ,DEFECTOR>)
	      (T <TELL
"You hear a commotion to the rear. It must be" HE ,DEFECTOR " being
escorted">)>
	<TELL " off the train.|
|
CONGRATULATIONS!|
">
	<COND (<HARD?> <AWARD>)>
	<FINISH>>

<ROUTINE AWARD ()
	<TELL "|
|
You deserve an award for such brilliant work on this mission!|
If you want it printed, please turn on your printer and type YES; otherwise,
type NO.">
	<COND (<YES?> <PUT 0 8 <BOR <GET 0 8> 1>>)>
	<TELL
"|
|
|
*****************************************************************************|
*****************************************************************************|
***                                                                       ***|
***                                                                       ***|
***    *   *******    *******   ******    *******   ******   ********* TM ***|
***   ***  ********  ********  **    **  ********  **    **  **********   ***|
***   ***  **    **  **        **    **  **        **    **  **  **  **   ***|
***   ***  **    **  ********  **    **  **        **    **  **  **  **   ***|
***   ***  **    **  ********  **    **  **        **    **  **  **  **   ***|
***   ***  **    **  **        **    **  ********  **    **  **  **  **   ***|
***   ***  **    **  **         ******    *******   ******   **  **  **   ***|
***                                                                       ***|
***                                                                       ***|
***                         hereby grants this                            ***|
***                                                                       ***|
***                     DISTINGUISHED SERVICE AWARD                       ***|
***                                                                       ***|
***                      for Doing the Right Thing                        ***|
***                                                                       ***|
*">
	<COND (<SPY?> <TELL
"**                       as an Undercover Agent                          ***"
>)
	      (T <TELL
"**                       as an Innocent Traveler                         ***"
>)>
	<TELL
"|
***                                                                       ***|
***            in CHECKPOINT, an interactive story of intrigue            ***|
***                                                                       ***|
***        Copyright (c) 1985 by Infocom, Inc. All rights reserved.       ***|
*****************************************************************************|
*****************************************************************************|
">>
