//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#define TRUE  1
#define FALSE 0
//+------------------------------------------------------------------+
//| Strategies managment                                             |
//+------------------------------------------------------------------+
struct Args_Strategy
  {
   // habilitação da estratégia EARLY e recursos de controle de risco
   bool Habilitar_EARLY;                   
   bool Habilitar_Risk_Control_EARLY;    
   // habilitação da estratégia EARLY_NY e recursos de controle de risco
   bool Habilitar_EARLY_NY;                
   bool Habilitar_Risk_Control_EARLY_NY;  
   // habilitação da estratégia STOCH1
   bool Habilitar_STOCH1; 
   bool Habilitar_STOCH1_Once;         // operações STOCH1 apenas uma vez ao dia   
   // habilitação da estratégia STOCH2 e recursos de gerenciamento
   bool Habilitar_STOCH2;      
   bool Habilitar_STOCH2_Once;         // operações STOCH2 apenas uma vez ao dia
   bool Habilitar_Risk_Control_STOCH_1_2; 
   // habilitação da estratégia ACD e recursos de gerenciamento            
   bool Habilitar_ACD;     
   bool Habilitar_ACD_Once;            // operações ACD apenas uma vez ao dia                
   // sub-estrategias
   bool Habilitar_Risk_Control;        // habilitação do controle de perda e ganho
   bool Habilitar_GAP_Control;         // habilitação da verificação de GAP no dia
   bool Habilitar_DATE_Control;        // habilitação da verificação de datas proibidas
   bool Habilitar_MA_Control;          // habilitação do controle de suporte/resistencia 
   bool Habilitar_MA_Oscillation;      // habilitação do controle de oscilação entre medias 
   bool Habilitar_Breakeven;           // habilitação do controle de drawdown das trades
   bool Habilitar_CS_Control;       // habilitação de candlestick patterns
   // habilitação da estratégia SQUEEZE
   bool Habilitar_SQUEEZE; 
   bool Habilitar_SQUEEZE_Once;
   bool Habilitar_Risk_Control_SQUEEZE;  
   // habilitação da estratégia SQUEEZE_HEAD
   bool Habilitar_SQUEEZE_HEAD; 
   bool Habilitar_Risk_Control_SQUEEZE_HEAD; 
   // habilitação da estratégia GAP
   bool Habilitar_GAP; 
   // habilitação da estratégia High_Volat
   bool Habilitar_High_Volat; 
   bool Habilitar_Short_Enter;          // permite entradas short
   bool Habilitar_Long_Enter;           // permite entradas long
   // habilitação da estratégia SQUEEZE_P5
   bool Habilitar_SQUEEZE_P5; 
   bool Habilitar_SQUEEZE_P5_Once;
   bool Habilitar_Risk_Control_SQUEEZE_P5; 
   // habilitação da SQUEEZE_double_mode
   bool Habilitar_SQUEEZE_double_mode;  // SQUEEZE E SQUEEZE_P5 atuando juntas
   // habilitação da estratégia CANDLESTICKS_P15
   bool Habilitar_CANDLESTICKS_P15; 
   bool Habilitar_CANDLESTICKS_P15_Once;
   bool Habilitar_Risk_Control_CANDLESTICKS_P15; 
   // outros
   bool PL;                            // habilitação da geração do arquivo de PL
   bool Debug;                         // habilitação do debug
   bool Simulation;                    // switch entre modo simulação e produção
   
   bool CS_15M;                  // habilita a analise de CS para 15M
   bool CS_30M;                  // habilita a analise de CS para 30M
   
  } Strategy;

