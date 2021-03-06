//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2014, Fabrício Amaral"
#property link      "http://executive.com.br/"

//+------------------------------------------------------------------+
//| Parametros de entrada                                            |
//+------------------------------------------------------------------+
// Numero do robo
input int      Robo = 0;   // 0 = Genesis   1 = Impetus   2 = Nature
// Requested volume for a deal in lots
input double   Lots = 1;
// Trade symbol
input string   Ativo = "WDOM15";
// menor divisão do ativo
input double   pip = 5;
// magic number
input int      NumeroUnicoGenesis = 1; 
// Maximal possible pips deviation from the requested price
input int      DesvioDeEntrada = 2;

input string   OBS_1; //####### CONTROLE TEMPORAL #######
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
input int      TradeStartMin = 7; // TradeStartMin > 15

input string   OBS_2; //####### SUB-ESTRATÉGIAS #######
input string   OBS_2_1; //------- Controle de GAP -------
// Range minimo para ser considerado uma GAP
input double   GAP_Range = 28;

input string   OBS_2_2; //------- Controle de Risco -------
// Ganho máximo permitido
input double   MaxGain_STOCH_1_2 = 1650;
// Perda máxima permitida
input double   MaxLoss_STOCH_1_2 = -250;

input string   OBS_2_3; //------- Controle de Medias Moveis -------
// Range de atuação do MA_Control
input double   delta_MA20 = 70;
// Range de atuação do MA_Control
input double   delta_MA50 = 3.5;
// Range de atuação do MA_Control
input double   delta_MA200 = 3.0;
// distancia minima de afastamento das medias
input double   dmin_MA200_50 = 0.7;
// distancia maxima de afastamento das medias
input double   dmax_MA200_50 = 2.1;
// distancia minima de afastamento das medias
input double   dmin_MA50_20 = 70;

input string   OBS_2_4; //------- Controle Breakeven -------
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
input double   shadow_factor_math_hammer = 0.08;

input string   OBS_3; //####### STOCHASTIC #######
// periodo do estocastico
input int      StochK = 54; 
// periodo da amortização do estocastico  
input int      StochD = 5;    
input int      StochSlow = 5;            // 1 = stoch fast  3 = stoch slow

input string   OBS_4; //####### STOCH 1 and STOCH 2 #######
// limite inferior do estocástico para entrada STOCH2
input double   StochMin = 48;   
 // limite superior do estocástico para entrada STOCH2          
input double   StochMax = 55;  

input string   OBS_5; //####### STOCH 1 #######
// limite inferior do estocástico para entrada long STOCH1    
input double   Stoch1_Buy_On = 18; 
// limite superior do estocástico para entrada short STOCH1   
input double   Stoch1_Sell_On = 87; 
// verifica se o estacastico esta ascendente e cruza o limite Stoch1_Buy_On   
input double   BumpSTOCH1_Buy = 8;  
// verifica se o estacastico esta descendente e cruza o limite Stoch1_Sell_On    
input double   BumpSTOCH1_Sell = -13;  
// fator de recuo maximo do estocastico desde o inicio da trade
input long     Stoch1_FactorLong = 8;  
// fator de recuo do estocastico desde o inicio da trade 
input long     Stoch1_FactorShort = 7; 

input string   OBS_6; //####### STOCH 2 #######
// delay de condição de compra no dentro dos limites 
input long     STOCH2_Buy_Delay = 216;  
// delay de condição de venda no dentro dos limites 
input long     STOCH2_Sell_Delay = 268;   
// variação maxima do estocastico para saida gain de operação long acima do limite superior         
input double   BumpStopGainLong = -7; 
// variação maxima do estocastico para saida gain de operação short abaixo do limite inferior 
input double   BumpStopGainShort = 14;  
// variação maxima do estocastico para saida loss de operação long abaixo do limite inferior 
input double   BumpStopLossLong = -14;   
// variação maxima do estocastico para saida loss de operação short acima do limite superior
input double   BumpStopLossShort = 14; 
// volatilidade dada em percentagem de reta evolução para saida de operação STOCH2   
input double   Volat_STOCH2 = 3; 

input string   OBS_7; //####### ACD #######
// limite do estocastico para ativação de operações long ACD
input double   ACD_OnLong = 94;
// limite do estocastico para ativação de operações short ACD
input double   ACD_OnShort = 14;
// fator de ajuste do contrato para saidas 1 sigma
input double   SigmaFactorLong = 1.3;
// fator de ajuste do contrato para saidas 1 sigma
input double   SigmaFactorShort = 1.0;

// ##########################################################################################################
 
