//*******************************************************************           
//**                                                               **           
//**  PERFORMS A DB2, CICS PRE COMPILE, COBOL LINK EDIT AND        **           
//**  GENERATE LOAD MODULE                                         **           
//**                                                               **           
//*******************************************************************           
//GCIIDCL PROC LISTLIB='&PROJECT..&C1ST..LISTLIB',                              
//             CLECOMP='IGY420.SIGYCOMP',                                       
//             CLERUN='CEE.SCEERUN',                                            
//             CLELKED='CEE.SCEELKED',                                          
//             CIILIB='IGY420.SIGYCOMP',                                        
//             CIICOMP='IGY420.SIGYCOMP',                                       
//             DB2SYS='DBAG',                                                   
//             DB2LOADL='DSNA10.SDSNLOAD',                                      
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
//             LOADLIB='DFH420.&C1ST..SDFHLOAD',                                
//             LSYSLIB1='&LOADLIB',                                             
//             LSYSLIB2='DFH420.&STG2..SDFHLOAD',                               
//             LSYSLIB3='DFH420.&STG3..SDFHLOAD',                               
//             LSYSLIB4='DFH420.&STG4..SDFHLOAD',                               
//             MEMBER=&C1ELEMENT,                                               
//             MONITOR=COMPONENTS,                                              
//             PARMLIB='&PROJECT..&C1ST..PARMLIB',                              
//             PARMPC='HOST(IBMCOB),APOST,APOSTSQL,SQL',                        
//             PARMCOB='LIB,NOSEQ,OBJECT,APOST,SQL("DB2")',                     
//             PARMLNK='LIST,MAP,XREF',                                         
//             PLAN=&MEMBER,                                                    
//             SYSOUT=A,                                                        
//             WRKUNIT=SYSALLDA,                                                
//             CICPRFX='DFH420.CICS',                                           
//             LODPRFX='FEK850'                                                 
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
//*    CICS TRANSLATOR                                                          
//*********************************************************************         
//CICSTRAN  EXEC PGM=DFHECP1$,PARM=('COBOL2','CICS(SP)','QUOTE')                
//STEPLIB  DD DISP=SHR,                                                         
//            DSN=&CICPRFX..SDFHLOAD                                            
//         DD DISP=SHR,                                                         
//            DSN=&LODPRFX..SFEKLOAD                                            
//SYSIN    DD DISP=(OLD,DELETE),DSN=&&ELMOUT                                    
//SYSLIB   DD DSN=&CICPRFX..SDFHCOB,DISP=SHR                                    
//SYSPRINT DD SYSOUT=*,DCB=BLKSIZE=13300                                        
//SYSPUNCH DD DSN=&&CPREOUT,DISP=(MOD,PASS),                                    
//            UNIT=SYSALLDA,SPACE=(1800,(2500,2500))                            
//*********************************************************************         
//*    DB2 PRECOMPILIER PROCESSING                                              
//*********************************************************************         
//PRECOMP  EXEC PGM=DSNHPC,COND=(4,LT),MAXRC=4,                                 
// PARM='&PARMPC'                                                               
//STEPLIB   DD DSN=&DB2LOADL,DISP=SHR                                           
//DBRMLIB   DD DSN=&DBRMLIB(&MEMBER),DISP=SHR,                                  
//             MONITOR=&MONITOR,                                                
//             FOOTPRNT=CREATE                                                  
//SYSIN     DD DSN=&&CPREOUT,DISP=OLD                                           
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
// PARM='&PARMCOB'                                                              
//EN$TRITE DD DUMMY                                                             
//STEPLIB  DD  DSN=&CIICOMP,DISP=SHR                                            
//         DD  DSN=&CIILIB,DISP=SHR                                             
//         DD  DSN=&CLECOMP,DISP=SHR                                            
//         DD  DSN=&CLERUN,DISP=SHR                                             
//         DD DSN=&DB2LOADL,DISP=SHR                                            
//*******************************************************************           
//*     COPYLIB CONCATENATIONS                                     **           
//*******************************************************************           
//DBRMLIB  DD DSN=&DBRMLIB(&MEMBER),DISP=SHR                                    
//SYSLIB   DD DSN=&CSYSLIB1,MONITOR=&MONITOR,DISP=SHR                           
//         DD DSN=&CSYSLIB2,MONITOR=&MONITOR,DISP=SHR                           
//         DD DSN=&CSYSLIB3,MONITOR=&MONITOR,DISP=SHR                           
//         DD DSN=&CSYSLIB4,MONITOR=&MONITOR,DISP=SHR                           
//         DD DSN=&DSYSLIB1,MONITOR=&MONITOR,DISP=SHR                           
//         DD DSN=&DSYSLIB2,MONITOR=&MONITOR,DISP=SHR                           
//         DD DSN=&DSYSLIB3,MONITOR=&MONITOR,DISP=SHR                           
//         DD DSN=&DSYSLIB4,MONITOR=&MONITOR,DISP=SHR                           
//         DD DSN=&CICPRFX..SDFHCOB,DISP=SHR                                    
//         DD DSN=&CICPRFX..SDFHMAC,DISP=SHR                                    
//         DD DSN=&CICPRFX..SDFHSAMP,DISP=SHR                                   
//         DD DSN=DSN910.SDSNLOAD,DISP=SHR                                      
//SYSIN    DD DSN=&&PREOUT,DISP=(OLD,PASS)                                      
//SYSLIN   DD DSN=&&SYSLIN,DISP=(,PASS),                                        
//     UNIT=&WRKUNIT,SPACE=(TRK,(10,10)),                                       
//     DCB=(RECFM=FB,LRECL=80,BLKSIZE=0),                                       
//     FOOTPRNT=CREATE                                                          
//SYSUT1   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT2   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT3   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT4   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT5   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT6   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSUT7   DD  UNIT=&WRKUNIT,SPACE=(CYL,(5,3))                                  
//SYSPRINT DD  DSN=&&COBLIST,DISP=(OLD,PASS)                                    
//*SYSPRINT DD  DUMMY                                                           
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
//SYSLIB   DD  DSN=&LSYSLIB1,MONITOR=&MONITOR,DISP=SHR                          
//         DD  DSN=&LSYSLIB2,MONITOR=&MONITOR,DISP=SHR                          
//         DD  DSN=&LSYSLIB3,MONITOR=&MONITOR,DISP=SHR                          
//         DD  DSN=&LSYSLIB4,MONITOR=&MONITOR,DISP=SHR                          
//         DD  DSN=&CICPRFX..SDFHLOAD,DISP=SHR                                  
//         DD  DSN=TCPIP.SEZATCP,DISP=SHR                                       
//         DD  DSN=&DB2LOADL,DISP=SHR                                           
//         DD  DSN=&CIILIB,DISP=SHR                                             
//         DD  DSN=&CLELKED,DISP=SHR                                            
//SYSUT1   DD  UNIT=&WRKUNIT,SPACE=(CYL,(1,1))                                  
//SYSPRINT DD  DSN=&&LNKLIST,DISP=(OLD,PASS)                                    
//SYSPRINT DD  DSN=ROYAL.TEST.LISTLIB(TEST1),DISP=SHR                           
