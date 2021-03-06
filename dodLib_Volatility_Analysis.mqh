//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"

//############################################################################################################# 
//######################################## ARQUIVOS DE SAIDA ################################################## 
//############################################################################################################# 
   
//+------------------------------------------------------------------+
//| VOLATILITY VALIDATION                                            |
//+------------------------------------------------------------------+
void Volat_Analysis_Validation(string texto)
  { 
   Global.filehandle_Volat_Validation = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Volat_Analysis_Validation.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Volat_Validation!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Volat_Validation,0,SEEK_END);
      FileWrite(Global.filehandle_Volat_Validation,TimeCurrent()+texto);
      FileFlush(Global.filehandle_Volat_Validation);
      FileClose(Global.filehandle_Volat_Validation);
     }
   else Alert("Operation FileOpen Volat_Validation failed, error: ",GetLastError() );
        ResetLastError();
   
  }
  
//+------------------------------------------------------------------+
//| VOLATILITY_MAX                                                   |
//+------------------------------------------------------------------+
void Volat_Max(string texto)
  { 
   Global.filehandle_Volat_Max = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Volat_Max.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Volat_Max!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Volat_Max,0,SEEK_END);
      FileWrite(Global.filehandle_Volat_Max,texto);
      FileFlush(Global.filehandle_Volat_Max);
      FileClose(Global.filehandle_Volat_Max);
     }
   else Alert("Operation FileOpen filehandle_Volat_Max failed, error: ",GetLastError() );
        ResetLastError();
   
  }
  
//+------------------------------------------------------------------+
//| VOLATILITY_MIN                                                   |
//+------------------------------------------------------------------+
void Volat_Min(string texto)
  { 
   Global.filehandle_Volat_Min = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Volat_Min.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Volat_Min!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Volat_Min,0,SEEK_END);
      FileWrite(Global.filehandle_Volat_Min,texto);
      FileFlush(Global.filehandle_Volat_Min);
      FileClose(Global.filehandle_Volat_Min);
     }
   else Alert("Operation FileOpen filehandle_Volat_Min failed, error: ",GetLastError() );
        ResetLastError();
   
  }    
  
//+------------------------------------------------------------------+
//| VOLATILITY_RANGE                                                 |
//+------------------------------------------------------------------+
void Volat_Range(string texto)
  { 
   Global.filehandle_Volat_Range = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Volat_Range.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Volat_Range!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Volat_Range,0,SEEK_END);
      FileWrite(Global.filehandle_Volat_Range,texto);
      FileFlush(Global.filehandle_Volat_Range);
      FileClose(Global.filehandle_Volat_Range);
     }
   else Alert("Operation FileOpen filehandle_Volat_Range failed, error: ",GetLastError() );
        ResetLastError();
   
  }   
  
//+------------------------------------------------------------------+
//| VOLATILITY FREQUENCY MAX                                         |
//+------------------------------------------------------------------+
void Volat_Frequency_Max(string texto)
  { 
   Global.filehandle_Volat_Frequency_Max = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Volat_Frequency_Max.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Volat_Frequency_Max!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Volat_Frequency_Max,0,SEEK_END);
      FileWrite(Global.filehandle_Volat_Frequency_Max,texto);
      FileFlush(Global.filehandle_Volat_Frequency_Max);
      FileClose(Global.filehandle_Volat_Frequency_Max);
     }
   else Alert("Operation FileOpen filehandle_Volat_Frequency_Max failed, error: ",GetLastError() );
        ResetLastError();
   
  }    
  
//+------------------------------------------------------------------+
//| VOLATILITY FREQUENCY MIN                                         |
//+------------------------------------------------------------------+
void Volat_Frequency_Min(string texto)
  { 
   Global.filehandle_Volat_Frequency_Min = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Volat_Frequency_Min.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Volat_Frequency_Min!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Volat_Frequency_Min,0,SEEK_END);
      FileWrite(Global.filehandle_Volat_Frequency_Min,texto);
      FileFlush(Global.filehandle_Volat_Frequency_Min);
      FileClose(Global.filehandle_Volat_Frequency_Min);
     }
   else Alert("Operation FileOpen filehandle_Volat_Frequency_Min failed, error: ",GetLastError() );
        ResetLastError();
   
  }           
    
//############################################################################################################# 
//########################################### ANÁLISES ######################################################## 
//############################################################################################################# 
   
//+------------------------------------------------------------------+
//| VOLATILITY FREQUENCY FINAL RESULTS                                          |
//+------------------------------------------------------------------+    
void Volat_Frequency_Results() 
  {
   Volat_Analysis_Validation( " ########################### VOLATILITY FREQUENCY RESULTS ########################### ");
    
    int k=35,l=0;  // numero de periodos
    do
      { 
       Volat_Analysis_Validation( " count_volat_F_max_"+k+":  "+Global.count_volat_F_max[k]); 
       Volat_Frequency_Max(Global.count_volat_F_max[k]); 
       k--;
      } 
    while(k>l); 
    
    Volat_Analysis_Validation( ""+"\n");
    
    int i=35,j=0;  // numero de periodos
    do
      { 
       Volat_Analysis_Validation( " count_volat_F_min_"+i+":  "+Global.count_volat_F_min[i]);
       Volat_Frequency_Min(Global.count_volat_F_min[i]); 
       i--;
      } 
    while(i>j); 
                                                                                                                                    
  }   
                                                                                                                                    

      
  
                              