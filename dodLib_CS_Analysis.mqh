//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//############################################################################################################# 
//########################################## TOP PATTERNS ##################################################### 
//############################################################################################################# 

//+------------------------------------------------------------------+
//| LONG ENTER                                                       |
//+------------------------------------------------------------------+   
bool Long_Enter_CS()
  {
   double price = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
   ArraySetAsSeries(mrate,true);  
   if(CopyRates(Ativo,PERIOD_M15,0,3,mrate) < 0)      // aloca a maxima do candle diário
        {
         Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
         ResetLastError();
        }  
   Buffers_CS();
   if(   
//         Ind.StochMainBuffer_CS[1] > Ind.StochSignalBuffer_CS[1]
//          && Ind.StochMainBuffer_CS[2] > Ind.StochSignalBuffer_CS[2] 
//      && Ind.StochSignalBuffer_CS[1] > Ind.StochSignalBuffer_CS[2] 
//         price > Ind.EMA8_Buffer[1] 
       (   mrate[1].low < Ind_CS.MA50_Buffer[1] + np*pip
        && mrate[1].low > Ind_CS.MA50_Buffer[1] - np*pip   )
       || 
       (   mrate[1].low < Ind_CS.MA200_Buffer[1] + np*pip
        && mrate[1].low > Ind_CS.MA200_Buffer[1] - np*pip   )
                                                                    )
      {
       return true;
      }       
    else return false; 
   }          
   
//+------------------------------------------------------------------+
//| SHORT ENTER                                                      |
//+------------------------------------------------------------------+   
bool Short_Enter_CS()
  {
   double price = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
   ArraySetAsSeries(mrate,true);  
   if(CopyRates(Ativo,PERIOD_M15,0,3,mrate) < 0)      // aloca a maxima do candle diário
        {
         Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
         ResetLastError();
        }  
   Buffers_CS();
   if(   
//         Ind_CS.StochMainBuffer_CS[1] < Ind_CS.StochSignalBuffer_CS[1]
//          && Ind_CS.StochMainBuffer_CS[2] > Ind_CS.StochSignalBuffer_CS[2] 
//      && Ind_CS.StochSignalBuffer_CS[1] < Ind_CS.StochSignalBuffer_CS[2] 
//         price < Ind_CS.EMA8_Buffer[1] 
       (   mrate[1].high < Ind_CS.MA50_Buffer[1] + np*pip
        && mrate[1].high > Ind_CS.MA50_Buffer[1] - np*pip   )
       || 
       (   mrate[1].high < Ind_CS.MA200_Buffer[1] + np*pip
        && mrate[1].high > Ind_CS.MA200_Buffer[1] - np*pip   )   
                                                                    )
      {
       return true;
      }       
    else return false; 
   }   
   
//+------------------------------------------------------------------+
//| PATTERN_ANALYSIS                                                 |
//+------------------------------------------------------------------+
void Pattern_Analysis(string texto)
  { 
   Global.filehandle_PA = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Pattern_Analysis.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_PA!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_PA,0,SEEK_END);
      FileWrite(Global.filehandle_PA,TimeCurrent()+texto);
      FileFlush(Global.filehandle_PA);
      FileClose(Global.filehandle_PA);
     }
   else Alert("Operation FileOpen PA failed, error: ",GetLastError() );
        ResetLastError();
   
  }
     
