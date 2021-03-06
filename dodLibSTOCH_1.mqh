//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| STOCH1 strategy                                                  |
//+------------------------------------------------------------------+
void Estrategia_STOCH1()
  {
   // Verificação das condições de negociação da estratégia STOCH1  
   if( !PositionSelect(Ativo) && !Signals.STOCH1_Once )  
     {
      // verifica horários não permitidos para entrada de operação
      if(   (str1.hour == TradeStartHour && str1.min < TradeStartMin)
         || (str1.hour >= BlockTradeStartHour && str1.min >= BlockTradeStartMin)
         || (str1.hour == 18 && str1.min >= 00)                                 )
        {
         return;   // sai da função e prossegue no mesmo tick
        }
      else   // horário permitido
        {
         STOCH1();  
        }       
     }
   else
     {
      if(Signals.TradeSignal_STOCH1)
        {
         STOCH1_SL_SG();
        }
     }  
   }
  
void STOCH1()
  {
   Buffers();
   // condições long
   // verifica se o estacastico esta ascendente e cruza o limite Stoch1_Buy_On
   if((   Ind.StochSignalBuffer[0] > Stoch1_Buy_On 
       && Ind.StochSignalBuffer[1] <= Stoch1_Buy_On )
       
       && Ind.StochMainBuffer[0] > Ind.StochSignalBuffer[0]     // cruzamento do estocastico na direção desejada   
       && Ind.StochMainBuffer[0] > Ind.StochMainBuffer[1]
           
       && (   (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[1]) > BumpSTOCH1_Buy 
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[2]) > BumpSTOCH1_Buy
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[3]) > BumpSTOCH1_Buy 
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[4]) > BumpSTOCH1_Buy
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[5]) > BumpSTOCH1_Buy 
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[6]) > BumpSTOCH1_Buy ) )
     {             
      OpenLongPosition(); 
      if(Signals.LongPosition == true)
        {
         if(Strategy.Debug){
         Debug( " Ordem de compra STOCH1: "); }   
   
         // Operações STOCH1 apenas uma vez ao dia 
         if(Strategy.Habilitar_STOCH1_Once)     
           {
            Signals.STOCH1_Once = true;
            if(Strategy.Debug){
            Debug(" STOCH1_Once: "+Signals.STOCH1_Once); } 
           }
         Signals.TradeSignal_STOCH1 = true;
         return; 
        } 
      else
        {
         Alert(" Falhou a Tentativa de Entrada!!!");
         Debug_Alert(" Falhou a Tentativa de Entrada!!!");
         return;
        }      
                     
     }
     
   // condições short
   // verifica se o estocastico esta descendente e cruza o limite Stoch1_Sell_On
   if((   Ind.StochSignalBuffer[0] < Stoch1_Sell_On 
       && Ind.StochSignalBuffer[1] >= Stoch1_Sell_On )
       
       && Ind.StochMainBuffer[0] < Ind.StochSignalBuffer[0]     // cruzamento do estocastico na direção desejada
       && Ind.StochMainBuffer[0] < Ind.StochMainBuffer[1]
          
       && (   (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[1]) < BumpSTOCH1_Sell 
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[2]) < BumpSTOCH1_Sell
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[3]) < BumpSTOCH1_Sell 
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[4]) < BumpSTOCH1_Sell
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[5]) < BumpSTOCH1_Sell 
           || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[6]) < BumpSTOCH1_Sell  )
                    )
     {             
      OpenShortPosition(); 
      if(Signals.ShortPosition == true)
        {
         if(Strategy.Debug){
         Debug(" Ordem de venda STOCH1: "); }
         
         // Operações STOCH1 apenas uma vez ao dia 
         if(Strategy.Habilitar_STOCH1_Once)     
           {
            Signals.STOCH1_Once = true;
            if(Strategy.Debug){
            Debug(" STOCH1_Once: "+Signals.STOCH1_Once); } 
           }
         Signals.TradeSignal_STOCH1 = true; 
         return;       
        } 
      else
        {
         Alert(" Falhou a Tentativa de Entrada!!!");
         Debug_Alert(" Falhou a Tentativa de Entrada!!!");
         return;
        }     
     }                         
  }  // fim da STOCH1()  
  
