//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| SQUEEZE strategy                                                 |
//+------------------------------------------------------------------+
void Estrategia_SQUEEZE()
  {
   // Verificação das condições de negociação da estratégia SQUEEZE    
   if(   (!PositionSelect(Ativo) && !Global_Get("SQUEEZE_Once")) )
     {
      // verifica horários não permitidos para entrada de operação
      if(   (str1.hour == TradeStartHour && str1.min <= TradeStartMin)
         || (str1.hour >= BlockTradeStartHour && str1.min >= BlockTradeStartMin)
         || (str1.hour == 18 && str1.min >= 00))
        {
         return;    // sai da função e prossegue no mesmo tick
        }
      else  // horário permitido
        {
         SQUEEZE();  
        }       
     }
   else
     {
      if(Global_Get("TradeSignal_SQUEEZE"))
        {
         SQUEEZE_SL_SG();
        }
     }
  }
  
  
void SQUEEZE()
  { 
   Buffers();  // Aloca os buffers dos indicadores
   // Verifica se há uma descendencia da volatilidade para entrar no SQUEEZE_mode 
   if( 
         Ind.BBandwidth_Buffer[1] > Ind.BBandwidth_Buffer[2]
      && Ind.BBandwidth_Buffer[2] < Ind.BBandwidth_Buffer[3]
      && Ind.BBandwidth_Buffer[3] < Ind.BBandwidth_Buffer[4]
      && Ind.BBandwidth_Buffer[4] < Ind.BBandwidth_Buffer[5]
      && Ind.BBandwidth_Buffer[5] < Ind.BBandwidth_Buffer[6]
      && Ind.BBandwidth_Buffer[6] < Ind.BBandwidth_Buffer[7]
      && Ind.BBandwidth_Buffer[7] < Ind.BBandwidth_Buffer[8]
      
//      && Ind.BBandwidth_Buffer[8] < Ind.BBandwidth_Buffer[9]
//      && Ind.BBandwidth_Buffer[9] < Ind.BBandwidth_Buffer[10]
                                                              ) 
     {
      if(Strategy.Debug && !Global_Get("SQUEEZE_mode")  )
        {
         Debug(" SQUEEZE_mode =  "+!Global_Get("SQUEEZE_mode")); 
         Debug(" Volatilidade: "+Ind.BBandwidth_Buffer[0]);     
        }
      Global_Set("SQUEEZE_mode",TRUE); 
     }
     // Verifica se está no SQUEEZE_mode e se a volat esta crescente
      if(   
            Global_Get("SQUEEZE_mode") 
         && Ind.BBandwidth_Buffer[0] > Ind.BBandwidth_Buffer[1]   
         && Ind.BBandwidth_Buffer[1] > Ind.BBandwidth_Buffer[2]  
         && Ind.BBandwidth_Buffer[2] > Ind.BBandwidth_Buffer[3]         
//         && Ind.BBandwidth_Buffer[3] > Ind.BBandwidth_Buffer[4]
                                                                 )
        {
         // Condições de abertura long
         if(   
              mrate[1].close > Ind.BBUp2[1]                       // fechamento acima da sigma 2                  
//            && mrate[0].close < (Ind.BBUp2[0] + Band_Jump_Long)  // calibragem do Band Jump
                                                                  )  
           {
            OpenLongPosition_SQ();       
           }
         // Condição de abertura short 
         if(   
              mrate[1].close < Ind.BBLow2[1]                         // fechamento abaixo da sigma 2 
//            && mrate[0].close > (Ind.BBLow2[0] - Band_Jump_Short)  // calibragem do Band Jump
                                                                    )  
           {
            OpenShortPosition_SQ();     
           }     
        
        } 

  } // fim da SQUEEZE
  
  
