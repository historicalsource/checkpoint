"THINGS for CHECKPOINT
Copyright (C) 1985 Infocom, Inc.  All rights reserved."

;<OBJECT PSEUDO-OBJECT
	(DESC "pseudo")		;"Place holder (MUST BE 6 CHARACTERS!!!!!)"
	(ACTION NULL-F)>	"Place holder"

<ROUTINE RANDOM-PSEUDO ()
	 <TELL "You can't do anything useful with that." CR>>

<OBJECT NOT-HERE-OBJECT
	(DESC "that thing")
	(FLAGS NARTICLEBIT)
	(CONTFCN NULL-F)	;"to establish property"
	(ACTION NOT-HERE-OBJECT-F)>

<ROUTINE NOT-HERE-OBJECT-F ("AUX" TBL (PRSO? T) OBJ)
	;"Protocol: return ,M-FATAL if case was handled and msg TELLed,
			  <> if PRSO/PRSI ready to use"
	<COND ;"This COND is game independent (except the TELL)"
	       (<AND <EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		     <EQUAL? ,PRSI ,NOT-HERE-OBJECT>>
		<TELL "(Those things aren't here!)" CR>
		<RFATAL>)
	       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>)
	       (T
		<SET TBL ,P-PRSI>
		<SET PRSO? <>>)>
	 <COND (<AND <VERB? ASK-ABOUT ASK-FOR SEARCH-FOR>
		     <FSET? ,PRSO ,PERSONBIT>
		     <IN? ,PRSO ,GLOBAL-OBJECTS>>
		<NOT-HERE-PERSON ,PRSO>
		<RFATAL>)>
	 <COND (<OR <AND .PRSO? <PRSO-VERB?>>
		    <AND <NOT .PRSO?> <PRSI-VERB?>>>
		<COND (<SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
		       <COND (<NOT <==? .OBJ ,NOT-HERE-OBJECT>>
			      <RFATAL>)>)
		      (T
		       <RFALSE>)>)>
	 ;"Here is the default 'cant see any' printer"
	 <TELL "(You can't see any">
	 <NOT-HERE-PRINT>
	 <TELL " here!)" CR>
	 <RFATAL>>

<ROUTINE PRSO-VERB? ("OPTIONAL" (V <>) (W <>))
 <COND (<NOT .V> <SET V ,PRSA>)>
 <COND (<NOT .W> <SET W ,WINNER>)>
 <COND (<SPEAKING-VERB? .V>
	<RTRUE>)
       (<EQUAL? .V ,V?$WHERE ,V?ASK-CONTEXT-ABOUT ,V?ASK-CONTEXT-FOR> <RTRUE>)
       (<EQUAL? .V ,V?$FCLEAR ,V?$FSET ,V?$QFSET>	<RTRUE>)
       (<EQUAL? .V ,V?BOARD ,V?BUY ,V?DISEMBARK>	<RTRUE>)
       (<EQUAL? .V ,V?EXAMINE ,V?FIND ,V?FOLLOW>	<RTRUE>)
       (<EQUAL? .V ,V?LEAVE ,V?PHONE ,V?THROUGH>	<RTRUE>)
       (<EQUAL? .V ,V?USE ,V?WAIT-FOR ,V?WALK-TO>	<RTRUE>)
       (<EQUAL? .V ,V?WHAT ;,V?WIND ,V?PASS>		<RTRUE>)
       (<EQUAL? .V ,V?SHOOT ,V?SIT ,V?LIE>		<RTRUE>)
       (<AND <NOT <==? .W ,PLAYER>>
	     <EQUAL? .V ,V?BRING ,V?TAKE ,V?SSHOW>>
	<RTRUE>)>>

<ROUTINE PRSI-VERB? ("OPTIONAL" (V <>) (W <>))
 <COND (<NOT .V> <SET V ,PRSA>)>
 <COND (<NOT .W> <SET W ,WINNER>)>
 <COND (<EQUAL? .V ,V?$WHERE ,V?ASK-ABOUT ,V?ASK-FOR>		<RTRUE>)
       (<EQUAL? .V ,V?SEARCH-FOR ,V?TAKE-TO ,V?TELL-ABOUT>	<RTRUE>)
       (<EQUAL? .V ,V?SSHOOT>					<RTRUE>)
       (<AND <NOT <==? .W ,PLAYER>>
	     <EQUAL? .V ,V?SBRING ,V?SHOW>>
	<RTRUE>)>>

<ROUTINE GEN-TEST (OBJ)
	<COND (<IN? .OBJ ,HERE>
	       <RTRUE>)
	      (<CORRIDOR-LOOK .OBJ>
	       <RTRUE>)
	      (<AND <OR <VERB? FOLLOW> <REMOTE-VERB?>>
		    <FSET? .OBJ ,PERSONBIT>
		    <FSET? .OBJ ,SEENBIT>>
	       <RTRUE>)>>

"<GLOBAL L-PRSO-NOT-HERE <>>
<GLOBAL L-PRSI-NOT-HERE <>>"

