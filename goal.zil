"GOAL for CHECKPOINT
Copyright (C) 1985 Infocom, Inc.  All rights reserved."

"This code is the local T system."

<ROUTINE DIR-PRINT (DIR "AUX" (CNT 0) TBL X)
	 <COND (<NOT .DIR>
		<TELL "out of view">
		<RTRUE>)>
	 <SET TBL ,DIR-STRINGS>
	 <COND (,ON-TRAIN
		<COND (<OR <NOT ,IN-STATION> <NOT <==? .DIR ,P?DOWN>>>
		       <SET TBL ,NAUTICAL-DIR-STRINGS>)>)>
	 <REPEAT ()
		 <SET X <GET .TBL .CNT>>
		 <COND (<ZERO? .X>
			<TELL "out of view">
			<RTRUE>)
		       (<==? .X .DIR>
			<COND (<NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
			       <TELL "the ">)>
			<COND (<AND ,ON-TRAIN ,IN-STATION <==? .DIR ,P?DOWN>>
			       <TELL "down the steps">)
			      (T <PRINT <GET .TBL <+ .CNT 1>>>)>
			<RTRUE>)>
		 <SET CNT <+ .CNT 2>>>>

<GLOBAL DIR-STRINGS
	<PTABLE P?SOUTH	"south"		P?NORTH	"north"
		P?EAST	"east"		P?WEST	"west"
		P?UP	"up the steps"	P?DOWN	"down the steps"
		P?IN	"in"		P?OUT	"out"
		0>>

<GLOBAL NAUTICAL-DIR-STRINGS
	<PTABLE P?NORTH	"front"		P?SOUTH "rear"
		P?EAST	"right side of the train"
		P?WEST	"left side of the train"
		P?UP	"up the ladder"	P?DOWN	"down the ladder" 
		P?IN	"in"		P?OUT	"out"
		0>>

<ROUTINE OPP-DIR (DIR "AUX" (CNT 0) X)
	<REPEAT ()
		 <SET X <GET ,DIR-STRINGS .CNT>>
		 <COND (<ZERO? .X> <RFALSE>)
		       (<==? .X .DIR>
			<COND (<0? <MOD .CNT 4>>
			       <RETURN <GET ,DIR-STRINGS <+ .CNT 2>>>)
			      (T
			       <RETURN <GET ,DIR-STRINGS <- .CNT 2>>>)>)>
		 <SET CNT <+ .CNT 2>>>>

"Rapid Transit Line Definitions and Identifiers"

<CONSTANT TRAIN-LINE-C 1>
<CONSTANT OTHER-LINE-C 2>
<CONSTANT DINER-LINE-C 3>
<CONSTANT PLATF-LINE-C 4>
<CONSTANT STATN-LINE-C 5>
<CONSTANT FANCY-LINE-C 6>
"<CONSTANT NUMBER-OF-LINES 6>"
<CONSTANT GOAL-I-MULTIPLIER 12>	"<* 2 ,NUMBER-OF-LINES>"

<ROUTINE GET-LINE (LN)
	 <COND (<==? .LN 1> ,TRAIN-LINE)
	       (<==? .LN 2> ,OTHER-LINE)
	       (<==? .LN 3> ,DINER-LINE)
	       (<==? .LN 4> ,PLATF-LINE)
	       (<==? .LN 5> ,STATN-LINE)
	       (<==? .LN 6> ,FANCY-LINE)>>

<GLOBAL TRAIN-LINE
	<PTABLE 0	LIMBO-FWD	P?SOUTH
		P?NORTH	VESTIBULE-FWD	P?SOUTH
		P?NORTH	HALL-1		P?SOUTH
		P?NORTH	HALL-2		P?SOUTH
		P?NORTH	HALL-3		P?SOUTH
		P?NORTH	HALL-4		P?SOUTH
		P?NORTH	HALL-5		P?SOUTH
		P?NORTH	VESTIBULE-REAR	P?SOUTH
		P?NORTH	LIMBO-REAR	0>>

<GLOBAL OTHER-LINE
	<PTABLE 0	OTHER-LIMBO-FWD		P?SOUTH
		P?NORTH	OTHER-VESTIBULE-FWD	P?SOUTH
		P?NORTH	OTHER-HALL-1		P?SOUTH
		P?NORTH	OTHER-HALL-2		P?SOUTH
		P?NORTH	OTHER-HALL-3		P?SOUTH
		P?NORTH	OTHER-HALL-4		P?SOUTH
		P?NORTH	OTHER-HALL-5		P?SOUTH
		P?NORTH	OTHER-VESTIBULE-REAR	P?SOUTH
		P?NORTH	OTHER-LIMBO-REAR	0>>

<GLOBAL DINER-LINE
	<PTABLE 0	LIMBO-FWD-DINER		P?SOUTH
		P?NORTH	VESTIBULE-FWD-DINER	P?SOUTH
		P?NORTH	HALL-1-DINER		P?SOUTH
		P?NORTH	HALL-2-DINER		P?SOUTH
		P?NORTH	HALL-3-DINER		P?SOUTH
		P?NORTH	HALL-4-DINER		P?SOUTH
		P?NORTH	HALL-5-DINER		P?SOUTH
		P?NORTH	VESTIBULE-REAR-DINER	P?SOUTH
		P?NORTH	LIMBO-REAR-DINER	0>>

<GLOBAL FANCY-LINE
	<PTABLE 0	LIMBO-FWD-FANCY		P?SOUTH
		P?NORTH	VESTIBULE-FWD-FANCY	P?SOUTH
		P?NORTH	HALL-1-FANCY		P?SOUTH
		P?NORTH	HALL-2-FANCY		P?SOUTH
		P?NORTH	HALL-3-FANCY		P?SOUTH
		P?NORTH	VESTIBULE-REAR-FANCY	P?SOUTH
		P?NORTH	LIMBO-REAR-FANCY	0>>

<GLOBAL PLATF-LINE
	<PTABLE 0	PLATFORM-A		P?SOUTH
		P?NORTH	PLATFORM-B		P?SOUTH
		P?NORTH	PLATFORM-C		P?SOUTH
		P?NORTH	PLATFORM-D		P?SOUTH
		P?NORTH	PLATFORM-E		0>>

<GLOBAL STATN-LINE
	<PTABLE 0	WAITING-ROOM		P?NORTH
		P?SOUTH	CAFE			0>>

<GLOBAL TRANSFER-TABLE
	<PTABLE ;"transfers for TRAIN-LINE"
		0	0
		0	0
		0	0
		0	0
		0	0
		0	0
		;"transfers for OTHER-LINE"
		0	0
		0	0
		0	0
		0	0
		0	0
		0	0
		;"transfers for DINER-LINE"
		0	0
		0	0
		0	0
		0	0
		0	0
		0	0
		;"transfers for PLATF-LINE"
		0	0
		0	0
		0	0
		0	0
		PLATFORM-C	WAITING-ROOM
		0	0
		;"transfers for STATN-LINE"
		0	0
		0	0
		0	0
		WAITING-ROOM	PLATFORM-C
		0	0
		0	0
		;"transfers for FANCY-LINE"
		0	0
		0	0
		0	0
		0	0
		0	0
		0	0>>

<GLOBAL COR-1
 <PTABLE P?NORTH P?SOUTH
	HALL-1 HALL-2 HALL-3 HALL-4 HALL-5 0>>

<GLOBAL COR-2
 <PTABLE P?NORTH P?SOUTH
	HALL-1-DINER HALL-2-DINER HALL-3-DINER HALL-4-DINER HALL-5-DINER 0>>

<GLOBAL COR-10
 <PTABLE P?NORTH P?SOUTH
	HALL-1-FANCY HALL-2-FANCY HALL-3-FANCY 0>>

<GLOBAL COR-4
 <PTABLE P?NORTH P?SOUTH
	PLATFORM-A PLATFORM-B PLATFORM-C 0>>

"<GLOBAL COR-10
 <PTABLE P?NORTH P?SOUTH
		   PLATFORM-B PLATFORM-C PLATFORM-D 0>>"
<GLOBAL COR-20
 <PTABLE P?NORTH P?SOUTH
			      PLATFORM-C PLATFORM-D PLATFORM-E 0>>

<GLOBAL CAR-ROOMS-CORRIDS <PLTABLE *40* *100* *200* *400* *1000*>>

<GLOBAL COR-40		<PTABLE P?WEST P?EAST COMPARTMENT-1 HALL-1 0>>
<GLOBAL COR-100		<PTABLE P?WEST P?EAST COMPARTMENT-2 HALL-2 0>>
<GLOBAL COR-200		<PTABLE P?WEST P?EAST COMPARTMENT-3 HALL-3 0>>
<GLOBAL COR-400		<PTABLE P?WEST P?EAST COMPARTMENT-4 HALL-4 0>>
<GLOBAL COR-1000	<PTABLE P?WEST P?EAST COMPARTMENT-5 HALL-5 0>>

<GLOBAL COR-2000	<PTABLE P?WEST P?EAST BOOTH-1 HALL-1-DINER 0>>
<GLOBAL COR-4000	<PTABLE P?WEST P?EAST BOOTH-2 HALL-2-DINER 0>>
<GLOBAL COR-10000	<PTABLE P?WEST P?EAST BOOTH-3 HALL-3-DINER 0>>
<GLOBAL COR-20000	<PTABLE P?WEST P?EAST PANTRY  HALL-4-DINER 0>>
<GLOBAL COR-40000	<PTABLE P?WEST P?EAST GALLEY  HALL-5-DINER 0>>

"up to 16 corridors (65536)"

"CODE"

<ROUTINE FOLLOW-GOAL (PERSON
		      "AUX" (HERE <LOC .PERSON>) GT GOAL FLG (IGOAL <>) X)
	 <COND (<NOT <IN? .HERE ,ROOMS>>
		<SET HERE <META-LOC .HERE>>
		<MOVE .PERSON .HERE>)>
	 <SET GT <GT-O .PERSON>>
	 <COND (<==? .HERE <GET .GT ,GOAL-F>>
		<RETURN <GOAL-REACHED .PERSON>>)
	       (<ZERO? <GET .GT ,GOAL-ENABLE>> <RFALSE>)>
	 <COND (<NOT <EQUAL? .HERE <SET X <GETP .HERE ,P?STATION>>>>
		<COND (<ZERO? .X>
		       <SET X .HERE>
		       <TELL "[!! NO STATION AT " D .HERE "]" CR>)>
		<COND (<ZMEMQ .HERE ,CAR-ROOMS-REST>
		       <FCLEAR <FIND-FLAG-LG .HERE ,DOORBIT> ,LOCKED>)>
		<RETURN <MOVE-PERSON .PERSON .X>>)>
	 <SET IGOAL <GET .GT ,GOAL-I>>
	 <SET GOAL <GET ,TRANSFER-TABLE .IGOAL>>
	 <COND (<ZERO? .GOAL>
		<SET IGOAL <>>
		<SET GOAL <GET .GT ,GOAL-S>>)>
	 <COND (<NOT .GOAL> <RFALSE>)
	       (<==? .HERE .GOAL>
		<COND (.IGOAL
		       <SET FLG <GET ,TRANSFER-TABLE <+ .IGOAL 1>>>
		       <COND (<ZERO? .FLG>
			      <SET FLG .HERE>
			      <TELL "[!! NO TRANSFER #" N .IGOAL "]" CR>)>
		       <SET FLG <MOVE-PERSON .PERSON .FLG>>
		       <ESTABLISH-GOAL .PERSON <GET .GT ,GOAL-F>>
		       <RETURN .FLG>)
		      (<NOT <==? .HERE <SET FLG <GET .GT ,GOAL-F>>>>
		       ;<PUT .GT ,GOAL-S <>>
		       <COND (<ZERO? .FLG>
			      <SET FLG .HERE>
			      <TELL "[!! NO GOAL FOR ">
			      <TELL-$WHERE .PERSON>
			      <TELL "]" CR>)>
		       ;<COND (<AND <==? .PERSON ,PLAYER>
				   <OR <ZMEMQ ,HERE ,CAR-ROOMS-VESTIB>
				       <ZMEMQ ,HERE ,CAR-ROOMS-CORRID>>
				   <OR <AND <SET X
						<FIND-FLAG-LG ,HERE ,DOORBIT>>
					    <FSET? .X ,LOCKED>>
				       <AND <ZMEMQ .FLG ,CAR-ROOMS-REST>
					    <OCCUPIED? .FLG ,CAR-HERE>>>>
			      <TELL CTHE .X " is locked." CR>
			      <RTRUE>)>
		       <COND (<NOT <EQUAL? .PERSON ,CONDUCTOR ,CUSTOMS-AGENT>>
			      <FCLEAR .PERSON ,TOUCHBIT>
			      <PUTP .PERSON ,P?LDESC 3>)>
		       <COND (<ZMEMQ .FLG ,CAR-ROOMS-REST>
			      <COND (<AND <NOT <==? .PERSON ,PLAYER>>
					  <OCCUPIED? .FLG
						     <GETP .PERSON ,P?CAR>>>
				     <RETURN <GOAL-REACHED .PERSON>>)
				    (T
				     <FSET <FIND-FLAG-LG .FLG ,DOORBIT>
					   ,LOCKED>)>)>
		       <SET FLG <MOVE-PERSON .PERSON .FLG>>
		       <RETURN .FLG>)
		      (T
		       <RETURN <GOAL-REACHED .PERSON>>)>)>
	 <SET FLG <FOLLOW-GOAL-NEXT .HERE .GOAL .PERSON>>
	 <COND (<==? .HERE .FLG>
		<SET FLG<FOLLOW-GOAL-NEXT .HERE <GETP .GOAL ,P?OTHER>.PERSON>>)>
	 <MOVE-PERSON .PERSON .FLG>>

