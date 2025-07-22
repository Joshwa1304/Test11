//*******************************************************************           
//**                                                               **           
//**    COBOL2 AND COBOL/MVS COMPILE AND LINK-EDIT PROCESSOR                    
//**                                                               **           
//*******************************************************************           
//GCIINBL PROC LISTLIB='&PROJECT..&GROUP.&C1ST..LISTLIB',                       
//             CLECOMP='IGY420.SIGYCOMP',                                       
//             CLERUN='CEE.SCEERUN',                                            
//             CLELKED='CEE.SCEELKED',                                          
//             CIILIB='IGY420.SIGYCOMP',                                        
//             CIICOMP='IGY420.SIGYCOMP',                                       
//             PROJECT='CAI.SCM',                                               
//             GROUP='SMPL',                                                    
//             STG3='EMER',                                                     
//             STG4='PROD',                                                     
//             CSYSLIB1='&PROJECT..&GROUP.&C1ST..COPYLIB',                      
//             CSYSLIB2='&PROJECT..&GROUP.&C1ST2..COPYLIB',                     
//             CSYSLIB3='&PROJECT..&GROUP.&STG3..COPYLIB',                      
//             CSYSLIB4='&PROJECT..&GROUP.&STG4..COPYLIB',                      
//             EXPINC=N,                                                        
//             LOADLIB='&PROJECT..&GROUP.&C1ST..LOADLIB',                       
//             LSYSLIB1='&LOADLIB',                                             
//             LSYSLIB2='&PROJECT..&GROUP.&C1ST2..LOADLIB',                     
//             LSYSLIB3='&PROJECT..&GROUP.&STG3..LOADLIB',                      
//             LSYSLIB4='&PROJECT..&GROUP.&STG4..LOADLIB',                      
//             MEMBER=&C1ELEMENT,                                               
//             MONITOR=COMPONENTS,                                              
//             PARMCOB='LIB,NOSEQ,OBJECT,APOST,',                               
//             PARMLNK='LIST,MAP,XREF',                                         
//             SYSOUT=*,                                                        
//             WRKUNIT=SYSALLDA                                                 
//**********************************************************************        
//*   ALLOCATE TEMPORARY LISTING DATASETS                              *        
//**********************************************************************        
//INIT     EXEC PGM=BC1PDSIN,MAXRC=0                                            
//C1INIT01 DD DSN=&&COBLIST,DISP=(,PASS),                                       
//            UNIT=&WRKUNIT,SPACE=(TRK,(10,10)),                                
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0,DSORG=PS)                      
//C1INIT02 DD DSN=&&LNKLIST,DISP=(,PASS),                                       
//            UNIT=&WRKUNIT,SPACE=(TRK,(10,10)),                                
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0,DSORG=PS)                      
//*********************************************************************         
//* READ SOURCE AND EXPAND INCLUDES                                             
//*********************************************************************         
//CONWRITE EXEC PGM=CONWRITE,COND=(0,LT),MAXRC=0,                               
// PARM='EXPINCL(&EXPINC)'                                                      
//ELMOUT   DD DSN=&&ELMOUT,DISP=(,PASS),                                        
//            UNIT=&WRKUNIT,SPACE=(TRK,(100,100),RLSE),                         
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0),                                
//            MONITOR=&MONITOR                                                  
//*******************************************************************           
//**    COMPILE THE ELEMENT                                        **           
//*******************************************************************           
//COMPILE  EXEC PGM=IGYCRCTL,COND=(0,LT),MAXRC=4,                               
// PARM='&PARMCOB'                                                              
//* TEST PROCESSOR GROUP IF CIINBL THEN ALLOCATE COBOL2 LIBRARIES               
//*                      IF CLENBL ALLOCATE COBOL/MVS RUNTIME LIBS              
//  IF &C1PRGRP=CIINBL THEN                                                     
//STEPLIB  DD  DSN=&CIICOMP,DISP=SHR                                            
//         DD  DSN=&CIILIB,DISP=SHR                                             
// ELSE                                                                         
//* PROCESSOR GROUP IS COBOL/LE                                                 
//STEPLIB  DD  DSN=&CLECOMP,DISP=SHR                                            
//         DD  DSN=&CLERUN,DISP=SHR                                             
// ENDIF                                                                        
//*******************************************************************           
//*     COPYLIB CONCATENATIONS                                     **           
//*******************************************************************           
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
//SYSIN    DD  DSN=&&ELMOUT,DISP=(OLD,PASS)                                     
//SYSLIN   DD  DSN=&&SYSLIN,DISP=(,PASS,DELETE),                                
//             UNIT=&WRKUNIT,SPACE=(TRK,(100,100),RLSE),                        
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=0),                               
//             FOOTPRNT=CREATE                                                  
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
//* IF PROCESSOR GROUP IS CIINBL THEN ALLOC COB2 CALL LIBRARY COB2LIB           
//  IF &C1PRGRP=CIINBL THEN                                                     
//         DD  DSN=&CIILIB,                                                     
//             DISP=SHR                                                         
//  ELSE                                                                        
//* IF PROCESSOR GROUP IS COBOL/LE THEN ALLOC LE CALL LIBRARY SCEELKED          
//         DD  DSN=&CLELKED,                                                    
//             DISP=SHR                                                         
//  ENDIF                                                                       
//SYSUT1   DD  UNIT=&WRKUNIT,SPACE=(CYL,(1,1))                                  
//SYSPRINT DD  DSN=&&LNKLIST,DISP=(OLD,PASS)                                    
//*******************************************************************           
//*     STORE THE LISTINGS IF:  &LISTLIB=LISTING LIBRARY NAME       *           
//*******************************************************************           
//STORLIST EXEC PGM=CONLIST,MAXRC=0,PARM=STORE,COND=EVEN,                       
//           EXECIF=(&LISTLIB,NE,NO)                                            
//C1LLIBO  DD DSN=&LISTLIB,DISP=SHR,                                            
//            MONITOR=&MONITOR                                                  
//C1BANNER DD UNIT=&WRKUNIT,SPACE=(TRK,(1,1)),                                  
//            DCB=(RECFM=FBA,LRECL=121,BLKSIZE=0)                               
//LIST01   DD DSN=&&COBLIST,DISP=(OLD,DELETE)                                   
//LIST02   DD DSN=&&LNKLIST,DISP=(OLD,DELETE)                                   
//*******************************************************************           
//*     PRINT THE LISTINGS IF:  &LISTLIB=NO                         *           
//*******************************************************************           
//PRNTLIST EXEC PGM=CONLIST,MAXRC=0,PARM=PRINT,COND=EVEN,                       
//           EXECIF=(&LISTLIB,EQ,NO)                                            
//C1BANNER DD UNIT=&WRKUNIT,SPACE=(TRK,(1,1)),                                  
//            DCB=(RECFM=FBA,LRECL=121,BLKSIZE=0,DSORG=PS)                      
//C1PRINT  DD SYSOUT=&SYSOUT,                                                   
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0,DSORG=PS)                      
//LIST01   DD DSN=&&COBLIST,DISP=(OLD,DELETE)                                   
//LIST02   DD DSN=&&LNKLIST,DISP=(OLD,DELETE)                                   
//**                                                                            
