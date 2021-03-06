//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| Miscelânea                                                       |
//+------------------------------------------------------------------+
void Misc()
  {
   // Verificação de disponibilidade de barras.
   int bars = Bars(Ativo,PERIOD_M15);
   int bars_P5 = Bars(Ativo,PERIOD_M5);
   if(bars > 0 && bars_P5 >0)
     { 
      if(Strategy.Debug){
      Debug(" Number of bars for the symbol-period 15/5 at the moment = "+bars+"/"+bars_P5); }       
     }
   else  // Sem barras disponíveis
     {
      // Dados sobre o ativo podem não estar sincronizados com os dados no servidor
      bool synchronized = false;
      // Contador de loop
      int attempts = 0;
      // Faz 5 tentativas de espera por sincronização
      while(attempts < 5)
        {
         if(SeriesInfoInteger(Ativo,0,SERIES_SYNCHRONIZED))
           {
            // Sincronização feita, sair
            synchronized = true;
            break;
           }
         // Aumentar o contador
         attempts++;
         // Espera 10 milissegundos até a próxima iteração
         Sleep(10);
        }
      // Sair do loop após sincronização
      if(synchronized)
        {
         if(Strategy.Debug)
           {
            Debug(" Number of bars for the symbol-period 15/5 at the moment = "+bars+"/"+bars_P5); 
            Debug("The first date in the terminal history for the symbol-period at the moment = "+
                 (datetime)SeriesInfoInteger(Ativo,0,SERIES_FIRSTDATE));     
            Debug("The first date in the history for the symbol on the server = "+
                 (datetime)SeriesInfoInteger(Ativo,0,SERIES_SERVER_FIRSTDATE));  
           }   
        }
      // Sincronização dos dados não aconteceu
      else
        {
         Debug_Alert(" Failed to get number of bars for "+Ativo);   
        }
     }
   
   // Do we have sufficient bars to work?
   if(bars < 61) // total number of bars is less than 61?
     {
      Debug_Alert(" We have less than 61 bars on the chart, an Expert Advisor terminated!! ");   
     }
  }

