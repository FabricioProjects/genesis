//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2014, Fabrício Amaral"
#property link      "http://executive.com.br/"

//+------------------------------------------------------------------+
//| Indicators                                                       |
//+------------------------------------------------------------------+

struct Indicators_Candle_Sticks      
  {
   // STOCHASTIC
   int          StochHandle_CS;          // Stochastic handle default
   double       StochMainBuffer_CS[];    // linha solida
   double       StochSignalBuffer_CS[];  // linha pontilhada 
   // MA
   int          EMA8_Handle;          // MA handle default
   double       EMA8_Buffer[];        // linha solida
   // MA
   int          MA50_Handle;          // MA handle default
   double       MA50_Buffer[];        // linha solida
   int          MA200_Handle;         // MA handle default
   double       MA200_Buffer[];       // linha solida
   
   // VOLUME
   int          Volume_Handle_CS;        // Volume handle default
   double       Volume_Buffer_CS[];      // buffer do volume
/*   
// CUSTOM INDICATORS
   // BBANDWIDTH
   int          BBandwidth_Handle_CS;
   double       BBandwidth_Buffer_CS[];
*/   
  } Ind_CS;
  
//+------------------------------------------------------------------+
//| INDICADORES EXCLUSIVOS PARA CANDLE STICKS                        |
//+------------------------------------------------------------------+   
void Indicators_CS()
  {
   // ##### PERIOD_M15
   // Get handle of the Stochastic indicator
   Ind_CS.StochHandle_CS = iStochastic(Ativo,PERIOD_M15,14,3,3,MODE_SMA,STO_LOWHIGH); 
   // Get handle of the T-line 
   Ind_CS.EMA8_Handle = iMA(Ativo,PERIOD_M15,8,0,MODE_EMA,PRICE_CLOSE);
    // Get handle of the Moving Average 50 (middle-term) indicator 
   Ind_CS.MA50_Handle = iMA(Ativo,PERIOD_M15,50,0,MODE_SMA,PRICE_CLOSE);
   // Get handle of the Moving Average 200 (long-term) indicator 
   Ind_CS.MA200_Handle = iMA(Ativo,PERIOD_M15,200,0,MODE_SMA,PRICE_CLOSE);
   
   // Get handle of the Volume indicator 
   Ind_CS.Volume_Handle_CS = iVolumes(Ativo,PERIOD_M15,VOLUME_TICK);
/*   
   // Get handle of the BBandwidth custom indicator
   Ind.BBandwidth_Handle_CS = iCustom(Ativo,PERIOD_M15,"dod_BBandwidth",20,0,2,PRICE_CLOSE); 
*/   
   // Check for Invalid Handle
   if(// ##### PERIOD_M15
           Ind_CS.StochHandle_CS < 0
        || Ind_CS.EMA8_Handle < 0
        || Ind_CS.MA50_Handle < 0 
        || Ind_CS.MA200_Handle < 0 
        || Ind_CS.Volume_Handle_CS < 0
//      || Ind_CS.BBandwidth_Handle_CS < 0 
                                        )
     {
      Debug_Alert(" Error in creation of indicators M15 - error: "+GetLastError()); 
     } 
  
   // Atribuição de arrays para buffers do indicador
   // ##### PERIOD_M15
   SetIndexBuffer(0,Ind_CS.StochMainBuffer_CS,INDICATOR_DATA);
   SetIndexBuffer(1,Ind_CS.StochSignalBuffer_CS,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind_CS.EMA8_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind_CS.MA50_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind_CS.MA200_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind_CS.Volume_Buffer_CS,INDICATOR_DATA);
/*   
   SetIndexBuffer(0,Ind.BBandwidth_Buffer_CS,INDICATOR_DATA);
*/   

   // Let's make sure our arrays values for the Rates and Indicators is stored serially 
   // ##### PERIOD_M15
   ArraySetAsSeries(mrate,true);
   
   ArraySetAsSeries(Ind_CS.StochMainBuffer_CS,true);
   ArraySetAsSeries(Ind_CS.StochSignalBuffer_CS,true);
   
   ArraySetAsSeries(Ind_CS.EMA8_Buffer,true);
   ArraySetAsSeries(Ind_CS.MA50_Buffer,true);
   ArraySetAsSeries(Ind_CS.MA200_Buffer,true);
   
   ArraySetAsSeries(Ind_CS.Volume_Buffer_CS,true);
/*   
   ArraySetAsSeries(Ind_CS.BBandwidth_Buffer_CS,true);
*/   
  }
  
void Indicators_Release_CS()
  {  
   // ##### PERIOD_M15
   IndicatorRelease(Ind_CS.StochHandle_CS);
   IndicatorRelease(Ind_CS.EMA8_Handle);
   IndicatorRelease(Ind_CS.MA50_Handle);
   IndicatorRelease(Ind_CS.MA200_Handle);
   
   IndicatorRelease(Ind_CS.Volume_Handle_CS);
/*   
   IndicatorRelease(Ind_CS.BBandwidth_Handle_CS);
*/   
  }    
  
//+------------------------------------------------------------------+
//| Buffers Call                                                     |
//+------------------------------------------------------------------+  
// ##### PERIOD_M15
void Buffers_CS()
  {
   // Stochastic Buffers
   if(   CopyBuffer(Ind_CS.StochHandle_CS,0,0,4,Ind_CS.StochMainBuffer_CS) < 0 
      || CopyBuffer(Ind_CS.StochHandle_CS,1,0,4,Ind_CS.StochSignalBuffer_CS) < 0 )
     {
      Debug_Alert(" Error copying Stochastic indicators Buffers - error: "+GetLastError() ); 
      ResetLastError();
      return;
     } 
    // T-line 
    if( CopyBuffer(Ind_CS.EMA8_Handle,0,0,4,Ind_CS.EMA8_Buffer) < 0 )
     {
      Debug_Alert(" Error copying MA's indicators Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }    
    // MA's Buffers 
    if(   CopyBuffer(Ind_CS.MA50_Handle,0,0,4,Ind_CS.MA50_Buffer) < 0
       || CopyBuffer(Ind_CS.MA200_Handle,0,0,4,Ind_CS.MA200_Buffer) <0 )
     {
      Debug_Alert(" Error copying MA's indicators Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }    
/*      
   // BBandwidth Buffers
   if( CopyBuffer(Ind_CS.BBandwidth_Handle_CS,0,0,6,Ind.BBandwidth_Buffer_CS) < 0 )
     {
      Debug_Alert(" Error copying BBandwidth indicator Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     } 
*/      
   // Volume Buffers
   if( CopyBuffer(Ind_CS.Volume_Handle_CS,0,0,4,Ind_CS.Volume_Buffer_CS) < 0 )
     {
      Debug_Alert(" Error copying Volume indicator Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }  
  
  }  // fim da Buffers_CS 
   
//+------------------------------------------------------------------+  