000100 IDENTIFICATION DIVISION.                                                 
000200 PROGRAM-ID.    RCBT001A.                                                 
000300 AUTHOR.        ANAND V.                                                  
000400 INSTALLATION.  RC.                                                       
000500 DATE-WRITTEN.  2014-09-02.                                               
000600 DATE-COMPILED.                                                           
000700                                                                          
000800******************************************************************        
000900*  TEST PROGRAM.                                                 *        
001000******************************************************************        
001100 EJECT                                                                    
001200                                                                          
001300 ENVIRONMENT DIVISION.                                                    
001400                                                                          
001500 CONFIGURATION SECTION.                                                   
001600                                                                          
001700 SOURCE-COMPUTER. Z900.                                                   
001800 OBJECT-COMPUTER. Z900.                                                   
001900                                                                          
002000 DATA DIVISION.                                                           
002600                                                                          
002700                                                                          
002800 WORKING-STORAGE SECTION.                                                 
002900                                                                          
003000******************************************************************        
003100*  APPLICATION-SPECIFIC WORKING STORAGE                          *        
003200******************************************************************        
003300 01 WS-VARIABLES.                                                         
003410    05 WS-INPUT-DTS.                                                      
003500       10 WS-YR                        PIC 9(02) VALUE 9.                 
003600       10 WS-MN                        PIC 9(02) VALUE 12.                
003700       10 WS-DY                        PIC 9(02) VALUE 21.                
003800       10 WS-HR                        PIC 9(02) VALUE 15.                
003900       10 WS-MI                        PIC 9(02) VALUE 57.                
004000       10 WS-SE                        PIC 9(02) VALUE 39.                
004010    05 WS-SECONDS                      PIC S9(9) COMP.                    
004200    05 WS-TEMP-SECONDS                 PIC S9(9) COMP.                    
004300    05 WS-QUOTIENT                     PIC S9(9) COMP.                    
004400    05 WS-OUTPUT-DTS.                                                     
004500       10 WS-YR                        PIC 9(02).                         
004600       10 WS-MN                        PIC 9(02).                         
004700       10 WS-DY                        PIC 9(02).                         
004800       10 WS-HR                        PIC 9(02).                         
004900       10 WS-MI                        PIC 9(02).                         
005000       10 WS-SE                        PIC 9(02).                         
005100    05 WS-DISPLAY-DTS.                                                    
005200       10 WS-YR                        PIC 9(02).                         
005300       10 FILLER                       PIC X(01) VALUE '-'.               
005400       10 WS-MN                        PIC 9(02).                         
005500       10 FILLER                       PIC X(01) VALUE '-'.               
005600       10 WS-DY                        PIC 9(02).                         
005700       10 FILLER                       PIC X(01) VALUE '-'.               
005800       10 WS-HR                        PIC 9(02).                         
005900       10 FILLER                       PIC X(01) VALUE '-'.               
006000       10 WS-MI                        PIC 9(02).                         
006100       10 FILLER                       PIC X(01) VALUE '.'.               
006200       10 WS-SE                        PIC 9(02).                         
006300       10 FILLER                       PIC X(03) VALUE ' / '.             
006400       10 WS-CALCSECS                  PIC 9(10).                         
                                                                                
010200 PROCEDURE DIVISION.                                                      
010300                                                                          
010400 00000-MAIN-LOGIC-PARA.                                                   
010700       COMPUTE WS-SECONDS =  WS-YR OF WS-INPUT-DTS * 32140800 +           
010800                             WS-MN OF WS-INPUT-DTS * 2678400  +           
010900                             WS-DY OF WS-INPUT-DTS * 86400    +           
011000                             WS-HR OF WS-INPUT-DTS * 3600     +           
011100                             WS-MI OF WS-INPUT-DTS * 60       +           
011200                             WS-SE OF WS-INPUT-DTS .                      
011300       MOVE WS-SECONDS      TO WS-TEMP-SECONDS.                           
011400       COMPUTE WS-QUOTIENT = WS-TEMP-SECONDS / 32140800.                  
011500       COMPUTE WS-TEMP-SECONDS = WS-TEMP-SECONDS -                        
011600                                (WS-QUOTIENT * 32140800)                  
011700       MOVE WS-QUOTIENT     TO WS-YR OF WS-OUTPUT-DTS.                    
011800       COMPUTE WS-QUOTIENT = WS-TEMP-SECONDS / 2678400.                   
011900       COMPUTE WS-TEMP-SECONDS = WS-TEMP-SECONDS -                        
012000                                (WS-QUOTIENT * 2678400)                   
012100       MOVE WS-QUOTIENT     TO WS-MN OF WS-OUTPUT-DTS.                    
012200       COMPUTE WS-QUOTIENT = WS-TEMP-SECONDS / 86400.                     
012300       COMPUTE WS-TEMP-SECONDS = WS-TEMP-SECONDS -                        
012400                                (WS-QUOTIENT * 86400)                     
012500       MOVE WS-QUOTIENT     TO WS-DY OF WS-OUTPUT-DTS.                    
012600       COMPUTE WS-QUOTIENT = WS-TEMP-SECONDS / 3600.                      
012700       COMPUTE WS-TEMP-SECONDS = WS-TEMP-SECONDS -                        
012800                                (WS-QUOTIENT * 3600)                      
012900       MOVE WS-QUOTIENT     TO WS-HR OF WS-OUTPUT-DTS.                    
013000       COMPUTE WS-QUOTIENT = WS-TEMP-SECONDS / 60.                        
013100       COMPUTE WS-TEMP-SECONDS = WS-TEMP-SECONDS -                        
013200                                (WS-QUOTIENT * 60)                        
013300       MOVE WS-QUOTIENT     TO WS-MI OF WS-OUTPUT-DTS.                    
013400       MOVE WS-TEMP-SECONDS TO WS-SE OF WS-OUTPUT-DTS.                    
013500       MOVE CORRESPONDING WS-INPUT-DTS TO WS-DISPLAY-DTS.                 
013600       MOVE WS-SECONDS                  TO WS-CALCSECS.                   
013700       DISPLAY WS-DISPLAY-DTS.                                            
013800       MOVE CORRESPONDING WS-OUTPUT-DTS TO WS-DISPLAY-DTS.                
013900       DISPLAY WS-DISPLAY-DTS.                                            
020200       GOBACK.                                                            
