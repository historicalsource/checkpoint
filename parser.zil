"PARSER for CHECKPOINT
Copyright (C) 1985 Infocom, Inc.  All rights reserved."

"Parser global variable convention:  All parser globals will 
  begin with 'P-'.  Local variables are not restricted in any
  way." 
 
<SETG SIBREAKS ".,\"!?"> 

<GLOBAL PRSA 0>
<GLOBAL PRSI 0>
<GLOBAL PRSO 0> 

<GLOBAL P-SYNTAX 0> 

<GLOBAL P-LEN 0>    

<GLOBAL P-DIR 0>    

<GLOBAL HERE 0>
<GLOBAL LAST-PLAYER-LOC 0>

<GLOBAL WINNER 0>   

<GLOBAL P-LEXV <ITABLE BYTE 120>>
<GLOBAL AGAIN-LEXV <ITABLE BYTE 120>>
<GLOBAL RESERVE-LEXV <ITABLE BYTE 120>>
<GLOBAL RESERVE-PTR <>>

"INBUF - Input buffer for READ"
<GLOBAL P-INBUF <ITABLE BYTE 60>>
<GLOBAL OOPS-INBUF <ITABLE BYTE 60>>
<GLOBAL OOPS-TABLE <TABLE <> <> <> <>>>
<CONSTANT O-PTR 0>
<CONSTANT O-START 1>
<CONSTANT O-LENGTH 2>
<CONSTANT O-END 3>

"Parse-cont variable"
<GLOBAL P-CONT <>>  

<GLOBAL P-IT-OBJECT <>>
<GLOBAL P-HER-OBJECT <>>
<GLOBAL P-HIM-OBJECT <>>
<GLOBAL P-THEM-OBJECT <>>

"Orphan flag"
<GLOBAL P-OFLAG <>> 

<GLOBAL P-MERGED <>>

<GLOBAL P-ACLAUSE <>>    

<GLOBAL P-ANAM <>>  

<GLOBAL P-AADJ <>>

"Byte offset to # of entries in LEXV"
<CONSTANT P-LEXWORDS 1>

"Word offset to start of LEXV entries"
<CONSTANT P-LEXSTART 1>

"Number of words per LEXV entry"
<CONSTANT P-LEXELEN 2>   

<CONSTANT P-WORDLEN 4>

"Offset to parts of speech byte"
<CONSTANT P-PSOFF %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 6) (T 4)>>

"Offset to first part of speech"
<CONSTANT P-P1OFF %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 7) (T 5)>>

"First part of speech bit mask in PSOFF byte"
<CONSTANT P-P1BITS 3>    

<CONSTANT P-ITBLLEN 9>   

<GLOBAL P-ITBL <TABLE 0 0 0 0 0 0 0 0 0 0>>  

<GLOBAL P-OTBL <TABLE 0 0 0 0 0 0 0 0 0 0>>  

<GLOBAL P-VTBL <TABLE 0 0 0 0>>

<GLOBAL P-OVTBL <TABLE 0 0 0 0>>

<GLOBAL P-NCN 0>    

<CONSTANT P-VERB 0> 

<CONSTANT P-VERBN 1>

<CONSTANT P-PREP1 2>

<CONSTANT P-PREP1N 3>    

<CONSTANT P-PREP2 4>

"<CONSTANT P-PREP2N 5>"    

<CONSTANT P-NC1 6>  

<CONSTANT P-NC1L 7> 

<CONSTANT P-NC2 8>  

<CONSTANT P-NC2L 9> 

<GLOBAL QUOTE-FLAG <>>

<GLOBAL P-ADVERB <>>

<GLOBAL P-END-ON-PREP <>>

<CONSTANT M-FATAL 2>
"<CONSTANT M-HANDLED 1>   
<CONSTANT M-NOT-HANDLED <>>"   

<CONSTANT M-BEG 1>  
<CONSTANT M-ENTER 2>
<CONSTANT M-LOOK 3> 
<CONSTANT M-FLASH 4>
<CONSTANT M-OBJDESC 5>
<CONSTANT M-END 6> 
<CONSTANT M-CONT 7> 
<CONSTANT M-WINNER 8> 
<CONSTANT M-OTHER 69>

<ROUTINE MAIN-LOOP ("AUX" X) <REPEAT () <SET X <MAIN-LOOP-1>>>>

<ROUTINE MAIN-LOOP-1 ("AUX" ICNT OCNT NUM CNT OBJ TBL V PTBL OBJ1 TMP X)
     <SET CNT 0>
     <SET OBJ <>>
     <SET PTBL T>
     <COND (<NOT <==? ,QCONTEXT-ROOM ,HERE>>
	    <SETG QCONTEXT <>>)>
     <COND (<PARSER> ;<SETG P-WON >
	    <SETG CLOCK-WAIT <>>
	    <SET ICNT <GET ,P-PRSI ,P-MATCHLEN>>
	    <SET OCNT <GET ,P-PRSO ,P-MATCHLEN>>
	    <COND (<AND ,P-IT-OBJECT <ACCESSIBLE? ,P-IT-OBJECT>>
		   <SET TMP <>>
		   <REPEAT ()
			   <COND (<IGRTR? CNT .ICNT>
				  <RETURN>)>
			   <COND (<EQUAL? <GET ,P-PRSI .CNT> ,IT>
				  <PUT ,P-PRSI .CNT ,P-IT-OBJECT>
				  <TELL ,I-ASSUME THE ,P-IT-OBJECT ".)" CR>
				  <SET TMP T>
				  <RETURN>)>>
		   <COND (<NOT .TMP>
			  <SET CNT 0>
			  <REPEAT ()
			   <COND (<IGRTR? CNT .OCNT>
				  <RETURN>)>
			   <COND (<EQUAL? <GET ,P-PRSO .CNT> ,IT>
				  <PUT ,P-PRSO .CNT ,P-IT-OBJECT>
				  <TELL ,I-ASSUME THE ,P-IT-OBJECT ".)" CR>
				  <RETURN>)>>)>
		   <SET CNT 0>)>
	    <SET NUM
		 <COND (<0? .OCNT> .OCNT)
		       (<G? .OCNT 1>
			<SET TBL ,P-PRSO>
			<COND (<0? .ICNT> <SET OBJ <>>)
			      (T <SET OBJ <GET ,P-PRSI 1>>)>
			.OCNT)
		       (<G? .ICNT 1>
			<SET PTBL <>>
			<SET TBL ,P-PRSI>
			<SET OBJ <GET ,P-PRSO 1>>
			.ICNT)
		       (T 1)>>
	    <COND (<AND <NOT .OBJ> <1? .ICNT>> <SET OBJ <GET ,P-PRSI 1>>)>
	    <COND (<EQUAL? ,PRSA ,V?WALK ,V?FACE>
		   <SET V <PERFORM ,PRSA ,PRSO>>)
		  (<0? .NUM>
		   <COND (<0? <BAND <GETB ,P-SYNTAX ,P-SBITS> ,P-SONUMS>>
			  <SET V <PERFORM ,PRSA>>
			  <SETG PRSO <>>)
			 (<NOT ,LIT>
			  <SETG QUOTE-FLAG <>>
			  <SETG P-CONT <>>
			  <TOO-DARK>)
			 (T
			  <SETG QUOTE-FLAG <>>
			  <SETG P-CONT <>>
			  <TELL "(There isn't anything to ">
			  <SET TMP <GET ,P-ITBL ,P-VERBN>>
			  <COND (<VERB? TELL>
				 <TELL "talk to">)
				(<OR ,P-MERGED ,P-OFLAG>
				 <PRINTB <GET .TMP 0>>)
				(T
				 <SET V <WORD-PRINT <GETB .TMP 2>
						    <GETB .TMP 3>>>)>
			  <TELL "!)" CR>
			  <SET V <>>)>)
		  ;(<AND .PTBL <G? .NUM 1> <VERB? COMPARE>>
		   <SET V <PERFORM ,PRSA ,OBJECT-PAIR>>)
		  (T
		   <SET X 0>
		   ;"<SETG P-MULT <>>
		   <COND (<G? .NUM 1> <SETG P-MULT T>)>"
		   <SET TMP 0>
		   <REPEAT ()
		    <COND (<IGRTR? CNT .NUM>
			   <COND (<G? .X 0>
				  <TELL "The ">
				  <COND (<NOT <EQUAL? .X .NUM>>
					 <TELL "other ">)>
				  <TELL "object">
				  <COND (<NOT <EQUAL? .X 1>>
					 <TELL "s">)>
				  <TELL " that you mentioned ">
				  <COND (<NOT <EQUAL? .X 1>>
					 <TELL "are">)
					(T <TELL "is">)>
				  <TELL "n't here." CR>)
				 (<NOT .TMP>
				  <MORE-SPECIFIC ;REFERRING>)>
			   <RETURN>)
			  (T
			   <COND (.PTBL <SET OBJ1 <GET ,P-PRSO .CNT>>)
				 (T <SET OBJ1 <GET ,P-PRSI .CNT>>)>
			   <COND (<OR <G? .NUM 1>
				      <EQUAL? <GET <GET ,P-ITBL ,P-NC1> 0>
					      ,W?ALL>>
				  <COND (<==? .OBJ1 ,NOT-HERE-OBJECT>
					 <SET X <+ .X 1>>
					 <AGAIN>)
					(<AND <EQUAL? ,P-GETFLAGS ,P-ALL>
					      <NOT<VERB-ALL-TEST .OBJ1 .OBJ>>>
					 <AGAIN>)
					(<NOT <ACCESSIBLE? .OBJ1>>
					 <AGAIN>)
					(<==? .OBJ1 ,PLAYER> <AGAIN>)
					;(<FSET? .OBJ1 ,DUPLICATE> <AGAIN>)
					(T
					 <COND (<EQUAL? .OBJ1 ,IT>
						<PRINTD ,P-IT-OBJECT>)
					       (T <PRINTD .OBJ1>)>
					 <TELL ": ">)>)>
			   <SET TMP T>
			   <SET V <QCONTEXT-CHECK <COND (.PTBL .OBJ1)
							(T .OBJ)>>>
			   <SETG PRSO <COND (.PTBL .OBJ1) (T .OBJ)>>
			   <SETG PRSI <COND (.PTBL .OBJ) (T .OBJ1)>>
			   <SET V <PERFORM ,PRSA ,PRSO ,PRSI>>
			   <COND (<==? .V ,M-FATAL> <RETURN>)>)>>)>
	    ;<COND (<GAME-VERB?> T)
		  (<VERB? AGAIN> T)
		  (,P-OFLAG T)
		  (T
		   <SETG L-PRSA ,PRSA>
		   <SETG L-PRSO ,PRSO>
		   <SETG L-PRSI ,PRSI>)>
	    <COND (<==? .V ,M-FATAL> <SETG P-CONT <>>)>)
	   (T
	    <SETG CLOCK-WAIT T>
	    <SETG P-CONT <>>)>
     <COND (<ZERO? ,CLOCK-WAIT>
	    <COND (<OR <VERB? SAVE RESTORE>
		       <NOT <GAME-VERB?>>>
		   <SET V <CLOCKER>>)>)>
     <SETG PRSA <>>
     <SETG PRSO <>>
     <SETG PRSI <>>>

