//**********************************************************************        
//*                                                                    *        
//*  DELETE LOAD/OBJECT AND LISTING MODULES                            *        
//*                                                                    *        
//**********************************************************************        
//*                                                                             
//*DLODNNL  PROC  LISTLIB='&PROJECT..&GROUP.&STG1..LISTLIB',                    
//*               LOADLIB='&PROJECT..&GROUP.&STG1..LOADLIB',                    
//*               PROJECT='CAI.SCM',                                            
//*               GROUP='SMPL',                                                 
//*              STG1='&C1STAGE.'      CURRENT STAGE                            
//*  FOR STUDENT TRAINING APPLICATION REFER TO NEW VALUES BELOW                 
//DLODNNL  PROC  LISTLIB='&PROJECT..&STG1..LISTLIB',                            
//               LOADLIB='&PROJECT..&STG1..LOADLIB',                            
//               PROJECT='ROYAL',                                               
//              STG1='&C1STAGE.'      CURRENT STAGE                             
//DELMOD   EXEC PGM=CONDELE,MAXRC=12                                            
//C1LIB     DD  DSN=&LOADLIB,DISP=SHR                                           
//**********************************************************************        
//*  DELETE THE LISTING IF: &LISTLIB=LISTING LIBRARY NAME              *        
//**********************************************************************        
//CONLIST  EXEC PGM=CONLIST,PARM='DELETE',MAXRC=12,COND=EVEN,                   
//           EXECIF=(&LISTLIB,NE,NO)                                            
//C1LLIBI  DD  DSN=&LISTLIB,DISP=SHR                                            
