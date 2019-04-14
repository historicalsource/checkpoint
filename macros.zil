"MACROS for CHECKPOINT
Copyright (c) 1985 Infocom, Inc.  All rights reserved."

<SETG C-ENABLED? 0>
<SETG C-ENABLED 1>
<SETG C-DISABLED 0>

<ZSTR-OFF>

<DEFMAC TELL ("ARGS" A)
 <FORM PROG ()
  !<MAPF ,LIST
    <FUNCTION ("AUX" E P O)
     <COND (<EMPTY? .A> <MAPSTOP>)
	   (<SET E <NTH .A 1>>
	    <SET A <REST .A>>)>
     <COND (<TYPE? .E ATOM>
	    <COND (<OR <=? <SET P <SPNAME .E>>
			   "CRLF">
		       <=? .P "CR">>
		   <MAPRET '<CRLF>>)
		  (<EMPTY? .A>
		   <ERROR INDICATOR-AT-END? .E>)
		  (ELSE
		   <SET O <NTH .A 1>>
		   <SET A <REST .A>>
		   <COND (<OR <=? <SET P <SPNAME .E>>
				  "DESC">
			      <=? .P "D">
			      <=? .P "OBJ">
			      <=? .P "O">>
			  <MAPRET <FORM PRINTD .O>>)
			 (<OR <=? .P "A">
			      <=? .P "AN">>
			  <MAPRET <FORM PRINTA .O>>)
			 (<OR ;<=? .P "T">
			      <=? .P "THE">>
			  <MAPRET <FORM PRINTT .O>>)
			 (<OR ;<=? .P "CT">
			      <=? .P "CTHE">>
			  <MAPRET <FORM START-SENTENCE .O>>)
			 (<=? .P "CHE">
			  <COND (<OR <EMPTY? .A>
				     <NOT <TYPE? <NTH .A 1> ATOM>>>
				 <MAPRET <FORM HE-SHE-IT .O T>>)
				(T
				 <SET P <SPNAME <NTH .A 1>>>
				 <SET A <REST .A>>
				 <MAPRET <FORM HE-SHE-IT .O T .P>>)>)
			 (<=? .P "HE">
			  <COND (<OR <EMPTY? .A>
				     <NOT <TYPE? <NTH .A 1> ATOM>>>
				 <MAPRET <FORM HE-SHE-IT .O>>)
				(T
				 <SET P <SPNAME <NTH .A 1>>>
				 <SET A <REST .A>>
				 <MAPRET <FORM HE-SHE-IT .O 0 .P>>)>)
			 (<=? .P "V">
			  <SET P <SPNAME <NTH .A 1>>>
			  <SET A <REST .A>>
			  <MAPRET <FORM HE-SHE-IT .O -1 .P>>)
			 (<=? .P "HIM">
			  <MAPRET <FORM HIM-HER-IT .O>>)
			 ;(<=? .P "CHIM">
			  <MAPRET <FORM HIM-HER-IT .O T>>)
			 (<=? .P "HIS">
			  <MAPRET <FORM HIM-HER-IT .O '<> T>>)
			 (<=? .P "CHIS">
			  <MAPRET <FORM HIM-HER-IT .O T T>>)
			 (<OR <=? .P "NUM">
			      <=? .P "N">>
			  <MAPRET <FORM PRINTN .O>>)
			 (<OR ;<=? .P "CHAR">
			      ;<=? .P "CHR">
			      <=? .P "C">>
			  <MAPRET <FORM PRINTC <ASCII .O>>>)
			 (ELSE
			  <MAPRET <FORM PRINT <FORM GETP .O .E>>>)>)>)
	   (<TYPE? .E STRING ZSTRING>
	    <COND ;(<==? 1 <LENGTH .E>>
		    <MAPRET <FORM PRINTC <ASCII <1 .E>>>>)
		  (T <MAPRET <FORM PRINTI .E>>)>)
	   (<TYPE? .E FORM LVAL GVAL>
	    <MAPRET <FORM PRINT .E>>)
	   (ELSE <ERROR UNKNOWN-TYPE .E>)>>>>>

<ROUTINE START-SENTENCE (OBJ "OPTIONAL" (INV? <>))
	<THIS-IS-IT .OBJ>
	<COND (<EQUAL? .OBJ ,PLAYER> <TELL "You"> <RTRUE>)
	      (<EQUAL? .OBJ ,POCKET> <TELL "Your pocket"> <RTRUE>)
	      (<EQUAL? .OBJ ,TICKET> <TELL "Your ticket"> <RTRUE>)
	      (<EQUAL? .OBJ ,PASSPORT> <TELL "Your passport"> <RTRUE>)
	      (<EQUAL? .OBJ ,HEAD> <TELL "Your head"> <RTRUE>)
	      (<EQUAL? .OBJ ,HANDS> <TELL "Your hands"> <RTRUE>)>
	<COND (<NOT <FSET? .OBJ ,NARTICLEBIT>>
	       <COND (<OR <NOT <FSET? .OBJ ,PERSONBIT>>
			  <FSET? .OBJ ,SEENBIT>>
		      <TELL "The ">)
		     (<FSET? .OBJ ,VOWELBIT>
		      <TELL "An ">)
		     (T <TELL "A ">)>)>
	<COND (<FSET? .OBJ ,PERSONBIT>
	       <FSET .OBJ ,SEENBIT>)>
	<TELL D .OBJ>
	<COND (<AND .INV?
		    <IN? ,BRIEFCASE .OBJ>
		    <NOT <FSET? ,BRIEFCASE ,SEENBIT>>>
	       <FSET ,BRIEFCASE ,SEENBIT>
	       <TELL ", carrying" HIM ,BRIEFCASE ",">
	       <RTRUE>)>>

<ROUTINE PRINTT (OBJ)
	<COND (<AND <EQUAL? .OBJ ,TURN> <L? 1 ,P-NUMBER>>
	       <TELL " " N ,P-NUMBER " minutes">)
	      (<AND <EQUAL? .OBJ ,INTNUM> ,P-DOLLAR-FLAG>
	       <TELL " that amount">)
	      (<FSET? .OBJ ,WINDOWBIT>
	       <TELL " the window">)
	      ;(<AND <EQUAL? .OBJ ,P-IT-OBJECT>
		    <FSET? ,IT ,TOUCHBIT>>
	       <TELL " it">
	       <RTRUE>)
	      (T
	       <THE? .OBJ>
	       <TELL " " D .OBJ>)>
	;<THIS-IS-IT .OBJ>>

<ROUTINE THE? (OBJ)
	<COND (<NOT <FSET? .OBJ ,NARTICLEBIT>>
	       <COND (<OR <NOT <FSET? .OBJ ,PERSONBIT>>
			  <FSET? .OBJ ,SEENBIT>>
		      <TELL " the">)
		     (<FSET? .OBJ ,VOWELBIT>
		      <TELL " an">)
		     (T <TELL " a">)>)>
	<COND (<FSET? .OBJ ,PERSONBIT>
	       <FSET .OBJ ,SEENBIT>)>>

<ROUTINE PRINTA (O)
	 <COND (<AND <EQUAL? .O ,INTNUM> ,P-DOLLAR-FLAG>
		<TELL "money">
		<RTRUE>)
	       (<OR ;<FSET? .O ,PERSONBIT> <FSET? .O ,NARTICLEBIT>> T)
	       (<FSET? .O ,VOWELBIT> <TELL "an ">)
	       (T <TELL "a ">)>
	 <TELL D .O>>

<ROUTINE NO-PRONOUN? (OBJ "OPTIONAL" (CAP 0))
	<COND (<EQUAL? .OBJ ,PLAYER>
	       <RFALSE>)
	      (<NOT <FSET? .OBJ ,PERSONBIT>>
	       <COND (<AND <EQUAL? .OBJ ,P-IT-OBJECT>
			   <FSET? ,IT ,TOUCHBIT>>
		      <RFALSE>)>)
	      (<FSET? .OBJ ,FEMALE>
	       <COND (<AND <EQUAL? .OBJ ,P-HER-OBJECT>
			   <FSET? ,HER ,TOUCHBIT>>
		      <RFALSE>)>)
	      (<FSET? .OBJ ,PLURALBIT>
	       <COND (<AND <EQUAL? .OBJ ,P-THEM-OBJECT>
			   <FSET? ,THEM ,TOUCHBIT>>
		      <RFALSE>)>)
	      (T
	       <COND (<AND <EQUAL? .OBJ ,P-HIM-OBJECT>
			   <FSET? ,HIM ,TOUCHBIT>>
		      <RFALSE>)>)>
	<COND (<ZERO? .CAP> <TELL THE .OBJ>)
	      (<ONE? .CAP> <TELL CTHE .OBJ>)>
	<RTRUE>>

<ROUTINE HE-SHE-IT (OBJ "OPTIONAL" (CAP 0) (VERB <>))
	<COND (<NO-PRONOUN? .OBJ .CAP>
	       T)
	      (<NOT <FSET? .OBJ ,PERSONBIT>>
	       <COND (<ZERO? .CAP> <TELL " it">)
		     (<ONE? .CAP> <TELL "It">)>)
	      (<==? .OBJ ,PLAYER>
	       <COND (<ZERO? .CAP> <TELL " you">)
		     (<ONE? .CAP> <TELL "You">)>)
	      (<FSET? .OBJ ,FEMALE>
	       <COND (<ZERO? .CAP> <TELL " she">)
		     (<ONE? .CAP> <TELL "She">)>)
	      (<FSET? .OBJ ,PLURALBIT>
	       <COND (<ZERO? .CAP> <TELL " they">)
		     (<ONE? .CAP> <TELL "They">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " he">)
		     (<ONE? .CAP> <TELL "He">)>)>
	<COND (.VERB
	       <PRINTC 32>
	       <COND (<OR <EQUAL? .OBJ ,PLAYER>
			  <FSET? .OBJ ,PLURALBIT>>
		      <COND (<=? .VERB "is"> <TELL "are">)
			    (<=? .VERB "has"><TELL "have">)
			    (T <TELL .VERB>)>)
		     (T
		      <TELL .VERB>
		      <COND (<EQUAL? .VERB "do" "kiss" "push">
			     <TELL "e">)>
		      <COND (<NOT <EQUAL? .VERB "is" "has">>
			     <TELL "s">)>)>)>>

<ROUTINE ONE? (NUM) <EQUAL? .NUM 1 T>>

<ROUTINE HIM-HER-IT (OBJ "OPTIONAL" (CAP 0) (POSSESS? <>))
 <COND (<NO-PRONOUN? .OBJ .CAP>
	<COND (.POSSESS? <TELL "'s">)>)
       (<NOT <FSET? .OBJ ,PERSONBIT>>
	<COND (<ZERO? .CAP> <TELL " it">) (T <TELL "It">)>
	<COND (.POSSESS? <TELL "s">)>)
       (<==? .OBJ ,PLAYER>
	<COND (.CAP <TELL "You">) (T <TELL " you">)>
	<COND (.POSSESS? <TELL "r">)>)
       (<FSET? .OBJ ,PLURALBIT>
	<COND (.POSSESS?
	       <COND (<ZERO? .CAP> <TELL " their">)
		     (T <TELL "Their">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " them">)
		     (T <TELL "Them">)>)>)
       (<FSET? .OBJ ,FEMALE>
	<COND (<ZERO? .CAP> <TELL " her">) (T <TELL "Her">)>)
       (T
	<COND (.POSSESS?
	       <COND (<ZERO? .CAP> <TELL " his">)
		     (T <TELL "His">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " him">)
		     (T <TELL "Him">)>)>)>
 <RTRUE>>

<DEFMAC VERB? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				     (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L
			     (<CHTYPE <PARSE <STRING "V?"<SPNAME .ATM>>> GVAL>
			      !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSA !.L> !.O)>
		<SET L ()>>>

<DEFMAC DOBJ? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				       (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L (<CHTYPE .ATM GVAL> !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSO !.L> !.O)>
		<SET L ()>>>

<DEFMAC IOBJ? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				       (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L (<CHTYPE .ATM GVAL> !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSI !.L> !.O)>
		<SET L ()>>>

<DEFMAC RFATAL ()
	'<PROG () <PUSH 2> <RSTACK>>>

<DEFMAC PROB ('BASE?)
	<FORM NOT <FORM L? .BASE? '<RANDOM 100>>>>

<ROUTINE PICK-ONE-NEW (FROB "OPTIONAL" (THIS <>) "AUX" L CNT RND MSG RFROB)
	 <SET L <GET .FROB 0>>
	 <SET CNT <GET .FROB 1>>
	 <SET L <- .L 1>>
	 <SET FROB <REST .FROB 2>>
	 <SET RFROB <REST .FROB <* .CNT 2>>>
	 <COND (<AND .THIS <ZERO? .CNT>>
		<SET RND .THIS>)
	       (T <SET RND <RANDOM <- .L .CNT>>>)>
	 <SET MSG <GET .RFROB .RND>>
	 <PUT .RFROB .RND <GET .RFROB 1>>
	 <PUT .RFROB 1 .MSG>
	 <SET CNT <+ .CNT 1>>
	 <COND (<==? .CNT .L> <SET CNT 0>)>
	 <PUT .FROB 0 .CNT>
	 .MSG>

<ROUTINE PICK-ONE (FROB) <GET .FROB <RANDOM <GET .FROB 0>>>>

<DEFMAC ENABLE ('INT) <FORM PUT .INT ,C-ENABLED? 1>>

<DEFMAC DISABLE ('INT) <FORM PUT .INT ,C-ENABLED? 0>>

;<DEFMAC FLAMING? ('OBJ)
	<FORM AND <FORM FSET? .OBJ ',FLAMEBIT>
	          <FORM FSET? .OBJ ',ONBIT>>>

<DEFMAC OPENABLE? ('OBJ)
	<FORM OR <FORM FSET? .OBJ ',DOORBIT>
	         <FORM FSET? .OBJ ',CONTBIT>>> 

<DEFMAC ABS ('NUM)
	<FORM COND (<FORM L? .NUM 0> <FORM - 0 .NUM>)
	           (T .NUM)>>

<DEFMAC GET-REXIT-ROOM ('PT)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM GET .PT ',REXIT>)
	      (T <FORM GETB .PT ',REXIT>)>>

<DEFMAC GET-DOOR-OBJ ('PT)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM GET .PT ',DEXITOBJ>)
	      (T <FORM GETB .PT ',DEXITOBJ>)>>

<DEFMAC GET/B ('TBL 'PTR)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM GET .TBL .PTR>)
	      (T <FORM GETB .TBL .PTR>)>>

<DEFMAC RMGL-SIZE ('TBL)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM - <FORM / <FORM PTSIZE .TBL> 2> 1>)
	      (T <FORM - <FORM PTSIZE .TBL> 1>)>>

<DEFMAC GT-O ('OBJ)
	<FORM GET ',GOAL-TABLES <FORM GETP .OBJ ',P?CHARACTER>>>

<DEFMAC HARD? () '<EQUAL? ,VARIATION 2 4>>
<DEFMAC SPY?  () '<EQUAL? ,VARIATION 3 4>>

<ZSTR-ON>

<SETG PLUS-MODE T>

<OBJECT LAST-OBJECT>	"for MOBY-FIND"
