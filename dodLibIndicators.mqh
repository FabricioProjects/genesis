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

struct Indicators      
  {
   // BOLLINGER BANDS 1 sigma
   int     BBandsHandle;              // Bolinger Bands handle default         
   double  BBUp[],BBLow[],BBMid[];    // Buffers - dynamic arrays for numerical values of Bollinger Bands 
   int     BBands_P5_Handle;                     
   double  BB_P5_Up[],BB_P5_Low[],BB_P5_Mid[];     
   // BOLLINGER BANDS 2 sigma
   int     BBandsHandle2;                   
   double  BBUp2[],BBLow2[],BBMid2[]; 
   int     BBands_P5_Handle2;                  
   double  BB_P5_Up2[],BB_P5_Low2[],BB_P5_Mid2[];  
   // BOLLINGER BANDS n sigma
   int     BBandsHandle_n;                   
   double  BBUp_n[],BBLow_n[],BBMid_n[];  
   // STOCHASTIC
   int          StochHandle;          // Stochastic handle default
   double       StochMainBuffer[];    // linha solida
   double       StochSignalBuffer[];  // linha pontilhada 
   // MA
   int          MA20_Handle;          // MA handle default
   double       MA20_Buffer[];        // linha solida
   int          MA50_Handle;          // MA handle default
   double       MA50_Buffer[];        // linha solida
   int          MA200_Handle;         // MA handle default
   double       MA200_Buffer[];       // linha solida
   int          MA20_P5_Handle;          // MA handle default _P5
   double       MA20_P5_Buffer[];        // linha solida _P5
   int          MA50_P5_Handle;          // MA handle default _P5
   double       MA50_P5_Buffer[];        // linha solida _P5
   int          MA200_P5_Handle;         // MA handle default _P5
   double       MA200_P5_Buffer[];       // linha solida _P5
   // VOLUME
   int          Volume_Handle;        // Volume handle default
   double       Volume_Buffer[];      // buffer do volume
   
// CUSTOM INDICATORS
   // BBANDWIDTH
   int          BBandwidth_Handle;
   double       BBandwidth_Buffer[];
   int          BBandwidth_Daily_Handle;
   double       BBandwidth_Daily_Buffer[];
   // MADISTANCE
   int          MAdistance_Handle;
   double       MA50_20_Buffer[];
   double       MA200_50_Buffer[];
   double       MAs_Distance_Buffer[];
   
  } Ind;

