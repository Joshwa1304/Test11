000100******************************************************************        
000200* LAYOUT OF ERROR INFORMATION RECORDED.                          *        
000300*================================================================*        
000400* Notes/Usage:                                                   *        
000500*================================================================*        
000600* The error information will be recorded in CICS LOG (LOG)       *        
000700*                                                                *        
000800* COPYBOOK IPERRLOG should be included towards the end of your   *        
000900* program.                                                       *        
001000*                                                                *        
001100* After executing DB2 statements, call CHECK-SQLCODE-PARA.       *        
001200* After executing CICS statements, call CHECK-RESPCODE-PARA.     *        
001300* If you'd like to log MISC errors, call LOG-MISC para.          *        
001400*                                                                *        
001500*================================================================*        
001600* - EL-ERROR-USERID will be obtained from CICS.                  *        
001700* - EL-ERROR-NUMBER will be populated.                           *        
001800* - EL-ERROR-TYPE   will be set.                                 *        
001900* - EL-ERROR-MODULE to be populated by the programmer.           *        
002000* - EL-ERROR-PARA-NAME to be populated by the programmer.        *        
002100* - EL-ERROR-TYPE   will hold the condition encountered.         *        
002200*   If DB2 error is detected EL-ERROR-DB2 will be set to TRUE.   *        
002300*   If CICS error is detected, EL-ERROR-CICS will be set to      *        
002400*   TRUE.                                                        *        
002500*   If LOG-MISC-PARA is performed, EL-ERROR-MISC will be set     *        
002600*   to TRUE.                                                     *        
002700*   If LOG-APPL-PARA is performed, EL-ERROR-APPL will be set     *        
002800*   to TRUE.                                                     *        
002900*   You can use the EL-ERROR-TYPE to determine the course of     *        
003000*   action.                                                      *        
003100* - Before calling CHECK-SQLCODE-PARA, populate the following:   *        
003200*   EL-ERROR-DB2-OBJECT                                          *        
003300*    Table name or Cursor Name. If SELECT involves multiple      *        
003400*    provide primary table name that you are obtaining           *        
003500*    information from or provide a meaningful 40 byte            *        
003600*    description of the objects involved.                        *        
003700*   EL-ERROR-ACTION                                              *        
003800*     SELECT, UPDATE, DELETE, FETCH, OPEN, CLOSE, etc.           *        
003900* For DB2, CICS or MISC errors, optionally populate              *        
004000*   EL-ERROR-TEXT                                                *        
004100*     80 bytes of meaningful description.                        *        
004200******************************************************************        
004300 01 EL-SQLCODE-IGNORE                   PIC X(01) VALUE '0'.              
004400    88 EL-SQLCODE-IGNORE-NONE                     VALUE '0'.              
004500    88 EL-SQLCODE-IGNORE-100                      VALUE '1'.              
004600    88 EL-SQLCODE-IGNORE-811                      VALUE '2'.              
004700    88 EL-SQLCODE-IGNORE-803                      VALUE '3'.              
004800    88 EL-SQLCODE-IGNORE-181                      VALUE '4'.              
004900 01 EL-ERROR-INFORMATION.                                                 
005000    05 EL-ERROR-ABSTIME                 PIC S9(15) COMP-3.                
005100    05 EL-CICS-FN-TO-HEX                PIC X(08) VALUE                   
005200       'RCOCBTHX'.                                                        
005300    05 EL-ERROR-TYPE                    PIC 9(02) VALUE 00.               
005400       88 EL-ERROR-NONE                           VALUE 00.               
005500       88 EL-ERROR-APPL                           VALUE 01.               
005600       88 EL-ERROR-DB2                            VALUE 02.               
005700       88 EL-ERROR-CICS                           VALUE 03.               
005800       88 EL-ERROR-MISC                           VALUE 04.               
005900    05 EL-ERROR-NUMBER-TEXT.                                              
006000       10 FILLER                        PIC X(10) VALUE                   
006100          ' ERROR NO:'.                                                   
006200       10 EL-ERROR-NUMBER               PIC 9(10).                        
006300       10 EL-ERROR-NUMBER-REDEF REDEFINES EL-ERROR-NUMBER.                
006400          15 EL-ERROR-NUMBER-MM         PIC 9(02).                        
006500          15 EL-ERROR-NUMBER-DD         PIC 9(02).                        
006600          15 EL-ERROR-NUMBER-HH         PIC 9(02).                        
006700          15 EL-ERROR-NUMBER-MN         PIC 9(02).                        
006800          15 EL-ERROR-NUMBER-SS         PIC 9(02).                        
006900                                                                          
007000    05 EL-ERROR-HEADER.                                                   
007100       10 EL-ERROR-DATE                 PIC X(08).                        
007200       10 EL-ERROR-DATE-REDEF REDEFINES EL-ERROR-DATE.                    
007300          15 EL-ERROR-DATE-MM           PIC 9(02).                        
007400          15 FILLER                     PIC X(01).                        
007500          15 EL-ERROR-DATE-DD           PIC 9(02).                        
007600          15 FILLER                     PIC X(03).                        
007700       10 FILLER                        PIC X(01) VALUE SPACES.           
007800       10 EL-ERROR-TIME                 PIC X(08).                        
007900       10 EL-ERROR-TIME-REDEF REDEFINES EL-ERROR-TIME.                    
008000          15 EL-ERROR-TIME-HH           PIC 9(02).                        
008100          15 FILLER                     PIC X(01).                        
008200          15 EL-ERROR-TIME-MM           PIC 9(02).                        
008300          15 FILLER                     PIC X(01).                        
008400          15 EL-ERROR-TIME-SS           PIC 9(02).                        
008500       10 FILLER                        PIC X(01) VALUE SPACES.           
008600       10 EL-ERROR-MODULE               PIC X(08).                        
008700       10 FILLER                        PIC X(01) VALUE SPACES.           
008800       10 EL-ERROR-USERID               PIC X(08).                        
008900       10 FILLER                        PIC X(01) VALUE SPACES.           
009000       10 EL-ERROR-PARA-NAME            PIC X(30).                        
009100       10 FILLER                        PIC X(01) VALUE SPACES.           
009200       10 EL-ERROR-DESC                 PIC X(20) VALUE SPACES.           
009300          88 EL-ERROR-DESC-BLANK                  VALUE SPACES.           
009400          88 EL-ERROR-DESC-CICS                   VALUE                   
009500             'CICS FUNCTION ERROR'.                                       
009600          88 EL-ERROR-DESC-DB2                    VALUE                   
009700             'DB2 ERROR'.                                                 
009800          88 EL-ERROR-DESC-MISC                   VALUE                   
009900             'MISCELLANEOUS ERROR'.                                       
010000          88 EL-ERROR-DESC-APPL                   VALUE                   
010100             'APPLICATION ERROR'.                                         
010200    05 EL-ERROR-DB2-HEADER.                                               
010300       10 FILLER                        PIC X(08) VALUE                   
010400          'SQLCODE:'.                                                     
010500       10 EL-ERROR-SQLCODE              PIC +(10).                        
010600       10 FILLER                        PIC X(08) VALUE                   
010700          ' OBJECT:'.                                                     
010800       10 EL-ERROR-DB2-OBJECT           PIC X(40).                        
010900       10 FILLER                        PIC X(08) VALUE                   
011000          ' ACTION:'.                                                     
011100       10 EL-ERROR-ACTION               PIC X(06).                        
011200    05 EL-ERROR-DB2-SQLERRMC.                                             
011300       10 FILLER                        PIC X(08) VALUE                   
011400          'SQLERRM:'.                                                     
011500       10 EL-ERROR-SQLERRMC             PIC X(70).                        
011600    05 EL-ERROR-CICS-HEADER.                                              
011700       15 FILLER                        PIC X(10) VALUE                   
011800          'FUNCTION: '.                                                   
011900       15 EL-ERROR-FUNCTION             PIC X(04).                        
012000       15 FILLER                        PIC X(07) VALUE                   
012100          ' RESP: '.                                                      
012200       15 EL-ERROR-RESP                 PIC +(10).                        
012300       15 FILLER                        PIC X(08) VALUE                   
012400          ' RESP2: '.                                                     
012500       15 EL-ERROR-RESP2                PIC +(10).                        
012600       15 FILLER                        PIC X(07) VALUE                   
012700          ' SRCE: '.                                                      
012800       15 EL-ERROR-SRCE                 PIC X(08).                        
012900    05 EL-ERROR-TEXT                    PIC X(100) VALUE SPACES.          
013000    05 EL-ERROR-LINE                    PIC X(100).                       
