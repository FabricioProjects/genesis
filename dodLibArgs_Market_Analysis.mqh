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
input int      Robo = 4;   // 0 = Genesis   1 = Impetus   2 = Nature   3 = Akira  4 = Market_Analysis
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


// ##########################################################################################################
 
//+------------------------------------------------------------------+
//| MARKET ANALYSIS MANAGMENT                                        |
//+------------------------------------------------------------------+
void Market_Analysis_Manager()
  {
   Market.Habilitar_Memory_Analysis =      false;
   Market.Habilitar_Volatility_Analysis =  true;
   Market.Habilitar_Volume_Analysis =      false;
   Market.Habilitar_Gap_Analysis =         false;
   
   Market.Habilitar_DATE_Control = true;    // habilitação da verificação de datas proibidas
   
   Market.Memory_Analysis_15M = false;       // habilitação da analise de mercado no periodo de 15 minutos
   Market.Memory_Analysis_30M = false;       // habilitação da analise de mercado no periodo de 30 minutos
   
  }

// Desabilita as analises de mercado
void Market_Analysis_Manager_False()   
  {
   Market.Habilitar_Memory_Analysis = false;
   Market.Habilitar_Volatility_Analysis = false;
   Market.Habilitar_Volume_Analysis = false;
   Market.Habilitar_Gap_Analysis = false;
   
   Market.Memory_Analysis_15M = false;      
   Market.Memory_Analysis_30M = false;        
  }  
  
//+------------------------------------------------------------------+
//| Signals                                                          |
//+------------------------------------------------------------------+
// Booleanos utilizados na analise de mercado
void Args_Init()
  {
   Signals.memory_day_min_max_alloc = false;
   Signals.memory_day_min_max_alloc_30M = false;
   Signals.memory_final_frequency_results = false;
   
   Signals.volat_day_min_max_alloc = false;
   Signals.volat_final_frequency_results = false;
   
   Signals.volume_day_min_max_alloc = false;
   Signals.volume_final_frequency_results = false;
   
  }
      
//+------------------------------------------------------------------+
//| Definição de Variáveis Globais                                   |
//+------------------------------------------------------------------+
// definição das variaveis globais de inicialização
void Global_Var()
   {
    // identificadores
    Global.identificador = MQLInfoString(MQL_PROGRAM_NAME); // nome do robo e ativo
    Global.b = _Symbol;        // tempo em unixtime na pasta de saida q contem os arquivos gerados no codigo
    Global.subfolder = Global.identificador+"_"+Global.b;
    // variaveis
    Global.memory_i = 9;    // hora
    Global.memory_j = 15;   // minutos
    Global.memory_k = 1;    // periodo
    Global.memory_i_30M = 9;    // hora
    Global.memory_j_30M = 30;   // minutos
    Global.memory_k_30M = 1;    // periodo
    
    Global.volat_i = 1;    // hora
    Global.volat_j = 15;   // minutos
    Global.volat_k = 1;    // periodo
    
    Global.volume_i = 9;    // hora
    Global.volume_j = 15;   // minutos
    Global.volume_k = 1;    // periodo
    
    
   }


//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Pre Defined Structs                                              |
//+------------------------------------------------------------------+
// Information about the prices, volumes and spread of each candle. 
MqlRates            mrate[]; 
// The date type structure contains eight fields of the int type. 
MqlDateTime         str1;

//+------------------------------------------------------------------+
//| MARKET ANALYSIS MANAGMENT                                        |
//+------------------------------------------------------------------+
struct Args_Market_Analysis
  {
   bool Habilitar_Memory_Analysis;
   bool Habilitar_Volatility_Analysis;
   bool Habilitar_Volume_Analysis;
   bool Habilitar_Gap_Analysis;
   
   bool Habilitar_DATE_Control;        // habilitação da verificação de datas proibidas
   
   bool Memory_Analysis_15M;           // habilitação da analise de mercado no periodo de 15 minutos
   bool Memory_Analysis_30M;           // habilitação da analise de mercado no periodo de 30 minutos
   
  } Market;