<ROUTINE FOLLOW-GOAL-DIR (HERE GOAL "OPTIONAL" (PERSON <>) "AUX" LINE LOC)
	 <SET LINE <GETP .GOAL ,P?LINE>>
	 <COND (<ZERO? .LINE> <RFALSE>)
	       (<NOT <EQUAL? .LINE <GETP .HERE ,P?LINE>>>
		<RFALSE>)>
	 <COND (<NOT <EQUAL? .HERE <SET LOC <GETP .HERE ,P?STATION>>>>
		<RETURN <DIR-FROM .HERE .LOC>>
		;<SET HERE .LOC>)>
	 <COND (<NOT <EQUAL? .GOAL <SET LOC <GETP .GOAL ,P?STATION>>>>
		<COND (<==? .HERE .LOC>
		       <RETURN <DIR-FROM .HERE .GOAL>>)
		      (T <SET GOAL .LOC>)>)>
	 <SET LOC <FOLLOW-GOAL-NEXT .HERE .GOAL .PERSON>>
	 <COND (<==? .LOC .HERE>
		<SET LOC<FOLLOW-GOAL-NEXT .HERE <GETP .GOAL ,P?OTHER>.PERSON>>)>
	 <DIR-FROM .HERE .LOC>>

<ROUTINE FOLLOW-GOAL-NEXT (HERE GOAL "OPTIONAL" (PERSON <>)
			   "AUX" LINE (CNT 1) RM (GOAL-FLAG <>) LOC)
	 <COND (<NOT .PERSON> <SET PERSON ,GAME>)>
	 <SET LINE <GET-LINE <GETP .GOAL ,P?LINE>>>
	 <COND (<ZERO? .LINE>
		<TELL "[!! STUCK (" D .PERSON "): GOAL=" D .GOAL "]" CR>
		<RETURN .HERE>)
	       (<NOT <==? .LINE <GET-LINE <GETP .HERE ,P?LINE>>>>
		<COND (<AND <OR <EQUAL? .HERE ,VESTIBULE-REAR
					      ,VESTIBULE-REAR-DINER>
				<EQUAL? .HERE ,OTHER-VESTIBULE-REAR
					      ,VESTIBULE-REAR-FANCY>>
			    <ON-PLATFORM? .GOAL>
			    ;<ZMEMQ .GOAL ,STATION-ROOMS>>
		       <SET HERE <GET ,STATION-ROOMS <GETP .PERSON ,P?CAR>>>
		       <MOVE-PERSON .PERSON .HERE>)
		      (T
		       <TELL "[!! STUCK: ">
		       <TELL-$WHERE .PERSON .HERE>
		       <TELL "GOAL: ">
		       <TELL-$WHERE .PERSON .GOAL>
		       <TELL "]" CR>
		       <RETURN .HERE>)>)>
	 <REPEAT ()
		 <SET RM <GET .LINE .CNT>>
		 <COND (<==? .RM .HERE>
		        <COND (.GOAL-FLAG
			       <SET LOC <GET .LINE <- .CNT 3>>>)
			      (T
			       <SET LOC <GET .LINE <+ .CNT 3>>>)>
			<RETURN .LOC>)
		       (<==? .RM .GOAL>
			<SET GOAL-FLAG T>)>
		 <SET CNT <+ .CNT 3>>>>

;<ROUTINE COR-DIR (HERE THERE CAR "AUX" COR RM (PAST 0) (CNT 2))
	 <COND (<EQUAL? .HERE ,ROOF ,BESIDE-TRACKS>
		<COND (<AND <EQUAL? .HERE ,ROOF>
			    <NOT <==? .THERE ,OTHER-ROOF>>>
		       <RFALSE>)
		      (<AND <EQUAL? .HERE ,BESIDE-TRACKS>
			    <NOT <==? .THERE ,OTHER-BESIDE-TRACKS>>>
		       <RFALSE>)
		      (<L? .CAR ,CAR-HERE>
		       <RETURN ,P?NORTH>)
		      (T <RETURN ,P?SOUTH>)>)
	       (<EQUAL? .HERE ,VESTIBULE-FWD
			      ,VESTIBULE-FWD-DINER ,VESTIBULE-FWD-FANCY>
		<COND (<AND <==? .CAR <- ,CAR-HERE 1>>
			    <==? .THERE <V-REAR .CAR>>>
		       <RETURN ,P?NORTH>)
		      (T <RETURN <>>)>)
	       (<EQUAL? .HERE ,VESTIBULE-REAR
			      ,VESTIBULE-REAR-DINER ,VESTIBULE-REAR-FANCY>
		<COND (<AND <==? .CAR <+ ,CAR-HERE 1>>
			    <==? .THERE <V-FWD .CAR>>>
		       <RETURN ,P?SOUTH>)
		      (T <RETURN <>>)>)>
	 <SET RM <BAND <GETP .THERE ,P?CORRIDOR> <GETP .HERE ,P?CORRIDOR>>>
	 <COND (<ZERO? .RM>
		<COND (<OR <ZMEMQ .HERE ,CAR-ROOMS-COMPS>
			   <ZMEMQ .HERE ,CAR-ROOMS-COMPS-DINER>
			   <EQUAL? .HERE ,SUITE-1 ,SUITE-2 ,SUITE-3>>
		       <RETURN <DIR-FROM .HERE .THERE>>)
		      (T <RFALSE>)>)>
	 <SET COR <GET-COR .RM>>
	 <REPEAT ()
		 <COND (<==? <SET RM <GET .COR .CNT>> .HERE>
			<SET PAST 1>
			<RETURN>)
		       (<==? .RM .THERE>
			<RETURN>)>
		 <SET CNT <+ .CNT 1>>>
	 <GET .COR .PAST>>

;<ROUTINE GET-COR (NUM)
	 ;#DECL ((NUM) FIX)
	 <COND (<==? .NUM 1> ,COR-1)
	       (<==? .NUM 2> ,COR-2)
	       (<==? .NUM 4> ,COR-4)
	       (<==? .NUM *10*> ,COR-10)
	       (<==? .NUM *20*> ,COR-20)
	       (<==? .NUM *40*> ,COR-40)
	       (<==? .NUM *100*> ,COR-100)
	       (<==? .NUM *200*> ,COR-200)
	       (<==? .NUM *400*> ,COR-400)
	       (<==? .NUM *1000*> ,COR-1000)
	       (<==? .NUM *2000*> ,COR-2000)
	       (<==? .NUM *4000*> ,COR-4000)
	       (<==? .NUM *10000*> ,COR-10000)
	       (<==? .NUM *20000*> ,COR-20000)
	       (T ,COR-40000)>>

"Routines to do looking down corridors"

<ROUTINE COR-GRAB-ATTENTION () <CORRIDOR-LOOK <> <> T>>

<ROUTINE CORRIDOR-LOOK ("OPTIONAL" (ITM <>) (CAR <>) (GRAB <>)
			"AUX" C Z COR VAL (FOUND <>))
 <COND (<AND .ITM <NOT .CAR>>
	<SET CAR <GETP .ITM ,P?CAR>>)>
 <COND (<SET C <GETP ,HERE ,P?CORRIDOR>>
	 <COND (<L? .C 0>
		<CORRIDOR-CHECK <> .ITM .CAR .GRAB>)
	       (T
		<REPEAT ()
			<COND (<NOT <L? <SET Z <- .C *40000*>> 0>>
			       <SET COR ,COR-40000>)
			      (<NOT <L? <SET Z <- .C *20000*>> 0>>
			       <SET COR ,COR-20000>)
			      (<NOT <L? <SET Z <- .C *10000*>> 0>>
			       <SET COR ,COR-10000>)
			      (<NOT <L? <SET Z <- .C *4000*>> 0>>
			       <SET COR ,COR-4000>)
			      (<NOT <L? <SET Z <- .C *2000*>> 0>>
			       <SET COR ,COR-2000>)
			      (<NOT <L? <SET Z <- .C *1000*>> 0>>
			       <SET COR ,COR-1000>)
			      (<NOT <L? <SET Z <- .C *400*>> 0>>
			       <SET COR ,COR-400>)
			      (<NOT <L? <SET Z <- .C *200*>> 0>>
			       <SET COR ,COR-200>)
			      (<NOT <L? <SET Z <- .C *100*>> 0>>
			       <SET COR ,COR-100>)
			      (<NOT <L? <SET Z <- .C *40*>> 0>>
			       <SET COR ,COR-40>)
			      (<NOT <L? <SET Z <- .C *20*>> 0>>
			       <SET COR ,COR-20>)
			      (<NOT <L? <SET Z <- .C *10*>> 0>>
			       <SET COR ,COR-10>)
			      (<NOT <L? <SET Z <- .C 4>> 0>>
			       <SET COR ,COR-4>)
			      (<NOT <L? <SET Z <- .C 2>> 0>>
			       <SET COR ,COR-2>)
			      (<NOT <L? <SET Z <- .C 1>> 0>>
			       <SET COR ,COR-1>)
			      (T <RETURN>)>
			<SET VAL <CORRIDOR-CHECK .COR .ITM .CAR .GRAB>>
			<COND (<NOT .FOUND> <SET FOUND .VAL>)>
			<SET C .Z>>
		.FOUND)>)>>

<GLOBAL COR-ALL-DIRS <>>

<ROUTINE CORRIDOR-CHECK (COR ITM CAR "OPTIONAL" (GRAB <>)
 "AUX" (CNT 2) (PAST 0) (FOUND <>) (RM <>) OBJ DIR (NCAR 0) X (Y <>))
	<SET DIR <GET <OR .COR ,COR-1> .PAST>>
	<REPEAT ()
	 <COND (<NOT <ZERO? .COR>>
		<SET RM <GET .COR .CNT>>
		<COND (<ZERO? .RM>
		       <COR-TELL-PER>
		       <RETURN .Y>)>)
	       (<EQUAL? ,HERE ,ROOF ,BESIDE-TRACKS>
		<COND (<EQUAL? ,HERE ,ROOF> <SET RM ,OTHER-ROOF>)
		      (T <SET RM ,OTHER-BESIDE-TRACKS>)>
		<COND (<ZERO? .NCAR>
		       <SET NCAR <- ,CAR-HERE 1>>
		       <COND (<ZERO? .NCAR>
			      <SET PAST 1>
			      <SET DIR <GET <OR .COR ,COR-1> .PAST>>
			      <SET NCAR <+ ,CAR-HERE 1>>)>)
		      (<ZERO? .PAST>
		       <SET NCAR <- .NCAR 1>>
		       <COND (<ZERO? .NCAR>
			      <SET PAST 1>
			      <SET DIR <GET <OR .COR ,COR-1> .PAST>>
			      <SET NCAR <+ ,CAR-HERE 1>>)>)
		      (T
		       <SET NCAR <+ .NCAR 1>>
		       <COND (<G? .NCAR ,CAR-MAX>
			      <COR-TELL-PER>
			      <RETURN .Y>)>)>)
	       (<NOT <ZERO? .RM>>
		<COR-TELL-PER>
		<RETURN .Y>)
	       (<EQUAL? ,HERE ,VESTIBULE-REAR
			      ,VESTIBULE-REAR-DINER ,VESTIBULE-REAR-FANCY>
		<SET PAST 1>
		<SET DIR <GET <OR .COR ,COR-1> .PAST>>
		<SET NCAR <+ ,CAR-HERE 1>>
		<SET RM <V-FWD .NCAR>>)
	       (<EQUAL? ,HERE ,VESTIBULE-FWD
			      ,VESTIBULE-FWD-DINER ,VESTIBULE-FWD-FANCY>
		<SET NCAR <- ,CAR-HERE 1>>
		<SET RM <V-REAR .NCAR>>)>
	 <COND (<AND <==? .RM ,HERE>>
		<SET PAST 1>
		<SET DIR <GET <OR .COR ,COR-1> .PAST>>)
	       (<OR <==? .ITM <SET OBJ .RM>>
		    <SET OBJ <FIRST? .RM>>>
		<REPEAT ()
		 <COND (<NOT <ZERO? .ITM>>
			<COND (<==? .OBJ .ITM>
			       <COND (<NOT <ZERO? .COR>>
				      <SET FOUND <GET .COR .PAST>>
				      <RETURN>)
				     (<==? .NCAR .CAR>
				      <SET FOUND <GET ,COR-1 .PAST>>
				      <RETURN>)>)>)
		       (<AND <OR ,COR-ALL-DIRS
				 <NOT <==? .DIR ,PLAYER-NOT-FACING>>>
			     <OR <EQUAL? .OBJ ,BRIEFCASE>
				 <GETP .OBJ ,P?CHARACTER>>
			     <OR .COR
				 <==? .NCAR <GETP .OBJ ,P?CAR>>>
			     <NOT <FSET? .OBJ ,NDESCBIT ;INVISIBLE>>
			     <OR .GRAB
				 <NOT <IN-MOTION? .OBJ>>>>
			<COND (<NOT <ZERO? .GRAB>>
			       <COND (<SET X <GRAB-ATTENTION .OBJ>>
				      <FCLEAR .OBJ ,TOUCHBIT>
				      <PUTP .OBJ ,P?LDESC 21 ;"listening ...">
				      <TELL CHE .OBJ turn " toward you." CR>)>
			       <COND (<NOT .Y> <SET Y .X>)>)
			      (<COR-ADD-PER .OBJ .DIR> T)
			      (T
			       ;<HE-SHE-IT .OBJ T "is">
			       <TELL CHE .OBJ is>
			       <WHERE? .OBJ .DIR>
			       <TELL "." CR>)>)>
		 <SET OBJ <NEXT? .OBJ>>
		 <COND (<ZERO? .OBJ> <RETURN>)>>
		<COND (<NOT <ZERO? .FOUND>>
		       <RETURN .FOUND>)>)>
	 <SET CNT <+ .CNT 1>>>>

