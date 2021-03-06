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
   // VOLUME
   int          Volume_Handle;        // Volume handle default
   double       Volume_Buffer[];      // buffer do volume
   
// CUSTOM INDICATORS
   // BBANDWIDTH
   int          BBandwidth_Handle;
   double       BBandwidth_Buffer[];

  } Ind;
  
//+------------------------------------------------------------------+
//| INDICADORES EXCLUSIVOS PARA ANALISE GLOBAL DO ATIVO              |
//+------------------------------------------------------------------+   
void Indicators_Market_Analysis()
  {
   // ##### PERIOD_M15
   // Get handle of the Volume indicator 
   Ind.Volume_Handle = iVolumes(Ativo,PERIOD_M15,VOLUME_TICK);
   // Get handle of the BBandwidth custom indicator
   Ind.BBandwidth_Handle = iCustom(Ativo,PERIOD_M15,"dod_BBandwidth",20,0,2,PRICE_CLOSE); 
   
   // Check for Invalid Handle
   if(// ##### PERIOD_M15   
         Ind.Volume_Handle < 0
      || Ind.BBandwidth_Handle < 0 
                                        )
     {
      Alert(" Error in creation of indicators M15 - error: "+GetLastError()); 
     } 
  
   // Atribuição de arrays para buffers do indicador
   // ##### PERIOD_M15
   SetIndexBuffer(0,Ind.Volume_Buffer,INDICATOR_DATA);
   
   SetIndexBuffer(0,Ind.BBandwidth_Buffer,INDICATOR_DATA);
  

   // Let's make sure our arrays values for the Rates and Indicators is stored serially 
   // ##### PERIOD_M15
   ArraySetAsSeries(mrate,true);

   ArraySetAsSeries(Ind.Volume_Buffer,true);
  
   ArraySetAsSeries(Ind.BBandwidth_Buffer,true);
 
  }
  
void Indicators_Market_Analysis_Release()
  {  
   // ##### PERIOD_M15
   IndicatorRelease(Ind.Volume_Handle);
   IndicatorRelease(Ind.BBandwidth_Handle);
  }    
  
//+------------------------------------------------------------------+
//| Buffers Call                                                     |
//+------------------------------------------------------------------+  
// ##### PERIOD_M15
void Buffers_Market_Analysis()
  {
   // BBandwidth Buffers
   if( CopyBuffer(Ind.BBandwidth_Handle,0,0,36,Ind.BBandwidth_Buffer) < 0 )
     {
      Alert(" Error copying BBandwidth indicator Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }       
   // Volume Buffers
   if( CopyBuffer(Ind.Volume_Handle,0,0,4,Ind.Volume_Buffer) < 0 )
     {
      Alert(" Error copying Volume indicator Buffers - error: "+GetLastError() ); 
      ResetLastError(); return;
     }  
  
  }  // fim da Buffers_Market_Analysis 
   
//+------------------------------------------------------------------+  