void STOCH1_SL_SG()
  {
   Buffers();
   double volatilidade = 100 - (100 * Ind.BBLow[0]/Ind.BBUp[0]);   
   TimeToStruct(Global.date1 = TimeCurrent(),str1);
   
   // verificação de saidas de posição de compra
   if(Signals.LongPosition)
     {  
      // saída por MA_Control
      if(Strategy.Habilitar_MA_Control)
        {
         // verifica zona de resistencia
         if((   Global_Get("MA_mode_200")
             || Global_Get("MA_mode_50") )
            && Resistance_200_50()          )
           {    
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra STOCH_1 por zona de resistencia_200_50 "); } 
            return;          
           }         
        }
        
      // analisa o encontro com a media na direção contraria da trade   
      if(   Global.price_trade_start > Ind.MA50_Buffer[1]
         && (TimeCurrent() >= (long)Global.initialize_unixtime + 1801)
         && mrate[1].close <= Ind.MA50_Buffer[1]                  // nasty candle 1
         && mrate[2].close <= Ind.MA50_Buffer[2]          )       // nasty candle 2
        {    
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra STOCH_1 por 2 nasty candles "); } 
         return;          
        }    
        
      // verifica o estocastico descendente apos o limite superior StochMax
      if(    Ind.StochSignalBuffer[0] > StochMax 
         && (   Ind.StochSignalBuffer[0] < Ind.StochSignalBuffer[1] 
             || Ind.StochSignalBuffer[1] < Ind.StochSignalBuffer[2]
             || Ind.StochSignalBuffer[2] < Ind.StochSignalBuffer[3] ) )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop STOCH1 long: estocastico descendente apos o limite superior StochMax "); }
         return;
        }  
        
      // stop loss STOCH1 long apos verificar a volta do estocastico ao ponto de inicio da estrategia STOCH1
      if(Ind.StochSignalBuffer[0] < Stoch1_Buy_On - Stoch1_FactorLong)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop Loss STOCH1 de operação long: volta do estocastico ao ponto de inicio - Stoch1_FactorLong "); }         
         return;
        } 
        
      // stop loss por fechamento abaixo do sigma 2 - evita perdas enormes 
      if(   mrate[1].close < Ind.BBLow2[1]
         && (TimeCurrent() >= (long)Global.initialize_unixtime + 901))
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop STOCH1 long: fechamento abaixo do sigma 2  "); }         
         return;
        }   
         
      // saida por CandleStick
      if(Strategy.Habilitar_CS_Control)
        {    
         if(Shooting_Star())
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra STOCH_1 por Shooting_Star ");}
            return;
           }            
         if(Candle_Math_Top())
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra STOCH_1 por Candle_Math_Top ");}
            return;
           } 
        }        
        
      // saída por TIME
      if(   str1.hour >= TimeExitHour 
         && str1.min >= TimeExitMin  )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação STOCH1 long por TIME "); }      
         return;
        }

     } // fim das saidas de posição de compra
   
   // verificação de saidas de posição de venda
   if(Signals.ShortPosition)
     {    
      // saída MA_Control
      if(Strategy.Habilitar_MA_Control)
        {
         // verifica zona de suporte
         if( (   Global_Get("MA_mode_200")
              || Global_Get("MA_mode_50") )
            && Support_200_50()              )
           {         
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de venda STOCH_1 por zona de suporte_200_50 "); } 
            return;          
           }       
         }  
         
      // analisa o encontro com a media na direção contraria da trade       
      if(   Global.price_trade_start < Ind.MA50_Buffer[1] 
         && (TimeCurrent() >= (long)Global.initialize_unixtime + 1801)
         && mrate[1].close >= Ind.MA50_Buffer[1]                // nasty candle 1
         && mrate[2].close >= Ind.MA50_Buffer[2]          )     // nasty candle 2
        {         
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda STOCH_1 por 2 nasty candles "); } 
         return;          
        }
              
      // verifica o estocastico ascendente apos o limite inferior StochMin
      if(   Ind.StochSignalBuffer[0] < StochMin
         && (   Ind.StochSignalBuffer[0] > Ind.StochSignalBuffer[1] 
             || Ind.StochSignalBuffer[1] > Ind.StochSignalBuffer[2]
             || Ind.StochSignalBuffer[2] > Ind.StochSignalBuffer[3] ) )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop STOCH1 short: estocastico ascendente apos o limite inferior StochMin "); }  
         return;  
        }
       
      // stop loss STOCH1 short apos verificar a volta do estocastico ao ponto de inicio da estrategia STOCH1
      if(Ind.StochSignalBuffer[0] > (Stoch1_Sell_On + Stoch1_FactorShort) )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop Loss de operação STOCH1 Short: volta do estocastico ao ponto de inicio + Stoch1_FactorShort "); }               
         return;
        }
        
      // stop loss fechamento acima do sigma 2 - evita perdas enormes 
      if(   mrate[1].close > Ind.BBUp2[1]
         && (TimeCurrent() >= (long)Global.initialize_unixtime + 901))
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop STOCH1 short: fechamento acima do sigma 2  "); }         
         return;
        }     
        
      // saida por CandleStick
      if(Strategy.Habilitar_CS_Control)
        {    
         if(Hammer())
           {
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de venda STOCH_1 por Hammer ");}
            return;
           }            
         if(Candle_Math_Bottom())
           {
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de venda STOCH_1 por Candle_Math_Bottom ");}
            return;
           } 
        }     
        
      // saida por TIME  
      if(   str1.hour >= TimeExitHour 
         && str1.min >= TimeExitMin  )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação STOCH1 short por TIME "); }   
         return;
        }    
              
     } // fim das saidas de posição de venda
     
  }  // fim da STOCH1_SL_SG() 


//+------------------------------------------------------------------+