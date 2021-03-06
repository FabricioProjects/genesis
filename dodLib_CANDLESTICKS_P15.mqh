//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| CANDLESTICKS_P15 strategy                                        |
//+------------------------------------------------------------------+
void Estrategia_CANDLESTICKS_P15()
  {
   // Verificação das condições de negociação da estratégia SQUEEZE    
   if(!PositionSelect(Ativo) && !Global_Get("CANDLESTICKS_P15_Once"))
     {
      // verifica horários não permitidos para entrada de operação
      if(  // (str1.hour == 9 || str1.hour == 10)  // cuidado!! dependente de otimização
            (
                str1.hour == 9 
             || str1.hour == 10 
//             || (str1.hour == 11  && str1.min < 30)    // 30M
           //  || str1.min < 30  || str1.min > 30
                                                               ) 
         || (str1.hour >= BlockTradeStartHour && str1.min >= BlockTradeStartMin)
         || (str1.hour == 18 && str1.min >= 00))
        {
         return;    // sai da função e prossegue no mesmo tick
        }
      else  // horário permitido
        {
         CANDLESTICKS_P15();  
        }       
     }
   else
     {
      if(Global_Get("TradeSignal_CANDLESTICKS_P15"))
        {
         CANDLESTICKS_P15_SL_SG();
        }
     }
  }
  
  
