//**********************************************************************        
//*                                                                    *        
//*  CICS PRE-COMPILER AND EXECUTABLE MAP                              *        
//*                                                                    *        
//**********************************************************************        
//GCIINCL   PROC  LEPARM='XREF,LIST,LET,NCAL,MAP',                              
//  COPYQUAL='CICS',                                                            
//  CICPRFX='DFH420.CICS',                                                      
//  MONITOR=COMPONENTS,                                                         
//  LOADLIB='DFH420.&C1ST..SDFHLOAD',                                           
//  MACLIB1='ROYAL.&C1ST..MACLIB',                                              
//  LISTLIB='ROYAL.&C1ST..LISTLIB',                                             
//  WRKUNIT=SYSDA                                                               
//*******************************************************************           
//*ALLOCATE TEMPORARY LISTING DATASETS                              *           
//*******************************************************************           
//INIT    EXEC PGM=BC1PDSIN                                                     
//C1INIT01 DD  DSN=&&ASMLIST,DISP=(,PASS,DELETE),                               
//             UNIT=&WRKUNIT,SPACE=(CYL,(1,2)),                                 
//             DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0,DSORG=PS)                     
//C1INIT02 DD  DSN=&&ASM1LST,DISP=(,PASS,DELETE),                               
//             UNIT=&WRKUNIT,SPACE=(CYL,(1,2)),                                 
//             DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0,DSORG=PS)                     
//C1INIT03 DD  DSN=&&LNKLIST,DISP=(,PASS,DELETE),                               
//             UNIT=&WRKUNIT,SPACE=(CYL,(1,2)),                                 
//             DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0,DSORG=PS)                     
//C1INIT04 DD  DSN=&&COPYLST,DISP=(,PASS,DELETE),                               
//             UNIT=&WRKUNIT,SPACE=(CYL,(1,2)),                                 
//             DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0,DSORG=PS)                     
//********************************************************************          
//*  WRITE OUT ELEMENT FROM ENDVR                                               
//********************************************************************          
//WRITE  EXEC  PGM=CONWRITE,PARM='EXPINCL(N)'                                   
//ELMOUT   DD  DSN=&&ELMOUT,DISP=(,PASS),                                       
//             SPACE=(TRK,(5,5)),UNIT=&WRKUNIT,                                 
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=0),                               
//             MONITOR=&MONITOR                                                 
//********************************************************************          
//*   CREATE MAP OBJECT                                                         
//********************************************************************          
//*ASMMAP EXEC  PGM=ASMA90,COND=(0,LT,WRITE),PARM='SYSPARM(AMAP)',              
//ASMMAP EXEC  PGM=ASMA90,COND=(0,LT,WRITE),PARM='SYSPARM(MAP)',                
//             MAXRC=4                                                          
//SYSLIB   DD  DSN=&MACLIB1,DISP=SHR,MONITOR=&MONITOR                           
//         DD  DSN=SYS1.MACLIB,DISP=SHR,                                        
//             DCB=(BLKSIZE=12960),MONITOR=&MONITOR                             
//SYSUT1   DD  DSN=&&SYSUT1,UNIT=SYSDA,SPACE=(CYL,(2,1))                        
//SYSUT2   DD  DSN=&&SYSUT2,UNIT=SYSDA,SPACE=(CYL,(2,1))                        
//SYSUT3   DD  DSN=&&SYSUT3,UNIT=SYSDA,SPACE=(CYL,(2,1))                        
//SYSPRINT DD  DSN=&&ASMLIST,DISP=(MOD,PASS)                                    
//SYSIN    DD  DSN=&&ELMOUT,DISP=(OLD,PASS)                                     
//SYSPUNCH DD  DSN=&&OBJ1,UNIT=SYSDA,SPACE=(TRK,(2,5)),                         
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=0),                               
//             DISP=(NEW,PASS,DELETE)                                           
//*********************************************************************         
//*   CREATE FOOTPRINTED CSECT AS ENDVR CAN NOT FOOTPRINT MAP OBJECT  *         
//*********************************************************************         
//ASMMAP1 EXEC PGM=ASMA90,COND=(0,LT,ASMMAP),PARM='DECK,NOLOAD',                
//             MAXRC=4                                                          
//SYSLIB   DD  DSN=&MACLIB1,DISP=SHR,MONITOR=&MONITOR                           
//         DD  DSN=SYS1.MACLIB,DISP=SHR,                                        
//             MONITOR=&MONITOR                                                 
//SYSUT1   DD  DSN=&&SYSUT1,UNIT=SYSDA,SPACE=(CYL,(2,1))                        
//SYSUT2   DD  DSN=&&SYSUT2,UNIT=SYSDA,SPACE=(CYL,(2,1))                        
//SYSUT3   DD  DSN=&&SYSUT3,UNIT=SYSDA,SPACE=(CYL,(2,1))                        
//SYSPRINT DD  DSN=&&ASM1LST,DISP=(MOD,PASS)                                    
//SYSPUNCH DD  DSN=&&FOOTPRNT,UNIT=SYSDA,SPACE=(TRK,(1,1),RLSE),                
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=0),                               
//             DISP=(,PASS,DELETE),FOOTPRNT=CREATE                              
//SYSIN    DD  *                                                                
&&C1ELEMENT   CSECT                                                             
         DC   C'&&C1ELEMENT'                                                    
         END                                                                    
