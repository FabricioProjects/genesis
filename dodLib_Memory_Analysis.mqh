//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"

//############################################################################################################# 
//######################################### ARQUIVOS DE SAIDA ################################################# 
//############################################################################################################# 
   
//+------------------------------------------------------------------+
//| MEMORY_ANALYSIS                                                  |
//+------------------------------------------------------------------+
void Memory_Analysis_Validation(string texto)
  { 
   Global.filehandle_Memory_Validation = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Memory_Analysis_Validation.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Memory_Validation!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Memory_Validation,0,SEEK_END);
      FileWrite(Global.filehandle_Memory_Validation,TimeCurrent()+texto);
      FileFlush(Global.filehandle_Memory_Validation);
      FileClose(Global.filehandle_Memory_Validation);
     }
   else Alert("Operation FileOpen Memory failed, error: ",GetLastError() );
        ResetLastError();
   
  }
  
//+------------------------------------------------------------------+
//| MEMORY_ANALYSIS_30M                                              |
//+------------------------------------------------------------------+
void Memory_Analysis_Validation_30M(string texto)
  { 
   Global.filehandle_Memory_Validation_30M = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Memory_Analysis_Validation_30M.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Memory_Validation_30M!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Memory_Validation_30M,0,SEEK_END);
      FileWrite(Global.filehandle_Memory_Validation_30M,TimeCurrent()+texto);
      FileFlush(Global.filehandle_Memory_Validation_30M);
      FileClose(Global.filehandle_Memory_Validation_30M);
     }
   else Alert("Operation FileOpen Memory_30M failed, error: ",GetLastError() );
        ResetLastError();
   
  }  
  
//+------------------------------------------------------------------+
//| MEMORY_ANALYSIS_MAX                                              |
//+------------------------------------------------------------------+
void Memory_Analysis_Max(string texto)
  { 
   Global.filehandle_Memory_Max = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Memory_Analysis_Max.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Memory_Max!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Memory_Max,0,SEEK_END);
      FileWrite(Global.filehandle_Memory_Max,texto);
      FileFlush(Global.filehandle_Memory_Max);
      FileClose(Global.filehandle_Memory_Max);
     }
   else Alert("Operation FileOpen Memory_Max failed, error: ",GetLastError() );
        ResetLastError();
   
  }
  
//+------------------------------------------------------------------+
//| MEMORY_ANALYSIS_MAX_30M                                          |
//+------------------------------------------------------------------+
void Memory_Analysis_Max_30M(string texto)
  { 
   Global.filehandle_Memory_Max_30M = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Memory_Analysis_Max_30M.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Memory_Max_30M!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Memory_Max_30M,0,SEEK_END);
      FileWrite(Global.filehandle_Memory_Max_30M,texto);
      FileFlush(Global.filehandle_Memory_Max_30M);
      FileClose(Global.filehandle_Memory_Max_30M);
     }
   else Alert("Operation FileOpen Memory_Max_30M failed, error: ",GetLastError() );
        ResetLastError();
   
  }  
  
//+------------------------------------------------------------------+
//| MEMORY_ANALYSIS_MIN                                              |
//+------------------------------------------------------------------+
void Memory_Analysis_Min(string texto)
  { 
   Global.filehandle_Memory_Min = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Memory_Analysis_Min.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Memory_Min!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Memory_Min,0,SEEK_END);
      FileWrite(Global.filehandle_Memory_Min,texto);
      FileFlush(Global.filehandle_Memory_Min);
      FileClose(Global.filehandle_Memory_Min);
     }
   else Alert("Operation FileOpen Memory_Min failed, error: ",GetLastError() );
        ResetLastError();
   
  }    
  
//+------------------------------------------------------------------+
//| MEMORY_ANALYSIS_MIN_30M                                              |
//+------------------------------------------------------------------+
void Memory_Analysis_Min_30M(string texto)
  { 
   Global.filehandle_Memory_Min_30M = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Memory_Analysis_Min_30M.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_Memory_Min_30M!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_Memory_Min_30M,0,SEEK_END);
      FileWrite(Global.filehandle_Memory_Min_30M,texto);
      FileFlush(Global.filehandle_Memory_Min_30M);
      FileClose(Global.filehandle_Memory_Min_30M);
     }
   else Alert("Operation FileOpen Memory_Min_30M failed, error: ",GetLastError() );
        ResetLastError();
   
  }    
    
