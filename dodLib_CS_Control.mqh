//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//############################################################################################################# 
//###################################### ALOCA MRATE BUFFERS ################################################## 
//############################################################################################################# 
void mrate_buffers()
  {
   // aloca os candles para 15M
   if( Strategy.CS_15M == true )
     {
      ArraySetAsSeries(mrate,true);
      if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)      
        {
         Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
         ResetLastError();
        }  
     } 
   // aloca os candles para 30M
   if( Strategy.CS_30M == true )
     {
      ArraySetAsSeries(mrate,true);
      if(CopyRates(Ativo,PERIOD_M30,0,4,mrate) < 0)      
        {
         Debug_Alert(" Error copying PERIOD_M30 rates - error: "+GetLastError()); 
         ResetLastError();
        }  
     } 
  }      

//############################################################################################################# 
//########################################## TOP PATTERNS ##################################################### 
//############################################################################################################# 

//+------------------------------------------------------------------+
//| DOJI TOP                                                         |
//+------------------------------------------------------------------+  
bool Doji_Top()
  {
   double shadow_up, shadow_down, body;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   double unixtime_inicio_dia = (long)mrate[0].time;
   if(CopyRates(Ativo,PERIOD_M15,0,3,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double trading_range = (mrate[1].high - mrate[1].low);
   
   // doji
   if(   mrate[1].high >= max_day               // maxima do dia   
      && (   mrate[1].open == mrate[1].close
          || mrate[1].open == (mrate[1].close + 1*pip) 
          || mrate[1].open == (mrate[1].close - 1*pip) ) )  
     {
      shadow_up = (mrate[1].high - mrate[1].close);
      shadow_down = (mrate[1].open - mrate[1].low);
      if(Strategy.Debug){
      Debug(" Doji Top "); } 
      return true;
      }
   return false;
   
  }  // fim da Doji_Top()

//+------------------------------------------------------------------+
//| SHOOTING STAR                                                    |
//+------------------------------------------------------------------+  
bool Shooting_Star()
  {
   double shadow_up, shadow_down, body;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   double unixtime_inicio_dia = (long)mrate[0].time;
   
   mrate_buffers();
   // desconsidera quando o periodo nao é especificado
   if(   Strategy.CS_15M == false
      && Strategy.CS_30M == false )
     {
      return false;
     }     
   
   double trading_range = (mrate[2].high - mrate[2].low);
   // candle de baixa
   if(mrate[2].open > mrate[2].close)  
     {
      shadow_up = (mrate[2].high - mrate[2].open);
      shadow_down = (mrate[2].close - mrate[2].low);
      body = (mrate[2].open - mrate[2].close);
     } 
   // candle de alta  
   if(mrate[2].open < mrate[2].close)  
     {
//      return false;   // não aceita candle de alta em Shooting Stars
      shadow_up = (mrate[2].high - mrate[2].close);
      shadow_down = (mrate[2].open - mrate[2].low);
      body = (mrate[2].close - mrate[2].open);
     }   
   // doji
   if(mrate[2].open == mrate[2].close)  
     {
      shadow_up = (mrate[2].high - mrate[2].close);
      shadow_down = (mrate[2].open - mrate[2].low);
      body = 0;
     }     
   // condições shooting star
   if(   
         mrate[2].high >= (max_day - 0*pip)              // maxima do dia
//      && (long)mrate[2].time > unixtime_inicio_dia     // opção para nao olhar para candles do dia anterior
      && mrate[1].open > mrate[1].close                  // confirmação: candle 2 de baixa
//      && (mrate[1].open - mrate[1].close) > 5*pip
      && shadow_up >= (2*body)                           // sombra pelo menos 2 vezes o corpo 
      && shadow_down <= (0.1*trading_range)              // sombra inferior a 10% do trading range
//      && mrate[3].open < mrate[3].close                // uptrend
                                             )            
      {
       if(Strategy.Debug){
       Debug(" Shooting Star "); } 
       return true;
      }
   return false;
   
  }  // fim da Shooting_Star()
  
//+------------------------------------------------------------------+
//| HANGING MAN                                                      |
//+------------------------------------------------------------------+  
bool Hanging_Man()
  {
   double shadow_up, shadow_down, body;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double trading_range = (mrate[2].high - mrate[2].low);
   // candle de baixa
   if(mrate[2].open > mrate[2].close)  
     {
      shadow_up = (mrate[2].high - mrate[2].open);
      shadow_down = (mrate[2].close - mrate[2].low);
      body = (mrate[2].open - mrate[2].close);
     } 
   // candle de alta  
   if(mrate[2].open < mrate[2].close)  
     {
//      return false;   // não aceita candle de alta em hanging man
      shadow_up = (mrate[2].high - mrate[2].close);
      shadow_down = (mrate[2].open - mrate[2].low);
      body = (mrate[2].close - mrate[2].open);
     }   
   // doji
   if(mrate[2].open == mrate[2].close)  
     {
      shadow_up = (mrate[2].high - mrate[2].close);
      shadow_down = (mrate[2].open - mrate[2].low);
      body = 5;
     }     
   // condições hanging man
   if(   
         (   mrate[2].high == max_day               // maxima do dia
          || mrate[1].high == max_day 
          || mrate[3].high == max_day 
                                      )                  
      && shadow_down >= (2*body)                    // sombra inferior maior q o corpo 
      && shadow_up < (0.1*trading_range)            // sombra superior 5% a 10% do trading range 
      && mrate[1].open > (mrate[1].close + 2*pip)   // confirmação: candle 2 de baixa
                                                  )    
      {
       if(Strategy.Debug){
       Debug(" Hanging Man "); }
       return true;
      }
   return false;
   
  }  // fim da Hanging_Man()    
  
//+------------------------------------------------------------------+
//| BEARISH ENGULFING                                                |
//+------------------------------------------------------------------+   
bool Bearish_Engulfing()
  {
   double body_1, body_2, trading_range_1, trading_range_2, shadow_up_2, shadow_down_2;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,5,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     } 
   trading_range_1 = (mrate[2].high - mrate[2].low);  // tamanho do candle 1 como um todo
   trading_range_2 = (mrate[1].high - mrate[1].low);  // tamanho do candle 2 como um todo    
   // candle 2 de baixa
   if(mrate[1].open > mrate[1].close)  
     {
      body_2 = (mrate[1].open - mrate[1].close);
      shadow_up_2 = (mrate[1].high - mrate[1].open);
      shadow_down_2 = (mrate[1].close - mrate[1].low);
     } 
   // candle 1 de alta  
   if(mrate[2].open < mrate[2].close)  
     {
      body_1 = (mrate[2].close - mrate[2].open);
     }   
   // doji
   if(   mrate[2].open == mrate[2].close
      || mrate[2].open == mrate[2].close + 1*pip
      || mrate[2].open == mrate[2].close - 1*pip )  
     {
      body_1 = 0;
     }         
   // condições Bearish_Engulfing
   if(   
         mrate[1].high == max_day                               // maxima do dia
      && trading_range_2 > trading_range_1                      // o candle de engolfo precisa ter um range maior
      && mrate[1].high > mrate[2].high                          // sombra superior do candle 2 é maior
      && mrate[1].open > mrate[1].close                         // candle 2 de baixa
      && mrate[2].open < mrate[2].close                         // candle 1 de alta  
//      && body_2 >= 10*pip
      && mrate[2].close >= mrate[3].open                        // uptrend
//      &&(shadow_up_2 <= body_2 && shadow_down_2 <= body_2)            // nenhuma das sombras pode ser maior q o corpo de engolfo
      && mrate[1].open >= (mrate[2].close - 1*pip)              // correção de anomalias: 1 pip
      && (body_2 > body_1 && mrate[1].close <= mrate[2].open)   // Engulfing 
//      && mrate[1].open > Global.ORmax
                                                              )    
      {
       if(Strategy.Debug){
       Debug(" Bearish Engulfing "); } 
       return true;
      }
   return false;
   
  }  // fim da Bearish_Engulfing()  
  
//+------------------------------------------------------------------+
//| DARK CLOUD COVER                                                 |
//+------------------------------------------------------------------+   
bool Dark_Cloud_Cover()
  {
   double shadow_up_1, shadow_down_1, body_1, body_2;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,3,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   // candle 2 de baixa
   if(mrate[1].open > mrate[1].close)  
     {
      body_2 = (mrate[1].open - mrate[1].close);
     } 
   // candle 1 de alta  
   if(mrate[2].open < mrate[2].close)  
     {
      body_1 = (mrate[2].close - mrate[2].open);
      shadow_up_1 = (mrate[2].high - mrate[2].close);
      shadow_down_1 = (mrate[2].open - mrate[2].low);
     }   
   // doji
   if(   mrate[2].open == mrate[2].close + 1*pip
      || mrate[2].open == mrate[2].close - 1*pip
      || mrate[2].open == mrate[2].close          )  
     {
      return false;
     }     
   // condições Dark_Cloud_Cover
   if(  (   
            mrate[1].high == max_day         // maxima do dia
//         || mrate[2].high == max_day
                                         )  
      && mrate[2].open < mrate[1].low                           // sombra inferior do candle 2 nao ultrapassa o open do candle 1
      && mrate[1].open > mrate[1].close                         // candle 2 de baixa
      && mrate[2].open < mrate[2].close                         // candle 1 de alta
      && mrate[1].open >= (mrate[2].close - pip)                // candle 2 abre com gap ou mantem o preço
//      && (body_1 > shadow_down_1)              // big candle 1 com sombras curtas
      && mrate[1].close > mrate[2].open                         // não engolfa todo o candle
      && mrate[1].close < (mrate[2].close - body_1/2)            // half cover 
//      && mrate[0].low <= mrate[2].open                          // confirmação dinamica 
                                                         )           
      {
       if(Strategy.Debug){
       Debug(" Dark Cloud Cover "); } 
       return true;
      }
   return false;
   
  }  // fim da Dark_Cloud_Cover()    
  
//+------------------------------------------------------------------+
//| HARAMI BEARISH                                                   |
//+------------------------------------------------------------------+   
bool Harami_Bearish()
  {
//   double body_1, body_2;
   Buffers_CS();
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   // condições Harami_Bearish
   if(  (   
            mrate[1].high == max_day            // maxima do dia
         || mrate[2].high == max_day
                                        )  
      && Ind_CS.Volume_Buffer_CS[0] > Ind_CS.Volume_Buffer_CS[1]                                    
//      && mrate[2].open < mrate[1].low                           // sombra inferior do candle 2 nao ultrapassa o open do candle 1
      && mrate[1].open > mrate[1].close                           // candle 2 de baixa
      && mrate[2].open < mrate[2].close                           // candle 1 de alta
      && mrate[1].open <= mrate[2].close                          // candle 2 abre com gap ou mantem o preço
      && mrate[1].close > mrate[2].open                           // não engolfa todo o candle  
      && mrate[0].low <= mrate[2].open    )                       // confirmação dinamica
      {
       if(Strategy.Debug){
       Debug(" Harami Bearish "); } 
       return true;
      }
   return false;
   
  }  // fim da Harami_Bearish()    
  
//+------------------------------------------------------------------+
//| 2 CANDLEMATH TOP                                                 |
//+------------------------------------------------------------------+  
bool Candle_Math_Top()
  {
   double shadow_up, shadow_down, body;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)    // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                 // maxima do dia até o momento
   if(CopyRates(Ativo,PERIOD_M30,0,2,mrate) < 0)
     {
      Debug_Alert(" Error copying PERIOD_M30 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double trading_range = (mrate[1].high - mrate[1].low);
   // candle de baixa
   if(mrate[1].open > mrate[1].close)  
     {
      shadow_up = (mrate[1].high - mrate[1].open);
      shadow_down = (mrate[1].close - mrate[1].low);
      body = (mrate[1].open - mrate[1].close);
     } 
   // candle de alta  
   if(mrate[1].open < mrate[1].close)  
     {
      return false;   // não aceita candle de alta em Shooting Stars
      shadow_up = (mrate[1].high - mrate[1].close);
      shadow_down = (mrate[1].open - mrate[1].low);
      body = (mrate[1].close - mrate[1].open);
     }   
   // doji
   if(mrate[1].open == mrate[1].close)  
     {
      shadow_up = (mrate[1].high - mrate[1].close);
      shadow_down = (mrate[1].open - mrate[1].low);
      body = 0;
     }     
   // condições shooting star PERIOD_M30
   if(   mrate[1].high == max_day                                 // maxima do dia
      && shadow_up >= (body_factor_math_SS*body)                  // sombra maior q o corpo 
      && shadow_down < (shadow_factor_math_SS*trading_range) )    // sombra inferior 5% a 10% do trading range 
      {
       if(Strategy.Debug){
       Debug(" Math Top "); }
       return true;
      }
   return false;
   
  }  // fim da Candle_Math_Top()
  
//+------------------------------------------------------------------+
//| EVENING STAR                                                     |
//+------------------------------------------------------------------+   
bool Evening_Star()
  {
//   Buffers_CS();
   double body_1, body_2, body_3;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double max_day = mrate[0].high;                   // maxima do dia até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   // candle 3 de baixa
   if(mrate[1].open > mrate[1].close)  
     {
      body_3 = (mrate[1].open - mrate[1].close);
     } 
   // candle 1 de alta  
   if(mrate[3].open < mrate[3].close)  
     {
      body_1 = (mrate[3].close - mrate[3].open);
     }   
   // candle 2 (star) de baixa ou alta ou doji
   if(mrate[2].open <= mrate[2].close)  
     {
      body_2 = (mrate[2].close - mrate[2].open);     // star de alta ou doji
     }   
   else body_2 = (mrate[2].open - mrate[2].close);   // star de baixa   
   // condições Evening_Star
   if(   mrate[2].high == max_day                              // candle 2 maxima do dia
   //|| mrate[2].high == max_day )                                // candle 3 maxima do dia
      && mrate[1].open > mrate[1].close                         // candle 3 de baixa
      && mrate[3].open < mrate[3].close                         // candle 1 de alta
      && !(body_1 >= 2*body_3 || body_3 >= 2*body_1)             // candles 1 e 3 proporcionais
      && (body_2 <= body_1/2 && body_2 <= body_3/2)              // corpo do candle 2 menor q o candle 1 e 3
      && mrate[1].open > mrate[3].open                          // prevenção de anomalias em mudança de dias
//      && Ind_CS.Volume_Buffer_CS[1] > 4000        // indicador ocidental: volume
      && mrate[1].close <= (mrate[3].close - body_1/2)     )    // candle 3 half cover candle 1 
     {
      if(Strategy.Debug){
      Debug(" Evening Star "); } 
      return true;
     }
   return false;
   
  }  // fim da Evening_Star()   
  
//############################################################################################################# 
//########################################## BOTTOM PATTERNS ################################################## 
//############################################################################################################# 
  
//+------------------------------------------------------------------+
//| HAMMER                                                           |
//+------------------------------------------------------------------+  
bool Hammer()
  {
//   Buffers();
   double shadow_up, shadow_down, body;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)            // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double min_day = mrate[0].low;                          // mínima do dia até o momento
   double unixtime_inicio_dia = (long)mrate[0].time; 
   
   mrate_buffers();
   // desconsidera quando o periodo nao é especificado
   if(   Strategy.CS_15M == false
      && Strategy.CS_30M == false )
     {
      return false;
     }
     
   double trading_range = (mrate[2].high - mrate[2].low);  // tamanho do candle como um todo
   // candle de baixa
   if(mrate[2].open > mrate[2].close)  
     {
//      return false;                                        // não aceita candle de baixa em hammers
      shadow_up = (mrate[2].high - mrate[2].open);
      shadow_down = (mrate[2].close - mrate[2].low);
      body = (mrate[2].open - mrate[2].close);
     } 
   // candle de alta  
   if(mrate[2].open < mrate[2].close)  
     {
      shadow_up = (mrate[2].high - mrate[2].close);
      shadow_down = (mrate[2].open - mrate[2].low);
      body = (mrate[2].close - mrate[2].open);
     }   
   // doji
   if(mrate[2].open == mrate[2].close)  
     {
      shadow_up = (mrate[2].high - mrate[2].close);
      shadow_down = (mrate[2].open - mrate[2].low);
      body = 0;
     }     
   // condições hammer
   if(  
         mrate[2].low <= (min_day + 0*pip)             // minima do dia
//      && (long)mrate[2].time > unixtime_inicio_dia   // opção para nao olhar para candles do dia anterior
      && mrate[1].open < mrate[1].close                // confirmação: o candle 2 é de alta
//      && (mrate[1].close - mrate[1].open) > 5*pip
      && shadow_down >= (2*body)                       // sombra pelo menos 2 vezes maior q o corpo 
      && shadow_up <= (0.1*trading_range)              // sombra superior no máximo 10% do trading range 
//      && mrate[3].open > mrate[3].close                // downtrend
                                            )            
      {
       if(Strategy.Debug){
       Debug(" Hammer "); }
       return true;
      }
   return false;
   
  }  // fim da Hammer()  
  
//+------------------------------------------------------------------+
//| INVERTED HAMMER                                                  |
//+------------------------------------------------------------------+  
bool Inverted_Hammer()
  {
//   Buffers();
   double shadow_up, shadow_down, body;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)            // aloca o candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double min_day = mrate[0].low;                          // mínima do candle diário até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double trading_range = (mrate[2].high - mrate[2].low);  // tamanho do candle como um todo
   // candle de baixa
   if(mrate[2].open > mrate[2].close)  
     {
//      return false;                                        // não aceita candle de baixa em inverted hammers
      shadow_up = (mrate[2].high - mrate[2].open);
      shadow_down = (mrate[2].close - mrate[2].low);
      body = (mrate[2].open - mrate[2].close);
     } 
   // candle de alta  
   if(mrate[2].open < mrate[2].close)  
     {
      shadow_up = (mrate[2].high - mrate[2].close);
      shadow_down = (mrate[2].open - mrate[2].low);
      body = (mrate[2].close - mrate[2].open);
     }   
   // doji
   if(mrate[2].open == mrate[2].close)  
     {
      shadow_up = (mrate[2].high - mrate[2].close);
      shadow_down = (mrate[2].open - mrate[2].low);
      body = 5;
     }     
   // condições inverted hammer
   if(  
         (   mrate[2].low == min_day                     // minima do dia
          || mrate[1].low == min_day
//          || mrate[3].low == min_day  
                                     )
      && shadow_up >= (2*body)                           // sombra superior maior q o corpo 
      && shadow_down < (0.1*trading_range)               // sombra inferior 5% a 10% do trading range 
      && (mrate[1].open + 2*pip) < mrate[1].close        // confirmação: o candle 2 é de alta
                                                   )  
      {
       if(Strategy.Debug){
       Debug(" Inverted Hammer "); }
       return true;
      }
   return false;
   
  }  // fim da Inverted_Hammer()    
  
