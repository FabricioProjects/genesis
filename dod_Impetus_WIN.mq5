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
#include "dodLibArgs_Impetus_WIN.mqh"
#include "dodLibTrade.mqh"
#include "dodLibDebug.mqh"
#include "dodLibIndicators.mqh"
#include "dodLibMisc.mqh"
#include "dodLib_RiskControl_Impetus.mqh"
#include "dodLibEARLY.mqh"
#include "dodLibGLOBAL.mqh"
//#include "dodLibMA_Control.mqh"
// DEV



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
   Indicators_PERIOD_M15();
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
   Indicators_Release_PERIOD_M15();
//   Indicators_Release_PERIOD_M5();
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
 {   
  // tempo do tick para toda a rotina Ontick  
  TimeToStruct(Global.date1 = TimeCurrent(),str1);    // em datetime
  Global.tick_unixtime = TimeCurrent();               // em unixtime
  
  // Controle de datas nao consideradas nas otimizações e horario de verao NY  
  Date_Control();       // ##dodLibMisc##
  // Faz o Reset diário                                 
  Reset();              // ##dodLibMisc##
  // O Genesis nao opera caso o dia abra com uma GAP acima de GAP_Range            
  GAP_Control();        // ##dodLibMisc##
  
//+------------------------------------------------------------------+
//| SUB-ESTRATÉGIA RISK_CONTROL                                      |
//+------------------------------------------------------------------+
if(Strategy.Habilitar_Risk_Control && PositionSelect(Ativo) )
  {
   RISK_CONTROL(); 
  }   
 
/*  
//+------------------------------------------------------------------+
//| SUB-ESTRATÉGIA MA_CONTROL                                        |
//+------------------------------------------------------------------+
if(Strategy.Habilitar_MA_Control )
  {
   MA_Control_20(); 
   MA_Control_50(); 
   MA_Control_200(); 
  }  
*/   
    
// Reseta os sinais para saidas manuais.            
  TradeSignal_Reset_Impetus();  // ##dodLibMisc##  

//+------------------------------------------------------------------+
//| ESTRATÉGIA EARLY                                                 |
//+------------------------------------------------------------------+
if(Strategy.Habilitar_EARLY && Signals.EARLY_delay)
  {  
   Estrategia_EARLY();
  }
  
//+------------------------------------------------------------------+
//| ESTRATÉGIA EARLY_NY                                              |
//+------------------------------------------------------------------+
if(Strategy.Habilitar_EARLY_NY && Signals.EARLY_NY_delay)
  {   
   Estrategia_EARLY_NY();
  }  
  
 }   // fim da OnTick




  