<ROUTINE FIND-NOT-HERE (TBL PRSO? "AUX" M-F OBJ LEN CNT (LOCAL 0))
	;"Protocol: return T if case was handled and msg TELLed,
	    ,NOT-HERE-OBJECT if 'can't see' msg TELLed,
			  <> if PRSO/PRSI ready to use"
	;"Here is where special-case code goes. <MOBY-FIND .TBL> returns
	   number of matches. If 1, then P-MOBY-FOUND is it. One may treat
	   the 0 and >1 cases alike or different. It doesn't matter. Always
	   return RFALSE (not handled) if you have resolved the problem."
	<SET M-F <MOBY-FIND .TBL>>
	<COND (,DEBUG
	       <TELL "[Found " N .M-F " objects]" CR>
	       <COND (<NOT <==? 1 .M-F>>
		      <TELL "[Namely: ">
		      <SET CNT 1>
		      <SET LEN <GET .TBL ,P-MATCHLEN>>
		      <REPEAT ()
			      <COND (<DLESS? LEN 0> <RETURN>)
				    (T <TELL D <GET .TBL .CNT> ", ">)>
			      <INC CNT>>
		      <TELL "]" CR>)>)>
	<COND (<G? .M-F 1>
	       <SET CNT 0>
	       <REPEAT ()
		       <COND (<G? <SET CNT <+ .CNT 1>> .M-F>
			      <RETURN>)>
		       <SET OBJ <GET .TBL .CNT>>
		       <COND (<GEN-TEST .OBJ>
			      <COND (<G? <SET LOCAL <+ .LOCAL 1>> 1>
				     <RETURN>)
				    (ELSE
				     <SETG P-MOBY-FOUND .OBJ>)>)>>
	       <COND (<EQUAL? .LOCAL 1>
		      <SET M-F 1>)>)>
	<COND (<==? 1 .M-F>
	       <COND (,DEBUG <TELL "[Namely: " D ,P-MOBY-FOUND "]" CR>)>
	       <COND (<AND <NOT <REMOTE-VERB?>>
			   <NOT <VERB? $CALL>>
			   <NOT <VISIBLE? ,P-MOBY-FOUND>>>
		      <NOT-HERE ,P-MOBY-FOUND>
		      <RETURN T ;,NOT-HERE-OBJECT>)>
	       <COND (.PRSO?
		      <SETG PRSO ,P-MOBY-FOUND>
		      ;<SETG L-PRSO-NOT-HERE ,PRSO>)
		     (T
		      <SETG PRSI ,P-MOBY-FOUND>
		      ;<SETG L-PRSI-NOT-HERE ,PRSI>)>
	       ;<THIS-IS-IT ,P-MOBY-FOUND>
	       <RFALSE>)
	     (<AND <L? 1 .M-F>
		   <FSET? <SET OBJ <GET .TBL 1>> ,PERSONBIT>>
	      ;<SET FOUND 0>
	      <SET CNT 1>
	      <SET LEN <GET .TBL ,P-MATCHLEN>>
	      <REPEAT ()
		      <SET OBJ <GET .TBL .CNT>>
		      <COND (<NOT <GEN-TEST .OBJ>>
			     <DEC LEN>
			     <ELIMINATE .TBL .CNT .LEN>
			     <COND (<NOT <G? .CNT .LEN>> <AGAIN>)>)>
		      <COND (<IGRTR? CNT .LEN> <RETURN>)>>
	      <PUT .TBL ,P-MATCHLEN .LEN>
	      <COND (<0? .LEN>
		     ;<TELL "(You can't see any">
		     ;<NOT-HERE-PRINT>
		     ;<TELL " here.)" CR>
		     <RETURN ,NOT-HERE-OBJECT>)
		    (<NOT <1? .LEN>>
		      <WHICH-PRINT 0 .LEN .TBL>
		      <SETG P-ACLAUSE
			     <COND (<==? .TBL ,P-PRSO> ,P-NC1)
				   (T ,P-NC2)>>
		      <SETG P-AADJ ,P-ADJ>
		      <SETG P-ANAM ,P-NAM>
		      <ORPHAN <> <>>
		      <SETG P-OFLAG T>
		      <RTRUE>)>
	      <COND (,DEBUG <TELL "[Corridor: " D .OBJ "]" CR>)>
	      <COND (.PRSO?
		     <SETG PRSO .OBJ>
		     ;<SETG L-PRSO-NOT-HERE ,PRSO>)
		    (T
		     <SETG PRSI .OBJ>
		     ;<SETG L-PRSI-NOT-HERE ,PRSI>)>
	      <RFALSE>)
	     (<AND <L? 1 .M-F>
		   <SET OBJ <APPLY <GETP <SET OBJ <GET .TBL 1>> ,P?GENERIC>
				   .TBL>>>
	;"Protocol: returns .OBJ if that's the one to use,
		,NOT-HERE-OBJECT if case was handled and msg TELLed,
			      <> if WHICH-PRINT should be called"
	       <COND (,DEBUG <TELL "[Generic: " D .OBJ "]" CR>)>
	       <COND (<==? .OBJ ,NOT-HERE-OBJECT> <RTRUE>)
		     (.PRSO?
		      <SETG PRSO .OBJ>
		      ;<SETG L-PRSO-NOT-HERE ,PRSO>)
		     (T
		      <SETG PRSI .OBJ>
		      ;<SETG L-PRSI-NOT-HERE ,PRSI>)>
	       ;<THIS-IS-IT .OBJ>
	       <RFALSE>)
	      (<OR <AND <NOT .PRSO?>
			<IN? ,PRSO ,HERE>
			<VERB? ASK-ABOUT ASK-FOR TELL-ABOUT>>
		   <AND .PRSO?
			<QCONTEXT-GOOD?>
			<VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR>>
		   <AND <NOT <==? ,WINNER ,PLAYER>>
			<VERB? FIND WHAT GIVE SGIVE>>>
	       <COND (<VERB? ASK-ABOUT ASK-FOR>
		      <SET LEN ,PRSO>)
		     (<QCONTEXT-GOOD?>
		      <SET LEN ,QCONTEXT>)
		     (<NOT <==? ,WINNER ,PLAYER>>
		      <SET LEN ,WINNER>)
		     (<SET OBJ <FIND-FLAG ,HERE ,PERSONBIT ,WINNER ;,PLAYER>>
		      <SET LEN .OBJ>)
		     (T <SET LEN ,GAME>)>
	       <START-SENTENCE .LEN>
	       <TELL V .LEN say ", ">
	       <PRODUCE-GIBBERISH>
	       <RTRUE>)
	      (<NOT .PRSO?>
	       <TELL "You wouldn't find any">
	       <NOT-HERE-PRINT>
	       <TELL " there." CR>
	       <RTRUE>)
	      (T ,NOT-HERE-OBJECT)>>