void Indicators_PERIOD_M15()
  {
   // ##### PERIOD_M15
   // Get handle of the Bollinger Bands indicator 1 sigma
   Ind.BBandsHandle = iBands(Ativo,PERIOD_M15,20,0,1,PRICE_CLOSE); 
   // Get handle of the Bollinger Bands indicator 2 sigma
   Ind.BBandsHandle2 = iBands(Ativo,PERIOD_M15,20,0,2,PRICE_CLOSE); 
   // Get handle of the Bollinger Bands indicator n sigma
   Ind.BBandsHandle_n = iBands(Ativo,PERIOD_M15,20,0,n,PRICE_CLOSE); 
   // Get handle of the Stochastic indicator
   Ind.StochHandle = iStochastic(Ativo,PERIOD_M15,StochK,StochD,StochSlow,MODE_SMA,STO_LOWHIGH); 
   // Get handle of the Moving Average 20 (short-term) indicator 
   Ind.MA20_Handle = iMA(Ativo,PERIOD_M15,20,0,MODE_SMA,PRICE_CLOSE);
   // Get handle of the Moving Average 50 (middle-term) indicator 
   Ind.MA50_Handle = iMA(Ativo,PERIOD_M15,50,0,MODE_SMA,PRICE_CLOSE);
   // Get handle of the Moving Average 200 (long-term) indicator 
   Ind.MA200_Handle = iMA(Ativo,PERIOD_M15,200,0,MODE_SMA,PRICE_CLOSE);
   // Get handle of the Volume indicator 
   Ind.Volume_Handle = iVolumes(Ativo,PERIOD_M15,VOLUME_TICK);
   // Get handle of the BBandwidth custom indicator
   Ind.BBandwidth_Handle = iCustom(Ativo,PERIOD_M15,"dod_BBandwidth",20,0,2,PRICE_CLOSE); 
   // Get handle of the MAdistance custom indicator
   Ind.MAdistance_Handle = iCustom(Ativo,PERIOD_M15,"dod_MAdistance",20,50,200,PRICE_CLOSE); 
   
   // Check for Invalid Handle
   if(// ##### PERIOD_M15
         Ind.BBandsHandle < 0 
      || Ind.StochHandle < 0
      || Ind.BBandsHandle2 < 0 
      || Ind.BBandsHandle_n < 0 
      || Ind.MA20_Handle < 0 
      || Ind.MA50_Handle < 0 
      || Ind.MA200_Handle < 0 
      || Ind.Volume_Handle < 0
      || Ind.BBandwidth_Handle < 0
      || Ind.MAdistance_Handle < 0 )
     {
      Debug_Alert(" Error in creation of indicators M15 - error: "+GetLastError()); 
     } 
  
   // Atribuição de arrays para buffers do indicador
   // ##### PERIOD_M15
   SetIndexBuffer(0,Ind.StochMainBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,Ind.StochSignalBuffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.MA20_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.MA50_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.MA200_Buffer,INDICATOR_DATA);
    
   SetIndexBuffer(0,Ind.BBMid,INDICATOR_DATA);
   SetIndexBuffer(1,Ind.BBUp,INDICATOR_DATA);
   SetIndexBuffer(2,Ind.BBLow,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.BBMid2,INDICATOR_DATA);
   SetIndexBuffer(1,Ind.BBUp2,INDICATOR_DATA);
   SetIndexBuffer(2,Ind.BBLow2,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.BBMid_n,INDICATOR_DATA);
   SetIndexBuffer(1,Ind.BBUp_n,INDICATOR_DATA);
   SetIndexBuffer(2,Ind.BBLow_n,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.Volume_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.BBandwidth_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.MA50_20_Buffer,INDICATOR_DATA);
   SetIndexBuffer(1,Ind.MA200_50_Buffer,INDICATOR_DATA);
   SetIndexBuffer(2,Ind.MAs_Distance_Buffer,INDICATOR_DATA);

   // Let's make sure our arrays values for the Rates and Indicators is stored serially 
   // ##### PERIOD_M15
   ArraySetAsSeries(mrate,true);
   
   ArraySetAsSeries(Ind.StochMainBuffer,true);
   ArraySetAsSeries(Ind.StochSignalBuffer,true);
   
   ArraySetAsSeries(Ind.MA20_Buffer,true);
   ArraySetAsSeries(Ind.MA50_Buffer,true);
   ArraySetAsSeries(Ind.MA200_Buffer,true);
   
   ArraySetAsSeries(Ind.BBUp,true);
   ArraySetAsSeries(Ind.BBLow,true);
   ArraySetAsSeries(Ind.BBMid,true);
   
   ArraySetAsSeries(Ind.BBUp2,true);
   ArraySetAsSeries(Ind.BBLow2,true);
   ArraySetAsSeries(Ind.BBMid2,true);
   
   ArraySetAsSeries(Ind.BBUp_n,true);
   ArraySetAsSeries(Ind.BBLow_n,true);
   ArraySetAsSeries(Ind.BBMid_n,true);
   
   ArraySetAsSeries(Ind.Volume_Buffer,true);
   
   ArraySetAsSeries(Ind.BBandwidth_Buffer,true);
   
   ArraySetAsSeries(Ind.MA50_20_Buffer,true);
   ArraySetAsSeries(Ind.MA200_50_Buffer,true);
   ArraySetAsSeries(Ind.MAs_Distance_Buffer,true);
   
  }
  
void Indicators_Release_PERIOD_M15()
  {  
   // ##### PERIOD_M15
   IndicatorRelease(Ind.BBandsHandle);
   IndicatorRelease(Ind.BBandsHandle2);
   IndicatorRelease(Ind.BBandsHandle_n);
   IndicatorRelease(Ind.StochHandle);
   IndicatorRelease(Ind.MA20_Handle);
   IndicatorRelease(Ind.MA50_Handle);
   IndicatorRelease(Ind.MA200_Handle);
   IndicatorRelease(Ind.Volume_Handle);
   IndicatorRelease(Ind.BBandwidth_Handle);
   IndicatorRelease(Ind.MAdistance_Handle);
  }  
  