//############################################################################################################# 
//########################################### ANÁLISES ######################################################## 
//############################################################################################################# 
     
//+------------------------------------------------------------------+
//| MIN MAX ALLOCATION                                               |
//+------------------------------------------------------------------+    
void Memory_Day_Min_Max() 
  {
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   double min_day = mrate[0].low;                    // minima do dia até o momento
   
   int i=1,j=36;  // numero de periodos
    do
      {
       if( min_day == Global.memory_F_min[i] ) 
         { 
          Global.count_memory_F_min[i]++; 
          Memory_Analysis_Validation( " count_memory_F_min_"+i+":  "+Global.count_memory_F_min[i]); 
         } 
   
       if( max_day == Global.memory_F_max[i] ) 
         { 
          Global.count_memory_F_max[i]++; 
          Memory_Analysis_Validation( " count_memory_F_max_"+i+":  "+Global.count_memory_F_max[i]); 
         } 
       i++;   
      }
    while(i<j);
    Memory_Analysis_Validation( ""+"\n");
    
  }     

void Memory_Exception_15M() 
  {
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   double min_day = mrate[0].low;                    // minima do dia até o momento  
   
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_M15,0,2,mrate) < 0)      // aloca a maxima do candle diário
     {
      Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
     
   if(   max_day == mrate[0].high
      && mrate[0].open > mrate[1].close )
     {
      Global.count_memory_F_max[35]++; 
      Memory_Analysis_Validation( " --> Exception_15M() <--"+" count_memory_F_max_"+35+":  "+Global.count_memory_F_max[35]);
      Memory_Analysis_Validation( ""+"\n");   
     }
   if(   min_day == mrate[0].low 
      && mrate[0].open < mrate[1].close  ) 
     { 
      Global.count_memory_F_min[35]++; 
      Memory_Analysis_Validation( " --> Exception_15M() <--"+" count_memory_F_min_"+35+":  "+Global.count_memory_F_min[35]);
      Memory_Analysis_Validation( ""+"\n"); 
     } 
   }    

//+------------------------------------------------------------------+
//| MIN MAX ALLOCATION_30M                                           |
//+------------------------------------------------------------------+    
void Memory_Day_Min_Max_30M() 
  {
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   double min_day = mrate[0].low;                    // minima do dia até o momento
   
   int i=1,j=18;  // numero de periodos
    do
      {
       if( min_day == Global.memory_F_min_30M[i] ) 
         { 
          Global.count_memory_F_min_30M[i]++; 
          Memory_Analysis_Validation_30M( " count_memory_F_min_30M_"+i+":  "+Global.count_memory_F_min_30M[i]); 
         } 
   
       if( max_day == Global.memory_F_max_30M[i] ) 
         { 
          Global.count_memory_F_max_30M[i]++; 
          Memory_Analysis_Validation_30M( " count_memory_F_max_30M_"+i+":  "+Global.count_memory_F_max_30M[i]); 
         } 
       i++;   
      }
    while(i<j);
    Memory_Analysis_Validation_30M( ""+"\n");
    
  }    
  
void Memory_Exception_30M() 
  {
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   double min_day = mrate[0].low;                    // minima do dia até o momento  
   
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_M30,0,2,mrate) < 0)      // aloca a maxima do candle diário
     {
      Alert(" Error copying PERIOD_M30 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
     
   if(   max_day == mrate[0].high
      && mrate[0].open > mrate[1].close )
     {
      Global.count_memory_F_max_30M[17]++; 
      Memory_Analysis_Validation_30M( " --> Exception_30M() <--"+" count_memory_F_max_30M_"+17+":  "+Global.count_memory_F_max_30M[17]);
      Memory_Analysis_Validation_30M( ""+"\n");   
     }
   if(   min_day == mrate[0].low 
      && mrate[0].open < mrate[1].close  ) 
     { 
      Global.count_memory_F_min_30M[17]++; 
      Memory_Analysis_Validation_30M( " --> Exception_30M() <--"+" count_memory_F_min_30M_"+17+":  "+Global.count_memory_F_min_30M[17]); 
      Memory_Analysis_Validation_30M( ""+"\n");
     } 
    
//    Memory_Analysis_Validation_30M( " max_day:  "+max_day+"  mrate[1].close :"+ mrate[1].high);  
   }       
  
  
//+------------------------------------------------------------------+
//| PERIOD MIN MAX ALLOCATION                                        |
//+------------------------------------------------------------------+  
void Memory_Period_Min_Max_Alloc() 
  {     
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_M15,0,2,mrate) < 0)      
    {
     Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
     ResetLastError();
    }  
   if(   
         str1.hour == Global.memory_i 
      && (   str1.min == Global.memory_j 
          || str1.min == (Global.memory_j + 14) )    //  caso não tenha havido dados no horario previsto 
                                )
     {
      Global.memory_F_min[Global.memory_k] = mrate[1].low;  
      Global.memory_F_max[Global.memory_k] = mrate[1].high;
      
//      Memory_Analysis_Validation( " mrate[1].low :"+mrate[1].low);
//      Memory_Analysis_Validation( " Global.memory_F_min[Global.memory_k] :"+Global.memory_F_min[Global.memory_k]);
      
      Global.memory_k++;
      Global.memory_j = Global.memory_j + 15;
      if(Global.memory_j == 60)
        {
         Global.memory_j = 0;
         Global.memory_i++;
        }
     }  
          
  }  
  
