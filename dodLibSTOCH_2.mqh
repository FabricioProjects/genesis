//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| STOCH2 strategy                                                  |
//+------------------------------------------------------------------+
void Estrategia_STOCH2()
  {
   // Verificação das condições de negociação da estratégia STOCH2    
   if( !PositionSelect(Ativo) && !Signals.STOCH2_Once )
     {
      // verifica horários não permitidos para entrada de operação
      if(   (str1.hour == TradeStartHour && str1.min < TradeStartMin)
         || (str1.hour >= BlockTradeStartHour && str1.min >= BlockTradeStartMin)
         || (str1.hour == 18 && str1.min >= 00))
        {
         return;    // sai da função e prossegue no mesmo tick
        }
      else  // horário permitido
        {
         STOCH2();  
        }       
     }
   else
     {
      if(Signals.TradeSignal_STOCH2)
        {
         STOCH2_SL_SG();
        }
     }
  } // fim da Estrategia_STOCH2()
  
void STOCH2()
  {
   Buffers();
   // largura das bandas dada em percentagem de reta evolução  
   double volatilidade = 100 - (100 * Ind.BBLow[0]/Ind.BBUp[0]);  
   
   // condição de entrada no limite inferior
   Signals.BuyCondition1_STOCH2 = (    Ind.StochSignalBuffer[0] >= StochMin 
                                    && Ind.StochSignalBuffer[1] < StochMin 
                                    && Ind.StochMainBuffer[0] > Ind.StochSignalBuffer[0]  // cruzamento do estocastico na direção desejada   
                                    && Ind.StochMainBuffer[0] > Ind.StochMainBuffer[1]  
                                    // analisa se entra estopando   
                                    && !((Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[5]) < BumpStopLossLong) 
                                    && !((Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[6]) < BumpStopLossLong) );
                                                                
   if(   Signals.BuyCondition1_STOCH2 
      && !Signals.STOCH2_bool1_buy   )
     {
      Global.STOCH2_buy_delay_enter = TimeCurrent();
      Signals.STOCH2_bool1_buy = true; 
      if(Strategy.Debug){
      Debug(" STOCH2_buy_delay_enter: "+Global.STOCH2_buy_delay_enter ); }
     }  
     
   if(   Signals.BuyCondition1_STOCH2 
      && Signals.STOCH2_bool1_buy    )
     {
      Global.STOCH2_buy_delay_exit = TimeCurrent();
      if( (long)Global.STOCH2_buy_delay_exit >= ((long)Global.STOCH2_buy_delay_enter + STOCH2_Buy_Delay) )
        {
         Signals.BuyCondition2_STOCH2 = true;
         if(Strategy.Debug){
         Debug(" STOCH2_buy_delay_exit: "+Global.STOCH2_buy_delay_exit); }   
        }
      else return; 
     }
   else
     {
      Signals.STOCH2_bool1_buy = false;
     }  
     
   if(   Signals.BuyCondition1_STOCH2 
      && Signals.BuyCondition2_STOCH2 )    
     {  
/*       
      // verifica se o stop na media de 50 será instantaneo 
      if(Strategy.Habilitar_MA_Control)
        {
         if(   Global_Get("MA_mode_50") && Resistance_200_50()
            || (   Global.price_trade_start > Ind.MA50_Buffer[1]
                && mrate[1].close <= Ind.MA50_Buffer[1]
                && mrate[2].close <= Ind.MA50_Buffer[2]  )      ) 
           {
            Signals.STOCH2_Once = true; 
            if(Strategy.Debug){
            Debug(" STOCH2_Once por entrada com stop instantaneo: "+Signals.STOCH2_Once); }
            return;
           }   
        }
*/                                        
      OpenLongPosition();
      if(Signals.LongPosition == true)
        {
         if(Strategy.Debug){
         Debug(" Ordem de compra STOCH2: "); }   
         Signals.TradeSignal_STOCH2 = true; 
         Signals.BuyCondition2_STOCH2 = false;
         Signals.STOCH2_bool1_buy = false;  
         // Operações STOCH2 apenas uma vez ao dia  
         if(Strategy.Habilitar_STOCH2_Once)     
           {
            Signals.STOCH2_Once = true;
            if(Strategy.Debug){
            Debug(" STOCH2_Once: "+Signals.STOCH2_Once); } 
           }
         
         if(volatilidade > Volat_STOCH2 - 0.05)
           {
            Signals.Vol = true;
           }       
         else
           {
           Signals.Vol = false;
           } 
         return;   
        } 
      else
        {
         Alert(" Falhou a Tentativa de Entrada!!!");
         Debug_Alert(" Falhou a Tentativa de Entrada!!!");
         return;
        }      
                            
     }
       
   // condição de entrada no limite superior                     
   Signals.SellCondition1_STOCH2 = (    Ind.StochSignalBuffer[0] <= StochMax 
                                     && Ind.StochSignalBuffer[1] > StochMax 
                                     && Ind.StochMainBuffer[0] < Ind.StochSignalBuffer[0]     // cruzamento do estocastico na direção desejada
                                     && Ind.StochMainBuffer[0] < Ind.StochMainBuffer[1]  
                                     // analisa se entra estopando   
                                     && !((Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[5]) > BumpStopLossShort) 
                                     && !((Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[6]) > BumpStopLossShort) ); 
                                                                                                                                                                                                                                                                                 
   if(   Signals.SellCondition1_STOCH2 
      && !Signals.STOCH2_bool1_sell   )
     {
      Global.STOCH2_sell_delay_enter = TimeCurrent();
      Signals.STOCH2_bool1_sell = true;
      if(Strategy.Debug){
      Debug(" STOCH2_sell_delay_enter: "+Global.STOCH2_sell_delay_enter); }
     }  
     
   if(   Signals.SellCondition1_STOCH2 
      && Signals.STOCH2_bool1_sell    )
     {
      Global.STOCH2_sell_delay_exit = TimeCurrent();
      if( (long)Global.STOCH2_sell_delay_exit >= ((long)Global.STOCH2_sell_delay_enter + STOCH2_Sell_Delay) )
        {
         Signals.SellCondition2_STOCH2 = true;
         if(Strategy.Debug){
         Debug(" STOCH2_sell_delay_exit: "+Global.STOCH2_sell_delay_exit); }
        }
      else return; 
     }
   else
     {
      Signals.STOCH2_bool1_sell = false;
     }     
                                                                       
   if(   Signals.SellCondition1_STOCH2 
      && Signals.SellCondition2_STOCH2 )   
     { 
/*            
      // verifica se o stop na media de 50 será instantaneo
      if(Strategy.Habilitar_MA_Control)
        {
         if(    Global_Get("MA_mode_50") && Support_200_50()
            || (   Global.price_trade_start < Ind.MA50_Buffer[1]
                && mrate[1].close >= Ind.MA50_Buffer[1]
                && mrate[2].close >= Ind.MA50_Buffer[2] )       )
           {
            Signals.STOCH2_Once = true; 
            if(Strategy.Debug){
            Debug(" STOCH2_Once por entrada com stop instantaneo: "+Signals.STOCH2_Once); }
            return;
           }  
        } 
*/                                    
      OpenShortPosition(); 
      if(Signals.ShortPosition == true)
        {
         if(Strategy.Debug){
         Debug(" Ordem de venda STOCH2: "); }
           {
            Signals.TradeSignal_STOCH2 = true;     
            Signals.SellCondition2_STOCH2 = false;
            Signals.STOCH2_bool1_sell = false;  
            // Operações STOCH2 apenas uma vez ao dia 
            if(Strategy.Habilitar_STOCH2_Once)     
              {
               Signals.STOCH2_Once = true;
               if(Strategy.Debug){
               Debug(" STOCH2_Once: "+Signals.STOCH2_Once); } 
              }
               
            if(volatilidade > Volat_STOCH2 - 0.05)
              {
               Signals.Vol = true;
              }       
            else
              {
               Signals.Vol = false;
              } 
            return;  
           }
        }   
      else
        {
         Alert(" Falhou a Tentativa de Entrada!!!");
         Debug_Alert(" Falhou a Tentativa de Entrada!!!");
         return;
        }     
                              
     }
     
  }    // fim da STOCH2()
   
