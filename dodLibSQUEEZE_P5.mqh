//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| SQUEEZE_P5 strategy                                              |
//+------------------------------------------------------------------+
void Estrategia_SQUEEZE_P5()
  {
   // Verificação das condições de negociação da estratégia SQUEEZE    
   if(!PositionSelect(Ativo) && !Global_Get("SQUEEZE_P5_Once"))
     {
      // verifica horários não permitidos para entrada de operação
      if(   (str1.hour == TradeStartHour && str1.min <= 6)
         || (str1.hour >= BlockTradeStartHour && str1.min >= BlockTradeStartMin)
         || (str1.hour == 18 && str1.min >= 00))
        {
         return;    // sai da função e prossegue no mesmo tick
        }
      else  // horário permitido
        {
         SQUEEZE_P5();  
        }       
     }
   else
     {
      if(Global_Get("TradeSignal_SQUEEZE_P5"))
        {
         SQUEEZE_P5_SL_SG();
        }
     }
  }
  
  
void SQUEEZE_P5()
  { 
   Buffers_P5();  // Aloca os buffers dos indicadores
   // Verifica se a volatilidade está abaixo de um limite minimo  
   if(Ind.BBandwidth_P5_Buffer[0] < Width_Limit_P5 - 0.1) 
     {
      if(Strategy.Debug && !Global_Get("SQUEEZE_P5_mode")  ){
      Debug(" SQUEEZE_P5_mode =  "+!Global_Get("SQUEEZE_P5_mode")); }
      Global_Set("SQUEEZE_P5_mode",TRUE); 
//      Signals.SQUEEZE_mode = true;
     }
      if(   (Global_Get("SQUEEZE_P5_mode")) 
         && (Ind.BBandwidth_P5_Buffer[0] >= Width_Limit_P5)
         && (Ind.BBandwidth_P5_Buffer[0] <= 1)              // não entra acima de uma certa volatilidade
         &&
          ( (Ind.BBandwidth_P5_Buffer[0] - Ind.BBandwidth_P5_Buffer[1]) > Width_Var_P5 
         || (Ind.BBandwidth_P5_Buffer[0] - Ind.BBandwidth_P5_Buffer[2]) > Width_Var_P5
         || (Ind.BBandwidth_P5_Buffer[0] - Ind.BBandwidth_P5_Buffer[3]) > Width_Var_P5
         || (Ind.BBandwidth_P5_Buffer[0] - Ind.BBandwidth_P5_Buffer[4]) > Width_Var_P5 
         || (Ind.BBandwidth_P5_Buffer[0] - Ind.BBandwidth_P5_Buffer[5]) > Width_Var_P5 ))
        {
         // Condição de abertura fechamento acima da banda long
         if(   (   mrate[1].close > Ind.BB_P5_Up2[1]
                || mrate[2].close > Ind.BB_P5_Up2[2] )
            && MA_Alignment_P5_Long()                                 // medias alinhadas
            && mrate[0].close < (Ind.BB_P5_Up2[0] + Band_Jump_Long_P5) )  // calibragem do Band Jump
           {
            OpenLongPosition_SQ_P5();      
           }
         // Condição de abertura short fechamento abaixo da banda  
         if(   (   mrate[1].close < Ind.BB_P5_Low2[1]
                || mrate[2].close < Ind.BB_P5_Low2[2])
            && MA_Alignment_P5_Short()                                  // medias alinhadas
            && mrate[0].close > (Ind.BB_P5_Low2[0] - Band_Jump_Short_P5) )  // calibragem do Band Jump
           {
            OpenShortPosition_SQ_P5();     
           }     
        
        } 

  } // fim da SQUEEZE_P5
  
  