<ROUTINE NOT-HERE-PRINT ()
 <COND (<OR ,P-OFLAG ,P-MERGED>
	<COND (,P-XADJ
	       <TELL " ">
	       <PRINTB %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
			       ',P-XADJ)
			      (T
			       ',P-XADJN)>>)>
	<COND (,P-XNAM
	       <TELL " ">
	       <PRINTB ,P-XNAM>)>)
       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC1> <GET ,P-ITBL ,P-NC1L> <>>)
       (T
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC2> <GET ,P-ITBL ,P-NC2L> <>>)>>

<OBJECT TICKET
	(LOC POCKET)
	(CAR 1)
	(DESC "your ticket")
	(ADJECTIVE MY)
	(SYNONYM TICKET)
	(FLAGS TAKEBIT NARTICLEBIT)
	(SIZE 1)
	(CAPACITY STATION-GOLA)
	(ACTION TICKET-F)>

<OBJECT TICKET-OTHER
	(CAR 1)
	(DESC "other ticket")
	(ADJECTIVE OTHER)
	(SYNONYM TICKET)
	(FLAGS VOWELBIT NDESCBIT)
	(SIZE 1)
	(CAPACITY STATION-GOLA)
	(ACTION TICKET-F)>

<GLOBAL TICKET-VIA <>>
<GLOBAL TICKET-OTHER-VIA <>>

<ROUTINE GIVE-SHOW (P1 P2)
 <COND (<VERB? GIVE>
	<COND (<EQUAL? ,PRSI .P1 .P2>
	       <RETURN ,PRSO>)>)
       (<VERB? SHOW>
	<COND (<EQUAL? ,PRSO .P1 .P2>
	       <RETURN ,PRSI>)>)>>

<ROUTINE TICKET-F ("AUX" COST OBJ TKT)
 <COND (<VERB? ANALYZE EXAMINE READ>
	<TELL
"All you can make out is the destination: " D <GETP ,PRSO ,P?CAPACITY>>
	<COND (<AND <DOBJ? TICKET> ,TICKET-VIA>
	       <TELL " via " D ,TICKET-VIA>)
	      (<AND <DOBJ? TICKET-OTHER> ,TICKET-OTHER-VIA>
	       <TELL " via " D ,TICKET-OTHER-VIA>)>
	<TELL "." CR>)
       (<SET TKT <GIVE-SHOW ,CONDUCTOR ,GUARD>>
	<COND (<==? .TKT ,PRSO> <SET OBJ ,PRSI>)
	      (<==? .TKT ,PRSI> <SET OBJ ,PRSO>)
	      (T <TELL "[BUG #1]" CR>)>
	<COND (<NOT ,ON-TRAIN>
	       <TELL
CTHE .OBJ " looks at" HIM .TKT " and points to this train track." CR>
	       <RTRUE>)>)
       (<AND <VERB? BUY BUY-TICKET> <DOBJ? TICKET TICKET-OTHER>>
	<COND (<NOT <==? ,HERE ,TICKET-AREA>>
	       <YOU-CANT>
	       <RTRUE>)
	      (<OR <VERB? BUY> <NOT ,PRSI>>
	       <SETG CLOCK-WAIT T>
	       <TELL "(You didn't say where the ticket is for.)" CR>
	       <RTRUE>)>
	<SET COST <GETP ,PRSI ,P?NORTH>>
	<COND (<OR <NOT <G? .COST 0>> <FSET? ,PRSI ,PERSONBIT>>
	       <TELL "You can't buy a ticket to" THE ,PRSI "." CR>
	       <RTRUE>)
	      (<G? .COST <GETP ,PLAYER ,P?SOUTH>>
	       <TELL "You don't have enough money." CR>
	       <RTRUE>)>
	<PUTP ,PLAYER ,P?SOUTH <- <GETP ,PLAYER ,P?SOUTH> .COST>>
	<PUTP ,PRSO ,P?CAPACITY ,PRSI>
	<COND (<AND <NOT <ZMEMZ ,PRSI ,TRAIN-TABLE>>
		    <NOT <==? ,SCENERY-OBJ ,STATION-KNUT>>>
	       <COND (<DOBJ? TICKET>
		      <SETG TICKET-VIA ,STATION-KNUT>)
		     (<DOBJ? TICKET-OTHER>
		      <SETG TICKET-OTHER-VIA ,STATION-KNUT>)>)
	      (T
	       <COND (<DOBJ? TICKET>
		      <SETG TICKET-VIA <>>)
		     (<DOBJ? TICKET-OTHER>
		      <SETG TICKET-OTHER-VIA <>>)>)>
	<MOVE ,PRSO ,PLAYER>
	<TELL CTHE ,CLERK " takes your money and stamps " D ,PRSO "." CR>)>>

<OBJECT PASSPORT
	(LOC POCKET)
	(CAR 1)
	(DESC "your passport")
	(ADJECTIVE MY)
	(SYNONYM PASSPORT)
	(FLAGS TAKEBIT NARTICLEBIT)
	(SIZE 2)
	(ACTION PASSPORT-F)>

<ROUTINE PASSPORT-F ()
 <COND (<VERB? READ OPEN>
	<PERFORM ,V?EXAMINE ,PRSO ,PRSI>
	<RTRUE>)>>

<OBJECT CHECK
	(LOC POCKET)
	(CAR 1)
	(DESC "traveler's check")
	(ADJECTIVE MY ;TRAVELER\'S TRAVELER TRAVELLER TRAVELERS)
	(SYNONYM CHECK CHEQUE)
	(FLAGS TAKEBIT READBIT)
	(SIZE 1)
	(ACTION CHECK-F)
	(TEXT
"It's your last $10 Mariners' Trust traveler's check, \"accepted and even
revered the world over.\"")>

<ROUTINE CHECK-F ("AUX" P)
 <COND (<VERB? ANALYZE ;READ>
	<PERFORM ,V?EXAMINE ,PRSO ,PRSI>
	<RTRUE>)
       (<VERB? SHOW>
	<COND (<AND <DOBJ? WAITER CLERK>
		    <NOT <FSET? ,PEN ,TOUCHBIT>>>
	       ;<IN? ,PEN ,PRSO>
	       <MOVE ,PEN ,PRSO>
	       <FCLEAR ,PEN ,NDESCBIT>
	       <FSET ,PEN ,TAKEBIT>
	       <TELL CHE ,PRSO nod " and" V ,PRSO display " " A ,PEN "." CR>)
	      (<DOBJ? CONDUCTOR GUARD WAITRESS>
	       <TELL CHE ,PRSO " shakes" HIS ,PRSO " head and points ">
	       <COND (<EQUAL? ,HERE ,CAFE>
		      <TELL "toward" HIM ,TICKET-AREA "." CR>)
		     (<NOT ,ON-TRAIN>
		      <TELL "into the station." CR>)
		     (<L? ,CAR-HERE ,DINER-CAR>
		      <TELL "to the rear." CR>)
		     (<G? ,CAR-HERE ,DINER-CAR>
		      <TELL "forward." CR>)
		     (T <TELL "to a booth." CR>)>)>)
       (<VERB? SIGN USE>
	<COND (<OR <IN? <SET P ,WAITER> ,HERE>
		   <IN? <SET P ,CLERK> ,HERE>>
	       <COND (<OR <IOBJ? PEN>
			  <NOT <FSET? ,PEN ,TOUCHBIT>>
			  <EQUAL? <LOC ,PEN> ,PLAYER ,POCKET>>
		      <TELL CTHE .P>
		      <COND (<NOT <FSET? ,PEN ,TOUCHBIT>> ;<IN? ,PEN .P>
			     <TELL " lends you a pen and then">
			     <MOVE ,PEN ,PLAYER>
			     <FCLEAR ,PEN ,NDESCBIT>
			     <FSET ,PEN ,TOUCHBIT>)>
		      <MOVE ,CHECK .P>
		      <FCLEAR ,CHECK ,TAKEBIT>
		      <PUTP ,PLAYER ,P?SOUTH <+ 20 <GETP ,PLAYER ,P?SOUTH>>>
		      <TELL " gives you ">
		      <PRINTC ,CURRENCY-SYMBOL>
		      <TELL "20 in exchange for the check." CR>)
		     (T <TELL
CTHE .P " shakes his head and shrugs his shoulders." CR>)>)>)>>

<OBJECT CAMERA
	(CAR 1)
	(LOC LIMBO-FWD)
	(DESC "miniature camera")
	(FLAGS CONTBIT SEARCHBIT TAKEBIT)
	(SYNONYM CAMERA SHUTTER)
	(CAPACITY 1)
	(SIZE 3)
	(ADJECTIVE MINIATURE)
	(ACTION CAMERA-F)>

<GLOBAL CAMERA-COCKED <>>

<ROUTINE CAMERA-F ()
 <COND (<AND <IN? ,CAMERA ,POCKET>
	     <VERB? AIM CLOSE EXAMINE LOOK-THROUGH OPEN SHOOT WIND>>
	<MOVE ,CAMERA ,PLAYER>)>
 <COND (<VERB? AIM>
	<COND (<DOBJ? CAMERA>
	       <TELL "Okay, then what?" CR>)>)
       (<VERB? EXAMINE>
	<COND (<FSET? ,PRSO ,OPENBIT>
	       <RFALSE>)
	      (<AND <IN? ,FILM ,CAMERA> <NOT ,CAMERA-COCKED>>
	       <TELL "It looks as if it needs to be cocked." CR>)
	      (T <TELL
"Ah! Is this the masterwork of some paranoid genius in \"Q\" Section?
A product of years of technological innovation, bordering on magic?
Nah, it's just an ordinary " D ,CAMERA " -- no weapons, no motors,
nothing to break down. And it's closed." CR>)>)
       (<VERB? LOOK-THROUGH>
	<TELL "Everything appears normal." CR>)
       (<VERB? OPEN>
	<COND (,CAMERA-COCKED
	       <PUT ,FILM-TBL ,PICTURE-NUMBER -1>
	       <RFALSE>)>)
       (<VERB? SHOOT>
	<COND (<EQUAL? ,PRSI ,CAMERA>
	       <PERFORM ,V?PHOTO ,PRSO ,PRSI>
	       <RTRUE>)>)
       (<VERB? WIND>
	<COND (<OR <FSET? ,CAMERA ,OPENBIT>
		   <NOT <IN? ,FILM ,CAMERA>>
		   ,CAMERA-COCKED
		   <G? ,PICTURE-NUMBER 3>>
	       <TELL "You try to cock it, but the lever won't move." CR>
	       ;<YOU-CANT>)
	      (T
	       <SETG PICTURE-NUMBER <+ ,PICTURE-NUMBER 1>>
	       <SETG CAMERA-COCKED T>
	       <TELL "Okay." CR>)>
	<RTRUE>)>>

<OBJECT PICTURE-GLOBAL
	(LOC GLOBAL-OBJECTS)
	(DESC "picture")
	(SYNONYM PHOTO ;"PICTURE PHOTOGRAPH")>

<OBJECT FILM
	(CAR 1)
	(DESC "cassette of film")
	(FLAGS TAKEBIT)
	(SYNONYM MICROFILM FILM CASSETTE)
	(SIZE 1)
	(ACTION FILM-F)>

<ROUTINE FILM-F ()
 <COND (<VERB? WIND>
	<PERFORM ,PRSA ,CAMERA>
	<RTRUE>)
       (<VERB? EXAMINE READ>
	<TELL
"It looks like instant-developing film, in a special miniature format." CR>)>>

<GLOBAL PICTURE-NUMBER 0>	"the camera can take only four pictures"

"OBSOLETE!  SEE BELOW!
FILM-TBL is where the pictures live. Each exposure is a table, whose entries
have the following meanings.
ZEROTH: If this is false it means a special case is being handled; slot
one will contain a description string stuffed in it by TAKE-PICTURE.
Otherwise it contains the number of objects contained in the picture's
subject.
FIRST: the room, if any, that the object is in.
If this is false the object was in LOCAL-GLOBALS or GLOBAL-OBJECTS
SECOND: the picture subject.
THIRD: and following -- objects contained in object to one level

<GLOBAL FILM-TBL
	<TABLE <TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 >
	       <TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 >
	       <TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 >
	       <TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 >>>"

"FILM-TBL tells the subject of each picture."

<GLOBAL FILM-TBL <LTABLE 0 0 0 0>>

<GLOBAL LENS-CRACKED <>>

<OBJECT GLASS
	(CAR 1)
	(LOC LIMBO-FWD)
	(DESC "magnifying glass")
	;(LDESC "A large magnifying glass.")
	(FLAGS ;FLAMEBIT TAKEBIT TRANSBIT)
	(SYNONYM GLASS LENS)
	(ADJECTIVE MAGNIFYIN)
	(SIZE 2)
	(ACTION GLASS-F)>

<ROUTINE GLASS-F ("AUX" X CNT)
 <COND (<VERB? LOOK-THROUGH>
	<TELL "Everything appears bigger." CR>)
       (<AND <VERB? READ EXAMINE> <EQUAL? ,PRSI ,GLASS>>
	<COND (<EQUAL? ,PRSO ,FILM>
	       <TELL
"With the aid of the magnifying glass you can just
make out what's on the film.">
	       <COND (<ZERO? ,PICTURE-NUMBER>
		      <TELL " The whole film is unexposed." CR>
		      <RTRUE>)>
	       <CRLF>
	       <SET CNT 1>
	       <REPEAT ()
		       <TELL "Picture " N .CNT " is ">
		       <SET X <GET ,FILM-TBL .CNT>>
		       <COND (<ZERO? .X> ;<NOT <L? .CNT ,PICTURE-NUMBER>>
			      <TELL "unexposed.">)
			     (<==? -1 .X>
			      <TELL "fogged.">)
			     (T
			      <TELL "a picture of ">
			      <COND (<==? .X ,GLOBAL-OBJECTS>
				     <TELL "something you can't make out.">)
				    (<FSET? .X ,WINDOWBIT>
				     <TELL "a window.">)
				    (.X <TELL A .X ".">)
				    (T <TELL "nothing.">)>)>
		       <CRLF>
		       <COND (<IGRTR? CNT 4> <RETURN>)>>)
	      ;(<AND <FSET? ,PRSO ,READBIT>
		    <SET X <GETP ,PRSO ,P?TEXT>>>
	       <TELL .X CR>) 
	      (<EQUAL? ,PRSO ,GLASS>
	       <HAR-HAR>
	       ;<TELL "Don't be absurd!" CR>)
	      (<EQUAL? ,PRSO ,PLAYER ,MIRROR>
	       <TELL
"You see yourself, only bigger and uglier than ever. Ugh!" CR>)
	      (T <TELL CHE ,PRSO look " the same, only much larger." CR>)>)
       (<AND <VERB? READ EXAMINE> <EQUAL? ,PRSO ,GLASS>>
	<COND (,PRSI
	       <PERFORM ,V?READ ,PRSI ,PRSO>
	       <RTRUE>)>)
       ;(<AND <VERB? BURN> <EQUAL? ,PRSI ,GLASS>>
	<COND (<NOT <EQUAL? ,PRSI ,PRSO>>
	       <TELL
"There isn't enough light here to burn the " D ,PRSO "." CR>)
	      (T <TELL "Don't be absurd!" CR>)>)>>

<OBJECT MCGUFFIN
	(LOC LIMBO-FWD)
	(CAR 1)
	(DESC "document" ;"plan")
	(TEXT
"It's not a very handsome document, scrawled in a hurry by a hand that
wouldn't win any prizes under the best of conditions. But it seems to
contain crucial information -- times, places, a crude map, even code
words -- about a plan to kidnap some high-ranking official.
Were the plan to succeed, several governments would be embarrassed, if
not in mortal danger, and the balance of power would become precarious.")
	(FLAGS TAKEBIT ;NDESCBIT READBIT)
	(SYNONYM DOCUMENT DOCUME PLAN MCGUFFIN MACGUFFIN PAPER)
	(SIZE 16)
	(ACTION MCGUFFIN-F)>

<ROUTINE MCGUFFIN-F ()
 <COND (<VERB? MUNG>
	<SETG CLOCK-WAIT T>
	<TELL "(How do you want to do that?)" CR>)
       (<AND <VERB? CHANGE> <IOBJ? PEN>>
	<FSET ,MCGUFFIN ,LOCKED>
	<TELL
"With a deft hand, you alter" HIM ,MCGUFFIN " in a subtle way so that it
conveys serious disinformation." CR>)>>

<OBJECT SPY-LIST
	(CAR 1)
	(LOC LIMBO-FWD)
	(DESC "scrap of newsprint" ;"note")
	(FLAGS READBIT TAKEBIT ;SURFACEBIT ;BURNBIT)
	(SYNONYM SCRAP PAPER NEWSPRINT PRINT NOTE WRITING MESSAGE)
	(SIZE 1)
	(ACTION SPY-LIST-F)>

<GLOBAL LIST-RUBBED <>>

<ROUTINE SPY-LIST-F ("AUX" X)
 <COND (<VERB? EAT>
	<MOVE ,PRSO ,LIMBO-FWD>
	<TELL "Gulp!" CR>)
       (<VERB? ANALYZE EXAMINE READ>
	<COND (,LIST-RUBBED
	       <TELL "Examining the " D ,SPY-LIST>
	       <PAD-READ>)
	      (<==? ,P-ADVERB ,W?CAREFULLY>
	       <TELL
"There are some shiny lines on the " D ,SPY-LIST ", maybe invisible ink." CR>)
	      (T <TELL
"There doesn't seem to be anything written on the " D ,SPY-LIST "." CR>)>)
       (<VERB? HEAT>
	<COND (<NOT ,PRSI>
	       <TELL "It heats up like ordinary newsprint." CR>)
	      (<==? ,PRSI ,LIGHTER>
	       <SETG LIST-RUBBED T>
	       <TELL "Heating" HIM ,SPY-LIST " with" HIM ,PRSI>
	       <PAD-READ>)
	      (T
	       <TELL "Nothing ">
	       <COND (,LIST-RUBBED <TELL "new ">)>
	       <TELL "appears." CR>)>)
       ;"(<AND <VERB? RUN-OVER> <==? ,PRSO ,PEN>>
	<SETG LIST-RUBBED T>
	<TELL 'Running the pen over the ' D ,SPY-LIST>
	<PAD-READ>)
       (<AND <VERB? HOLD-UP LAMP-ON>
	     <OR <AND <SET X <FIND-FLAG-LG ,HERE ,WINDOWBIT>>
		      <ZERO? ,PRSI>>
		 <EQUAL? ,PRSI ,LIGHT-GLOBAL ;,LIGHTER .X>>>
	<TELL 'Looking at the ' D ,SPY-LIST ' against the light'>
	<PAD-READ>)">>

<ROUTINE PAD-READ ("AUX" CNT OBJ)
	<COND (<FSET? ,SPY-LIST ,MUNGBIT>
	       <TELL " reveals nothing intelligible." CR>
	       <RTRUE>)>
	<TELL " shows two things written on it">
	<COND (<SPY?> ;<NOT <ZERO? ,EGO>>
	       <TELL ", which you easily translate into English">)>
	<TELL ":|
">
	<SET CNT 6 ;<GET ,PASS-TABLE 0>>
	<REPEAT ()
		<SET OBJ <GET ,PASS-TABLE .CNT>>
		<COND (<EQUAL? .OBJ ,PASSWORD ,PASSOBJECT>
		       <TELL "   ">
		       <PRINTD .OBJ>
		       <CRLF>)>
		<COND (<DLESS? CNT 1> <RTRUE>)>>>

<OBJECT BRIEFCASE
	;(LOC SEAT-1)
	(CAR 1)
	(FLAGS SURFACEBIT CONTBIT SEARCHBIT ;TRANSBIT ;OPENBIT TAKEBIT)
	(ADJECTIVE BRIEF LEATHER BLACK)
	(SYNONYM BRIEFCASE BRIEFC BAG CASE VALISE)
	(DESC "briefcase")
	(CAPACITY 29)
	(SIZE 30)
	(DESCFCN BRIEFCASE-F)
	(ACTION BRIEFCASE-F)>

<GLOBAL BRIEFCASE-PASSED ;"customs" <>>

<ROUTINE BRIEFCASE-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-OBJDESC>
		<TELL 
"A black briefcase with a chrome latch is here, ">
		<COND (<FSET? ,BRIEFCASE ,SURFACEBIT>
		       <TELL "closed." CR>)
		      (T <TELL "open." CR>)>)
	       (<VERB? EXAMINE>
		<TELL
"It's an expensive-looking case, built as sturdy as a tank.">
		<COND (<==? ,P-ADVERB ,W?CAREFULLY>
		       <CASE-CAREFUL>)>
		<CRLF>)
	       (<REMOTE-VERB?> <RFALSE>)
	       (<AND <VERB? TAKE MOVE>
		     <EQUAL? ,PRSO ,BRIEFCASE>
		     <FSET? <LOC ,BRIEFCASE> ,PERSONBIT>
		     ;<NOT <IN? ,BRIEFCASE ,PLAYER>>>
		<RFALSE>)
	       (<AND <FSET? <LOC ,BRIEFCASE> ,PERSONBIT>
		     <NOT-HOLDING? ,BRIEFCASE>>
		<RTRUE>)
	       (<AND <VERB? TAKE MOVE>
		     <EQUAL? ,PRSO ,BRIEFCASE>>
		<COND (<AND <FSET? ,BRIEFCASE ,OPENBIT>
			    <NOT ,PLAYER-SEATED>>
		       <TOO-BAD-BUT ,BRIEFCASE "open">
		       <RTRUE>)
		      (<FSET? ,BRIEFCASE ,SURFACEBIT>
		       <OBJS-SLIDE-OFF ,BRIEFCASE>
		       <RFALSE>)>)
	       (<VERB? OPEN>
		<COND (<NOT <FSET? ,BRIEFCASE-LATCH ,OPENBIT>>
		       <THIS-IS-IT ,BRIEFCASE-LATCH>
		       <TELL "The latch is closed." CR>
		       <RTRUE>)
		      (<AND <IN? ,BRIEFCASE ,PLAYER>
			    <NOT ,PLAYER-SEATED>
			    <TBL-FIRST? ,BRIEFCASE-TBL>>
		       <TELL
"You open it a crack before you realize that everything inside would fall out.
You quickly close it again." CR>
		       <RTRUE>)
		      (<AND <NOT ,LATCH-TURNED>
			    <FSET? ,BRIEFCASE ,SURFACEBIT>>
		       <TELL-GAS>)
		      (T
		       <FSET ,BRIEFCASE ,OPENBIT>
		       <TBL-TO-INSIDE ,BRIEFCASE ,BRIEFCASE-TBL>
		       <RTRUE>)>)
	       (<VERB? CLOSE>
		<FCLEAR ,BRIEFCASE ,OPENBIT>
		<INSIDE-OBJ-TO ,BRIEFCASE-TBL ,BRIEFCASE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<NOT <FSET? ,BRIEFCASE ,OPENBIT>>
		       <TOO-BAD-BUT ,BRIEFCASE "closed">
		       <RTRUE>)>)
	       (<VERB? SHAKE>
		<COND (<NOT <0? <GET ,BRIEFCASE-TBL 1>>>
		       <TELL "Hmm. Something's in there." CR>
		       <RTRUE>)>)
	       ;(<AND <VERB? PUT PUT-IN>
		     <EQUAL? ,PRSI ,BRIEFCASE>
		     <IN? ,BRIEFCASE ,WINNER>>
		<TELL "You can't do that while you're holding the briefcase."
		      ;"Try putting down the briefcase first." CR>)>>

<ROUTINE TELL-GAS ("OPTIONAL" (YOU? T))
	<COND (.YOU? <TELL
"As the lid is lifted, you hear an explosion from inside the case. P">)
	      (T <TELL
"Too late, you notice that the compartment is filled with p">)>
	<TELL "ale yellow gas, practically invisible">
	<COND (.YOU? <TELL
", hisses out of tiny vents set into the briefcase's spine">)>
	<TELL
". Holding your breath will not help: this cunning creation of the
chemical warfare chaps is absorbed through the skin. Well, \"only the
good die young.\"" CR CR>
	<FINISH ;JIGS-UP>>

<GLOBAL BRIEFCASE-TBL
	<LTABLE	;"20 Slots to hold objects"
	SPY-LIST GLASS FILM CAMERA MCGUFFIN 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>>

<GLOBAL LATCH-TURNED T>

<OBJECT BRIEFCASE-LATCH
	(DESC "briefcase latch")
	(LOC GLOBAL-OBJECTS ;BRIEFCASE)
	(FLAGS TURNBIT NDESCBIT)
	(ADJECTIVE METAL CHROME BRIEFCASE)
	(SYNONYM BAR LATCH CLASP LOCK)
	(ACTION LATCH-F)>

<ROUTINE LATCH-F ()
	 <COND (<NOT <VISIBLE? ,BRIEFCASE>>
		<NOT-HERE ,BRIEFCASE-LATCH>)
	       (<VERB? EXAMINE>
		<TELL
"The latch on the briefcase is operated by sliding a short metal bar
that points ">
		<COND (<NOT ,LATCH-TURNED>
		       <TELL "away from ">)
		      (T <TELL "toward ">)>
		<TELL "the handle of the briefcase. The latch is " >
		<COND (<NOT <FSET? ,BRIEFCASE-LATCH ,OPENBIT>>
		       <TELL "closed.">)
		      (T <TELL "open.">)>
		<COND (<==? ,P-ADVERB ,W?CAREFULLY>
		       <CASE-CAREFUL>)>
		<CRLF>)
	 (<REMOTE-VERB?> <RFALSE>)
	 (<AND <FSET? <LOC ,BRIEFCASE> ,PERSONBIT>
	       <NOT-HOLDING? ,BRIEFCASE>>
	  <RTRUE>)
	 (<VERB? REMOVE TAKE> <YOU-CANT>)
	 (<AND <VERB? TURN AIM> <EQUAL? ,PRSO ,BRIEFCASE-LATCH>>
	  <SETG LATCH-TURNED <NOT ,LATCH-TURNED>>
	  <TELL "A mechanical click comes from within the briefcase." CR>
	  <RTRUE>)
	 (<VERB? CLOSE>
	  <COND (<FSET? ,BRIEFCASE ,OPENBIT>
		 <TOO-BAD-BUT ,BRIEFCASE "open">
		 <RTRUE>)
		(<NOT <FSET? ,BRIEFCASE-LATCH ,OPENBIT>>
		 <ALREADY ,BRIEFCASE-LATCH "closed">
		 <RTRUE>)
		(T <OKAY ,BRIEFCASE-LATCH "closed">)>)
	 (<AND <VERB? PUSH OPEN RAISE MOVE SLIDE RUB>
	       <EQUAL? ,PRSO ,BRIEFCASE-LATCH>>
	  <COND (<NOT <FSET? ,BRIEFCASE-LATCH ,OPENBIT>>
		 <FSET ,BRIEFCASE-LATCH ,OPENBIT>
		 <TELL "The metal latch snaps open.">
		 <COND (<NOT ,LATCH-TURNED>
			<TELL
" At the same time, a loud thump comes from within the briefcase.">)>
		 <CRLF>)
		(T
		 <ALREADY ,PRSO "open">
		 ;<TELL "The latch is already open." CR>)>)>>

<ROUTINE CASE-CAREFUL ()
	<TELL
" A careful examination shows that the latch can be turned as well as opened.
And there are tiny vents set into the briefcase's spine.">>

<OBJECT BRIEFCASE-HANDLE
	(DESC "briefcase handle")
	(LOC GLOBAL-OBJECTS ;BRIEFCASE)
	(FLAGS NDESCBIT)
	(ADJECTIVE BRIEFCASE)
	(SYNONYM HANDLE)
	(ACTION BRIEFCASE-HANDLE-F)>

<ROUTINE BRIEFCASE-HANDLE-F ()
 <COND (<REMOTE-VERB?> <RFALSE>)
       (<NOT <VISIBLE? ,BRIEFCASE>>
	<NOT-HERE ,BRIEFCASE-HANDLE>)
       (<VERB? EXAMINE>
	<NOTHING-SPECIAL>)>>

<OBJECT PLAQUE
	(DESC "sign" ;"plaque")
	(LDESC
"A sign on the wall announces something in large, unfriendly letters.")
	(ADJECTIVE LARGE UNFRIENDLY)
	(SYNONYM SIGN LETTER)
	(ACTION PLAQUE-F)>

<ROUTINE PLAQUE-F ()
	 <COND (<VERB? ANALYZE EXAMINE READ>
		<TELL
"If you could read the language, it would say:|
\"This is the CHECKPOINT. All passengers who are crossing the frontier
must pass through customs inspection before boarding the train.|
CHECKPOINT is also a trademark and product of Infocom, Inc., "
<PICK-ONE-NEW ,CREDITS <+ 1 <MOD ,VARIATION <- <GET ,CREDITS 0> 1>>>>
".\"" CR>)>>

<GLOBAL CREDITS
	<LTABLE	0
"written and directed by Stu Galley, with a little help from his friends"
		"with some narration by Bruce Schechter"
		"dedicated to the late Sir Alfred Hitchcock"
		"proofed by the Infocom Quality Assurance Dept"
		;"with stunts staged by Marc Blank">>

"THESE ARE MIKE'S SURFACE-CONTAINER ROUTINES"

<ROUTINE TBL-FIRST? (TBL "AUX" (OFFS 0) THING MAX)
	 <SET MAX <GET .TBL 0>>
	 <REPEAT ()
		 <COND (<IGRTR? OFFS .MAX>
			<RFALSE>)
		       (<NOT <EQUAL? 0 <SET THING <GET .TBL .OFFS>>>>
			<RETURN .THING>)>>>

<ROUTINE TBL-TO-INSIDE (OBJ TBL "OPTIONAL" (STR <>)
			"AUX" THING (OFFS 0) MAX)
	 <COND (<NOT <FSET? .OBJ ,SURFACEBIT>>
		<ALREADY .OBJ "open">
		;<TELL "The " D .OBJ " is already open." CR>
		<RTRUE>)>
	 <COND (<FIRST? .OBJ>
		<OBJS-SLIDE-OFF .OBJ >)>
	 <SET MAX <GET .TBL 0>>
	 <COND (<OR ,DEBUG <NOT .STR>>
		<COND (.STR
		       <PRINTC %<ASCII !\[>>
		       <TELL "Opened." CR>)>)
	       (<NOT <1? .STR>>
		<TELL .STR CR>)>
	 <FCLEAR .OBJ ,SURFACEBIT>
	 <REPEAT ()
		 <COND (<IGRTR? OFFS .MAX>
			<RETURN>)
		       (<NOT <ZERO? <SET THING <GET .TBL .OFFS>>>>
			<COND (<IN? .OBJ ,PLAYER>
			       <FSET .THING ,TAKEBIT>)>
			<MOVE .THING .OBJ>
			<PUT .TBL .OFFS 0>)>>
	 <COND (<1? .STR> <RTRUE>)
	       (<NOT <FIRST? .OBJ>> <RTRUE>)>
	 <TELL "Opening" HIM .OBJ " reveals ">
	 <PRINT-CONTENTS .OBJ>
	 <TELL ".">
	 <CRLF>
	 <RTRUE>>

<ROUTINE INSIDE-OBJ-TO (TBL OBJ "OPTIONAL" (STR <>) "AUX" (OFFS 0) F N)
	 <COND (<FSET? .OBJ ,SURFACEBIT>
		<ALREADY .OBJ "closed">
		;<TELL "The " D .OBJ " is already closed." CR>
		<RTRUE>)>
	 <FSET .OBJ ,SURFACEBIT>
	 <COND (<OR ,DEBUG <NOT .STR>>
		<COND (.STR <PRINTC %<ASCII !\[>>)>
		<TELL "Closed." CR>)
	       (<NOT <1? .STR>>
		<TELL .STR CR>)>
	 <COND (<NOT <SET F <FIRST? .OBJ>>>
		<RTRUE>)>
	 <REPEAT ()
		 <COND (<NOT .F>
			<RETURN>)
		       (T
			<SET N .F>
			<SET F <NEXT? .N>>
			<COND ;(<EQUAL? .N ,BRIEFCASE-LATCH>)
			      (T
			       <MOVE .N ,LIMBO-FWD>	;<REMOVE .N>
			       <REPEAT ()
				       <SET OFFS <+ .OFFS 1>>
				       <COND (<EQUAL? <GET .TBL .OFFS> 0>
					      <PUT .TBL .OFFS .N>
					      <RETURN>)>>)>)>>>

<ROUTINE OBJS-SLIDE-OFF (OBJ "AUX" (SLIDE <>) THERE F N)
	 <SET THERE <LOC .OBJ>>
	 <COND (<EQUAL? .THERE ,WINNER>
		<SET THERE ,HERE>)>
	 <SET F <FIRST? .OBJ>>
	 <REPEAT ()
		 <COND (<NOT .F>
			<RETURN>)
		       (T
			<SET N .F>
			<SET F <NEXT? .N>>
			<COND (T ;<NOT <EQUAL? .N ,BRIEFCASE-LATCH>>
			       <MOVE .N .THERE>
			       <SET SLIDE T>)>)>>
	 <SET F <FIRST? .OBJ>>
	 <COND (.SLIDE
		<TELL "Everything on" HIM .OBJ " falls off." CR>
		<CRLF>)>>

<OBJECT LUGGAGE
	(CAR 0)
	(DESC "bunch of luggage")
	(SYNONYM BUNCH LUGGAGE)
	(FLAGS NDESCBIT)>

<OBJECT NEWSPAPER
	(LOC GLOBAL-OBJECTS)
	(CAR 1)
	(DESC "newspaper")
	(ADJECTIVE NEWS)
	(SYNONYM NEWSPAPER PAPER PAPERS)
	(FLAGS ;TAKEBIT READBIT)
	(SIZE 5)
	(TEXT "It's all in some foreign language.")
	(ACTION NEWSPAPER-F)>

<ROUTINE NEWSPAPER-F ()
 <COND (<VERB? OPEN>
	<TELL "You flip through the pages but find nothing readable." CR>)>>

<OBJECT CIGARETTE
	(LOC GLOBAL-OBJECTS)
	(CAR 1)
	(DESC "cigarette")
	(SYNONYM CIGARETTE CIG ;SMOKE PACK)
	(SIZE 1)
	(ACTION CIGARETTE-F)>

<ROUTINE CIGARETTE-F ()
 <COND (<VERB? BUY>
	<COND (<IN? ,MACHINE ,HERE>
	       <COND (<NOT <G? <GETP ,PLAYER ,P?SOUTH> 0>>
		      <TELL "You dig in " D ,POCKET " but find no cash." CR>
		      <RTRUE>)>
	       <SETG P-DOLLAR-FLAG T>
	       <SETG P-AMOUNT 1>
	       <PERFORM ,V?PUT-IN ,INTNUM ,MACHINE>
	       <RTRUE>)>)
       (<VERB? SMOKE LAMP-ON>
	<TELL
"You think it over and decide that this mission is dangerous enough already."
CR>)>>

[
<OBJECT LIGHTER
	(DESC "lighter")
	(SYNONYM LIGHTER)
	;(NORTH 4)
	(CAR 2)
	(SIZE 1)
	(FLAGS LIGHTBIT)
	(LOC GLOBAL-OBJECTS)
	(ACTION LIGHTER-F)>

<ROUTINE LIGHTER-F ()
 <COND (<VERB? HOLD-UNDER>
	<COND (<DOBJ? LIGHTER>
	       <PERFORM ,V?HEAT ,PRSI ,PRSO>
	       <RTRUE>)>)
       (<VERB? LAMP-OFF>
	<TELL "It stays off by itself!" CR>)
       (<VERB? LAMP-ON>
	<TELL
"The lighter spurts to life for a minute until you turn it off again." CR>)>>

<OBJECT FLOWER-GLOBAL
	(DESC "flower")
	(ADJECTIVE WILD)
	(SYNONYM FLOWER WILDFLOWER)
	(LOC GLOBAL-OBJECTS)>

<OBJECT FLOWER-1
	(DESC "yellow flower")
	(ADJECTIVE YELLOW WILD)
	(SYNONYM FLOWER WILDFLOWER)
	;(NORTH 1)
	(CAR 2)
	(SIZE 1)
	;(LOC GLOBAL-OBJECTS)
	(FLAGS NDESCBIT WEARBIT)
	(TEXT "It's a small burst of color in this colorless country.")
	(ACTION FLOWER-F)>

<OBJECT FLOWER-2
	(DESC "blue flower")
	(ADJECTIVE BLUE WILD)
	(SYNONYM FLOWER WILDFLOWER)
	;(NORTH 1)
	(CAR 2)
	(SIZE 1)
	;(LOC GLOBAL-OBJECTS)
	(FLAGS NDESCBIT WEARBIT)
	(TEXT "It's a small burst of color in this colorless country.")
	(ACTION FLOWER-F)>

<ROUTINE FLOWER-F ()
 <COND (<FSET? ,FLOWER-1 ,NDESCBIT>
	<SEARCHING-FOR? ,FLOWER-1>)
       (<FSET? ,FLOWER-2 ,NDESCBIT>
	<SEARCHING-FOR? ,FLOWER-2>)>>

<ROUTINE SEARCHING-FOR? (OBJ)
	<COND (<OR <VERB? EXAMINE> <SNEAKY-TAKE? .OBJ>>
	       <TELL "You haven't found " A .OBJ " yet!" CR>)
	      (<AND <IN? .OBJ ,HERE>
		    <OR <VERB? FIND>
			<AND <VERB? SEARCH-FOR> <==? ,PRSI .OBJ>>>>
	       <FCLEAR .OBJ ,NDESCBIT>
	       ;<FCLEAR .OBJ ,TRYTAKEBIT>
	       <FSET .OBJ ,TAKEBIT>
	       <MOVE .OBJ ,WINNER>
	       <TELL "You find " A .OBJ " in short order and take it." CR>)>>

;<OBJECT HAT
	(DESC "hat")
	(SYNONYM HAT)
	(NORTH 7)
	(CAR 2)
	(SIZE 20)
	(FLAGS WEARBIT)
	(LOC GLOBAL-OBJECTS)>

<OBJECT PEN
	(DESC "pen")
	(SYNONYM PEN)
	(CAR 2)
	(SIZE 1)
	(FLAGS NDESCBIT)
	(LOC LIMBO-FWD)>

"<OBJECT RING
	(DESC 'ring')
	(SYNONYM RING)
	(NORTH 15)
	(CAR 2)
	(SIZE 1)
	(LOC GLOBAL-OBJECTS)>"

<OBJECT HANKY
	(DESC "red handkerchief")
	(ADJECTIVE RED)
	(SYNONYM HANKY HANDKERCH)
	;(NORTH 6)
	(CAR 2)
	(FLAGS WEARBIT)
	(SIZE 5)
	(LOC GLOBAL-OBJECTS)>

<OBJECT SCARF ;"TOWEL"
	(DESC "white scarf")
	(ADJECTIVE WHITE)
	(SYNONYM SCARF ;TOWEL)
	;(NORTH 6)
	(CAR 2)
	(FLAGS WEARBIT)
	(SIZE 20)
	(LOC GLOBAL-OBJECTS)>

"<CONSTANT SECOND-PASS-OFFSET 4>"

<GLOBAL PASS-TABLE
 <PLTABLE ;"RING NEWSPAPER CAMERA"
  PEN HANKY ;CIGARETTE LIGHTER FLOWER-GLOBAL ;HAT-COOK SCARF KNIFE PEN>>

<GLOBAL PASSWORD 0>
<GLOBAL PASSOBJECT 0>
<GLOBAL PASSWORD-GIVEN <>>
<GLOBAL PASSOBJECT-GIVEN <>>
<GLOBAL PASSWORD-GIVEN-OTHER <>>
<GLOBAL PASSOBJECT-GIVEN-OTHER <>>
]

<OBJECT BLOOD-SPOT
	;(LOC COMPARTMENT-1)
	(CAR 2)
	(DESC "spot of blood")
	(SYNONYM SPOT BLOOD)
	(FLAGS NDESCBIT ;TRYTAKEBIT)
	(DESCFCN BLOOD-SPOT-DESC)
	(ACTION BLOOD-SPOT-F)>

<ROUTINE BLOOD-SPOT-DESC (X)
 <COND (<NOT <IN? ,BLOOD-SPOT ,COMPARTMENT-START>>
	<RFALSE>)
       (<FSET? ,BLOOD-SPOT ,TOUCHBIT>
	<TELL "A spot of blood is still on the floor." CR>)
       (T
	<FSET ,BLOOD-SPOT ,TOUCHBIT>
	<TELL "Your sharp eyes notice a spot of blood on the floor." CR>)>>

<ROUTINE FIND-SEARCH ()
 <COND (<VERB? FIND>
	<RETURN ,PRSO>)
       (<VERB? SEARCH-FOR>
	<RETURN ,PRSI>)>>

<ROUTINE BLOOD-SPOT-F ("AUX" OBJ)
 <COND (<SET OBJ <FIND-SEARCH>>
	<COND (<AND <EQUAL? ,HERE <LOC .OBJ>>
		    <FSET? .OBJ ,NDESCBIT>>
	       <FCLEAR .OBJ ,NDESCBIT>
	       ;<HE-SHE-IT ,WINNER T "find">
	       <TELL CHE ,WINNER find " it in short order." CR>)>)
       (<VERB? TAKE>
	<TELL "You can't pick" HIM ,PRSO " up with your bare hands!" CR>)
       (<VERB? TAKE-WITH BRUSH>
	<COND (<OR <EQUAL? ,PRSI ,SPY-LIST>
		   <AND <NOT ,PRSI> <IN? ,SPY-LIST ,WINNER>>>
	       <MOVE ,PRSO ,SPY-LIST>
	       <FCLEAR ,PRSO ,NDESCBIT>
	       ;<PUTP ,BLOOD-SPOT ,P?LDESC 0>
	       <TELL "Okay." CR>)>)>>

<OBJECT KNIFE
	(LOC GALLEY ;GLOBAL-OBJECTS)
	(CAR 2)
	(DESC "knife")
	(ADJECTIVE	KITCHEN GALLEY)
	(SYNONYM	KNIFE)
	(FLAGS WEAPONBIT NDESCBIT ;TRYTAKEBIT)
	(ACTION KNIFE-F)>

<ROUTINE KNIFE-F () <KNIFE-NAPKIN-F ,KNIFE ,COOK>>

<ROUTINE KNIFE-NAPKIN-F (OBJ PER)
 <COND (<FSET? .OBJ ,NDESCBIT>
	<COND (<AND <IN? .PER ,HERE>
		    <NOT <BRIBED? .PER>>>
	       <FCLEAR .PER ,TOUCHBIT>
	       <PUTP .PER ,P?LDESC 1 ;"looking at you suspiciously">
	       <TELL CTHE .PER " says, " ;"\"Mrmbl gchu knif.\"">
	       <PRODUCE-GIBBERISH>)
	      (T <SEARCHING-FOR? .OBJ>)>)>>

<OBJECT NAPKIN
	(LOC PANTRY)
	(CAR 2)
	(DESC "white napkin")
	(ADJECTIVE WHITE)
	(SYNONYM ;SCARF NAPKIN)
	(FLAGS WEARBIT NDESCBIT ;TRYTAKEBIT)
	(SIZE 9)
	(ACTION NAPKIN-F)>

<ROUTINE NAPKIN-F () <KNIFE-NAPKIN-F ,NAPKIN ,WAITER>>

<ROUTINE SNEAKY-TAKE? (OBJ)
 <COND (<AND <EQUAL? ,PRSO .OBJ>
	     <OR <VERB? TAKE>
		 <BTST <GETB ,P-SYNTAX ,P-SLOC1> ,STAKE>>>
	<RTRUE>)
       (<AND <EQUAL? ,PRSI .OBJ>
	     <BTST <GETB ,P-SYNTAX ,P-SLOC2> ,STAKE>>
	<RTRUE>)>>

;"<OBJECT COAT
	(LOC OTHER-HOOK)
	(CAR 2)
	(DESC 'raincoat')
	(ADJECTIVE RAIN CONDUCTOR COLLECTOR)
	(SYNONYM RAINCOAT COAT POCKET)
	(FLAGS WEARBIT TRYTAKEBIT CONTBIT OPENBIT)
	(CAPACITY 15)
	(SIZE 30)
	(DESCFCN COAT-F)
	(ACTION COAT-F)>

<ROUTINE COAT-F ('OPTIONAL' (ARG <>))
 <COND (<==? .ARG ,M-OBJDESC>
	<COND (<IN? ,COAT ,HOOK>
	       <TELL 'A raincoat is hanging on a hook.' CR>)
	      (T <TELL 'A raincoat is lying on the floor.' CR>)>)
       (<NOT <ZERO? .ARG>>
	<RFALSE>)
       (<VERB? OPEN CLOSE>
	<YOU-CANT>)
       (<VERB? TAKE>
	<TELL CHE ,CONDUCTOR ' really wouldn't be pleased.' CR>)>>"

<OBJECT MARKS
	(CAR 0)
	(DESC "scratches")
	(SYNONYM SCRATCHES SCRATCH MARKS MARK)
	(FLAGS PLURALBIT)
	(FDESC "You notice marks and scratches on the walls.")
	(TEXT
"The scratches are dark but indistinct, probably from rubber-soled
shoes, as if there had once been a desparate struggle here.")>

<OBJECT WORN-SPOT
	(CAR 0)
	(DESC "worn spot")
	(ADJECTIVE WORN)
	(SYNONYM SPOT)
	(FDESC "You notice a worn spot on the floor.")
	(TEXT
"The linoleum is completely gone from this spot, leaving the floor
itself exposed in a roundish shape, as if someone with itchy feet
had stood or sat in the same place over and over again.")>

<OBJECT GRAFFITI
	(CAR 0)
	(DESC "graffiti")
	(SYNONYM GRAFFITI)
	(FLAGS PLURALBIT)
	(FDESC "You notice some graffiti on the wall.")
	(TEXT
"The graffiti artist made do with a lead pencil, since felt pens and
spray paint are probably expensive here. As near as you can make out,
the graffiti extol the artist's virtues, and recommend a phone number to
call in a place called Zgrf.")>

<GLOBAL MARKS-TABLE <PLTABLE MARKS WORN-SPOT GRAFFITI>>