//+------------------------------------------------------------------+
//| PERIOD MIN MAX ALLOCATION_30M                                    |
//+------------------------------------------------------------------+  
void Memory_Period_Min_Max_Alloc_30M() 
  {     
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_M30,0,2,mrate) < 0)      
    {
     Alert(" Error copying PERIOD_M30 rates - error: "+GetLastError()); 
     ResetLastError();
    }  
   if(   
         str1.hour == Global.memory_i_30M 
      && (   str1.min == Global.memory_j_30M 
          || str1.min == (Global.memory_j_30M + 29) )    //  caso não tenha havido dados no horario previsto
                                               )
     {
      Global.memory_F_min_30M[Global.memory_k_30M] = mrate[1].low;  
      Global.memory_F_max_30M[Global.memory_k_30M] = mrate[1].high;
      Global.memory_k_30M++;
      Global.memory_j_30M = Global.memory_j_30M + 30;
//      Memory_Analysis_Validation_30M( "  mrate[1].close :"+ mrate[1].high);  
      if(Global.memory_j_30M == 60)
        {
         Global.memory_j_30M = 0;
         Global.memory_i_30M++;
        }
     }  
          
  }    

//+------------------------------------------------------------------+
//| FREQUENCY FINAL RESULTS                                          |
//+------------------------------------------------------------------+    
void Memory_Frequency_Results() 
  {
   Memory_Analysis_Validation( " ########################### MEMORY FREQUENCY RESULTS ########################### ");
   
   int i=1,j=36;  // numero de periodos
    do
      { 
       Memory_Analysis_Validation( " count_memory_F_min_"+i+":  "+Global.count_memory_F_min[i]);
       Memory_Analysis_Min(Global.count_memory_F_min[i]); 
       i++;
      } 
    while(i<j); 
    
    int k=1,l=36;  // numero de periodos
    do
      { 
       Memory_Analysis_Validation( " count_memory_F_max_"+k+":  "+Global.count_memory_F_max[k]); 
       Memory_Analysis_Max(Global.count_memory_F_max[k]); 
       k++;
      } 
    while(k<l); 
                                                                                                                                    

  }   
  
//+------------------------------------------------------------------+
//| FREQUENCY FINAL RESULTS_30M                                      |
//+------------------------------------------------------------------+    
void Memory_Frequency_Results_30M() 
  {
   Memory_Analysis_Validation_30M( " ########################### MEMORY FREQUENCY RESULTS 30M ########################### ");
   
   int i=1,j=18;  // numero de periodos
    do
      { 
       Memory_Analysis_Validation_30M( " count_memory_F_min_30M_"+i+":  "+Global.count_memory_F_min_30M[i]);
       Memory_Analysis_Min_30M(Global.count_memory_F_min_30M[i]); 
       i++;
      } 
    while(i<j); 
    
    int k=1,l=18;  // numero de periodos
    do
      { 
       Memory_Analysis_Validation_30M( " count_memory_F_max_30M_"+k+":  "+Global.count_memory_F_max_30M[k]); 
       Memory_Analysis_Max_30M(Global.count_memory_F_max_30M[k]); 
       k++;
      } 
    while(k<l); 
                                                                                                                                    

  }     
  
                              