;<ROUTINE CLEAR-TABLES (TBL "AUX" LEN T L)
	<SET LEN <GET .TBL 0>>
	<REPEAT ()
		<SET T <GET .TBL .LEN>>
		<SET L <GET .T 0>>
		<REPEAT ()
			<PUT .T .L 0>
			<COND (<DLESS? L 1> <RETURN>)>>
		<COND (<DLESS? LEN 1> <RETURN>)>>>

<ROUTINE COR-ADD-PER (PER DIR "AUX" T L)
	<COND (<NOT <SET L <ZMEMQ .DIR ,COR-DIR-TBL>>>
	       <RFALSE>)>
	<SET T <GET ,COR-PER-TBLS .L>>
	<SET L <GET .T 0>>
	<REPEAT ()
		<COND (<ZERO? <GET .T .L>>
		       <PUT .T .L .PER>
		       <RTRUE>)
		      (<DLESS? L 1>
		       <RFALSE>)>>>

<ROUTINE COR-TELL-PER ("AUX" TBL LEN T L FIRST P OP NUM)
	<SET TBL ,COR-PER-TBLS>
	<SET LEN <GET .TBL 0>>
	<REPEAT ()
		<SET T <GET .TBL .LEN>>
		<SET L <GET .T 0>>
		<SET FIRST T>
		<SET NUM 0>
		<REPEAT ()
			<COND (<NOT <ZERO? <SET P <GET .T .L>>>>
			       <SET OP .P>
			       <INC NUM>
			       <PUT .T .L 0>
			       <COND (.FIRST
				      <SET FIRST <>>
				      <TELL CTHE .P>)
				     (T
				      <COND (<OR <1? .L>
						 <ZERO? <GET .T <- .L 1>>>>
					     <TELL " and">)
					    (T <TELL ",">)>
				      <TELL THE .P>
				      <THIS-IS-IT .P>)>)>
			<COND (<DLESS? L 1>
			       <COND (<0? .NUM> <RETURN>)
				     (<AND <1? .NUM>
					   <NOT <FSET? .OP ,PLURALBIT>>>
				      <TELL " is">)
				     (T <TELL " are">)>
			       <WHERE? .OP <GET ,COR-DIR-TBL .LEN>>
			       <TELL "." CR>
			       <RETURN>)>>
		<COND (<DLESS? LEN 1> <RETURN>)>>>

<GLOBAL COR-DIR-TBL <PLTABLE P?NORTH P?SOUTH P?EAST P?WEST>>
<GLOBAL COR-PER-TBLS
   <PLTABLE	<LTABLE 0 0 0 0 0>
		<LTABLE 0 0 0 0 0>
		<LTABLE 0 0 0 0 0>
		<LTABLE 0 0 0 0 0>>>

<ROUTINE IN-MOTION? (PERSON "OPTIONAL" (DISABLED-OK <>) "AUX" GT L F C)
	<COND (<EQUAL? .PERSON ,BOND> <RTRUE>)>
	<SET C <GETP .PERSON ,P?CHARACTER>>
	<COND (<==? ,EXTRA-C .C>
	       <COND (<NOT <==? .PERSON <GET ,GLOBAL-CHARACTER-TABLE .C>>>
		      <RFALSE>)
		     (.DISABLED-OK <RTRUE>)
		     ;(T <RTRUE>)>)>
	<SET GT <GET ,GOAL-TABLES .C>>
	<COND (<AND <GET .GT ,GOAL-S>
		    <NOT <==? <SET L <LOC .PERSON>>
			      <SET F <GET .GT ,GOAL-F>>>>>
	       <COND (.DISABLED-OK <RTRUE>)
		     (<NOT <ZERO? <GET .GT ,GOAL-ENABLE>>>
		      <FOLLOW-GOAL-DIR .L .F .PERSON>)>)>>

<ROUTINE START-MOVEMENT ()
	 <I-EXTRA ,M-OTHER>
	 <ENABLE <QUEUE I-STAR <RANDOM 9>>>
	 <QUEUE G-LEAVE-TRAIN 0>
	 <ENABLE <QUEUE I-CONDUCTOR 1>>
	 <ENABLE <QUEUE I-FOLLOW -1>>
	 <ENABLE <QUEUE I-ATTENTION -1>>
	 <QUEUE I-LEAVE-TRAIN 0>
	 <ENABLE <QUEUE I-TICKETS-PLEASE -1>>>

"Goal tables for the characters, offset by a constant,
which, for a given character, is the P?CHARACTER property of the object."

<GLOBAL GOAL-TABLES
	<PTABLE	<TABLE <> <> <> 1 <> I-PLAYER	 5 0 0 I-PLAYER>
		<TABLE <> <> <> 1 <> I-CONDUCTOR 5 0 0 I-CONDUCTOR>
		<TABLE <> <> <> 1 <> I-WAITER	 5 0 0 I-WAITER>
		<TABLE <> <> <> 1 <> I-COOK	 5 0 0 I-COOK>
		<TABLE <> <> <> 1 <> I-EXTRA	 5 0 0 I-EXTRA>
		<TABLE <> <> <> 1 <> I-BOND	 5 0 0 I-BOND>
		<TABLE <> <> <> 1 <> I-STAR	 5 0 0 STOP-WALKING-F>
		<TABLE <> <> <> 1 <> I-STAR	 5 0 0 STOP-WALKING-F>
		<TABLE <> <> <> 1 <> I-STAR	 5 0 0 STOP-WALKING-F>
		<TABLE <> <> <> 1 <> I-STAR	 5 0 0 STOP-WALKING-F>
		<TABLE <> <> <> 1 <> I-STAR	 5 0 0 STOP-WALKING-F>
		<TABLE <> <> <> 1 <> I-STAR	 5 0 0 STOP-WALKING-F>
		<TABLE <> <> <> 1 <> I-GUARD	 5 0 0 I-GUARD>
		<TABLE <> <> <> 1 <> I-STAR	 5 0 0 STOP-WALKING-F>
		<TABLE <> <> <> 1 <> I-STAR	 5 0 0 STOP-WALKING-F>>>
[
"Offsets into GOAL-TABLEs"

<CONSTANT GOAL-F 0> "final goal"
<CONSTANT GOAL-S 1> "station of final goal"
<CONSTANT GOAL-I 2> "intermediate goal (transfer point)"
<CONSTANT GOAL-ENABLE 3> "character can move: 0=no 1=slow 2=fast"
<CONSTANT GOAL-QUEUED 4> "secondary goal to go to when proper car reached"
<CONSTANT GOAL-FUNCTION 5> "routine to apply on arrival"
<CONSTANT ATTENTION-SPAN 6> "how long character will wait when interrupted"
<CONSTANT ATTENTION 7> "used to count down from ATTENTION-SPAN to 0"
<CONSTANT GOAL-CAR 8> "car number to go with GOAL-QUEUED"
<CONSTANT GOAL-SCRIPT 9> "second routine to apply on arrival"
]
"Goal-function constants, similar to M-xxx in MAIN"

<CONSTANT G-REACHED 1>
<CONSTANT G-ENROUTE 2>
<CONSTANT G-IMPATIENT 3>
<CONSTANT G-DEBUG 4>

"Movement etc."

<ROUTINE ESTABLISH-GOAL (PERSON GOAL "OPTIONAL" (WALK-TRAIN 0)
			 	     "AUX" HERE HL GL GT)
	 <COND (<ZERO? .PERSON>
		<TELL
"[!! E-G: PERSON=0, GOAL=" D .GOAL ", W-T=" N .WALK-TRAIN ".]" CR>)>
	 <SET HERE <LOC .PERSON>>
	 ;<COND (<==? .HERE .GOAL>
		<RETURN .HERE>)>
	 <SET GT <GT-O .PERSON>>
	 <PUT .GT ,GOAL-I <+ <* <- <GETP .HERE ,P?LINE> 1> ,GOAL-I-MULTIPLIER>
			     <* <- <GETP .GOAL ,P?LINE> 1> 2>>>
	 <PUT .GT ,GOAL-S <GETP .GOAL ,P?STATION>>
	 <PUT .GT ,GOAL-F .GOAL>
	 ;"WALK-TRAIN: 0=normal, 1=continuing walk, 2=finishing walk"
	 <COND (<EQUAL? 2 .WALK-TRAIN>
		<PUT .GT ,GOAL-FUNCTION <GET .GT ,GOAL-SCRIPT>>)>
	 <COND (<AND <ZERO? .WALK-TRAIN>
		     <NOT <EQUAL? .PERSON;,PLAYER ,CONDUCTOR ,CUSTOMS-AGENT>>>
		<FCLEAR .PERSON ,TOUCHBIT>
		<PUTP .PERSON ,P?LDESC 13 ;"about to leave">)>
	 <LOC .PERSON>>

<ROUTINE ESTABLISH-GOAL-TRAIN (PERSON GOAL CAR "AUX" GT CARH)
	<COND (<OR <EQUAL? <LOC .PERSON> ,BESIDE-TRACKS ,OTHER-BESIDE-TRACKS>
		   <ZMEMQ <LOC .PERSON> ,STATION-ROOMS>>
	       <TELL "[!! " D .PERSON " not on train!]" CR>
	       <RTRUE>)>
	<SET CARH <GETP .PERSON ,P?CAR>>
	<SET GT <GT-O .PERSON>>
	<COND (<NOT <==? .CAR .CARH>>
	       <PUT .GT ,GOAL-CAR .CAR>
	       <PUT .GT ,GOAL-QUEUED .GOAL>
	       <PUT .GT ,GOAL-FUNCTION ,I-WALK-TRAIN>
	       <COND (<L? .CAR .CARH>
		      <SET GOAL <L-FWD .CARH>>)
		     (T <SET GOAL <L-REAR .CARH>>)>)
	      (T
	       <PUT .GT ,GOAL-FUNCTION <GET .GT ,GOAL-SCRIPT>>
	       <COND (<NOT <EQUAL? .CAR ,CAR-HERE ,DINER-CAR ,FANCY-CAR>>
		      <SET GOAL <GETP .GOAL ,P?OTHER>>)>)>
	<ESTABLISH-GOAL .PERSON .GOAL>>

<GLOBAL GOAL-PERSON <>>
<ROUTINE GOAL-REACHED (PERSON "AUX" GT)
	 <SET GT <GT-O .PERSON>>
	 <COND (<AND <NOT <EQUAL? .PERSON ,CONDUCTOR ,CUSTOMS-AGENT ,BAD-SPY>>
		     <NOT <==? ,I-WALK-TRAIN <GET .GT ,GOAL-FUNCTION>>>>
		<NEW-LDESC .PERSON>)>
	 <COND (<EQUAL? <LOC .PERSON> ,BOOTH-1 ,BOOTH-2 ,BOOTH-3>
		<COND (<EQUAL? ,HERE ,PANTRY>
		       <TELL "A concealed bell tinkles merrily." CR>)
		      (<IN? ,WAITER ,PANTRY>
		       <ESTABLISH-GOAL ,WAITER <LOC .PERSON>>)>)>
	 <COND (<GET .GT ,GOAL-S>
		<PUT .GT ,GOAL-S <>>
		<SETG GOAL-PERSON .PERSON>
		<D-APPLY "Reached" <GET .GT ,GOAL-FUNCTION> ,G-REACHED>)>>

<ROUTINE ENTERS? (DIR OWHERE)
 <COND (<==? .DIR ,P?IN> <RTRUE>)
       (<NOT <ZMEMQ ,HERE ,CAR-ROOMS-CORRID>> <RFALSE>)
       (<ZMEMQ .OWHERE ,CAR-ROOMS-COMPS> <RTRUE>)
       (<EQUAL? .OWHERE ,BOOTH-1 ,BOOTH-2 ,BOOTH-3> <RTRUE>)
       (<ZMEMQ .OWHERE ,CAR-ROOMS-REST> <RTRUE>)>>

<ROUTINE TELL-THE-NOT-OTHER (RM)
	<COND (<OR <ZMEMQ .RM ,STATION-ROOMS>
		   <ZMEMQ .RM ,CAR-ROOMS-DINER>
		   <ZMEMQ .RM ,CAR-ROOMS-FANCY>
		   <ZMEMQ .RM ,CAR-ROOMS>>
	       <TELL THE .RM>)
	      (T <TELL THE <GETP .RM ,P?OTHER>>)>>

<ROUTINE DESCRIBE-MOVER? (PERSON)
 <COND (<AND <VERB? EXAMINE> <==? ,PRSO .PERSON>>
	<RFALSE>)
       (<VERB? WAIT-FOR WAIT-UNTIL>
	<RFALSE>)
       (<NOT <FSET? .PERSON ,ONBIT>>
	<RFALSE>)
       (<NOT <EQUAL? .PERSON ,CONDUCTOR>>
	<RTRUE>)
       (<NOT <EQUAL? <GETP .PERSON ,P?LDESC> 19 ;"making his rounds">>
	<RTRUE>)
       (T <RFALSE>)>>