void STOCH2_SL_SG()
  {
   Buffers();
   // largura das bandas dada em percentagem de reta evolução    
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
            Debug(" Fechamento de operação de compra STOCH_2 por zona de resistencia_200_50 "); } 
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
         Debug(" Fechamento de operação de compra STOCH_2 por 2 nasty candles "); } 
         return;          
        }  
             
      // saída por MA_Control Oscillation
      if(   Strategy.Habilitar_MA_Oscillation
         && Strategy.Habilitar_MA_Control
         && MA_Oscillation_Long()              )
        {    
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra por Oscillation "); } 
         return;          
        }  
    
      // stop gain long STOCH2 apos verificar o estocastico descendente acima do limite superior
      if(   Ind.StochSignalBuffer[0] > StochMax  
         && (   (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[1]) < BumpStopGainLong 
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[2]) < BumpStopGainLong
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[3]) < BumpStopGainLong 
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[4]) < BumpStopGainLong
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[5]) < BumpStopGainLong 
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[6]) < BumpStopGainLong ) )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop Gain BUMP de operação STOCH2 long: "); }
         return;
        }

      // saida stop loss long apos uma descendencia do estocastico q rompe o limite inferior 
      if(   (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[1]) < BumpStopLossLong 
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[2]) < BumpStopLossLong
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[3]) < BumpStopLossLong 
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[4]) < BumpStopLossLong
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[5]) < BumpStopLossLong 
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[6]) < BumpStopLossLong )
        {
         if(   Ind.StochSignalBuffer[0] < StochMin
            || Ind.StochMainBuffer[0] < StochMin )
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Stop Loss de operação STOCH2 long: "); }        
            return;
           }
        }
