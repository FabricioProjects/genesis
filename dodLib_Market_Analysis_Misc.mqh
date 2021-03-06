//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"

//+------------------------------------------------------------------+
//| Miscelânea                                                       |
//+------------------------------------------------------------------+
void Market_Analysis_Misc()
  {
   // Verificação de disponibilidade de barras.
   int bars = Bars(Ativo,PERIOD_M15);
   int bars_P5 = Bars(Ativo,PERIOD_M5);
   if(bars > 0 && bars_P5 >0)
     { 
      Alert(" Number of bars for the symbol-period 15/5 at the moment = "+bars+"/"+bars_P5);        
     }
   else  // Sem barras disponíveis
     {
      // Dados sobre o ativo podem não estar sincronizados com os dados no servidor
      bool synchronized = false;
      // Contador de loop
      int attempts = 0;
      // Faz 5 tentativas de espera por sincronização
      while(attempts < 5)
        {
         if(SeriesInfoInteger(Ativo,0,SERIES_SYNCHRONIZED))
           {
            // Sincronização feita, sair
            synchronized = true;
            break;
           }
         // Aumentar o contador
         attempts++;
         // Espera 10 milissegundos até a próxima iteração
         Sleep(10);
        }
      // Sair do loop após sincronização
      if(synchronized)
        {
            Alert(" Number of bars for the symbol-period 15/5 at the moment = "+bars+"/"+bars_P5); 
            Alert("The first date in the terminal history for the symbol-period at the moment = "+
                 (datetime)SeriesInfoInteger(Ativo,0,SERIES_FIRSTDATE));     
            Alert("The first date in the history for the symbol on the server = "+
                 (datetime)SeriesInfoInteger(Ativo,0,SERIES_SERVER_FIRSTDATE));   
        }
      // Sincronização dos dados não aconteceu
      else
        {
         Alert(" Failed to get number of bars for "+Ativo);   
        }
     }
   
   // Do we have sufficient bars to work?
   if(bars < 61) // total number of bars is less than 61?
     {
      Alert(" We have less than 61 bars on the chart, an Expert Advisor terminated!! ");   
     }
  }
  
//+------------------------------------------------------------------+
//| RESET                                                            |
//+------------------------------------------------------------------+   
void Market_Analysis_Reset()
  {
   if(str1.hour == 9 && str1.min == 0)
     {    
      // memory
      Global.memory_i = 9;    // hora
      Global.memory_j = 15;   // minutos
      Global.memory_k = 1;    // periodo
      Global.memory_i_30M = 9;    // hora
      Global.memory_j_30M = 30;   // minutos
      Global.memory_k_30M = 1;    // periodo
      Signals.memory_day_min_max_alloc = false;  // para alocar somente uma vez
      Signals.memory_day_min_max_alloc_30M = false;  // para alocar somente uma vez
      Signals.memory_final_frequency_results = false;
      
      // volatility
//      Global.volat_i = 9;    // hora
      Global.volat_j = 15;   // minutos
      Global.volat_k = 1;    // periodo
      Signals.volat_day_min_max_alloc = false;  // para alocar somente uma vez
      Signals.volat_final_frequency_results = false;
      
      // volume
      Global.volume_i = 9;    // hora
      Global.volume_j = 15;   // minutos
      Global.volume_k = 1;    // periodo
      Signals.volume_day_min_max_alloc = false;  // para alocar somente uma vez
      Signals.volume_final_frequency_results = false;
      
     }
     
  } // fim da Market_Analysis_Reset()
  
//+------------------------------------------------------------------+
//| MARKET ANALYSIS DATE CONTROL                                     |
//+------------------------------------------------------------------+   
void Market_Analysis_Date_Control()
  {  
   if(Market.Habilitar_DATE_Control)
     {
      // controle de datas nao consideradas nas otimizações
      if(    str1.year == 2013 && str1.mon == 02
         &&  str1.day == 13   
         &&  str1.hour == 13 && str1.min == 00   )  
        {
         Market_Analysis_Manager_False();
        }
      // controle de datas nao consideradas nas otimizações
      if(    str1.year == 2014 && str1.mon == 03
         &&  str1.day == 5   
         &&  str1.hour == 13 && str1.min == 00   )  
        {
         Market_Analysis_Manager_False();
        }  
      // controle de datas nao consideradas nas otimizações
      if(    str1.year == 2015 && str1.mon == 02
         &&  str1.day == 18   
         &&  str1.hour == 13 && str1.min == 00   )  
        {
         Market_Analysis_Manager_False();
        }  
      // dias de jogos do brasil em junho WC 2014
      if(    str1.year == 2014 && str1.mon == 06 
         && (str1.day == 12 || str1.day == 17 || str1.day == 23)   
         &&  str1.hour == 09 && str1.min == 00   )  
        {
         Market_Analysis_Manager_False();
        }
      // dias de jogos do brasil em julho WC 2014
      if(    str1.year == 2014 && str1.mon == 07 
         && (str1.day == 04 || str1.day == 08 )   
         &&  str1.hour == 09 && str1.min == 00 )  
        {
         Market_Analysis_Manager_False();
        }
      // reseta para o dia seguinte 
      if(   str1.hour == 17 
         && str1.min == 46 ) 
        {
         Market_Analysis_Manager();
        }  
               
     }
  }  // fim da date control
    

//+------------------------------------------------------------------+