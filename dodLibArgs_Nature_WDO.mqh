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
input int      Robo = 2;   // 0 = Genesis   1 = Impetus   2 = Nature
// Requested volume for a deal in lots
input double   Lots = 1;
// Trade symbol
input string   Ativo = "WDOX15";
// menor divisão do ativo
input double   pip = 0.5;
// numero de pips
input int   np = 5;

// estrategia High_Volat
// BBands standard deviation
input double   n = 2;  
// standard deviation increasing               
input double   sigma_n_factor = 1; 
input double   sigma_n_factor_stop = 1;  
// limite de volatilidade permitido
input double   volat_limit = 1.5;   
// limite maximo de minutos permitido de entrada high_volat
input double   min_enter = 30;   

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
input int      TradeStartHour = 9; 
// minuto minimo permitido para entrada de operação  #### TradeStartMin > 15
input int      TradeStartMin = 16; 

input string   OBS_2; //####### SUB-ESTRATÉGIAS #######
input string   OBS_2_1; //------- Controle de GAP -------
// Range minimo para ser considerado uma GAP
input double   GAP_Range = 28;

input string   OBS_2_2; //------- Controle de Risco -------
// Ganho máximo permitido 
input double   MaxGain_SQUEEZE = 810;
// Perda máxima permitida 
input double   MaxLoss_SQUEEZE = -380;
// Ganho máximo permitido 
input double   MaxGain_SQUEEZE_HEAD = 665;
// Perda máxima permitida 
input double   MaxLoss_SQUEEZE_HEAD = -65;
// Ganho máximo permitido 
input double   MaxGain_SQUEEZE_P5 = 2000;
// Perda máxima permitida 
input double   MaxLoss_SQUEEZE_P5 = -300;

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

input string   OBS_2_4; //------- Controle Breakeven -------

input double   Breakeven_enter = 38;
input double   BE_factor_enter = 2.5;

input double   Breakeven_exit = 20;
input double   BE_factor_exit = 1.2;

// Variação do preço para acionar o Breakeven
input double   Breakeven_long_enter = 300;
// Variação do preço para acionar o Breakeven
input double   Breakeven_short_enter = 300;
// Variação do preço para sair por Breakeven
input double   Breakeven_long_exit = 100;
// Variação do preço para sair por Breakeven
input double   Breakeven_short_exit = 100;

input double   Breakeven_long_enter_P5 = 300;
// Variação do preço para acionar o Breakeven
input double   Breakeven_short_enter_P5 = 300;
// Variação do preço para sair por Breakeven
input double   Breakeven_long_exit_P5 = 100;
// Variação do preço para sair por Breakeven
input double   Breakeven_short_exit_P5 = 100;

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
              
input string   OBS_3; //####### STOCHASTIC #######
// periodo do estocastico
input int      StochK = 44; 
// periodo da amortização do estocastico  
input int      StochD = 5;    
input int      StochSlow = 2;            // 1 = stoch fast  3 = stoch slow


input string   OBS_6; //####### SQUEEZE #######
// Limite minimo de volatilidade
//input double   Width_Limit = 1.05;
// Grau de ascendência do BBandwidth
//input double   Width_Var = 0.55;
// saida da banda low 2 sigma 
input double   Band_Jump_Short = 46;
// saida da banda high 2 sigma
input double   Band_Jump_Long = 34;
//input double   Max_Width = 2.45;

input double   BJ_factor = 1;

//input double   Volat_enter_delay = 0.3;

//input double   candle_body = 100;

/*
input string   OBS_7; //####### SQUEEZE_P5 #######
// Limite minimo de volatilidade
input double   Width_Limit_P5 = 0.8;
// Grau de ascendência do BBandwidth
input double   Width_Var_P5 = 0.3;
// saida da banda low 2 sigma 
input double   Band_Jump_Short_P5 = 390;
// saida da banda high 2 sigma
input double   Band_Jump_Long_P5 = 240;
// delta da saida por recuo
//input double   delta_SQUEEZE_long_P5 = 10;
// delta da saida por recuo
//input double   delta_SQUEEZE_short_P5 = 70;
// delta da saida por recuo
input double   Max_Width_P5 = 2.8;
*/
// ##########################################################################################################
 
//+------------------------------------------------------------------+
//| Strategies managment                                             |
//+------------------------------------------------------------------+
void Strategy_Manager()
  {
   Strategy.Habilitar_SQUEEZE = false;
   Strategy.Habilitar_SQUEEZE_Once = true;
   Strategy.Habilitar_Risk_Control_SQUEEZE = false;
   
   Strategy.Habilitar_SQUEEZE_HEAD = false;
   Strategy.Habilitar_Risk_Control_SQUEEZE_HEAD = false;
   
   Strategy.Habilitar_GAP = false;
   
   Strategy.Habilitar_High_Volat = true;
   Strategy.Habilitar_Short_Enter = true;
   Strategy.Habilitar_Long_Enter = true;
   
//   Strategy.Habilitar_SQUEEZE_P5 = false;
//   Strategy.Habilitar_SQUEEZE_P5_Once = false;
//   Strategy.Habilitar_Risk_Control_SQUEEZE_P5 = false;
                    
   // SUB-ESTRATEGIAS
   Strategy.Habilitar_Risk_Control = false;          // habilitação do controle de perda e ganho
   Strategy.Habilitar_GAP_Control = false;          // habilitação da verificação de GAP no dia
   Strategy.Habilitar_DATE_Control = true;          // habilitação da verificação de datas proibidas
   Strategy.Habilitar_MA_Control = false;           // habilitação do controle de medias moveis
   Strategy.Habilitar_Breakeven = false;            // habilitação do controle de drawdown das trades
   Strategy.Habilitar_CS_Control = false;        // habilitação de candlestick patterns
   
   // outros
   Strategy.PL = false;                       // habilitação da geração do arquivo de PL
   Strategy.Debug = false;                    // habilitação do debug
   Strategy.Simulation = true;                // switch entre modo simulação e produção
   
  }

