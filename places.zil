"PLACES for CHECKPOINT
Copyright (C) 1985 Infocom, Inc.  All rights reserved."

"The usual globals"

<OBJECT ROOMS
	(DESC "that")
	(FLAGS NARTICLEBIT)>

<ROUTINE NULL-F ("OPTIONAL" A1 A2)
	<RFALSE>>

<ROUTINE DOOR-ROOM (RM DR "AUX" (P 0) TBL)
	 <REPEAT ()
		 <COND (<OR <0? <SET P <NEXTP .RM .P>>>
			    <L? .P ,LOW-DIRECTION>>
			<RFALSE>)
		       (<AND <==? ,DEXIT <PTSIZE <SET TBL <GETPT .RM .P>>>>
			     <==? .DR <GET-DOOR-OBJ .TBL>>>
			<RETURN <GET-REXIT-ROOM .TBL>>)>>>

<ROUTINE DOOR-DIR (RM DR "AUX" (P 0) TBL)
	 <REPEAT ()
		 <COND (<OR <0? <SET P <NEXTP .RM .P>>>
			    <L? .P ,LOW-DIRECTION>>
			<RFALSE>)
		       (<AND <==? ,DEXIT <PTSIZE <SET TBL <GETPT .RM .P>>>>
			     <==? .DR <GET-DOOR-OBJ .TBL>>
			     <OR <EQUAL? .P ,P?NORTH ,P?EAST>
				 <EQUAL? .P ,P?SOUTH ,P?WEST>>>
			<RETURN .P>)>>>

<ROUTINE FACE-DOOR (DR "AUX" PER)
	<COND (<AND <VERB? CLOSE KNOCK LOCK LOOK-THROUGH OPEN UNLOCK>
		    ;<NOT ,PLAYER-SEATED>
		    ;<NOT ,PLAYER-HIDING>
		    <SET PER <DOOR-DIR ,HERE .DR>>>
	       <SETG PLAYER-NOT-FACING <OPP-DIR .PER>>
	       <COND (<NOT <==? ,PLAYER-NOT-FACING-OLD
				,PLAYER-NOT-FACING>>
		      <TELL "[You're facing to ">
		      <DIR-PRINT .PER ;<OPP-DIR ,PLAYER-NOT-FACING>>
		      <TELL ".]" CR>)>)>>

<ROUTINE FIND-FLAG (RM FLAG "OPTIONAL" (EXCLUDED <>) "AUX" O CAR STA?)
	<SET O <FIRST? .RM>>
	<SET CAR <GETP ,WINNER ,P?CAR>>
	<SET STA? <ZMEMQ .RM ,STATION-ROOMS>>
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <FSET? .O .FLAG>
		     <NOT <==? .O .EXCLUDED>>
		     <OR .STA?
			 <==? <GETP .O ,P?CAR> .CAR>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE FIND-FLAG-CAR (RM CAR FLAG "AUX" O)
	<SET O <FIRST? .RM>>
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <FSET? .O .FLAG>
		     <==? <GETP .O ,P?CAR> .CAR>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE FIND-FLAG-LG (RM FLAG "AUX" TBL O (CNT 0) SIZE)
	 <COND (<SET TBL <GETPT .RM ,P?GLOBAL>>
		<SET SIZE <RMGL-SIZE .TBL>>
		<REPEAT ()
			<COND (<FSET? <SET O <GET/B .TBL .CNT>> .FLAG>
			       <RETURN .O>)
			      (<IGRTR? CNT .SIZE> <RFALSE>)>>)>>

<ROUTINE FIND-FLAG-HERE (FLAG "OPTIONAL" (NOT1 <>) (NOT2 <>) (NOT3 <>)
			      "AUX" O CAR STA?)
	<SET O <FIRST? ,HERE>>
	<SET CAR <GETP ,WINNER ,P?CAR>>
	<SET STA? <ZMEMQ ,HERE ,STATION-ROOMS>>
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <FSET? .O .FLAG>
		     <NOT <EQUAL? .O .NOT1 .NOT2 .NOT3>>
		     <OR .STA?
			 <==? <GETP .O ,P?CAR> .CAR>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE FIND-FLAG-HERE-NOT (FLAG NFLAG "OPTIONAL" (NOT2 <>) "AUX" O CAR STA?)
	<SET O <FIRST? ,HERE>>
	<SET CAR <GETP ,WINNER ,P?CAR>>
	<SET STA? <ZMEMQ ,HERE ,STATION-ROOMS>>
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <FSET? .O .FLAG>
		     <NOT <FSET? .O .NFLAG>>
		     <NOT <EQUAL? .O .NOT2>>
		     <OR .STA?
			 <==? <GETP .O ,P?CAR> .CAR>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

"<ROUTINE FIND-FLAG-NOT (RM FLAG1 FLAG2 'AUX' (O <FIRST? .RM>))
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <FSET? .O .FLAG1> <NOT <FSET? .O .FLAG2>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>"

<ROUTINE NEXT-ROOM (RM DIR "AUX" PT PTS)
	 <COND (<SET PT <GETPT .RM .DIR>>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <GET-REXIT-ROOM .PT>)
		      (<==? .PTS ,NEXIT>
		       <RFALSE>)
		      (<==? .PTS ,FEXIT>
		       <APPLY <GET .PT ,FEXITFCN>>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GET-REXIT-ROOM .PT>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (T ;<FSET? <GET-DOOR-OBJ .PT> ,OPENBIT>
			      <GET-REXIT-ROOM .PT>)>)>)>>

<ROUTINE OUTSIDE? (RM)
	<OR <EQUAL? .RM ,ROOF ,OTHER-ROOF ,BESIDE-TRACKS>
	    <EQUAL? .RM ,SIDEWALK ,OTHER-BESIDE-TRACKS>>>

<ROUTINE WINDOW-IN? (RM) <FIND-FLAG-LG .RM ,WINDOWBIT>>

"<ROUTINE WINDOW-IN? (RM 'AUX' RMG RMGL (CNT 0))
 <COND (<SET RMG <GETPT .RM ,P?GLOBAL>>
	<SET RMGL <RMGL-SIZE .RMG>>
	<REPEAT ()
		<COND (<WORD-TYPE <GET/B .RMG .CNT> ,W?WINDOW>
		       <RTRUE>)>
		<COND (<IGRTR? CNT .RMGL> <RFALSE>)>>)>>"

;<ROUTINE WORD-TYPE (OBJ WORD "AUX" SYNS)
	 <ZMEMQ .WORD
		<SET SYNS <GETPT .OBJ ,P?SYNONYM>>
		<- </ <PTSIZE .SYNS> 2> 1>>>

"Other stuff"

<ROUTINE FRESH-AIR? (RM "AUX" P L TBL O)
	<SET P 0>
	<REPEAT ()
		<COND (<0? <SET P <NEXTP ,HERE .P>>>
		       <RFALSE>)
		      (<NOT <L? .P ,LOW-DIRECTION>>
		       <SET TBL <GETPT ,HERE .P>>
		       <SET L <PTSIZE .TBL>>
		       <COND (<AND <EQUAL? .L ,DEXIT>	;"Door EXIT"
				   <FSET? <SET O <GET-DOOR-OBJ .TBL>>
					  ,OPENBIT>>
			      <TELL
"There's a pleasant breeze coming through the " D .O "." CR>
			      <RETURN>)>)>>>