//+------------------------------------------------------------------+
//| Strategies managment                                             |
//+------------------------------------------------------------------+
void Strategy_Manager()
  {
   Strategy.Habilitar_STOCH1 = true;
   Strategy.Habilitar_STOCH1_Once = true;     // operações STOCH1 apenas uma vez ao dia
   
   Strategy.Habilitar_STOCH2 = true;    
   Strategy.Habilitar_STOCH2_Once = true;     // operações STOCH2 apenas uma vez ao dia
   
   Strategy.Habilitar_Risk_Control_STOCH_1_2 = false;  // controle de risco stoch 1 e 2 simultaneamente
                
   Strategy.Habilitar_ACD = true;   
   Strategy.Habilitar_ACD_Once = true;        // operações ACD apenas uma vez ao dia  
                    
   // SUB-ESTRATEGIAS
   Strategy.Habilitar_Risk_Control = false;    // habilitação do controle de perda e ganho
   Strategy.Habilitar_GAP_Control = true;     // habilitação da verificação de GAP no dia
   Strategy.Habilitar_DATE_Control = true;    // habilitação da verificação de datas proibidas
   Strategy.Habilitar_MA_Control = true;      // habilitação do controle de medias moveis STOCH2
   Strategy.Habilitar_MA_Oscillation = false; // habilitação do controle de oscilação entre medias
   Strategy.Habilitar_Breakeven = false;       // habilitação do controle de drawdown das trades ACD
   Strategy.Habilitar_CS_Control = true;        // habilitação de candlestick patterns
   
   // outros
   Strategy.PL = false;                       // habilitação da geração do arquivo de PL
   Strategy.Debug = false;                    // habilitação do debug
   Strategy.Simulation = true;                // switch entre modo simulação e produção
     
  }

// Desabilita as estratégias
void Strategy_Manager_False()   
  {
   Strategy.Habilitar_STOCH1 = false;
   Strategy.Habilitar_STOCH2 = false;        
   Strategy.Habilitar_ACD = false;           
   Strategy.Habilitar_Risk_Control = false;  
   Strategy.Habilitar_MA_Control = false;
   Strategy.Habilitar_MA_Oscillation = false;
   Strategy.Debug = false;         
  }  
  
//+------------------------------------------------------------------+
//| Signals                                                          |
//+------------------------------------------------------------------+
// Booleanos utilizados nas estrategias e sub-estrategias
void Args_Init()
  {
   // Estratégia STOCH1
   Signals.TradeSignal_STOCH1 = false;      // operações STOCH1 abertas ou fechadas
   Signals.STOCH1_Once = false;             // Stoch1 não entra após um BumpStopGain para evitar falsas reversões
   Signals.BuyCondition_STOCH1 = false;
   Signals.SellCondition_STOCH1 = false;
   // Estratégia STOCH2
   Signals.TradeSignal_STOCH2 = false;      // operações STOCH2 abertas ou fechadas
   Signals.STOCH2_Once = false;             // operações STOCH2 apenas uma vez por dia
   Signals.BuyCondition1_STOCH2 = false;
   Signals.BuyCondition2_STOCH2 = false;    // verifica o delay de entrada de operação de compra
   Signals.STOCH2_bool1_buy = false;
   Signals.STOCH2_bool1_sell = false;
   Signals.SellCondition1_STOCH2 = false;
   Signals.SellCondition2_STOCH2 = false;   // verifica o delay de entrada de operação de venda
   // Estratégia ACD
   Signals.TradeSignal_ACD = false;         // operações ACD abertas ou fechadas
   Signals.ACD_Once = false;                // operações ACD apenas uma vez por dia
   
   // SUB-ESTRATEGIAS
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
      Global_Set("Breakeven_mode",FALSE);         
     }    
   Signals.GAP_Low = false;                 // GAP de baixa
   Signals.GAP_High = false;                // GAP de alta
   // Outros
   Signals.OR = false;                      // mecanismo de segurança para alocação do OR
   Signals.LongPosition = false;            // Indica se a posição long esta em aberto (true) ou fechada (false)
   Signals.ShortPosition = false;           // Indica se a posição short esta em aberto (true) ou fechada (false)
//   Signals.Vol = false;                     // Indica a condição inicial de volatilidade para entrada de operação
   
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
    Global.subfolder_prd = "dod_hints\\Genesis";        // nome da pasta de saida de hints em prd
    Global.lum = "-Midfielder-all-Genesis-Long-";     // nome do arquivo de saida de hints long na saida de operação
    Global.lzero = "-Midfielder-all-Genesis-Long-";   // nome do arquivo de saida de hints long na entrada de operação
    Global.sum = "-Midfielder-all-Genesis-Short-";    // nome do arquivo de saida de hints short na saida de operação
    Global.szero = "-Midfielder-all-Genesis-Short-";  // nome do arquivo de saida de hints short na entrada de operação
    Global.um = ".1";                          // identificação do hint de saida de operação
    Global.zero = ".0";                        // identificação do hint de entrada de operação
    // file handles
    Global.filehandle_hints = -1;              // handle do arquivo de hints
    Global.filehandle = -1;                    // handle da saida de debug
    Global.filehandle_alert = -1;              // handle da saida de alertas
    Global.filehandle_PL = -1;                 // handle da saida de PL
   }


//+------------------------------------------------------------------+


