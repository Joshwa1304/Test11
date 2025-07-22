//*******************************************************************           
//**                                                               **           
//**  PERFORMS A DB2 PRECOMPILE, COBOL2 COMPILE AND LINK EDIT      **           
//**  BINDS THE DB2 PLAN                                           **           
//**                                                               **           
//*******************************************************************           
//GCIIDBL PROC LISTLIB='&PROJECT..&C1ST..LISTLIB',                              
//             CLECOMP='IGY420.SIGYCOMP',                                       
//             CLERUN='CEE.SCEERUN',                                            
//             CLELKED='CEE.SCEELKED',                                          
//             CIILIB='IGY420.SIGYCOMP',                                        
//             CIICOMP='IGY420.SIGYCOMP',                                       
//             DB2SYS='DB9G',                                                   
//             DB2LOADL='DSN910.SDSNLOAD',                                      
//             DBRMLIB='&PROJECT..&C1ST..DBRMLIB',                              
//             PROJECT='ROYAL',                                                 
//*            GROUP='SMPL',                                                    
//             STG1='&C1ST.',       CURRENT ENV STAGE 2 NAME                    
//             STG2='&C1ST2.',      CURRENT ENV STAGE 2 NAME                    
//             STG3='EMER',           EMER STAGE                                
//             STG4='PROD',           PROD STAGE                                
//             CSYSLIB1='&PROJECT..&STG1..COPYLIB.COBOL',                       
//             CSYSLIB2='&PROJECT..&STG2..COPYLIB.COBOL',                       
//             CSYSLIB3='&PROJECT..&STG3..COPYLIB.COBOL',                       
//             CSYSLIB4='&PROJECT..&STG4..COPYLIB.COBOL',                       
//             DSYSLIB1='&PROJECT..&STG1..DCLGLIB.COBOL',                       
//             DSYSLIB2='&PROJECT..&STG2..DCLGLIB.COBOL',                       
//             DSYSLIB3='&PROJECT..&STG3..DCLGLIB.COBOL',                       
//             DSYSLIB4='&PROJECT..&STG4..DCLGLIB.COBOL',                       
//             EXPINC=N,                                                        
//             LOADLIB='&PROJECT..&C1ST..LOADLIB',                              
//             LSYSLIB1='&LOADLIB',                                             
//             LSYSLIB2='&PROJECT..&STG2..LOADLIB',                             
//             LSYSLIB3='&PROJECT..&STG3..LOADLIB',                             
//             LSYSLIB4='&PROJECT..&STG4..LOADLIB',                             
//             SYSDBUG='&PROJECT..&C1ST..SYSDEBUG',                             
//             SYSDBUG1='&SYSDBUG',                                             
//             SYSDBUG2='&PROJECT..&C1ST2..SYSDEBUG',                           
//             SYSDBUG3='&PROJECT..&STG3..SYSDEBUG',                            
//             SYSDBUG4='&PROJECT..&STG4..SYSDEBUG',                            
//             DBGLIB='EQAD10.SEQAMOD',                                         
//             MEMBER=&C1ELEMENT,                                               
//             MONITOR=COMPONENTS,                                              
//             PARMLIB='&PROJECT..&C1ST..PARMLIB',                              
//             PARMPC='HOST(IBMCOB),APOST,APOSTSQL,SQL',                        
//* PARMCOB='LIB,NOSEQ,OBJECT,APOST,SQL("DB2")',                                
//*          'TEST(NONE,SYM,SEPARATE),NOOPT',                                   
//             PARMLNK='LIST,MAP,XREF',                                         
//             PLAN=&MEMBER,                                                    
//             SYSOUT=A,                                                        
//             WRKUNIT=SYSALLDA                                                 
//**********************************************************************        
//*   ALLOCATE TEMPORARY LISTING DATASETS                              *        
//**********************************************************************        
//INIT     EXEC PGM=BC1PDSIN,MAXRC=0                                            
//C1INIT01 DD DISP=(,PASS),DSN=&&DB2PLIST,                                      
//            UNIT=&WRKUNIT,SPACE=(TRK,(10,10)),                                
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0)                               
//C1INIT02 DD DISP=(,PASS),DSN=&&COBLIST,                                       
//            UNIT=&WRKUNIT,SPACE=(TRK,(10,10)),                                
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0)                               
//C1INIT03 DD DISP=(,PASS),DSN=&&LNKLIST,                                       
//            UNIT=&WRKUNIT,SPACE=(TRK,(10,10)),                                
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0)                               
//C1INIT04 DD DISP=(,PASS),DSN=&&PARMLIST,                                      
//            UNIT=&WRKUNIT,SPACE=(TRK,(10,10)),                                
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0)                               
//*********************************************************************         
//* READ SOURCE AND EXPAND INCLUDES                                             
//*********************************************************************         
//CONWRITE EXEC PGM=CONWRITE,COND=(0,LT),MAXRC=0,                               
// PARM='EXPINCL(&EXPINC)'                                                      
//C1INCL01 DD DSN=&CSYSLIB1,DISP=SHR,                                           
//            MONITOR=&MONITOR                                                  
//         DD DSN=&DSYSLIB1,DISP=SHR,                                           
//            MONITOR=&MONITOR                                                  
//C1INCL02 DD DSN=&CSYSLIB2,DISP=SHR,                                           
//            MONITOR=&MONITOR                                                  
//         DD DSN=&DSYSLIB2,DISP=SHR,                                           
//            MONITOR=&MONITOR                                                  
//C1INCL03 DD DSN=&CSYSLIB3,DISP=SHR,                                           
//            MONITOR=&MONITOR                                                  
//         DD DSN=&DSYSLIB3,DISP=SHR,                                           
//            MONITOR=&MONITOR                                                  
//C1INCL04 DD DSN=&CSYSLIB4,DISP=SHR,                                           
//            MONITOR=&MONITOR                                                  
//         DD DSN=&DSYSLIB4,DISP=SHR,                                           
//            MONITOR=&MONITOR                                                  
//ELMOUT   DD DSN=&&ELMOUT,DISP=(,PASS),                                        
//            UNIT=&WRKUNIT,SPACE=(800,(2500,2500),RLSE),                       
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0),                                
//            MONITOR=&MONITOR                                                  
//*********************************************************************         
//*    DB2 PRECOMPILIER PROCESSING                                              
//*********************************************************************         
//PRECOMP  EXEC PGM=DSNHPC,COND=(0,NE),MAXRC=4,                                 
// PARM='&PARMPC'                                                               
//STEPLIB   DD DSN=&DB2LOADL,DISP=SHR                                           
//DBRMLIB   DD DSN=&DBRMLIB(&MEMBER),DISP=SHR,                                  
//             MONITOR=&MONITOR,                                                
//             FOOTPRNT=CREATE                                                  
//SYSIN     DD DSN=&&ELMOUT,DISP=OLD                                            
//SYSCIN    DD DSN=&&PREOUT,DISP=(,PASS),                                       
//             UNIT=&WRKUNIT,SPACE=(800,(2500,2500),RLSE),                      
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)                                
//SYSLIB    DD DSN=&CSYSLIB1,MONITOR=&MONITOR,DISP=SHR                          
//          DD DSN=&CSYSLIB2,MONITOR=&MONITOR,DISP=SHR                          
//          DD DSN=&CSYSLIB3,MONITOR=&MONITOR,DISP=SHR                          
//          DD DSN=&CSYSLIB4,MONITOR=&MONITOR,DISP=SHR                          
//          DD DSN=&DSYSLIB1,MONITOR=&MONITOR,DISP=SHR                          
//          DD DSN=&DSYSLIB2,MONITOR=&MONITOR,DISP=SHR                          
//          DD DSN=&DSYSLIB3,MONITOR=&MONITOR,DISP=SHR                          
//          DD DSN=&DSYSLIB4,MONITOR=&MONITOR,DISP=SHR                          
//SYSTERM   DD SYSOUT=&SYSOUT                                                   
//SYSPRINT  DD DSN=&&DB2PLIST,DISP=(OLD,PASS)                                   
//SYSUT1    DD UNIT=&WRKUNIT,SPACE=(CYL,(1,1))                                  
//SYSUT2    DD UNIT=&WRKUNIT,SPACE=(CYL,(1,1))                                  
//*******************************************************************           
//**    COMPILE THE ELEMENT                                        **           
//*******************************************************************           
//COMPILE  EXEC PGM=IGYCRCTL,COND=(4,LT),MAXRC=4,                               
// PARM='LIB,OBJECT,APOST,SQL("DB2"),TEST(NONE,SYM,SEPARATE),NOOPT'             
//* TEST PROCESSOR GROUP IF CIINBL THEN ALLOCATE COBOL2 LIBRARIES               
//*                      IF CLENBL ALLOCATE COBOL/MVS RUNTIME LIBS              
//* IF &C1PRGRP=CIINBL THEN                                                     
//STEPLIB  DD  DSN=&CIICOMP,DISP=SHR                                            
//         DD  DSN=&CIILIB,DISP=SHR                                             
//*ELSE                                                                         
//* PROCESSOR GROUP IS COBOL/LE                                                 
//         DD  DSN=&CLECOMP,DISP=SHR                                            
//         DD  DSN=&CLERUN,DISP=SHR                                             
//*ENDIF                                                                        
//*******************************************************************           
//*     COPYLIB CONCATENATIONS                                     **           
//*******************************************************************           
//DBRMLIB   DD DSN=&DBRMLIB(&MEMBER),DISP=SHR                                   
//SYSLIB   DD  DSN=&CSYSLIB1,                                                   
//             MONITOR=&MONITOR,                                                
//             DISP=SHR                                                         
//         DD  DSN=&CSYSLIB2,                                                   
//             MONITOR=&MONITOR,                                                
//             DISP=SHR                                                         
//         DD  DSN=&CSYSLIB3,                                                   
//             MONITOR=&MONITOR,                                                
//             DISP=SHR                                                         
//         DD  DSN=&CSYSLIB4,                                                   
//             MONITOR=&MONITOR,                                                
//             DISP=SHR                                                         
//         DD   DSN=&DSYSLIB1,MONITOR=&MONITOR,DISP=SHR                         
//         DD   DSN=&DSYSLIB2,MONITOR=&MONITOR,DISP=SHR                         
//         DD   DSN=&DSYSLIB3,MONITOR=&MONITOR,DISP=SHR                         
//         DD   DSN=&DSYSLIB4,MONITOR=&MONITOR,DISP=SHR                         
//SYSIN    DD  DSN=&&ELMOUT,DISP=(OLD,PASS)                                     
//SYSLIN   DD  DSN=&&SYSLIN,DISP=(,PASS),                                       
//     UNIT=&WRKUNIT,SPACE=(TRK,(10,10)),                                       
//     DCB=(RECFM=FB,LRECL=80,BLKSIZE=0),                                       
//     FOOTPRNT=CREATE                                                          
//SYSDEBUG DD DISP=SHR,MONITOR=COMPONENTS,FOOTPRNT=CREATE,                      
// DSN=&SYSDBUG(&C1ELEMENT)                                                     
//SYSUT1   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT2   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT3   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT4   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT5   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT6   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT7   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSPRINT DD  DSN=&&COBLIST,DISP=(OLD,PASS)                                    
//*******************************************************************           
//**    LINK EDIT THE ELEMENT                                      **           
//*******************************************************************           
//LKED     EXEC PGM=IEWL,COND=(4,LT),MAXRC=4,                                   
// PARM='&PARMLNK'                                                              
//SYSLIN   DD  DSN=&&SYSLIN,DISP=(OLD,DELETE)                                   
//SYSLMOD  DD  DSN=&LOADLIB(&MEMBER),                                           
//             MONITOR=&MONITOR,                                                
//             FOOTPRNT=CREATE,                                                 
//             DISP=SHR                                                         
//DBGLIB DD DISP=SHR,MONITOR=COMPONENTS,DSN=&DBGLIB                             
//SYSLIB   DD  DSN=&LSYSLIB1,                                                   
//             MONITOR=&MONITOR,                                                
//             DISP=SHR                                                         
//         DD  DSN=&LSYSLIB2,                                                   
//             MONITOR=&MONITOR,                                                
//             DISP=SHR                                                         
//         DD  DSN=&LSYSLIB3,                                                   
//             MONITOR=&MONITOR,                                                
//             DISP=SHR                                                         
//         DD  DSN=&LSYSLIB4,                                                   
//             MONITOR=&MONITOR,                                                
//             DISP=SHR                                                         
//         DD  DSN=&DB2LOADL,                                                   
//             DISP=SHR                                                         
//* IF PROCESSOR GROUP IS CIINBL THEN ALLOC COB2 CALL LIBRARY COB2LIB           
//* IF &C1PRGRP=CIINBL THEN                                                     
//         DD  DSN=&CIILIB,                                                     
//             DISP=SHR                                                         
//* ELSE                                                                        
//* IF PROCESSOR GROUP IS COBOL/LE THEN ALLOC LE CALL LIBRARY SCEELKED          
//         DD  DSN=&CLELKED,                                                    
//             DISP=SHR                                                         
//* ENDIF                                                                       
//SYSUT1   DD  UNIT=&WRKUNIT,SPACE=(CYL,(1,1))                                  
//SYSPRINT DD  DSN=&&LNKLIST,DISP=(OLD,PASS)                                    
//SYSPRINT DD  DSN=ROYAL.TEST.LISTLIB(TEST1),DISP=SHR                           
//*********************************************************************         
//*  GENERATE BIND CARDS TO BIND APPLICATION                                    
//*  AND EXECUTING IN FOREGROUND                                                
//*********************************************************************         
//GENBINDC EXEC PGM=IEBGENER,MAXRC=0                                            
//SYSUT2 DD DSN=&PARMLIB(&C1ELEMENT),DISP=SHR                                   
//SYSPRINT DD SYSOUT=*                                                          
//SYSOUT DD SYSOUT=*                                                            
//SYSUT1 DD *                                                                   
  DSN SYSTEM(DB9G)                                                              
    BIND PACKAGE(DALLAS9.PLB&C1ST.C)-                                           
    MEMBER(&C1ELEMENT) -                                                        
    ISOLATION(CS) -                                                             
    RELEASE(C) -                                                                
    SQLERROR(NOPACKAGE)-                                                        
    FLAG(I) -                                                                   
    EXPLAIN(NO)-                                                                
    OWNER(DBO&C1ST.)-                                                           
    LIBRARY('&PROJECT..&C1ST..DBRMLIB') -                                       
    ACTION(REP) -                                                               
    VALIDATE(RUN)                                                               
      BIND PLAN(PLB&C1ST.P)-                                                    
      PKLIST(DALLAS9.PLB&C1ST.C.*)                                              
  END                                                                           
