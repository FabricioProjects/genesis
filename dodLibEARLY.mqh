//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"

//+------------------------------------------------------------------+
//| EARLY strategy                                                   |
//+------------------------------------------------------------------+
void Estrategia_EARLY()
  {
   // Verificação das condições de negociação da estratégia EARLY    
   if( !PositionSelect(Ativo) && !Global_Get("EARLY_once") )
     {
      // verifica horários PERMITIDOS para entrada de operação    
      if( str1.hour == 9 && str1.min < 10 
         && (long)Global.tick_unixtime > ( (long) Global.EARLY_unixtime + EARLY_Delay_Enter) )
        {
         EARLY();
        }
      else
        {
         return;  // sai da função e prossegue no mesmo tick
        }       
     }
   else
     {
      if(Signals.TradeSignal_EARLY)
        {
         EARLY_SL_SG();
        }
     }
   }  // fim da Estrategia_EARLY()

void EARLY()
  {
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)
     {
      Debug_Alert(" Error copying M15 rates - error: "+GetLastError()); 
      ResetLastError(); return;
     }   
   double perc_enter;  
   perc_enter = 100 - (100 * (mrate[0].open/mrate[0].close));
   // condições de compra
   if( (long)TimeCurrent() > ((long)Global.EARLY_unixtime + EARLY_Delay_Enter + EARLY_Delay_Enter_Long) )
     {     
      if(   mrate[0].close > mrate[0].open 
         && perc_enter > EARLY_Enter_Long  )
        { 
         OpenLongPosition();
         Signals.TradeSignal_EARLY = true;
         Global_Set("EARLY_once",TRUE);
         if(Strategy.Debug){
         Debug(" Abertura de operação de compra EARLY "); }
         return;          
        }    
     }
   // condições de venda
   if( (long)TimeCurrent() > ((long)Global.EARLY_unixtime + EARLY_Delay_Enter + EARLY_Delay_Enter_Short) )
     {      
      if(   mrate[0].close < mrate[0].open 
         && perc_enter < EARLY_Enter_Short )
        {
         OpenShortPosition();
         Signals.TradeSignal_EARLY = true;
         Global_Set("EARLY_once",TRUE);
         if(Strategy.Debug){
         Debug(" Abertura de operação de venda EARLY "); }    
         return;          
        }
     }   
  }   // fim da EARLY() 
  
void EARLY_SL_SG()
  {
   TimeToStruct(Global.date1 = TimeCurrent(),str1);  // em datetime
   // saidas Long
   if(Signals.LongPosition)
     {     
     
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
            Debug(" Fechamento de operação de compra EARLY por Breakeven ");}
            
            return;      
           }  
         }  // fim da saida por Breakeven        
       
      if(str1.hour == 9 && str1.min >= EARLY_Time_Exit_Long ) 
        {
         CloseLongPosition(); 
         if(Strategy.Debug){
         Debug(" Saida EARLY long "); }
         return;    
        }  
     }
   // saidas Short  
   if(Signals.ShortPosition)
     {      
     
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
            Debug(" Fechamento de operação de venda EARLY por Breakeven ");}
            
            return;      
           }  
         }  // fim da saida por Breakeven short  

      if(str1.hour == 9 && str1.min >= EARLY_Time_Exit_Short) 
        {
         CloseShortPosition();  
         if(Strategy.Debug){
         Debug(" Saida EARLY short "); }
         return;    
        }  
     }  
  }  // fim da EARLY_SL_SG()      

//+------------------------------------------------------------------+
//| EARLY_NY strategy                                                |
//+------------------------------------------------------------------+
void Estrategia_EARLY_NY()
  {
   // Verificação das condições de negociação da estratégia EARLY_NY    
   if( !PositionSelect(Ativo) && !Global_Get("EARLY_NY_once") )
     {
      // alocação de buffers
      ArraySetAsSeries(Ind.Volume_Buffer,true);
      if( CopyBuffer(Ind.Volume_Handle,0,0,2,Ind.Volume_Buffer) < 0 )
        {
         Debug_Alert(" Error copying Volume indicator Buffers - error: "+GetLastError() ); 
         ResetLastError(); return;
        }  
      // verifica horários PERMITIDOS para entrada de operação 
      if(    str1.hour == Global.hour_NY && str1.min < Global.min_NY + 10
          && (long)Global.tick_unixtime > ( (long) Global.EARLY_NY_unixtime + EARLY_NY_Delay_Enter) 
          && Ind.Volume_Buffer[0] >= Volume_Tick_NY   )
        {
         EARLY_NY();
        }
      else
        {
         return;  // sai da função e prossegue no mesmo tick
        }       
     }
   else
     {
      if(Signals.TradeSignal_EARLY_NY)
        {
         EARLY_NY_SL_SG();
        }
     }
  }  // fim da Estrategia_EARLY_NY()
  
