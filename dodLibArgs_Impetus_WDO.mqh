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
input int      Robo = 1;   // 0 = Genesis   1 = Impetus   2 = Desert
// Requested volume for a deal in lots
input double   Lots = 3;
// Trade symbol
input string   Ativo = "WINM15";
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
input int      TradeStartMin = 1; // TradeStartMin > 15

input string   OBS_2; //####### SUB-ESTRATÉGIAS #######
input string   OBS_2_1; //------- Controle de GAP -------
// Range minimo para ser considerado uma GAP
input double   GAP_Range = 500;

input string   OBS_2_2; //------- Controle de Risco -------
// Ganho máximo permitido na primeira operação EARLY
input double   MaxGain_EARLY = 665;
// Perda máxima permitida na primeira operação EARLY
input double   MaxLoss_EARLY = -65;
// Ganho máximo permitido na primeira operação EARLY
input double   MaxGain_EARLY_NY = 300;
// Perda máxima permitida na primeira operação EARLY
input double   MaxLoss_EARLY_NY = -155;
/*
input string   OBS_2_3; //------- Controle de Medias Moveis -------
// Range de atuação do MA_Control
input double   delta_MA20 = 70;
// Range de atuação do MA_Control
input double   delta_MA50 = 70;
// Range de atuação do MA_Control
input double   delta_MA200 = 70;
// distancia minima de afastamento das medias
input double   dmin_MA200_50 = 70;
// distancia minima de afastamento das medias
input double   dmin_MA50_20 = 70;
*/
input string   OBS_2_4; //------- Controle Breakeven -------
// Variação do preço para acionar o Breakeven
input double   Breakeven_long_enter = 300;
// Variação do preço para acionar o Breakeven
input double   Breakeven_short_enter = 300;
// Variação do preço para sair por Breakeven
input double   Breakeven_long_exit = 100;
// Variação do preço para sair por Breakeven
input double   Breakeven_short_exit = 100;

/*
input string   OBS_2_5; //------- Controle Breakout -------
// volume minimo para ser considerado um breakout
input double   Breakout_Volume = 2000;

input string   OBS_2_6; //------- Controle CandleSticks -------
input string   OBS_4_1; //------- Shooting Star -------
// fator de relação entre o tamanho do corpo e da sombra 
input double   body_factor_SS = 2.3;
// fator de tamanho da sombra inferior de shooting stars
input double   shadow_factor_SS = 0.12;
input string   OBS_4_2; //------- Shooting Star math M30 -------
// fator de relação entre o tamanho do corpo e da sombra 
input double   body_factor_math_SS = 2.4;
// fator de tamanho da sombra inferior de Shooting Stars math M30
input double   shadow_factor_math_SS = 0.29;
input string   OBS_4_3; //------- Hammer -------
// fator de relação entre o tamanho do corpo e da sombra 
input double   body_factor_hammer = 2;
// fator de tamanho da sombra inferior de hammers
input double   shadow_factor_hammer = 0.08;
input string   OBS_4_4; //------- Hammer math M30 -------
// fator de relação entre o tamanho do corpo e da sombra 
input double   body_factor_math_hammer = 2;
// fator de tamanho da sombra inferior de Hammers math M30
input double   shadow_factor_math_hammer = 0.05;
*/              
input string   OBS_3; //####### STOCHASTIC #######
// periodo do estocastico
input int      StochK = 44; 
// periodo da amortização do estocastico  
input int      StochD = 5;    
input int      StochSlow = 2;            // 1 = stoch fast  3 = stoch slow

input string   OBS_4; //####### EARLY #######
// tempo máximo em minutos para forçar a saída EARLY long
input long     EARLY_Time_Exit_Long = 30;  // 15 < EARLY_Time_Exit_Long < 45
// tempo máximo em minutos para forçar a saída EARLY short
input long     EARLY_Time_Exit_Short = 30;  // 15 < EARLY_Time_Exit_Short < 45
// tempo em segundos do delay de entrada de operação EARLY  #### EARLY_Delay_Enter > 60
input long     EARLY_Delay_Enter = 66;  // EARLY_Delay_Enter > 60
// tempo em segundos do delay de entrada de operação EARLY na direção long
input long     EARLY_Delay_Enter_Long = 63;
// tempo em segundos do delay de entrada de operação EARLY na direção short
input long     EARLY_Delay_Enter_Short = 175;
// percentagem em relação à abertura para entrada de operação
input double   EARLY_Enter_Long = 0.155;
// percentagem em relação à abertura para entrada de operação
input double   EARLY_Enter_Short = -0.065;

input string   OBS_5; //####### EARLY_NY #######
// tempo máximo em minutos para forçar a saída EARLY long
input long     EARLY_NY_Time_Exit_Long = 53;  // 30 < EARLY_NY_Time_Exit_Long < 55
// tempo máximo em minutos para forçar a saída EARLY short
input long     EARLY_NY_Time_Exit_Short = 50;  // 30 < EARLY_NY_Time_Exit_Short < 55
// tempo em segundos do delay de entrada de operação EARLY  #### EARLY_Delay_Enter > 60
input long     EARLY_NY_Delay_Enter = 79;  // EARLY_NY_Delay_Enter > 60
// tempo em segundos do delay de entrada de operação EARLY na direção long
input long     EARLY_NY_Delay_Enter_Long = 82;
// tempo em segundos do delay de entrada de operação EARLY na direção short
input long     EARLY_NY_Delay_Enter_Short = 7;
// percentagem em relação à abertura para entrada de operação
input double   EARLY_NY_Enter_Long = 0.34;
// percentagem em relação à abertura para entrada de operação
input double   EARLY_NY_Enter_Short = -0.08;
// Volume de ticks
input double   Volume_Tick_NY = 1500;