void CANDLESTICKS_P15()
{ 
 // aloca os buffers dos indicadores
// Buffers_CS();
 double price = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
 // nao opera na direção da GAP
 if(   Signals.GAP_High == false
    && Signals.low_candle_stop_once == false)    // entrada long uma vez ao dia
   {
/*        
//#######################################################################################     
//################ BOTTOM PATTERNS DE 1 CANDLE: entradas long ###########################
//#######################################################################################

   if(   
         Hammer()                                               // indicador oriental: hammer
//      || Inverted_Hammer()                                      // indicador oriental: inverted_hammer
//      && Long_Enter_CS()      
                              )
     {
      OpenLongPosition();
      mrate_buffers(); 
      if(str1.hour == 9 && str1.min == 15 && str1.sec == 00)    // evita q o stop esteja no dia anterior
        {
         Global.low_candle_stop = mrate[1].low;
        }
      if(mrate[1].low < mrate[2].low)    // stop no candle 1
        {
         Global.low_candle_stop = mrate[1].low;
        }  
      else Global.low_candle_stop = mrate[2].low;    
      Global_Set("TradeSignal_CANDLESTICKS_P15",TRUE);
      if(Strategy.Habilitar_CANDLESTICKS_P15_Once)
        {
         Global_Set("CANDLESTICKS_P15_Once",TRUE);
         if(Strategy.Debug){
         Debug(" CANDLESTICKS_P15_Once: "+(bool)Global_Get("CANDLESTICKS_P15_Once")); } 
        } 
      // contagem dos padroes
      if(Strategy.Simulation)
        {
         Pattern_Count_Enter();
        } 
       
      return;    
     } 
*/     
//#######################################################################################     
//################ BOTTOM PATTERNS DE 2 CANDLES: entradas long ##########################
//#######################################################################################
   
   if(   (   
             Bullish_Engulfing()             // indicador oriental: Bullish_Engulfing
//          || Piercing_Pattern()              // indicador oriental: Piercing_Pattern
//          || Harami_Bullish()                // indicador oriental: Harami_Bullish                      
                                  )                                      
//      && Long_Enter_CS()            
                                   )
     {
      OpenLongPosition();
      if(Signals.LongPosition == true)
        {
         mrate_buffers();
         
         if(mrate[1].low > mrate[2].low)             // condição para o Piercing Pattern
           {   
            Global.low_candle_stop = mrate[2].low;
           } 
         else Global.low_candle_stop = mrate[1].low;  
         Global_Set("TradeSignal_CANDLESTICKS_P15",TRUE);
         if(Strategy.Habilitar_CANDLESTICKS_P15_Once)
           {
            Global_Set("CANDLESTICKS_P15_Once",TRUE);
            if(Strategy.Debug){
            Debug(" CANDLESTICKS_P15_Once: "+(bool)Global_Get("CANDLESTICKS_P15_Once")); } 
           } 
         // contagem dos padroes
         if(Strategy.Simulation)
           {
            Pattern_Count_Enter();
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
/*     
//#######################################################################################     
//################ BOTTOM PATTERNS DE 4 CANDLES: entradas long ##########################
//#######################################################################################

   if(   
         Morning_Star()                                          // indicador oriental: Morning_Star
//      && Long_Enter_CS()  
                              ) 
     {
      OpenLongPosition();
      ArraySetAsSeries(mrate,true);
      if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)      
        {
         Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
         ResetLastError();
        } 
        
      Global.low_candle_stop = mrate[2].low; 
//      Signals.Morn_Even_star = true; 
      Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = true;              
      Global_Set("TradeSignal_CANDLESTICKS_P15",TRUE);
      
      if(Strategy.Habilitar_CANDLESTICKS_P15_Once)
        {
         Global_Set("CANDLESTICKS_P15_Once",TRUE);
         if(Strategy.Debug){
         Debug(" CANDLESTICKS_P15_Once: "+(bool)Global_Get("CANDLESTICKS_P15_Once")); } 
        }  
      // contagem dos padroes
      if(Strategy.Simulation)
        {
         Pattern_Count_Enter();
        } 
          
      return;    
     }  
*/     
   }  // fim da GAP_Control entradas long 
 
 // nao opera na direção da GAP  
 if(   Signals.GAP_Low == false
    && Signals.high_candle_stop_once == false )      // entrada short uma vez ao dia
   {               
/* 
//#######################################################################################     
//################### TOP PATTERNS DE 1 CANDLE: entradas short ##########################
//#######################################################################################

   if(   Shooting_Star()                                        // indicador oriental: Shooting star
//      || Hanging_Man()                                          // indicador oriental: Hanging Man
//      && Short_Enter_CS()
                           )
     {
      OpenShortPosition();
      mrate_buffers();
      if(   Strategy.CS_15M
         && str1.hour == 9 && str1.min == 15 && str1.sec == 00)  // evita q o stop esteja no dia anterior  
        {
         Global.high_candle_stop = mrate[1].high;
        }   
      if(   Strategy.CS_30M
         && str1.hour == 9 && str1.min == 30 && str1.sec == 00)  // evita q o stop esteja no dia anterior  
        {
         Global.high_candle_stop = mrate[1].high;
        }     
      if( mrate[1].high > mrate[2].high )  // stop no candle 1  
        {
         Global.high_candle_stop = mrate[1].high;
        }     
      else Global.high_candle_stop = mrate[2].high;
      Global_Set("TradeSignal_CANDLESTICKS_P15",TRUE);
      if(Strategy.Habilitar_CANDLESTICKS_P15_Once)
        {
         Global_Set("CANDLESTICKS_P15_Once",TRUE);
         if(Strategy.Debug){
         Debug(" CANDLESTICKS_P15_Once: "+(bool)Global_Get("CANDLESTICKS_P15_Once")); } 
        }  
      // contagem dos padroes
      if(Strategy.Simulation)
        {
         Pattern_Count_Enter();
        } 
          
      return;    
     } 
    
//#######################################################################################     
//################### TOP PATTERNS DE 2 CANDLES: entradas short #########################
//#######################################################################################      
    
   if(   (   
             Bearish_Engulfing()                  // indicador oriental: Bearish_Engulfing
          || Dark_Cloud_Cover()                   // indicador oriental: Dark_Cloud_Cover
          || Harami_Bearish()                     // indicador oriental: Harami_Bearish
                                 )                                  
//      && Short_Enter_CS()         
                                   )
     {
      OpenShortPosition();
      ArraySetAsSeries(mrate,true);                      
      if(CopyRates(Ativo,PERIOD_M15,0,3,mrate) < 0)      // aloca a maxima do candle diário
        {
         Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
         ResetLastError();
        }  
      if(mrate[1].high > mrate[2].high)
        {   
         Global.high_candle_stop = mrate[1].high;
        } 
      else Global.high_candle_stop = mrate[2].high;  
      Global_Set("TradeSignal_CANDLESTICKS_P15",TRUE);
      if(Strategy.Habilitar_CANDLESTICKS_P15_Once)
        {
         Global_Set("CANDLESTICKS_P15_Once",TRUE);
         if(Strategy.Debug){
         Debug(" CANDLESTICKS_P15_Once: "+(bool)Global_Get("CANDLESTICKS_P15_Once")); } 
        }    
      // contagem dos padroes
      if(Strategy.Simulation)
        {
         Pattern_Count_Enter();
        } 
          
      return;
     }    

//#######################################################################################     
//################### TOP PATTERNS DE 3 CANDLES: entradas short #########################
//#######################################################################################      
  
   if(   
         Evening_Star()                                         // indicador oriental: Evening_Star
//      && Short_Enter_CS()
                                 )
     {
      OpenShortPosition();
      ArraySetAsSeries(mrate,true);                      
      if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)      // aloca a maxima do candle diário
        {
         Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
         ResetLastError();
        }  
        
      Global.high_candle_stop = mrate[2].high; 
//      Signals.Morn_Even_star = true; 
      Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = true;   
      Global_Set("TradeSignal_CANDLESTICKS_P15",TRUE);
      
      if(Strategy.Habilitar_CANDLESTICKS_P15_Once)
        {
         Global_Set("CANDLESTICKS_P15_Once",TRUE);
         if(Strategy.Debug){
         Debug(" CANDLESTICKS_P15_Once: "+(bool)Global_Get("CANDLESTICKS_P15_Once")); } 
        }    
      // contagem dos padroes
      if(Strategy.Simulation)
        {
         Pattern_Count_Enter();
        } 
          
      return;
     } 
*/     
   }  // fim da GAP_Control entradas short              

 } // fim da CANDLESTICKS_P15
    
  
void CANDLESTICKS_P15_SL_SG()
  {
   // aloca os buffers dos indicadores
   ArraySetAsSeries(mrate,true);  
   if(CopyRates(Ativo,PERIOD_M15,0,5,mrate) < 0)      // aloca a maxima do candle diário
        {
         Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
         ResetLastError();
        }  
   Buffers_CS();
   double price = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
   // saidas long
   if(Signals.LongPosition)
     {  
/*     
      // saida de momento morning star
      if(   Signals.Morn_Even_star == true
         && (long)TimeCurrent() > ((long)Global.initialize_unixtime + 901) 
         && mrate[1].close < mrate[3].open
                                                                             )
        {
         CloseLongPosition();
         Global.low_candle_stop = 0;
         Signals.Morn_Even_star = false;
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
//         Signals.low_candle_stop_once = true;
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 long por Morn_Even_star "); }         
         return;
        } 
*/  
/*    
      // saida de momento trailling
      if(   
            (   
//                Signals.hammer == true
//             || Signals.Inverted_Hammer == true
//             || Signals.Bullish_Engulfing == true
//             || Signals.Piercing_Pattern == true
//             || Signals.Harami_Bullish == true
//              Signals.Morning_Star == true
                                                   )
         && (long)TimeCurrent() > ((long)Global.initialize_unixtime + 901) 
         && mrate[1].close < mrate[3].open
                                                                              )
        {
         CloseLongPosition();
         Global.low_candle_stop = 0;
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
//         Signals.low_candle_stop_once = true;
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 long por Piercing_Pattern "); }         
         return;
        } 
*/           
      // saida pela minima do padrao de candle +- algumas pips
      if(price <= (Global.low_candle_stop + 2*pip))
        {
         CloseLongPosition();
         Global.low_candle_stop = 0;
         Signals.low_candle_stop_once = true;
//         Signals.high_candle_stop_once = true;
         Signals.Morn_Even_star = false;
         if(Strategy.Simulation)
           {
            Pattern_SL();
           } 
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 long por low_candle_stop "); }         
         return;
        }  
/*        
      // saida por padroes de candle top 
      if(  // Doji_Top()
            Shooting_Star()                                     // indicador oriental: Shooting star   
//          || Hanging_Man()                                          // indicador oriental: Hanging Man
         || Bearish_Engulfing()      // indicador oriental: Bearish_Engulfing
         || Dark_Cloud_Cover()       // indicador oriental: Dark_Cloud_Cover
//         || Harami_Bearish()         // indicador oriental: Harami_Bearish                               
         || Evening_Star()                                     // indicador oriental: Evening_Star
                                     )                    
        {
         CloseLongPosition();
         Signals.Morn_Even_star = false;
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
         if(Strategy.Simulation)
           {
            Pattern_Exit_Long();
           } 
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 long por padroes de candle top "); }
        } 
*/              
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseLongPosition();
         Signals.Morn_Even_star = false;
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
         if(Strategy.Simulation)
           {
            Pattern_Time_Exit();
           } 
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 long por TIME "); }
                    
         return;
        }       
     } // fim saidas long
     
   // saidas short  
   if(Signals.ShortPosition)
     {
/*     
      // saida de momento evening star
      if(   Signals.Morn_Even_star == true
         && (long)TimeCurrent() > ((long)Global.initialize_unixtime + 901)
         && mrate[1].close > mrate[3].open
                                                                               )
        {
         CloseShortPosition();
         Global.high_candle_stop = 0;
         Signals.Morn_Even_star = false;
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
//         Signals.high_candle_stop_once = true;
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 short por Morn_Even_star "); }         
         return;
        } 
*/   
/*             
      // saida de momento trailling
      if(   
            (
//                Signals.Shooting_Star == true
//             || Signals.Hanging_Man == true
//             || Signals.Bearish_Engulfing == true
//             || Signals.Dark_Cloud_Cover == true
//             || Signals.Harami_Bearish == true
             Signals.Evening_Star == true
                                                   )
         && (long)TimeCurrent() > ((long)Global.initialize_unixtime + 901)
         && mrate[1].close > mrate[3].open 
                                                                            )
        {
         CloseShortPosition();
         Global.high_candle_stop = 0;
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
//         Signals.high_candle_stop_once = true;
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 short por Dark_Cloud_Cover "); }         
         return;
        }   
*/       
      // saida pela maxima dos padroes de candle +- algumas pips
      if(price >= (Global.high_candle_stop - 2*pip))
        {
         CloseShortPosition();
         Global.high_candle_stop = 0;
         Signals.high_candle_stop_once = true;
//         Signals.low_candle_stop_once = true;
         Signals.Morn_Even_star = false;
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
         if(Strategy.Simulation)
           {
            Pattern_SL();
           } 
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 short por high_candle_stop "); }         
         return;
        }  
/*         
      // saida por padroes de candle bottom 
      if(   
            Hammer()                                         // indicador oriental: hammer
//         || Inverted_Hammer()                                   // indicador oriental: inverted_hammer
//         || Harami_Bullish_Exit()
         || Bullish_Engulfing()        // indicador oriental: Bullish_Engulfing
         || Piercing_Pattern()         // indicador oriental: Piercing_Pattern
//         || Harami_Bullish()           // indicador oriental: Harami_Bullish                           
         || Morning_Star()                                  // indicador oriental: Morning_Star
                                    )
        {
         CloseShortPosition();
         Signals.Morn_Even_star = false;
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
         if(Strategy.Simulation)
           {
            Pattern_Exit_Short();
           } 
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 short por padroes de candle bottom "); }
        }  
*/              
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseShortPosition();
         Signals.Morn_Even_star = false;
         Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
         if(Strategy.Simulation)
           {
            Pattern_Time_Exit();
           } 
         if(Strategy.Debug){
         Debug(" Stop de operação CANDLESTICKS_P15 short por TIME "); }
                    
         return;
        }      
        
     }  // fim saidas short  
     
  }  // fim da CANDLESTICKS_P15_SL_SG()    
  
  
  
  