<ROUTINE MOVE-PERSON (PERSON WHERE "OPTIONAL" (LIMBO? <>)
			"AUX" DIR (GT <>) OL COR PCOR CHR OWHERE
			(DOOR <>) (VAL <>) X CAR NCAR)
	 ;#DECL ((PERSON WHERE) OBJECT)
	 <SET CHR <GETP .PERSON ,P?CHARACTER>>
	 <SET CAR <GETP .PERSON ,P?CAR>>
	 <SET NCAR .CAR>
	 <COND (T ;.CHR <SET GT <GET ,GOAL-TABLES .CHR>>)>
	 <SET OL <LOC .PERSON>>
	 <SET DIR <DIR-FROM .OL .WHERE>>
	 <SET OWHERE .WHERE>
	 <COND (<OR <EQUAL? .OL ,VESTIBULE-FWD ,VESTIBULE-FWD-DINER>
		    <EQUAL? .OL ,OTHER-VESTIBULE-FWD ,VESTIBULE-FWD-FANCY>>
		<COND (<OR <EQUAL? .WHERE ,LIMBO-FWD ,LIMBO-FWD-FANCY>
			   <EQUAL? .WHERE ,OTHER-LIMBO-FWD ,LIMBO-FWD-DINER>>
		       <DEC NCAR>
		       <SET OWHERE <V-REAR .NCAR>>)>)
	       (<OR <EQUAL? .OL ,VESTIBULE-REAR ,VESTIBULE-REAR-DINER>
		    <EQUAL? .OL ,OTHER-VESTIBULE-REAR ,VESTIBULE-REAR-FANCY>>
		<COND (<OR <EQUAL? .WHERE ,LIMBO-REAR ,LIMBO-REAR-FANCY>
			   <EQUAL? .WHERE ,OTHER-LIMBO-REAR,LIMBO-REAR-DINER>>
		       <INC NCAR>
		       <SET OWHERE <V-FWD .NCAR>>)>)>
	 <COND (<AND <NOT <ZERO? .DIR>>
		     <SET X <GETPT .OL .DIR>>
		     <==? <PTSIZE .X> ,DEXIT>>
		<SET DOOR <GET-DOOR-OBJ .X>>
		;<COND (<ZMEMQ .OL ,CAR-ROOMS-REST>
		       <SET DOOR <>>)>)>
	 <COND (<EQUAL? .PERSON ,PLAYER>
		<COND (<SET OL <COMPASS-EQV ,HERE .DIR>>
		       ;<SETG PLAYER-NOT-FACING-OLD ,PLAYER-NOT-FACING>
		       <SETG PLAYER-NOT-FACING <OPP-DIR .OL>>)>
		<COND (<AND .DOOR <NOT <WALK-THRU-DOOR? .X>>>
		       <CRLF>
		       <RFATAL>)>)
	       (<FSET? .PERSON ,NDESCBIT ;INVISIBLE> T)
	       (<PREVENTS-YOU? .OL .DIR .PERSON>
		<COND (<VISIBLE? .PERSON>
		       <SET VAL T>
		       <TELL
CHE ,CONDUCTOR " prevents" THE .PERSON " from passing him." CR>)>)
	       (<==? .OL ,HERE>
		<COND (<DESCRIBE-MOVER? .PERSON>
		       <FCLEAR .PERSON ,ONBIT>	;"un-special the case"
		       <DESCRIBE-OBJECT .PERSON 0>)>
		<SET VAL T>
		<COND (<AND <IN? ,BRIEFCASE .PERSON>
			    <NOT <FSET? ,BRIEFCASE ,SEENBIT>>>
		       <START-SENTENCE .PERSON T>)
		      (T <TELL CHE .PERSON>)>
		<COND (<AND <==? .PERSON ,CONDUCTOR> ,TOUCH-CAP?>
		       <SETG TOUCH-CAP? <>>
		       <TELL " touches a finger to his cap and">)>
		<COND (.DOOR
		       ;<HE-SHE-IT .PERSON -1 "open">
		       <TELL V .PERSON open HIM .DOOR " for a moment and">)>
		<COND (<OR <==? .DIR ,P?OUT>
			   <ZMEMQ ,HERE ,CAR-ROOMS-COMPS>
			   <EQUAL? ,HERE ,BOOTH-1 ,BOOTH-2 ,BOOTH-3>>
		       <TELL V .PERSON leave "." CR>)
		      (<AND ;.DOOR <ENTERS? .DIR .OWHERE>>
		       ;<HE-SHE-IT .PERSON -1 "enter">
		       <TELL V .PERSON enter>
		       <TELL-THE-NOT-OTHER .OWHERE>
		       <COND (<AND .DOOR <FSET? .DOOR ,LOCKED>>
			      <TELL ", locking the door">)>
		       <TELL "." CR>)
		      (<AND <==? .CAR ,CAR-MAX>
			    <EQUAL? .OL ,VESTIBULE-REAR>
			    <EQUAL? .WHERE ,LIMBO-REAR>>
		       <TELL
V .PERSON check HIS .PERSON " pocket for a minute." CR>)
		      (T
		       <TELL V .PERSON head C !\ >
		       <COND (<NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
			      <TELL "off to ">)>
		       <DIR-PRINT .DIR>
		       <COND (<AND .DOOR <FSET? .DOOR ,LOCKED>>
			      <TELL ", locking the door" ;" again">)>
		       <TELL "." CR>)>)
	       (<==? .OWHERE ,HERE>
		<COND (<OR <NOT .GT>
			   <NOT <==? ,HERE <GET .GT ,GOAL-F>>>>
		       <COND (<OR <AND ,TICKETS-PUNCHED? <NOT ,CUSTOMS-SWEEP>>
				  <NOT <==? .PERSON ,CONDUCTOR>>>
			      <SET VAL T ;,M-FATAL>
			      <START-SENTENCE .PERSON T>
			      <COND (.DOOR
				     <TELL
V .PERSON open HIM .DOOR " for a moment and">)>
			      <TELL V .PERSON walk C !\ >
			      <COND (<AND <VERB? WALK>
					  ;<==? .OWHERE ,HERE>
					  <==? .OL ,LAST-PLAYER-LOC>>
				     <TELL "along with you">)
				    (T
				     <TELL "past you">
				     <COND (<NOT <EQUAL? .DIR ,P?IN ,P?OUT>>
					    <TELL " from ">
					    <DIR-PRINT <OPP-DIR .DIR>>)>)>
			      <TELL "." CR>)>)>)
	       (<SET COR <GETP ,HERE ,P?CORRIDOR>>
		<SET PCOR <CORRIDOR-LOOK .PERSON .CAR>>
		<COND (<NOT <EQUAL? .PCOR ,FALSE-VALUE ,PLAYER-NOT-FACING>>
		       <COND (<EQUAL? <CORRIDOR-LOOK .OWHERE .NCAR>
				      ,FALSE-VALUE ,PLAYER-NOT-FACING>
			      <SET VAL T>
			      <COND (<AND <EQUAL? .PERSON ,P-HER-OBJECT>
					  <FSET? ,HER ,TOUCHBIT>>
				     <TELL "She">)
				    (<AND <EQUAL? .PERSON ,P-HIM-OBJECT>
					  <FSET? ,HIM ,TOUCHBIT>>
				     <TELL "He">)
				    (<AND <EQUAL? .PERSON ,P-THEM-OBJECT>
					  <FSET? ,THEM ,TOUCHBIT>>
				     <TELL "They">)
				    (T
				     <COND (<NOT <START-SENTENCE .PERSON T>>
					    <TELL ",">)>
				     <WHERE? .PERSON .PCOR>
				     <TELL ",">)>
			      <COND (.DOOR
				     ;<HE-SHE-IT .PERSON -1 "open">
				     <TELL
V .PERSON open HIM .DOOR " for a moment and">)>
			      <COND (<AND ;.DOOR <ENTERS? .DIR .OWHERE>>
				     <TELL V .PERSON enter>
				     <TELL-THE-NOT-OTHER .OWHERE>)
				    (T
				     <TELL V .PERSON disappear C !\ >
				     <COND (<NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
					    <TELL "to ">)>
				     <DIR-PRINT .DIR>)>
			      <COND (<AND .DOOR <FSET? .DOOR ,LOCKED>>
				     <TELL ", locking the door" ;" again">)>
			      <TELL "." CR>)
			     (T
			      <SET VAL T>
			      <START-SENTENCE .PERSON T>
			      ;<HE-SHE-IT .PERSON -1 "is">
			      <TELL V .PERSON is>
			      <WHERE? .PERSON .PCOR>
			      <TELL ", heading ">
			      <COND (<==? .PCOR .DIR>
				     <TELL "away from you">)
				    (<==? .PCOR <OPP-DIR .DIR>>
				     <TELL "toward you">)
				    (T
				     <COND (<NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
					    <TELL "toward ">)>
				     <DIR-PRINT .DIR>)>
			      <TELL "." CR>)>)
		      (<NOT <EQUAL? <SET PCOR <CORRIDOR-LOOK .OWHERE .NCAR>>
				    ,FALSE-VALUE ,PLAYER-NOT-FACING>>
		       <SET VAL T>
		       <WHERE? .PERSON .PCOR T>
		       ;<TELL "To ">
		       ;<DIR-PRINT .PCOR>
		       <TELL HE .PERSON>
		       <COND (<AND <IN? ,BRIEFCASE .PERSON>
				   <NOT <FSET? ,BRIEFCASE ,SEENBIT>>>
			      <FSET ,BRIEFCASE ,SEENBIT>
			      <TELL ", carrying" HIM ,BRIEFCASE ",">)>
		       ;<HE-SHE-IT .PERSON -1 "appear">
		       <TELL V .PERSON appear>
		       <SET DIR <DIR-FROM .OWHERE .OL>>
		       <COND (<NOT <EQUAL? .DIR ,P?IN>>
			      <TELL " from">
			      <TELL-THE-NOT-OTHER .OL>
			      ;<DIR-PRINT .DIR>)>
		       <TELL "." CR>)>)>
	<COND (<ZERO? .PERSON> <TELL "[PERSON=0!]" CR>)
	      (T
	       <COND (<ON-PLATFORM? .WHERE>
		      <PUTP .PERSON ,P?CAR <GETP .WHERE ,P?CAR>>)>
	       <MOVE .PERSON .WHERE>)>
	<COND (<NOT <==? .PERSON ,PLAYER>>
	       ;<FCLEAR .PERSON ,TOUCHBIT>
	       <COND (<OR <==? .PERSON ,PEEKER>
			  <AND <==? .PERSON ,BAD-SPY>
			       <NOT ,BAD-SPY-DONE-PEEKING>>>
		      <PUTP .PERSON ,P?LDESC ,PEEKING-CODE>)
		     (<NOT <EQUAL? .PERSON ,CONDUCTOR ,CUSTOMS-AGENT>>
		      <PUTP .PERSON ,P?LDESC 14 ;"walking along">)>)>
	<COND (.GT
	       <COND (<==? <GET .GT ,GOAL-F> ;.OWHERE .WHERE>
		      <SET VAL <GOAL-REACHED .PERSON>>
		      <COND (<AND <NOT .VAL>
				  <NOT <==? ,I-WALK-TRAIN
					    <GET .GT ,GOAL-FUNCTION>>>
				  <==? ,HERE .WHERE ;.OWHERE>
				  <NOT <FSET? .PERSON ,NDESCBIT ;INVISIBLE>>>
			     <SET VAL T ;,M-FATAL>
			     ;<HE-SHE-IT .PERSON 1 "stop">
			     <TELL CHE .PERSON stop " here." CR>)>)
		     (T
		      <SETG GOAL-PERSON .PERSON>
		      <SET VAL <D-APPLY "Enroute" <GET .GT ,GOAL-FUNCTION>
						  ,G-ENROUTE>>)>)>
	<COND (,DEBUG
	       <TELL "[">
	       ;<TELL THE .PERSON" just went into (car #"N .NCAR")"THE .WHERE>
	       ;<COND (<ON-PLATFORM? .WHERE>
		      <TELL " (" N <GETP .WHERE ,P?CAR> ")">)>
	       <TELL-$WHERE .PERSON .WHERE>
	       <TELL "]" CR>)>
	<COND (.VAL <THIS-IS-IT .PERSON>)>
	.VAL>

