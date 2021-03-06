//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| MA_Control                                                       |
//+------------------------------------------------------------------+  
// verifica se o preço se encontra na zona de suporte/resistencia da media de 20
void MA_Control_20()
  {
   if(str1.hour == 9 && str1.min == 0) return; // horario do reset
   Buffers();
   if(   ( (Ind.MA20_Buffer[0] + delta_MA20) >= mrate[0].close && mrate[0].close >= Ind.MA20_Buffer[0])
       ||(  Ind.MA20_Buffer[0] >= mrate[0].close && mrate[0].close >= (Ind.MA20_Buffer[0] - delta_MA20)) )
     {
      Global_Set("MA_mode_20",TRUE);
     }   
   else 
     {
      Global_Set("MA_mode_20",FALSE); 
     }   
  } 
// verifica se o preço se encontra na zona de suporte/resistencia da media de 50  
void MA_Control_50()
  {
   if(str1.hour == 9 && str1.min == 0) return; // horario do reset
   Buffers();
   if(  ( (Ind.MA50_Buffer[0] + delta_MA50) >= mrate[0].close && mrate[0].close >= Ind.MA50_Buffer[0])
      ||(  Ind.MA50_Buffer[0] >= mrate[0].close && mrate[0].close >= (Ind.MA50_Buffer[0] - delta_MA50)) )
     {
      Global_Set("MA_mode_50",TRUE);
     }   
   else 
     {
      Global_Set("MA_mode_50",FALSE);    
     }   
  }   
// verifica se o preço se encontra na zona de suporte/resistencia da media de 200  
void MA_Control_200()
  {
   if(str1.hour == 9 && str1.min == 0) return; // horario do reset
   Buffers();
   if(  ( (Ind.MA200_Buffer[0] + delta_MA200) >= mrate[0].close && mrate[0].close >= Ind.MA200_Buffer[0])
      ||(  Ind.MA200_Buffer[0] >= mrate[0].close && mrate[0].close >= (Ind.MA200_Buffer[0] - delta_MA200)) )
     {
      Global_Set("MA_mode_200",TRUE);
     }   
   else 
     {
      Global_Set("MA_mode_200",FALSE);   
     }   
  }     
     
//+------------------------------------------------------------------+
//| Support/Resistance                                               |
//+------------------------------------------------------------------+  
// Verifica se a combinação das medias de 200 e 50 atuam como suporte
bool Support_200_50()
  {
   Buffers();
   if( // preço inicial acima da zona de suporte   
          Global.price_trade_start > Ind.MA50_Buffer[0] 
       && Ind.MA50_Buffer[0] > Ind.MA200_Buffer[0]
       // medias ascendentes
       && Ind.MA50_Buffer[0]  > Ind.MA50_Buffer[1]
       && Ind.MA50_Buffer[0]  > Ind.MA50_Buffer[2]
       && (   Ind.MA200_Buffer[0] > Ind.MA200_Buffer[1] 
           || Ind.MA200_Buffer[0] > Ind.MA200_Buffer[2]
           || Ind.MA200_Buffer[0] > Ind.MA200_Buffer[3])
       //  distancia entre as medias acima de um valor minimo 
//       && Ind.MA200_50_Buffer[0] > dmin_MA200_50
       //  ascendencia da distancia
       && (   Ind.MA200_50_Buffer[0] > Ind.MA200_50_Buffer[1]
           || Ind.MA200_50_Buffer[0] > Ind.MA200_50_Buffer[2]
           || Ind.MA200_50_Buffer[0] > Ind.MA200_50_Buffer[3] ) )
     {
      if(Strategy.Debug){
      Debug(" Support_200_50 =  "+true); }
      return true;
     }    
   else return false;   
  }
  
// Verifica se a combinação das medias de 50 e 20 atuam como suporte
bool Support_50_20()
  {
   Buffers();
   if(    mrate[0].close > Ind.MA20_Buffer[0] 
       && Ind.MA20_Buffer[0] > Ind.MA50_Buffer[0]
       // medias ascendentes
       && (   Ind.MA20_Buffer[0] > Ind.MA20_Buffer[1]
           && Ind.MA20_Buffer[0] > Ind.MA20_Buffer[2]
           && Ind.MA50_Buffer[0] > Ind.MA50_Buffer[1] 
           && Ind.MA50_Buffer[0] > Ind.MA50_Buffer[2] )
       //  distancia entre as medias acima de uma distancia minima  
       &&  Ind.MA50_20_Buffer[0] > dmin_MA50_20 
       //  ascendencia da distancia
       && Ind.MA50_20_Buffer[0] > Ind.MA50_20_Buffer[1] 
       && Ind.MA50_20_Buffer[0] > Ind.MA50_20_Buffer[2] )
     {
      if(Strategy.Debug){
      Debug(" Support_50_20 =  "+true); }
      return true;
     }       
   else return false;   
  }  