//+------------------------------------------------------------------+
//| BULLISH ENGULFING                                                |
//+------------------------------------------------------------------+  
bool Bullish_Engulfing()
  {
   double body_1, body_2, trading_range_1, trading_range_2, shadow_up_2, shadow_down_2;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a minima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double min_day = mrate[0].low;                    // minima do dia até o momento
   
   mrate_buffers();
   // desconsidera quando o periodo nao é especificado
   if(   Strategy.CS_15M == false
      && Strategy.CS_30M == false )
     {
      return false;
     }
     
   trading_range_1 = (mrate[2].high - mrate[2].low);  // tamanho do candle 1 como um todo
   trading_range_2 = (mrate[1].high - mrate[1].low);  // tamanho do candle 2 como um todo  
   // candle 2 de alta
   if(mrate[1].open < mrate[1].close)  
     {
      body_2 = (mrate[1].close - mrate[1].open);
      shadow_up_2 = (mrate[1].high - mrate[1].close);
      shadow_down_2 = (mrate[1].open - mrate[1].low);
     } 
   // candle 1 de baixa  
   if(mrate[2].open > mrate[2].close)  
     {
      body_1 = (mrate[2].open - mrate[2].close);
     }   
   // doji
   if(   mrate[2].open == mrate[2].close
      || mrate[2].open == mrate[2].close + 1*pip
      || mrate[2].open == mrate[2].close - 1*pip )  
     {
      body_1 = 0;
     }     
   // condições Bullish_Engulfing
   if(  
         mrate[1].low == min_day                                 // minima do dia
      && trading_range_2 > trading_range_1                       // o candle de engolfo precisa ter um range maior
      && mrate[1].low < mrate[2].low                             // low inferior do candle 2 é maior
      && mrate[1].open < mrate[1].close                          // candle 2 de alta
      && mrate[2].open > mrate[2].close                          // candle 1 de baixa
//      && body_2 >= 10*pip
      && mrate[2].close <= mrate[3].open                         // downtrend
//      &&(shadow_up_2 <= body_2 && shadow_down_2 <= body_2)             // nenhuma das sombras pode ser maior q o corpo de engolfo
      && mrate[1].open <= (mrate[2].close + 1*pip)                 // correção de anomalias: aceita 1 pip.
      &&(body_2 > body_1 && mrate[1].close >= mrate[2].open)     // Engulfing
//      && mrate[1].open < Global.ORmin
                                                              )       
      {
       if(Strategy.Debug){
       Debug(" Bullish Engulfing "); } 
       return true;
      }
   return false;
   
  }  // fim da Bullish_Engulfing()  
  