<ROUTINE VERB-ALL-TEST (O I "AUX" L)	;"O=PRSO I=PRSI"
 <SET L <LOC .O>>
 <COND (<VERB? DROP GIVE>
	<COND (<EQUAL? .O ,POCKET>
	       <RFALSE>)
	      (<OR <==? .L ,WINNER> ;<IN? ,P-IT-OBJECT ,WINNER>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<VERB? PUT PUT-IN>
	<COND (<EQUAL? .O .I ,POCKET>
	       <RFALSE>)
	      (<NOT <HELD? .O .I>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<VERB? TAKE>
	<COND (<AND <NOT <FSET? .O ,TAKEBIT>>
		    <NOT <FSET? .O ,TRYTAKEBIT>>>
	       <RFALSE>)>
	<COND (<NOT <ZERO? .I>>
	       <COND (<NOT <==? .L .I>>
		      <RFALSE>)
		     (T
		      <SET L .I>)>)
	      (<EQUAL? .L ;,WINNER ,HERE>
	       <RTRUE>)>
	<COND (<FSET? .L ,SURFACEBIT>
	       <RTRUE>)
	      (<AND <FSET? .L ,CONTBIT>
		    <FSET? .L ,OPENBIT>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<NOT <ZERO? .I>>
	<COND (<NOT <==? .O .I>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (T <RTRUE>)>>

<ROUTINE GAME-VERB? ("OPTIONAL" (V <>))
	<COND (<NOT .V> <SET V ,PRSA>)>
	<COND (<EQUAL? .V ,V?$ANSWER ,V?$GOAL ,V?$VERIFY>	<RTRUE>)
	      (<EQUAL? .V ;,V?$AGAIN ,V?$QUEUE ,V?$STATION>	<RTRUE>)
	      (<EQUAL? .V ,V?$FCLEAR ,V?$FSET ,V?$QFSET>	<RTRUE>)
	      (<EQUAL? .V ,V?$WHERE ,V?BRIEF ,V?DEBUG>		<RTRUE>)
	      (<EQUAL? .V ,V?QUIT ,V?RESTART ,V?RESTORE>	<RTRUE>)
	      (<EQUAL? .V ,V?SAVE ,V?SCRIPT ,V?SUPER-BRIEF>	<RTRUE>)
	      (<EQUAL? .V ,V?TELL ,V?TIME ,V?UNSCRIPT>		<RTRUE>)
	      (<EQUAL? .V ,V?VERBOSE ,V?VERSION ,V?$FACE>	<RTRUE>)>>

<ROUTINE QCONTEXT-CHECK (PRSO "AUX" OTHER (WHO <>) (N 0))
	 <COND (<OR <VERB? ;FIND HELP WHAT>
		    <AND <VERB? SHOW TELL-ABOUT>
			 <==? .PRSO ,PLAYER>>> ;"? more?"
		<SET OTHER <FIRST? ,HERE>>
		<REPEAT ()
			<COND (<NOT .OTHER> <RETURN>)
			      (<AND <FSET? .OTHER ,PERSONBIT>
				    <NOT <FSET? .OTHER ,INVISIBLE>>
				    <NOT <==? .OTHER ,PLAYER>>>
			       <SET N <+ 1 .N>>
			       <SET WHO .OTHER>)>
			<SET OTHER <NEXT? .OTHER>>>
		<COND (<AND <==? 1 .N> <NOT ,QCONTEXT>>
		       <SAID-TO .WHO>)>
		<COND (<AND <QCONTEXT-GOOD?>
			    <==? ,WINNER ,PLAYER>> ;"? more?"
		       ;<SETG L-WINNER ,WINNER>
		       <SETG WINNER ,QCONTEXT>
		       <TELL "(said to " D ,QCONTEXT ")" CR>)>)>>

<ROUTINE QCONTEXT-GOOD? ()
 <COND (<AND <NOT <ZERO? ,QCONTEXT>>
	     <FSET? ,QCONTEXT ,PERSONBIT>
	     <NOT <FSET? ,QCONTEXT ,INVISIBLE>>
	     <==? ,HERE ,QCONTEXT-ROOM>
	     <==? ,HERE <META-LOC ,QCONTEXT>>>
	<RTRUE>)>>

<ROUTINE SAID-TO (WHO)
	<SETG QCONTEXT .WHO>
	<SETG QCONTEXT-ROOM <LOC .WHO>>>

<ROUTINE THIS-IS-IT (OBJ)
 <COND (<EQUAL? .OBJ <> ,NOT-HERE-OBJECT ,PLAYER>
	<RTRUE>)
       (<EQUAL? .OBJ ,INTDIR ,GLOBAL-HERE>
	<RTRUE>)
       (<AND <VERB? WALK WALK-TO FACE> <==? .OBJ ,PRSO>>
	<RTRUE>)>
 <COND (<NOT <FSET? .OBJ ,PERSONBIT>>
	<FSET ,IT ,TOUCHBIT>	;"to cause pronoun 'it' in output"
	<SETG P-IT-OBJECT .OBJ>)
       (<FSET? .OBJ ,FEMALE>
	<FSET ,HER ,TOUCHBIT>
	<SETG P-HER-OBJECT .OBJ>)
       (<FSET? .OBJ ,PLURALBIT>
	<FSET ,THEM ,TOUCHBIT>
	<SETG P-THEM-OBJECT .OBJ>)
       (T
	<FSET ,HIM ,TOUCHBIT>
	<SETG P-HIM-OBJECT .OBJ>)>
 <RTRUE>>

<ROUTINE NOT-IT (WHO)
 <COND (<EQUAL? .WHO ,P-HER-OBJECT>
	<FCLEAR ,HER ,TOUCHBIT>)
       (<EQUAL? .WHO ,P-HIM-OBJECT>
	<FCLEAR ,HIM ,TOUCHBIT>)
       (<EQUAL? .WHO ,P-THEM-OBJECT>
	<FCLEAR ,THEM ,TOUCHBIT>)
       (<EQUAL? .WHO ,P-IT-OBJECT>
	<FCLEAR ,IT  ,TOUCHBIT>)>>

<ROUTINE FAKE-ORPHAN ("AUX" TMP)
	 <ORPHAN ,P-SYNTAX <>>
	 <TELL "(Be specific: what thing do you want to ">
	 <SET TMP <GET ,P-OTBL ,P-VERBN>>
	 <COND (<==? .TMP 0> <TELL "tell">)
	       (<0? <GETB ,P-VTBL 2>>
		<PRINTB <GET .TMP 0>>)
	       (T
		<WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
		<PUTB ,P-VTBL 2 0>)>
	 <SETG P-OFLAG T>
	 ;<SETG P-WON <>>
	 <SETG CLOCK-WAIT T>
	 <TELL "?)" CR>>

<ROUTINE TELL-D-LOC (OBJ)
	<TELL D .OBJ>
	<COND (<IN? .OBJ ,GLOBAL-OBJECTS>	<TELL "(gl)">)
	      (<IN? .OBJ ,LOCAL-GLOBALS>	<TELL "(lg)">)
	      (<IN? .OBJ ,ROOMS>		<TELL "(rm)">)>
	<COND (<EQUAL? .OBJ ,TURN ,INTNUM>
	       <TELL "(">
	       <COND (,P-DOLLAR-FLAG
		      <PRINTC ,CURRENCY-SYMBOL>
		      <TELL N ,P-AMOUNT ")">)
		     (T <TELL N ,P-NUMBER ")">)>)>>

<ROUTINE FIX-HIM-HER (HEM-OBJECT "AUX" C P)
	<SET C <GETP .HEM-OBJECT ,P?CHARACTER>>
	<COND (<NOT <ACCESSIBLE? .HEM-OBJECT>>
	       <COND (,DEBUG <TELL "[" D .HEM-OBJECT ":NA]" CR>)>
	       <SET P <GET ,GLOBAL-CHARACTER-TABLE .C>>
	       <COND (<AND .C <NOT <==? .P <GET ,CHARACTER-TABLE .C>>>>
		      <TELL ,I-ASSUME THE .P ".)" CR>
		      <RETURN .P>)
		     (T <RFALSE>)>)>
	<COND (<IN? .HEM-OBJECT ,GLOBAL-OBJECTS>
	       <SET P <GET ,CHARACTER-TABLE .C>>)
	      (T <SET P .HEM-OBJECT>)>
	<COND (<EQUAL? ,HERE <LOC .P>>
	       <COND (,DEBUG <TELL "[" D .HEM-OBJECT ":LO]" CR>)>
	       <TELL ,I-ASSUME THE .P ".)" CR>
	       <RETURN .P>)>>

<GLOBAL NOW-PRSI <>>

<ROUTINE PERFORM (A "OPTIONAL" (O <>) (I <>) "AUX" V OA OO OI)
	<COND (,DEBUG
	       <TELL "[Perform: ">
	       %<COND (<GASSIGNED? PREDGEN> '<TELL N .A>)
		      (T '<PRINC <NTH ,ACTIONS <+ <* .A 2> 1>>>)>
	       <COND (.O
		      <TELL "/">
		      <COND (<EQUAL? .A ,V?WALK ,V?FACE> <TELL N .O>)
			    (T <TELL-D-LOC .O>)>)>
	       <COND (.I
		      <TELL "/">
		      <TELL-D-LOC .I>)>
	       <TELL "]" CR>)>
	<SET OA ,PRSA>
	<SET OO ,PRSO>
	<SET OI ,PRSI>
	<SETG PRSA .A>
	<COND ;(<AND <NOT ,LIT>
		    <SEE-VERB?>>
	       <TOO-DARK>
	       <RFATAL>)
	      (<NOT <EQUAL? .A ,V?WALK ,V?FACE>>
	       <COND (<AND <EQUAL? ,IT .I .O>
			   <NOT <ACCESSIBLE? ,P-IT-OBJECT>>>
		      <COND (<NOT .I> <FAKE-ORPHAN>)
			    (T <NOT-HERE ,P-IT-OBJECT>)>
		      <RFATAL>)>
	       <COND (<EQUAL? ,THEM .I .O>
		      <COND (<SET V <FIX-HIM-HER ,P-THEM-OBJECT>>
			     <COND (,DEBUG <TELL "[them=" D .V "]" CR>)>
			     <COND (<==? ,THEM .O> <SET O .V>)>
			     <COND (<==? ,THEM .I> <SET I .V>)>)
			    (T
			     <COND (<NOT .I> <FAKE-ORPHAN>)
				   (T <NOT-HERE ,P-THEM-OBJECT>)>
			     <RFATAL>)>)>
	       <COND (<EQUAL? ,HER .I .O>
		      <COND (<SET V <FIX-HIM-HER ,P-HER-OBJECT>>
			     <COND (,DEBUG <TELL "[her=" D .V "]" CR>)>
			     <COND (<==? ,HER .O> <SET O .V>)>
			     <COND (<==? ,HER .I> <SET I .V>)>)
			    (T
			     <COND (<NOT .I> <FAKE-ORPHAN>)
				   (T <NOT-HERE ,P-HER-OBJECT>)>
			     <RFATAL>)>)>
	       <COND (<EQUAL? ,HIM .I .O>
		      <COND (<SET V <FIX-HIM-HER ,P-HIM-OBJECT>>
			     <COND (,DEBUG <TELL "[him=" D .V "]" CR>)>
			     <COND (<==? ,HIM .O> <SET O .V>)>
			     <COND (<==? ,HIM .I> <SET I .V>)>)
			    (T
			     <COND (<NOT .I> <FAKE-ORPHAN>)
				   (T <NOT-HERE ,P-HIM-OBJECT>)>
			     <RFATAL>)>)>
	       <COND (<==? .O ,IT>
		      <SET O ,P-IT-OBJECT>
		      <TELL ,I-ASSUME THE .O ".)" CR>
		      ;<COND (,DEBUG <TELL "[it=" D .O "]" CR>)>)>
	       <COND (<==? .I ,IT>
		      <SET I ,P-IT-OBJECT>
		      <TELL ,I-ASSUME THE .I ".)" CR>
		      ;<COND (,DEBUG <TELL "[it=" D .O "]" CR>)>)>)>
	<SETG PRSI .I>
	<SETG PRSO .O>
	<SET V <>>
	<COND (<AND ,NOW-LURCHING
		    <NOT <==? ,TOLD-LURCHING ,PRESENT-TIME>>
		    ,TRAIN-MOVING
		    <OR ;<VERB? SAVE RESTORE> <NOT <GAME-VERB?>>>
		    <OR <NOT <VERB? MOVE>> <NOT <EQUAL? ,PRSO ,STOP-CORD>>>>
	       <SETG TOLD-LURCHING ,PRESENT-TIME>
	       <TELL "The train lurches a bit." CR>)>
	<COND (<AND <NOT <EQUAL? .A ,V?WALK ,V?FACE>>
		    <EQUAL? ,NOT-HERE-OBJECT ,PRSO ,PRSI>>
	       <SET V <D-APPLY "Not Here" ,NOT-HERE-OBJECT-F>>
	       <COND (.V
		      ;<SETG P-WON <>>
		      <SETG CLOCK-WAIT T>)>)>
	<THIS-IS-IT ,PRSI>
	<THIS-IS-IT ,PRSO>
	<SET O ,PRSO>
	<SET I ,PRSI>
	<COND (,DEBUG
	       <PRINTC %<ASCII !\[>>
	       <PRINTD ,WINNER>	;"extra output for next (...)"
	       <PRINTI "=]">)>
	<COND (<ZERO? .V>
	       <SET V <D-APPLY "Actor" <GETP ,WINNER ,P?ACTION> ,M-WINNER>>)>
	<COND (<ZERO? .V>
	       <SET V <D-APPLY "Room (M-BEG)"
			       <GETP <LOC ,WINNER> ,P?ACTION>
			       ,M-BEG>>)>
	<COND (<ZERO? .V>
	       <SET V <D-APPLY "Preaction" <GET ,PREACTIONS .A>>>)>
	<SETG NOW-PRSI T>
	<COND ;"This new clause applies CONTFCN to PRSI, BM 2/85"
	      (<AND <ZERO? .V>
		    .I	
		    <NOT <EQUAL? .A ,V?WALK>>
		    <LOC .I>>
	       <SET V <GETP <LOC .I> ,P?CONTFCN>>
	       <COND (.V
		      <SET V <APPLY .V ,M-CONT>>)>)>
	<COND (<AND <ZERO? .V>
		    .I>
	       <SET V <D-APPLY "PRSI" <GETP .I ,P?ACTION>>>)>
	<SETG NOW-PRSI <>>
	<COND (<AND <ZERO? .V>
		    .O
		    <NOT <EQUAL? .A ,V?WALK ,V?FACE>>
		    <LOC .O>>
	       <SET V <GETP <LOC .O> ,P?CONTFCN>>
	       <COND (.V
		      <SET V <APPLY .V ,M-CONT>>)>)>
	<COND (<AND <ZERO? .V>
		    .O
		    <NOT <EQUAL? .A ,V?WALK ,V?FACE>>>
	       <SET V <D-APPLY "PRSO" <GETP .O ,P?ACTION>>>)>
	<COND (<ZERO? .V>
	       <SET V <D-APPLY <> <GET ,ACTIONS .A>>>)>
	;<THIS-IS-IT ,PRSI>
	;<THIS-IS-IT ,PRSO>
	<COND (<NOT <==? .V ,M-FATAL>>
	       <COND (<OR <VERB? SAVE RESTORE> <NOT <GAME-VERB?>>>
		      <SET V <D-APPLY "Room (M-END)"
				   <GETP <LOC ,WINNER> ,P?ACTION> ,M-END>>)>)>
	<SETG PRSA .OA>
	<SETG PRSO .OO>
	<SETG PRSI .OI>
	.V>

<ROUTINE D-APPLY (STR FCN "OPTIONAL" (FOO <>) "AUX" RES)
	<COND (<NOT .FCN> <>)
	      (T
	       <COND (,DEBUG
		      <COND (<NOT .STR>
			     <TELL "[Action:]" CR>)
			    (T
			     <PRINTC %<ASCII !\[>>
			     <TELL .STR ": ">)>)>
	       <COND (<=? .STR "Container">
		      <SET FOO ,M-CONT>)>
	       <SET RES
		    <COND (.FOO <APPLY .FCN .FOO>)
			  (T <APPLY .FCN>)>>
	       <COND (<AND ,DEBUG .STR>
		      <COND (<==? .RES ,M-FATAL>
			     <TELL "Fatal]" CR>)
			    (<NOT .RES>
			     <TELL "Not handled]" CR>)
			    (T <TELL "Handled]" CR>)>)>
	       .RES)>>

" Grovel down the input finding the verb, prepositions, and noun clauses.
   If the input is <direction> or <walk> <direction>, fall out immediately
   setting PRSA to ,V?WALK and PRSO to <direction>.  Otherwise, perform
   all required orphaning, syntax checking, and noun clause lookup."   

<CONSTANT P-PROMPT-START 9>
<GLOBAL P-PROMPT 9>

<ROUTINE I-PROMPT ("OPTIONAL" (GARG <>))
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-PROMPT:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <SETG P-PROMPT <- ,P-PROMPT 1>>
 <COND (,IDEBUG <TELL "(0)]" CR>)>
 <RFALSE>>

<ROUTINE BUZZER-WORD? (WORD)
 <COND (<QUESTION-WORD? .WORD> <RTRUE>)
       (  <NUMBER-WORD? .WORD> <RTRUE>)
       ( <NAUGHTY-WORD? .WORD> <RTRUE>)
       (<OR <EQUAL? .WORD ,W?NW ,W?NORTHWEST ,W?NE>
	    <EQUAL? .WORD ,W?SW ,W?SOUTHWEST ,W?NORTHEAST>
	    <EQUAL? .WORD ,W?SE ,W?SOUTHEAST>>
	<TELL "(Sorry, but this story has no \"">
	<PRINTB .WORD>
	<TELL "\" directions.)" CR>)>>

<BUZZ	AM ;ANY ARE CAN COULD DID DO HAS HAVE HE\'S HOW
	IS IT\'S I\'LL I\'M I\'VE LET\'S SHALL SHE\'S SHOULD
	THAT\'S THEY\'RE WAS WERE WE\'RE
	WHAT WHAT\'S WHEN WHEN\'S WHERE ;WHERE\'S WHICH WHO WHO\'S WHY
	WILL WON\'T WOULD YOU\'RE>

<GLOBAL QUESTION-WORD-COUNT 0>
<ROUTINE QUESTION-WORD? (WORD)
	<COND (<EQUAL? .WORD ,W?WHERE ;",W?THERE ,W?SEEN">
	       <TELL
"(To locate something, use the command: FIND " D ,SOMETHING ".)" CR>)
	      (<OR <EQUAL? .WORD ,W?WHAT ,W?WHAT\'S>
		   <EQUAL? .WORD ,W?WHO ,W?WHO\'S>>
	       <TELL
"(To ask about something, use the command: TELL ME ABOUT " D ,SOMETHING ".)"
CR>)
	      (<OR <EQUAL? .WORD ,W?THAT\'S	,W?IT\'S>
		   <EQUAL? .WORD ,W?WHY		,W?HOW		,W?WHEN>
		   <EQUAL? .WORD ,W?IS		,W?DID		,W?ARE>
		   <EQUAL? .WORD ,W?DO		,W?HAVE>
		   <EQUAL? .WORD ,W?AM		,W?I\'M		,W?WE\'RE>
		   <EQUAL? .WORD ,W?WILL	,W?WAS		,W?WERE>
		   <EQUAL? .WORD ,W?I\'LL	,W?CAN		,W?WHICH>
		   <EQUAL? .WORD ,W?I\'VE	,W?WON\'T	,W?HAS>
		   <EQUAL? .WORD ,W?YOU\'RE	,W?HE\'S	,W?SHE\'S>
		   <EQUAL? .WORD ,W?SHOULD	,W?WOULD	,W?WHEN\'S>
		   <EQUAL? .WORD ,W?THEY\'RE	,W?COULD	,W?SHALL>>
	       <TELL "(Please use commands">
	       <INC QUESTION-WORD-COUNT>
	       <COND (<G? ,QUESTION-WORD-COUNT 4 ;9>
		      <SETG QUESTION-WORD-COUNT 0>
		      <TELL
"! Your commands tell the computer what you want to do in the story.
Here are examples of commands:|
   TURN ON THE LAMP|
   LOOK UNDER THE RUG|
   MADAME, GIVE THE BOOK TO HIM|
   CONDUCTOR, HELP ME|
Now you can try again">)
		     (T <TELL ", not statements or questions">)>
	       <TELL ".)" CR>
	       <RTRUE>)>>

<BUZZ	ZERO ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN ELEVEN TWELVE
	THIRTEEN FOURTEEN FIFTEEN SIXTEEN SEVENTEEN EIGHTEEN NINETEEN TWENTY
	THIRTY FORTY FIFTY SIXTY SEVENTY EIGHTY NINETY HUNDRED
	THOUSAND MILLION BILLION>

<ROUTINE NUMBER-WORD? (WRD)
	<COND (<OR <EQUAL? .WRD ,W?ZERO ,W?SEVENTY>
		   <EQUAL? .WRD ,W?TWO ,W?THREE ,W?FOUR>
		   <EQUAL? .WRD ,W?FIVE ,W?SIX ,W?SEVEN>
		   <EQUAL? .WRD ,W?EIGHT ,W?NINE ,W?TEN>
		   <EQUAL? .WRD ,W?ELEVEN ,W?TWELVE ,W?THIRTEEN>
		   <EQUAL? .WRD ,W?FOURTEEN ,W?FIFTEEN ,W?SIXTEEN>
		   <EQUAL? .WRD ,W?SEVENTEEN ,W?EIGHTEEN ,W?NINETEEN>
		   <EQUAL? .WRD ,W?TWENTY ,W?THIRTY ,W?FORTY>
		   <EQUAL? .WRD ,W?FIFTY ,W?SIXTY ,W?EIGHTY>
		   <EQUAL? .WRD ,W?NINETY ,W?HUNDRED ,W?THOUSAND>
		   <EQUAL? .WRD ,W?MILLION ,W?BILLION ,W?ONE>>
	       <TELL "(Use numerals for numbers, for example \"10.\")" CR>
	       <RTRUE>)>>

<BUZZ	BASTARD CHOMP CURSE CURSES CUSS DAMN DARN FUCK FUDGE HELL
	PISS SCREW SHIT CRAP SUCK
	FUCKED GODDAMN ASSHOLE CUNT SHITHEAD SUCKS DAMNED PEE COCKSUCKER BITCH>

<ROUTINE NAUGHTY-WORD? (WORD)
 <COND (<OR <EQUAL? .WORD ,W?CURSE ,W?CURSES ,W?CUSS>
	    <EQUAL? .WORD ,W?DAMN ,W?SHIT ,W?FUCK>
	    <EQUAL? .WORD ,W?CHOMP ,W?DARN ,W?HELL>
	    <EQUAL? .WORD ,W?FUDGE ,W?PISS ,W?SUCK>
	    <EQUAL? .WORD ,W?BASTARD ,W?SCREW ,W?CRAP>
	    <EQUAL? .WORD ,W?FUCKED ,W?GODDAMN ,W?ASSHOLE>
	    <EQUAL? .WORD ,W?CUNT ,W?SHITHEAD ,W?SUCKS>
	    <EQUAL? .WORD ,W?DAMNED ,W?PEE ,W?COCKSUCKER>
	    <EQUAL? .WORD ,W?BITCH>>
	<PRINTC %<ASCII !\(>>
	<TELL <PICK-ONE-NEW ,OFFENDED>>
	<PRINTC %<ASCII !\)>>
	<CRLF>)>>

<GLOBAL OFFENDED
	<LTABLE 0
		"What charming language!"
		"Computers aren't impressed by naughty words!"
		"You ought to be ashamed of yourself!"
		"Hey, save that talk for the locker room!"
		"Step outside and say that!"
		"And so's your old man!">>

<BUZZ AGAIN G OOPS>

<ROUTINE PARSER ("AUX" (PTR ,P-LEXSTART) WRD (VAL 0) (VERB <>) (OF-FLAG <>)
		       LEN (DIR <>) (NW 0) (LW 0) (CNT -1) OMERGED OWINNER
		       TMP) 
	<REPEAT ()
		<COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN> <RETURN>)
		      (T
		       <COND (<NOT ,P-OFLAG>
			      <PUT ,P-OTBL .CNT <GET ,P-ITBL .CNT>>)>
		       <PUT ,P-ITBL .CNT 0>)>>
	<SETG P-NUMBER -1>
	<SETG P-NAM <>>
	<SETG P-ADJ <>>
	<SETG P-ADVERB <>>
	<SET OMERGED ,P-MERGED>
	<SETG P-MERGED <>>
	<SETG P-END-ON-PREP <>>
	;<SETG P-WHAT-IGNORED <>>
	<PUT ,P-PRSO ,P-MATCHLEN 0>
	<PUT ,P-PRSI ,P-MATCHLEN 0>
	<PUT ,P-BUTS ,P-MATCHLEN 0>
	<SET OWINNER ,WINNER>
	<COND (<AND <NOT ,QUOTE-FLAG> <N==? ,WINNER ,PLAYER>>
	       ;<SETG L-WINNER ,WINNER>
	       <SETG WINNER ,PLAYER>
	       <COND (T ;<NOT <FSET? <LOC ,WINNER> ,VEHBIT>>
		      ;<SETG LAST-PLAYER-LOC ,HERE>
		      <SETG HERE <LOC ,WINNER>>)>
	       <SETG LIT <LIT? ,HERE>>)>
	<COND (,RESERVE-PTR
	       <SET PTR ,RESERVE-PTR>
	       <STUFF ,P-LEXV ,RESERVE-LEXV>
	       <COND (<AND <EQUAL? ,VERBOSE 1 2>
			   <==? ,PLAYER ,WINNER>>
		      <CRLF>)>
	       <SETG RESERVE-PTR <>>
	       <SETG P-CONT <>>)
	      (<NOT <ZERO? ,P-CONT>>
	       <SET PTR ,P-CONT>
	       <SETG P-CONT <>>
	       <COND (<AND <NOT <0? ,VERBOSE>>
			   ;<NOT ,SUPER-BRIEF>
			   <==? ,PLAYER ,WINNER>>
		      <CRLF>)>
	       ;<COND (<NOT <VERB? ASK TELL SAY>> <CRLF>)>)
	      (T
	       ;<SETG L-WINNER ,WINNER>
	       <SETG WINNER ,PLAYER>
	       <SETG QUOTE-FLAG <>>
	       <COND (T ;<NOT <FSET? <LOC ,WINNER> ,VEHBIT>>
		      ;<SETG LAST-PLAYER-LOC ,HERE>
		      <SETG HERE <LOC ,WINNER>>)>
	       <SETG LIT <LIT? ,HERE>>
	       <FCLEAR ,IT  ,TOUCHBIT>	;"to prevent pronouns w/o referents"
	       <FCLEAR ,HER ,TOUCHBIT>
	       <FCLEAR ,HIM ,TOUCHBIT>
	       <FCLEAR,THEM ,TOUCHBIT>
	       <COND (<NOT <0? ,VERBOSE>>
		      ;<NOT ,SUPER-BRIEF>
		      <CRLF>)>
	       <COND (<AND ,P-PROMPT <NOT ,P-OFLAG>>
		      <COND (<EQUAL? ,P-PROMPT ,P-PROMPT-START>
			     <TELL "Okay, what do you want to do now?">)
			    (<DLESS? P-PROMPT 1>
			     <TELL
"(You won't see \"What next?\" any more.)|
">)
			    (T <TELL "What next?">)>
		      <CRLF>)>
	       <PUTB ,P-LEXV 0 59>
	       %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
		       '<PROG ()
			      <STATUS-LINE>
			      <TELL ">">>)
		      (T
		       '<TELL ">">)>
	       <READ ,P-INBUF ,P-LEXV>)>
	<SETG P-LEN <GETB ,P-LEXV ,P-LEXWORDS>>
	<COND (<AND <==? ,W?QUOTE <GET ,P-LEXV .PTR>>
		    <QCONTEXT-GOOD?>>		;"Is quote first input token?"
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<==? ,W?THEN <GET ,P-LEXV .PTR>>	;"Is THEN first input word?"
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<AND <L? 1 ,P-LEN>
		    <==? ,W?GO <GET ,P-LEXV .PTR>> ;"Is GO first input word?"
		    <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
		    <WT? .NW ,PS?VERB ;,P1?VERB>   ;" followed by verb?">
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<0? ,P-LEN> <TELL "I beg your pardon?" CR> <RFALSE>)
	      (<EQUAL? <GET ,P-LEXV .PTR> ,W?OOPS>
	       <COND (<NOT <G? ,P-LEN 1>>
		      <TELL "I can't help your clumsiness." CR>
		      <RFALSE>)
		     (<SET VAL <GET ,OOPS-TABLE ,O-PTR>>
		      <PUT ,AGAIN-LEXV .VAL <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
		      <SETG WINNER .OWINNER> ;"Fixes OOPS w/chars"
		      <SET TMP <+ <* .PTR ,P-LEXELEN> 6>>
		      <INBUF-ADD <GETB ,P-LEXV .TMP>
				 <GETB ,P-LEXV <+ .TMP 1>>
				 <+ <* .VAL ,P-LEXELEN> 3>>
		      <STUFF ,P-LEXV ,AGAIN-LEXV>
		      <SETG P-LEN <GETB ,P-LEXV ,P-LEXWORDS>>;"Will this help?"
		      <SET PTR <GET ,OOPS-TABLE ,O-START>>
		      <INBUF-STUFF ,P-INBUF ,OOPS-INBUF>)
		     (T
		      <PUT ,OOPS-TABLE ,O-END <>>
		      <TELL "There was no word to replace!" CR>
		      <RFALSE>)>)
	      (T <PUT ,OOPS-TABLE ,O-END <>>)>
	<COND (<EQUAL? <GET ,P-LEXV .PTR> ,W?AGAIN ,W?G>
	       <COND (,P-OFLAG
		      <TELL "It's difficult to repeat fragments." CR>
		      <RFALSE>)
		     (<G? ,P-LEN 1>
		      <COND (<OR <EQUAL? <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>
					,W?PERIOD ,W?COMMA ,W?THEN>
				 <EQUAL? <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>
					,W?AND>>
			     <SET PTR <+ .PTR <* 2 ,P-LEXELEN>>>
			     <PUTB ,P-LEXV ,P-LEXWORDS
				   <- <GETB ,P-LEXV ,P-LEXWORDS> 2>>)
			    (T
			     <TELL "I couldn't understand that sentence." CR>
			     <RFALSE>)>)
		     (T
		      <SET PTR <+ .PTR ,P-LEXELEN>>
		      <PUTB ,P-LEXV ,P-LEXWORDS 
			    <- <GETB ,P-LEXV ,P-LEXWORDS> 1>>)>
	       <COND (<G? <GETB ,P-LEXV ,P-LEXWORDS> 0>
		      <STUFF ,RESERVE-LEXV ,P-LEXV>
		      <SETG RESERVE-PTR .PTR>)
		     (T
		      <SETG RESERVE-PTR <>>)>
	       ;<SETG P-LEN <GETB ,AGAIN-LEXV ,P-LEXWORDS>>
	       <SETG WINNER .OWINNER>
	       <SETG P-MERGED .OMERGED>
	       <INBUF-STUFF ,P-INBUF ,OOPS-INBUF>
	       <STUFF ,P-LEXV ,AGAIN-LEXV>
	       <SET CNT -1>
	       <SET DIR ,P-WALK-DIR>
	       <REPEAT ()
		<COND (<IGRTR? CNT ,P-ITBLLEN> <RETURN>)
		      (T <PUT ,P-ITBL .CNT <GET ,P-OTBL .CNT>>)>>)
	      (T
	       <STUFF ,AGAIN-LEXV ,P-LEXV>
	       <INBUF-STUFF ,OOPS-INBUF ,P-INBUF>
	       <PUT ,OOPS-TABLE ,O-START .PTR>
	       <PUT ,OOPS-TABLE ,O-LENGTH <* 4 ,P-LEN>>
	       <SETG RESERVE-PTR <>>
	       <SET LEN ,P-LEN>
	       <SETG P-DIR <>>
	       <SETG P-NCN 0>
	       <SETG P-GETFLAGS 0>
	       ;"3/25/83: Next statement added."
	       <PUT ,P-ITBL ,P-VERBN 0>
	       <REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN 1>> 0>
		       <SETG QUOTE-FLAG <>>
		       <RETURN>)
		      (<BUZZER-WORD? <SET WRD <GET ,P-LEXV .PTR>>>
		       <RFALSE>)
		      (<OR .WRD
			   <SET WRD <NUMBER? .PTR>>
			   ;<SET WRD <NAME? .PTR>>>
		       <COND (<AND <==? .WRD ,W?TO>
				   <EQUAL? .VERB ,ACT?TELL ,ACT?ASK>>
			      <PUT ,P-ITBL ,P-VERB ,ACT?TELL>
			      ;<SET VERB ,ACT?TELL>
			      <SET WRD ,W?QUOTE>)
			     (<AND <==? .WRD ,W?THEN>
				   <NOT .VERB>
				   <NOT ,QUOTE-FLAG>>
			      <PUT ,P-ITBL ,P-VERB ,ACT?TELL>
			      <PUT ,P-ITBL ,P-VERBN 0>
			      <SET WRD ,W?QUOTE>)>
		       <COND ;(<AND <EQUAL? .WRD ,W?PERIOD>
				   <EQUAL? .LW ,W?MRS ,W?MR>>
			      <SET LW 0>)
			     (<EQUAL? .WRD ,W?THEN ,W?PERIOD ,W?QUOTE> 
			      <COND (<EQUAL? .WRD ,W?QUOTE>
				     <COND (,QUOTE-FLAG
					    <SETG QUOTE-FLAG <>>)
					   (T <SETG QUOTE-FLAG T>)>)>
			      <OR <0? ,P-LEN>
				  <SETG P-CONT <+ .PTR ,P-LEXELEN>>>
			      <PUTB ,P-LEXV ,P-LEXWORDS ,P-LEN>
			      <RETURN>)
			     (<AND <SET VAL
					<WT? .WRD
					     ,PS?DIRECTION
					     ,P1?DIRECTION>>
				   <EQUAL? .VERB <> ,ACT?WALK ,ACT?HEAD>
				   <OR <==? .LEN 1>
				       <AND <==? .LEN 2>
					   <EQUAL? .VERB ,ACT?WALK ,ACT?HEAD>>
				       <AND <EQUAL? <SET NW
						     <GET ,P-LEXV
							 <+ .PTR ,P-LEXELEN>>>
					            ,W?THEN
					            ,W?PERIOD
						    ,W?QUOTE>
					    <G? .LEN 1 ;2>>
				       ;<AND <EQUAL? .NW ,W?PERIOD>
					    <G? .LEN 1>>
				       <AND ,QUOTE-FLAG
					    <==? .LEN 2>
					    <EQUAL? .NW ,W?QUOTE>>
				       <AND <G? .LEN 2>
					    <EQUAL? .NW ,W?COMMA ,W?AND>>>>
			      <SET DIR .VAL>
			      <COND (<EQUAL? .NW ,W?COMMA ,W?AND>
				     <CHANGE-LEXV <+ .PTR ,P-LEXELEN>
						  ,W?THEN>)>
			      <COND (<NOT <G? .LEN 2>>
				     <SETG QUOTE-FLAG <>>
				     <RETURN>)>)
			     (<AND <SET VAL <WT? .WRD ,PS?VERB ,P1?VERB>>
				   <OR <NOT .VERB>
				       ;<EQUAL? .VERB ,ACT?NAME>>>
			      ;<COND (<EQUAL? .VERB ,ACT?NAME>
				     <SETG P-WHAT-IGNORED T>)>
			      <SET VERB .VAL>
			      <PUT ,P-ITBL ,P-VERB .VAL>
			      <PUT ,P-ITBL ,P-VERBN ,P-VTBL>
			      <PUT ,P-VTBL 0 .WRD>
			      <PUTB ,P-VTBL 2 <GETB ,P-LEXV
						    <SET TMP
							 <+ <* .PTR 2> 2>>>>
			      <PUTB ,P-VTBL 3 <GETB ,P-LEXV <+ .TMP 1>>>)
			     (<OR <SET VAL <WT? .WRD ,PS?PREPOSITION 0>>
				  <AND <OR <EQUAL? .WRD ,W?ONE ,W?A>
					   <EQUAL? .WRD ,W?BOTH ,W?ALL>
					   <WT? .WRD ,PS?ADJECTIVE>
					   <WT? .WRD ,PS?OBJECT>>
				       <SET VAL 0>>>
			      <COND (<AND <G? ,P-LEN 1 ;0>
					  <==? <GET ,P-LEXV
						    <+ .PTR ,P-LEXELEN>>
					       ,W?OF>
					  ;<NOT <EQUAL? .VERB
						       ,ACT?MAKE ,ACT?TAKE>>
					  <0? .VAL>
					  <NOT <EQUAL? .WRD ,W?ONE ,W?A>>
					  <NOT <EQUAL? .WRD ,W?ALL ,W?BOTH>>>
				     <SET OF-FLAG T>)
				    (<AND <NOT <0? .VAL>>
				          <OR <0? ,P-LEN>
					      <EQUAL? <GET ,P-LEXV <+ .PTR 2>>
						      ,W?THEN ,W?PERIOD>>>
				     <SETG P-END-ON-PREP T>
				     <COND (<L? ,P-NCN 2>
					    <PUT ,P-ITBL ,P-PREP1 .VAL>
					    <PUT ,P-ITBL ,P-PREP1N .WRD>)>)
				    (<==? ,P-NCN 2>
				     <TELL
"(I found too many nouns in that sentence!)" CR>
				     <RFALSE>)
				    (T
				     <SETG P-NCN <+ ,P-NCN 1>>
				     <OR <SET PTR <CLAUSE .PTR .VAL .WRD>>
					 <RFALSE>>
				     <COND (<L? .PTR 0>
					    <SETG QUOTE-FLAG <>>
					    <RETURN>)>)>)
			     (<==? .WRD ,W?CLOSELY>
			      <SETG P-ADVERB ,W?CAREFULLY>)
			     (<OR <EQUAL? .WRD
					 ,W?CAREFULLY ,W?QUIETLY>
				  <EQUAL? .WRD
					  ,W?SLOWLY ,W?QUICKLY ,W?BRIEFLY>>
			      <SETG P-ADVERB .WRD>)
			     (<EQUAL? .WRD ,W?OF>
			      <COND (<OR <NOT .OF-FLAG>
					 <EQUAL?
					  <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>
					  ,W?PERIOD ,W?THEN>>
				     <CANT-USE .PTR>
				     <RFALSE>)
				    (T
				     <SET OF-FLAG <>>)>)
			     (<WT? .WRD ,PS?BUZZ-WORD>)
			     (<AND <EQUAL? .VERB ,ACT?TELL>
				   <WT? .WRD ,PS?VERB ;,P1?VERB>>
			      <TELL
"(Please consult your manual for the correct way to talk to characters.)" CR>
			      <RFALSE>)
			     (T
			      <CANT-USE .PTR>
			      <RFALSE>)>)
		      (T
		       <UNKNOWN-WORD .PTR>
		       <RFALSE>)>
		<SET LW .WRD>
		<SET PTR <+ .PTR ,P-LEXELEN>>>)>
	<PUT ,OOPS-TABLE ,O-PTR <>>
	<COND (.DIR
	       <COND (<EQUAL? .VERB ,ACT?HEAD>
		      <SETG PRSA ,V?FACE>)
		     (T
		      <SETG PRSA ,V?WALK>)>
	       <SETG P-WALK-DIR .DIR>
	       <SETG PRSO .DIR>
	       <SETG P-OFLAG <>>
	       <RETURN T>)>
	<SETG P-WALK-DIR <>>
	<COND (<AND ,P-OFLAG
		    <ORPHAN-MERGE>>
	       <SETG WINNER .OWINNER>)>
	<COND (<==? <GET ,P-ITBL ,P-VERB> 0>
	       <PUT ,P-ITBL ,P-VERB ,ACT?$CALL>)>
	<COND (<AND <SYNTAX-CHECK> <SNARF-OBJECTS> <MANY-CHECK> <TAKE-CHECK>>
	       T)>>

<GLOBAL P-WALK-DIR <>>


"For AGAIN purposes, put contents of one LEXV table into another:"

<ROUTINE STUFF (DEST SRC "OPTIONAL" (MAX 29) "AUX" (PTR ,P-LEXSTART) (CTR 1)
						   BPTR)
	 <PUTB .DEST 0 <GETB .SRC 0>>
	 <PUTB .DEST 1 <GETB .SRC 1>>
	 <REPEAT ()
	  <PUT .DEST .PTR <GET .SRC .PTR>>
	  <SET BPTR <+ <* .PTR 2> 2>>
	  <PUTB .DEST .BPTR <GETB .SRC .BPTR>>
	  <SET BPTR <+ <* .PTR 2> 3>>
	  <PUTB .DEST .BPTR <GETB .SRC .BPTR>>
	  <SET PTR <+ .PTR ,P-LEXELEN>>
	  <COND (<IGRTR? CTR .MAX>
		 <RETURN>)>>>

"Put contents of one INBUF into another:"

<ROUTINE INBUF-STUFF (DEST SRC "AUX" (CNT -1))
	 <REPEAT ()
	  <COND (<IGRTR? CNT 59> <RETURN>)
		(T <PUTB .DEST .CNT <GETB .SRC .CNT>>)>>> 

"Put the word in the positions specified from P-INBUF to the end of
OOPS-INBUF, leaving the appropriate pointers in AGAIN-LEXV:"

<ROUTINE INBUF-ADD (LEN BEG SLOT "AUX" DBEG (CTR 0) TMP)
	 <COND (<SET TMP <GET ,OOPS-TABLE ,O-END>>
		<SET DBEG .TMP>)
	       (T
		<SET DBEG <+ <GETB ,AGAIN-LEXV
				   <SET TMP <GET ,OOPS-TABLE ,O-LENGTH>>>
			     <GETB ,AGAIN-LEXV <+ .TMP 1>>>>)>
	 <PUT ,OOPS-TABLE ,O-END <+ .DBEG .LEN>>
	 <REPEAT ()
	  <PUTB ,OOPS-INBUF <+ .DBEG .CTR> <GETB ,P-INBUF <+ .BEG .CTR>>>
	  <SET CTR <+ .CTR 1>>
	  <COND (<EQUAL? .CTR .LEN> <RETURN>)>>
	 <PUTB ,AGAIN-LEXV .SLOT .DBEG>
	 <PUTB ,AGAIN-LEXV <- .SLOT 1> .LEN>>

"Check whether word pointed at by PTR is the correct part of speech.
   The second argument is the part of speech (,PS?<part of speech>).  The
   3rd argument (,P1?<part of speech>), if given, causes the value
   for that part of speech to be returned." 

<ROUTINE WT? (PTR BIT "OPTIONAL" (B1 5) "AUX" (OFFS ,P-P1OFF) TYP) 
	<COND (<BTST <SET TYP <GETB .PTR ,P-PSOFF>> .BIT>
	       <COND (<G? .B1 4> <RTRUE>)
		     (T
		      <SET TYP <BAND .TYP ,P-P1BITS>>
		      <COND (<NOT <==? .TYP .B1>> <SET OFFS <+ .OFFS 1>>)>
		      <GETB .PTR .OFFS>)>)>>

<ROUTINE CHANGE-LEXV (PTR WRD)
	 <PUT ,P-LEXV .PTR .WRD>
	 <PUT ,AGAIN-LEXV .PTR .WRD>>

"Scan through a noun phrase, leaving a pointer to its starting location:"

<ROUTINE CLAUSE (PTR VAL WRD "AUX" OFF NUM (ANDFLG <>) (FIRST?? T) NW (LW 0))
	<SET OFF <* <- ,P-NCN 1> 2>>
	<COND (<NOT <==? .VAL 0>>
	       <PUT ,P-ITBL <SET NUM <+ ,P-PREP1 .OFF>> .VAL>
	       <PUT ,P-ITBL <+ .NUM 1> .WRD>
	       <SET PTR <+ .PTR ,P-LEXELEN>>)
	      (T <SETG P-LEN <+ ,P-LEN 1>>)>
	<COND (<0? ,P-LEN> <SETG P-NCN <- ,P-NCN 1>> <RETURN -1>)>
	<PUT ,P-ITBL <SET NUM <+ ,P-NC1 .OFF>> <REST ,P-LEXV <* .PTR 2>>>
	<COND (<EQUAL? <GET ,P-LEXV .PTR> ,W?THE ,W?A ,W?AN>
	       <PUT ,P-ITBL .NUM <REST <GET ,P-ITBL .NUM> 4>>)>
	<REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN 1>> 0>
		       <PUT ,P-ITBL <+ .NUM 1> <REST ,P-LEXV <* .PTR 2>>>
		       <RETURN -1>)>
		<COND (<BUZZER-WORD? <SET WRD <GET ,P-LEXV .PTR>>>
		       <RFALSE>)
		      (<OR .WRD
			   <SET WRD <NUMBER? .PTR>>
			   ;<SET WRD <NAME? .PTR>>>
		       <COND (<0? ,P-LEN> <SET NW 0>)
			     (T <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>)>
		       ;<COND (<AND <==? .WRD ,W?OF>
				   <EQUAL? <GET ,P-ITBL ,P-VERB>
					   ,ACT?MAKE ,ACT?TAKE>>
			      <CHANGE-LEXV .PTR ,W?WITH>
			      <SET WRD ,W?WITH>)>
		       <COND ;(<AND <EQUAL? .WRD ,W?PERIOD>
				   <EQUAL? .LW ,W?MRS ,W?MR>>
			      <SET LW 0>)
			     (<EQUAL? .WRD ,W?AND ,W?COMMA> <SET ANDFLG T>)
			     (<EQUAL? .WRD ,W?ALL ,W?BOTH ,W?ONE>
			      <COND (<==? .NW ,W?OF>
				     <SETG P-LEN <- ,P-LEN 1>>
				     <SET PTR <+ .PTR ,P-LEXELEN>>)>)
			     (<OR <EQUAL? .WRD ,W?THEN ,W?PERIOD>
				  <AND <WT? .WRD ,PS?PREPOSITION>
				       <GET ,P-ITBL ,P-VERB>
				       <NOT .FIRST??>>>
			      <SETG P-LEN <+ ,P-LEN 1>>
			      <PUT ,P-ITBL
				   <+ .NUM 1>
				   <REST ,P-LEXV <* .PTR 2>>>
			      <RETURN <- .PTR ,P-LEXELEN>>)
			     ;"3/16/83: This clause used to be later."
			     (<AND .ANDFLG
				   <OR ;"3/25/83: next statement added."
				       <EQUAL? <GET ,P-ITBL ,P-VERBN> 0>
				       ;"10/26/84: next stmt changed"
				       <VERB-DIR-ONLY? .WRD>>>
			      <SET PTR <- .PTR 4>>
			      <CHANGE-LEXV <+ .PTR 2> ,W?THEN>
			      <SETG P-LEN <+ ,P-LEN 2>>)
			     (<WT? .WRD ,PS?OBJECT>
			      <COND (<AND <G? ,P-LEN 0>
					  <EQUAL? .NW ,W?OF>
					  <NOT <EQUAL? .WRD ,W?ALL ,W?ONE>>>
				     T)
				    (<AND <WT? .WRD
					       ,PS?ADJECTIVE
					       ;,P1?ADJECTIVE>
					  <NOT <==? .NW 0>>
					  <WT? .NW ,PS?OBJECT>>)
				    (<AND <NOT .ANDFLG>
					  <NOT <EQUAL? .NW ,W?BUT ,W?EXCEPT>>
					  <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
				     <PUT ,P-ITBL
					  <+ .NUM 1>
					  <REST ,P-LEXV <* <+ .PTR 2> 2>>>
				     <RETURN .PTR>)
				    (T <SET ANDFLG <>>)>)
			     ;"Next clause replaced by following one to allow
			       ATTRACTIVE MAN, VERB - JW 2/15/85"
			     ;(<AND <OR ,P-MERGED
				       ,P-OFLAG
				       <NOT <EQUAL? <GET ,P-ITBL ,P-VERB> 0>>>
				   <OR <WT? .WRD ,PS?ADJECTIVE>
				       <WT? .WRD ,PS?BUZZ-WORD>>>)
			     (<OR <WT? .WRD ,PS?ADJECTIVE>
				  <WT? .WRD ,PS?BUZZ-WORD>>)
			     (<AND .ANDFLG
				   <EQUAL? <GET ,P-ITBL ,P-VERB> 0>>
			      <SET PTR <- .PTR 4>>
			      <CHANGE-LEXV <+ .PTR 2> ,W?THEN>
			      <SETG P-LEN <+ ,P-LEN 2>>)
			     (<WT? .WRD ,PS?PREPOSITION> T)
			     (T
			      <CANT-USE .PTR>
			      <RFALSE>)>)
		      (T <UNKNOWN-WORD .PTR> <RFALSE>)>
		<SET LW .WRD>
		<SET FIRST?? <>>
		<SET PTR <+ .PTR ,P-LEXELEN>>>> 

<ROUTINE VERB-DIR-ONLY? (WRD)
	<AND <NOT <WT? .WRD ,PS?OBJECT>>
	     <NOT <WT? .WRD ,PS?ADJECTIVE>>
	     <OR <WT? .WRD ,PS?DIRECTION>
		 <WT? .WRD ,PS?VERB>>>>

<ROUTINE NUMBER? (PTR "AUX" CNT BPTR CHR (SUM 0) (TIM <>) (DOLLAR <>) CCTR TMP
			    NW PTT)
	 <SET TMP <REST ,P-LEXV <* .PTR 2>>>
	 <SET CNT  <GETB .TMP 2>>
	 <SET BPTR <GETB .TMP 3>>
	 ;<SETG P-DOLLAR-FLAG <>>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0> <RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			<COND (<==? .CHR %<ASCII !\:>>
			       <SET TIM .SUM>
			       <SET SUM 0>)
			      (<G? .SUM 9999> <RFALSE>)
			      (<EQUAL? .CHR ,CURRENCY-SYMBOL>
			       <SET DOLLAR T>)
			      (<OR <G? .CHR %<ASCII !\9>>
				   <L? .CHR %<ASCII !\0>>>
			       <RFALSE>)
			      (T
			       <SET SUM <+ <* .SUM 10>
					   <- .CHR %<ASCII !\0>>>>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <CHANGE-LEXV .PTR ,W?NUMBER>
	 <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
	 <COND (<AND <NOT .DOLLAR>
		     <EQUAL? .NW ,W?PERIOD>
		     <G? ,P-LEN 1>>
		<COND (<SET TMP <CENTS-CHECK <+ .PTR <* ,P-LEXELEN 2>>>>
		       <SETG P-CENT-FLAG T>
		       <COND (<EQUAL? .TMP 100> <SET TMP 0>)>
		       <SET TIM .SUM>
		       <SET SUM .TMP>
		       ;<SET SUM <+ <* 100 .SUM> .TMP>>
		       <SET CCTR <- ,P-LEN 2>>
		       <SET TMP <* 2 ,P-LEXELEN>>	;"two tokens"
		       <SET PTT <+ .PTR .TMP>>
		       <REPEAT ()
			 <COND (<DLESS? CCTR 0> <RETURN>)
			       (T
				<SET PTR <+ .PTR ,P-LEXELEN>>
				<CHANGE-LEXV .PTR <GET ,P-LEXV .PTT>>
				<PUTB ,P-LEXV <+ <* .PTR 2> 2>
				<GETB ,P-LEXV <+ <* .PTT 2> 2>>>
				<PUTB ,P-LEXV <+ <* .PTR 2> 3>
				<GETB ,P-LEXV <+ <* .PTT 2> 3>>>)>>
		       <SETG P-LEN <- ,P-LEN 2>>
		       <PUTB ,P-LEXV ,P-LEXWORDS
			     <- <GETB ,P-LEXV ,P-LEXWORDS> 2>>)
		      (T <SETG P-CENT-FLAG <>>)>)>
	 <COND (<G? .SUM 9999> <RFALSE>)
	       (.TIM
		<COND (<G? .TIM 23> <RFALSE>)>
		<SET SUM <+ .SUM <* .TIM 60>>>)>
	 ;<SETG P-DOLLAR-FLAG .DOLLAR>
	 <COND (<AND .DOLLAR <G? .SUM 0>>
		<SETG P-AMOUNT .SUM>
		<SETG P-DOLLAR-FLAG T>
		,W?MONEY)
	       (T
		<SETG P-NUMBER .SUM>
		<SETG P-DOLLAR-FLAG <>>
		,W?NUMBER)>>

<ROUTINE CENTS-CHECK (PTR "AUX" CNT BPTR (CCTR 0) CHR (SUM 0) TMP)
	 <SET TMP <REST ,P-LEXV <* .PTR 2>>>
	 <SET CNT  <GETB .TMP 2>>
	 <SET BPTR <GETB .TMP 3>>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0> <RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			<COND (<IGRTR? CCTR 2> <RFALSE>)
			      (<OR <G? .CHR %<ASCII !\5>>
				   <L? .CHR %<ASCII !\0>>>
			       <RFALSE>)
			      (T
			       <SET SUM <+ <* .SUM 10>
					   <- .CHR %<ASCII !\0>>>>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <COND (<0? .SUM>
		<RETURN 100>)
	       (<EQUAL? .CCTR 1>
		<RETURN <* 10 .SUM>>)
	       (T <RETURN .SUM>)>>

<GLOBAL P-NUMBER -1>
<GLOBAL P-AMOUNT 0>
<GLOBAL P-DOLLAR-FLAG <>>
<GLOBAL P-CENT-FLAG <>>
<CONSTANT CURRENCY-SYMBOL %<ASCII !\*>>

<GLOBAL P-DIRECTION 0>

<ROUTINE ORPHAN-MERGE ("AUX" (CNT -1) TEMP VERB BEG END (ADJ <>) WRD) 
   <SETG P-OFLAG <>>
   <COND (<WT? <SET WRD <GET <GET ,P-ITBL ,P-VERBN> 0>> ,PS?ADJECTIVE>
	  <SET ADJ T>)
	 (<AND <WT? .WRD ,PS?OBJECT>
	       <EQUAL? ,P-NCN 0>>
	  <PUT ,P-ITBL ,P-VERB 0>
	  <PUT ,P-ITBL ,P-VERBN 0>
	  <PUT ,P-ITBL ,P-NC1 <REST ,P-LEXV 2>>
	  <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>
	  <SETG P-NCN 1>)>
   <COND (<AND <NOT <0? <SET VERB <GET ,P-ITBL ,P-VERB>>>>
	       <NOT .ADJ>
	       <NOT <==? .VERB <GET ,P-OTBL ,P-VERB>>>>
	  <RFALSE>)
	 (<==? ,P-NCN 2> <RFALSE>)
	 (<==? <GET ,P-OTBL ,P-NC1> 1>
	  <COND (<OR <==? <SET TEMP <GET ,P-ITBL ,P-PREP1>>
			  <GET ,P-OTBL ,P-PREP1>>
		     <0? .TEMP>>
		 <COND (.ADJ
			<PUT ,P-OTBL ,P-NC1 <REST ,P-LEXV 2>>
			<COND (<ZERO? <GET ,P-ITBL ,P-NC1L>> ;"? DELETE?"
			       <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>)>
			<COND (<ZERO? ,P-NCN> ;"? DELETE?"
			       <SETG P-NCN 1>)>
			;<PUT ,P-OTBL ,P-NC1L <REST ,P-LEXV 6>>)
		       (T
			<PUT ,P-OTBL ,P-NC1 <GET ,P-ITBL ,P-NC1>>
			;<PUT ,P-OTBL ,P-NC1L <GET ,P-ITBL ,P-NC1L>>)>
		 <PUT ,P-OTBL ,P-NC1L <GET ,P-ITBL ,P-NC1L>>)
		(T <RFALSE>)>)
	 (<==? <GET ,P-OTBL ,P-NC2> 1>
	  <COND (<OR <==? <SET TEMP <GET ,P-ITBL ,P-PREP1>>
			  <GET ,P-OTBL ,P-PREP2>>
		     <0? .TEMP>>
		 <COND (.ADJ
			<PUT ,P-ITBL ,P-NC1 <REST ,P-LEXV 2>>
			<COND (<ZERO? <GET ,P-ITBL ,P-NC1L>> ;"? DELETE?"
			       <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>)>
			;<PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>)>
		 <PUT ,P-OTBL ,P-NC2 <GET ,P-ITBL ,P-NC1>>
		 <PUT ,P-OTBL ,P-NC2L <GET ,P-ITBL ,P-NC1L>>
		 <SETG P-NCN 2>)
		(T <RFALSE>)>)
	 (,P-ACLAUSE
	  <COND (<AND <NOT <==? ,P-NCN 1>> <NOT .ADJ>>
		 <SETG P-ACLAUSE <>>
		 <RFALSE>)
		(T
		 <SET BEG <GET ,P-ITBL ,P-NC1>>
		 <COND (.ADJ <SET BEG <REST ,P-LEXV 2>> <SET ADJ <>>)>
		 <SET END <GET ,P-ITBL ,P-NC1L>>
		 <REPEAT ()
			 <SET WRD <GET .BEG 0>>
			 <COND (<==? .BEG .END>
				<COND (.ADJ <ACLAUSE-WIN .ADJ> <RETURN>)
				      (T <SETG P-ACLAUSE <>> <RFALSE>)>)
			       (<AND <NOT .ADJ>
				     <OR <BTST <GETB .WRD ,P-PSOFF>
					       ,PS?ADJECTIVE> ;"same as WT?"
					 <EQUAL? .WRD ,W?ALL ,W?ONE>>>
				<SET ADJ .WRD>)
			       (<==? .WRD ,W?ONE>
				<ACLAUSE-WIN .ADJ>
				<RETURN>)
			       (<BTST <GETB .WRD ,P-PSOFF> ,PS?OBJECT>
				<COND (<EQUAL? .WRD ,P-ANAM>
				       <ACLAUSE-WIN .ADJ>)
				      (T
				       <NCLAUSE-WIN>)>
				<RETURN>)>
			 <SET BEG <REST .BEG ,P-WORDLEN>>
			 <COND (<EQUAL? .END 0>
				<SET END .BEG>
				<SETG P-NCN 1>
				<PUT ,P-ITBL ,P-NC1 <BACK .BEG 4>>
				<PUT ,P-ITBL ,P-NC1L .BEG>)>>)>)>
   <PUT ,P-VTBL 0 <GET ,P-OVTBL 0>>
   <PUTB ,P-VTBL 2 <GETB ,P-OVTBL 2>>
   <PUTB ,P-VTBL 3 <GETB ,P-OVTBL 3>>
   <PUT ,P-OTBL ,P-VERBN ,P-VTBL>
   <PUTB ,P-VTBL 2 0>
   ;<AND <NOT <==? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
   <REPEAT ()
	   <COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN>
		  <SETG P-MERGED T>
		  <RTRUE>)
		 (T <PUT ,P-ITBL .CNT <GET ,P-OTBL .CNT>>)>>
   T>

<ROUTINE ACLAUSE-WIN (ADJ "AUX" X)
	<PUT ,P-ITBL ,P-VERB <GET ,P-OTBL ,P-VERB>>
	<SET X <+ ,P-ACLAUSE 1>>
	%<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	      '<CLAUSE-COPY ,P-OTBL ,P-OTBL ,P-ACLAUSE .X ,P-ACLAUSE .X .ADJ>)
	       (T
		'<PROG ()
		       <PUT ,P-CCTBL ,CC-SBPTR ,P-ACLAUSE>
		       <PUT ,P-CCTBL ,CC-SEPTR .X>
		       <PUT ,P-CCTBL ,CC-DBPTR ,P-ACLAUSE>
		       <PUT ,P-CCTBL ,CC-DEPTR .X>
		       <CLAUSE-COPY ,P-OTBL ,P-OTBL .ADJ>>)>
	<AND <NOT <==? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
	<SETG P-ACLAUSE <>>
	<RTRUE>>

<ROUTINE NCLAUSE-WIN ()
        %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
		'<CLAUSE-COPY ,P-ITBL ,P-OTBL ,P-NC1 ,P-NC1L
			      ,P-ACLAUSE <+ ,P-ACLAUSE 1>>)
	       (T
		'<PROG ()
		       <PUT ,P-CCTBL ,CC-SBPTR ,P-NC1>
		       <PUT ,P-CCTBL ,CC-SEPTR ,P-NC1L>
		       <PUT ,P-CCTBL ,CC-DBPTR ,P-ACLAUSE>
		       <PUT ,P-CCTBL ,CC-DEPTR <+ ,P-ACLAUSE 1>>
		       <CLAUSE-COPY ,P-ITBL ,P-OTBL>>)>
	<AND <NOT <==? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
	<SETG P-ACLAUSE <>>
	<RTRUE>>


"Print undefined word in input. PTR points to the unknown word in P-LEXV:"   

<ROUTINE WORD-PRINT (CNT BUF)
	 ;<COND (<G? .CNT 6> <SET CNT 6>)>
	 <REPEAT ()
		 <COND (<DLESS? CNT 0> <RETURN>)
		       (ELSE
			<PRINTC <GETB ,P-INBUF .BUF>>
			<SET BUF <+ .BUF 1>>)>>>

<GLOBAL UNKNOWN-MSGS
 <PLTABLE
  <PTABLE "(I don't know the word \""
	 "\".)">
  <PTABLE "(Sorry, but the word \""
	 "\" is not in the vocabulary that you can use.)">
  <PTABLE "(You don't need to use the word \""
	 "\" to finish this story.)">
  <PTABLE "(Sorry, but this story doesn't recognize the word \""
	 "\".)">>>

<ROUTINE UNKNOWN-WORD (PTR "AUX" BUF MSG)
	<PUT ,OOPS-TABLE ,O-PTR .PTR>
	<SET MSG <PICK-ONE ,UNKNOWN-MSGS>>
	<COND (T ;<EQUAL? ,WINNER ,PLAYER>
	       <TELL <GET .MSG 0>>)
	      ;(T <TELL "\"Please, I not know English word '">)>
	<WORD-PRINT <GETB <REST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
		    <GETB <REST ,P-LEXV .BUF> 3>>
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>
	<COND (T ;<EQUAL? ,WINNER ,PLAYER>
	       <TELL <GET .MSG 1> CR>)
	      ;(T <TELL "'.\"" CR>)>>

<ROUTINE CANT-USE (PTR "AUX" BUF) 
	;#DECL ((PTR BUF) FIX)
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>
	<COND (T ;<EQUAL? ,WINNER ,PLAYER>
	       <TELL "(Sorry, but I don't understand the word \"">
	       <WORD-PRINT <GETB <REST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
			   <GETB <REST ,P-LEXV .BUF> 3>>
	       <TELL "\" when you use it that way.)" CR>)
	      ;(T <TELL "\"Please, to me simple English speak.\"" CR>)>>

" Perform syntax matching operations, using P-ITBL as the source of
   the verb and adjectives for this input.  Returns false if no
   syntax matches, and does it's own orphaning.  If return is true,
   the syntax is saved in P-SYNTAX."   

<GLOBAL P-SLOCBITS 0>    

<CONSTANT P-SYNLEN 8>    

<CONSTANT P-SBITS 0> 
<CONSTANT P-SPREP1 1>
<CONSTANT P-SPREP2 2>
<CONSTANT P-SFWIM1 3>
<CONSTANT P-SFWIM2 4>
<CONSTANT P-SLOC1 5>
<CONSTANT P-SLOC2 6>
<CONSTANT P-SACTION 7>   

<CONSTANT P-SONUMS 3>    

<ROUTINE SYNTAX-CHECK ("AUX" SYN LEN NUM OBJ (DRIVE1 <>) (DRIVE2 <>)
			     PREP VERB) 
	;#DECL ((DRIVE1 DRIVE2) <OR FALSE <PRIMTYPE VECTOR>>
	       (SYN) <PRIMTYPE VECTOR> (LEN NUM VERB PREP) FIX
	       (OBJ) <OR FALSE OBJECT>)
	<COND (<0? <SET VERB <GET ,P-ITBL ,P-VERB>>>
	       <MISSING-VERB>
	       <RFALSE>)>
	<SET SYN <GET ,VERBS <- 255 .VERB>>>
	<SET LEN <GETB .SYN 0>>
	<SET SYN <REST .SYN>>
	<REPEAT ()
		<SET NUM <BAND <GETB .SYN ,P-SBITS> ,P-SONUMS>>
		<COND (<G? ,P-NCN .NUM> T) ;"Added 4/27/83"
		      (<AND <NOT <L? .NUM 1>>
			    <0? ,P-NCN>
			    <OR <0? <SET PREP <GET ,P-ITBL ,P-PREP1>>>
				<==? .PREP <GETB .SYN ,P-SPREP1>>>>
		       <SET DRIVE1 .SYN>)
		      (<==? <GETB .SYN ,P-SPREP1> <GET ,P-ITBL ,P-PREP1>>
		       <COND (<AND <==? .NUM 2> <==? ,P-NCN 1>>
			      <SET DRIVE2 .SYN>)
			     (<==? <GETB .SYN ,P-SPREP2>
				   <GET ,P-ITBL ,P-PREP2>>
			      <SYNTAX-FOUND .SYN>
			      <RTRUE>)>)>
		<COND (<DLESS? LEN 1>
		       <COND (<OR .DRIVE1 .DRIVE2> <RETURN>)
			     (T
			      <DONT-UNDERSTAND>
			      <RFALSE>)>)
		      (T <SET SYN <REST .SYN ,P-SYNLEN>>)>>
	<COND (<AND .DRIVE1
		    <SET OBJ
			 <GWIM <GETB .DRIVE1 ,P-SFWIM1>
			       <GETB .DRIVE1 ,P-SLOC1>
			       <GETB .DRIVE1 ,P-SPREP1>>>>
	       <PUT ,P-PRSO ,P-MATCHLEN 1>
	       <PUT ,P-PRSO 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE1>)
	      (<AND .DRIVE2
		    <SET OBJ
			 <GWIM <GETB .DRIVE2 ,P-SFWIM2>
			       <GETB .DRIVE2 ,P-SLOC2>
			       <GETB .DRIVE2 ,P-SPREP2>>>>
	       <PUT ,P-PRSI ,P-MATCHLEN 1>
	       <PUT ,P-PRSI 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE2>)
	      (<EQUAL? .VERB ,ACT?FIND ,ACT?NAME>
	       <TELL "(Sorry, but I can't answer that question.)" CR>
	       <RFALSE>)
	      (T
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <ORPHAN .DRIVE1 .DRIVE2>
		      <TELL "(Wh">)
		     (T
		      <TELL
"(Your command was not complete. Next time, type wh">)>
	       <COND (<EQUAL? .VERB ,ACT?WALK ,ACT?HEAD>
		      <TELL "ere">)
		     (<OR <AND .DRIVE1
			       <==? <GETB .DRIVE1 ,P-SFWIM1> ,PERSONBIT>>
			  <AND .DRIVE2
			       <==? <GETB .DRIVE2 ,P-SFWIM2> ,PERSONBIT>>>
		      <TELL "om">)
		     (T <TELL "at">)>
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <TELL " do you want to ">)
		     (T
		      <TELL " you want" HIM ,WINNER " to ">)>
	       <VERB-PRINT>
	       <COND (.DRIVE2
		      <CLAUSE-PRINT ,P-NC1 ,P-NC1L>)>
	       <SETG P-END-ON-PREP <>>
	       <PREP-PRINT <COND (.DRIVE1 <GETB .DRIVE1 ,P-SPREP1>)
				 (T <GETB .DRIVE2 ,P-SPREP2>)>>
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <SETG P-OFLAG T>
		      <TELL "?)" CR>)
		     (T
		      <SETG P-OFLAG <>>
		      <TELL ".)" CR>)>
	       <RFALSE>)>>

<ROUTINE DONT-UNDERSTAND ()
	<TELL
"(Sorry, but I don't understand. Please reword that or try something else.)"
CR>>

<ROUTINE VERB-PRINT ("AUX" TMP)
	<SET TMP <GET ,P-ITBL ,P-VERBN>>	;"? ,P-OTBL?"
	<COND (<==? .TMP 0> <TELL "tell">)
	      (<0? <GETB ,P-VTBL 2>>
	       <PRINTB <GET .TMP 0>>)
	      (T
	       <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
	       <PUTB ,P-VTBL 2 0>)>>

<ROUTINE ORPHAN (D1 D2 "AUX" (CNT -1)) 
	;#DECL ((D1 D2) <OR FALSE <PRIMTYPE VECTOR>>)
	<COND (<NOT ,P-MERGED>
	       <PUT ,P-OCLAUSE ,P-MATCHLEN 0>)>
	<PUT ,P-OVTBL 0 <GET ,P-VTBL 0>>
	<PUTB ,P-OVTBL 2 <GETB ,P-VTBL 2>>
	<PUTB ,P-OVTBL 3 <GETB ,P-VTBL 3>>
	<REPEAT ()
		<COND (<IGRTR? CNT ,P-ITBLLEN> <RETURN>)
		      (T <PUT ,P-OTBL .CNT <GET ,P-ITBL .CNT>>)>>
	<COND (<==? ,P-NCN 2>
	       %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
		       '<CLAUSE-COPY ,P-ITBL ,P-OTBL
				     ,P-NC2 ,P-NC2L ,P-NC2 ,P-NC2L>)
		      (T
		       '<PROG ()
			      <PUT ,P-CCTBL ,CC-SBPTR ,P-NC2>
			      <PUT ,P-CCTBL ,CC-SEPTR ,P-NC2L>
			      <PUT ,P-CCTBL ,CC-DBPTR ,P-NC2>
			      <PUT ,P-CCTBL ,CC-DEPTR ,P-NC2L>
			      <CLAUSE-COPY ,P-ITBL ,P-OTBL>>)>)>
	<COND (<NOT <L? ,P-NCN 1>>
	       %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
		       '<CLAUSE-COPY ,P-ITBL ,P-OTBL
				     ,P-NC1 ,P-NC1L ,P-NC1 ,P-NC1L>)
		      (T
		       '<PROG ()
			      <PUT ,P-CCTBL ,CC-SBPTR ,P-NC1>
			      <PUT ,P-CCTBL ,CC-SEPTR ,P-NC1L>
			      <PUT ,P-CCTBL ,CC-DBPTR ,P-NC1>
			      <PUT ,P-CCTBL ,CC-DEPTR ,P-NC1L>
			      <CLAUSE-COPY ,P-ITBL ,P-OTBL>>)>)>
	<COND (.D1
	       <PUT ,P-OTBL ,P-PREP1 <GETB .D1 ,P-SPREP1>>
	       <PUT ,P-OTBL ,P-NC1 1>)
	      (.D2
	       <PUT ,P-OTBL ,P-PREP2 <GETB .D2 ,P-SPREP2>>
	       <PUT ,P-OTBL ,P-NC2 1>)>> 

<ROUTINE CLAUSE-PRINT (BPTR EPTR "OPTIONAL" (THE? T)) 
	<BUFFER-PRINT <GET ,P-ITBL .BPTR> <GET ,P-ITBL .EPTR> .THE?>>    

<ROUTINE BUFFER-PRINT (BEG END CP "AUX" (NOSP <>) WRD (FIRST?? T) (PN <>))
	 <REPEAT ()
		<COND (<==? .BEG .END> <RETURN>)
		      (T
		       <COND (.NOSP <SET NOSP <>>)
			     (T <TELL " ">)>
		       <SET WRD <GET .BEG 0>>
		       <COND (<OR <AND <EQUAL? .WRD ,W?HIM>
				       <NOT <VISIBLE? ,P-HIM-OBJECT>>>
				  <AND <EQUAL? .WRD ,W?HER>
				       <NOT <VISIBLE? ,P-HER-OBJECT>>>
				  <AND <EQUAL? .WRD ,W?THEM>
				       <NOT <VISIBLE? ,P-THEM-OBJECT>>>>
			      <SET PN T>)>
		       <COND (<==? .WRD ,W?PERIOD>
			      <SET NOSP T>)
			     (<AND <OR <WT? .WRD ,PS?BUZZ-WORD>
				       <WT? .WRD ,PS?PREPOSITION>>
				   <NOT <WT? .WRD ,PS?ADJECTIVE>>
				   <NOT <WT? .WRD ,PS?OBJECT>>>
			      <SET NOSP T>)
			     (<EQUAL? .WRD ,W?ME>
			      <PRINTD ,PLAYER>
			      <SET PN T>)
			     (<CAPITAL-NOUN? .WRD>
			      <CAPITALIZE .BEG>
			      <SET PN T>)
			     (T
			      <COND (<AND .FIRST?? <NOT .PN> .CP>
				     <TELL "the ">)>
			      <COND (<OR ,P-OFLAG ,P-MERGED> <PRINTB .WRD>)
				    (<AND <==? .WRD ,W?IT>
					  <VISIBLE? ,P-IT-OBJECT>>
				     <PRINTD ,P-IT-OBJECT>)
				    (<AND <EQUAL? .WRD ,W?HER>
					  <NOT .PN>	;"VISIBLE check above"
					  ;<VISIBLE? ,P-HER-OBJECT>>
				     <PRINTD ,P-HER-OBJECT>)
				    (<AND <EQUAL? .WRD ,W?THEM>
					  <NOT .PN>
					  ;<VISIBLE? ,P-THEM-OBJECT>>
				     <PRINTD ,P-THEM-OBJECT>)
				    (<AND <EQUAL? .WRD ,W?HIM>
					  <NOT .PN>
					  ;<VISIBLE? ,P-HIM-OBJECT>>
				     <PRINTD ,P-HIM-OBJECT>)
				    (T
				     <WORD-PRINT <GETB .BEG 2>
						 <GETB .BEG 3>>)>
			      <SET FIRST?? <>>)>)>
		<SET BEG <REST .BEG ,P-WORDLEN>>>>

<ROUTINE CAPITAL-NOUN? (WRD)
	<OR <EQUAL? .WRD ,W?FRBZ ,W?GRNZ ,W?GOLA>
	    <EQUAL? .WRD ,W?KNUT ,W?HRNG ,W?WIEN>>>

<ROUTINE CAPITALIZE (PTR)
	 <COND (<OR ,P-OFLAG ,P-MERGED>
		<PRINTB <GET .PTR 0>>)
	       (T
		<PRINTC <- <GETB ,P-INBUF <GETB .PTR 3>> 32>>
		<WORD-PRINT <- <GETB .PTR 2> 1> <+ <GETB .PTR 3> 1>>)>>

<ROUTINE PREP-PRINT (PREP "OPTIONAL" (SP? T) "AUX" WRD) 
	;#DECL ((PREP) FIX)
	<COND (<AND <NOT <0? .PREP>>
		    <NOT ,P-END-ON-PREP>>
	       <COND (.SP? <TELL " ">)>
	       <SET WRD <PREP-FIND .PREP>>
	       <COND ;(<==? .WRD ,W?AGAINST> <TELL "against">)
		     ;(<==? .WRD ,W?THROUGH> <TELL "through">)
		     (T <PRINTB .WRD>)>
	       <COND (<AND <EQUAL?<GET <GET ,P-ITBL ,P-VERBN> 0>,W?SIT ,W?LIE>
			   <==? ,W?DOWN .WRD>>
		      <TELL " on">)>
	       <COND (<AND <==? ,W?GET <GET <GET ,P-ITBL ,P-VERBN> 0>>
			   <==? ,W?OUT .WRD>>
		      <TELL " of">)>
	       <RTRUE>)>>    

%<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
'<ROUTINE CLAUSE-COPY (SRC DEST SRCBEG SRCEND DESTBEG DESTEND
		      "OPTIONAL" (INSRT <>) "AUX" BEG END)
	<SET BEG <GET .SRC .SRCBEG>>
	<SET END <GET .SRC .SRCEND>>
	<PUT .DEST .DESTBEG
	     <REST ,P-OCLAUSE
		   <+ <* <GET ,P-OCLAUSE ,P-MATCHLEN> ,P-LEXELEN> 2>>>
	<REPEAT ()
	 <COND (<==? .BEG .END>
		<PUT .DEST .DESTEND
		     <REST ,P-OCLAUSE
			   <+ 2 <* <GET ,P-OCLAUSE ,P-MATCHLEN> ,P-LEXELEN>>>>
		<RETURN>)
	       (T
		<COND (<AND .INSRT <==? ,P-ANAM <GET .BEG 0>>>
		       <CLAUSE-ADD .INSRT>)>
		<CLAUSE-ADD <GET .BEG 0>>)>
	 <SET BEG <REST .BEG ,P-WORDLEN>>>>
)(T
"pointers used by CLAUSE-COPY (source/destination beginning/end pointers)"
'(
<CONSTANT CC-SBPTR 0>
<CONSTANT CC-SEPTR 1>
<CONSTANT CC-DBPTR 2>
<CONSTANT CC-DEPTR 3>
<GLOBAL P-CCTBL <TABLE 0 0 0 0>>
<ROUTINE CLAUSE-COPY (SRC DEST "OPTIONAL" (INSRT <>) "AUX" BEG END)
	<SET BEG <GET .SRC <GET ,P-CCTBL ,CC-SBPTR>>>
	<SET END <GET .SRC <GET ,P-CCTBL ,CC-SEPTR>>>
	<PUT .DEST
	     <GET ,P-CCTBL ,CC-DBPTR>
	     <REST ,P-OCLAUSE
		   <+ <* <GET ,P-OCLAUSE ,P-MATCHLEN> ,P-LEXELEN> 2>>>
	<REPEAT ()
		<COND (<==? .BEG .END>
		       <PUT .DEST
			    <GET ,P-CCTBL ,CC-DEPTR>
			    <REST ,P-OCLAUSE
				  <+ <* <GET ,P-OCLAUSE ,P-MATCHLEN> ,P-LEXELEN>
				     2>>>
		       <RETURN>)
		      (T
		       <COND (<AND .INSRT <==? ,P-ANAM <GET .BEG 0>>>
			      <CLAUSE-ADD .INSRT>)>
		       <CLAUSE-ADD <GET .BEG 0>>)>
		<SET BEG <REST .BEG ,P-WORDLEN>>>>
))>

