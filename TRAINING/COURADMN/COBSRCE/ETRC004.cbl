       IDENTIFICATION DIVISION.                                                 
000200 PROGRAM-ID.    TESTPGM1.                                                 
000300 AUTHOR.        ANAND V.                                                  
000800******************************************************************        
000900*  TEST PROGRAM.                                                 *        
001000******************************************************************        
001300 ENVIRONMENT DIVISION.                                                    
001400                                                                          
001500 CONFIGURATION SECTION.                                                   
001600                                                                          
001700 SOURCE-COMPUTER. Z900.                                                   
001800 OBJECT-COMPUTER. Z900.                                                   
001900                                                                          
002500 DATA DIVISION.                                                           
002600                                                                          
002700                                                                          
002800 WORKING-STORAGE SECTION.                                                 
002900                                                                          
003000******************************************************************        
003100*  APPLICATION-SPECIFIC WORKING STORAGE                          *        
003200******************************************************************        
003200******************************************************************        
003200******************************************************************        
           COPY ETRCCOP1.                                                       
           COPY ETRCCOP2.                                                       
                                                                                
       PROCEDURE DIVISION.                                                      
                                                                                
           MOVE -12345     TO WS-PD1.                                           
           MOVE WS-PD1      TO WS-EDITED1.                                      
           DISPLAY WS-EDITED1.                                                  
           MOVE -45245     TO WS-PD1.                                           
           MOVE WS-PD1      TO WS-EDITED1.                                      
           DISPLAY WS-EDITED1.                                                  
           MOVE -13445     TO WS-PD1.                                           
           MOVE WS-PD1     TO WS-EDITED1.                                       
           DISPLAY WS-EDITED1.                                                  
           MOVE 12345      TO WS-PD2.                                           
           MOVE WS-PD2      TO WS-EDITED2.                                      
           DISPLAY WS-EDITED2.                                                  
           MOVE 998        TO WS-PD2.                                           
           MOVE WS-PD2      TO WS-EDITED2.                                      
           DISPLAY WS-EDITED2.                                                  
           GOBACK.                                                              