//+------------------------------------------------------------------+
//| PIERCING PATTERN                                                 |
//+------------------------------------------------------------------+   
bool Piercing_Pattern()
  {
   double shadow_up_1, shadow_down_1, body_1, body_2;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double min_day = mrate[0].low;                   // minima do dia até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,3,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   // candle 2 de alta
   if(mrate[1].open < mrate[1].close)  
     {
      body_2 = (mrate[1].close - mrate[1].open);
     } 
   // candle 1 de baixa  
   if(mrate[2].open > mrate[2].close)  
     {
      body_1 = (mrate[2].open - mrate[2].close);
      shadow_up_1 = (mrate[2].high - mrate[2].open);
      shadow_down_1 = (mrate[2].close - mrate[2].low);
     }   
   // doji
   if(mrate[2].open == mrate[2].close)  
     {
      return false;
     }     
   // condições Piercing_Pattern
   if(  (   
            mrate[1].low == min_day        // minima do dia
//         || mrate[2].low == min_day 
                                       )    
      && mrate[2].open > mrate[1].high                          // sombra superior do candle 2 nao ultrapassa o open do candle 1
      && mrate[1].open < mrate[1].close                         // candle 2 de alta
      && mrate[2].open > mrate[2].close                         // candle 1 de baixa
      && mrate[1].open <= (mrate[2].close + pip)                // candle 2 abre com gap ou mantem o preço
//      && (body_1 > shadow_up_1)                            // big candle 1 com sombras curtas
      && mrate[1].close < mrate[2].open                         // não engolfa todo o candle
      && mrate[1].close > (mrate[2].close + body_1/2)           ) // half cover     
      {
       if(Strategy.Debug){
       Debug(" Piercing Pattern "); } 
       return true;
      }
   return false;
   
  }  // fim da Piercing_Pattern()   
  