//+------------------------------------------------------------------+
//| RESET                                                            |
//+------------------------------------------------------------------+   
void Reset()
  {
  // Reseta as sub-estrategias_once a cada começo de dia - necessario em simulações
  if(Strategy.Simulation)
    {
     // Impetus
     if(str1.hour == 09 && str1.min > 45 )
       {
        Signals.EARLY_unixtime_reset = false;
        Signals.EARLY_delay = false;
        Global_Set("EARLY_once",FALSE);
       }   
     if(str1.hour == 13 && str1.min > 00 )
       {
        Signals.EARLY_NY_unixtime_reset = false;
        Signals.EARLY_NY_delay = false;
        Global_Set("EARLY_NY_once",FALSE);
       }     
     if(str1.hour == 9 && str1.min == 0)
       {     
        // Genesis  
        Signals.ACD_Once = false;
        Signals.STOCH2_Once = false;
        Signals.STOCH1_Once = false;
        Signals.EARLY_delay = true;
        Signals.OR = false;
        // Nature
//        Global_Set("SQUEEZE_mode",FALSE);
        Global_Set("SQUEEZE_Once",FALSE);
        Global_Set("SQUEEZE_long",FALSE);
        Global_Set("SQUEEZE_short",FALSE);
        Global_Set("SQUEEZE_HEAD_Once",FALSE);
        Signals.Head_Allowed = false;
        Signals.Double_Lots = false;
        Signals.Triple_Lots = false;
//        Global_Set("SQUEEZE_P5_mode",FALSE);
//        Global_Set("SQUEEZE_P5_Once",FALSE);
        // Akira
        Global_Set("CANDLESTICKS_P15_Once",FALSE);
        Global.high_candle_stop = 0;
        Global.low_candle_stop = 0;
        Signals.high_candle_stop_once = false;         // stop na maxima do padrão de candle
        Signals.low_candle_stop_once = false;          // stop na minima do padrao candle
        // Sub-estratégias
        Global_Set("MA_mode_20",FALSE);
        Global_Set("MA_mode_50",FALSE);
        Global_Set("MA_mode_200",FALSE);
        // serve para alocar o EARLY_unixtime somente uma vez
        if(!Signals.EARLY_unixtime_reset)    
          {
           Global.EARLY_unixtime = TimeCurrent();
           Signals.EARLY_unixtime_reset = true;
          }
       }
          
     if(str1.hour == Global.hour_NY && str1.min == Global.min_NY)
       {     
        Signals.EARLY_NY_delay = true;
        // serve para alocar o EARLY_unixtime somente uma vez
        if(!Signals.EARLY_NY_unixtime_reset)     
          {
           Global.EARLY_NY_unixtime = TimeCurrent();
           Signals.EARLY_NY_unixtime_reset = true;
          }  
       }
    }       
     
  // Alocando o booleano do Opening Range (OR) e EARLY_delay em produção ...
  // ... e reseta booleanos de sub-estrategias
  if(!Strategy.Simulation)
    {
     // reseta para o dia posterior
     if(str1.hour == 17 && str1.min > 45 )
       {
        Signals.OR = false;
       }    
     // reseta para o mesmo dia
     if(str1.hour == 9 && str1.min == 0)    
       {
        // Genesis
        Signals.ACD_Once = false;
        Signals.STOCH2_Once = false;
        Signals.STOCH1_Once = false;
        Signals.OR = false;
        // Nature
        Global_Set("SQUEEZE_mode",FALSE);
        Global_Set("SQUEEZE_Once",FALSE);
        Global_Set("SQUEEZE_long",FALSE);
        Global_Set("SQUEEZE_short",FALSE);
        Global_Set("SQUEEZE_HEAD_Once",FALSE);
        Signals.Head_Allowed = false;
        Signals.Triple_Lots = false;
//        Global_Set("SQUEEZE_P5_mode",FALSE);
//        Global_Set("SQUEEZE_P5_Once",FALSE);
        // Akira
        Global_Set("CANDLESTICKS_P15_Once",FALSE);
        Global.high_candle_stop = 0;
        Global.low_candle_stop = 0;
        Signals.high_candle_stop_once = false;         // stop na maxima do padrão de candle
        Signals.low_candle_stop_once = false;          // stop na minima do padrao candle
        // Sub-estratégias
        Global_Set("MA_mode_20",FALSE);
        Global_Set("MA_mode_50",FALSE);
        Global_Set("MA_mode_200",FALSE);
       }
     // reseta para o dia seguinte  
     if(str1.hour == 9 && str1.min > 45 )    
       {
        Global_Set("EARLY_once",FALSE);
        Signals.EARLY_delay = false;
//        Signals.OR = false;
       }
     // reseta para o dia seguinte  
     if(str1.hour == 13 && str1.min >= 00 )    
       {     
        Global_Set("EARLY_NY_once",FALSE); 
        Signals.EARLY_NY_delay = false;
       }  
     if(!Signals.OR && !Signals.EARLY_delay)
       {
        if(str1.hour == 9 && str1.min == 0 )
          {
           Signals.EARLY_delay = true;
           Global.EARLY_unixtime = TimeCurrent();           
          }
       }
     if(!Signals.EARLY_NY_delay)
       {
        if(str1.hour == Global.hour_NY && str1.min == Global.min_NY )
          {
           Signals.EARLY_NY_delay = true;
           Global.EARLY_NY_unixtime = TimeCurrent();           
          }
       }  
    }      
  } 
  
//+------------------------------------------------------------------+
//| OPENING RANGE                                                    |
//+------------------------------------------------------------------+     
void OR()
  {  
   // alocação do OR diário para a estratégia ACD
   if(!Signals.OR)
     {   
      if(str1.hour == 9 && str1.min == 31)
        {
         if(CopyRates(Ativo,PERIOD_M30,0,2,mrate) < 0)
           {
            Debug_Alert(" OR - Error copying M30 rates - error: "+GetLastError() ); 
            ResetLastError();
            return;
           }      
         Global.ORmax = mrate[1].high;  
         if(Strategy.Debug){
         Debug(" Opening Range superior: "+Global.ORmax); }

         Global.ORmin = mrate[1].low; 
         if(Strategy.Debug){
         Debug(" Opening Range inferior: "+Global.ORmin); }
     
         Signals.OR = true;
        }
     }  

  } // fim da OR()
  
  
  
