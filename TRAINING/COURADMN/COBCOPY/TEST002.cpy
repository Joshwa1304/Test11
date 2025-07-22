000100 IDENTIFICATION DIVISION.                                         00010000
000200 PROGRAM-ID. DEMOPGM1.                                            00020000
000300 ENVIRONMENT DIVISION.                                            00030000
000400 DATA DIVISION.                                                   00040000
000500 WORKING-STORAGE SECTION.                                         00050000
000600 01  WS-SQLCODE PIC +(11).                                        00060000
000700*                                                                 00070000
000800     EXEC SQL                                                     00080000
000900          INCLUDE SQLCA                                           00090000
001000     END-EXEC.                                                    00100000
001100     EXEC SQL                                                     00110000
001200          INCLUDE EMP999                                          00120000
001300     END-EXEC.                                                    00130000
001400 PROCEDURE DIVISION.                                              00140000
001500     DISPLAY 'PROGRAM STARTED'.                                   00150000
001600     MOVE 'AAAA' TO ENO.                                          00160000
001700     DISPLAY ' ENO BEFORE EXEC : ' ENO                            00170000
001800*                                                                 00180000
001900      EXEC SQL                                                    00190000
002000            SELECT ENO, ENAME                                     00200000
002100               INTO :ENO, :ENAME                                  00210000
002200            FROM VIJILAK.EMP999                                   00220000
002300            WHERE ENO = :ENO                                      00230000
002400      END-EXEC.                                                   00240000
002500      MOVE SQLCODE TO WS-SQLCODE                                  00250000
002600            DISPLAY ' SQL CODE   '  SQLCODE                       00260000
002700      IF SQLCODE = 0                                              00270000
002800            DISPLAY ' SQL EXECUTED SUCCESSFULLY '                 00280000
002900            DISPLAY ' EMPLOYEE INFO : ' ENO                       00290000
003000            DISPLAY ' ENAME     : ' ENAME                         00300000
003100*           DISPLAY ' SALARY      : ' ESAL                        00310000
003200       ELSE                                                       00320000
003300            DISPLAY ' SQL FAILED '                                00330000
003400            DISPLAY ' SQL CODE   '  SQLCODE                       00340000
003500            DISPLAY ' SQL CODE   '  WS-SQLCODE                    00350000
003600            DISPLAY ' SQL STATE  '  SQLSTATE                      00360000
003700            DISPLAY ' SQL ERRMC  '  SQLERRMC                      00370000
003800       END-IF.                                                    00380000
003900     DISPLAY 'PROGRAM ENDED'.                                     00390000
004000     STOP RUN.                                                    00400000
