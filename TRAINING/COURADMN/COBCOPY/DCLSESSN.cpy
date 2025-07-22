      ******************************************************************        
      * DCLGEN TABLE(DBODEVP.TRAINING_SESSION)                         *        
      *        LIBRARY(ROYAL.DEVP.DCLGLIB.COBOL(DCLSESSN))             *        
      *        LANGUAGE(COBOL)                                         *        
      *        QUOTE                                                   *        
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *        
      ******************************************************************        
           EXEC SQL DECLARE DBODEVP.TRAINING_SESSION TABLE                      
           ( SESSION_CATG                   CHAR(2) NOT NULL,                   
             SESSION_ID                     INTEGER NOT NULL,                   
             SESSION_DURATION               SMALLINT NOT NULL,                  
             SESSION_START_DATE             DATE NOT NULL,                      
             USR_ID                         CHAR(8) NOT NULL,                   
             DTS                            TIMESTAMP NOT NULL                  
           ) END-EXEC.                                                          
      ******************************************************************        
      * COBOL DECLARATION FOR TABLE DBODEVP.TRAINING_SESSION           *        
      ******************************************************************        
       01  DCLTRAINING-SESSION.                                                 
           10 SESSION-CATG         PIC X(2).                                    
           10 SESSION-ID           PIC S9(9) USAGE COMP.                        
           10 SESSION-DURATION     PIC S9(4) USAGE COMP.                        
           10 SESSION-START-DATE   PIC X(10).                                   
           10 USR-ID               PIC X(8).                                    
           10 DTS                  PIC X(26).                                   
      ******************************************************************        
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 6       *        
      ******************************************************************        