//+------------------------------------------------------------------+
//| DATE CONTROL                                                     |
//+------------------------------------------------------------------+   
void Date_Control()
  {  
   if(Strategy.Habilitar_DATE_Control)
     {
      // controle de datas nao consideradas nas otimizações
      if(    str1.year == 2013 && str1.mon == 02
         &&  str1.day == 13   
         &&  str1.hour == 13 && str1.min == 00   )  
        {
         Strategy_Manager_False();
        }
      // controle de datas nao consideradas nas otimizações
      if(    str1.year == 2014 && str1.mon == 03
         &&  str1.day == 5   
         &&  str1.hour == 13 && str1.min == 00   )  
        {
         Strategy_Manager_False();
        }  
      // controle de datas nao consideradas nas otimizações
      if(    str1.year == 2015 && str1.mon == 02
         &&  str1.day == 18   
         &&  str1.hour == 13 && str1.min == 00   )  
        {
         Strategy_Manager_False();
        }  
          
      // dias de jogos do brasil em junho WC 2014
      if(    str1.year == 2014 && str1.mon == 06 
         && (str1.day == 12 || str1.day == 17 || str1.day == 23)   
         &&  str1.hour == 09 && str1.min == 00   )  
        {
         Strategy_Manager_False();
        }
      // dias de jogos do brasil em julho WC 2014
      if(    str1.year == 2014 && str1.mon == 07 
         && (str1.day == 04 || str1.day == 08 )   
         &&  str1.hour == 09 && str1.min == 00 )  
        {
         Strategy_Manager_False();
        }
      // reseta para o dia seguinte 
      if(   str1.hour == TimeExitHour 
         && str1.min == TimeExitMin +1 ) 
        {
         Strategy_Manager();
        }  
   
      // controle do horario de verao para a estrategia early_NY  
      // 2013.10.20 - 2013.11.03  11:30
      if(   str1.year == 2013 && str1.mon == 10 && str1.day >= 20   
         || str1.year == 2013 && str1.mon == 11 && str1.day <= 03 )  
        {
         //  EUA = true  BR = true : 11:30
         Global.hour_NY = 11;
         Global.min_NY = 30;
        }  
      // 2013.11.04 - 2014.02.15  12:30
      if(   str1.year == 2013 && str1.mon == 11 && str1.day >= 04 
         || str1.year == 2013 && str1.mon == 12 || str1.year == 2014 && str1.mon == 01 
         || str1.year == 2014 && str1.mon == 02 && str1.day <= 15   )  
        {
         //  EUA = false  BR = true : 12:30
         Global.hour_NY = 12;
         Global.min_NY = 30;
        }    
      // 2014.02.16 - 2014.03.10  11:30
      if(   str1.year == 2014 && str1.mon == 02 && str1.day >= 16 
         || str1.year == 2014 && str1.mon == 03 && str1.day <= 10 )  
        {
         //  EUA = false  BR = false : 11:30
         Global.hour_NY = 11;
         Global.min_NY = 30;
        }     
      // 2014.03.11 - 2014.10.18  10:30
      if(   str1.year == 2014 && str1.mon == 03 && str1.day >= 11 
         || str1.year == 2014 && str1.mon >= 04 && str1.year == 2014 && str1.mon <= 09 
         || str1.year == 2014 && str1.mon == 10 && str1.day <= 18  )  
        {
         //  EUA = true  BR = false : 10:30
         Global.hour_NY = 10;
         Global.min_NY = 30;
        }       
      // 2014.10.19 - 2014.11.03  11:30
      if(   str1.year == 2014 && str1.mon == 10 && str1.day >= 19 
         || str1.year == 2014 && str1.mon == 11 && str1.day <= 03  )  
        {
         //  EUA = true  BR = true : 11:30
         Global.hour_NY = 11;
         Global.min_NY = 30;
        }    
      // 2014.11.04 - 2015.02.21  12:30
      if(   str1.year == 2014 && str1.mon == 11 && str1.day >= 04 
         || str1.year == 2014 && str1.mon == 12 || str1.year == 2015 && str1.mon == 01 
         || str1.year == 2015 && str1.mon == 02 && str1.day <= 21  )  
        {
         //  EUA = false  BR = true : 12:30
         Global.hour_NY = 12;
         Global.min_NY = 30;
        }
      // 2015.02.21 - 2015.03.08  11:30
      if(   str1.year == 2015 && str1.mon == 02 && str1.day >= 21 
         || str1.year == 2015 && str1.mon == 03 && str1.day <= 8 )  
        {
         //  EUA = false  BR = false : 11:30
         Global.hour_NY = 11;
         Global.min_NY = 30;
        }  
      // 2015.03.09 - 2015.??.??  10:30
      if(   str1.year == 2015 && str1.mon == 03 && str1.day >= 9 
         || str1.year == 2015 && str1.mon >= 04 && str1.year == 2015 && str1.mon <= 09 
         || str1.year == 2015 && str1.mon == 10 && str1.day <= 18  )  
        {
         //  EUA = true  BR = false : 10:30
         Global.hour_NY = 10;
         Global.min_NY = 30;
        }               
               
     }
  }  // fim da date control
  