<ROUTINE DIR-FROM (HERE THERE "AUX" (V <>) P D)
 <SET P <ON-PLATFORM? .HERE>>
 <SET D <ON-PLATFORM? .THERE>>
 <COND (<AND .P .D>
	<COND (<L? .P .D> <RETURN ,P?SOUTH>)
	      (<G? .P .D> <RETURN ,P?NORTH>)
	      (T <RFALSE>)>)
       (<AND <EQUAL? .THERE ,ROOF ,OTHER-ROOF>
	     <OR <EQUAL? .HERE  ,VESTIBULE-REAR-FANCY>
		 <EQUAL? .HERE  ,VESTIBULE-REAR ,VESTIBULE-REAR-DINER
				,OTHER-VESTIBULE-REAR>>>
	<RETURN ,P?UP>)
       (<AND <EQUAL? .HERE  ,ROOF ,OTHER-ROOF>
	     <OR <EQUAL? .THERE ,VESTIBULE-REAR-FANCY>
		 <EQUAL? .THERE ,VESTIBULE-REAR ,VESTIBULE-REAR-DINER
				,OTHER-VESTIBULE-REAR>>>
	<RETURN ,P?DOWN>)
       (<AND <OR .P <EQUAL? .HERE  ,BESIDE-TRACKS ,OTHER-BESIDE-TRACKS>>
	     <OR <EQUAL? .THERE ,VESTIBULE-REAR-FANCY>
		 <EQUAL? .THERE ,VESTIBULE-REAR ,VESTIBULE-REAR-DINER
				,OTHER-VESTIBULE-REAR>>>
	<RETURN ,P?UP>)
       (<AND <OR .D <EQUAL? .THERE ,BESIDE-TRACKS ,OTHER-BESIDE-TRACKS>>
	     <OR <EQUAL? .HERE  ,VESTIBULE-REAR-FANCY>
		 <EQUAL? .HERE  ,VESTIBULE-REAR ,VESTIBULE-REAR-DINER
				,OTHER-VESTIBULE-REAR>>>
	<RETURN ,P?DOWN>)
       (<OR <AND <EQUAL? .HERE ,VESTIBULE-FWD-DINER
			       ,VESTIBULE-FWD-FANCY ,VESTIBULE-FWD>
		 <OR <EQUAL? .THERE ,VESTIBULE-REAR-FANCY ,VESTIBULE-REAR>
		     <EQUAL? .THERE ,VESTIBULE-REAR-DINER
				    ,OTHER-VESTIBULE-REAR>
		     <EQUAL? .THERE ,LIMBO-FWD-DINER
				    ,LIMBO-FWD-FANCY ,LIMBO-FWD>>>
	    <AND <EQUAL?  .HERE ,OTHER-VESTIBULE-FWD>
		 <EQUAL? .THERE ,OTHER-LIMBO-FWD>>>
	<RETURN ,P?NORTH>)
       (<OR <AND <EQUAL? .HERE ,VESTIBULE-REAR-DINER
			       ,VESTIBULE-REAR-FANCY ,VESTIBULE-REAR>
		 <OR <EQUAL? .THERE ,VESTIBULE-FWD-FANCY ,VESTIBULE-FWD>
		     <EQUAL? .THERE ,VESTIBULE-FWD-DINER ,OTHER-VESTIBULE-FWD>
		     <EQUAL? .THERE ,LIMBO-REAR-DINER
				    ,LIMBO-REAR-FANCY ,LIMBO-REAR>>>
	    <AND <EQUAL?  .HERE ,OTHER-VESTIBULE-REAR>
		 <EQUAL? .THERE ,OTHER-LIMBO-REAR>>>
	<RETURN ,P?SOUTH>)>
 <COND (<DIR-FROM-TEST .HERE .THERE ,P?IN>  <RETURN ,P?IN>)
       (<DIR-FROM-TEST .HERE .THERE ,P?OUT> <RETURN ,P?OUT>)>
 <SET P 0>
 <REPEAT ()
	 <COND (<L? <SET P <NEXTP .HERE .P>> ,LOW-DIRECTION>
		<RETURN .V>)
	       (<SET D <DIR-FROM-TEST .HERE .THERE .P>>
		<COND (<AND <L? .D ,LOW-DIRECTION> <NOT .V>>
		       <SET V .P>)
		      (T <RETURN .P>)>)>>>

<ROUTINE DIR-FROM-TEST (HERE THERE P "AUX" L TBL)
	<COND (<ZERO? <SET TBL <GETPT .HERE .P>>>
	       <RFALSE>)>
	<SET L <PTSIZE .TBL>>
	<COND (<AND <EQUAL? .L ,DEXIT ,UEXIT ,CEXIT>
		    <==? <GET-REXIT-ROOM .TBL> .THERE>>
	       <RETURN .P>)
	      ;(<EQUAL? .L ,FEXIT>
	       <RTRUE>)>>

<ROUTINE I-FOLLOW ("OPTIONAL" (GARG <>) "AUX" (FLG <>) (CNT 0) GT VAL)
	 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		<TELL "[I-FOLLOW:">
		<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX>
			<RETURN>)
		       (<AND <GET <SET GT <GET ,GOAL-TABLES .CNT>> ,GOAL-S>
			     <OR <NOT <ZERO? <GET .GT ,GOAL-ENABLE>>>
				 ;<0? <GET .GT ,ATTENTION>>>>
			;<PUT .GT ,GOAL-ENABLE 1>
			<COND (<SET VAL
				    <FOLLOW-GOAL <GET ,CHARACTER-TABLE .CNT>>>
			       <COND (<NOT <==? .FLG ,M-FATAL>>
				      ;<TELL
"[!! CHAR=" D <GET ,CHARACTER-TABLE .CNT> ", CNT=" N .CNT "]" CR>
				      <SET FLG .VAL>)>)>)>>
	 <COND (,IDEBUG <TELL N .FLG "]" CR>)>
	 .FLG>

<ROUTINE I-PLAYER (ARG "AUX" VAL)
  ;<SETG LAST-PLAYER-LOC ,HERE>
  <SETG HERE <LOC ,PLAYER>>
  <COND (<ZMEMQ ,HERE ,STATION-ROOMS>
	 <NEXT-CAR-SWITCHEROO ,CAR-HERE <GETP ,HERE ,P?CAR>>)>
  <COND (<==? .ARG ,G-ENROUTE>
	 <SET VAL <FIND-FLAG-HERE-NOT ,PERSONBIT ,NDESCBIT ,PLAYER>>
	 <COND (<AND .VAL
		     <OR <==? ,NOW-LURCHING ,PRESENT-TIME> <PROB 50>>>
		<COND (<ZERO? <GETP .VAL ,P?LDESC>>
		       <NEW-LDESC .VAL>)>
		<COND (<DIR-FROM ,HERE ,LAST-PLAYER-LOC>
		       <TELL "You have just started walking, when">)
		      (T <TELL
"You walk along as far as" THE ,HERE ", where">)>
		<COND (<==? ,NOW-LURCHING ,PRESENT-TIME>
		       <COND (<==? .VAL ,PICKPOCKET> <PICK-POCKET .VAL>)>
		       <TELL
" the train lurches, and" HE .VAL bump " into you." CR>)
		      (T
		       <TELL HE .VAL get " in your way." CR>)>
		;<TELL " at this point." CR>)
	       (T
		;<TELL "(" D ,HERE ")" CR>
		;<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
		<RFALSE>)>)
	(<==? .ARG ,G-REACHED>
	 <RTRUE>)>>

<ROUTINE PICK-POCKET (PER "AUX" X Y)
	<COND (<L? 2 <CCOUNT ,PLAYER>> ;<PROB 20>
	       <COND (<NOT <SET X <FIRST? ,PLAYER>>>
		      <RFALSE>)>)
	      (T
	       <COND (<NOT <SET X <FIRST? ,POCKET>>>
		      <PUTP ,PLAYER ,P?SOUTH 0>
		      <RFALSE>)>)>
	<COND (<SET Y <NEXT? .X>>
	       <SET X .Y>)>
	<COND (<AND <NOT <EQUAL? .X ,BRIEFCASE>>
		    <NOT <FSET? .X ,WORNBIT>>>
	       <FSET .X ,NDESCBIT>
	       <MOVE .X .PER>)>>

<ROUTINE I-LEAVE-TRAIN ("OPTIONAL" (GARG <>) "AUX" (VAL <>) X)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-LEAVE-TRAIN:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <SET X ,LEAVE-TRAIN-PERSON>
 <COND (<ZERO? .X>
	<SET VAL <LEAVE-TRAIN ,VESTIBULE-REAR>>
	<COND (<LEAVE-TRAIN ,VESTIBULE-REAR-DINER>
	       <SET VAL T>)>
	<COND (<LEAVE-TRAIN ,VESTIBULE-REAR-FANCY>
	       <SET VAL T>)>
	<COND (<LEAVE-TRAIN ,OTHER-VESTIBULE-REAR>
	       <SET VAL T>)>)
       (T
	<COND (<==? -1 .X> <SET X <GETP ,BAD-SPY ,P?CAR>>)
	      (T <SET X <GETP .X ,P?CAR>>)>
	<COND (,IN-STATION
	       <SET VAL <GET ,STATION-ROOMS .X>>)	;"? CAR-MAX"
	      (<==? .X ,CAR-HERE>
	       <SET VAL ,BESIDE-TRACKS>)
	      (T <SET VAL ,OTHER-BESIDE-TRACKS>)>
	<COND (<==? -1 ,LEAVE-TRAIN-PERSON>
	       <SET VAL <MOVE-PERSON ,BAD-SPY <V-REAR .X>>>)
	      (T
	       <SET VAL <MOVE-PERSON ,LEAVE-TRAIN-PERSON .VAL>>)>)>
 <COND (,IDEBUG <TELL N .VAL "]" CR>)>
 .VAL>

<GLOBAL LEAVE-TRAIN-PERSON <>>

<ROUTINE LEAVE-TRAIN (RM "AUX" PER NXT (VAL <>))
 <SET PER <FIRST? .RM>>
 <REPEAT ()
	<COND (<ZERO? .PER> <RETURN .VAL>)
	      (<OR <NOT <FSET? .PER ,PERSONBIT>>
		   <FSET? .PER ,MUNGBIT>
		   <NOT <==? ,G-LEAVE-TRAIN
			     <GET <GT-O .PER> ,GOAL-FUNCTION>>>>
	       <SET PER <NEXT? .PER>>
	       <AGAIN>)
	      (T
	       <SET NXT <NEXT? .PER>>
	       <COND (<MOVE-PERSON .PER<GET ,STATION-ROOMS<GETP .PER ,P?CAR>>>
		      <SET VAL T>)>
	       <SET PER .NXT>)>>>