<ROUTINE CLAUSE-ADD (WRD "AUX" PTR) 
	;#DECL ((WRD) TABLE (PTR) FIX)
	<SET PTR <+ <GET ,P-OCLAUSE ,P-MATCHLEN> 2>>
	<PUT ,P-OCLAUSE <- .PTR 1> .WRD>
	<PUT ,P-OCLAUSE .PTR 0>
	<PUT ,P-OCLAUSE ,P-MATCHLEN .PTR>>   
 
<ROUTINE PREP-FIND (PREP "AUX" (CNT 0) SIZE) 
	;#DECL ((PREP CNT SIZE) FIX)
	<SET SIZE <* <GET ,PREPOSITIONS 0> 2>>
	<REPEAT ()
		<COND (<IGRTR? CNT .SIZE> <RFALSE>)
		      (<==? <GET ,PREPOSITIONS .CNT> .PREP>
		       <RETURN <GET ,PREPOSITIONS <- .CNT 1>>>)>>>  
 
<ROUTINE SYNTAX-FOUND (SYN) 
	;#DECL ((SYN) <PRIMTYPE VECTOR>)
	<SETG P-SYNTAX .SYN>
	<SETG PRSA <GETB .SYN ,P-SACTION>>>   
 
<GLOBAL P-GWIMBIT 0>
 