//+------------------------------------------------------------------+
//| GAP                                                              |
//+------------------------------------------------------------------+   
void GAP_Control()
  { 
   if(Strategy.Habilitar_GAP_Control)
     {
      // verifica se há GAP no começo do dia
      if((   str1.hour == 09 && str1.min == 00 
          || str1.hour == 09 && str1.min == 01
          || str1.hour == 09 && str1.min == 02 )
         && Signals.GAP_Low == false
         && Signals.GAP_High == false            ) 
        {
         if(CopyRates(Ativo,PERIOD_M15,0,2,mrate) < 0)
           {
            Debug_Alert(" Gap_Control - Error copying M15 rates - error: "+GetLastError() ); 
            ResetLastError();
            return;
           }  
         if(   mrate[0].open - mrate[1].low < 0 
            && mrate[0].open - mrate[1].low < (-GAP_Range) )
           {
            Signals.GAP_Low = true;
            if(Strategy.Debug){
            Debug(" GAP_Low = "+Signals.GAP_Low+
                  " GAP_Range > "+(-GAP_Range) ); }
           }
         if(   mrate[0].open - mrate[1].high > 0 
            && mrate[0].open - mrate[1].high > (GAP_Range) )
           {
            Signals.GAP_High = true;
            if(Strategy.Debug){
            Debug(" GAP_High = "+Signals.GAP_High+
                  " GAP_Range > "+(+GAP_Range) );  }
           } 
         // Com GAP acima do GAP_Range, o Genesis nao opera   
         if(Signals.GAP_Low || Signals.GAP_High)  
           {
            Strategy_Manager_False();
           }  
        }
      // reseta para o dia seguinte  
      if(   str1.hour == TimeExitHour 
         && str1.min == TimeExitMin +1 ) 
        {
         Strategy_Manager();
         Signals.GAP_Low = false;
         Signals.GAP_High = false;
        }  
     }
  }
  
//+------------------------------------------------------------------+
//| TRADING SIGNALS RESET                                            |
//+------------------------------------------------------------------+     
void TradeSignal_Reset_Genesis()
  {
   if(!PositionSelect(Ativo))
     {
      Signals.TradeSignal_STOCH1 = false;
      Signals.TradeSignal_STOCH2 = false;
      Signals.TradeSignal_ACD = false;
      Signals.ShortPosition = false;
      Signals.LongPosition = false;
      Global_Set("Breakeven_mode",FALSE);
     }
  }
  
void TradeSignal_Reset_Impetus()
  {
   if(!PositionSelect(Ativo))
     {
      Signals.TradeSignal_EARLY = false;
      Signals.TradeSignal_EARLY_NY = false;
      Global_Set("Breakeven_mode",FALSE);
      Signals.ShortPosition = false;
      Signals.LongPosition = false;
     }
  } 
  
void TradeSignal_Reset_Nature()
  {
   if(!PositionSelect(Ativo))
     {
      Global_Set("TradeSignal_SQUEEZE",FALSE);
      Global_Set("TradeSignal_SQUEEZE_HEAD",FALSE);
      Global_Set("TradeSignal_GAP",FALSE);
      Signals.TradeSignal_High_Volat = false;
//      Global_Set("TradeSignal_SQUEEZE_P5",FALSE);
      Global_Set("Breakeven_mode",FALSE);
      Signals.ShortPosition = false;
      Signals.LongPosition = false;
      Global.contratos = Lots;
     }
  }   
  
void TradeSignal_Reset_Akira()
  {
   if(!PositionSelect(Ativo))
     {
      Global_Set("TradeSignal_CANDLESTICKS_P15",FALSE);
      Signals.ShortPosition = false;
      Signals.LongPosition = false;
      Pattern_Signals_Reset();
     }
  } 
  
