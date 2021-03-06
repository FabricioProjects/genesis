//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2014, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| Parametros de entrada                                            |
//+------------------------------------------------------------------+
// Numero do robo
input int      Robo = 3;   // 0 = Genesis   1 = Impetus   2 = Nature   3 = Akira
// Requested volume for a deal in lots
input double   Lots = 1;
// Trade symbol
input string   Ativo = "WIN$D";
// menor divisão do ativo
input double   pip = 5;
// numero de pips
input double   np = 5;
// magic number
input int      NumeroUnicoGenesis = 1;
// Maximal possible pips deviation from the requested price
input int      DesvioDeEntrada = 2;

//#### cautela em otimizações
// Hora máxima permitida para saida de operação      #### TimeExitHour = 17
input int      TimeExitHour = 17; // TimeExitHour = 17
// minuto maximo permitido para saida de operação    #### TimeExitMin > BlockTradeStartMin
input int      TimeExitMin = 44; // TimeExitMin > BlockTradeStartMin
// hora maxima permitida para entrada de operação    #### BlockTradeStartHour = 17
input int      BlockTradeStartHour = 17; // BlockTradeStartHour = 17
// minuto maximo permitido para entrada de operação  #### BlockTradeStartMin < TimeExitMin
input int      BlockTradeStartMin = 0; // BlockTradeStartMin < TimeExitMin
// hora minima permitida para entrada de operação    #### TradeStartHour = 9
input int      TradeStartHour = 9; // TradeStartHour = 9
// minuto minimo permitido para entrada de operação  #### TradeStartMin > 15
input int      TradeStartMin = 31; // TradeStartMin > 15

input string   OBS_2; //####### SUB-ESTRATÉGIAS #######
input string   OBS_2_1; //------- Controle de GAP -------
// Range minimo para ser considerado uma GAP
input double   GAP_Range = 500;

input string   OBS_2_2; //------- Controle de Risco -------
// Ganho máximo permitido CANDLESTICKS_P15 na direção short
input double   MaxGain_CANDLESTICKS_P15_Short = 690;
// Perda máxima permitida CANDLESTICKS_P15 na direção short
input double   MaxLoss_CANDLESTICKS_P15_Short = -4000;
// Ganho máximo permitido CANDLESTICKS_P15 na direção long
input double   MaxGain_CANDLESTICKS_P15_Long = 690;
// Perda máxima CANDLESTICKS_P15 na direção long
input double   MaxLoss_CANDLESTICKS_P15_Long = -4000;


input string   OBS_4_1_3; //------- Shooting Star math M30 -------
// fator de relação entre o tamanho do corpo e da sombra 
input double   body_factor_math_SS = 2.4;
// fator de tamanho da sombra inferior de Shooting Stars math M30
input double   shadow_factor_math_SS = 0.29;

input string   OBS_4_2_3; //------- Hammer math M30 -------
// fator de relação entre o tamanho do corpo e da sombra 
input double   body_factor_math_hammer = 2;
// fator de tamanho da sombra inferior de Hammers math M30
input double   shadow_factor_math_hammer = 0.08;

// ##########################################################################################################
 
//+------------------------------------------------------------------+
//| Strategies managment                                             |
//+------------------------------------------------------------------+
void Strategy_Manager()
  {
   Strategy.Habilitar_CANDLESTICKS_P15 = true;
   Strategy.Habilitar_CANDLESTICKS_P15_Once = false;
   Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15 = false;
                    
   // SUB-ESTRATEGIAS
   Strategy.Habilitar_Risk_Control = false;    // habilitação do controle de perda e ganho
   Strategy.Habilitar_GAP_Control = true;     // habilitação da verificação de GAP no dia
   Strategy.Habilitar_DATE_Control = true;    // habilitação da verificação de datas proibidas
   
   // outros
   Strategy.PL = false;                       // habilitação da geração do arquivo de PL
   Strategy.Debug = true;                    // habilitação do debug
   Strategy.Simulation = false;                // switch entre modo simulação e produção
   
   Strategy.CS_15M = true;                  // habilita a analise de CS para 15M
   Strategy.CS_30M = false;                  // habilita a analise de CS para 30M
   
  }

// Desabilita as estratégias
void Strategy_Manager_False()   
  {
   Strategy.Habilitar_CANDLESTICKS_P15 = false;
   Strategy.Debug = false; 
         
  }  
  
  
