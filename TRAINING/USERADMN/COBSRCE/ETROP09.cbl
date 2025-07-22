000100 IDENTIFICATION DIVISION.                                                 
000200 PROGRAM-ID.    ETROP04.                                                  
000300 INSTALLATION.  RC.                                                       
000400 AUTHOR.        ANAND.                                                    
000500 DATE-WRITTEN.  9/21/2014.                                                
000600 DATE-COMPILED.                                                           
003200                                                                          
003300 ENVIRONMENT DIVISION.                                                    
003400                                                                          
003500 CONFIGURATION SECTION.                                                   
003600 SOURCE-COMPUTER. Z900.                                                   
003700 OBJECT-COMPUTER. Z900.                                                   
003800                                                                          
003900 EJECT                                                                    
004000                                                                          
004100 DATA DIVISION.                                                           
004200                                                                          
004300 WORKING-STORAGE SECTION.                                                 
004400                                                                          
004500 01 WS-BEGIN                          PIC  X(36) VALUE                    
004600     'ETROP04 WORKING STORAGE STARTS HERE'.                               
004700                                                                          
004800******************************************************************        
004900*  APPLICATION-SPECIFIC WORKING STORAGE                          *        
      *  INCLUDING THIS COMMENT LINE FOR API TESTING - 24/03/2015      *        
005000******************************************************************        
005100 01 WS-VARIABLES.                                                         
005200    05 WS-ERROR-SWITCH                 PIC X(01) VALUE SPACES.            
005300       88 WS-NO-ERROR                            VALUE SPACES.            
005310       88 WS-NON-FATAL-ERROR                     VALUE 'N'.               
005320       88 WS-FATAL-ERROR                         VALUE 'F'.               
005330    05 WS-CICS-RESP                    PIC S9(8) COMP.                    
          05 WS-STUDENT-COUNT                PIC S9(9) COMP.                    
003510******************************************************************        
003520* Copybook Includes.                                             *        
003530******************************************************************        
003600     EXEC SQL                                                             
003700       INCLUDE CWERRLOG                                                   
003800     END-EXEC.                                                            
003900                                                                          
010900******************************************************************        
011000*                     DB2 SECTION                                *        
011100******************************************************************        
011200     EXEC SQL                                                             
011300       INCLUDE SQLCA                                                      
011400     END-EXEC.                                                            
011500                                                                          
011600     EXEC SQL                                                             
011700       INCLUDE DCLSESSN                                                   
011800     END-EXEC.                                                            
011801                                                                          
011810     EXEC SQL                                                             
011820       INCLUDE DCLRGSTR                                                   
011830     END-EXEC.                                                            
011840                                                                          
011900******************************************************************        
012000*  CURSOR DECLARATION                                            *        
012100******************************************************************        
012200     EXEC SQL DECLARE STUDENTS-IN-SESSION CURSOR                          
012300      FOR                                                                 
012400      SELECT          A.SESSION_CATG,                                     
012500                      A.SESSION_START_DATE,                               
012600                      COUNT(*)                                            
012830        FROM DBODEVP.TRAINING_SESSION A,                                  
012840             DBODEVP.REGISTRATION B                                       
012870       WHERE   B.SESSION_CATG      = A.SESSION_CATG                       
               AND   B.SESSION_ID        = A.SESSION_ID                         
               AND   B.REG_STATUS        = 'A'                                  
012910     END-EXEC.                                                            
013000                                                                          
013100 01 WS-END                             PIC X(50) VALUE                    
013200     'ETROP04-WORKING STORAGE SECTION ENDS HERE'.                         
013300                                                                          
014100 PROCEDURE DIVISION.                                                      
014200                                                                          
014300 MAIN-LOGIC-PARA.                                                         
014400                                                                          
004970     MOVE 'ETROP04'                    TO EL-ERROR-MODULE.                
004971*                                         DCI-ERROR-MODULE.               
004972     MOVE 'MAIN-LOGIC-PARA           ' TO EL-ERROR-PARA-NAME.             
014800                                                                          
019620     EXEC SQL                                                             
019700       OPEN STUDENTS-IN-SESSION                                           
019800     END-EXEC.                                                            
019900                                                                          
005112     EVALUATE SQLCODE                                                     
005113       WHEN 0                                                             
005114         CONTINUE                                                         
005115       WHEN 100                                                           
005116         PERFORM EXIT-PARA                                                
005117       WHEN OTHER                                                         
005119         MOVE 'OPEN  '                 TO EL-ERROR-ACTION                 
005120         MOVE 'STUDENTS-IN-SESSION'    TO EL-ERROR-DB2-OBJECT             
005121         PERFORM CHECK-SQLCODE-PARA                                       
005122         PERFORM EXIT-PARA                                                
005123     END-EVALUATE.                                                        
021900                                                                          
005133*    PERFORM UNTIL SQLCODE = 100 OR EL-ERROR-DB2                          
005133     PERFORM UNTIL SQLCODE = 100                                          
005134       EXEC SQL                                                           
005135         FETCH STUDENTS-IN-SESSION                                        
005136          INTO :DCLTRAINING-SESSION.SESSION-CATG,                         
005138               :DCLTRAINING-SESSION.SESSION-START-DATE,                   
005139               :WS-STUDENT-COUNT                                          
005145       END-EXEC                                                           
005146       EVALUATE SQLCODE                                                   
005147         WHEN 0                                                           
005148           CONTINUE                                                       
005186         WHEN 100                                                         
005187           CONTINUE                                                       
005188         WHEN OTHER                                                       
005189           MOVE 'FETCH '               TO EL-ERROR-ACTION                 
005190           MOVE 'STUDENTS-IN-SESSION'  TO EL-ERROR-DB2-OBJECT             
005191           PERFORM CHECK-SQLCODE-PARA                                     
005192           PERFORM EXIT-PARA                                              
005200       END-EVALUATE                                                       
005209     END-PERFORM.                                                         
005210                                                                          
005215     EXEC SQL                                                             
005216       CLOSE STUDENTS-IN-SESSION                                          
           END-EXEC.                                                            
005218                                                                          
005219     IF SQLCODE NOT = 0                                                   
005220       MOVE 'CLOSE '                   TO EL-ERROR-ACTION                 
005221       MOVE 'STUDENTS-IN-SESSION'      TO EL-ERROR-DB2-OBJECT             
005222       PERFORM CHECK-SQLCODE-PARA                                         
005223*      SET EL-ERROR-NONE               TO TRUE                            
005224     END-IF.                                                              
006464     GOBACK.                                                              
006465                                                                          
006466******************************************************************        
006467* Error Logging                                                  *        
006468******************************************************************        
       CHECK-SQLCODE-PARA.                                                      
006469*    EXEC SQL                                                             
006470*      INCLUDE CWERRLOG                                                   
006471*    END-EXEC.                                                            
                                                                                
       EXIT-PARA.                                                               
      *    EXEC CICS RETURN                                                     
      *    END-EXEC.                                                            
