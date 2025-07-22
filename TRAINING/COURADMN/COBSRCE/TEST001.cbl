000100 IDENTIFICATION DIVISION.                                         00010000
000200 PROGRAM-ID. DEMOPGM1.                                            00020021
000300 ENVIRONMENT DIVISION.                                            00030000
000400 DATA DIVISION.                                                   00040000
000500 WORKING-STORAGE SECTION.                                         00050000
000600 01  WS-SQLCODE PIC +(11).                                        00060000
001000*                                                                 00100000
001100     EXEC SQL                                                     00110000
001200          INCLUDE SQLCA                                           00120000
001300     END-EXEC.                                                    00130000
001310     EXEC SQL                                                     00131006
001320          INCLUDE EMP999                                          00132014
001330     END-EXEC.                                                    00133006
001400 PROCEDURE DIVISION.                                              00140000
001500     DISPLAY 'PROGRAM STARTED'.                                   00150000
001600     MOVE 'AAAA' TO ENO.                                          00160018
001610     DISPLAY ' ENO BEFORE EXEC : ' ENO                            00161016
001700*                                                                 00170000
002400      EXEC SQL                                                    00240000
002500            SELECT ENO, ENAME                                     00250011
002600               INTO :ENO, :ENAME                                  00260011
002700            FROM VIJILAK.EMP999                                   00270017
002800            WHERE ENO = :ENO                                      00280014
002900      END-EXEC.                                                   00290000
003000      MOVE SQLCODE TO WS-SQLCODE                                  00300000
003010            DISPLAY ' SQL CODE   '  SQLCODE                       00301000
003100      IF SQLCODE = 0                                              00310000
003200            DISPLAY ' SQL EXECUTED SUCCESSFULLY '                 00320000
003300            DISPLAY ' EMPLOYEE INFO : ' ENO                       00330011
003400            DISPLAY ' ENAME     : ' ENAME                         00340010
003410*           DISPLAY ' SALARY      : ' ESAL                        00341011
003500       ELSE                                                       00350000
003600            DISPLAY ' SQL FAILED '                                00360000
003700            DISPLAY ' SQL CODE   '  SQLCODE                       00370000
003800            DISPLAY ' SQL CODE   '  WS-SQLCODE                    00380000
003900            DISPLAY ' SQL STATE  '  SQLSTATE                      00390000
004000            DISPLAY ' SQL ERRMC  '  SQLERRMC                      00400000
004100       END-IF.                                                    00410000
004200     DISPLAY 'PROGRAM ENDED'.                                     00420000
004300     STOP RUN.                                                    00430000
