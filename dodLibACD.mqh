//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| ACD strategy                                                     |
//+------------------------------------------------------------------+
void Estrategia_ACD()
  {
   // Verificação das condições de negociação da estratégia ACD  
   if( !PositionSelect(Ativo) && !Signals.ACD_Once )
     {
      // verifica horários não permitidos para entrada de operação
      if(   (str1.hour == 9 && str1.min < 32)
         || (str1.hour >= BlockTradeStartHour && str1.min >= BlockTradeStartMin)
         || (str1.hour == 18 && str1.min >= 00))
        {
         return;   // sai da função e prossegue no mesmo tick
        }
      else    // horário permitido
        {
         ACD();
        }       
     }
   else
     {
      if(Signals.TradeSignal_ACD)
        {
         ACD_SL_SG();
        }
     }
  }
  
void ACD()
  {
   Buffers();
   
   // Condições de compra ACD 
   if(   Ind.StochSignalBuffer[0] > ACD_OnLong                 // estocastico no regime ACD long
      && mrate[0].close > Global.ORmax                         // preço acima do OR
      && MA_Alignment_Long()                                   // medias ascendentes
      && mrate[0].close > Ind.BBUp2[0]                         // preço acima da banda superior 2 sigma
      && Ind.BBandwidth_Buffer[1] > Ind.BBandwidth_Buffer[2]   // volatilidade aumentando
      && Ind.StochMainBuffer[0] > Ind.StochSignalBuffer[0]     // cruzamento do estocastico na direção desejada   
      && Ind.StochMainBuffer[0] > Ind.StochMainBuffer[1]    )                                                   
     {                                             
      OpenLongPosition(); 
      if(Signals.LongPosition == true)
        {
         Signals.TradeSignal_ACD = true;
         if(Strategy.Debug){
         Debug(" Ordem de compra ACD: "); } 
         if(Strategy.Habilitar_ACD_Once)
           {
            Signals.ACD_Once = true;
            if(Strategy.Debug){
            Debug(" ACD_once: "+Signals.ACD_Once); } 
           }  
        }
      else
        {
         Alert(" Falhou a Tentativa de Entrada!!!");
         Debug_Alert(" Falhou a Tentativa de Entrada!!!");
         return;
        }                        
     }
     
   // Condições de venda ACD
   if (   Ind.StochSignalBuffer[0] < ACD_OnShort                // estocastico no regime ACD short
       && mrate[0].close < Global.ORmin                         // preço abaixo do OR
       && MA_Alignment_Short()                                  // medias descendentes
       && mrate[0].close < Ind.BBLow2[0]                        // preço abaixo da banda inferior 2 sigma
       && Ind.BBandwidth_Buffer[1] > Ind.BBandwidth_Buffer[2]   // volatilidade aumentando
       && Ind.StochMainBuffer[0] < Ind.StochSignalBuffer[0]     // cruzamento do estocastico na direção desejada
       && Ind.StochMainBuffer[0] < Ind.StochMainBuffer[1]    )
     {                                           
      OpenShortPosition(); 
      if(Signals.ShortPosition == true)
        {
         Signals.TradeSignal_ACD = true;
         if(Strategy.Debug){
         Debug(" Ordem de venda ACD: "); }
         if(Strategy.Habilitar_ACD_Once)
           {
            Signals.ACD_Once = true;
            if(Strategy.Debug){
            Debug(" ACD_Once: "+Signals.ACD_Once); }
           }   
        } 
      else
        {
         Alert(" Falhou a Tentativa de Entrada!!!");
         Debug_Alert(" Falhou a Tentativa de Entrada!!!");
         return;
        }          
     }  
       
  } // fim da ACD()   

void ACD_SL_SG()
  {  
   TimeToStruct(Global.date1 = TimeCurrent(),str1);
   Buffers();
   
   // verificação de saidas de posição de compra
   if(Signals.LongPosition)
     { 
      double diff = (Ind.BBUp[0] - Ind.BBMid[0])/SigmaFactorLong;
      // Stop entre as bandas 1 sigma
      if(mrate[0].close < (Ind.BBMid[0] + diff) )     
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop ACD de operação long por SigmaFactorLong "); }  
         return;
        } 
      // saida por TIME    
      if(   str1.hour >= TimeExitHour 
         && str1.min  >= TimeExitMin  )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação long ACD por TIME "); }
         return;
        }  
               
      // saida por Breakeven
      if(Strategy.Habilitar_Breakeven)
        {
         // analisa se a trade entra no modo Breakeven
         if(Breakeven_Long() && !Global_Get("Breakeven_mode"))
           {
            Global_Set("Breakeven_mode",TRUE);
            if(Strategy.Debug){
            Debug(" Breakeven_mode: "+Global_Get("Breakeven_mode"));}
           }
         // saida por Breakeven
         if(   Global_Get("Breakeven_mode") 
            && mrate[0].close <= (Global.price_trade_start + Breakeven_long_exit) )
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra ACD por Breakeven ");}
            
            return;      
           }  
         }  // fim da saida por Breakeven
                  
     }  // fim da verificação de saidas long

   // verificação de saidas de posição de venda  
   if(Signals.ShortPosition)
     {
      double diff = (Ind.BBMid[0] - Ind.BBLow[0])/SigmaFactorShort;
      // Stop entre as bandas 1 sigma
      if(mrate[0].close > (Ind.BBLow[0] + diff) )   
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop ACD de operação Short por SigmaFactorShort "); }
         return;
        }   
      // saida por TIME  
      if(   str1.hour >= TimeExitHour 
         && str1.min  >= TimeExitMin  )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação short ACD por TIME "); }
         return;
        } 
        
      // saida por Breakeven short
      if(Strategy.Habilitar_Breakeven)
        {
         // analisa se a trade entra no modo Breakeven
         if(Breakeven_Short() && !Global_Get("Breakeven_mode"))
           {
            Global_Set("Breakeven_mode",TRUE);
            if(Strategy.Debug){
            Debug(" Breakeven_mode: "+Global_Get("Breakeven_mode"));}
           }
         // saida por Breakeven
         if(   Global_Get("Breakeven_mode") 
            && mrate[0].close >= (Global.price_trade_start - Breakeven_short_exit) )
           {
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de venda ACD por Breakeven ");} 
            return;      
           }  
         }  // fim da saida por Breakeven short
        
     }  // fim da verificação de saidas short     
     
  } // fim da ACD_SL_SG()
  

//+------------------------------------------------------------------+