//+------------------------------------------------------------------+
//| PATTERN COUNT ENTER                                              |
//+------------------------------------------------------------------+    
void Pattern_Count_Enter() 
  {
   // bottom patterns
   if( Hammer() ) 
     {
      Global.count_hammer_enter++ ; 
      Signals.hammer = true;
      Pattern_Analysis(" HAMMER_enter: "+Global.count_hammer_enter);  
      return;
     } 
/*       
   if( Inverted_Hammer() ) 
     {
      Global.count_Inverted_Hammer_enter++ ; 
      Signals.Inverted_Hammer = true;
      Pattern_Analysis(" INVERTED_HAMMER_enter: "+Global.count_Inverted_Hammer_enter);  
      return;
     }  
*/        
   if( Bullish_Engulfing() ) 
     {
      Global.count_Bullish_Engulfing_enter++ ; 
      Signals.Bullish_Engulfing = true;
      Pattern_Analysis(" BULLISH_ENGULFING_enter: "+Global.count_Bullish_Engulfing_enter); 
      return; 
     }   
   if( Piercing_Pattern() ) 
     {
      Global.count_Piercing_Pattern_enter++ ; 
      Signals.Piercing_Pattern = true;
      Pattern_Analysis(" PIERCING_PATTERN_enter: "+Global.count_Piercing_Pattern_enter);  
      return;
     }   
   if( Harami_Bullish() ) 
     {
      Global.count_Harami_Bullish_enter++ ; 
      Signals.Harami_Bullish = true;
      Pattern_Analysis(" HARAMI_BULLISH_enter: "+Global.count_Harami_Bullish_enter);  
      return;
     }   
   if( Morning_Star() ) 
     {
      Global.count_Morning_Star_enter++ ; 
      Signals.Morning_Star = true;
      Pattern_Analysis(" MORNING_STAR_enter: "+Global.count_Morning_Star_enter);  
      return;
     }  
     
   // top patterns   
   if( Shooting_Star() ) 
     {
      Global.count_Shooting_Star_enter++ ; 
      Signals.Shooting_Star = true;
      Pattern_Analysis(" SHOOTING_STAR_enter: "+Global.count_Shooting_Star_enter);  
      return;
     } 
/*       
   if( Hanging_Man() ) 
     {
      Global.count_Hanging_Man_enter++ ; 
      Signals.Hanging_Man = true;
      Pattern_Analysis(" HANGING_MAN_enter: "+Global.count_Hanging_Man_enter);  
      return;
     }  
*/         
   if( Bearish_Engulfing() ) 
     {
      Global.count_Bearish_Engulfing_enter++ ; 
      Signals.Bearish_Engulfing = true;
      Pattern_Analysis(" BEARISH_ENGULFING_enter: "+Global.count_Bearish_Engulfing_enter);  
      return;
     }   
   if( Dark_Cloud_Cover() ) 
     {
      Global.count_Dark_Cloud_Cover_enter++ ; 
      Signals.Dark_Cloud_Cover = true;
      Pattern_Analysis(" DARK_CLOUD_enter: "+Global.count_Dark_Cloud_Cover_enter); 
      return; 
     }   
   if( Harami_Bearish() ) 
     {
      Global.count_Harami_Bearish_enter++ ; 
      Signals.Harami_Bearish = true;
      Pattern_Analysis(" HARAMI_BEARISH_enter: "+Global.count_Harami_Bearish_enter); 
      return; 
     }   
   if( Evening_Star() ) 
     {
      Global.count_Evening_Star_enter++ ; 
      Signals.Evening_Star = true;
      Pattern_Analysis(" EVENING_STAR_enter: "+Global.count_Evening_Star_enter); 
      return; 
     }           
     
  }          
  
//+------------------------------------------------------------------+
//| PATTERN STOP LOSS                                                |
//+------------------------------------------------------------------+    
void Pattern_SL() 
  {
   // bottom patterns
   if( Signals.hammer == true ) 
     {
      Global.count_hammer_SL++ ; 
      Pattern_Analysis(" HAMMER_SL: "+Global.count_hammer_SL);  
     }
   if( Signals.Inverted_Hammer == true ) 
     {
      Global.count_Inverted_Hammer_SL++ ; 
      Pattern_Analysis(" INVERTED_HAMMER_SL: "+Global.count_Inverted_Hammer_SL);  
     }  
   if( Signals.Bullish_Engulfing == true ) 
     {
      Global.count_Bullish_Engulfing_SL++ ; 
      Pattern_Analysis(" BULLISH_ENGULFING_SL: "+Global.count_Bullish_Engulfing_SL);  
     }
   if( Signals.Piercing_Pattern == true ) 
     {
      Global.count_Piercing_Pattern_SL++ ; 
      Pattern_Analysis(" PIERCING_PATTERN_SL: "+Global.count_Piercing_Pattern_SL);  
     }    
   if( Signals.Harami_Bullish == true ) 
     {
      Global.count_Harami_Bullish_SL++ ; 
      Pattern_Analysis(" HARAMI_BULLISH_SL: "+Global.count_Harami_Bullish_SL);  
     }    
   if( Signals.Morning_Star == true ) 
     {
      Global.count_Morning_Star_SL++ ; 
      Pattern_Analysis(" MORNING_STAR_SL: "+Global.count_Morning_Star_SL);  
     }  
   
   // top patterns    
   if( Signals.Shooting_Star == true ) 
     {
      Global.count_Shooting_Star_SL++ ; 
      Pattern_Analysis(" SHOOTING_STAR_SL: "+Global.count_Shooting_Star_SL);  
     }
   if( Signals.Hanging_Man == true ) 
     {
      Global.count_Hanging_Man_SL++ ; 
      Pattern_Analysis(" HANGING_MAN_SL: "+Global.count_Hanging_Man_SL);  
     }  
   if( Signals.Bearish_Engulfing == true ) 
     {
      Global.count_Bearish_Engulfing_SL++ ; 
      Pattern_Analysis(" BEARISH_ENGULFING_SL: "+Global.count_Bearish_Engulfing_SL);  
     }
   if( Signals.Dark_Cloud_Cover == true ) 
     {
      Global.count_Dark_Cloud_Cover_SL++ ; 
      Pattern_Analysis(" DARK_CLOUD_SL: "+Global.count_Dark_Cloud_Cover_SL);  
     }    
   if( Signals.Harami_Bearish == true ) 
     {
      Global.count_Harami_Bearish_SL++ ; 
      Pattern_Analysis(" HARAMI_BEARISH_SL: "+Global.count_Harami_Bearish_SL);  
     }    
   if( Signals.Evening_Star == true ) 
     {
      Global.count_Evening_Star_SL++ ; 
      Pattern_Analysis(" EVENING_STAR_SL: "+Global.count_Evening_Star_SL);  
     }      
     
  }        
  