<ROUTINE GWIM (GBIT LBIT PREP "AUX" OBJ ;WPREP)
	;#DECL ((GBIT LBIT) FIX (OBJ) OBJECT)
	<COND (<==? .GBIT ,RMUNGBIT>
	       <RETURN ,ROOMS>)>
	<SETG P-GWIMBIT .GBIT>
	<SETG P-SLOCBITS .LBIT>
	<PUT ,P-MERGE ,P-MATCHLEN 0>
	<COND (<GET-OBJECT ,P-MERGE <>>
	       <SETG P-GWIMBIT 0>
	       <COND (<==? <GET ,P-MERGE ,P-MATCHLEN> 1>
		      <SET OBJ <GET ,P-MERGE 1>>
		      <TELL "(">
		      <COND (<PREP-PRINT .PREP <>>
			     <THE? .OBJ>
			     <TELL " ">)>
		      <TELL D .OBJ ")" CR>
		      .OBJ)>)
	      (T <SETG P-GWIMBIT 0> <RFALSE>)>>   

<ROUTINE SNARF-OBJECTS ("AUX" PTR) 
	;#DECL ((PTR) <OR FIX <PRIMTYPE VECTOR>>)
	<COND (<NOT <==? <SET PTR <GET ,P-ITBL ,P-NC1>> 0>>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC1>>
	       <OR <SNARFEM .PTR <GET ,P-ITBL ,P-NC1L> ,P-PRSO> <RFALSE>>
	       <OR <0? <GET ,P-BUTS ,P-MATCHLEN>>
		   <SETG P-PRSO <BUT-MERGE ,P-PRSO>>>)>
	<COND (<NOT <==? <SET PTR <GET ,P-ITBL ,P-NC2>> 0>>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC2>>
	       <OR <SNARFEM .PTR <GET ,P-ITBL ,P-NC2L> ,P-PRSI> <RFALSE>>
	       <COND (<NOT <0? <GET ,P-BUTS ,P-MATCHLEN>>>
		      <COND (<==? <GET ,P-PRSI ,P-MATCHLEN> 1>
			     <SETG P-PRSO <BUT-MERGE ,P-PRSO>>)
			    (T <SETG P-PRSI <BUT-MERGE ,P-PRSI>>)>)>)>
	<RTRUE>>  

