//+------------------------------------------------------------------+
//|                                                                  |
//|                            Copyright 2014-2015, Fabrício Amaral  |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

/* DLL/* 
#import "AmazonSQS.dll"
  int SendMessageSQS(string DevKey, string SecretKey, string QueueName, string Msg, string Region);
#import 
/* DLL*/

//+------------------------------------------------------------------+
//| Pre Defined Structs                                              |
//+------------------------------------------------------------------+
// Interaction between the client terminal and a trade server for sending our trade requests.
MqlTradeRequest     mrequest; 
// As result of a trade request, a trade server returns data about the trade request processing result.
MqlTradeResult      mresult;  
// Before sending a request for a trade operation to a trade server, it is recommended to check it.
MqlTradeCheckResult mcheck; 
// Information about the prices, volumes and spread of each candle. 
MqlRates            mrate[];  
// The date type structure contains eight fields of the int type. 
MqlDateTime         str1;
 
//+------------------------------------------------------------------+
//| CTrade_Buy                                                       |
//+------------------------------------------------------------------+
void CTrade_Buy()   
  {
//--- number of decimal places
   int    digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
//--- point value
   double point=SymbolInfoDouble(_Symbol,SYMBOL_POINT);
//--- receiving a buy price
   double price=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
//--- calculate and normalize SL and TP levels
   double SL=NormalizeDouble(price-1000*point,digits);
   double TP=NormalizeDouble(price+1000*point,digits);
//--- filling comments
   string comment="Trade "+_Symbol+" "+Global.contratos+" at "+DoubleToString(price,digits);
   Debug(" "+comment);
   
   if(!Signals.ShortPosition)
     {
      Global.price_trade_start = DoubleToString(price,digits);
     }
   else
     {  
      Global.price_trade_stop = DoubleToString(price,digits);
     }
  }
  
//+------------------------------------------------------------------+
//| CTrade_Sell                                                      |
//+------------------------------------------------------------------+
void CTrade_Sell()   
  {
//--- number of decimal places
   int    digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
//--- point value
   double point=SymbolInfoDouble(_Symbol,SYMBOL_POINT);
//--- receiving a sell price
   double price=SymbolInfoDouble(_Symbol,SYMBOL_BID);
//--- calculate and normalize SL and TP levels
   double SL=NormalizeDouble(price-1000*point,digits);
   double TP=NormalizeDouble(price+1000*point,digits);
//--- filling comments
   string comment="Trade "+_Symbol+" "+Global.contratos+" at "+DoubleToString(price,digits);
   Debug(" "+comment);
   
   if(!Signals.LongPosition)
     {
      Global.price_trade_start = DoubleToString(price,digits);
     }
   else
     {  
      Global.price_trade_stop = DoubleToString(price,digits);
     }
  }  
     
   
