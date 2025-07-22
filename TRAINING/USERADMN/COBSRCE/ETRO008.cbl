000100 IDENTIFICATION DIVISION.                                                 
000200 PROGRAM-ID. RCOTSQDL.                                                    
000300 AUTHOR. ANAND V.                                                         
000400 ENVIRONMENT DIVISION.                                                    
000500 DATA DIVISION.                                                           
000600                                                                          
000700 WORKING-STORAGE SECTION.                                                 
000800                                                                          
000900******************************************************************        
001000* CICS LOG RELATED DECLARATIONS.                                 *        
001100******************************************************************        
001200 01 MSG-ABSTIME                     PIC 9(08).                            
001300 01 APPL-MESSAGE.                                                         
001400    02 APPL-CICS-HEADER.                                                  
001500       05 MSG-DATE                  PIC 9(08).                            
001600       05 FILLER                    PIC X(01) VALUE SPACES.               
001700       05 MSG-TIME                  PIC 9(08).                            
001800       05 FILLER                    PIC X(01) VALUE SPACES.               
001900       05 MSG-MODULE                PIC X(10) VALUE 'RCOTSQDL: '.         
002000       05 MSG-AREA                  PIC X(43).                            
002100          88 MSG-BLANK              VALUE SPACES.                         
002200          88 MSG-CICS-ERROR         VALUE 'CICS FUNCTION ERROR'.          
002300       05 MSG-AREA-DETAIL REDEFINES MSG-AREA.                             
002400          10 MSG-TRANID             PIC X(04).                            
002500          10 MSG-INFO-1             PIC X(01).                            
002600          10 MSG-TSQNAME            PIC X(08).                            
002700          10 MSG-INFO-2             PIC X(12).                            
002800          10 MSG-INTV               PIC 9(05).                            
002900          10 MSG-INFO-3             PIC X(13).                            
003000 01 APPL-CICS-ERROR.                                                      
003100    05 FILLER                       PIC X(10) VALUE 'FUNCTION: '.         
003200    05 APPL-CICS-FUNCTION            PIC X(04).                           
003300    05 FILLER                       PIC X(07) VALUE ' RESP: '.            
003400    05 APPL-CICS-RESP               PIC S9(10)                            
003500                                    SIGN IS LEADING SEPARATE.             
003600    05 FILLER                       PIC X(08) VALUE ' RESP2: '.           
003700    05 APPL-CICS-RESP2              PIC S9(10)                            
003800                                    SIGN IS LEADING SEPARATE.             
003900    05 FILLER                       PIC X(07) VALUE ' SRCE: '.            
004000    05 APPL-CICS-SRCE               PIC X(16).                            
004100                                                                          
004200******************************************************************        
004300* OTHER VARIABLES USED IN THE PROGRAM.                           *        
004310* INCLUDING THIS COMMENT LINE FOR API TESTING                    *        
004400******************************************************************        
004500 01 WS-VARIABLES.                                                         
004600    05 WS-ERROR-SWITCH              PIC X(01) VALUE 'N'.                  
004700       88 WS-NO-ERROR                         VALUE 'N'.                  
004800       88 WS-CICS-ERROR                       VALUE 'C'.                  
004900    05 WS-RESP                      PIC S9(8) COMP.                       
005000    05 WS-RESP2                     PIC S9(8) COMP.                       
005100    05 WS-CICS-FN-TO-HEX            PIC X(08) VALUE 'RCOCBTHX'.           
005200    05 WS-TSQNAME                   PIC X(16) VALUE SPACE.                
005300    05 WS-DELETEQ                   PIC X(16) VALUE SPACE.                
005400    05 WS-LASTUSEDINT               PIC S9(8) COMP VALUE 0.               
005500    05 WS-TRANID                    PIC X(04) VALUE SPACES.               
005600                                                                          
005700 PROCEDURE DIVISION.                                                      
005800                                                                          
005900 MAIN-LOGIC-PARA.                                                         
006000     EXEC CICS                                                            
006100      INQUIRE TSQNAME                                                     
006200              START                                                       
006300              RESP(WS-RESP)                                               
006400             RESP2(WS-RESP2)                                              
006500     END-EXEC.                                                            
006600                                                                          
006700     PERFORM CICS-CALL-CHECK                                              
006800        THRU CICS-CALL-EXIT.                                              
006900                                                                          
007000     IF WS-NO-ERROR                                                       
007100      PERFORM UNTIL WS-RESP = DFHRESP(END) OR WS-CICS-ERROR               
007200       EXEC CICS                                                          
007300        INQUIRE TSQNAME(WS-TSQNAME)                                       
007400        LASTUSEDINT(WS-LASTUSEDINT)                                       
007500        TRANSID(WS-TRANID)                                                
007600        NEXT                                                              
007700        RESP(WS-RESP)                                                     
007800        RESP2(WS-RESP2)                                                   
007900       END-EXEC                                                           
008000                                                                          
008100       PERFORM DELETE-TSQ                                                 
008200          THRU DELETE-EXIT                                                
008300                                                                          
008400       IF WS-RESP NOT = DFHRESP(END)                                      
008500        PERFORM CICS-CALL-CHECK                                           
008600           THRU CICS-CALL-EXIT                                            
008700        IF WS-NO-ERROR                                                    
008710          IF (WS-TRANID(1:2)  = 'RC'  AND                                 
008800              WS-LASTUSEDINT  > 3599 AND                                  
008900              WS-TSQNAME(1:1) = '#'      )                                
009000           MOVE WS-TRANID             TO MSG-TRANID                       
009100           MOVE WS-TSQNAME            TO WS-DELETEQ                       
009200                                         MSG-TSQNAME                      
009300           COMPUTE MSG-INTV = WS-LASTUSEDINT / 60                         
009400          END-IF                                                          
009410        END-IF                                                            
009500       END-IF                                                             
009600      END-PERFORM                                                         
009700     END-IF.                                                              
009800                                                                          
009900     PERFORM DELETE-TSQ                                                   
010000        THRU DELETE-EXIT.                                                 
010100                                                                          
010200     EXEC CICS                                                            
010300      INQUIRE TSQNAME END                                                 
010400      RESP(WS-RESP)                                                       
010500      RESP2(WS-RESP2)                                                     
010600     END-EXEC.                                                            
010700                                                                          
010800     PERFORM CICS-CALL-CHECK                                              
010900        THRU CICS-CALL-EXIT.                                              
011000                                                                          
011100     GOBACK.                                                              
011200                                                                          
011300 DELETE-TSQ.                                                              
011400     IF WS-DELETEQ NOT = SPACES                                           
011500      EXEC CICS DELETEQ TS                                                
011600           QUEUE(WS-DELETEQ)                                              
011700           RESP(WS-RESP)                                                  
011800           RESP2(WS-RESP2)                                                
011900      END-EXEC                                                            
012000      EVALUATE WS-RESP                                                    
012100       WHEN DFHRESP(NORMAL)                                               
012200        MOVE SPACE                  TO MSG-INFO-1                         
012300        MOVE ' TSQ PURGED.'         TO MSG-INFO-2                         
012400        MOVE ' MINS UNUSED.'        TO MSG-INFO-3                         
012500        PERFORM LOG-PARA                                                  
012600           THRU LOG-EXIT                                                  
012700       WHEN DFHRESP(QIDERR)                                               
012800        CONTINUE                                                          
012900       WHEN OTHER                                                         
013000        PERFORM CICS-CALL-CHECK                                           
013100           THRU CICS-CALL-EXIT                                            
013200      END-EVALUATE                                                        
013300      MOVE SPACES                      TO WS-DELETEQ                      
013400     END-IF.                                                              
013500                                                                          
013600 DELETE-EXIT.                                                             
013700     EXIT.                                                                
013800                                                                          
013900                                                                          
014000 CICS-CALL-CHECK.                                                         
014100     IF WS-RESP NOT = DFHRESP(NORMAL)                                     
014200      SET WS-CICS-ERROR                  TO TRUE                          
014300      CALL  WS-CICS-FN-TO-HEX                                             
014400      USING EIBFN, APPL-CICS-FUNCTION                                     
014500      END-CALL                                                            
014600      MOVE WS-RESP                       TO APPL-CICS-RESP                
014700      MOVE WS-RESP2                      TO APPL-CICS-RESP2               
014800      MOVE EIBRSRCE                      TO APPL-CICS-SRCE                
014900      SET  MSG-BLANK                     TO TRUE                          
015000      SET  MSG-CICS-ERROR                TO TRUE                          
015100      PERFORM LOG-PARA                                                    
015200         THRU LOG-EXIT                                                    
015300      EXEC CICS WRITEQ TD                                                 
015400           QUEUE  ('CSSL')                                                
015500           FROM   (APPL-CICS-ERROR)                                       
015600           RESP   (WS-RESP)                                               
015700           RESP2  (WS-RESP2)                                              
015800           LENGTH (LENGTH OF APPL-CICS-ERROR)                             
015900      END-EXEC                                                            
016000     END-IF.                                                              
016100                                                                          
016200 CICS-CALL-EXIT.                                                          
016300     EXIT.                                                                
016400                                                                          
016500 LOG-PARA.                                                                
016600                                                                          
016700     EXEC CICS ASKTIME                                                    
016800          ABSTIME (MSG-ABSTIME)                                           
016900     END-EXEC.                                                            
017000                                                                          
017100     EXEC CICS FORMATTIME                                                 
017200          ABSTIME (MSG-ABSTIME)                                           
017300          MMDDYY  (MSG-DATE)                                              
017400          TIME    (MSG-TIME)                                              
017500          DATESEP ('/')                                                   
017600          TIMESEP (':')                                                   
017700     END-EXEC.                                                            
017800                                                                          
017900                                                                          
018000     EXEC CICS WRITEQ TD                                                  
018100          QUEUE  ('CSSL')                                                 
018200          FROM   (APPL-MESSAGE)                                           
018300          RESP   (WS-RESP)                                                
018400          RESP2  (WS-RESP2)                                               
018500          LENGTH (LENGTH OF APPL-MESSAGE)                                 
018600     END-EXEC.                                                            
018700                                                                          
018800     SET MSG-BLANK                       TO TRUE.                         
018900                                                                          
019000 LOG-EXIT.                                                                
019100     EXIT.                                                                