<ROUTINE BUT-MERGE (TBL "AUX" LEN BUTLEN (CNT 1) (MATCHES 0) OBJ NTBL) 
	;#DECL ((TBL NTBL) TABLE (LEN BUTLEN MATCHES) FIX (OBJ) OBJECT)
	<SET LEN <GET .TBL ,P-MATCHLEN>>
	<PUT ,P-MERGE ,P-MATCHLEN 0>
	<REPEAT ()
		<COND (<DLESS? LEN 0> <RETURN>)
		      (<ZMEMQ <SET OBJ <GET .TBL .CNT>> ,P-BUTS>)
		      (T
		       <PUT ,P-MERGE <+ .MATCHES 1> .OBJ>
		       <SET MATCHES <+ .MATCHES 1>>)>
		<SET CNT <+ .CNT 1>>>
	<PUT ,P-MERGE ,P-MATCHLEN .MATCHES>
	<SET NTBL ,P-MERGE>
	<SETG P-MERGE .TBL>
	.NTBL>    
 
<GLOBAL P-NAM <>>
<GLOBAL P-XNAM <>>

<GLOBAL P-ADJ <>>
<GLOBAL P-XADJ <>>

%<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>)
       (T
'(<GLOBAL P-ADJN <>>
  <GLOBAL P-XADJN <>>))>