// Verifica se a combinação das medias de 200 e 50 atuam como resistencia  
bool Resistance_200_50()
  {  
   Buffers();
   if( // preço inicial abaixo da zona de resistencia
          Global.price_trade_start < Ind.MA50_Buffer[0] 
       && Ind.MA50_Buffer[0] < Ind.MA200_Buffer[0]
       // medias descendentes
       && Ind.MA50_Buffer[0] < Ind.MA50_Buffer[1]
       && Ind.MA50_Buffer[0] < Ind.MA50_Buffer[2] 
       && (   Ind.MA200_Buffer[0] < Ind.MA200_Buffer[1] 
           || Ind.MA200_Buffer[0] < Ind.MA200_Buffer[2]
           || Ind.MA200_Buffer[0] < Ind.MA200_Buffer[3] )
       // distancia entre as medias acima de um valor minimo 
//       && Ind.MA200_50_Buffer[0] > dmin_MA200_50    
       // ascendencia da distancia
       && (   Ind.MA200_50_Buffer[0] > Ind.MA200_50_Buffer[1]
           || Ind.MA200_50_Buffer[0] > Ind.MA200_50_Buffer[2] 
           || Ind.MA200_50_Buffer[0] > Ind.MA200_50_Buffer[3] ) )
     {
      if(Strategy.Debug){
      Debug(" Resistance_200_50 =  "+true); }
      return true;
     }    
   else return false;   
  }
  
// Verifica se a combinação das medias de 50 e 20 atuam como resistencia  
bool Resistance_50_20()
  {  
   Buffers();
   if(    mrate[0].close < Ind.MA20_Buffer[0] 
       && Ind.MA20_Buffer[0] < Ind.MA50_Buffer[0]
       // verifica se as medias estao descendentes
       && (   Ind.MA20_Buffer[0] < Ind.MA20_Buffer[1]
           && Ind.MA20_Buffer[0] < Ind.MA20_Buffer[2] 
           && Ind.MA50_Buffer[0] < Ind.MA50_Buffer[1] 
           && Ind.MA50_Buffer[0] < Ind.MA50_Buffer[2] )
       //  distancia entre as medias acima de uma distancia minima  
       &&  Ind.MA50_20_Buffer[0] > dmin_MA50_20     
       // verifica se a distancia entre as medias esta descendente
       && Ind.MA50_20_Buffer[0] > Ind.MA50_20_Buffer[1] 
       && Ind.MA50_20_Buffer[0] > Ind.MA50_20_Buffer[2] )
     {
      if(Strategy.Debug){
      Debug(" Resistance_50_20 =  "+true); }
      return true;
     }     
   else return false;   
  }  
  
//+------------------------------------------------------------------+
//| Alinhamento de medias                                            |
//+------------------------------------------------------------------+  
// ##### PERIOD_M15
// Verifica se as medias estao alinhadas para baixo - entradas short permitidas
bool MA_Alignment_Short()
  {
   // descendencia
   Buffers();  
   if(   Ind.MA20_Buffer[0] < Ind.MA20_Buffer[1]
      && (   Ind.MA50_Buffer[0] < Ind.MA50_Buffer[1]
          && Ind.MA50_Buffer[0] < Ind.MA50_Buffer[2]) 
      && (   Ind.MA200_Buffer[0] < Ind.MA200_Buffer[1] 
          || Ind.MA200_Buffer[0] < Ind.MA200_Buffer[2]
          || Ind.MA200_Buffer[0] < Ind.MA200_Buffer[3])  )
     {
      return true; // entradas short permitidas
     }   
     
   return false;   
  } 
