//-------------------------------------------------------------------+
//|                                          dod_Market_Analysis.mq5 |
//|                       dod - Robôs Investidores / Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014 - 2015, dod - Robôs Investidores / Fabrício Amaral"
#property link      "http://executive.com.br/"
#property version   "1.0"

// Standard Libraries
//#include <Trade\Trade.mqh>
//#include <Trade\AccountInfo.mqh>
//#include <Trade\SymbolInfo.mqh>
//#include <Trade\PositionInfo.mqh> 
// Genesis Libraries
#include "dodLibArgs_Market_Analysis.mqh"
#include "dodLib_Market_Analysis_Misc.mqh"
#include "dodLib_Memory_Analysis.mqh"
#include "dodLib_Volatility_Analysis.mqh"
//#include "dodLib_Volume_Analysis.mqh"
//#include "dodLib_Gap_Analysis.mqh"
// Indicadores
#include "dodLib_Market_Analysis_Indicators.mqh"



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
// definições globais, feitas somente uma vez
int OnInit()
  { 
   // Disponibilidade de barras e sincronização.             ##dodLib_Market_Analysis_Misc##
   Market_Analysis_Misc();   
   // Gerenciamento de estrategias e sub-estrategias.        ##dodLibArgs##            
   Market_Analysis_Manager();   
   // Booleanos Signal.                                      ##dodLibArgs##
   Args_Init();  
   // Definição das variáveis globais.                       ##dodLibArgs##        
   Global_Var();    
   // Call, Indexação, Séries - indicadores.                 ##dodLib_Market_Analysis_Indicators##     
   Indicators_Market_Analysis();
       
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Indicators_Market_Analysis_Release();
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
  Market_Analysis_Date_Control();               // ##dodLibMisc##
  // Faz o Reset diário                                 
  Market_Analysis_Reset();                      // ##dodLibMisc##
  
//############################################################################################################# 
//######################################## MEMORY_ANALYSIS #################################################### 
//############################################################################################################# 
  
if( Market.Habilitar_Memory_Analysis == true )
  {
  
//+------------------------------------------------------------------+
//| ANALISE DE MAXIMAS E MINIMAS                                     |
//+------------------------------------------------------------------+

  // Aloca a maxima e minima do periodo de 15 minutos
  if(Market.Memory_Analysis_15M)
    {
     Memory_Period_Min_Max_Alloc();       // ##dodLib_Memory_Analysis##
    }
  // Aloca a maxima e minima do periodo de 30 minutos
  if(Market.Memory_Analysis_30M)
    {
     Memory_Period_Min_Max_Alloc_30M();   // ##dodLib_Memory_Analysis##
    }
   
  // Aloca o periodo de 15M da minima e maxima do dia
  if(   str1.hour == 17 && str1.min == 45 
     && Signals.memory_day_min_max_alloc == false
     && Market.Memory_Analysis_15M                )
    {
     Memory_Day_Min_Max();             // ##dodLib_Memory_Analysis## 
     Memory_Exception_15M();        // controle de exeções quanda a maxima ou minima é no ultimo candle  
     Signals.memory_day_min_max_alloc = true;
    }
    
  // Aloca o periodo de 30M da minima e maxima do dia
  if(   str1.hour == 17 && str1.min == 30 
     && Signals.memory_day_min_max_alloc_30M == false
     && Market.Memory_Analysis_30M                    )
    {
     Memory_Day_Min_Max_30M();         // ##dodLib_Memory_Analysis##
     Memory_Exception_30M();        // controle de exeções quanda a maxima ou minima é no ultimo candle    
     Signals.memory_day_min_max_alloc_30M = true;
    }  
 
//+------------------------------------------------------------------+
//| MEMORY FREQUENCY FINAL RESULTS                                   |
//+------------------------------------------------------------------+     
   if( !Signals.memory_final_frequency_results )
     {
      // data da saida da estatistica final
      if(   
             str1.year == 2015  && str1.mon == 07  && str1.day == 02  
         &&  str1.hour == 17    && str1.min == 45  && str1.sec == 0      
                                                                      )  
        {
         if(Market.Memory_Analysis_15M)
           {
            Memory_Frequency_Results();
           } 
         if(Market.Memory_Analysis_30M)
           {
            Memory_Frequency_Results_30M();
           }   
         Signals.memory_final_frequency_results = true;
        }
     }  
     
  }  // fim da Memory_Analysis   
  
if( Market.Habilitar_Volatility_Analysis == true )
  {
  
//+------------------------------------------------------------------+
//| ANALISE DE VOLATILIDADE                                          |
//+------------------------------------------------------------------+  
   
   if(   str1.hour == 17 && str1.min == 45
      && Signals.volat_day_min_max_alloc == false  )
     {
      Buffers_Market_Analysis();
      int  max = ArrayMaximum(Ind.BBandwidth_Buffer,1,35);      // retorna a componente do vetor q possui a maxima do range  
      int  min = ArrayMinimum(Ind.BBandwidth_Buffer,1,35);      // retorna a componente do vetor q possui a minima do range 
      
      Global.volat_F_max[Global.volat_i] = Ind.BBandwidth_Buffer[max];   // elementos da media max
      Global.volat_F_min[Global.volat_i] = Ind.BBandwidth_Buffer[min];   // elementos da media min
      
      // alocação da frequencia para validação
      Global.count_volat_F_max[max]++;
      Global.count_volat_F_min[min]++;
      Volat_Analysis_Validation(" Global.count_volat_F_max["+max+"] = "+Global.count_volat_F_max[max]);
      Volat_Analysis_Validation(" Global.count_volat_F_min["+min+"] = "+Global.count_volat_F_min[min]);
      Volat_Analysis_Validation( ""+"\n");
      
      // alocação das max e min para validação
      Volat_Analysis_Validation(" Global.volat_F_max["+Global.volat_i+"] = "+Global.volat_F_max[Global.volat_i]);
      Volat_Analysis_Validation(" Global.volat_F_min["+Global.volat_i+"] = "+Global.volat_F_min[Global.volat_i]);
      Volat_Analysis_Validation( ""+"\n");
      
      // alocação das maximas e minimas
      Volat_Max(Global.volat_F_max[Global.volat_i]);      // volatilidade maxima do dia
      Volat_Min(Global.volat_F_min[Global.volat_i]);      // volatilidade minima do dia
      
      // alocação da amplitude
      Volat_Range((Global.volat_F_max[Global.volat_i] - Global.volat_F_min[Global.volat_i]));  // amplitude da volatilidade do dia
      
      Global.volat_i++;
      Signals.volat_day_min_max_alloc = true;
     } 
     
   if( !Signals.volat_final_frequency_results )
     {
      // data da saida da estatistica final
      if(   
             str1.year == 2015  && str1.mon == 08  && str1.day == 07  
         &&  str1.hour == 17    && str1.min == 45        
                                                                      )  
        {
         Volat_Frequency_Results();
         Signals.volat_final_frequency_results = true;   
        }
      }  

  }  // fim da analise de volatilidade
  
 }   // fim da OnTick




  