//+------------------------------------------------------------------+
//| PATTERN SIGNALS RESET                                            |
//+------------------------------------------------------------------+    
void Pattern_Signals_Reset() 
  {
   Signals.hammer = false;
   Signals.Inverted_Hammer = false;
   Signals.Bullish_Engulfing = false;
   Signals.Piercing_Pattern = false;
   Signals.Harami_Bullish = false;
   Signals.Morning_Star = false;
   
   Signals.Shooting_Star = false;
   Signals.Hanging_Man = false;
   Signals.Bearish_Engulfing = false;
   Signals.Dark_Cloud_Cover = false;
   Signals.Harami_Bearish = false;
   Signals.Evening_Star = false;
      
  }        
  
//+------------------------------------------------------------------+
//| ACCOUNT INFO                                                     |
//+------------------------------------------------------------------+
void AccountInfo()
  {
//--- object for working with the account
   CAccountInfo account;
//--- receiving the account number, the Expert Advisor is launched at
   long login=account.Login();
   Debug(" Login= "+login);
//--- clarifying account type
   ENUM_ACCOUNT_TRADE_MODE account_type=account.TradeMode();
//--- if the account is real, the Expert Advisor is stopped immediately!
   if(account_type==ACCOUNT_TRADE_MODE_REAL)
     {
      MessageBox("The Expert Advisor has been launched on a real account!");
//      return(-1);
     }
//--- displaying the account type    
   Debug(" Account type: "+EnumToString(account_type));
//--- clarifying if we can trade on this account
   if(account.TradeAllowed())
      Debug(" Trading on this account is allowed");
   else
      Debug(" Trading on this account is forbidden: you may have entered using the Investor password");
//--- clarifying if we can use an Expert Advisor on this account
   if(account.TradeExpert())
      Debug(" Automated trading on this account is allowed");
   else
      Debug(" Automated trading using Expert Advisors and scripts on this account is forbidden");
//--- clarifying if the permissible number of orders has been set
   int orders_limit=account.LimitOrders();
   if(orders_limit!=0)Debug(" Maximum permissible amount of active pending orders: "+orders_limit);
//--- displaying company and server names
   Debug(" "+account.Company()+" : server "+account.Server());
//--- displaying balance and current profit on the account in the end
   Debug(" Balance= "+account.Balance()+"  Profit= "+account.Profit()+"   Equity= "+account.Equity());
   Debug(" "+__FUNCTION__+"  completed"+"\n"); //---
  }       
  
//+------------------------------------------------------------------+
//| SYMBOL INFO                                                      |
//+------------------------------------------------------------------+
void SymbolInfo()
  {
//--- object for receiving symbol settings
   CSymbolInfo symbol_info;
//--- set the name for the appropriate symbol
   symbol_info.Name(_Symbol);
//--- receive current rates and display
   symbol_info.RefreshRates();
   Debug(" "+symbol_info.Name()+" ("+symbol_info.Description()+")"+
         "  Bid= "+symbol_info.Bid()+"   Ask= "+symbol_info.Ask());
//--- receive minimum freeze levels for trade operations
   Debug(" StopsLevel= "+symbol_info.StopsLevel()+" pips, FreezeLevel= "+
         symbol_info.FreezeLevel()+" pips");
//--- receive the number of decimal places and point size
   Debug(" Digits= "+symbol_info.Digits()+
         ", Point= "+DoubleToString(symbol_info.Point(),symbol_info.Digits()));
//--- spread info
   Debug(" SpreadFloat="+symbol_info.SpreadFloat()+", Spread(current)= "+
         symbol_info.Spread()+" pips");
//--- request order execution type for limitations
   Debug(" Limitations for trade operations: "+EnumToString(symbol_info.TradeMode())+
         " ("+symbol_info.TradeModeDescription()+")");
//--- clarifying trades execution mode
   Debug(" Trades execution mode: "+EnumToString(symbol_info.TradeExecution())+
         " ("+symbol_info.TradeExecutionDescription()+")");
//--- clarifying contracts price calculation method
   Debug(" Contract price calculation: "+EnumToString(symbol_info.TradeCalcMode())+
         " ("+symbol_info.TradeCalcModeDescription()+")");
//--- sizes of contracts
   Debug(" Standard contract size: "+symbol_info.ContractSize()+
         " ("+symbol_info.CurrencyBase()+")");
//--- minimum and maximum volumes in trade operations
   Debug(" Volume info: LotsMin= "+symbol_info.LotsMin()+"  LotsMax= "+symbol_info.LotsMax()+
         "  LotsStep= "+symbol_info.LotsStep());
//--- 
   Debug(" "+__FUNCTION__+"  completed"+"\n");
//---
   }
   
   
   
   
//+------------------------------------------------------------------+