// ##########################################################################################################
 
//+------------------------------------------------------------------+
//| Strategies managment                                             |
//+------------------------------------------------------------------+
void Strategy_Manager()
  {
   Strategy.Habilitar_EARLY = false;
   Strategy.Habilitar_Risk_Control_EARLY = false;
   
   Strategy.Habilitar_EARLY_NY = true;
   Strategy.Habilitar_Risk_Control_EARLY_NY = true;
                    
   // SUB-ESTRATEGIAS
   Strategy.Habilitar_Risk_Control = true;    // habilitação do controle de perda e ganho
   Strategy.Habilitar_GAP_Control = false;     // habilitação da verificação de GAP no dia
   Strategy.Habilitar_DATE_Control = true;    // habilitação da verificação de datas proibidas
//   Strategy.Habilitar_MA_Control = false;      // habilitação do controle de medias moveis
   Strategy.Habilitar_Breakeven = false;       // habilitação do controle de drawdown das trades
   
   // outros
   Strategy.PL = false;                       // habilitação da geração do arquivo de PL
   Strategy.Debug = false;                    // habilitação do debug
   Strategy.Simulation = true;                // switch entre modo simulação e produção
   
  }

// Desabilita as estratégias
void Strategy_Manager_False()   
  {
   Strategy.Habilitar_EARLY = false;
   Strategy.Habilitar_EARLY_NY = false; 
   Strategy.Debug = false;         
  }  
  
  
//+------------------------------------------------------------------+
//| Signals                                                          |
//+------------------------------------------------------------------+
// Booleanos utilizados nas estrategias e sub-estrategias
void Args_Init()
  {
   // variáveis globais EARLY
   if(!Global_Check("EARLY_once"))
     {
      Global_Set("EARLY_once",FALSE);             // se true, EARLY apenas uma vez ao dia
     } 
   if(!Global_Check("EARLY_NY_once"))
     {
      Global_Set("EARLY_NY_once",FALSE);          // se true, EARLY apenas uma vez ao dia
     }     
   // variáveis globais MA_Control 
   if(!Global_Check("MA_mode_20"))
     {
      Global_Set("MA_mode_20",FALSE);             // se true, controle de medias estara ativo
     }      
   if(!Global_Check("MA_mode_50"))
     {
      Global_Set("MA_mode_50",FALSE);             // se true, controle de medias estara ativo
     }      
   if(!Global_Check("MA_mode_200"))
     {
      Global_Set("MA_mode_200",FALSE);            // se true, controle de medias estara ativo
     }        
   if(!Global_Check("Breakeven_mode"))
     {
      Global_Set("Breakeven_mode",FALSE);         // se true, controle de medias estara ativo
     }          
   // Estratégia EARLY
   Signals.TradeSignal_EARLY = false;     // operações EARLY_1 abertas ou fechadas
   Signals.EARLY_delay = false;             // habilita a entrada EARLY somente apos um periodo em unixtime
   Signals.EARLY_unixtime_reset = false;    // adequa o EARLY_unixtime para produção e simulação
   Signals.EARLY_once = false;              // operações EARLY apenas uma vez por dia
   // Estratégia EARLY_NY
   Signals.TradeSignal_EARLY_NY = false;  // operações EARLY_NY_1 abertas ou fechadas
   Signals.EARLY_NY_delay = false;          // habilita a entrada EARLY somente apos um periodo em unixtime
   Signals.EARLY_NY_unixtime_reset = false; // adequa o EARLY_unixtime para produção e simulação
   Signals.EARLY_NY_once = false;           // operações EARLY NY apenas uma vez por dia
   // SUB-ESTRATEGIAS
   Signals.GAP_Low = false;                 // GAP de baixa
   Signals.GAP_High = false;                // GAP de alta
   // Outros
   Signals.OR = false;                      // mecanismo de segurança para alocação do OR
   Signals.LongPosition = false;            // Indica se a posição long esta em aberto (true) ou fechada (false)
   Signals.ShortPosition = false;           // Indica se a posição short esta em aberto (true) ou fechada (false)
   Signals.Vol = false;                     // Indica a condição inicial de volatilidade para entrada de operação
   
  }

//+------------------------------------------------------------------+
//| Variáveis Globais                                                |
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
    Global.subfolder_prd = "dod_hints\\Impetus";      // nome da pasta de saida de hints em prd
    Global.lum = "-Midfielder-all-Impetus-Long-";     // nome do arquivo de saida de hints long na saida de operação
    Global.lzero = "-Midfielder-all-Impetus-Long-";   // nome do arquivo de saida de hints long na entrada de operação
    Global.sum = "-Midfielder-all-Impetus-Short-";    // nome do arquivo de saida de hints short na saida de operação
    Global.szero = "-Midfielder-all-Impetus-Short-";  // nome do arquivo de saida de hints short na entrada de operação
    Global.um = ".1";                          // identificação do hint de saida de operação
    Global.zero = ".0";                        // identificação do hint de entrada de operação
    // file handles
    Global.filehandle_hints = -1;              // handle do arquivo de hints
    Global.filehandle = -1;                    // handle da saida de debug
    Global.filehandle_alert = -1;              // handle da saida de alertas
    Global.filehandle_PL = -1;                 // handle da saida de PL
   }


//+------------------------------------------------------------------+


