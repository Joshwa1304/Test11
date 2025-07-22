000100 CHECK-SQLCODE-PARA.                                                      
000200       EVALUATE TRUE                                                      
000300         WHEN SQLCODE = 0                                                 
000400           CONTINUE                                                       
000410         WHEN SQLCODE = 100  AND EL-SQLCODE-IGNORE-100                    
000411         WHEN SQLCODE = -803 AND EL-SQLCODE-IGNORE-803                    
000412         WHEN SQLCODE = -811 AND EL-SQLCODE-IGNORE-811                    
000413         WHEN SQLCODE = -181 AND EL-SQLCODE-IGNORE-181                    
000420           SET EL-SQLCODE-IGNORE-NONE  TO TRUE                            
000900         WHEN OTHER                                                       
001000           SET EL-ERROR-DB2            TO TRUE                            
001100           SET EL-ERROR-DESC-DB2       TO TRUE                            
001200           MOVE SQLCODE                TO EL-ERROR-SQLCODE                
001300           MOVE SQLERRMC               TO EL-ERROR-SQLERRMC               
001400           PERFORM LOG-ERROR                                              
001500       END-EVALUATE.                                                      
001600                                                                          
001700 CHECK-RESPCODE-PARA.                                                     
001800     IF EIBRESP NOT = DFHRESP(NORMAL)                                     
001900      SET EL-ERROR-CICS                  TO TRUE                          
002000      SET EL-ERROR-DESC-CICS             TO TRUE                          
002100      MOVE EIBRESP                       TO EL-ERROR-RESP                 
002200      MOVE EIBRESP2                      TO EL-ERROR-RESP2                
002300      MOVE EIBRSRCE                      TO EL-ERROR-SRCE                 
002400      CALL  EL-CICS-FN-TO-HEX                                             
002500      USING EIBFN, EL-ERROR-FUNCTION                                      
002600      END-CALL                                                            
002700      PERFORM LOG-ERROR                                                   
002800     END-IF.                                                              
002900                                                                          
003000 LOG-MISC-PARA.                                                           
003101     SET EL-ERROR-MISC                   TO TRUE                          
003120     SET EL-ERROR-DESC-MISC              TO TRUE                          
003200     PERFORM LOG-ERROR.                                                   
003300                                                                          
003310 LOG-APPL-PARA.                                                           
003320     SET EL-ERROR-APPL                   TO TRUE                          
003322     SET EL-ERROR-DESC-APPL              TO TRUE                          
003330     PERFORM LOG-ERROR.                                                   
003340                                                                          
003400 LOG-ERROR.                                                               
003500       EXEC CICS ASSIGN                                                   
003600            USERID    (EL-ERROR-USERID)                                   
003700            NOHANDLE                                                      
003800       END-EXEC.                                                          
003810                                                                          
004000       EXEC CICS ASKTIME                                                  
004100            ABSTIME (EL-ERROR-ABSTIME)                                    
004200            NOHANDLE                                                      
004300       END-EXEC.                                                          
004400                                                                          
004500       EXEC CICS FORMATTIME                                               
004600            ABSTIME (EL-ERROR-ABSTIME)                                    
004700            MMDDYY  (EL-ERROR-DATE)                                       
004800            TIME    (EL-ERROR-TIME)                                       
004900            DATESEP ('/')                                                 
005000            TIMESEP (':')                                                 
005100            NOHANDLE                                                      
005200       END-EXEC.                                                          
005300                                                                          
005400       MOVE EL-ERROR-DATE-MM            TO EL-ERROR-NUMBER-MM.            
005500       MOVE EL-ERROR-DATE-DD            TO EL-ERROR-NUMBER-DD.            
005600       MOVE EL-ERROR-TIME-HH            TO EL-ERROR-NUMBER-HH.            
005700       MOVE EL-ERROR-TIME-MM            TO EL-ERROR-NUMBER-MN.            
005800       MOVE EL-ERROR-TIME-SS            TO EL-ERROR-NUMBER-SS.            
005900                                                                          
005910       MOVE EL-ERROR-NUMBER-TEXT        TO DCI-ERROR-NUMBER-TEXT.         
006000       MOVE EL-ERROR-HEADER             TO EL-ERROR-LINE.                 
006100       PERFORM WRITE-TO-LOG.                                              
006200       SET EL-ERROR-DESC-BLANK        TO TRUE.                            
006300                                                                          
006400       IF EL-ERROR-DB2                                                    
006500         MOVE SPACES                   TO EL-ERROR-LINE                   
006600         MOVE EL-ERROR-DB2-HEADER      TO EL-ERROR-LINE                   
006700         PERFORM WRITE-TO-LOG                                             
006800                                                                          
006900         MOVE SPACES                   TO EL-ERROR-LINE                   
007000         MOVE EL-ERROR-DB2-SQLERRMC    TO EL-ERROR-LINE                   
007100         PERFORM WRITE-TO-LOG                                             
007200       END-IF.                                                            
007300                                                                          
007400       IF EL-ERROR-CICS                                                   
007500         MOVE SPACES                   TO EL-ERROR-LINE                   
007600         MOVE EL-ERROR-CICS-HEADER     TO EL-ERROR-LINE                   
007700         PERFORM WRITE-TO-LOG                                             
007800       END-IF.                                                            
007900                                                                          
008000                                                                          
008100       IF EL-ERROR-TEXT NOT = SPACES                                      
008200          MOVE SPACES                  TO EL-ERROR-LINE                   
008300          MOVE EL-ERROR-TEXT           TO EL-ERROR-LINE                   
008400          PERFORM WRITE-TO-LOG                                            
008500       END-IF.                                                            
008600                                                                          
008700 WRITE-TO-LOG.                                                            
008800******************************************************************        
008900* WRITE TO ddname LOG within CICS.                            *           
009000******************************************************************        
009100       EXEC CICS WRITEQ TD                                                
009200            QUEUE          ('CSSL')                                       
009300            FROM           (EL-ERROR-LINE)                                
009400            LENGTH         (LENGTH OF EL-ERROR-LINE)                      
009500            NOHANDLE                                                      
009600       END-EXEC.                                                          