//+------------------------------------------------------------------+
//| Signals                                                          |
//+------------------------------------------------------------------+
struct Args_Signals
  {
   // Estratégia EARLY
   bool TradeSignal_EARLY;     // operações EARLY_1 abertas ou fechadas
   bool EARLY_delay;             // habilita a entrada EARLY somente apos um periodo em unixtime
   bool EARLY_unixtime_reset;    // adequa o EARLY_unixtime para produção e simulação
   bool EARLY_once;              // operações EARLY apenas uma vez por dia
   // Estratégia EARLY_NY
   bool TradeSignal_EARLY_NY;  // operações EARLY_NY_1 abertas ou fechadas
   bool EARLY_NY_delay;          // habilita a entrada EARLY somente apos um periodo em unixtime
   bool EARLY_NY_unixtime_reset; // adequa o EARLY_unixtime para produção e simulação
   bool EARLY_NY_once;           // operações EARLY apenas uma vez por dia
   // Estratégia STOCH1
   bool TradeSignal_STOCH1;      // operações STOCH1 abertas ou fechadas
   bool STOCH1_Once;             // Stoch1 não entra após um BumpStopGain para evitar falsas reversões
   bool BuyCondition_STOCH1;
   bool SellCondition_STOCH1;
   // Estratégia STOCH2
   bool TradeSignal_STOCH2;      // operações STOCH2 abertas ou fechadas
   bool STOCH2_Once;             // operações STOCH2 apenas uma vez por dia
   bool BuyCondition1_STOCH2;
   bool BuyCondition2_STOCH2;    // verifica o delay de entrada de operação de compra
   bool STOCH2_bool1_buy;
   bool STOCH2_bool1_sell;
   bool SellCondition1_STOCH2;
   bool SellCondition2_STOCH2;   // verifica o delay de entrada de operação de venda
   // Estratégia ACD
   bool TradeSignal_ACD;         // operações ACD abertas ou fechadas
   bool ACD_Once;                // operações ACD apenas uma vez por dia
   bool Buy_ACD;                 // verifica o delay de entrada long ACD
   bool BuyCondition_ACD_1;
   bool BuyCondition_ACD_2;
   bool BuyCondition_ACD_3;
   bool Sell_ACD;                // verifica o delay de entrada short ACD
   bool SellCondition_ACD_1;
   bool SellCondition_ACD_2;
   bool SellCondition_ACD_3;
   // Estratégia SQUEEZE
//   bool TradeSignal_SQUEEZE;
//   bool SQUEEZE_mode;
//   bool SQUEEZE_Once;
   bool Head_Allowed;
   bool TradeSignal_High_Volat;
   bool Double_Lots;
   bool Triple_Lots;
   
   
   bool high_candle_stop_once;         // stop na maxima do padrão de candle
   bool low_candle_stop_once;          // stop na minima do padrao candle
   // SUB-ESTRATEGIAS  
   bool MA_mode;
   bool GAP_Low;                 // GAP de baixa
   bool GAP_High;                // GAP de Alta
   // Outros
   bool OR;                      // mecanismo de segurança para alocação do OR
   bool LongPosition;            // Indica se a posição long esta em aberto (true) ou fechada (false)
   bool ShortPosition;           // Indica se a posição short esta em aberto (true) ou fechada (false)
   bool Vol;                     // Indica a condição inicial de volatilidade para entrada de operação
   
   bool Morn_Even_star;
   bool hammer;
   bool Inverted_Hammer;
   bool Bullish_Engulfing;
   bool Piercing_Pattern;
   bool Harami_Bullish;
   bool Morning_Star;
   
   bool Shooting_Star;
   bool Hanging_Man;
   bool Bearish_Engulfing;
   bool Dark_Cloud_Cover;
   bool Harami_Bearish;
   bool Evening_Star;
   
   bool final_results;
   
  } Signals;

