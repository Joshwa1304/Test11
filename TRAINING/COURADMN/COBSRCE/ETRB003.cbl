000100 IDENTIFICATION DIVISION.                                         00010000
000200 PROGRAM-ID. ETRB002.                                             00020000
000300 ENVIRONMENT DIVISION.                                            00030000
000400 DATA DIVISION.                                                   00040000
000500 WORKING-STORAGE SECTION.                                         00050000
000600 01  WS-SQLCODE PIC +(11).                                        00060000
000700*     "BTCH SCL ADD UPDT IF PRSNT NPG-RAVI"                       00070000
000800*     COPY CPDCLREG.                                              00080000
000900 01  WS-REGISTRATION.                                             00090000
001000     10 WS-SESSION-CATG         PIC X(2).                         00100000
001100     10 WS-SESSION-ID           PIC S9(9) USAGE COMP.             00110000
001200     10 WS-EMAIL-ADDR.                                            00120000
001300        49 WS-EMAIL-ADDR-LEN    PIC S9(4) USAGE COMP.             00130000
001400        49 WS-EMAIL-ADDR-TEXT   PIC X(120).                       00140000
001500     10 WS-FULL-NAME.                                             00150000
001600        49 WS-FULL-NAME-LEN     PIC S9(4) USAGE COMP.             00160000
001700        49 WS-FULL-NAME-TEXT    PIC X(130).                       00170000
001800     10 WS-ORG-NAME.                                              00180000
001900        49 WS-ORG-NAME-LEN      PIC S9(4) USAGE COMP.             00190000
002000        49 WS-ORG-NAME-TEXT     PIC X(120).                       00200000
002100     10 WS-REG-DATE             PIC X(10).                        00210000
002200     10 WS-REG-STATUS           PIC X(1).                         00220000
002300     10 WS-DTS                  PIC X(26).                        00230000
002400     EXEC SQL                                                     00240000
002500          INCLUDE SQLCA                                           00250000
002600     END-EXEC.                                                    00260000
002700     EXEC SQL                                                     00270000
002800          INCLUDE DCLRGSTR                                        00280000
002900     END-EXEC.                                                    00290000
003000 PROCEDURE DIVISION.                                              00300000
003100     DISPLAY 'PROGRAM STARTED'.                                   00310000
003200     MOVE 'TR' TO WS-SESSION-CATG.                                00320000
003300     DISPLAY 'OUT SIDE SQL BLOCK : ' WS-SESSION-CATG.             00330000
003400*                                                                 00340000
003500      EXEC SQL                                                    00350000
003600        SELECT SESSION_CATG, SESSION_ID, REG_DATE, REG_STATUS     00360000
003700               INTO  :WS-SESSION-CATG, :WS-SESSION-ID,            00370000
003800                     :WS-REG-DATE, :WS-REG-STATUS                 00380000
003900            FROM DBODEVP.REGISTRATION                             00390000
004000            WHERE SESSION_CATG= :WS-SESSION-CATG                  00400000
004100      END-EXEC.                                                   00410000
004200      MOVE SQLCODE TO WS-SQLCODE                                  00420000
004300            DISPLAY ' SQL CODE   '  SQLCODE                       00430000
004400      IF SQLCODE = 0                                              00440000
004500                                                                  00450000
004600            DISPLAY ' SQL EXECUTED SUCCESSFULLY '                 00460000
004700            DISPLAY ' REGISTRATION DETAILS '                      00470000
004800            DISPLAY ' SESSION-CATG  : ' WS-SESSION-CATG           00480000
004900            DISPLAY ' SESSION-ID    : ' WS-SESSION-ID             00490000
005000*           DISPLAY ' EMAIL-ADDR    : ' WS-EMAIL-ADDR             00500000
005100*           DISPLAY ' FULL-NAME     : ' WS-FULL-NAME              00510000
005200*           DISPLAY ' ORG-NAME      : ' WS-ORG-NAME               00520000
005300            DISPLAY ' REG-DATE      : ' WS-REG-DATE               00530000
005400*           DISPLAY ' REG-STATUS    : ' WS-REG-STATUS             00540000
005500       ELSE                                                       00550000
005600            DISPLAY ' SQL FAILED '                                00560000
005700            DISPLAY ' SQL CODE   '  SQLCODE                       00570000
005800            DISPLAY ' SQL CODE   '  WS-SQLCODE                    00580000
005900            DISPLAY ' SQL STATE  '  SQLSTATE                      00590000
006000            DISPLAY ' SQL ERRMC  '  SQLERRMC                      00600000
006100       END-IF.                                                    00610000
006200     DISPLAY 'PROGRAM ENDED'.                                     00620000
006210*INCLUDING BELOW DISPLAY LINE FOR TESTING API - 24-03-2015        00621000
006300     DISPLAY 'END OF DISPLAY - API TESTING'                       00630000
006400     STOP RUN.                                                    00640000