<GLOBAL P-PRSO <ITABLE NONE 25>>   
 
<GLOBAL P-PRSI <ITABLE NONE 25>>   
 
<GLOBAL P-BUTS <ITABLE NONE 25>>   
 
<GLOBAL P-MERGE <ITABLE NONE 25>>  
 
<GLOBAL P-OCLAUSE <ITABLE NONE 25>>
 
<CONSTANT P-MATCHLEN 0>    
 
<GLOBAL P-GETFLAGS 0>    
 
<CONSTANT P-ALL 1>  
 
<CONSTANT P-ONE 2>  
 
<CONSTANT P-INHIBIT 4>   

"<GLOBAL P-CSPTR <>>
<GLOBAL P-CEPTR <>>"
<GLOBAL P-AND <>>

<ROUTINE SNARFEM (PTR EPTR TBL
		  "AUX" (BUT <>) LEN WV WRD NW (WAS-ALL <>) ONEOBJ) 
   ;"Next SETG 6/21/84 for WHICH retrofix"
   <SETG P-AND <>>
   <COND (<EQUAL? ,P-GETFLAGS ,P-ALL>
	  <SET WAS-ALL T>)>
   <SETG P-GETFLAGS 0>
   ;"<SETG P-CSPTR .PTR>
   <SETG P-CEPTR .EPTR>"
   <PUT ,P-BUTS ,P-MATCHLEN 0>
   <PUT .TBL ,P-MATCHLEN 0>
   <SET WRD <GET .PTR 0>>
   <REPEAT ()
	   <COND (<==? .PTR .EPTR>
		  <SET WV <GET-OBJECT <OR .BUT .TBL>>>
		  <COND (.WAS-ALL <SETG P-GETFLAGS ,P-ALL>)>
		  <RETURN .WV>)
		 (T
		  <SET NW <GET .PTR ,P-LEXELEN>>
		  <COND (<EQUAL? .WRD ,W?ALL ,W?BOTH>
			 <SETG P-GETFLAGS ,P-ALL>
			 <COND (<==? .NW ,W?OF>
				<SET PTR <REST .PTR ,P-WORDLEN>>)>)
			(<EQUAL? .WRD ,W?BUT ,W?EXCEPT>
			 <OR <GET-OBJECT <OR .BUT .TBL>> <RFALSE>>
			 <SET BUT ,P-BUTS>
			 <PUT .BUT ,P-MATCHLEN 0>)
			(<BUZZER-WORD? .WRD>
			 <RFALSE>)
			(<EQUAL? .WRD ,W?A ,W?ONE>
			 <COND (<NOT ,P-ADJ>
				<SETG P-GETFLAGS ,P-ONE>
				<COND (<==? .NW ,W?OF>
				       <SET PTR <REST .PTR ,P-WORDLEN>>)>)
			       (T
				<SETG P-NAM .ONEOBJ>
				<OR <GET-OBJECT <OR .BUT .TBL>> <RFALSE>>
				<AND <0? .NW> <RTRUE>>)>)
			(<AND <EQUAL? .WRD ,W?AND ,W?COMMA>
			      <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
			 ;"Next SETG 6/21/84 for WHICH retrofix"
			 <SETG P-AND T>
			 <OR <GET-OBJECT <OR .BUT .TBL>> <RFALSE>>
			 T)
			(<WT? .WRD ,PS?BUZZ-WORD>)
			(<EQUAL? .WRD ,W?AND ,W?COMMA>)
			(<==? .WRD ,W?OF>
			 <COND (<0? ,P-GETFLAGS>
				<SETG P-GETFLAGS ,P-INHIBIT>)>)
			%<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
				'(<AND <WT? .WRD ,PS?ADJECTIVE>
				       <NOT ,P-ADJ>>
				  <SETG P-ADJ .WRD>))
			       (T
				'(<AND <SET WV <WT? .WRD ,PS?ADJECTIVE
							 ,P1?ADJECTIVE>>
				       <NOT ,P-ADJ>>
				  <SETG P-ADJ .WV>
				  <SETG P-ADJN .WRD>))>
			(<WT? .WRD ,PS?OBJECT ;,P1?OBJECT>
			 <SETG P-NAM .WRD>
			 <SET ONEOBJ .WRD>)>)>
	   <COND (<NOT <==? .PTR .EPTR>>
		  <SET PTR <REST .PTR ,P-WORDLEN>>
		  <SET WRD .NW>)>>>
 