void EARLY_NY()
  {
   ArraySetAsSeries(mrate,true);
   if(CopyRates(Ativo,PERIOD_M15,0,4,mrate) < 0)
     {
      Debug_Alert(" Error copying M15 rates - error: "+GetLastError()); 
      ResetLastError(); return;
     }   
   double perc_enter;  
   perc_enter = 100 - (100 * (mrate[0].open/mrate[0].close));
   
   if( (long)TimeCurrent() > ((long)Global.EARLY_NY_unixtime + EARLY_NY_Delay_Enter + EARLY_NY_Delay_Enter_Long) )
     {     
      if(   mrate[0].close > mrate[0].open 
         && perc_enter > EARLY_NY_Enter_Long  )
        {
         OpenLongPosition();
         Signals.TradeSignal_EARLY_NY = true;
         Global_Set("EARLY_NY_once",TRUE);
         if(Strategy.Debug){
         Debug(" Abertura de operação de compra EARLY_NY ");}     
         return;          
        }    
     }
   
   if( (long)TimeCurrent() > ((long)Global.EARLY_NY_unixtime + EARLY_NY_Delay_Enter + EARLY_NY_Delay_Enter_Short) )
     {      
      if(   mrate[0].close < mrate[0].open 
         && perc_enter < EARLY_NY_Enter_Short  )
        {
         OpenShortPosition();
         Signals.TradeSignal_EARLY_NY = true;
         Global_Set("EARLY_NY_once",TRUE);
         if(Strategy.Debug){
         Debug(" Abertura de operação de venda EARLY_NY "); }          
         return;          
        }
     }   
    
  }   // fim da EARLY_NY() 
  
void EARLY_NY_SL_SG()
  {
   TimeToStruct(Global.date1 = TimeCurrent(),str1);  // em datetime
   // saidas Long
   if(Signals.LongPosition)
     {      
     
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
            Debug(" Fechamento de operação de compra EARLY_NY por Breakeven ");}
            
            return;      
           }  
         }  // fim da saida por Breakeven        
        
      if(str1.hour == Global.hour_NY && str1.min >= EARLY_NY_Time_Exit_Long ) 
        {
         CloseLongPosition(); 
         if(Strategy.Debug){
         Debug(" Saida EARLY_NY long "); }
         return;    
        }  
     }
   // saidas Short  
   if(Signals.ShortPosition)
     {      
         
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
            Debug(" Fechamento de operação de venda SQUEEZE por Breakeven ");}
            
            return;      
           }  
         }  // fim da saida por Breakeven short  

      if(str1.hour == Global.hour_NY && str1.min >= EARLY_NY_Time_Exit_Short ) 
        {
         CloseShortPosition();  
         if(Strategy.Debug){
         Debug(" Saida EARLY_NY short "); }
         return;    
        }  
     }  
   
  }   // fim da EARLY_NY_SL_SG()    
  
  
  
//+------------------------------------------------------------------+
//| Breakeven                                                        |
//+------------------------------------------------------------------+
// Verifica o drawdown dos ganhos na trade long
bool Breakeven_Long()
  {
   Buffers();
   if(mrate[0].close > (Global.price_trade_start + Breakeven_long_enter) )
     {
      Global_Set("Breakeven_mode",TRUE);
      return true;
     }
   
   return false;
  }
// Verifica o drawdown dos ganhos na trade short
bool Breakeven_Short()
  {
   Buffers();
   if(mrate[0].close < (Global.price_trade_start - Breakeven_short_enter) )
     {
      Global_Set("Breakeven_mode",TRUE);
      return true;
     }
   
   return false;
  }  
    
  
  
//+------------------------------------------------------------------+