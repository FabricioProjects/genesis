//-------------------------------------------------------------------+
//|                                                  dod_Genesis.mq5 |
//|                       dod - Robôs Investidores / Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014 - 2015, dod - Robôs Investidores / Fabrício Amaral"
#property link      "http://executive.com.br/"
#property version   "2.1"

// Standard Libraries
#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\PositionInfo.mqh> 
// Genesis Libraries
#include "dodLibStructArgs.mqh"
#include "dodLibArgs_Akira_WIN.mqh"
#include "dodLibTrade.mqh"
#include "dodLibDebug.mqh"
#include "dodLibMisc.mqh"
#include "dodLib_RiskControl_Akira.mqh"
#include "dodLibGLOBAL.mqh"
#include "dodLib_CS_Control.mqh"
#include "dodLib_CS_Analysis.mqh"
#include "dodLib_CANDLESTICKS_P15.mqh"

// Opcionais
#include "dodLib_CS_Indicators.mqh"
//#include "dodLibMA_Control.mqh"


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
// definições globais, feitas somente uma vez
int OnInit()
  { 
   // Disponibilidade de barras e sincronização.             ##dodLibMisc##
   Misc();   
   // Gerenciamento de estrategias e sub-estrategias.        ##dodLibArgs##            
   Strategy_Manager();   
   // Booleanos Signal.                                      ##dodLibArgs##
   Args_Init();  
   // Definição das variáveis globais.                       ##dodLibArgs##        
   Global_Var();    
   // Call, Indexação, Séries - indicadores.                 ##dodLibIndicators##     
   Indicators_CS();
//   Indicators_PERIOD_M5();
   // Dados sobre a conta, ativo                             ##dodLibMisc##
   AccountInfo();     
   SymbolInfo(); 
   // Inicialização do set de arquivos que compôe o Debug.   ##dodLibDebug##    
   Debug_Set_Init();     

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Indicators_Release_CS();
//   Indicators_Release_PERIOD_M5();
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
 {   
  Global.prev_unixtime = Global.tick_unixtime; 
  // tempo do tick para toda a rotina Ontick  
  TimeToStruct(Global.date1 = TimeCurrent(),str1);    // em datetime
  Global.tick_unixtime = TimeCurrent();               // em unixtime
  // controle de delay entre ticks
  if(!Strategy.Simulation)
  {
   if((long)Global.prev_unixtime + 30 <= (long)Global.tick_unixtime) 
     {
      Debug_Tick_Control(" Delay de mais de 30 segundos entre 2 ticks!! ");
     }
  }   
  // Controle de datas nao consideradas nas otimizações e horario de verao NY  
  Date_Control();               // ##dodLibMisc##
  // Faz o Reset diário                                 
  Reset();                      // ##dodLibMisc##
  // O Genesis nao opera caso o dia abra com uma GAP acima de GAP_Range            
  GAP_Control();                // ##dodLibMisc##
  // Aloca o Opening Range - OR
  //OR();                         // ##dodLibMisc##
  
  
//+------------------------------------------------------------------+
//| SUB-ESTRATÉGIA RISK_CONTROL                                      |
//+------------------------------------------------------------------+
if(Strategy.Habilitar_Risk_Control && PositionSelect(Ativo) )
  {
   RISK_CONTROL(); 
  }   
    
// Reseta os sinais para saidas manuais.            
  TradeSignal_Reset_Akira();  // ##dodLibMisc##  
  
//+------------------------------------------------------------------+
//| ESTRATÉGIA CANDLESTICKS_P15                                      |
//+------------------------------------------------------------------+
if(   Strategy.Habilitar_CANDLESTICKS_P15
   && (long)TimeCurrent() > ((long)Global.finalize_unixtime + 60) 
                                                                  )
  {  
   Estrategia_CANDLESTICKS_P15();
  }   
  
//+------------------------------------------------------------------+
//| PATTERN FINAL RESULTS                                            |
//+------------------------------------------------------------------+   
if(Strategy.Simulation && !Signals.final_results)
  {
   // data da saida da estatistica final
   if(   (    str1.year == 2015  && str1.mon == 07  && str1.day == 02 
          ||  str1.year == 2014  && str1.mon == 09  && str1.day == 01 
                                                                      )
      &&  str1.hour == 17    && str1.min == 45  && str1.sec == 0       )  
     {
      Pattern_Final_Results();
      Signals.final_results = true;
     }
  }
  
  
 }   // fim da OnTick




  