<CONSTANT SH 128>
<CONSTANT SC 64>
<CONSTANT SIR 32>
<CONSTANT SOG 16>
<CONSTANT STAKE 8>
<CONSTANT SMANY 4>
<CONSTANT SHAVE 2>  

<ROUTINE GET-OBJECT (TBL
		    "OPTIONAL" (VRB T)
		    "AUX" BTS LEN XBITS TLEN (GCHECK <>) (OLEN 0) OBJ ADJ)
	;#DECL ((TBL) TABLE (XBITS BTS TLEN LEN) FIX (GWIM) <OR FALSE FIX>
	       (VRB GCHECK) <OR ATOM FALSE>)
 <SET XBITS ,P-SLOCBITS>
 <SET TLEN <GET .TBL ,P-MATCHLEN>>
 ;<COND (,DEBUG <TELL "[GETOBJ: TLEN=" N .TLEN "]" CR>)>
 <COND (<BTST ,P-GETFLAGS ,P-INHIBIT> <RTRUE>)>
 <SET ADJ %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
		  ',P-ADJ)
		 (T
		  ',P-ADJN)>>
 <COND (<AND <NOT ,P-NAM> ,P-ADJ>
	<COND (<WT? %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
			    ',P-ADJ)
			   (T ',P-ADJN)>
		    ,PS?OBJECT>
	       <SETG P-NAM %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
				   ',P-ADJ)
				  (T ',P-ADJN)>>
	       <SETG P-ADJ <>>)
	      (<SET BTS <WT? %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
				     ',P-ADJ)
				    (T ',P-ADJN)>
			     ,PS?DIRECTION ,P1?DIRECTION>>
	       <SETG P-ADJ <>>
	       <PUT .TBL ,P-MATCHLEN 1>
	       <PUT .TBL 1 ,INTDIR>
	       <SETG P-DIRECTION .BTS>
	       <RTRUE>)>)>
 <COND (<AND <NOT ,P-NAM>
	     <NOT ,P-ADJ>
	     <NOT <==? ,P-GETFLAGS ,P-ALL>>
	     <0? ,P-GWIMBIT>>
	<COND (.VRB <MISSING-NOUN .ADJ>)>
	<RFALSE>)>
 <COND (<OR <NOT <==? ,P-GETFLAGS ,P-ALL>> <0? ,P-SLOCBITS>>
	<SETG P-SLOCBITS -1>)>
 ;<SETG P-TABLE .TBL>
 <PROG ()
  ;<COND (,DEBUG <TELL "[GETOBJ: GCHECK=" N .GCHECK "]" CR>)>
  <COND (.GCHECK
	 ;<COND (,DEBUG <TELL "[GETOBJ: calling GLOBAL-CHECK]" CR>)>
	 <GLOBAL-CHECK .TBL>)
	(T
	 <COND (,LIT
		<FCLEAR ,PLAYER ,TRANSBIT>
		<DO-SL ,HERE ,SOG ,SIR .TBL>
		<FSET ,PLAYER ,TRANSBIT>)>
	 <DO-SL ,PLAYER ,SH ,SC .TBL>)>
  <SET LEN <- <GET .TBL ,P-MATCHLEN> .TLEN>>
  ;<COND (,DEBUG <TELL "[GETOBJ: LEN=" N .LEN "]" CR>)>
  <COND (<BTST ,P-GETFLAGS ,P-ALL>)
	(<AND <BTST ,P-GETFLAGS ,P-ONE>
	      <NOT <0? .LEN>>>
	 <COND (<NOT <==? .LEN 1>>
		<PUT .TBL 1 <GET .TBL <RANDOM .LEN>>>
		<TELL "(How about" THE <GET .TBL 1> "?)" CR>)>
	 <PUT .TBL ,P-MATCHLEN 1>)
	(<OR <G? .LEN 1>
	     <AND <0? .LEN> <NOT <==? ,P-SLOCBITS -1>>>>
	 <COND (<==? ,P-SLOCBITS -1>
		<SETG P-SLOCBITS .XBITS>
		<SET OLEN .LEN>
		<PUT .TBL ,P-MATCHLEN <- <GET .TBL ,P-MATCHLEN> .LEN>>
		<AGAIN>)
	       (T
		<COND (<0? .LEN> <SET LEN .OLEN>)>
		<COND (<AND ,P-NAM
			    ;<REMOTE-VERB?>
			    <SET OBJ <GET .TBL <+ .TLEN 1>>>
			    <SET OBJ <APPLY <GETP .OBJ ,P?GENERIC> .TBL>>>
		       <COND (<==? .OBJ ,NOT-HERE-OBJECT>
			      <RFALSE>)>
		       <PUT .TBL 1 .OBJ>
		       <PUT .TBL ,P-MATCHLEN 1>
		       <SETG P-NAM <>>
		       %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
			       '<SETG P-ADJ <>>)
			      (T
			       '<PROG ()
				      <SETG P-ADJ <>>
				      <SETG P-ADJN <>>>)>
		       <RTRUE>)
		      (<AND .VRB ;".VRB added 8/14/84 by JW"
			    <NOT <==? ,WINNER ,PLAYER>>>
		       <CANT-ORPHAN>
		       <RFALSE>)
		      (<AND .VRB ,P-NAM>
		       <WHICH-PRINT .TLEN .LEN .TBL>
		       <SETG P-ACLAUSE
			     <COND (<==? .TBL ,P-PRSO> ,P-NC1)
				   (T ,P-NC2)>>
		       <SETG P-AADJ ,P-ADJ>
		       <SETG P-ANAM ,P-NAM>
		       <ORPHAN <> <>>
		       <SETG P-OFLAG T>)
		      (.VRB
		       <MISSING-NOUN .ADJ>)>
		<SETG P-NAM <>>
		<SETG P-ADJ <>>
		<RFALSE>)>)
	(<AND <0? .LEN> .GCHECK>
	 <COND (.VRB
		<SETG P-SLOCBITS .XBITS>
		<COND (<OR ,LIT <SPEAKING-VERB?>>
		       <OBJ-FOUND ,NOT-HERE-OBJECT .TBL>
		       <SETG P-XNAM ,P-NAM>
		       <SETG P-NAM <>>
		       %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
			       '<PROG ()
				      <SETG P-XADJ ,P-ADJ>
				      <SETG P-ADJ <>>>)
			      (T
			       '<PROG ()
				      <SETG P-XADJ ,P-ADJ>
				      <SETG P-XADJN ,P-ADJN>
				      <SETG P-ADJ <>>
				      <SETG P-ADJN <>>>)>
		       <RTRUE>)
		      (T <TOO-DARK>)>)>
	 <SETG P-NAM <>>
	 <SETG P-ADJ <>>
	 <RFALSE>)
	(<0? .LEN>
	 <SET GCHECK T>
	 ;<COND (,DEBUG <TELL "[GETOBJ: GCHECK set to " N .GCHECK "]" CR>)>
	 <AGAIN>)>
  <COND (<AND ,P-ADJ <NOT ,P-NAM>>
	 <TELL ,I-ASSUME THE <GET .TBL <+ .TLEN ;0 1>> ".)" CR>)>
  <SETG P-SLOCBITS .XBITS>
  <SETG P-NAM <>>
  <SETG P-ADJ <>>
  <RTRUE>>>

<ROUTINE SPEAKING-VERB? ("OPTIONAL" (V <>))
	<COND (<NOT .V> <SET V ,PRSA>)>
	<COND (<EQUAL? .V ,V?$CALL ,V?ASK ,V?ASK-ABOUT>		<RTRUE>)
	      (<EQUAL? .V ,V?ASK-FOR ,V?GOODBYE ,V?HELLO>	<RTRUE>)
	      (<EQUAL? .V ,V?NO ,V?TELL ,V?TELL-ABOUT>		<RTRUE>)
	      (<EQUAL? .V ,V?YES ,V?TALK-ABOUT ,V?ANSWER>	<RTRUE>)
	      (<EQUAL? .V ,V?ASK-CONTEXT-ABOUT ,V?ASK-CONTEXT-FOR ,V?REPLY>
								<RTRUE>)>>

<ROUTINE CANT-ORPHAN ()
	 <TELL "(Please try saying that another way.)" CR>
	 <RFALSE>>

<ROUTINE MISSING-NOUN (ADJ)
	<COND ;(<EQUAL? .ADJ ,W?NUMBER>
	       <TELL "(Please use units with numbers.)" CR>)
	      (T <TELL
"(I couldn't find enough nouns in that sentence!)" CR>)>>

<ROUTINE MISSING-VERB ()
	<TELL "(I couldn't find a verb in that sentence!)" CR>>

<ROUTINE MOBY-FIND (TBL "AUX" (OBJ 1) LEN FOO)
  <SETG P-NAM ,P-XNAM>
  <SETG P-ADJ ,P-XADJ>
  <PUT .TBL ,P-MATCHLEN 0>
  <COND (<NOT <ZERO? <GETB 0 18>>>	;"ZIP case"
	 <REPEAT ()
		 <COND (<AND <SET FOO <META-LOC .OBJ T>>
			     <SET FOO <THIS-IT? .OBJ>>>
			<SET FOO <OBJ-FOUND .OBJ .TBL>>)>
		 <COND (<IGRTR? OBJ ,LAST-OBJECT>
			<RETURN>)>>
	 <SET LEN <GET .TBL ,P-MATCHLEN>>
	 <COND (<EQUAL? .LEN 1>
		<SETG P-MOBY-FOUND <GET .TBL 1>>)>
	 .LEN)
	(T		;"ZIL case"
	 ;<SETG P-MOBY-FLAG T>
	 ;<SETG P-TABLE .TBL>
	 <SETG P-SLOCBITS -1>
	 <SETG P-NAM ,P-XNAM>
	 <SETG P-ADJ ,P-XADJ>
	 <PUT .TBL ,P-MATCHLEN 0>
	 <SET FOO <FIRST? ,ROOMS>>
	 <REPEAT ()
		 <COND (<NOT .FOO> <RETURN>)
		       (T
			<SEARCH-LIST .FOO .TBL ,P-SRCALL T>
			<SET FOO <NEXT? .FOO>>)>>
	 <COND (T ;<EQUAL? <SET LEN <GET .TBL ,P-MATCHLEN>> 0>
		<DO-SL ,LOCAL-GLOBALS 1 1 .TBL T>)>
	 <COND (T ;<EQUAL? <SET LEN <GET .TBL ,P-MATCHLEN>> 0>
		<SEARCH-LIST ,ROOMS .TBL ,P-SRCTOP T>
		;<DO-SL ,ROOMS 1 1>)>
	 <COND (<EQUAL? <SET LEN <GET .TBL ,P-MATCHLEN>> 1>
		<SETG P-MOBY-FOUND <GET .TBL 1>>)>
	 ;<SETG P-MOBY-FLAG <>>
	 <SETG P-NAM <>>
	 <SETG P-ADJ <>>
	 .LEN)>>

<GLOBAL P-MOBY-FOUND <>>

<ROUTINE WHICH-PRINT (TLEN LEN TBL "AUX" OBJ RLEN)
	 <SET RLEN .LEN>
	 <TELL "(Which">
         <COND (<OR ,P-OFLAG ,P-MERGED ,P-AND> <TELL " "> <PRINTB ,P-NAM>)
	       (<==? .TBL ,P-PRSO>
		<CLAUSE-PRINT ,P-NC1 ,P-NC1L <>>)
	       (T <CLAUSE-PRINT ,P-NC2 ,P-NC2L <>>)>
	 <TELL " do you mean,">
	 <REPEAT ()
		 <SET TLEN <+ .TLEN 1>>
		 <SET OBJ <GET .TBL .TLEN>>
		 <TELL THE .OBJ>
		 <COND (<==? .LEN 2>
		        <COND (<NOT <==? .RLEN 2>> <TELL ",">)>
		        <TELL " or">)
		       (<G? .LEN 2> <TELL ",">)>
		 <COND (<L? <SET LEN <- .LEN 1>> 1>
		        <TELL "?)" CR>
		        <RETURN>)>>>


<ROUTINE GLOBAL-CHECK (TBL "AUX" LEN RMG RMGL (CNT 0) OBJ OBITS FOO) 
	;#DECL((TBL) TABLE (RMG) <OR FALSE TABLE> (RMGL CNT) FIX (OBJ) OBJECT)
	<SET LEN <GET .TBL ,P-MATCHLEN>>
	<SET OBITS ,P-SLOCBITS>
	<COND (<SET RMG <GETPT ,HERE ,P?GLOBAL>>
	       <SET RMGL <RMGL-SIZE .RMG>>
	       ;<COND (,DEBUG <TELL "[GLBCHK: (LG) RMGL=" N .RMGL "]" CR>)>
	       <REPEAT ()
		       <SET OBJ <GET/B .RMG .CNT>>
		       <COND (<FIRST? .OBJ>
			      <SEARCH-LIST .OBJ .TBL ,P-SRCALL>)>
		       <COND (<THIS-IT? .OBJ>
			      <OBJ-FOUND .OBJ .TBL>)>
		       <COND (<IGRTR? CNT .RMGL> <RETURN>)>>)>
	;<COND (<SET RMG <GETPT ,HERE ,P?PSEUDO>>
	       <SET RMGL <- </ <PTSIZE .RMG> 4> 1>>
	       <SET CNT 0>
	       ;<COND (,DEBUG <TELL "[GLBCHK: (PS) RMGL=" N .RMGL "]" CR>)>
	       <REPEAT ()
		       <COND (<==? ,P-NAM <GET .RMG <* .CNT 2>>>
			      <SETG LAST-PSEUDO-LOC ,HERE>
			      <PUTP ,PSEUDO-OBJECT
				    ,P?ACTION
				    <GET .RMG <+ <* .CNT 2> 1>>>
			      <SET FOO
				   <BACK <GETPT ,PSEUDO-OBJECT ,P?ACTION> 5>>
			      <PUT .FOO 0 <GET ,P-NAM 0>>
			      <PUT .FOO 1 <GET ,P-NAM 1>>
			      <OBJ-FOUND ,PSEUDO-OBJECT .TBL>
			      <RETURN>)
		             (<IGRTR? CNT .RMGL> <RETURN>)>>)>
	<COND (<==? <GET .TBL ,P-MATCHLEN> .LEN>
	       <SETG P-SLOCBITS -1>
	       ;<SETG P-TABLE .TBL>
	       <DO-SL ,GLOBAL-OBJECTS 1 1 .TBL>
	       <SETG P-SLOCBITS .OBITS>
	       <COND (<0? <GET .TBL ,P-MATCHLEN>>
		      <COND (<VERB? EXAMINE FIND FOLLOW LEAVE LOOK-INSIDE
				    SEARCH SEARCH-FOR SMELL THROUGH WALK-TO>
			     <DO-SL ,ROOMS 1 1 .TBL>)>)>)>>

<ROUTINE DO-SL (OBJ BIT1 BIT2 TBL "OPTIONAL" (MOBY-FLAG <>) "AUX" BTS)
	<COND (<BTST ,P-SLOCBITS <+ .BIT1 .BIT2>>
	       <SEARCH-LIST .OBJ .TBL ,P-SRCALL .MOBY-FLAG>)
	      (T
	       <COND (<BTST ,P-SLOCBITS .BIT1>
		      <SEARCH-LIST .OBJ .TBL ,P-SRCTOP .MOBY-FLAG>)
		     (<BTST ,P-SLOCBITS .BIT2>
		      <SEARCH-LIST .OBJ .TBL ,P-SRCBOT .MOBY-FLAG>)
		     (T <RTRUE>)>)>>

;<ROUTINE DO-SL (OBJ BIT1 BIT2 "AUX" BITS) 
	<COND (<BTST ,P-SLOCBITS <+ .BIT1 .BIT2>>
	       <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCALL>)
	      (T
	       <COND (<BTST ,P-SLOCBITS .BIT1>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCTOP>)
		     (<BTST ,P-SLOCBITS .BIT2>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCBOT>)
		     (T <RTRUE>)>)>>  

<CONSTANT P-SRCBOT 2>
<CONSTANT P-SRCTOP 0>
<CONSTANT P-SRCALL 1>    

<ROUTINE SEARCH-LIST (OBJ TBL LVL "OPTIONAL" (MOBY-FLAG <>))
	;#DECL ((OBJ NOBJ) <OR FALSE OBJECT> (TBL) TABLE (LVL) FIX)
 ;<COND (<EQUAL? .OBJ ,GLOBAL-OBJECTS> <SET GLOB T>) (T <SET GLOB <>>)>
 <COND (<SET OBJ <FIRST? .OBJ>>
	<REPEAT ()
		;<COND (<AND .GLOB ,DEBUG>
		       <TELL "[SRCLST: OBJ=" D .OBJ "]" CR>)>
		<COND (<AND <NOT <==? .LVL ,P-SRCBOT>>
			    <GETPT .OBJ ,P?SYNONYM>
			    <THIS-IT? .OBJ>>
		       <OBJ-FOUND .OBJ .TBL>)>
		<COND (<AND <OR <NOT <==? .LVL ,P-SRCTOP>>
				<FSET? .OBJ ,SEARCHBIT>
				<FSET? .OBJ ,SURFACEBIT>>
			    <FIRST? .OBJ>
			    <OR .MOBY-FLAG <SEE-INSIDE? .OBJ>>
			    ;<OR <FSET? .OBJ ,OPENBIT>
				<FSET? .OBJ ,TRANSBIT>
				.MOBY-FLAG
				<AND <FSET? .OBJ ,PERSONBIT>
				     <NOT <==? .OBJ ,PLAYER>>>>
			    ;<NOT <EQUAL? .OBJ ,PLAYER ,LOCAL-GLOBALS>>>
		       <SEARCH-LIST .OBJ .TBL
				    <COND (<FSET? .OBJ ,SURFACEBIT> ,P-SRCALL)
					  (<FSET? .OBJ ,SEARCHBIT> ,P-SRCALL)
					  (T ,P-SRCTOP)>
				    .MOBY-FLAG>)>
		<COND (<SET OBJ <NEXT? .OBJ>>) (T <RETURN>)>>)>>

<ROUTINE THIS-IT? (OBJ "AUX" SYNS) 
 <COND (<FSET? .OBJ ,INVISIBLE>
	<RFALSE>)
       (<AND ,P-NAM
	     <OR <NOT <SET SYNS <GETPT .OBJ ,P?SYNONYM>>>
		 <NOT <ZMEMQ ,P-NAM .SYNS <- </ <PTSIZE .SYNS> 2> 1>>>>>
	<RFALSE>)
       (<AND ,P-ADJ
	     <OR <NOT <SET SYNS <GETPT .OBJ ,P?ADJECTIVE>>>
		 <NOT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
			      '<ZMEMQ  ,P-ADJ .SYNS <RMGL-SIZE .SYNS>>)
			     (T
			      '<ZMEMQB ,P-ADJ .SYNS <RMGL-SIZE .SYNS>>)>>>>
	<RFALSE>)
       (<AND <NOT <0? ,P-GWIMBIT>> <NOT <FSET? .OBJ ,P-GWIMBIT>>>
	<RFALSE>)>
 <RTRUE>>

<ROUTINE OBJ-FOUND (OBJ TBL "AUX" PTR) 
	;#DECL ((OBJ) OBJECT (TBL) TABLE (PTR) FIX)
	<SET PTR <GET .TBL ,P-MATCHLEN>>
	<PUT .TBL <+ .PTR 1> .OBJ>
	<PUT .TBL ,P-MATCHLEN <+ .PTR 1>>> 
 
<ROUTINE TAKE-CHECK () 
	<AND <ITAKE-CHECK ,P-PRSO <GETB ,P-SYNTAX ,P-SLOC1>>
	     <ITAKE-CHECK ,P-PRSI <GETB ,P-SYNTAX ,P-SLOC2>>>> 

<ROUTINE ITAKE-CHECK (TBL BITS "AUX" PTR OBJ TAKEN)
	 ;#DECL ((TBL) TABLE (BITS PTR) FIX (OBJ) OBJECT
		(TAKEN) <OR FALSE FIX ATOM>)
 <COND (<AND <SET PTR <GET .TBL ,P-MATCHLEN>>
	     <OR <BTST .BITS ,SHAVE>
		 <BTST .BITS ,STAKE>>
	     ;<EQUAL? ,WINNER ,PLAYER>>
	<REPEAT ()
	 <COND (<L? <SET PTR <- .PTR 1>> 0> <RETURN>)>
	 <SET OBJ <GET .TBL <+ .PTR 1>>>
	 <COND (<==? .OBJ ,IT>
		<COND (<NOT <ACCESSIBLE? ,P-IT-OBJECT>>
		       <MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-IT-OBJECT>)>)
	       (<==? .OBJ ,HER>
		<COND (<NOT <ACCESSIBLE? ,P-HER-OBJECT>>
		       <MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-HER-OBJECT>)>)
	       (<==? .OBJ ,HIM>
		<COND (<NOT <ACCESSIBLE? ,P-HIM-OBJECT>>
		       <MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-HIM-OBJECT>)>)
	       (<==? .OBJ ,THEM>
		<COND (<NOT <ACCESSIBLE? ,P-THEM-OBJECT>>
		       <MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-THEM-OBJECT>)>)>
	 <COND (<AND <NOT <HELD? .OBJ ,WINNER>> ;<NOT <==? .OBJ ,HANDS>>>
		<SETG PRSO .OBJ>
		<COND (<FSET? .OBJ ,TRYTAKEBIT>
		       <SET TAKEN T>)
		      (<NOT <==? ,WINNER ,PLAYER>>
		       <SET TAKEN <>>)
		      (<AND <BTST .BITS ,STAKE>
			    <==? <ITAKE <>> T>>
		       <SET TAKEN <>>)
		      (T <SET TAKEN T>)>
		<COND (<AND .TAKEN <BTST .BITS ,SHAVE>>
		       <TELL "(">
		       <TELL CHE ,WINNER do "n't seem to be holding">
		       <COND (<L? 1 <GET .TBL ,P-MATCHLEN>>
			      <TELL ;" all" " those things">)
			     (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
			      <TELL " that">)
			     (T
			      <TELL THE .OBJ>
			      <THIS-IS-IT .OBJ>)>
		       <TELL "!)" CR>
		       <RFALSE>)
		      (<AND <NOT .TAKEN> <==? ,WINNER ,PLAYER>>
		       <TELL "(taking" HIM .OBJ ;,PRSO>
		       <COND (,ITAKE-LOC
			      <TELL " from" HIM ,ITAKE-LOC>)>
		       <TELL " first)" CR>)>)>>)
       (T)>>

<ROUTINE MANY-CHECK ("AUX" (LOSS <>) TMP) 
	;#DECL ((LOSS) <OR FALSE FIX>)
	<COND (<AND <G? <GET ,P-PRSO ,P-MATCHLEN> 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC1> ,SMANY>>>
	       <SET LOSS 1>)
	      (<AND <G? <GET ,P-PRSI ,P-MATCHLEN> 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC2> ,SMANY>>>
	       <SET LOSS 2>)>
	<COND (.LOSS
	       <COND ;(<NOT <EQUAL? ,WINNER ,PLAYER>>
		      <TELL "\"Please, to me simple English speak.\"" CR>
		      <RFALSE>)
		     (T
		      <TELL "(You can't use more than one ">
		      <COND (<==? .LOSS 2> <TELL "in">)>
		      <TELL "direct object with \"">
		      <SET TMP <GET ,P-ITBL ,P-VERBN>>
		      <COND (<0? .TMP> <TELL "tell">)
			    (<OR ,P-OFLAG ,P-MERGED>
			     <PRINTB <GET .TMP 0>>)
			    (T
			     <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>
		      <TELL "\"!)" CR>
		      <RFALSE>)>)
	      (T)>>

<ROUTINE ZMEMQ (ITM TBL "OPTIONAL" (SIZE -1) "AUX" (CNT 1)) 
	<COND (<NOT .TBL> <RFALSE>)>
	<COND (<NOT <L? .SIZE 0>> <SET CNT 0>)
	      (ELSE <SET SIZE <GET .TBL 0>>)>
	<REPEAT ()
		<COND (<==? .ITM <GET .TBL .CNT>>
		       <COND (<0? .CNT> <RTRUE>)
			     (T <RETURN .CNT>)>)
		      (<IGRTR? CNT .SIZE> <RFALSE>)>>>

<ROUTINE ZMEMZ (ITM TBL "AUX" (CNT 0)) 
	<COND (<NOT .TBL> <RFALSE>)>
	<REPEAT ()
		<COND (<ZERO? <GET .TBL .CNT>>
		       <RFALSE>)
		      (<==? .ITM <GET .TBL .CNT>>
		       <COND (<0? .CNT> <RTRUE>)
			     (T <RETURN .CNT>)>)
		      (T <INC CNT>)>>>

;<ROUTINE ZMEMQB (ITM TBL SIZE "AUX" (CNT 0))
	<REPEAT ()
		<COND (<==? .ITM <GETB .TBL .CNT>>
		       <COND (<0? .CNT> <RTRUE>)
			     (T <RETURN .CNT>)>)
		      (<IGRTR? CNT .SIZE> <RFALSE>)>>>  

<GLOBAL ALWAYS-LIT <>>
 
<ROUTINE LIT? (RM "OPTIONAL" (RMBIT T) "AUX" OHERE (LIT <>))
	<COND (<AND ,ALWAYS-LIT <EQUAL? ,WINNER ,PLAYER>>
	       <RTRUE>)>
	<SETG P-GWIMBIT ,ONBIT>
	<SET OHERE ,HERE>
	<SETG HERE .RM>
	<COND (<AND .RMBIT <FSET? .RM ,ONBIT>>
	       <SET LIT T>)
	      (T
	       <PUT ,P-MERGE ,P-MATCHLEN 0>
	       ;<SETG P-TABLE ,P-MERGE>
	       <SETG P-SLOCBITS -1>
	       <COND (<==? .OHERE .RM>
		      <DO-SL ,WINNER 1 1 ,P-MERGE>
		      <COND (<AND <NOT <EQUAL? ,WINNER ,PLAYER>>
				  <IN? ,PLAYER .RM>>
			     <DO-SL ,PLAYER 1 1 ,P-MERGE>)>)>
	       <DO-SL .RM 1 1 ,P-MERGE>
	       <COND (<G? <GET ,P-MERGE ,P-MATCHLEN> 0> <SET LIT T>)>)>
	<SETG HERE .OHERE>
	<SETG P-GWIMBIT 0>
	.LIT>

;<ROUTINE VPRINT ("AUX" TMP)
	 <SET TMP <GET ,P-OTBL ,P-VERBN>>
	 <COND (<==? .TMP 0> <TELL "tell">)
	       (<0? <GETB ,P-VTBL 2>>
		<PRINTB <GET .TMP 0>>)
	       (T
		<WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>>

<ROUTINE NOT-HERE (OBJ)
	 <SETG CLOCK-WAIT T>
	 <TELL "(You can't see ">
	 <COND (<NOT <FSET? .OBJ ,NARTICLEBIT>> <TELL "any ">)>
	 <THIS-IS-IT .OBJ>
	 <COND (<AND ,P-DOLLAR-FLAG <EQUAL? .OBJ ,INTNUM>>
		<TELL "money">)
	       (T <PRINTD .OBJ>)>
	 <TELL " here.)" CR>>

<OBJECT HER
	(LOC GLOBAL-OBJECTS)
	(SYNONYM SHE HER ;WOMAN ;GIRL)
	(DESC "her")
	(FLAGS NARTICLEBIT)>

<OBJECT HIM
	(LOC GLOBAL-OBJECTS)
	(SYNONYM HE HIM ;MAN ;BOY)
	(DESC "him")
	(FLAGS NARTICLEBIT)>

<OBJECT THEM
	(LOC GLOBAL-OBJECTS)
	(SYNONYM THEY THEM)
	(DESC "them")
	(FLAGS NARTICLEBIT)>

<GLOBAL QCONTEXT <>>
<GLOBAL QCONTEXT-ROOM <>>
;<GLOBAL LAST-PSEUDO-LOC <>>
<GLOBAL I-ASSUME "(I assume you mean:">

<OBJECT INTDIR
	(LOC GLOBAL-OBJECTS)
	(SYNONYM DIRECTION)
	(ADJECTIVE NORTH EAST SOUTH WEST ;"NE NW SE SW")
	(DESC ;"compass " "direction")>