//+------------------------------------------------------------------+
//| PATTERN TIME EXIT                                                |
//+------------------------------------------------------------------+    
void Pattern_Time_Exit() 
  {
   // bottom patterns
   if( Signals.hammer == true ) 
     {
      Global.count_hammer_time_exit++ ; 
      Pattern_Analysis(" HAMMER_TIME_EXIT: "+Global.count_hammer_time_exit);  
     }
   if( Signals.Inverted_Hammer == true ) 
     {
      Global.count_Inverted_Hammer_time_exit++ ; 
      Pattern_Analysis(" INVERTED_HAMMER_TIME_EXIT: "+Global.count_Inverted_Hammer_time_exit);  
     }  
   if( Signals.Bullish_Engulfing == true ) 
     {
      Global.count_Bullish_Engulfing_time_exit++ ; 
      Pattern_Analysis(" BULLISH_ENGULFING_TIME_EXIT: "+Global.count_Bullish_Engulfing_time_exit);  
     }
   if( Signals.Piercing_Pattern == true ) 
     {
      Global.count_Piercing_Pattern_time_exit++ ; 
      Pattern_Analysis(" PIERCING_PATTERN_TIME_EXIT: "+Global.count_Piercing_Pattern_time_exit);  
     }  
   if( Signals.Harami_Bullish == true ) 
     {
      Global.count_Harami_Bullish_time_exit++ ; 
      Pattern_Analysis(" HARAMI_BULLISH_TIME_EXIT: "+Global.count_Harami_Bullish_time_exit);  
     }  
   if( Signals.Morning_Star == true ) 
     {
      Global.count_Morning_Star_time_exit++ ; 
      Pattern_Analysis(" MORNING_STAR_TIME_EXIT: "+Global.count_Morning_Star_time_exit);  
     }      
     
   // top patterns
   if( Signals.Shooting_Star == true ) 
     {
      Global.count_Shooting_Star_time_exit++ ; 
      Pattern_Analysis(" SHOOTING_STAR_TIME_EXIT: "+Global.count_Shooting_Star_time_exit);  
     }
   if( Signals.Hanging_Man == true ) 
     {
      Global.count_Hanging_Man_time_exit++ ; 
      Pattern_Analysis(" HANGING_MAN_TIME_EXIT: "+Global.count_Hanging_Man_time_exit);  
     }  
   if( Signals.Bearish_Engulfing == true ) 
     {
      Global.count_Bearish_Engulfing_time_exit++ ; 
      Pattern_Analysis(" BEARISH_ENGULFING_TIME_EXIT: "+Global.count_Bearish_Engulfing_time_exit);  
     }
   if( Signals.Dark_Cloud_Cover == true ) 
     {
      Global.count_Dark_Cloud_Cover_time_exit++ ; 
      Pattern_Analysis(" DARK_CLOUD_TIME_EXIT: "+Global.count_Dark_Cloud_Cover_time_exit);  
     }  
   if( Signals.Harami_Bearish == true ) 
     {
      Global.count_Harami_Bearish_time_exit++ ; 
      Pattern_Analysis(" HARAMI_BEARISH_TIME_EXIT: "+Global.count_Harami_Bearish_time_exit);  
     }  
   if( Signals.Evening_Star == true ) 
     {
      Global.count_Evening_Star_time_exit++ ; 
      Pattern_Analysis(" EVENING_STAR_TIME_EXIT: "+Global.count_Evening_Star_time_exit);  
     }        
  }          
  
  