//SYSIN DD DUMMY                                                                
/*                                                                              
//*********************************************************************         
//*  BIND APPLICATION PLAN IF EXECUTING IN FOREGROUND                           
//*  NOTE: ATTEMPTING TO RUN THIS STEP IN BG WILL RESULT IN RC=5                
//*********************************************************************         
//BINDFG  EXEC PGM=BC1PTMP0,MAXRC=5,COND=(4,LT),                                
// PARM='&PARMLIB(&C1ELEMENT)'                                                  
//STEPLIB   DD DSN=&DB2LOADL,DISP=SHR                                           
//DBRMLIB   DD DSN=&DBRMLIB,DISP=SHR                                            
//SYSUDUMP  DD SYSOUT=&SYSOUT                                                   
//SYSPRINT DD  DSN=ROYAL.TEST.LISTLIB(TEST2),DISP=SHR                           
//*********************************************************************         
//*  BIND APPLICATION PLAN IF EXECUTING IN BACKGROUND                 *         
//*********************************************************************         
//BINDBG  EXEC PGM=IKJEFT01,COND=((5,NE,BINDFG),(5,LT)),MAXRC=7                 
//STEPLIB   DD DSN=&DB2LOADL,DISP=SHR                                           
//DBRMLIB   DD DSN=&DBRMLIB,DISP=SHR                                            
//SYSTSPRT  DD DSN=&&PARMLIST,DISP=(OLD,PASS)                                   
//SYSTSIN   DD DSN=&PARMLIB(&C1ELEMENT),DISP=(OLD,PASS)                         
//*******************************************************************           
//*     STORE THE LISTINGS IF:  &LISTLIB=LISTING LIBRARY NAME       *           
//*******************************************************************           
//STORLIST EXEC PGM=CONLIST,MAXRC=0,PARM=STORE,COND=EVEN,                       
//           EXECIF=(&LISTLIB,NE,NO)                                            
//C1LLIBO  DD DSN=&LISTLIB,DISP=SHR,                                            
//            MONITOR=&MONITOR                                                  
//C1BANNER DD UNIT=&WRKUNIT,SPACE=(TRK,(1,1)),                                  
//            DCB=(RECFM=FBA,LRECL=121,BLKSIZE=6171)                            
//LIST01   DD DSN=&&DB2PLIST,DISP=(OLD,DELETE)                                  
//LIST02   DD DSN=&&COBLIST,DISP=(OLD,DELETE)                                   
//LIST03   DD DSN=&&LNKLIST,DISP=(OLD,DELETE)                                   
//LIST04   DD DSN=&&PARMLIST,DISP=(OLD,DELETE)                                  
//SYSPRINT DD  DSN=ROYAL.TEST.LISTLIB(TEST1),DISP=SHR                           
//*******************************************************************           
//*     PRINT THE LISTINGS IF:  &LISTLIB=NO                         *           
//*******************************************************************           
//PRNTLIST EXEC PGM=CONLIST,MAXRC=0,PARM=PRINT,COND=EVEN,                       
//           EXECIF=(&LISTLIB,EQ,NO)                                            
//C1BANNER DD UNIT=&WRKUNIT,SPACE=(TRK,(1,1)),                                  
//            DCB=(RECFM=FBA,LRECL=121,BLKSIZE=6171,DSORG=PS)                   
//C1PRINT  DD SYSOUT=&SYSOUT,                                                   
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=1330,DSORG=PS)                   
//LIST01   DD DSN=&&DB2PLIST,DISP=(OLD,DELETE)                                  
//LIST02   DD DSN=&&COBLIST,DISP=(OLD,DELETE)                                   
//LIST03   DD DSN=&&LNKLIST,DISP=(OLD,DELETE)                                   
//LIST04   DD DSN=&&PARMLIST,DISP=(OLD,DELETE)                                  
//**                                                                            