<ROUTINE G-LEAVE-TRAIN ("OPTIONAL" (GARG <>) "AUX" L (VAL <>) P GT)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[G-LEAVE-TRAIN:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <SET L <LOC ,GOAL-PERSON>>
 <COND (<==? .GARG ,G-REACHED>
	<COND (<OR <EQUAL? .L ,VESTIBULE-REAR-FANCY ,VESTIBULE-REAR-DINER>
		   <EQUAL? .L ,VESTIBULE-REAR ,OTHER-VESTIBULE-REAR>>
	       <SET P <GETP ,GOAL-PERSON ,P?CAR>>
	       <COND (<G? .P ,PLATFORM-MAX> <SET P ,PLATFORM-MAX>)>
	       ;<SET VAL <MOVE-PERSON ,GOAL-PERSON <GET ,STATION-ROOMS .P>>>
	       ;<SETG LEAVE-TRAIN-PERSON ,GOAL-PERSON>
	       <ENABLE <QUEUE I-LEAVE-TRAIN 1>>
	       <SET GT <GT-O ,GOAL-PERSON>>
	       <COND (<EQUAL? <GET .GT ,GOAL-SCRIPT>
			      ,I-TRAVELER-FINDS-CONTACT>
		      ;<AND <SPY?>
			   <EQUAL? ,GOAL-PERSON ,BAD-SPY>
			   <EQUAL? ,SCENERY-OBJ ,STATION-FRBZ ,STATION-GOLA>>
		      <PUT .GT ,GOAL-FUNCTION ,I-TRAVELER-FINDS-CONTACT>
		      <ESTABLISH-GOAL ,GOAL-PERSON ,PLATFORM-A ;2>
		      <I-TRAVELER-FINDS-CONTACT ,G-ENROUTE>)
		    (T<ESTABLISH-GOAL ,GOAL-PERSON ,PLATFORM-B ;2>)>)
	      (<EQUAL? .L ,PLATFORM-B>
	       <COND (<VISIBLE? ,GOAL-PERSON>
		      <SET VAL T>
		      <TELL
CHE ,GOAL-PERSON show HIS ,GOAL-PERSON " passport ">
		      <COND (<IN? ,BRIEFCASE ,GOAL-PERSON>
			     <TELL "and the briefcase ">)>
		      <TELL "to" HIM ,CUSTOMS-AGENT "." CR>)>
	       <ESTABLISH-GOAL ,GOAL-PERSON ,PLATFORM-A ;2>)
	      (<EQUAL? .L ,PLATFORM-A>
	       <PUTP ,GOAL-PERSON ,P?CAR 1>
	       <SET VAL <MOVE-PERSON ,GOAL-PERSON <V-REAR 1>>>
	       <SET P <GETP ,GOAL-PERSON ,P?CHARACTER>>
	       <COND (<AND <SPY?> <EQUAL? .P ,BAD-SPY-C>>
		      <PUT <GET ,GOAL-TABLES ,BAD-SPY-C>
			   ,GOAL-SCRIPT
			   ,I-TRAVELER-PASSED-CUSTOMS>)>
	       <ESTABLISH-GOAL-TRAIN ,GOAL-PERSON
				     <GET ,CHAR-LOCS .P>
				     <GET ,CHAR-CARS .P>>)
	      (T
	       <TELL "[!! LEAVE-TRAIN GOAL? ">
	       <TELL-$WHERE ,GOAL-PERSON .L>
	       ;<TELL D ,GOAL-PERSON "@" D .L>
	       <TELL "]" CR>
	       <SET VAL T>)>)>
 <COND (,IDEBUG <TELL N .VAL "]" CR>)>
 .VAL>

<ROUTINE I-WALK-TRAIN ("OPTIONAL" (GARG <>)
		       "AUX" L CAR CARH FCN (VAL <>) GT GOAL)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-WALK-TRAIN:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <SET L <LOC ,GOAL-PERSON>>
 <SET GT <GT-O ,GOAL-PERSON>>
 <SET FCN <GET .GT ,GOAL-SCRIPT>>
 <SET CAR <GET .GT ,GOAL-CAR>>
 <SET GOAL <GET .GT ,GOAL-QUEUED>>
 <COND (<==? .GARG ,G-ENROUTE>
	<SET VAL <D-APPLY "Enroute" .FCN ,G-ENROUTE>>)
       (<==? .GARG ,G-REACHED>
	<SET CARH <GETP ,GOAL-PERSON ,P?CAR>>
	<COND (<OR <EQUAL? .L ,LIMBO-FWD-FANCY ,LIMBO-FWD>
		   <EQUAL? .L ,LIMBO-FWD-DINER ,OTHER-LIMBO-FWD>>
	       <SET CARH <- .CARH 1>>
	       <PUTP ,GOAL-PERSON ,P?CAR .CARH>
	       <OBJ-TO-NEXT ,GOAL-PERSON .CARH>
	       <MOVE ,GOAL-PERSON <V-REAR .CARH>>
	       ;<SET VAL <MOVE-PERSON ,GOAL-PERSON <V-REAR ;L-REAR .CARH> T>>
	       <COND (<==? .CAR .CARH>
		      ;<PUT .GT ,GOAL-FUNCTION .FCN>
		      <COND (<EQUAL? .GOAL ,VESTIBULE-REAR-DINER
					   ,VESTIBULE-REAR-FANCY
					   ,VESTIBULE-REAR>
			     <SET GOAL <V-REAR .CARH>>)
			    (<EQUAL? .GOAL ,VESTIBULE-FWD-DINER
					   ,VESTIBULE-FWD-FANCY
					   ,VESTIBULE-FWD>
			     <SET GOAL <V-FWD .CARH>>)
			    (<NOT <EQUAL? .CARH
					  ,DINER-CAR ,FANCY-CAR ,CAR-HERE>>
			     <SET GOAL <GETP .GOAL ,P?OTHER>>)>
		      <ESTABLISH-GOAL ,GOAL-PERSON .GOAL 2>)
		     (T
		      <ESTABLISH-GOAL ,GOAL-PERSON <L-FWD .CARH> 1>)>
	       ;.VAL)
	      (<OR <EQUAL? .L ,LIMBO-REAR-FANCY ,LIMBO-REAR>
		   <EQUAL? .L ,LIMBO-REAR-DINER ,OTHER-LIMBO-REAR>>
	       <SET CARH <+ .CARH 1>>
	       <PUTP ,GOAL-PERSON ,P?CAR .CARH>
	       <OBJ-TO-NEXT ,GOAL-PERSON .CARH>
	       <MOVE ,GOAL-PERSON <V-FWD .CARH>>
	       ;<SET VAL <MOVE-PERSON ,GOAL-PERSON <V-FWD ;L-FWD .CARH> T>>
	       <COND (<==? .CAR .CARH>
		      ;<PUT .GT ,GOAL-FUNCTION .FCN>
		      <COND (<EQUAL? .GOAL ,VESTIBULE-REAR-DINER
					   ,VESTIBULE-REAR-FANCY
					   ,VESTIBULE-REAR>
			     <SET GOAL <V-REAR .CARH>>)
			    (<EQUAL? .GOAL ,VESTIBULE-FWD-DINER
					   ,VESTIBULE-FWD-FANCY
					   ,VESTIBULE-FWD>
			     <SET GOAL <V-FWD .CARH>>)
			    (<NOT <EQUAL? .CARH
					  ,DINER-CAR ,FANCY-CAR ,CAR-HERE>>
			     <SET GOAL <GETP .GOAL ,P?OTHER>>)>
		      <ESTABLISH-GOAL ,GOAL-PERSON .GOAL 2>)
		     (T
		      <ESTABLISH-GOAL ,GOAL-PERSON <L-REAR .CARH> 1>)>
	       ;.VAL)
	      (T
	       <TELL "[!! WALK-TRAIN GOAL? ">
	       ;<TELL D ,GOAL-PERSON "@" D .L ", car #" N .CARH>
	       <TELL-$WHERE ,GOAL-PERSON .L>
	       <TELL "]" CR>
	       <SET VAL T>)>)>
 <COND (,IDEBUG <TELL N .VAL "]" CR>)>
 .VAL>

<ROUTINE OBJ-TO-NEXT (OBJ CAR "AUX" F N)
	<SET F <FIRST? .OBJ>>
	<REPEAT ()
	 <COND (.F <SET N <NEXT? .F>>)
	       (T <RETURN>)>
	 <COND (<GETP .F ,P?CAR>
		;<OR <FSET? .F ,TAKEBIT> <FSET? .F ,TRYTAKEBIT>>
		<PUTP .F ,P?CAR .CAR>
		<COND (<FIRST? .F>
		       <OBJ-TO-NEXT .F .CAR>)>)>
	 <SET F .N>>>

<GLOBAL LAST-EXTRA-LOC <>>

<ROUTINE I-EXTRA ("OPTIONAL" (GARG <>) "AUX" DEST NCAR EXTRA L VL VLEL)
	 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		<TELL "[I-EXTRA:">
		<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
	 <SET EXTRA <GET ,CHARACTER-TABLE ,EXTRA-C>>
	 <SET L <LOC .EXTRA>>
	 <SET VL <VISIBLE? .L>>
	 <COND (<AND <ZERO? .GARG>
		     <NOT <==? ,CLERK .EXTRA>>>
		<COND (<NOT ,ON-TRAIN>	;<ON-PLATFORM? ,HERE>
		       <ENABLE <QUEUE I-EXTRA 1>>
		       <COND (,IDEBUG <TELL "0]" CR>)>
		       <RFALSE>)>
		<SET NCAR <+ ,CAR-HERE <- <* 2 <RANDOM 2>> 3>>>	;"+-1"
		<COND (<==? .NCAR ,FANCY-CAR>	<DEC NCAR>)>
		<COND (<L? .NCAR 1>		<SET NCAR 1>)
		      (<G? .NCAR ,CAR-MAX>	<SET NCAR ,CAR-MAX>)>
		<COND (<==? .NCAR ,DINER-CAR>
		       <SET DEST <PICK-ONE-BOOTH>>)
		      (T
		       <SET DEST <PICK-ONE ,CAR-ROOMS-COMPS>>)>
		<COND (<OR ,DEBUG ,IDEBUG>
		       <TELL
"[GOAL: " D .EXTRA " at " D .L " (car #" N <GETP .EXTRA ,P?CAR>
") to " D .DEST " (car #" N .NCAR ").]" CR>)>
		<COND (<AND <==? .NCAR ,GAS-CAR> <==? .DEST ,GAS-CAR-RM>>
		       <SET DEST ,COMPARTMENT-4>)>
		<PUT <GET ,GOAL-TABLES ,EXTRA-C> ,GOAL-ENABLE 1>
		<ESTABLISH-GOAL-TRAIN .EXTRA .DEST .NCAR>
		<COND (,IDEBUG <TELL "0]" CR>)>
		<RFALSE>)
	       (T
		<COND (<==? .GARG ,G-ENROUTE>
		       <COND (<EQUAL? .L ,HERE>
			      <SETG LAST-EXTRA-LOC .L>
			      <COND (,IDEBUG
				     <TELL "(EXTRA HERE)">
				     <TELL "1]" CR>)>
			      <RTRUE>)>
		       <SET VLEL <VISIBLE? ,LAST-EXTRA-LOC>>
		       <COND (<AND .VL <NOT .VLEL>>
			      <SETG LAST-EXTRA-LOC .L>
			      <COND (,IDEBUG
				     <TELL "(EXTRA NOW VISIBLE)">
				     <TELL "1]" CR>)>
			      <RTRUE>)
			     (<AND <NOT .VL> .VLEL>
			      <SETG LAST-EXTRA-LOC .L>
			      <COND (,IDEBUG
				     <TELL "(EXTRA NOT VISIBLE)">
				     <TELL "1]" CR>)>
			      <RTRUE>)
			     (T
			      <SETG LAST-EXTRA-LOC .L>
			      <COND (,IDEBUG <TELL "0]" CR>)>
			      <RFALSE>)>)
		      (<==? .GARG ,G-REACHED>
		       <SET EXTRA <GET ,CHARACTER-TABLE ,EXTRA-C>>
		       <NEW-LDESC .EXTRA>)>
		<COND (<==? ,CAR-HERE ,DINER-CAR>
		       <SET DEST <PICK-ONE-BOOTH>>)
		      (T
		       <SET DEST <PICK-ONE ,CAR-ROOMS-COMPS>>)>
		<SET EXTRA <CALL-FOR-EXTRA .DEST ,CAR-HERE .EXTRA>>
		<COND (.EXTRA
		       <SETG LAST-EXTRA-LOC .DEST>
		       <PUT	   ,CHARACTER-TABLE ,EXTRA-C .EXTRA>
		       <PUT ,GLOBAL-CHARACTER-TABLE ,EXTRA-C .EXTRA>
		       <ENABLE <QUEUE I-EXTRA 1>>)
		      (T
		       <ENABLE <QUEUE I-EXTRA 5>>)>
		<COND (,IDEBUG <TELL N .VL "]" CR>)>
		.VL)>>

<GLOBAL LAST-STAR-LOC 0>

<ROUTINE I-STAR ("OPTIONAL" (GARG <>) "AUX" DEST NCAR STAR L VL VLEL)
	 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		<TELL "[I-STAR:">
		<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
	 <SET STAR ,STAR-C>
	 <COND (<ZERO? .STAR>
		<SET STAR <PICK-ONE-NOT ,SPY-TABLE ,BAD-SPY ,PEEKER>>
		<SETG STAR-C <GETP .STAR ,P?CHARACTER>>)
	       (T
		<SET STAR <GET ,CHARACTER-TABLE .STAR>>)>
	 <SET L <LOC .STAR>>
	 <SET VL <VISIBLE? .L>>
	 <COND (<ZERO? .GARG>
		<COND (<NOT ,ON-TRAIN>
		       <ENABLE <QUEUE I-STAR 1>>
		       <COND (,IDEBUG <TELL "0]" CR>)>
		       <RFALSE>)>
		<SETG LAST-STAR-LOC .L>
		<COND (<NOT <EQUAL? ,DINER-CAR <GETP .STAR ,P?CAR>>>
		       <SET NCAR ,DINER-CAR>)
		      (<L? ,CAR-HERE ,DINER-CAR>
		       <SET NCAR <- ,CAR-HERE 1>>)
		      (T
		       <SET NCAR <+ ,CAR-HERE 1>>)>
		<COND (<==? .NCAR ,FANCY-CAR>	<DEC NCAR>)>
		<COND (<L? .NCAR 1>		<SET NCAR 1>)
		      (<G? .NCAR ,CAR-MAX>	<SET NCAR ,CAR-MAX>)>
		<COND (<==? .NCAR ,DINER-CAR>
		       <SET DEST <PICK-ONE-BOOTH>>)
		      (T
		       <SET DEST <PICK-ONE ,CAR-ROOMS-COMPS>>)>
		<COND (<AND <==? .NCAR ,GAS-CAR> <==? .DEST ,GAS-CAR-RM>>
		       <SET DEST ,COMPARTMENT-4>)>
		<COND (<OR ,DEBUG ,IDEBUG>
		       <TELL
"[GOAL: " D .STAR " at " D .L " (car #" N <GETP .STAR ,P?CAR>
") to " D .DEST " (car #" N .NCAR ").]" CR>)>
		<PUT <GT-O .STAR> ,GOAL-ENABLE 1>
		<ESTABLISH-GOAL-TRAIN .STAR .DEST .NCAR>
		<COND (,IDEBUG <TELL "0]" CR>)>
		<RFALSE>)
	       (T
		<COND (<==? .GARG ,G-ENROUTE>
		       <COND (<EQUAL? .L ,HERE>
			      <SETG LAST-STAR-LOC .L>
			      <COND (,IDEBUG
				     <TELL "(STAR HERE)">
				     <TELL "1]" CR>)>
			      <RTRUE>)>
		       <SET VLEL <VISIBLE? ,LAST-STAR-LOC>>
		       <COND (<AND .VL <NOT .VLEL>>
			      <SETG LAST-STAR-LOC .L>
			      <COND (,IDEBUG
				     <TELL "(STAR NOW VISIBLE)">
				     <TELL "1]" CR>)>
			      <RTRUE>)
			     (<AND <NOT .VL> .VLEL>
			      <SETG LAST-STAR-LOC .L>
			      <COND (,IDEBUG
				     <TELL "(STAR NOT VISIBLE)">
				     <TELL "1]" CR>)>
			      <RTRUE>)
			     (T
			      <SETG LAST-STAR-LOC .L>
			      <COND (,IDEBUG <TELL "0]" CR>)>
			      <RFALSE>)>)
		      (<==? .GARG ,G-REACHED>
		       <SET STAR <GET ,CHARACTER-TABLE ,STAR-C>>
		       <NEW-LDESC .STAR>
		       <SETG STAR-C 0>
		       <ENABLE <QUEUE I-STAR <RANDOM 9>>>)>
		<COND (,IDEBUG <TELL N .VL "]" CR>)>
		.VL)>>

<ROUTINE PICK-ONE-NOT (TBL "OPTIONAL" (NOT1 <>) (NOT2 <>) "AUX" L CNT X)
	<SET L <GET .TBL 0>>
	<SET CNT <RANDOM .L>>
	<REPEAT ()
		<SET X <GET .TBL .CNT>>
		<COND (<NOT <EQUAL? .X .NOT1 .NOT2>>
		       <RETURN .X>)
		      (<IGRTR? CNT .L>
		       <SET CNT 1>)>>>

<ROUTINE STOP-CONDUCTOR? ("AUX" L (LL <>) X)
	<SET L <LOC ,CONDUCTOR>>
	<COND (<OR <SET X <GETPT .L ,P?IN>>
		   <SET X <GETPT .L ,P?OUT>>>
	       <SET LL <GET-REXIT-ROOM .X>>)>
	<COND (<SET X <ANY-TICKETS? .L ,PERSONBIT>>
	       <RETURN .X>)
	      (<SET X <ANY-TICKETS? .L ,MUNGBIT>>
	       <RETURN .X>)
	      (<AND <NOT <ZERO? .LL>>
		    <SET X <ANY-TICKETS? .LL ,PERSONBIT>>>
	       <RETURN .X>)
	      (<AND <NOT <ZERO? .LL>>
		    <SET X <ANY-TICKETS? .LL ,MUNGBIT>>>
	       <RETURN .X>)
	      (<AND ,TICKETS-PUNCHED? <NOT ,CUSTOMS-SWEEP>>
	       <RFALSE>)
	      (<NOT ,ON-TRAIN>
	       <RFALSE>)
	      (<SET X <ANY-TICKETS? .L>>
	       <RETURN .X>)
	      (<NOT <ZERO? .LL>>
	       <RETURN <ANY-TICKETS? .LL>>)>>

<GLOBAL VICTIM-KNOWN <>>

<ROUTINE I-CONDUCTOR ("OPTIONAL" (GARG <>) "AUX" L OBJ DEST X Y)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-CONDUCTOR:">
	<COND (<==? .GARG ,G-DEBUG>
	       ;<COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)>
 <SET L <LOC ,CONDUCTOR>>
 <COND (<NOT .GARG>
	<ESTABLISH-GOAL-TRAIN ,CONDUCTOR ,VESTIBULE-REAR ,CAR-MAX>
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)
       (<==? .GARG ,G-REACHED>
	<COND (<EQUAL? .L ,PLATFORM-A>
	       <FSET ,CONDUCTOR ,NDESCBIT>
	       <FCLEAR ,CONDUCTOR ,TOUCHBIT>
	       <PUTP ,CONDUCTOR ,P?LDESC 15 ;"waiting for the train to start">
	       <COND (<ON-PLATFORM? ,HERE>
		      <TELL CHE ,CONDUCTOR " stops walking." CR>
		      <COND (,IDEBUG <TELL "(1)]" CR>)>
		      <RTRUE>)
		     (T
		      <COND (,IDEBUG <TELL "(0)]" CR>)>
		      <RFALSE>)>)
	      (<EQUAL? .L ,VESTIBULE-FWD ,OTHER-VESTIBULE-FWD>
	       <ESTABLISH-GOAL-TRAIN ,CONDUCTOR ,VESTIBULE-REAR ,CAR-MAX>
	       <SET X <TURNS-AROUND? .L ,VESTIBULE-FWD>>
	       <COND (,IDEBUG <TELL N .X "]" CR>)>
	       <RETURN .X>)
	      (<EQUAL? .L ,VESTIBULE-REAR ,OTHER-VESTIBULE-REAR>
	       <COND (<I-CONDUCTOR ,G-ENROUTE>
		      <COND (,IDEBUG <TELL "(1)]" CR>)>
		      <RTRUE>)>
	       <SETG TICKETS-PUNCHED? T>
	       <QUEUE I-TICKETS-PLEASE 0>
	       <ESTABLISH-GOAL-TRAIN ,CONDUCTOR ,VESTIBULE-FWD 1>
	       <SET X <TURNS-AROUND? .L ,VESTIBULE-REAR>>
	       <COND (,IDEBUG <TELL N .X "]" CR>)>
	       <RETURN .X>)
	      (T
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)
       (<==? .GARG ,G-ENROUTE>
	<COND (<SET Y <STOP-CONDUCTOR?>>;"need to merge with I-TICKETS-PLEASE"
	       <PUT <GET ,GOAL-TABLES ,CONDUCTOR-C> ,GOAL-ENABLE 0>
	       <SET X <VISIBLE? ,CONDUCTOR T>>
	       <COND (<NOT <FSET? .Y ,PERSONBIT>>
		      <MOVE .Y ,LIMBO-FWD>
		      <SETG VICTIM-KNOWN .Y>)
		     (<FSET? .Y ,MUNGBIT>
		      <QUEUE I-COME-TO 1>)>
	       <COND (<OR ,DEBUG
			  <NOT <EQUAL? .X ,FALSE-VALUE ,PLAYER-NOT-FACING>>>
		      <COND (<EQUAL? .X ,FALSE-VALUE ,PLAYER-NOT-FACING>
			     <TELL "[">)>
		      <TELL CHE ,CONDUCTOR>
		      <COND (<AND .X <WHERE? ,CONDUCTOR>>
			     <PRINTC %<ASCII !\,>>)>
		      <TELL " stops ">
		      <COND (<IN? ,CONDUCTOR ,HERE> <TELL "here ">)>
		      <TELL "to ">
		      <COND (<NOT <FSET? .Y ,PERSONBIT>>
			     <TELL "remove" HIS .Y " body.">
			     <THIS-IS-IT .Y>
			     <COND (<EQUAL? .L ,HERE>
				    <ARREST-PLAYER "homicide"
						   ,CONDUCTOR T ,PLAYER>)>)
			    (<FSET? .Y ,MUNGBIT>
			     <TELL "try to revive" HIM .Y ".">
			     <THIS-IS-IT .Y>)
			    (,CUSTOMS-SWEEP
			     ;<THIS-IS-IT ,TRAIN>
			     <TELL "ask passengers to leave the train.">)
			    (T
			     ;<THIS-IS-IT ,TICKET>
			     <TELL "punch tickets.">)>
		      <CRLF>
		      <COND (,IDEBUG <TELL "(1)]" CR>)>
		      <RTRUE>)>)>
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)>>

<ROUTINE TURNS-AROUND? (L RM)
	<COND (<AND <==? ,HERE .RM>
		    ;<==? ,CAR-HERE <GETP ,CONDUCTOR ,P?CAR>>
		    <==? .L .RM>>
	       <TELL CHE ,CONDUCTOR appear " and turns around." CR>
	       <RTRUE>)>>

<ROUTINE WHERE? (PER "OPTIONAL" (X 0) (CAP 0))
	<COND (<NOT <IN? .PER ,HERE>>
	       <COND (<ZERO? .X>
		      <PRINTC %<ASCII !\,>>
		      <SET X <CORRIDOR-LOOK .PER ,CAR-HERE>>
		      ;<SET X <COR-DIR ,HERE <LOC .PER> <GETP .PER ,P?CAR>>>)>
	       <COND (<ZERO? .CAP> <PRINTC 32>)>
	       <COND (<EQUAL? .X ,P?WEST ,P?IN>
		      <COND (<ZERO? .CAP> <TELL "in">) (T <TELL "In">)>
		      <TELL THE <LOC .PER>>)
		     (<EQUAL? .X ,P?EAST ,P?OUT>
		      <COND (<ZERO? .CAP> <PRINTC %<ASCII !\j>>)
			    (T		  <PRINTC %<ASCII !\J>>)>
		      <TELL "ust outside">)
		     (T
		      <COND (<ZERO? .CAP> <PRINTC %<ASCII !\o>>)
			    (T		  <PRINTC %<ASCII !\O>>)>
		      <TELL "ff to ">
		      <DIR-PRINT .X>)>
	       <RTRUE>)>>

<GLOBAL CONDUCTOR-KNOWS <>>

<ROUTINE ANY-TICKETS? (L "OPTIONAL" (BIT <>) "AUX" O (VAL <>) CAR)
	<COND (<ZERO? .BIT> <SET BIT ,LOCKED>)>
	<SET CAR <GETP ,CONDUCTOR ,P?CAR>>
	<COND (<AND <==? .L <META-LOC ,PLAYER>>
		    <==? .CAR ,CAR-HERE>
		    <OR ,CUSTOMS-SWEEP
			<AND <NOT <==? .BIT ,PERSONBIT>>
			     <FSET? ,PLAYER .BIT>>>>
	       <RETURN ,PLAYER>)
	      (<AND <==? .L ,GAS-CAR-RM>
		    <==? .CAR ,GAS-CAR>
		    <OR ,CUSTOMS-SWEEP <NOT ,TICKETS-PUNCHED?>>>
	       <SETG CONDUCTOR-KNOWS ,BRIEFCASE>
	       <RFALSE>)>
	<SET O <FIRST? .L>>
	<REPEAT ()
		<COND (<NOT .O> <RETURN>)
		      (<AND <==? .CAR <GETP .O ,P?CAR>>
			    <OR <AND <==? .BIT ,PERSONBIT>
				     <NOT <ZERO? <GETP .O ,P?CHARACTER>>>
				     <NOT <FSET? .O ,PERSONBIT>>>
				<AND <NOT <==? .BIT ,PERSONBIT>>
				     <FSET? .O .BIT>
				     <FSET? .O ,PERSONBIT>>>>
		       <COND ;(<EQUAL? .O ,PLAYER>
			      <SET VAL .O>)
			     (<NOT .VAL>
			      <SET VAL .O>)>
		       <COND (<IN-MOTION? .O>
			      <PUT <GT-O .O> ,GOAL-ENABLE 0>)>)>
		<SET O <NEXT? .O>>>
	.VAL>

<ROUTINE I-WAITER ("OPTIONAL" (GARG <>) "AUX" L)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-WAITER:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <SET L <LOC ,WAITER>>
 <COND (<==? .GARG ,G-REACHED>
	<COND (<EQUAL? .L ,PANTRY>
	       <COND (<IN? ,FOOD ,WAITER>
		      <FCLEAR ,FOOD ,TAKEBIT>
		      <FSET ,FOOD ,NDESCBIT>
		      <MOVE ,FOOD ,PANTRY>)>
	       <COND (<IN? ,CUP-A ,WAITER>
		      <FCLEAR ,CUP-A ,TAKEBIT>
		      <MOVE ,CUP-A ,GLOBAL-OBJECTS>)>
	       <COND (<IN? ,CUP-B ,WAITER>
		      <FCLEAR ,CUP-B ,TAKEBIT>
		      <MOVE ,CUP-B ,GLOBAL-OBJECTS>)>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)
	      (<EQUAL? .L ,HERE>
	       <TELL CHE ,WAITER enter ", ready to take your order." CR>
	       <PUTP ,WAITER ,P?LDESC 25>
	       <COND (,IDEBUG <TELL "(2)]" CR>)>
	       <RFATAL>)
	      (T
	       <COND (<EQUAL? .L <META-LOC ,FOOD>>
		      <MOVE ,FOOD ,WAITER>)>
	       <COND (<EQUAL? .L <META-LOC ,CUP-A>>
		      <MOVE ,CUP-A ,WAITER>)>
	       <COND (<EQUAL? .L <META-LOC ,CUP-B>>
		      <MOVE ,CUP-B ,WAITER>)>
	       <ESTABLISH-GOAL ,WAITER ,PANTRY>
	       <COND (,IDEBUG <TELL "(0)]" CR>)>
	       <RFALSE>)>)>>

<GLOBAL BOND-CTR 0>

<ROUTINE I-BOND ("OPTIONAL" (GARG <>) "AUX" (VAL <>) CAR)
	<COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	       <TELL "[I-BOND:">
	       <COND (<==? .GARG ,G-DEBUG>
		      ;<COND (,IDEBUG <TELL "(0)]" CR>)>
		      <RFALSE>)>)>
	<SETG BOND-CTR <+ 1 ,BOND-CTR>>
	<COND (<==? 1 ,BOND-CTR>
	       <QUEUE I-BOND 1>
	       <SET VAL <MOVE-PERSON ,BOND ,VESTIBULE-REAR>>)
	      (<==? 2 ,BOND-CTR>
	       <QUEUE I-BOND 3>
	       <SET VAL <MOVE-PERSON ,BOND ,ROOF>>
	       <SET CAR <+ 1 ,CAR-START>>
	       <PUTP ,BOND ,P?CAR .CAR>
	       <COND (<NOT <==? .CAR ,CAR-HERE>> <MOVE ,BOND ,OTHER-ROOF>)>)
	      (<==? 3 ,BOND-CTR>
	       <QUEUE I-BOND 2>
	       <COND (<SET VAL <NOT <NOISY? ,HERE>>>
		      <TELL
"You hear some kind of noise from the roof of the train." CR>)>)
	      (<==? 4 ,BOND-CTR>
	       <QUEUE I-BOND 1>
	       <MOVE ,BOND ,LIMBO-FWD>
	       <COND (<SET VAL <WINDOW-IN? ,HERE>>
		      <TELL
"Something outside the window catches your eye. It looks like"
THE ,BOND " falling off the roof of the train." CR>)>)
	      (<==? 5 ,BOND-CTR>
	       <SET VAL <START-BAD-SPY>>)>
	<COND (,IDEBUG <TELL N .VAL "]" CR>)>
	.VAL>

<GLOBAL SUPPRESS-INTERRUPT <>>
<GLOBAL BOND-OTHER-ACTIONS
	<LTABLE	0
		" crouches low and prepares to lunge"
		" slips but then regains his footing"
		" creeps a little closer">>

<ROUTINE I-BOND-OTHER ("OPTIONAL" (GARG <>) "AUX" (VAL <>))
	<COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	       <TELL "[I-BOND-OTHER:">
	       <COND (<==? .GARG ,G-DEBUG>
		      ;<COND (,IDEBUG <TELL "(0)]" CR>)>
		      <RFALSE>)>)>
	<COND (<ZERO? ,SUPPRESS-INTERRUPT>
	       <COND (<PROB 90>
		      <SET VAL T>
		      <TELL
CHE ,BOND-OTHER <PICK-ONE-NEW ,BOND-OTHER-ACTIONS> "." CR>)
		     (T <TELL
CHE ,BOND-OTHER " leaps at you and tries to kick your feet out from
under you. You respond with your best moves. But after wrestling
together for what seems like ages, you both reach the edge of the roof
and plunge over it!" CR>
		      <FINISH>)>)
	      (T
	       <SETG SUPPRESS-INTERRUPT <>>)>
	<COND (,IDEBUG <TELL N .VAL "]" CR>)>
	.VAL>