void Indicators_PERIOD_M5()
  {
   // ##### PERIOD_M5
   // Get handle of the Bollinger Bands indicator 1 sigma
   Ind.BBands_P5_Handle = iBands(Ativo,PERIOD_M5,20,0,1,PRICE_CLOSE); 
   // Get handle of the Bollinger Bands indicator 2 sigma
   Ind.BBands_P5_Handle2 = iBands(Ativo,PERIOD_M5,20,0,2,PRICE_CLOSE); 
    // Get handle of the BBandwidth custom indicator
   Ind.BBandwidth_Daily_Handle = iCustom(Ativo,PERIOD_D1,"dod_BBandwidth",20,0,2,PRICE_CLOSE);
   // Get handle of the Moving Average 20 (short-term) indicator 
   Ind.MA20_P5_Handle = iMA(Ativo,PERIOD_M5,20,0,MODE_SMA,PRICE_CLOSE);
   // Get handle of the Moving Average 50 (middle-term) indicator 
   Ind.MA50_P5_Handle = iMA(Ativo,PERIOD_M5,50,0,MODE_SMA,PRICE_CLOSE);
   // Get handle of the Moving Average 200 (long-term) indicator 
   Ind.MA200_P5_Handle = iMA(Ativo,PERIOD_M5,200,0,MODE_SMA,PRICE_CLOSE);
   
   // Check for Invalid Handle
   if(
      // ##### PERIOD_M5
         Ind.BBands_P5_Handle < 0
      || Ind.BBands_P5_Handle2 < 0
      || Ind.BBandwidth_Daily_Handle < 0
      || Ind.MA20_P5_Handle < 0 
      || Ind.MA50_P5_Handle < 0 
      || Ind.MA200_P5_Handle < 0     )
     {
      Debug_Alert(" Error in creation of indicators M5 - error: "+GetLastError()); 
     } 
     
   // ##### Index PERIOD_M5
   SetIndexBuffer(0,Ind.BB_P5_Mid,INDICATOR_DATA);
   SetIndexBuffer(1,Ind.BB_P5_Up,INDICATOR_DATA);
   SetIndexBuffer(2,Ind.BB_P5_Low,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.BB_P5_Mid2,INDICATOR_DATA);
   SetIndexBuffer(1,Ind.BB_P5_Up2,INDICATOR_DATA);
   SetIndexBuffer(2,Ind.BB_P5_Low2,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.BBandwidth_Daily_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.MA20_P5_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.MA50_P5_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.MA200_P5_Buffer,INDICATOR_DATA);  
   
   // ##### Series PERIOD_M5
   ArraySetAsSeries(mrate,true);
   
   ArraySetAsSeries(Ind.BB_P5_Up,true);
   ArraySetAsSeries(Ind.BB_P5_Low,true);
   ArraySetAsSeries(Ind.BB_P5_Mid,true);
   
   ArraySetAsSeries(Ind.BB_P5_Up2,true);
   ArraySetAsSeries(Ind.BB_P5_Low2,true);
   ArraySetAsSeries(Ind.BB_P5_Mid2,true);
   
   ArraySetAsSeries(Ind.BBandwidth_Daily_Buffer,true);
   
   ArraySetAsSeries(Ind.MA20_P5_Buffer,true);
   ArraySetAsSeries(Ind.MA50_P5_Buffer,true);
   ArraySetAsSeries(Ind.MA200_P5_Buffer,true);
     
  }
  
void Indicators_Release_PERIOD_M5()
  {  
   // ##### PERIOD_M5
   IndicatorRelease(Ind.BBands_P5_Handle);
   IndicatorRelease(Ind.BBands_P5_Handle2);
   IndicatorRelease(Ind.BBandwidth_Daily_Handle);
   IndicatorRelease(Ind.MA20_P5_Handle);
   IndicatorRelease(Ind.MA50_P5_Handle);
   IndicatorRelease(Ind.MA200_P5_Handle);
  }  
  
  