//+------------------------------------------------------------------+
//| Variáveis Globais                                                |
//+------------------------------------------------------------------+
struct Global_Variables   
  {
   // variáveis datetime
   datetime date1;                  // variaveis globais para uso e manipulação do datetime
   datetime tm;
   datetime tm1;
   datetime initialize_datetime;    // tempo de inicio de uma operação
   datetime finalize_datetime;      // tempo de término de uma operação
   // variáveis string
   string tick_unixtime;            // unixtime da função on_tick
   string prev_unixtime;            // unixtime da do tick anterior
   string EARLY_unixtime;           // unixtime delay de entrada em operação EARLY
   string EARLY_NY_unixtime;           // unixtime delay de entrada em operação EARLY
   string STOCH2_buy_delay_enter;   // começo do delay de entrada no limite para evitar picos de liquidez
   string STOCH2_buy_delay_exit;    // final do delay de entrada no limite para evitar picos de liquidez
   string STOCH2_sell_delay_enter;
   string STOCH2_sell_delay_exit;
   string ACD_buy_delay_enter;      // começo do delay de entrada 
   string ACD_buy_delay_exit;       // final do delay de entrada 
   string ACD_sell_delay_enter;
   string ACD_sell_delay_exit;
   string unixtime_enter;           // inicio stoch1
   string unixtime_exit;            // stoch1 stop loss somente apos 3 candles
   string initialize_unixtime;      // tempo, em unixtime, de inicio de uma operação
   string finalize_unixtime;        // tempo, em unixtime, de término de uma operação
   string identificador;                   // nome da pasta de saida q contem os arquivos gerados no codigo em simulação
   string b;                   // tempo em unixtime na pasta de saida q contem os arquivos gerados no codigo
   string subfolder;
   string subfolder_prd;
//   string dod_symbol;          // Label para o dod reconhecer corretamente o ativo
   string lum;                 // nome do arquivo de saida de hints long na saida de operação
   string lzero;               // nome do arquivo de saida de hints long na entrada de operação
   string sum;                 // nome do arquivo de saida de hints short na saida de operação
   string szero;               // nome do arquivo de saida de hints short na entrada de operação
   string um;                  // identificação do hint de saida de operação
   string zero;                // identificação do hint de entrada de operação
   string status;              // status da transação (loss ou gain)
   // variáveis double
   double ORmax;                    // limite superior do Opening Range
   double ORmin;                    // limite inferior do Opening Range
   double initial_price;            // inicio do preço de uma operação para alocação no arquivo de hints
   double final_price;              // final do preço de uma operação para alocação no arquivo de hints
   double price_trade_start;        // preço no inicio de uma operação
   double price_trade_stop;         // preço no termino de uma operação
   double high_candle_stop;         // stop na maxima do padrão de candle
   double low_candle_stop;          // stop na minima do padrao candle
   double Volat_Media_Max[300];     // alocação dinamica da volatilidade
   double Volat_Media_Min[300];     // alocação dinamica da volatilidade
   double BJ_Long;                  // band jump dinamico
   double BJ_Short;                 // band jump dinamico
   double min_prev;                 // minima do ultimo candle do dia anterior
   double max_prev;                 // maxima do ultimo candle do dia anterior
   double close_prev;               // fechamento do ultimo candle do dia anterior
   // variáveis long
   long delay_SQUEEZE_HEAD;
   // variáveis int
   int contratos;
   
   int count_hammer_enter;
   int count_hammer_SL;
   int count_hammer_time_exit;
   int count_Inverted_Hammer_enter;
   int count_Inverted_Hammer_SL;
   int count_Inverted_Hammer_time_exit; 
   int count_Bullish_Engulfing_enter;
   int count_Bullish_Engulfing_SL;
   int count_Bullish_Engulfing_time_exit;
   int count_Piercing_Pattern_enter;
   int count_Piercing_Pattern_SL;
   int count_Piercing_Pattern_time_exit; 
   int count_Harami_Bullish_enter;
   int count_Harami_Bullish_SL;
   int count_Harami_Bullish_time_exit; 
   int count_Morning_Star_enter;
   int count_Morning_Star_SL;
   int count_Morning_Star_time_exit;
   
   int count_Shooting_Star_enter;
   int count_Shooting_Star_SL;
   int count_Shooting_Star_time_exit;
   int count_Hanging_Man_enter;
   int count_Hanging_Man_SL;
   int count_Hanging_Man_time_exit;
   int count_Bearish_Engulfing_enter;
   int count_Bearish_Engulfing_SL;
   int count_Bearish_Engulfing_time_exit; 
   int count_Dark_Cloud_Cover_enter;
   int count_Dark_Cloud_Cover_SL;
   int count_Dark_Cloud_Cover_time_exit;  
   int count_Harami_Bearish_enter;
   int count_Harami_Bearish_SL;
   int count_Harami_Bearish_time_exit; 
   int count_Evening_Star_enter;
   int count_Evening_Star_SL;
   int count_Evening_Star_time_exit;
   
   int count_Pattern_Exit_Long;
   int count_Pattern_Exit_Short;
   
   int hour_NY;                     // hora da abertura da bolsa de NY
   int min_NY;                      // minuto da abertura da bolsa de NY
   int hour,min,sec;
   int difftime;
   
   int filehandle_hints;         // handle do arquivo de hints
   int filehandle;               // handle da saida de debug
   int filehandle_alert;         // handle da saida de alertas
   int filehandle_tick_control;  // handle da saida de alertas
   int filehandle_PL;            // handle da saida de PL
   int filehandle_PA;            // handle da saida de Pattern Analysis
  
  } Global;


//+------------------------------------------------------------------+