// Desabilita as estratégias
void Strategy_Manager_False()   
  {
   Strategy.Habilitar_Risk_Control = false;  
   Strategy.Habilitar_SQUEEZE = false;
   Strategy.Habilitar_SQUEEZE_HEAD = false;
   Strategy.Habilitar_High_Volat = false;
//   Strategy.Habilitar_SQUEEZE_P5 = false;
   Strategy.Habilitar_MA_Control = false;      
  }  
  
  
//+------------------------------------------------------------------+
//| Signals                                                          |
//+------------------------------------------------------------------+
// Booleanos utilizados nas estrategias e sub-estrategias
void Args_Init()
  {
   // variáveis globais SQUEEZE PERIOD_M15
   if(!Global_Check("SQUEEZE_mode"))
     {
      Global_Set("SQUEEZE_mode",FALSE);           // se true, o ativo se encontra com volatilidade baixa
     } 
   if(!Global_Check("TradeSignal_SQUEEZE"))
     {
      Global_Set("TradeSignal_SQUEEZE",FALSE);    // se true, operação de SQUEEZE em aberto
     }   
   if(!Global_Check("SQUEEZE_Once"))
     {
      Global_Set("SQUEEZE_Once",FALSE);           // se true, operações SQUEEZE somente uma vez ao dia
     }    
   if(!Global_Check("SQUEEZE_long"))
     {
      Global_Set("SQUEEZE_long",FALSE);           // se true, o nature está posicionado long; necessario para squeeze_head
     } 
   if(!Global_Check("SQUEEZE_short"))
     {
      Global_Set("SQUEEZE_short",FALSE);          // se true, o nature está posicionado short; necessario para squeeze_head
     }     
   // variáveis globais SQUEEZE_HEAD PERIOD_M15  
   if(!Global_Check("TradeSignal_SQUEEZE_HEAD"))
     {
      Global_Set("TradeSignal_SQUEEZE_HEAD",FALSE);    // se true, operação de SQUEEZE em aberto
     }   
   if(!Global_Check("SQUEEZE_HEAD_Once"))
     {
      Global_Set("SQUEEZE_HEAD_Once",FALSE);           // se true, operações SQUEEZE somente uma vez ao dia
     }    
   if(!Global_Check("TradeSignal_GAP"))
     {
      Global_Set("TradeSignal_GAP",FALSE);           // se true, operações SQUEEZE somente uma vez ao dia  
     } 
/*          
   // variáveis globais SQUEEZE PERIOD_M5
   if(!Global_Check("SQUEEZE_P5_mode"))
     {
      Global_Set("SQUEEZE_P5_mode",FALSE);           // se true, o ativo se encontra com volatilidade baixa
     } 
   if(!Global_Check("TradeSignal_SQUEEZE_P5"))
     {
      Global_Set("TradeSignal_SQUEEZE_P5",FALSE);    // se true, operação de SQUEEZE em aberto
     }   
   if(!Global_Check("SQUEEZE_P5_Once"))
     {
      Global_Set("SQUEEZE_P5_Once",FALSE);           // se true, operações SQUEEZE somente uma vez ao dia
     }        
*/     
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
   // SUB-ESTRATEGIAS
   Signals.GAP_Low = false;                 // GAP de baixa
   Signals.GAP_High = false;                // GAP de alta
   // Outros
   Signals.OR = false;                      // mecanismo de segurança para alocação do OR
   Signals.LongPosition = false;            // Indica se a posição long esta em aberto (true) ou fechada (false)
   Signals.ShortPosition = false;           // Indica se a posição short esta em aberto (true) ou fechada (false)
   Signals.Vol = false;                     // Indica a condição inicial de volatilidade para entrada de operação
   
   Signals.Head_Allowed = false;
   
   Signals.TradeSignal_High_Volat = false;
   Signals.Double_Lots = false;
   Signals.Triple_Lots = false;
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
    Global.subfolder_prd = "dod_hints\\Nature";      // nome da pasta de saida de hints em prd
    Global.lum = "-Midfielder-all-Nature-Long-";     // nome do arquivo de saida de hints long na saida de operação
    Global.lzero = "-Midfielder-all-Nature-Long-";   // nome do arquivo de saida de hints long na entrada de operação
    Global.sum = "-Midfielder-all-Nature-Short-";    // nome do arquivo de saida de hints short na saida de operação
    Global.szero = "-Midfielder-all-Nature-Short-";  // nome do arquivo de saida de hints short na entrada de operação
    Global.um = ".1";                          // identificação do hint de saida de operação
    Global.zero = ".0";                        // identificação do hint de entrada de operação
    // file handles
    Global.filehandle_hints = -1;              // handle do arquivo de hints
    Global.filehandle = -1;                    // handle da saida de debug
    Global.filehandle_alert = -1;              // handle da saida de alertas
    Global.filehandle_PL = -1;                 // handle da saida de PL
    
    Global.contratos = Lots;
   }


//+------------------------------------------------------------------+