void SQUEEZE_P5_SL_SG()
  {
   Buffers_P5();
   double price = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
   // saidas long
   if(Signals.LongPosition)
     {  
        
      // saida por Breakeven
      if(Strategy.Habilitar_Breakeven)
        {
         // analisa se a trade entra no modo Breakeven
         if(Breakeven_Long_P5() && !Global_Get("Breakeven_mode"))
           {
            Global_Set("Breakeven_mode",TRUE);
            if(Strategy.Debug){
            Debug(" Breakeven_mode: "+Global_Get("Breakeven_mode"));}
           }
         // saida por Breakeven
         if(   Global_Get("Breakeven_mode") 
            && mrate[0].close <= (Global.price_trade_start + Breakeven_long_exit_P5) )
           {
            CloseLongPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de compra SQUEEZE por Breakeven ");}
            return;      
           }  
         }  // fim da saida por Breakeven     

         
      // saida por Band Jump
      if(price >= Ind.BB_P5_Up2[0] + Band_Jump_Long_P5)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE_P5 por Band Jump ");}  
         return;      
        }
        
/*        
      // saida por recuo  
      if(mrate[1].close < Ind.BB_P5_Up[1] - delta_SQUEEZE_long_P5 )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE_P5 por recuo ");}
         
         return;      
        }  
*/        

      // saida por volatilidade  
      if(Ind.BBandwidth_P5_Buffer[1] >= Max_Width_P5)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de compra SQUEEZE_P5 por volatilidade ");}
         
         return;      
        }     
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação SQUEEZE_P5 long por TIME "); }
                    
         return;
        }       
     } // fim saidas long
     
   // saidas short  
   if(Signals.ShortPosition)
     {
     
      // saida por Breakeven short
      if(Strategy.Habilitar_Breakeven)
        {
         // analisa se a trade entra no modo Breakeven
         if(Breakeven_Short_P5() && !Global_Get("Breakeven_mode"))
           {
            Global_Set("Breakeven_mode",TRUE);
            if(Strategy.Debug){
            Debug(" Breakeven_mode: "+Global_Get("Breakeven_mode"));}
           }
         // saida por Breakeven
         if(   Global_Get("Breakeven_mode") 
            && mrate[0].close >= (Global.price_trade_start - Breakeven_short_exit_P5) )
           {
            CloseShortPosition();
            if(Strategy.Debug){
            Debug(" Fechamento de operação de venda SQUEEZE por Breakeven ");}           
            return;      
           }  
         }  // fim da saida por Breakeven short 
         
      // saida por Band Jump
      if(price <= Ind.BB_P5_Low2[0] - Band_Jump_Short_P5)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE_P5 por Band Jump ");}       
         return;      
        } 
        
/*           
      // saida por recuo  
      if(mrate[1].close > Ind.BB_P5_Low[1] + delta_SQUEEZE_short_P5)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE_P5 por recuo ");}
         
         return;      
        } 
*/        

      // saida por volatilidade  
      if(Ind.BBandwidth_P5_Buffer[1] >= Max_Width_P5)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Fechamento de operação de venda SQUEEZE_P5 por volatilidade ");}
         
         return;      
        }   
        
      // saida por TIME
      if(str1.hour >= TimeExitHour && str1.min >= TimeExitMin)
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação SQUEEZE_P5 short por TIME "); }
                    
         return;
        }      
        
     }  // fim saidas short  
     
  }  // fim da SQUEEZE_SL_SG    
  
  
  
  
void OpenShortPosition_SQ_P5()   
  {
   OpenShortPosition();
   Global_Set("TradeSignal_SQUEEZE_P5",TRUE);
   Global_Set("SQUEEZE_P5_mode",FALSE);
   if(Strategy.Debug){
   Debug(" Abertura de operação de venda SQUEEZE_P5 ");}
   if(Strategy.Habilitar_SQUEEZE_P5_Once)     
     {
      Global_Set("SQUEEZE_P5_Once",TRUE);
      if(Strategy.Debug){
      Debug(" SQUEEZE_P5_Once: "+(bool)Global_Get("SQUEEZE_P5_Once")); } 
     }
   return;         
  
  } 
  
void OpenLongPosition_SQ_P5()
  {
   OpenLongPosition();
   Global_Set("TradeSignal_SQUEEZE_P5",TRUE);
   Global_Set("SQUEEZE_P5_mode",FALSE);
   if(Strategy.Debug){
   Debug(" Abertura de operação de compra SQUEEZE_P5 ");}
   if(Strategy.Habilitar_SQUEEZE_P5_Once)     
     {
      Global_Set("SQUEEZE_P5_Once",TRUE);
      if(Strategy.Debug){
      Debug(" SQUEEZE_P5_Once: "+(bool)Global_Get("SQUEEZE_P5_Once")); } 
     }
   return;  
  }  