void SQUEEZE_SL_SG()
  {
   Buffers();
   double price = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
   // saidas long
   if(Signals.LongPosition)
     { 
/*     
      // saida por CandleStick
      if(Strategy.Habilitar_CS_Control)
        {
        
         if(   str1.hour >= 11
            && 
               (   Shooting_Star()  
                || Bearish_Engulfing() 
                || Dark_Cloud_Cover() )
                                         )
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra SQUEEZE por padrao de candle ");}
            return;
           }
*/            
/*           
         if(Candle_Math_Top())
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra SQUEEZE por Candle_Math_Top ");}
            return;
           }  
*/            
//        }   // fim da saida por CandleStick
      
    
      // saida por Breakeven
      if(Strategy.Habilitar_Breakeven)
        {
         double BE_exit;
         BE_exit = ( MathPow(Ind.BBandwidth_Buffer[0],BE_factor_exit) * Breakeven_exit * pip);
         // analisa se a trade entra no modo Breakeven
         if(Breakeven_Long() && !Global_Get("Breakeven_mode"))
           {
            Global_Set("Breakeven_mode",TRUE);
            if(Strategy.Debug){
            Debug(" Breakeven_mode: "+!!Global_Get("Breakeven_mode"));}
            
            CloseLongPosition();
            return;
            
           }
           
           
/*           
         // saida por Breakeven
         if(   Global_Get("Breakeven_mode") 
            && mrate[0].close <= (Global.price_trade_start + BE_exit) )
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra SQUEEZE por Breakeven ");
            Debug(" BE_exit: "+BE_exit);}
            
            return;      
           }  
*/           
           
         }  // fim da saida por Breakeven        
       

      // saida por sigma 1
      if(   
            mrate[0].close < Ind.BBUp[0]/2
//         || mrate[0].close < Ind.BBUp[1] - (Ind.BBUp[1] - Ind.BBMid[1])/3 
                                                                          )
        {
         CloseLongPosition();
         Signals.Head_Allowed = true;
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE por sigma 1 ");
         Debug(" Signals.Head_Allowed = "+Signals.Head_Allowed);}
         
         return;      
        }       
           
      // saida por Band Jump
      if(
//         price >= Ind.BBUp2[0] + (Band_Jump_Long * pip / MathPow(Ind.BBandwidth_Buffer[0],BJ_factor)) 
         price >= Ind.BBUp_n[0] 
                                                                                                      )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE por Band Jump ");
         Debug(" Preço acima da banda: "+(Band_Jump_Long * pip / MathPow(Ind.BBandwidth_Buffer[0],BJ_factor)));}
         
         return;      
        }   
       
      // saida por volatilidade  
      if(   Ind.BBandwidth_Buffer[1] < Ind.BBandwidth_Buffer[2]
         && Ind.BBandwidth_Buffer[2] < Ind.BBandwidth_Buffer[3] )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE por volatilidade decrescente ");}
         return;      
        }  
          
/*                  
      // saida por volatilidade  
      if(Ind.BBandwidth_Buffer[1] >= Max_Width)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE por volatilidade maxima permitida ");
         Debug(" Volatilidade: "+Ind.BBandwidth_Buffer[0]);                    }
         
         return;      
        }  
*/              
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação SQUEEZE long por TIME "); }
                    
         return;
        }       
     } // fim saidas long
     
   // saidas short  
   if(Signals.ShortPosition)
     {
/*     
      // saida por CandleStick
      if(Strategy.Habilitar_CS_Control)
        {
        
         if(   str1.hour >= 11
            && 
               (   Hammer()
                || Bullish_Engulfing()
                || Piercing_Pattern() )
                                        )
           {
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de venda SQUEEZE por padrao de candle ");}
            return;
           } 
         } 
*/          
     
      // saida por Breakeven short
      if(Strategy.Habilitar_Breakeven)
        {
         double BE_exit;
         BE_exit = ( MathPow(Ind.BBandwidth_Buffer[0],BE_factor_exit) * Breakeven_exit * pip);
         // analisa se a trade entra no modo Breakeven
         if(Breakeven_Short() && !Global_Get("Breakeven_mode"))
           {
            Global_Set("Breakeven_mode",TRUE);
            if(Strategy.Debug){
            Debug(" Breakeven_mode: "+!!Global_Get("Breakeven_mode"));}
            
            CloseShortPosition();
            return;
           }
           
           
/*           
         // saida por Breakeven
         if(   Global_Get("Breakeven_mode") 
            && mrate[0].close >= (Global.price_trade_start - BE_exit) )
           {
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de venda SQUEEZE por Breakeven ");
            Debug(" BE_exit: "+BE_exit);}
            
            return;      
           }  
*/           
           
         }  // fim da saida por Breakeven short  


      // saida por sigma 1
      if(  
            mrate[0].close > Ind.BBLow[0]/2
//         || mrate[0].close > Ind.BBLow[1] + (Ind.BBMid[1] - Ind.BBLow[1])/3 
                                                                            )
        {
         CloseShortPosition();
         Signals.Head_Allowed = true;
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE por sigma 1 ");
         Debug(" Signals.Head_Allowed = "+Signals.Head_Allowed);}
         
         return;      
        }        
        
      // saida por Band Jump
      if(
//         price <= Ind.BBLow2[0] - (Band_Jump_Short * pip / MathPow(Ind.BBandwidth_Buffer[0],BJ_factor) )
         price <= Ind.BBLow_n[0]
                                                                                                        )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE por Band Jump ");
         Debug(" Preço abaixo da banda: "+(Band_Jump_Short * pip / MathPow(Ind.BBandwidth_Buffer[0],BJ_factor)) );}
         
         return;      
        }
         
      // saida por volatilidade  
      if(   Ind.BBandwidth_Buffer[1] < Ind.BBandwidth_Buffer[2]
         && Ind.BBandwidth_Buffer[2] < Ind.BBandwidth_Buffer[3] )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE por volatilidade decrescente ");}
         return;      
        }
        
/*                  
      // saida por volatilidade  
      if(Ind.BBandwidth_Buffer[1] >= Max_Width)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE por volatilidade maxima permitida ");
         Debug(" Volatilidade: "+Ind.BBandwidth_Buffer[0]);                   }
         
         return;      
        }
*/                
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação SQUEEZE short por TIME "); }
                    
         return;
        }      
        
     }  // fim saidas short  
     
  }  // fim da SQUEEZE_SL_SG    
  
  
  
  