// Verifica se as medias estao alinhadas para cima - entradas long permitidas
bool MA_Alignment_Long()
  {
   Buffers(); 
   // ascendencia 
   if(   Ind.MA20_Buffer[0] > Ind.MA20_Buffer[1]
      && (   Ind.MA50_Buffer[0] > Ind.MA50_Buffer[1]
          && Ind.MA50_Buffer[0] > Ind.MA50_Buffer[2]) 
      && (   Ind.MA200_Buffer[0] > Ind.MA200_Buffer[1] 
          || Ind.MA200_Buffer[0] > Ind.MA200_Buffer[2]
          || Ind.MA200_Buffer[0] > Ind.MA200_Buffer[3])  )
     {
      return true;  // entradas long permitidas
     }   
     
   return false;   
  }   
  
// ##### PERIOD_M5   
// Verifica se as medias estao alinhadas para baixo - entradas short permitidas
bool MA_Alignment_P5_Short()
  {
   // descendencia
   Buffers_P5();  
   if(   Ind.MA20_P5_Buffer[0] < Ind.MA20_P5_Buffer[1]
      && (   Ind.MA50_P5_Buffer[0] < Ind.MA50_P5_Buffer[1]
          && Ind.MA50_P5_Buffer[0] < Ind.MA50_P5_Buffer[2]) 
      && (   Ind.MA200_P5_Buffer[0] < Ind.MA200_P5_Buffer[1] 
          || Ind.MA200_P5_Buffer[0] < Ind.MA200_P5_Buffer[2]
          || Ind.MA200_P5_Buffer[0] < Ind.MA200_P5_Buffer[3])  )
     {
      return true; // entradas short permitidas
     }   
     
   return false;   
  } 
// Verifica se as medias estao alinhadas para cima - entradas long permitidas
bool MA_Alignment_P5_Long()
  {
   Buffers_P5(); 
   // ascendencia 
   if(   Ind.MA20_P5_Buffer[0] > Ind.MA20_P5_Buffer[1]
      && (   Ind.MA50_P5_Buffer[0] > Ind.MA50_P5_Buffer[1]
          && Ind.MA50_P5_Buffer[0] > Ind.MA50_P5_Buffer[2]) 
      && (   Ind.MA200_P5_Buffer[0] > Ind.MA200_P5_Buffer[1] 
          || Ind.MA200_P5_Buffer[0] > Ind.MA200_P5_Buffer[2]
          || Ind.MA200_P5_Buffer[0] > Ind.MA200_P5_Buffer[3])  )
     {
      return true;  // entradas long permitidas
     }   
     
   return false;   
  }   
     
//+------------------------------------------------------------------+
//| Breakeven                                                        |
//+------------------------------------------------------------------+
// Verifica o drawdown dos ganhos na trade long
bool Breakeven_Long()
  {
   Buffers();
   if(mrate[0].close > (Global.price_trade_start + (Breakeven_long_enter * pip)) )
     {
//      Global_Set("Breakeven_mode",TRUE);
      return true;
     }
   
   return false;
  }
// Verifica o drawdown dos ganhos na trade short
bool Breakeven_Short()
  {
   Buffers();
   if(mrate[0].close < (Global.price_trade_start - (Breakeven_short_enter * pip)) )
     {
//      Global_Set("Breakeven_mode",TRUE);
      return true;
     }
   
   return false;
  }  
  
// ##### PERIOD_M5  
// Verifica o drawdown dos ganhos na trade long
bool Breakeven_Long_P5()
  {
   Buffers_P5();
   if(mrate[0].close > (Global.price_trade_start + Breakeven_long_enter_P5) )
     {
      Global_Set("Breakeven_mode",TRUE);
      return true;
     }
   
   return false;
  }
// Verifica o drawdown dos ganhos na trade short
bool Breakeven_Short_P5()
  {
   Buffers_P5();
   if(mrate[0].close < (Global.price_trade_start - Breakeven_short_enter_P5) )
     {
      Global_Set("Breakeven_mode",TRUE);
      return true;
     }
   
   return false;
  }      
  
  