//+------------------------------------------------------------------+
//| Buffers Call                                                     |
//+------------------------------------------------------------------+  
// ##### PERIOD_M15
void Buffers()
  {
   // BBands Buffers
   if(   CopyBuffer(Ind.BBandsHandle2,1,0,5,Ind.BBUp2) < 0 
      || CopyBuffer(Ind.BBandsHandle2,2,0,5,Ind.BBLow2) < 0
      || CopyBuffer(Ind.BBandsHandle_n,1,0,5,Ind.BBUp_n) < 0
      || CopyBuffer(Ind.BBandsHandle_n,2,0,5,Ind.BBLow_n) < 0
      || CopyBuffer(Ind.BBandsHandle,1,0,5,Ind.BBUp) < 0
      || CopyBuffer(Ind.BBandsHandle,2,0,5,Ind.BBLow) < 0
      || CopyBuffer(Ind.BBandsHandle,0,0,5,Ind.BBMid) < 0   )
     {
      Debug_Alert(" Error copying BBands indicators Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }
   // Stochastic Buffers
   if(   CopyBuffer(Ind.StochHandle,0,0,3,Ind.StochMainBuffer) < 0 
      || CopyBuffer(Ind.StochHandle,1,0,7,Ind.StochSignalBuffer) < 0 )
     {
      Debug_Alert(" Error copying Stochastic indicators Buffers - error: "+GetLastError() ); 
      ResetLastError();
      return;
     }  
   // Rates Buffers 
   if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)
     {
      Debug_Alert(" Error copying M15 rates - error: "+GetLastError()); 
      ResetLastError(); return;
     }  
   // Volume Buffers
   if( CopyBuffer(Ind.Volume_Handle,0,0,2,Ind.Volume_Buffer) < 0 )
     {
      Debug_Alert(" Error copying Volume indicator Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }  
   // MA's Buffers 
   if(   CopyBuffer(Ind.MA20_Handle,0,0,4,Ind.MA20_Buffer) < 0
      || CopyBuffer(Ind.MA50_Handle,0,0,4,Ind.MA50_Buffer) < 0
      || CopyBuffer(Ind.MA200_Handle,0,0,4,Ind.MA200_Buffer) <0 )
     {
      Debug_Alert(" Error copying MA's indicators Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }  
   // BBandwidth Buffers
   if( CopyBuffer(Ind.BBandwidth_Handle,0,0,12,Ind.BBandwidth_Buffer) < 0 )
     {
      Debug_Alert(" Error copying BBandwidth indicator Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }    
   // MA_distance Buffers
   if(   CopyBuffer(Ind.MAdistance_Handle,0,0,6,Ind.MA50_20_Buffer) < 0 
      || CopyBuffer(Ind.MAdistance_Handle,1,0,6,Ind.MA200_50_Buffer) < 0
      || CopyBuffer(Ind.MAdistance_Handle,1,0,6,Ind.MAs_Distance_Buffer) < 0 )
     {
      Debug_Alert(" Error copying MAdistance indicators Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }      
  
  }  // fim da Buffers
  
// ##### PERIOD_M5
void Buffers_P5()
  {
   // BBands Buffers
   if(   CopyBuffer(Ind.BBands_P5_Handle2,1,0,5,Ind.BB_P5_Up2) < 0 
      || CopyBuffer(Ind.BBands_P5_Handle2,2,0,5,Ind.BB_P5_Low2) < 0
      || CopyBuffer(Ind.BBands_P5_Handle,1,0,5,Ind.BB_P5_Up) < 0
      || CopyBuffer(Ind.BBands_P5_Handle,2,0,5,Ind.BB_P5_Low) < 0
      || CopyBuffer(Ind.BBands_P5_Handle,0,0,5,Ind.BB_P5_Mid) < 0   )
     {
      Debug_Alert(" Error copying BBands indicators Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }
   // BBandwidth Buffers
   if( CopyBuffer(Ind.BBandwidth_Daily_Handle,0,0,10,Ind.BBandwidth_Daily_Buffer) < 0 )
     {
      Debug_Alert(" Error copying BBandwidth indicator Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }  
   // Rates Buffers 
   if(CopyRates(Ativo,PERIOD_M5,0,3,mrate) < 0)
     {
      Debug_Alert(" Error copying M15 rates - error: "+GetLastError()); 
      ResetLastError(); return;
     }  
   // MA's Buffers 
   if(   CopyBuffer(Ind.MA20_P5_Handle,0,0,4,Ind.MA20_P5_Buffer) < 0
      || CopyBuffer(Ind.MA50_P5_Handle,0,0,4,Ind.MA50_P5_Buffer) < 0
      || CopyBuffer(Ind.MA200_P5_Handle,0,0,4,Ind.MA200_P5_Buffer) <0 )
     {
      Debug_Alert(" Error copying MA's indicators Buffers_P5 - error: "+GetLastError() ); 
      ResetLastError(); return;
     }    
     
  }    // fim da Buffers_P5
  
  
//+------------------------------------------------------------------+