<ROUTINE I-COOK		("OPTIONAL" (GARG <>) "AUX" L) <RFALSE>>

"<ROUTINE I-THIN-MAN	('OPTIONAL' (GARG <>) 'AUX' L) <RFALSE>>
<ROUTINE I-FAT-MAN	('OPTIONAL' (GARG <>) 'AUX' L) <RFALSE>>
<ROUTINE I-HUNK		('OPTIONAL' (GARG <>) 'AUX' L) <RFALSE>>
<ROUTINE I-PEEL		('OPTIONAL' (GARG <>) 'AUX' L) <RFALSE>>
<ROUTINE I-DUCHESS	('OPTIONAL' (GARG <>) 'AUX' L) <RFALSE>>
<ROUTINE I-NATASHA	('OPTIONAL' (GARG <>) 'AUX' L) <RFALSE>>"

<ROUTINE I-GUARD	("OPTIONAL" (GARG <>) "AUX" L) <RFALSE>>

<ROUTINE I-ATTENTION ("OPTIONAL" (GARG <>) "AUX" (FLG <>) (CNT 0) ATT GT PER)
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-ATTENTION:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <REPEAT ()
	<COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX> <RETURN>)>
	<SET GT <GET ,GOAL-TABLES .CNT>>
	<SET ATT <GET .GT ,ATTENTION>>
	<COND (<NOT <G? .ATT 0>> <AGAIN>)>
	<DEC ATT>
	<SET PER <GET ,CHARACTER-TABLE .CNT>>
	<COND (<0? .PER>
	       <TELL "[!! I-ATT: PER=0]" CR>)
	      (<0? .ATT>
	       <FCLEAR .PER ,TOUCHBIT>
	       <COND (<OR <==? .PER ,PEEKER>
			  <AND <==? .PER ,BAD-SPY>
			       <NOT ,BAD-SPY-DONE-PEEKING>>>
		      <PUTP .PER ,P?LDESC ,PEEKING-CODE>)
		     (<EQUAL? .PER ,CONDUCTOR ;,CUSTOMS-AGENT>
		      <PUTP .PER ,P?LDESC 19 ;"making rounds">)
		     (T
		      <PUTP .PER ,P?LDESC 14 ;"walking along">)>
	       <COND (<OR <NOT <==? .PER ,CONDUCTOR>>
			  <NOT <STOP-CONDUCTOR?>>>
		      <PUT .GT ,GOAL-ENABLE 1>)>)
	      (<AND <==? .ATT 1>
		    <IN? .PER ,HERE>
		    <D-APPLY "Impatient"<GET .GT ,GOAL-FUNCTION>,G-IMPATIENT>>
	       <SET FLG T>)>
	<PUT .GT ,ATTENTION .ATT>>
 <COND (,IDEBUG <TELL N .FLG "]" CR>)>
 .FLG>