//################################################################################  
//############## SUB ESTRATEGIAS EXPERIMENTAIS ###################################
//################################################################################
//+------------------------------------------------------------------+
//| Breakout                                                         |
//+------------------------------------------------------------------+
// Verifica se pode ocorrer um breakout
bool Breakout()
  {
   Buffers();
   if( (  Signals.LongPosition 
       && !Resistance_200_50()
       && mrate[1].close >= Ind.MA50_Buffer[1]
       && Ind.Volume_Buffer[1] >= Breakout_Volume)
      || 
       (  Signals.ShortPosition 
       && !Support_200_50()
       && mrate[1].close <= Ind.MA50_Buffer[1]
       && Ind.Volume_Buffer[1] >= Breakout_Volume)   )
     {
      if(Strategy.Debug){
      Debug(" Breakout =  "+true); }
      return true;
     }
     
   return false;   
  }  
  

//+------------------------------------------------------------------+
//| MA_Control  Oscillation                                          |
//+------------------------------------------------------------------+  
// saída long por MA_Control Oscillation
bool MA_Oscillation_Long()
  {
   if((// preço abaixo das medias   
          (   Global.price_trade_start < Ind.MA50_Buffer[1]
           && Global_Get("MA_mode_200")                     )
       // preço entre as medias - saida gain    
       || (   Global.price_trade_start > Ind.MA50_Buffer[1]
           && Global.price_trade_start < Ind.MA200_Buffer[1]
           && Global_Get("MA_mode_200")                     )
       // preço entre as medias - saida loss    
       || (   Global.price_trade_start > Ind.MA50_Buffer[1]
           && Global.price_trade_start < Ind.MA200_Buffer[1] 
           && mrate[1].close < Ind.MA50_Buffer[1]           ) )
   
      // as medias nao podem estar muito proximas
      && Ind.MA200_50_Buffer[0] > dmin_MA200_50
      // media de 200 descendente
      && (   Ind.MA200_Buffer[0] < Ind.MA200_Buffer[1] 
          || Ind.MA200_Buffer[0] < Ind.MA200_Buffer[2]
          || Ind.MA200_Buffer[0] < Ind.MA200_Buffer[3] )
      // media de 50 ascendente
      && (   Ind.MA50_Buffer[0]  > Ind.MA50_Buffer[1]
          || Ind.MA50_Buffer[0]  > Ind.MA50_Buffer[2]
          || Ind.MA50_Buffer[0]  > Ind.MA50_Buffer[3]  )
      // distancia entre as medias descendente    
      && 
        (   Ind.MA200_50_Buffer[0] < Ind.MA200_50_Buffer[1]
         || Ind.MA200_50_Buffer[0] < Ind.MA200_50_Buffer[2]
         || Ind.MA200_50_Buffer[0] < Ind.MA200_50_Buffer[3] )   )
    return true; 
    else return false;     
   }  

// saída short por MA_Control Oscillation
bool MA_Oscillation_Short()
  {
   if((// preço acima das medias   
          (   Global.price_trade_start > Ind.MA200_Buffer[1]
           && Global_Get("MA_mode_50")                     )
       // preço entre as medias - saida gain    
       || (   Global.price_trade_start > Ind.MA50_Buffer[1]
           && Global.price_trade_start < Ind.MA200_Buffer[1]
           && Global_Get("MA_mode_50")                     )
       // preço entre as medias - saida loss    
       || (   Global.price_trade_start > Ind.MA50_Buffer[1]
           && Global.price_trade_start < Ind.MA200_Buffer[1] 
           && mrate[1].close > Ind.MA200_Buffer[1]         ) )   
   
      // as medias nao podem estar muito proximas
      && Ind.MA200_50_Buffer[0] > dmin_MA200_50
      // media de 200 descendente
      && (   Ind.MA200_Buffer[0] < Ind.MA200_Buffer[1] 
          || Ind.MA200_Buffer[0] < Ind.MA200_Buffer[2]
          || Ind.MA200_Buffer[0] < Ind.MA200_Buffer[3] )
      // media de 50 ascendente
      && (   Ind.MA50_Buffer[0]  > Ind.MA50_Buffer[1]
          || Ind.MA50_Buffer[0]  > Ind.MA50_Buffer[2]
          || Ind.MA50_Buffer[0]  > Ind.MA50_Buffer[3]  ) 
      // distancia entre as medias descendente         
      && 
        (   Ind.MA200_50_Buffer[0] < Ind.MA200_50_Buffer[1]
         || Ind.MA200_50_Buffer[0] < Ind.MA200_50_Buffer[2]
         || Ind.MA200_50_Buffer[0] < Ind.MA200_50_Buffer[3] )  )
    return true;   
    else return false;  
   }     