//+------------------------------------------------------------------+
//| Open Long position                                               |
//+------------------------------------------------------------------+
void OpenLongPosition()
  {
   CTrade  trade;
  //--- buying at the current symbol
   if(!trade.Buy(Global.contratos))
     {
      Debug(" Buy() method failed. Return code= "+trade.ResultRetcode()+
            ". Descrição do código: "+trade.ResultRetcodeDescription());
      return;
     }
   else
     {
      Debug(" Buy() method executed successfully. Return code= "+trade.ResultRetcode()+
            " ("+trade.ResultRetcodeDescription()+")");
       
      CTrade_Buy();  // Check for information
      
      // Mecanismo de segurança para ter certeza q a corretora atualizou a posição da trade
      int i=0,j=50000000;
      uint time_init,time_end,time_delay;
      do
        {
         if(Strategy.Debug && i==0)
           {
            time_init = GetTickCount();
           }
         if(PositionSelect(Ativo))
           {
            time_end = GetTickCount();
            time_delay = time_end - time_init;
            break;
           }
         i++; 
        }
      while(i<j);
      
      if(PositionSelect(Ativo))
        {
         if(Strategy.Debug){
         Debug(" Entrada long, PositionSelect() = "+PositionSelect(Ativo)+", Delay = "+time_delay+" milisec");} 
        }
      else  // caso complete o loop inteiro...
        {  
         time_end = GetTickCount();
         time_delay = time_end - time_init;
         Alert(" Tentativa de Entrada Long com Latencia Alta!!!!!!!  Delay = "+time_delay+" milisec");
         Debug_Alert(" Tentativa de Entrada Long com Latencia Alta!!!!!!!  Delay = "+time_delay+" milisec");
         return;
        }    
       
      Signals.LongPosition = true;    
      // hint de entrada long em produção
      if(!Strategy.Simulation) 
        {    
         Global.tm = TimeCurrent();
         Global.initialize_datetime = Global.tm;
         Global.initialize_unixtime = TimeCurrent();  // tempo em unixtime de inicio de operação long
                
         Hints_Enter_Long( "#1|INITIALIZE UNIXTIME\t"
                          +"2|INITIALIZE DATETIME\t"
                          +"3|FINALIZE UNIXTIME\t"
                          +"4|FINALIZE DATETIME\t"
                          +"5|DIRECTION\t"
                          +"6|STATUS\t"
                          +"7|BUY PRICE\t"
                          +"8|SELL PRICE\t"
                          +"9|STOP LOSS\t"
                          +"10|STOP GAIN\t"
                          +"11|QUANTITY\t"
                          +"12|TICKS"
                          +"\n"
                          +((long)Global.initialize_unixtime + 10800)+"\t"  // O marketcetera espera um timestamp em GMT
                          +Global.initialize_datetime+"\t"
                          +"NULL"+"\t"
                          +"NULL"+"\t"
                          +"NULL"+"\t"
                          +"LONG\t"
                          +"NULL"+"\t"
                          +Global.price_trade_start+"\t"
                          +"NULL"+"\t"
                          +"NULL\t"+
                          "NULL\t"
                          +Global.contratos+"\t"
                          +"NULL\t"       ); 
                                                            
        } 
      else
        {
         Global.tm = TimeCurrent();
         Global.initialize_datetime = Global.tm;
         Global.initialize_unixtime = TimeCurrent();  // tempo em unixtime de inicio de operação long
        }      
     }
       
    // commission emulation
    if(Strategy.Simulation) 
      {
       double commission = 2*Global.contratos;
       TesterWithdrawal(commission);
      }   
       
  } // fim da OpenLongPosition

//+------------------------------------------------------------------+
//| Open Short position                                              |
//+------------------------------------------------------------------+
void OpenShortPosition()
  {
  CTrade  trade;
  //--- 1. example of buying at the current symbol
   if(!trade.Sell(Global.contratos))
     {
      //--- failure message
      Debug(" Sell() method failed. Return code= "+trade.ResultRetcode()+
            ". Descrição do código: "+trade.ResultRetcodeDescription());
     }
   else
     {
      Debug(" Sell() method executed successfully. Return code= "+trade.ResultRetcode()+
            " ("+trade.ResultRetcodeDescription()+")");
     
      CTrade_Sell();  // Check for information
      
      // Mecanismo de segurança para ter certeza q a corretora atualizou a posição da trade
      int i=0,j=50000000;
      uint time_init,time_end,time_delay;
      do
        {
         if(Strategy.Debug && i==0)
           {
            time_init = GetTickCount();
           }
         if(PositionSelect(Ativo))
           {
            time_end = GetTickCount();
            time_delay = time_end - time_init;
            break;
           }
         i++; 
        }
      while(i<j);
      
      if(PositionSelect(Ativo))
        {
         if(Strategy.Debug){
         Debug(" Entrada short, PositionSelect() = "+PositionSelect(Ativo)+", Delay = "+time_delay+" milisec");} 
        }
      else  // caso complete o loop inteiro...
        {  
         time_end = GetTickCount();
         time_delay = time_end - time_init;
         Alert(" Tentativa de Entrada Short com Latencia Alta!!!!!!!  Delay = "+time_delay+" milisec");
         Debug_Alert(" Tentativa de Entrada Short com Latencia Alta!!!!!!!  Delay = "+time_delay+" milisec");
         return;
        }  
      
      Signals.ShortPosition = true;    
      // hint de entrada long em produção
      if(!Strategy.Simulation) 
        {    
         Global.tm = TimeCurrent();
         Global.initialize_datetime = Global.tm;
         Global.initialize_unixtime = TimeCurrent();  // tempo em unixtime de inicio de operação long
                
         Hints_Enter_Short( "#1|INITIALIZE UNIXTIME\t"
                          +"2|INITIALIZE DATETIME\t"
                          +"3|FINALIZE UNIXTIME\t"
                          +"4|FINALIZE DATETIME\t"
                          +"5|DIRECTION\t"
                          +"6|STATUS\t"
                          +"7|BUY PRICE\t"
                          +"8|SELL PRICE\t"
                          +"9|STOP LOSS\t"
                          +"10|STOP GAIN\t"
                          +"11|QUANTITY\t"
                          +"12|TICKS"
                          +"\n"
                          +((long)Global.initialize_unixtime + 10800)+"\t"  // O marketcetera espera um timestamp em GMT
                          +Global.initialize_datetime+"\t"
                          +"NULL"+"\t"
                          +"NULL"+"\t"
                          +"NULL"+"\t"
                          +"SHORT\t"
                          +"NULL"+"\t"
                          +"NULL"+"\t"
                          +Global.price_trade_start+"\t"
                          +"NULL\t"+
                          "NULL\t"
                          +Global.contratos+"\t"
                          +"NULL\t"       ); 
                                            
       } 
     else
        {
         Global.tm = TimeCurrent();
         Global.initialize_datetime = Global.tm;
         Global.initialize_unixtime = TimeCurrent();  // tempo em unixtime de inicio de operação long
        }                
     } 
     
    // commission emulation
    if(Strategy.Simulation) 
      {
       double commission = 2*Global.contratos;
       TesterWithdrawal(commission);
      }   
      
  } // fim da OpenShortPosition