<ROUTINE GRAB-ATTENTION (PERSON "OPTIONAL" (LEN <>)
			 "AUX" (CHR <GETP .PERSON ,P?CHARACTER>) GT ATT)
	 <COND (<NOT <FSET? .PERSON ,PERSONBIT>>
		<TOO-BAD-BUT .PERSON "dead">
		<RFALSE>)
	       (<FSET? .PERSON ,MUNGBIT>
		<TOO-BAD-BUT .PERSON "out cold">
		<RFALSE>)
	       (<EQUAL? <GETP .PERSON ,P?LDESC> 2 ;"snoozing">
		<TOO-BAD-BUT .PERSON "asleep">
		<RFALSE>)
	       (<FSET? .PERSON ,BUSYBIT>
		<TOO-BAD-BUT .PERSON "busy">
		<RFALSE>)>
	 <SET GT <GET ,GOAL-TABLES .CHR>>
	 <COND (<GET .GT ,GOAL-S>
		<COND (.LEN <SET ATT .LEN>)
		      (ELSE <SET ATT <GET .GT ,ATTENTION-SPAN>>)>
		<PUT .GT ,ATTENTION .ATT>
		<COND (<==? .ATT 0>
		       <COND (<OR <NOT <==? .PERSON ,CONDUCTOR>>
				  <NOT <STOP-CONDUCTOR?>>>
			      <PUT .GT ,GOAL-ENABLE 1>)>
		       <RFALSE>)
		      (<NOT <ZERO? <GET .GT ,GOAL-ENABLE>>>
		       <PUT .GT ,GOAL-ENABLE 0>)>)>
	 <SAID-TO .PERSON>
	 <RTRUE>>

<GLOBAL TOUCH-CAP? <>>
<GLOBAL TICKET-KNOCK <>>
<GLOBAL TICKET-COUNT 0 ;1>
<GLOBAL GESTURE-TABLE
	<PLTABLE 0
		" again" " strongly" " forcefully" " wildly" " frantically">>

<ROUTINE I-TICKETS-PLEASE ("OPTIONAL" (GARG <>)
			   "AUX" L (L1 <>) PER X (VAL <>))
 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
	<TELL "[I-TICKETS-PLEASE:">
	<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>
 <COND (<AND ,TICKETS-PUNCHED? <NOT ,CUSTOMS-SWEEP>>
	<QUEUE I-TICKETS-PLEASE 0>
	<RFALSE>)>
 <COND (,IDEBUG <TELL "[I-TICKETS-PLEASE:">)>
 <SET L <LOC ,CONDUCTOR>>
 <COND (<OR <SET X <GETPT .L ,P?IN>>
	    <SET X <GETPT .L ,P?OUT>>>
	<SET L1 <GET-REXIT-ROOM .X>>)>
 <COND (<SET PER <STOP-CONDUCTOR?>>	;"need to merge with I-CONDUCTOR"
	<PUT <GET ,GOAL-TABLES ,CONDUCTOR-C> ,GOAL-ENABLE 0>
	<SETG TOUCH-CAP? <>>
	<SET X <VISIBLE? .PER T>>
	<COND (<NOT <FSET? .PER ,PERSONBIT>>
	       <MOVE .PER ,LIMBO-FWD>
	       <SETG VICTIM-KNOWN .PER>
	       <COND (<OR <NOT <EQUAL? .X ,FALSE-VALUE ,PLAYER-NOT-FACING>>
			  <AND ,DEBUG <TELL "[">>>
		      <TELL CHE ,CONDUCTOR " removes" HIS .PER " body.">
		      <COND (,DEBUG ;<ZERO? .X> <TELL "]">)>
		      <CRLF>)>)
	      (<FSET? .PER ,MUNGBIT>
	       <QUEUE I-COME-TO 1>
	       <COND (<OR <NOT <EQUAL? .X ,FALSE-VALUE ,PLAYER-NOT-FACING>>
			  <AND ,DEBUG <TELL "[">>>
		      <TELL CHE ,CONDUCTOR " tries to revive" HIM .PER ".">
		      <THIS-IS-IT .PER>
		      <COND (,DEBUG ;<ZERO? .X> <TELL "]">)>
		      <CRLF>)>)
	      (<EQUAL? .PER ,PLAYER>
	       <COND (<==? ,HERE <LOC ,CONDUCTOR>>
		      <TELL CHE ,CONDUCTOR>)
		     (T
		      <SET X <FIND-FLAG-LG ,HERE ,DOORBIT>>
		      ;<COND (.X
			     <TELL "[Debugging info: X=" D .X " L="
				   <COND (<FSET? .X ,LOCKED> "1") (T "0")>
				   " TK=" N ,TICKET-KNOCK "]" CR>)>
		      <COND (<AND .X <FSET? .X ,LOCKED>>
			     <COND (,TICKET-KNOCK
				    <FCLEAR .X ,LOCKED>)
				   (T
				    <SETG TICKET-KNOCK T>
				    <TELL "You hear a knock on the door." CR>
				    <COND (,IDEBUG <TELL "(1)]" CR>)>
				    <RTRUE>)>)>
		      <SETG TICKET-KNOCK <>>
		      <SETG TICKET-COUNT 0>
		      <MOVE ,CONDUCTOR ,HERE>
		      <TELL CR CHE ,CONDUCTOR appear " and">)>
	       <COND (<VERB? TELL SAY> T)
		     (<L? ,TICKET-COUNT <GET ,GESTURE-TABLE 0>>
		      <SETG TICKET-COUNT <+ 1 ,TICKET-COUNT>>)
		     (T
		      <ARREST-PLAYER "proper tickets">
		      <TELL " throws up his hands and hurries away." CR>
		      <COND (,IDEBUG <TELL "(0)]" CR>)>
		      <RTRUE>)>
	       <TELL " makes a gesture">
	       <COND (<L? 1 ,TICKET-COUNT>
		      <TELL <GET ,GESTURE-TABLE ,TICKET-COUNT>>)>
	       <SET VAL T>
	       <COND (,CUSTOMS-SWEEP
		      <COND (<G? 5 ,TICKET-COUNT> <TELL ", asking you to">)
			    (T <TELL ", demanding that you">)>
		      <TELL " leave the train." CR>)
		     (<==? .PER ,PLAYER>
		      <COND (<G? 5 ,TICKET-COUNT> <TELL ", asking for ">)
			    (T <TELL ", demanding ">)>
		      <THIS-IS-IT ,TICKET>
		      <TELL D ,TICKET>
		      <TELL "." CR>)>
	       <ARREST-MCGUFFIN?>
	       <COND (T ;<SPY?> <ARREST-MCGUFFIN? ,GUN "carrying weapons">)>
	       <COND (,IDEBUG <TELL N .VAL "]" CR>)>
	       .VAL)
	      (T
	       <FCLEAR .PER ,LOCKED>
	       <COND (<GET <GT-O .PER> ,GOAL-S>
		      <PUT <GT-O .PER> ,GOAL-ENABLE 1>)>
	       <COND (<OR <NOT <EQUAL? .X ,FALSE-VALUE ,PLAYER-NOT-FACING>>
			  <AND ,DEBUG <TELL "[">>>
		      <TELL CHE ,CONDUCTOR>
		      <COND (,CUSTOMS-SWEEP
			     <TELL " asks" HIM .PER " to leave the train.">)
			    (T
			     <TELL " punches" HIS .PER " ticket.">)>
		      <COND (,DEBUG ;<ZERO? .X> <TELL "]">)>
		      <CRLF>)>)>)
       (T
	<PUT <GET ,GOAL-TABLES ,CONDUCTOR-C> ,GOAL-ENABLE 1>
	<COND (<SET X <VISIBLE? ,CONDUCTOR>>
	       <COND (<OR <FIND-FLAG .L ,PERSONBIT ,CONDUCTOR>
			  <AND .L1 <FIND-FLAG .L1 ,PERSONBIT ,CONDUCTOR>>>
		      <SETG TOUCH-CAP? T>)
		     (T <SETG TOUCH-CAP? <>>)>)>
	<COND (<NOT <==? .L <GETP .L ,P?STATION>>>
	       <MOVE-PERSON ,CONDUCTOR <GETP .L ,P?STATION>>)>
	<COND (,IDEBUG <TELL "(0)]" CR>)>
	<RFALSE>)>>

<ROUTINE ARREST-MCGUFFIN? ("OPTIONAL" (OBJ <>) (STR <>) "AUX" X)
	<COND (<ZERO? .OBJ>
	       <SET OBJ ,MCGUFFIN>
	       <SET STR "smuggling">)>
	<SET X <LOC .OBJ>>
	<COND (<OR <EQUAL? .X ,PLAYER>
		   <AND <EQUAL? <META-LOC .OBJ> ,HERE>
			<NOT <FSET? .X ,PERSONBIT>>
			<NOT <HIDDEN? .OBJ>>>>
	       <MOVE .OBJ ,LIMBO-FWD ;CONDUCTOR>
	       <ARREST-PLAYER .STR>
	       <TELL
"Then he notices" HIM .OBJ ", confiscates it, and leaves in a hurry." CR>)>>

<GLOBAL ARREST-REASON 0>

<ROUTINE ARREST-PLAYER (STR "OPTIONAL" (PER <>) (TELL? <>) (OBJ <>))
	<COND (<NOT .PER>
	       <SET PER ,CONDUCTOR>)>
	<COND (.TELL?
	       <TELL CHE .PER>
	       <COND (<WHERE? .PER> <PRINTC %<ASCII !\,>>)>
	       <TELL
V .PER stare " at" HIM .OBJ " for a moment, not believing" HIS .PER
" eyes. Then" HE .PER leave " in a hurry.">
	       <COND (<AND <NOT <==? .PER ,CONDUCTOR>>
			   <VISIBLE? ,CONDUCTOR>>
		      <TELL " So does" HE ,CONDUCTOR ".">)>
	       <CRLF>)>
	<QUEUE I-TICKETS-PLEASE 0>
	<COND (<NOT <QUEUED? ,I-TRAIN-ARREST>>
	       <ENABLE <QUEUE I-TRAIN-ARREST 5>>)>
	<SETG ARREST-REASON .STR>
	<MOVE .PER ,OTHER-LIMBO-FWD>
	<PUT <GT-O .PER> ,GOAL-ENABLE 0>
	<MOVE ,CONDUCTOR ,OTHER-LIMBO-FWD>
	<PUT <GET ,GOAL-TABLES ,CONDUCTOR-C> ,GOAL-ENABLE 0>
	<RTRUE>>
