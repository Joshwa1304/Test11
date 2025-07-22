      ******************************************************************        
      * DCLGEN TABLE(DBODEVP.REGISTRATION)                             *        
      *        LIBRARY(ROYAL.DEVP.DCLGLIB.COBOL(DCLRGSTR))             *        
      *        ACTION(REPLACE)                                         *        
      *        LANGUAGE(COBOL)                                         *        
      *        QUOTE                                                   *        
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *        
      ******************************************************************        
           EXEC SQL DECLARE DBODEVP.REGISTRATION TABLE                          
           ( SESSION_CATG                   CHAR(2) NOT NULL,                   
             SESSION_ID                     INTEGER NOT NULL,                   
             EMAIL_ADDR                     VARCHAR(120) NOT NULL,              
             FULL_NAME                      VARCHAR(130) NOT NULL,              
             ORG_NAME                       VARCHAR(120) NOT NULL,              
             REG_DATE                       DATE NOT NULL,                      
             REG_STATUS                     CHAR(1) NOT NULL,                   
             DTS                            TIMESTAMP NOT NULL                  
           ) END-EXEC.                                                          
      ******************************************************************        
      * COBOL DECLARATION FOR TABLE DBODEVP.REGISTRATION               *        
      ******************************************************************        
       01  DCLREGISTRATION.                                                     
           10 SESSION-CATG         PIC X(2).                                    
           10 SESSION-ID           PIC S9(9) USAGE COMP.                        
           10 EMAIL-ADDR.                                                       
              49 EMAIL-ADDR-LEN    PIC S9(4) USAGE COMP.                        
              49 EMAIL-ADDR-TEXT   PIC X(120).                                  
           10 FULL-NAME.                                                        
              49 FULL-NAME-LEN     PIC S9(4) USAGE COMP.                        
              49 FULL-NAME-TEXT    PIC X(130).                                  
           10 ORG-NAME.                                                         
              49 ORG-NAME-LEN      PIC S9(4) USAGE COMP.                        
              49 ORG-NAME-TEXT     PIC X(120).                                  
           10 REG-DATE             PIC X(10).                                   
           10 REG-STATUS           PIC X(1).                                    
           10 DTS                  PIC X(26).                                   
      ******************************************************************        
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 8       *        
      ******************************************************************        