/*        
      // saida devido a largura das bandas estarem acima do limite de volatilidade permitido   
      if(volatilidade > Volat_STOCH2 && !Signals.Vol)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação STOCH2 long por Volatilidade: "+volatilidade); }
         return;
        }   
*/      
      // saida por CandleStick
      if(Strategy.Habilitar_CS_Control)
        {    
         if(Shooting_Star())
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra STOCH_2 por Shooting_Star ");}
            return;
           }            
         if(Candle_Math_Top())
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra STOCH_2 por Candle_Math_Top ");}
            return;
           } 
        }   
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação STOCH2 long por TIME "); }     
         return;
        }
              
     }  // fim saidas long
     
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
            Debug(" Fechamento de operação de venda STOCH_2 por zona de suporte_200_50 "); } 
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
         Debug(" Fechamento de operação de venda STOCH_2 por 2 nasty candles "); } 
         return;          
        } 
              
      // saída por MA_Control Oscillation
      if(   Strategy.Habilitar_MA_Oscillation
         && Strategy.Habilitar_MA_Control
         && MA_Oscillation_Short()              )
        {    
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda por Oscillation "); } 
         return;          
        }     

      // stop gain short STOCH2 apos verificar o estocastico ascendente abaixo do limite inferior
      if(   Ind.StochSignalBuffer[0] < StochMin
         && (   (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[1]) > BumpStopGainShort 
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[2]) > BumpStopGainShort
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[3]) > BumpStopGainShort 
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[4]) > BumpStopGainShort
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[5]) > BumpStopGainShort 
             || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[6]) > BumpStopGainShort ) )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop Gain BUMP de operação STOCH2 short: "); }      
         return;
        }
      
      // saida stop loss short apos uma ascendencia do estocastico q rompe o limite superior
      if(   (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[1]) > BumpStopLossShort 
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[2]) > BumpStopLossShort
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[3]) > BumpStopLossShort 
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[4]) > BumpStopLossShort
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[5]) > BumpStopLossShort 
         || (Ind.StochSignalBuffer[0] - Ind.StochSignalBuffer[6]) > BumpStopLossShort )
        {
         if(   Ind.StochSignalBuffer[0] > StochMax
            || Ind.StochMainBuffer[0] > StochMax   )
           {
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Stop Loss de operação STOCH2 short: "); }     
            return;
           }
        }
/*        
      // saida devido a largura das bandas estarem acima do limite de volatilidade permitido   
      if(volatilidade > Volat_STOCH2 && !Signals.Vol)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação STOCH2 short por Volatilidade: "+volatilidade); }
         return;
        }   
*/      
      // saida por CandleStick
      if(Strategy.Habilitar_CS_Control)
        {    
         if(Hammer())
           {
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de venda STOCH_2 por Hammer ");}
            return;
           }            
         if(Candle_Math_Bottom())
           {
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de venda STOCH_2 por Candle_Math_Bottom ");}
            return;
           } 
        }   
        
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação STOCH2 short por TIME "); }            
         return;
        } 
          
     } // fim saidas short
     
  }  // fim da STOCH2_SL_SG()


//+------------------------------------------------------------------+