//+------------------------------------------------------------------+
//| Close Long position                                              |
//+------------------------------------------------------------------+
void CloseLongPosition()
  {
   CTrade  trade;
   //--- closing a position at the current symbol
   if(!trade.PositionClose(_Symbol))
     {
      //--- failure message
      Debug(" PositionClose() method failed. Return code= "+trade.ResultRetcode()+
            ". Descrição do código: "+trade.ResultRetcodeDescription());
     }
   else
     {
      Debug(" PositionClose() method executed successfully. Return code="+trade.ResultRetcode()+
            " ("+trade.ResultRetcodeDescription()+")");
          
      CTrade_Sell();       
      Global.tm = TimeCurrent();
      Global.finalize_datetime = Global.tm;
      Global.finalize_unixtime = TimeCurrent();  // tempo em unixtime de termino de operação long
      if(Global.price_trade_stop > Global.price_trade_start)
        {
         Global.status = "GAIN";
        }
      else
        {
         Global.status = "LOSS";
        }
      
      if(Strategy.Simulation) 
        { 
         Hints( Global.initialize_unixtime+"\t"
               +Global.initialize_datetime+"\t"
               +Global.finalize_unixtime+"\t"
               +Global.finalize_datetime+"\t"
               +"LONG\t"
               +Global.status+"\t"
               +Global.price_trade_start+"\t"
               +Global.price_trade_stop+"\t"
               +"null\t"
               +"null\t"
               +Global.contratos+"\t"
               +"null\t"         );
        } 
      // hint de saida long em produção
      if(!Strategy.Simulation) 
        {                 
         Hints(  "#1|INITIALIZE UNIXTIME\t"
                +"2|INITIALIZE DATETIME\t"
                +"3|FINALIZE UNIXTIME\t"
                +"4|FINALIZE DATETIME\t"
                +"5|DIRECTION\t"
                +"6|STATUS\t"
                +"7|BUY PRICE\t"
                +"8|SELL PRICE\t"
                +"9|STOP LOSS\t"
                +"10|STOP GAIN\t"
                +"11|QUANTITY\t"
                +"12|TICKS"
                +"\n"
                +((long)Global.initialize_unixtime + 10800)+"\t"  // O marketcetera espera um timestamp em GMT
                +Global.initialize_datetime+"\t"
                +((long)Global.finalize_unixtime + 10800)+"\t"    // O marketcetera espera um timestamp em GMT
                +Global.finalize_datetime+"\t"
                +"LONG\t"
                +Global.status+"\t"
                +Global.price_trade_start+"\t"
                +Global.price_trade_stop+"\t"
                +"NULL\t"
                +"NULL\t"
                +Global.contratos+"\t"
                +"NULL\t"         );
                     
        }                         
     }
     
    // Mecanismo de segurança para ter certeza q a corretora atualizou a posição da trade
    int i=0,j=10000000;
    uint time_init,time_end,time_delay;
    do
      {
       if(Strategy.Debug && i==0)
         {
          time_init = GetTickCount();
         }
       if(!PositionSelect(Ativo))
         {
          time_end = GetTickCount();
          time_delay = time_end - time_init;
          break;
         }
       i++; 
      }
    while(i<j);
    if(Strategy.Debug && !PositionSelect(Ativo)){
    Debug(" Saida long, PositionSelect() = "+PositionSelect(Ativo)+", Delay = "+time_delay+" milisec"); }
    // caso complete o loop inteiro...
    if(Strategy.Debug && PositionSelect(Ativo)) 
      {
       time_end = GetTickCount();
       time_delay = time_end - time_init;
       Alert(" Saida Long com Latencia Alta!!!!!!!  Delay = "+time_delay+" milisec");
       Debug(" Saida Long com Latencia Alta!!!!!!!  Delay = "+time_delay+" milisec");
      }  
       
  } // fim da CloseLongPosition
      
