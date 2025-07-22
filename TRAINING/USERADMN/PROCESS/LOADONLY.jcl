//**********************************************************************        
//*                                                                    *        
//* COPY SOURCELES LOAD MODULES FROM USER DATA SETS TO STAGE1       *           
//*                                                                    *        
//**********************************************************************        
//*                                                                             
//LOADONLY  PROC LISTLIB='&PROJECT..SMPL&C1ST..LISTLIB',                        
//               LOADLIB1='&PROJECT..SMPL&C1ST..LOADLIB',                       
//               LOADLIB2='&PROJECT..SMPL&STG2..LOADLIB',                       
//               PROJECT='ROYAL',                                               
//*              GROUP='SCM',                                                   
//               STG2='&C1SSTAGE.',  FROM STAGE FOR TRANSFER/MOVE               
//               MONITOR=COMPONENTS,                                            
//               SYSOUT=*,                                                      
//               WRKUNIT=SYSALLDA                                               
//**********************************************************************        
//*   ALLOCATE TEMPORARY LISTING DATASETS                              *        
//**********************************************************************        
//INIT     EXEC PGM=BC1PDSIN                                                    
//C1INIT01 DD DSN=&&COPYLIST,                                                   
//            DISP=(NEW,PASS,DELETE),                                           
//            UNIT=&WRKUNIT,                                                    
//            SPACE=(CYL,(1,2),RLSE),                                           
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0,DSORG=PS)                      
//**********************************************************************        
//*                                                                    *        
//* ONLY PERFORM COPY FROM USER LOADLIB WHEN ADD OR UPDATE IS REQUESTED*        
//*                                                                    *        
//**********************************************************************        
//IF1  IF ((&C1ACTION=ADD) OR (&C1ACTION=UPDATE)) THEN                          
//ADD     EXEC PGM=BSTCOPY,MAXRC=04                                             
//SYSPRINT  DD DSN=&&COPYLIST,DISP=(OLD,PASS)                                   
//SYSUT3    DD UNIT=&WRKUNIT,SPACE=(TRK,(1,1))                                  
//SYSUT4    DD UNIT=&WRKUNIT,SPACE=(TRK,(1,1))                                  
//INDD      DD DSN=&C1USRDSN,DISP=SHR                                           
//OUTDD     DD DSN=&LOADLIB1,DISP=SHR,FOOTPRNT=CREATE                           
//SYSIN     DD *                                                                
  COPY    I=INDD,O=OUTDD                                                        
  SELECT MEMBER=((&C1USRMBR,&C1ELEMENT,R))                                      
//END1  ENDIF                                                                   
//**********************************************************************        
//*                                                                    *        
//* IF TRANSFER,COPY FROM SOURCE LOADLIB TO CURRENT LOADLIB            *        
//*                                                                    *        
//**********************************************************************        
//IF2  IF (&C1ACTION=TRANSFER) OR (&C1ACTION=MOVE) THEN                         
//TRANSFER EXEC PGM=BSTCOPY,MAXRC=04                                            
//SYSPRINT  DD  DSN=&&COPYLIST,DISP=(OLD,PASS)                                  
//SYSUT3    DD  UNIT=&WRKUNIT,SPACE=(TRK,(1,1))                                 
//SYSUT4    DD  UNIT=&WRKUNIT,SPACE=(TRK,(1,1))                                 
//OUTDD     DD  DSN=&LOADLIB1,DISP=SHR,FOOTPRNT=VERIFY                          
//INDD      DD  DSN=&LOADLIB2,DISP=SHR,FOOTPRNT=CREATE                          
//SYSIN     DD  *                                                               
  COPY    I=INDD,O=OUTDD                                                        
  SELECT MEMBER=((&C1ELEMENT,,R))                                               
//END2  ENDIF                                                                   
//*******************************************************************           
//*            STORE THE LISTINGS IF:  &LISTLIB=LISTING LIBRARY     *           
//*******************************************************************           
//STORLIST EXEC PGM=CONLIST,PARM='STORE',COND=EVEN,                             
//           EXECIF=(&LISTLIB,NE,NO)                                            
//C1LLIBO  DD DSN=&LISTLIB,DISP=SHR                                             
//C1BANNER DD DSN=&&BANNER,DISP=(,PASS,DELETE),                                 
//            UNIT=&WRKUNIT,SPACE=(TRK,(1,1)),                                  
//            DCB=(RECFM=FBA,LRECL=121,BLKSIZE=0,DSORG=PS)                      
//LIST01   DD DSN=&&COPYLIST,DISP=(OLD,DELETE)                                  
//*******************************************************************           
//*     PRINT THE LISTINGS IF:  &LISTLIB=NO                         *           
//*******************************************************************           
//PRNTLIST EXEC PGM=CONLIST,MAXRC=0,PARM=PRINT,COND=EVEN,                       
//           EXECIF=(&LISTLIB,EQ,NO)                                            
//C1BANNER DD UNIT=&WRKUNIT,SPACE=(TRK,(1,1)),                                  
//            DCB=(RECFM=FBA,LRECL=121,BLKSIZE=0,DSORG=PS)                      
//C1PRINT  DD SYSOUT=&SYSOUT,                                                   
//            DCB=(RECFM=FBA,LRECL=133,BLKSIZE=0,DSORG=PS)                      
//LIST01   DD DSN=&&COPYLIST,DISP=(OLD,DELETE)                                  
//*                                                                             
//**                                                                            