//+------------------------------------------------------------------+
//| PATTERN FINAL RESULTS                                            |
//+------------------------------------------------------------------+    
void Pattern_Final_Results() 
  {
   Pattern_Analysis( " ########################### PATTERN FINAL RESULTS ########################### ");
   
   Pattern_Analysis( " HAMMER_enter: "+"           "+Global.count_hammer_enter+
                    +"    HAMMER_TIME_EXIT: "+"           "+Global.count_hammer_time_exit+
                    +"   HAMMER_SL: "+"            "+Global.count_hammer_SL                  );               
                    
   Pattern_Analysis( " SHOOTING_STAR_enter: "+"    "+Global.count_Shooting_Star_enter+
                    +"    SHOOTING_STAR_TIME_EXIT: "+"    "+Global.count_Shooting_Star_time_exit+
                    +"   SHOOTING_STAR_TIME_SL: "+Global.count_Shooting_Star_SL                  );                  
                     
   Pattern_Analysis( " INVERTED_HAMMER_enter: "+"  "+Global.count_Inverted_Hammer_enter+
                    +"   INVERTED_HAMMER_TIME_EXIT: "+"    "+Global.count_Inverted_Hammer_time_exit+
                    +"    INVERTED_HAMMER_SL: "+"   "+Global.count_Inverted_Hammer_SL                  );  
                  
   Pattern_Analysis( " HANGING_MAN_enter: "+"      "+Global.count_Hanging_Man_enter+
                    +"   HANGING_MAN_TIME_EXIT: "+"        "+Global.count_Hanging_Man_time_exit+
                    +"    HANGING_MAN_SL: "+"       "+Global.count_Hanging_Man_SL                  );  
                                                       
   Pattern_Analysis( " BULLISH_ENGULFING_enter: "+Global.count_Bullish_Engulfing_enter+
                    +"    BULLISH_ENGULFING_TIME_EXIT: "+Global.count_Bullish_Engulfing_time_exit+
                    +"   BULLISH_ENGULFING_SL: "+" "+Global.count_Bullish_Engulfing_SL                  ); 
                    
   Pattern_Analysis( " BEARISH_ENGULFING_enter: "+Global.count_Bearish_Engulfing_enter+
                    +"    BEARISH_ENGULFING_TIME_EXIT: "+Global.count_Bearish_Engulfing_time_exit+
                    +"   BEARISH_ENGULFING_SL: "+" "+Global.count_Bearish_Engulfing_SL                  );                  
                     
   Pattern_Analysis( " PIERCING_PATTERN_enter: "+" "+Global.count_Piercing_Pattern_enter+
                    +"    PIERCING_PATTERN_TIME_EXIT: "+" "+Global.count_Piercing_Pattern_time_exit+
                    +"   PIERCING_PATTERN_SL: "+"  "+Global.count_Piercing_Pattern_SL                  );
                    
   Pattern_Analysis( " DARK_CLOUD_enter: "+"       "+Global.count_Dark_Cloud_Cover_enter+
                    +"    DARK_CLOUD_TIME_EXIT: "+"       "+Global.count_Dark_Cloud_Cover_time_exit+
                    +"   DARK_CLOUD_SL: "+"        "+Global.count_Dark_Cloud_Cover_SL                  );                    
             
   Pattern_Analysis( " HARAMI_BULLISH_enter: "+"   "+Global.count_Harami_Bullish_enter+
                    +"   HARAMI_BULLISH_TIME_EXIT: "+"   "+Global.count_Harami_Bullish_time_exit+
                    +"   HARAMI_BULLISH_SL: "+"    "+Global.count_Harami_Bullish_SL                  );
                    
   Pattern_Analysis( " HARAMI_BEARISH_enter: "+"   "+Global.count_Harami_Bearish_enter+
                    +"    HARAMI_BEARISH_TIME_EXIT: "+"   "+Global.count_Harami_Bearish_time_exit+
                    +"   HARAMI_BEARISH_SL: "+"    "+Global.count_Harami_Bearish_SL                  );                    
                    
   Pattern_Analysis( " MORNING_STAR_enter: "+"     "+Global.count_Morning_Star_enter+
                    +"    MORNING_STAR_TIME_EXIT: "+"     "+Global.count_Morning_Star_time_exit+
                    +"    MORNING_STAR_SL: "+"      "+Global.count_Morning_Star_SL                  );  
                    
   Pattern_Analysis( " EVENING_STAR_enter: "+"     "+Global.count_Evening_Star_enter+
                    +"    EVENING_STAR_TIME_EXIT: "+"     "+Global.count_Evening_Star_time_exit+
                    +"    EVENING_STAR_SL: "+"      "+Global.count_Evening_Star_SL                  );   
                    
   Pattern_Analysis( " ########################### GLOBAL FINAL RESULTS ########################### ");
   
   Pattern_Analysis( " PATTERN_EXIT_LONG: "+Global.count_Pattern_Exit_Long+
                    +"           PATTERN_EXIT_SHORT: "+"   "+Global.count_Pattern_Exit_Short); 
                    
   int total_enter_long = (  Global.count_hammer_enter + Global.count_Inverted_Hammer_enter + Global.count_Bullish_Engulfing_enter 
                           + Global.count_Piercing_Pattern_enter + Global.count_Harami_Bullish_enter
                           + Global.count_Morning_Star_enter ); 
                           
   int total_time_exit_long = (  Global.count_hammer_time_exit + Global.count_Inverted_Hammer_time_exit + Global.count_Bullish_Engulfing_time_exit 
                               + Global.count_Piercing_Pattern_time_exit + Global.count_Harami_Bullish_time_exit
                               + Global.count_Morning_Star_time_exit );   
                               
   int total_sl_exit_long = (  Global.count_hammer_SL + Global.count_Inverted_Hammer_SL + Global.count_Bullish_Engulfing_SL 
                             + Global.count_Piercing_Pattern_SL + Global.count_Harami_Bullish_SL
                             + Global.count_Morning_Star_SL );                             
                                                    
   int total_enter_short = (  Global.count_Shooting_Star_enter + Global.count_Hanging_Man_enter + Global.count_Bearish_Engulfing_enter 
                            + Global.count_Dark_Cloud_Cover_enter + Global.count_Harami_Bearish_enter
                            + Global.count_Evening_Star_enter );
                            
   int total_time_exit_short = (  Global.count_Shooting_Star_time_exit + Global.count_Hanging_Man_time_exit + Global.count_Bearish_Engulfing_time_exit 
                                + Global.count_Dark_Cloud_Cover_time_exit + Global.count_Harami_Bearish_time_exit
                                + Global.count_Evening_Star_time_exit );  
                                
   int total_sl_exit_short = (  Global.count_Shooting_Star_SL + Global.count_Hanging_Man_SL + Global.count_Bearish_Engulfing_SL 
                              + Global.count_Dark_Cloud_Cover_SL + Global.count_Harami_Bearish_SL
                              + Global.count_Evening_Star_SL );                                                                                           
                    
   Pattern_Analysis( " TOTAL_ENTER_LONG: "+" "+total_enter_long+
                    +"         TOTAL_TIME_EXIT_LONG: "+" "+total_time_exit_long
                    +"         TOTAL_SL_EXIT_LONG: "+" "+total_sl_exit_long);
                    
   Pattern_Analysis( " TOTAL_ENTER_SHORT: "+total_enter_short+
                    +"         TOTAL_TIME_EXIT_SHORT: "+total_time_exit_short
                    +"         TOTAL_SL_EXIT_SHORT: "+total_sl_exit_short);                                                                                                                                       
  
     
  }   
  
//+------------------------------------------------------------------+
//| PATTERN EXIT LONG                                                |
//+------------------------------------------------------------------+    
void Pattern_Exit_Long() 
  {
   Global.count_Pattern_Exit_Long++ ; 
   Pattern_Analysis(" PATTERN_EXIT_LONG: "+Global.count_Pattern_Exit_Long); 
      
  }                       
  
//+------------------------------------------------------------------+
//| PATTERN EXIT SHORT                                                |
//+------------------------------------------------------------------+    
void Pattern_Exit_Short() 
  {
   Global.count_Pattern_Exit_Short++ ; 
   Pattern_Analysis(" PATTERN_EXIT_SHORT: "+Global.count_Pattern_Exit_Short); 
   
  }                                                                                         