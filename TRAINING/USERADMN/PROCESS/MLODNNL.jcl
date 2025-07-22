//**********************************************************************        
//*                                                                    *        
//* COPY LOAD MODULES FROM STAGE 1 TO STAGE 2 AND THEIR ASSOCIATED     *        
//* COMPONENT LIST AND LISTINGS.                                       *        
//*                                                                    *        
//**********************************************************************        
//*                                                                             
//MLODNNL  PROC  LISTLIB='YES',                                                 
//               LISTLIB1='&PROJECT..&STG1..LISTLIB',                           
//               LISTLIB2='&PROJECT..&STG2..LISTLIB',                           
//               LOADLIB1='&PROJECT..&STG1..LOADLIB',                           
//               LOADLIB2='&PROJECT..&STG2..LOADLIB',                           
//               PROJECT='ROYAL',                                               
//*              GROUP='SMPL',                                                  
//               STG1='&C1SSTAGE.',     CURRENT STAGE                           
//               STG2='&C1STAGE.',      TO STAGE                                
//               MONITOR=COMPONENTS,                                            
//               SYSOUT=*,                                                      
//               WRKUNIT=SYSALLDA                                               
//**********************************************************************        
//*   ALLOCATE TEMPORARY LISTING DATASETS                              *        
//**********************************************************************        
//INIT      EXEC  PGM=BC1PDSIN                                                  
//C1INIT01 DD DSN=&&COPYLIST,DISP=(,PASS,DELETE),                               
//            UNIT=&WRKUNIT,SPACE=(CYL,(1,2),RLSE),                             
//            DCB=(RECFM=V,LRECL=121,BLKSIZE=125,DSORG=PS)                      
//**********************************************************************        
//* COPY THE LOAD MODULE                                               *        
//**********************************************************************        
//BSTCOPY  EXEC PGM=BSTCOPY,MAXRC=04                                            
//SYSPRINT  DD  DSN=&&COPYLIST,DISP=(OLD,PASS)                                  
//SYSUT3    DD  UNIT=&WRKUNIT,SPACE=(TRK,(1,1))                                 
//SYSUT4    DD  UNIT=&WRKUNIT,SPACE=(TRK,(1,1))                                 
//INDD      DD  DSN=&LOADLIB1,DISP=SHR                                          
//OUTDD     DD  DSN=&LOADLIB2,DISP=SHR,MONITOR=&MONITOR                         
//SYSIN     DD  *                                                               
  COPY O=OUTDD,I=INDD                                                           
  SELECT MEMBER=((&C1ELEMENT,,R))                                               
//*******************************************************************           
//*     COPY & STORE THE LISTINGS IF:  &LISTING=LISTING LIBRARY     *           
//*******************************************************************           
//COPYLIST EXEC PGM=CONLIST,MAXRC=0,PARM=COPY,COND=EVEN,                        
//         EXECIF=(&LISTLIB,EQ,YES)                                             
//C1LLIBI  DD DSN=&LISTLIB1,DISP=SHR                                            
//C1LLIBO  DD DSN=&LISTLIB2,DISP=SHR,MONITOR=&MONITOR                           
//C1BANNER DD DSN=&&BANNER,DISP=(,PASS,DELETE),                                 
//            UNIT=&WRKUNIT,SPACE=(TRK,(1,1)),                                  
//            DCB=(RECFM=FBA,LRECL=121,BLKSIZE=6171,DSORG=PS)                   
//LIST01   DD DSN=&&COPYLIST,DISP=(OLD,DELETE)                                  
//*******************************************************************           
//*     PRINT THE LISTINGS IF:  &LISTING=NO                         *           
//*******************************************************************           
//PRNTLIST EXEC PGM=CONLIST,MAXRC=0,PARM=PRINT,COND=EVEN,                       
//         EXECIF=(&LISTLIB,EQ,NO)                                              
//C1BANNER DD UNIT=&WRKUNIT,SPACE=(TRK,(1,1)),                                  
//            DCB=(RECFM=FBA,LRECL=121,BLKSIZE=6171,DSORG=PS)                   
//C1PRINT  DD SYSOUT=&SYSOUT,                                                   
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=1330,DSORG=PS)                   
//LIST01   DD DSN=&&COPYLIST,DISP=(OLD,DELETE)                                  
//**********************************************************************        
//* UPDATE THE COMPONENT LIST WITH THE NEW OUTPUT COMPONENTS           *        
//* AND MOVE THE COMPONENT LIST TO THE NEXT STAGE                               
//**********************************************************************        
//MOVECL   EXEC PGM=BC1PMVCL,COND=(0,NE)                                        
//*                                                                             
