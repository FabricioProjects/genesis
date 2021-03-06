//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| GAP_Control                                                      |
//+------------------------------------------------------------------+   
void GAP_Control_Nature()
  { 
   if(   Strategy.Habilitar_GAP_Control
                                          )
     {
      // verifica se há GAP no começo do dia
      if(  (   str1.hour == 09 && str1.min == 00 
            || str1.hour == 09 && str1.min == 01
            || str1.hour == 09 && str1.min == 02)
         && Signals.GAP_Low == false
         && Signals.GAP_High == false               ) 
        {
         if(CopyRates(Ativo,PERIOD_M15,0,2,mrate) < 0)
           {
            Debug_Alert(" Gap_Control - Error copying M15 rates - error: "+GetLastError() ); 
            ResetLastError();
            return;
           }  
         if(   mrate[0].open - mrate[1].low < 0 
            && mrate[0].open - mrate[1].low < (-GAP_Range) )
           {
            Signals.GAP_Low = true;
            if(Strategy.Debug){
            Debug(" GAP_Low = "+Signals.GAP_Low+
                  " GAP_Range > "+(-GAP_Range) ); }
           }
         if(   mrate[0].open - mrate[1].high > 0 
            && mrate[0].open - mrate[1].high > (GAP_Range) )
           {
            Signals.GAP_High = true;
            if(Strategy.Debug){
            Debug(" GAP_High = "+Signals.GAP_High+
                  " GAP_Range > "+(+GAP_Range) );  }
           } 
         // Com GAP acima do GAP_Range, o Genesis nao opera   
         if(Signals.GAP_Low || Signals.GAP_High)  
           {
            Strategy_Manager_False();
     
            Global.min_prev = mrate[1].low;
            Global.max_prev = mrate[1].high;
            Global.close_prev = mrate[1].close;
           }  
        }
      // reseta para o dia seguinte  
      if(   str1.hour == TimeExitHour 
         && str1.min == TimeExitMin +1 ) 
        {
         Strategy_Manager();
         Signals.GAP_Low = false;
         Signals.GAP_High = false;
        }  
     }
  }
  
//+------------------------------------------------------------------+
//| GAP strategy                                                     |
//+------------------------------------------------------------------+
void Estrategia_GAP()
  {
   // Verificação das condições de negociação da estratégia GAP    
   if(   !PositionSelect(Ativo)
      && (Signals.GAP_Low || Signals.GAP_High) )
     {
      GAP();         
     }
   else
     {
      if(Global_Get("TradeSignal_GAP"))
        {
         GAP_SL_SG();
        }
     }
  }  
  
//+------------------------------------------------------------------+
//| GAP enter                                                        |
//+------------------------------------------------------------------+  
void GAP()
  {  
   Buffers();
   // entrada long
   if(
         Signals.GAP_Low
      && (str1.hour == 9 && str1.min == 15 && str1.sec == 00)   
      && (mrate[1].high < mrate[2].low - 5*pip)
                                                )
     {
      OpenLongPosition_GAP();
     }                                              
  
    // entrada short
   if(
         Signals.GAP_High
      && (str1.hour == 9 && str1.min == 15 && str1.sec == 00)   
      && (mrate[1].low > mrate[2].high + 5*pip)
                                                )
     {
      OpenShortPosition_GAP();
     }                         
  } // fim da GAP
  
//+------------------------------------------------------------------+
//| GAP_SL_SG                                                        |
//+------------------------------------------------------------------+  
void GAP_SL_SG()
  {
   Buffers();
   if(Signals.LongPosition)
     {
      // saidas long
      if(   
            mrate[0].close >= Global.min_prev - 4*pip
         || mrate[0].close < Global.price_trade_start - 8*pip
                                                               )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra GAP ");}
         return;
        }   
     }   
   if(Signals.ShortPosition)
     {   
      // saidas short
      if(
            mrate[0].close <= Global.min_prev + 4*pip
         || mrate[0].close > Global.price_trade_start + 8*pip
                                                               )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda GAP ");}
         return;
        } 
     }                                                           
    
  }
  
//+------------------------------------------------------------------+
//| Abertura de posições                                             |
//+------------------------------------------------------------------+   
void OpenLongPosition_GAP()
  {
   OpenLongPosition();
   Global_Set("TradeSignal_GAP",TRUE);
   if(Strategy.Debug){
   Debug(" Abertura de operação de compra GAP ");}

   return;  
  }    
  
void OpenShortPosition_GAP()
  {
   OpenShortPosition();
   Global_Set("TradeSignal_GAP",TRUE);
   if(Strategy.Debug){
   Debug(" Abertura de operação de venda GAP ");}

   return;  
  }      