//+------------------------------------------------------------------+
//| Signals                                                          |
//+------------------------------------------------------------------+
// Booleanos utilizados nas estrategias e sub-estrategias
void Args_Init()
  {
   // variáveis globais EARLY
   if(!Global_Check("CANDLESTICKS_P15_Once"))
     {
      Global_Set("CANDLESTICKS_P15_Once",FALSE);             // se true, EARLY apenas uma vez ao dia
     } 
   if(!Global_Check("TradeSignal_CANDLESTICKS_P15"))
     {
      Global_Set("TradeSignal_CANDLESTICKS_P15",FALSE);    // se true, operação de SQUEEZE em aberto
     }   
   // SUB-ESTRATEGIAS
   Signals.GAP_Low = false;                 // GAP de baixa
   Signals.GAP_High = false;                // GAP de alta
   Signals.high_candle_stop_once = false;         // stop na maxima do padrão de candle
   Signals.low_candle_stop_once = false;          // stop na minima do padrao candle
   // Outros
   Signals.LongPosition = false;            // Indica se a posição long esta em aberto (true) ou fechada (false)
   Signals.ShortPosition = false;           // Indica se a posição short esta em aberto (true) ou fechada (false)
   Signals.Morn_Even_star = false;
   Signals.final_results = false;
   
  }

//+------------------------------------------------------------------+
//| Atribuições das Variáveis Globais                                                |
//+------------------------------------------------------------------+
// definição das variaveis globais de inicialização
void Global_Var()
   {
    // simulação
    Global.identificador = MQLInfoString(MQL_PROGRAM_NAME); // nome do robo e ativo
    Global.b = TimeCurrent();        // tempo em unixtime na pasta de saida q contem os arquivos gerados no codigo
    Global.subfolder = Global.identificador+"_"+Global.b;
//    Global.dod_symbol = "WINFUT";              // Label para o dod reconhecer corretamente o ativo
    Global.hour_NY = 00;                       // hora da abertura da bolsa de NY
    Global.min_NY = 00;                        // minuto da abertura da bolsa de NY
    // produção
    Global.subfolder_prd = "dod_hints\\Akira";      // nome da pasta de saida de hints em prd
    Global.lum = "-Midfielder-all-Akira-Long-";     // nome do arquivo de saida de hints long na saida de operação
    Global.lzero = "-Midfielder-all-Akira-Long-";   // nome do arquivo de saida de hints long na entrada de operação
    Global.sum = "-Midfielder-all-Akira-Short-";    // nome do arquivo de saida de hints short na saida de operação
    Global.szero = "-Midfielder-all-Akira-Short-";  // nome do arquivo de saida de hints short na entrada de operação
    Global.um = ".1";                          // identificação do hint de saida de operação
    Global.zero = ".0";                        // identificação do hint de entrada de operação
    // file handles
    Global.filehandle_hints = -1;              // handle do arquivo de hints
    Global.filehandle = -1;                    // handle da saida de debug
    Global.filehandle_alert = -1;              // handle da saida de alertas
    Global.filehandle_PL = -1;                 // handle da saida de PL
    // contagem de padroes
    Global.count_hammer_enter = 0;
    Global.count_hammer_SL = 0;
    Global.count_hammer_time_exit = 0; 
    Global.count_Inverted_Hammer_enter = 0;
    Global.count_Inverted_Hammer_SL = 0;
    Global.count_Inverted_Hammer_time_exit = 0;  
    Global.count_Bullish_Engulfing_enter = 0;
    Global.count_Bullish_Engulfing_SL = 0;
    Global.count_Bullish_Engulfing_time_exit = 0;
    Global.count_Piercing_Pattern_enter = 0;
    Global.count_Piercing_Pattern_SL = 0;
    Global.count_Piercing_Pattern_time_exit = 0;
    Global.count_Harami_Bullish_enter = 0;
    Global.count_Harami_Bullish_SL = 0;
    Global.count_Harami_Bullish_time_exit = 0; 
    Global.count_Morning_Star_enter = 0;
    Global.count_Morning_Star_SL = 0;
    Global.count_Morning_Star_time_exit = 0;
    
    Global.count_Shooting_Star_enter = 0;
    Global.count_Shooting_Star_SL = 0;
    Global.count_Shooting_Star_time_exit = 0;
    Global.count_Hanging_Man_enter = 0;
    Global.count_Hanging_Man_SL = 0;
    Global.count_Hanging_Man_time_exit = 0; 
    Global.count_Bearish_Engulfing_enter = 0;
    Global.count_Bearish_Engulfing_SL = 0;
    Global.count_Bearish_Engulfing_time_exit = 0;  
    Global.count_Dark_Cloud_Cover_enter = 0;
    Global.count_Dark_Cloud_Cover_SL = 0;
    Global.count_Dark_Cloud_Cover_time_exit = 0;
    Global.count_Harami_Bearish_enter = 0;
    Global.count_Harami_Bearish_SL = 0;
    Global.count_Harami_Bearish_time_exit = 0;   
    Global.count_Evening_Star_enter = 0;
    Global.count_Evening_Star_SL = 0;
    Global.count_Evening_Star_time_exit = 0;
    
    Global.count_Pattern_Exit_Long = 0;
    Global.count_Pattern_Exit_Short = 0;
    
    
   }


//+------------------------------------------------------------------+


