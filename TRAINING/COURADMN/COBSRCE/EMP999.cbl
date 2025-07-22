      ******************************************************************        
      * DCLGEN TABLE(VIJILAK.EMP999)                                   *        
      *        LIBRARY(ROYAL.DEVP.DCLGLIB.COBOL(EMP999))               *        
      *        LANGUAGE(COBOL)                                         *        
      *        QUOTE                                                   *        
      *        LABEL(YES)                                              *        
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *        
      ******************************************************************        
           EXEC SQL DECLARE VIJILAK.EMP999 TABLE                                
           ( ENO                            CHAR(4),                            
             ENAME                          CHAR(20),                           
             ESAL                           DECIMAL(6, 0)                       
           ) END-EXEC.                                                          
      ******************************************************************        
      * COBOL DECLARATION FOR TABLE VIJILAK.EMP999                     *        
      ******************************************************************        
       01  DCLEMP999.                                                           
      *    *************************************************************        
           10 ENO                  PIC X(4).                                    
      *    *************************************************************        
           10 ENAME                PIC X(20).                                   
      *    *************************************************************        
           10 ESAL                 PIC S9(6)V USAGE COMP-3.                     
      ******************************************************************        
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 3       *        
      ******************************************************************        