//+------------------------------------------------------------------+
//| HARAMI BULLISH                                                   |
//+------------------------------------------------------------------+   
bool Harami_Bullish()
  {
//   double body_1, body_2;
   Buffers_CS();
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double min_day = mrate[0].low;                   // minima do dia até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,3,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   // condições Harami_Bullish
   if(  (   
            mrate[1].low == min_day             // minima do dia
         || mrate[2].low == min_day  
                                     ) 
      && Ind_CS.Volume_Buffer_CS[0] > Ind_CS.Volume_Buffer_CS[1]                                 
//      && mrate[2].open > mrate[1].high                          // sombra superior do candle 2 nao ultrapassa o open do candle 1
      && mrate[1].open < mrate[1].close                         // candle 2 de alta
      && mrate[2].open > mrate[2].close                         // candle 1 de baixa
      && mrate[1].open >= mrate[2].close                        // candle 2 abre com gap ou mantem o preço
      && mrate[1].close < mrate[2].open                         // não engolfa todo o candle   
      && mrate[0].high >= mrate[2].open     )                   // confirmação dinamica
      {
       if(Strategy.Debug){
       Debug(" Harami Bullish "); } 
       return true;
      }
   return false;
   
  }  // fim da Harami_Bullish()    
  
//+------------------------------------------------------------------+
//| HARAMI BULLISH EXIT                                                  |
//+------------------------------------------------------------------+   
bool Harami_Bullish_Exit()
  {
//   double body_1, body_2;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double min_day = mrate[0].low;                   // minima do dia até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,3,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   // condições Harami_Bullish
   if(   mrate[1].open < mrate[1].close                         // candle 2 de alta
      && mrate[2].open > mrate[2].close                         // candle 1 de baixa
      && mrate[1].open >= mrate[2].close                        // candle 2 abre com gap ou mantem o preço
      && mrate[1].close < mrate[2].open                         // não engolfa todo o candle   
      && mrate[0].high >= mrate[2].open     )                   // confirmação dinamica
      {
       if(Strategy.Debug){
       Debug(" Harami_Bullish_Exit "); } 
       return true;
      }
   return false;
   
  }  // fim da Harami_Bullish_Exit()        
  