/*                                                                              
//******************************************************************            
//*EXECUTE MAP LINKEDIT TO CREATE EXECUTABLE MAP                                
//********************************************************************          
//LKED   EXEC  PGM=IEWL,COND=((0,LT,WRITE),(4,LT,ASMMAP)),                      
//             MAXRC=4,PARM='&LEPARM'                                           
//SYSPRINT DD  DSN=&&LNKLIST,DISP=(MOD,PASS)                                    
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(1,1))                                     
//SYSLIN   DD  DSN=&&OBJ1,DISP=(OLD,DELETE)                                     
//         DD  DSN=&&FOOTPRNT,DISP=(OLD,DELETE)                                 
//SYSLMOD  DD  DSN=&LOADLIB(&C1ELEMENT),DISP=SHR,                               
//             MONITOR=&MONITOR                                                 
//********************************************************************          
//*  ASSEMBLE MAP TO CREATE SYMBOLIC MAP (COPY RECORD)               *          
//********************************************************************          
//DSECT   EXEC PGM=ASMA90,PARM='SYSPARM(ADSECT)',                               
//             COND=((0,LT,WRITE),(4,LT,ASMMAP),(4,LT,LKED))                    
//SYSLIB   DD  DSN=&MACLIB1,DISP=SHR,MONITOR=&MONITOR                           
//         DD  DSN=SYS1.MACLIB,DISP=SHR,                                        
//             DCB=(BLKSIZE=12960),MONITOR=&MONITOR                             
//SYSUT1   DD  DSN=&&SYSUT1,UNIT=SYSDA,SPACE=(CYL,(1,1))                        
//SYSUT2   DD  DSN=&&SYSUT2,UNIT=SYSDA,SPACE=(CYL,(1,1))                        
//SYSUT3   DD  DSN=&&SYSUT3,UNIT=SYSDA,SPACE=(CYL,(1,1))                        
//SYSPRINT DD  DSN=&&ASMLST2,DISP=(MOD,PASS)                                    
//SYSIN    DD  DSN=&&ELMOUT,DISP=(OLD,DELETE)                                   
//SYSPUNCH DD  DSN=&&PDSIN,DISP=(,PASS),UNIT=SYSDA,                             
//             SPACE=(TRK,(2,1)),DCB=(LRECL=80,BLKSIZE=0,RECFM=FB)              
//**********************************************************************        
//*  ADD SYMBOLIC MAP W/C1BM3000 TO ENDVR AUTOMAGICALLY                         
//**********************************************************************        
//ADDSTEP EXEC PGM=C1BM3000,PARM=(C1IN2,C1OUT2),MAXRC=08,                       
//         COND=(8,LE)                                                          
//C1IN2    DD  *                                                                
 ADD  ELEMENT  '&C1ELEMENT'                                                     
 FROM FILE 'PUTCOPY'  MEM '&&C1ELEMENT'                                         
 TO   ENVIRONMENT  '&C1ENVMNT'                                                  
      SYSTEM       '&C1SYSTEM'                                                  
      SUBSYSTEM    '&C1SUBSYS'                                                  
      TYPE         'COBCOPY'                                                    
      OPTIONS  UPDATE                                                           
      COMMENTS '&C1COMMENT' CCID '&&C1CCID'                                     
      .                                                                         
//C1OUT2   DD  SYSOUT=*                                                         
//PUTCOPY  DD DSN=&&PDSIN,DISP=(OLD,PASS),UNIT=SYSDA,DCB=DSORG=PS               
//SYSUDUMP DD  SYSOUT=*                                                         
//SYSOUT   DD  SYSOUT=*                                                         
//********************************************************************          
//*  WRITE LISTINGS TO LISTLIB                                       *          
//********************************************************************          
//CONLIST EXEC  PGM=CONLIST,MAXRC=0,PARM=STORE                                  
//C1LLLIBO  DD  DSN=&LISTLIB,DISP=SHR                                           
//LIST01    DD  DSN=&&ASMLIST,DISP=SHR                                          
//LIST02    DD  DSN=&&LNKLIST,DISP=SHR                                          
