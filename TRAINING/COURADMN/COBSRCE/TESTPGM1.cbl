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
           COPY CPPGDEMO.                                                       
                                                                                
       PROCEDURE DIVISION.                                                      
                                                                                
           MOVE -12345     TO WS-PD.                                            
           MOVE WS-PD      TO WS-EDITED.                                        
           DISPLAY WS-EDITED.                                                   
           MOVE -45245     TO WS-PD.                                            
           MOVE WS-PD      TO WS-EDITED.                                        
           DISPLAY WS-EDITED.                                                   
           MOVE -13445     TO WS-PD.                                            
           MOVE WS-PD      TO WS-EDITED.                                        
           DISPLAY WS-EDITED.                                                   
           MOVE 12345      TO WS-PD.                                            
           MOVE WS-PD      TO WS-EDITED.                                        
           DISPLAY WS-EDITED.                                                   
           MOVE 998        TO WS-PD.                                            
           MOVE WS-PD      TO WS-EDITED.                                        
           DISPLAY WS-EDITED.                                                   
           MOVE 12         TO WS-PD.                                            
           MOVE WS-PD      TO WS-EDITED.                                        
           DISPLAY WS-EDITED.                                                   
           GOBACK.                                                              