//+------------------------------------------------------------------+
//| 2 CANDLEMATH BOTTOM                                              |
//+------------------------------------------------------------------+  
bool Candle_Math_Bottom()
  {
//   Buffers();
   double shadow_up, shadow_down, body;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)            // aloca a maxima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double min_day = mrate[0].low;                          // mínima do dia até o momento
   if(CopyRates(Ativo,PERIOD_M30,0,2,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M30 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double trading_range = (mrate[1].high - mrate[1].low);   // tamanho do candle como um todo
   // candle de baixa
   if(mrate[1].open > mrate[1].close)  
     {
      return false;                                         // não aceita candle de baixa em hammers
      shadow_up = (mrate[1].high - mrate[1].open);
      shadow_down = (mrate[1].close - mrate[1].low);
      body = (mrate[1].open - mrate[1].close);
     } 
   // candle de alta  
   if(mrate[1].open < mrate[1].close)  
     {
      shadow_up = (mrate[1].high - mrate[1].close);
      shadow_down = (mrate[1].open - mrate[1].low);
      body = (mrate[1].close - mrate[1].open);
     }   
   // doji
   if(mrate[1].open == mrate[1].close)  
     {
      shadow_up = (mrate[1].high - mrate[1].close);
      shadow_down = (mrate[1].open - mrate[1].low);
      body = 0;
     }     
   // condições hammer
   if(   mrate[1].low == min_day                                  // minima do dia
//      && MA_Alignment_Long()
//      && Ind.MA200_50_Buffer[0] > dmin_MA200_50
      && shadow_down >= (body_factor_math_hammer*body)            // sombra maior q o corpo 
      && shadow_up < (shadow_factor_math_hammer*trading_range) )  // sombra superior 5% a 10% do trading range 
      {
       if(Strategy.Debug){
       Debug(" Math Bottom "); }
       return true;
      }
   return false;
   
  }  // fim da Candle_Math_Bottom()    
  
//+------------------------------------------------------------------+
//| MORNING STAR                                                     |
//+------------------------------------------------------------------+   
bool Morning_Star()
  {
//   Buffers_CS();
   double body_1, body_2, body_3;
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_D1,0,1,mrate) < 0)      // aloca a minima do candle diário
     {
      Debug_Alert(" Error copying PERIOD_D1 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   double min_day = mrate[0].low;                   // minima do dia até o momento
   
   if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)      
     {
      Debug_Alert(" Error copying PERIOD_M15 rates - error: "+GetLastError()); 
      ResetLastError();
     }  
   // candle 3 de alta
   if(mrate[1].open < mrate[1].close)  
     {
      body_3 = (mrate[1].close - mrate[1].open);
     } 
   // candle 1 de baixa  
   if(mrate[3].open > mrate[3].close)  
     {
      body_1 = (mrate[3].open - mrate[3].close);
     }   
   // candle 2 de baixa ou alta ou doji
   if(mrate[2].open <= mrate[2].close)  
     {
      body_2 = (mrate[2].close - mrate[2].open);     // star de alta ou doji
     }   
   else body_2 = (mrate[2].open - mrate[2].close);   // star de baixa   
   // condições Morning_Star
   if(    mrate[2].low == min_day                                // candle 2 minima do dia
   //|| mrate[2].low == min_day )                               // candle 3 minima do dia
      &&  mrate[1].open < mrate[1].close                         // candle 3 de alta
      &&  mrate[3].open > mrate[3].close                         // candle 1 de baixa
      && !(body_1 >= 2*body_3 || body_3 >= 2*body_1)             // candles 1 e 3 proporcionais
      && (body_2 <= body_1/2 && body_2 <= body_3/2)              // corpo do candle 2 menor q o candle 1 e 3
      &&  mrate[1].open < mrate[3].open                          // prevenção de anomalias em mudança de dias
//      && Ind_CS.Volume_Buffer_CS[1] > 4000        // indicador ocidental: volume
      &&  mrate[1].close >= (mrate[3].close + body_1/2)     )    // candle 3 half cover candle 1 
      {
       if(Strategy.Debug){
       Debug(" Morning Star "); } 
       return true;
      }
   return false;
   
  }  // fim da Morning_Star()     


                                   