//+------------------------------------------------------------------+
//| Signals                                                          |
//+------------------------------------------------------------------+
struct Args_Signals
  {
   bool memory_day_min_max_alloc;
   bool memory_day_min_max_alloc_30M;
   bool memory_final_frequency_results;
   
   bool volat_day_min_max_alloc;
   bool volat_final_frequency_results;
   
   bool volume_day_min_max_alloc;
   bool volume_final_frequency_results;
   
  } Signals;

//+------------------------------------------------------------------+
//| Struct de Variáveis Globais                                      |
//+------------------------------------------------------------------+
struct Global_Variables   
  {
   // variáveis datetime
   datetime date1;                  // variaveis globais para uso e manipulação do datetime
   datetime tm;
   datetime tm1;
   // variáveis string
   string tick_unixtime;            // unixtime da função on_tick
   string identificador;                   // nome da pasta de saida q contem os arquivos gerados no codigo em simulação
   string b;                   // tempo em unixtime na pasta de saida q contem os arquivos gerados no codigo
   string subfolder;
   // variáveis int
   int hour,min,sec;
   int filehandle_Memory_Validation;              // handle da saida de Memory Analysis_15M
   int filehandle_Memory_Max;          // handle da saida de Memory Analysis_15M
   int filehandle_Memory_Min;          // handle da saida de Memory Analysis_15M
   int filehandle_Memory_Validation_30M;          // handle da saida de Memory Analysis_30M
   int filehandle_Memory_Max_30M;      // handle da saida de Memory Analysis_30M
   int filehandle_Memory_Min_30M;      // handle da saida de Memory Analysis_30M
   
   int filehandle_Volat_Validation;              // handle da saida de Memory Analysis_15M
   int filehandle_Volat_Max;          // handle da saida de Memory Analysis_15M
   int filehandle_Volat_Min;          // handle da saida de Memory Analysis_15M
   int filehandle_Volat_Range;          // handle da saida de Memory Analysis_30M
   int filehandle_Volat_Frequency_Max;          // handle da saida de Memory Analysis_15M
   int filehandle_Volat_Frequency_Min;          // handle da saida de Memory Analysis_15M
   
   int filehandle_Volume_Validation;              // handle da saida de Memory Analysis_15M
   int filehandle_Volume_Max;          // handle da saida de Memory Analysis_15M
   int filehandle_Volume_Min;          // handle da saida de Memory Analysis_15M
   int filehandle_Volume_Frequency_Max;          // handle da saida de Memory Analysis_15M
   int filehandle_Volume_Frequency_Min;          // handle da saida de Memory Analysis_15M
   
   int memory_i;    // hora
   int memory_j;    // minutos
   int memory_k;    // periodo
   int memory_i_30M;    // hora
   int memory_j_30M;    // minutos
   int memory_k_30M;    // periodo
   
   int volat_i;    // hora
   int volat_j;    // minutos
   int volat_k;    // periodo
   
   int volume_i;    // hora
   int volume_j;    // minutos
   int volume_k;    // periodo
   
   double memory_F_min[36];        // minima do dia
   double memory_F_max[36];        // maxima do dia
   double memory_F_min_30M[18];        // minima do dia
   double memory_F_max_30M[18];        // maxima do dia
   
   double volat_F_min[800];        // minima do dia
   double volat_F_max[800];        // maxima do dia
   
   double volume_F_min[36];        // minima do dia
   double volume_F_max[36];        // maxima do dia
   
   int count_memory_F_min[100];     // contagem da minima do dia
   int count_memory_F_max[100];     // contagem da maxima do dia
   int count_memory_F_min_30M[200];     // contagem da minima do dia
   int count_memory_F_max_30M[200];     // contagem da maxima do dia
   
   int count_volat_F_min[200];     // contagem da minima do dia
   int count_volat_F_max[200];     // contagem da maxima do dia
   
   int count_volume_F_min[100];     // contagem da minima do dia
   int count_volume_F_max[100];     // contagem da maxima do dia
  
  } Global;


//+------------------------------------------------------------------+