void OpenShortPosition_SQ()   
  {
   OpenShortPosition();
   Global_Set("TradeSignal_SQUEEZE",TRUE);
   Global_Set("SQUEEZE_mode",FALSE);
   Global_Set("SQUEEZE_short",TRUE);
   if(Strategy.Debug){
   Debug(" Abertura de operação de venda SQUEEZE ");
   Debug(" Volatilidade: "+Ind.BBandwidth_Buffer[0]);}
   if(Strategy.Habilitar_SQUEEZE_Once)     
     {
      Global_Set("SQUEEZE_Once",TRUE);
      Global.delay_SQUEEZE_HEAD = ((long)Global.initialize_unixtime + 15*(900)); // 8 candles de 15m
      if(Strategy.Debug){
      Debug(" SQUEEZE_Once: "+(bool)Global_Get("SQUEEZE_Once")); } 
     }
   return;         
  } 
  
void OpenLongPosition_SQ()
  {
   OpenLongPosition();
   Global_Set("TradeSignal_SQUEEZE",TRUE);
   Global_Set("SQUEEZE_mode",FALSE);
   Global_Set("SQUEEZE_long",TRUE);
   if(Strategy.Debug){
   Debug(" Abertura de operação de compra SQUEEZE ");
   Debug(" Volatilidade: "+Ind.BBandwidth_Buffer[0]);}
   if(Strategy.Habilitar_SQUEEZE_Once)     
     {
      Global_Set("SQUEEZE_Once",TRUE);
      Global.delay_SQUEEZE_HEAD = ((long)Global.initialize_unixtime + 15*(900)); // 8 candles de 15m
      if(Strategy.Debug){
      Debug(" SQUEEZE_Once: "+(bool)Global_Get("SQUEEZE_Once")); } 
     }
   return;  
  }  
  
// informações sobre a volatilidade recente (8 dias) 
void Volat_Info()
  {  
   if(   
         str1.hour == 9 && str1.min == 14 && str1.sec == 0
                                                            )
     { 
      Buffers();
      if( CopyBuffer(Ind.BBandwidth_Handle,0,0,300,Ind.BBandwidth_Buffer) < 0 )
        {
         Debug_Alert(" Error copying BBandwidth indicator Buffers - error: "+GetLastError() ); 
         ResetLastError(); return;
        }  

      Global.Volat_Media_Max[1] = (  Ind.BBandwidth_Buffer[ArrayMaximum(Ind.BBandwidth_Buffer,1,36)] 
                                   + Ind.BBandwidth_Buffer[ArrayMaximum(Ind.BBandwidth_Buffer,37,36)]
                                   + Ind.BBandwidth_Buffer[ArrayMaximum(Ind.BBandwidth_Buffer,73,36)] 
                                   + Ind.BBandwidth_Buffer[ArrayMaximum(Ind.BBandwidth_Buffer,109,36)]
                                   + Ind.BBandwidth_Buffer[ArrayMaximum(Ind.BBandwidth_Buffer,145,36)] 
                                   + Ind.BBandwidth_Buffer[ArrayMaximum(Ind.BBandwidth_Buffer,181,36)]
                                   + Ind.BBandwidth_Buffer[ArrayMaximum(Ind.BBandwidth_Buffer,217,36)] 
                                   + Ind.BBandwidth_Buffer[ArrayMaximum(Ind.BBandwidth_Buffer,253,36)])/8;
                      
      Global.Volat_Media_Min[1] = (  Ind.BBandwidth_Buffer[ArrayMinimum(Ind.BBandwidth_Buffer,1,36)] 
                                   + Ind.BBandwidth_Buffer[ArrayMinimum(Ind.BBandwidth_Buffer,37,36)]
                                   + Ind.BBandwidth_Buffer[ArrayMinimum(Ind.BBandwidth_Buffer,73,36)] 
                                   + Ind.BBandwidth_Buffer[ArrayMinimum(Ind.BBandwidth_Buffer,109,36)]
                                   + Ind.BBandwidth_Buffer[ArrayMinimum(Ind.BBandwidth_Buffer,145,36)] 
                                   + Ind.BBandwidth_Buffer[ArrayMinimum(Ind.BBandwidth_Buffer,181,36)]
                                   + Ind.BBandwidth_Buffer[ArrayMinimum(Ind.BBandwidth_Buffer,217,36)] 
                                   + Ind.BBandwidth_Buffer[ArrayMinimum(Ind.BBandwidth_Buffer,253,36)])/8;  
                         
      if(Strategy.Debug){
      Debug(" Volat_Media_Max: "+Global.Volat_Media_Max[1]+"    Volat_Media_Min: "+Global.Volat_Media_Min[1]); }
//      if(Strategy.Debug){
//      Debug(" ArrayMaximum(Ind.BBandwidth_Buffer,1,35): "+Ind.BBandwidth_Buffer[ArrayMaximum(Ind.BBandwidth_Buffer,1,35)]); }                                   
      
     }
  } 