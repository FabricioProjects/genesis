//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| SQUEEZE_HEAD strategy                                            |
//+------------------------------------------------------------------+
void Estrategia_SQUEEZE_HEAD()
  {
   // Verificação das condições de negociação da estratégia SQUEEZE_HEAD    
   if(   !PositionSelect(Ativo) 
      && Global_Get("SQUEEZE_Once")                   // já stopou SQUEEZE
      && !Global_Get("SQUEEZE_HEAD_Once")             // não houve operação SQUEEZE_HEAD
      && TimeCurrent() < Global.delay_SQUEEZE_HEAD )   // o stop SQUEEZE ocorreu somente após alguns candles
//      && TimeCurrent() > ((long)Global.finalize_unixtime + 901) )  // espera um candle para entrar novamente 
     {
      // verifica horários não permitidos para entrada de operação
      if(   (str1.hour == 9 && str1.min <= 1)
         || (str1.hour >= BlockTradeStartHour && str1.min >= BlockTradeStartMin)
         || (str1.hour == 18 && str1.min >= 00))
        {
         return;    // sai da função e prossegue no mesmo tick
        }
      else  // horário permitido
        {
         SQUEEZE_HEAD();  
        }       
     }
   else
     {
      if(Global_Get("TradeSignal_SQUEEZE_HEAD"))
        {
         SQUEEZE_HEAD_SL_SG();
        }
     }
  }
  
  
void SQUEEZE_HEAD()
  { 
   Buffers();  // Aloca os buffers dos indicadores 
   // Condições de abertura long
   if(   
         !Global_Get("SQUEEZE_long")                          // a ultima trade SQUEEZE não pode ser long
      && Signals.Head_Allowed                                 // a ultima operação foi de loss
      && mrate[0].close > Ind.BBMid[0] + np*pip                       // fechamento acima da media 20 
//      && Ind.BBandwidth_Buffer[1] > Ind.BBandwidth_Buffer[2]  // volat crescente
                                                                )                 
      
     {
      OpenLongPosition_SQ_HEAD();       
     }
   // Condição de abertura short 
   if(   
         !Global_Get("SQUEEZE_short")                          // a ultima trade SQUEEZE não pode ser short
      && Signals.Head_Allowed                                  // a ultima operação foi de loss
      && mrate[0].close < Ind.BBMid[0] - np*pip                        // fechamento abaixo da media 20
//      && Ind.BBandwidth_Buffer[1] > Ind.BBandwidth_Buffer[2]   // volat crescente
                                                                )
     {
      OpenShortPosition_SQ_HEAD();     
     }         

  } // fim da SQUEEZE_HEAD
  
  
void SQUEEZE_HEAD_SL_SG()
  {
   Buffers();
   double price = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
   // saidas long
   if(Signals.LongPosition)
     {  
      // saida por Band Jump
      if(price >= Ind.BBUp2[0] + Band_Jump_Long)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE_HEAD por Band Jump ");}
         
         return;      
        }    
        
      // saida por loss
      if(
//            mrate[1].close < Ind.BBMid[1]
//         && mrate[2].close < Ind.BBMid[2]
           mrate[0].close < Ind.BBLow[0]                    
                                          )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE_HEAD por fechar abaixo da MA20 ");}
         
         return;      
        }      
        
      // saida por alvo
      if(mrate[0].close > Ind.BBUp2[1])
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE_HEAD por alvo Sigma 2 ");}
         
         return;      
        }        
       
/*
      // saida por volatilidade  
      if(   Ind.BBandwidth_Buffer[1] < Ind.BBandwidth_Buffer[2]
         && Ind.BBandwidth_Buffer[2] < Ind.BBandwidth_Buffer[3] )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE_HEAD por volatilidade decrescente ");}
         return;      
        }    
*/

/*                  
      // saida por volatilidade  
      if(Ind.BBandwidth_Buffer[1] >= Max_Width)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE_HEAD por volatilidade ");
         Debug(" Volatilidade: "+Ind.BBandwidth_Buffer[0]);                         }
         
         return;      
        }  
*/              
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação SQUEEZE_HEAD long por TIME "); }
                    
         return;
        }       
     } // fim saidas long
     
   // saidas short  
   if(Signals.ShortPosition)
     {      
      // saida por Band Jump
      if(price <= Ind.BBLow2[0] - Band_Jump_Short)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE_HEAD por Band Jump ");}
         
         return;      
        }  
        
      // saida por loss
      if(
//            mrate[1].close > Ind.BBMid[1]
//         && mrate[2].close > Ind.BBMid[2]   
            mrate[0].close > Ind.BBUp[0]    
                                            )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE_HEAD por fechar acima da MA20 ");}
         
         return;      
        }    
        
      // saida por alvo
      if(mrate[0].close < Ind.BBLow2[0])
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE_HEAD por alvo Sigma 2 ");}
         
         return;      
        }      

/*
      // saida por volatilidade  
      if(   Ind.BBandwidth_Buffer[1] < Ind.BBandwidth_Buffer[2]
         && Ind.BBandwidth_Buffer[2] < Ind.BBandwidth_Buffer[3] )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE_HEAD por volatilidade decrescente ");}
         return;      
        }
*/ 
/*                 
      // saida por volatilidade  
      if(Ind.BBandwidth_Buffer[1] >= Max_Width)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE_HEAD por volatilidade ");
         Debug(" Volatilidade: "+Ind.BBandwidth_Buffer[0]);                         }
         
         return;      
        }
*/                
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação SQUEEZE_HEAD short por TIME "); }
                    
         return;
        }      
        
     }  // fim saidas short  
     
  }  // fim da SQUEEZE_SL_SG    
  
  
  
  
void OpenShortPosition_SQ_HEAD()   
  {
//   if(long(Global.tick_unixtime) > long(Global.finalize_unixtime) + 900){
   OpenShortPosition();
   Global_Set("TradeSignal_SQUEEZE_HEAD",TRUE);
   Global_Set("SQUEEZE_HEAD_Once",TRUE);
   if(Strategy.Debug){
   Debug(" Abertura de operação de venda SQUEEZE_HEAD ");}
//   }
   return;         
  } 
  
void OpenLongPosition_SQ_HEAD()
  {
//   if(long(Global.tick_unixtime) > long(Global.finalize_unixtime) + 900){
   OpenLongPosition();
   Global_Set("TradeSignal_SQUEEZE_HEAD",TRUE);
   Global_Set("SQUEEZE_HEAD_Once",TRUE);
   if(Strategy.Debug){
   Debug(" Abertura de operação de compra SQUEEZE_HEAD ");}
//   }
   return;  
  }  