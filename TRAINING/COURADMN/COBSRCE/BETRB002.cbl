       IDENTIFICATION DIVISION.                                                 
       PROGRAM-ID. ETRB002.                                                     
       ENVIRONMENT DIVISION.                                                    
       DATA DIVISION.                                                           
       WORKING-STORAGE SECTION.                                                 
      *     "Ravikanth Chavali & Vijaya Lakshmi Sombhotla testing               
      *      RDz Endevor Integration for PoC project"                           
       01  WS-SQLCODE PIC +(11).                                                
      *     COPY CPDCLREG.                                                      
       01  WS-REGISTRATION.                                                     
           10 WS-SESSION-CATG         PIC X(2).                                 
           10 WS-SESSION-ID           PIC S9(9) USAGE COMP.                     
           10 WS-EMAIL-ADDR.                                                    
              49 WS-EMAIL-ADDR-LEN    PIC S9(4) USAGE COMP.                     
              49 WS-EMAIL-ADDR-TEXT   PIC X(120).                               
           10 WS-FULL-NAME.                                                     
              49 WS-FULL-NAME-LEN     PIC S9(4) USAGE COMP.                     
              49 WS-FULL-NAME-TEXT    PIC X(130).                               
           10 WS-ORG-NAME.                                                      
              49 WS-ORG-NAME-LEN      PIC S9(4) USAGE COMP.                     
              49 WS-ORG-NAME-TEXT     PIC X(120).                               
           10 WS-REG-DATE             PIC X(10).                                
           10 WS-REG-STATUS           PIC X(1).                                 
           10 WS-DTS                  PIC X(26).                                
           EXEC SQL                                                             
                INCLUDE SQLCA                                                   
           END-EXEC.                                                            
           EXEC SQL                                                             
                INCLUDE DCLRGSTR                                                
           END-EXEC.                                                            
       PROCEDURE DIVISION.                                                      
           DISPLAY 'PROGRAM STARTED'.                                           
           MOVE 'TR' TO WS-SESSION-CATG.                                        
           DISPLAY 'OUT SIDE SQL BLOCK : ' WS-SESSION-CATG.                     
      *                                                                         
            EXEC SQL                                                            
              SELECT SESSION_CATG, SESSION_ID, REG_DATE, REG_STATUS             
                     INTO  :WS-SESSION-CATG, :WS-SESSION-ID,                    
                           :WS-REG-DATE, :WS-REG-STATUS                         
                  FROM DBODEVP.REGISTRATION                                     
                  WHERE SESSION_CATG= :WS-SESSION-CATG                          
            END-EXEC.                                                           
            MOVE SQLCODE TO WS-SQLCODE                                          
                  DISPLAY ' SQL CODE   '  SQLCODE                               
            IF SQLCODE = 0                                                      
                                                                                
                  DISPLAY ' SQL EXECUTED SUCCESSFULLY '                         
                  DISPLAY ' REGISTRATION DETAILS '                              
                  DISPLAY ' SESSION-CATG  : ' WS-SESSION-CATG                   
                  DISPLAY ' SESSION-ID    : ' WS-SESSION-ID                     
      *           DISPLAY ' EMAIL-ADDR    : ' WS-EMAIL-ADDR                     
      *           DISPLAY ' FULL-NAME     : ' WS-FULL-NAME                      
      *           DISPLAY ' ORG-NAME      : ' WS-ORG-NAME                       
                  DISPLAY ' REG-DATE      : ' WS-REG-DATE                       
      *           DISPLAY ' REG-STATUS    : ' WS-REG-STATUS                     
             ELSE                                                               
                  DISPLAY ' SQL FAILED '                                        
                  DISPLAY ' SQL CODE   '  SQLCODE                               
                  DISPLAY ' SQL CODE   '  WS-SQLCODE                            
                  DISPLAY ' SQL STATE  '  SQLSTATE                              
                  DISPLAY ' SQL ERRMC  '  SQLERRMC                              
             END-IF.                                                            
           DISPLAY 'PROGRAM ENDED'.                                             
           STOP RUN.                                                            
