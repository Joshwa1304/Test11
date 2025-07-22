SET FROM  DSNAME 'RCSYSAC.CAI.SCM.CSIQSAMP'.                                    
                                                                                
SET OPTIONS  OVERRIDE SIGNOUT UPDATE                                            
             COMMENT 'DATA SUPPLIED WITH INSTALL'                               
             CCID    'SAMPLE'.                                                  
                                                                                
SET TO ENV   'STUDTEST'                                                         
       SYS   'TRAINING'                                                         
       SUB   'USERADMN'                                                         
       TYPE  'PROCESS'.                                                         
                                                                                
ADD ELEMENT  'GCIIDBL'.                                                         
                                                                                
MOVE ELEMENT '*'                                                                
 FROM ENV    'STUDTEST'                                                         
      SYSTEM 'TRAINING'                                                         
      SUB    '*'                                                                
      TYPE   '*'                                                                
      STAGE  'T'                                                                
 OPTIONS COMMENT 'MOVE PROCESSORS TO PRODUCTION'                                
         CCID    'SAMPLE'                                                       
  .                                                                             