//+------------------------------------------------------------------+
//| Close Short position                                             |
//+------------------------------------------------------------------+
void CloseShortPosition()
  {
   CTrade  trade;
   //--- closing a position at the current symbol
   if(!trade.PositionClose(_Symbol))
     {
      //--- failure message
      Debug(" PositionClose() method failed. Return code= "+trade.ResultRetcode()+
            ". Descrição do código: "+trade.ResultRetcodeDescription());
     }
   else
     {
      Debug(" PositionClose() method executed successfully. Return code="+trade.ResultRetcode()+
            " ("+trade.ResultRetcodeDescription()+")");
            
      CTrade_Buy();       
      Global.tm = TimeCurrent();
      Global.finalize_datetime = Global.tm;
      Global.finalize_unixtime = TimeCurrent();  // tempo em unixtime de termino de operação long
      if(Global.price_trade_stop < Global.price_trade_start)
        {
         Global.status = "GAIN";
        }
      else
        {
         Global.status = "LOSS";
        }
      
      if(Strategy.Simulation) 
        { 
         Hints( Global.initialize_unixtime+"\t"
               +Global.initialize_datetime+"\t"
               +Global.finalize_unixtime+"\t"
               +Global.finalize_datetime+"\t"
               +"SHORT\t"
               +Global.status+"\t"
               +Global.price_trade_start+"\t"
               +Global.price_trade_stop+"\t"
               +"null\t"
               +"null\t"
               +Global.contratos+"\t"
               +"null\t"         );
        } 
      // hint de saida long em produção
      if(!Strategy.Simulation) 
        {                     
         Hints(  "#1|INITIALIZE UNIXTIME\t"
                +"2|INITIALIZE DATETIME\t"
                +"3|FINALIZE UNIXTIME\t"
                +"4|FINALIZE DATETIME\t"
                +"5|DIRECTION\t"
                +"6|STATUS\t"
                +"7|BUY PRICE\t"
                +"8|SELL PRICE\t"
                +"9|STOP LOSS\t"
                +"10|STOP GAIN\t"
                +"11|QUANTITY\t"
                +"12|TICKS"
                +"\n"
                +((long)Global.initialize_unixtime + 10800)+"\t"  // O marketcetera espera um timestamp em GMT
                + Global.initialize_datetime+"\t"
                +((long)Global.finalize_unixtime + 10800)+"\t"    // O marketcetera espera um timestamp em GMT
                +Global.finalize_datetime+"\t"
                +"SHORT\t"
                +Global.status+"\t"
                +Global.price_trade_stop+"\t"
                +Global.price_trade_start+"\t"
                +"NULL\t"
                +"NULL\t"
                +Global.contratos+"\t"
                +"NULL\t"         );
                      
        }                         
     } 
     
    // Mecanismo de segurança para ter certeza q a corretora atualizou a posição da trade
    int i=0,j=100000000;
    uint time_init,time_end,time_delay;
    do
      {
       if(Strategy.Debug && i==0)
         {
          time_init = GetTickCount(); 
         }
       if(!PositionSelect(Ativo))
         {
          time_end = GetTickCount();
          time_delay = time_end - time_init;
          break;
         }
       i++; 
      }
    while(i<j);
    if(Strategy.Debug && !PositionSelect(Ativo)){
    Debug(" Saida short, PositionSelect() = "+PositionSelect(Ativo)+", Delay = "+time_delay+" milisec"); }
    // caso complete o loop inteiro...
    if(Strategy.Debug && PositionSelect(Ativo)) 
      {
       time_end = GetTickCount();
       time_delay = time_end - time_init;
       Alert(" Saida Short com Latencia Alta!!!!!!!  Delay = "+time_delay+" milisec");
       Debug(" Saida Short com Latencia Alta!!!!!!!  Delay = "+time_delay+" milisec");
      }  
      
  } // fim da CloseShortPosition
  
  

//+------------------------------------------------------------------+




