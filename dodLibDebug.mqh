//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| Debug                                                            |
//+------------------------------------------------------------------+
void Debug(string texto)
  { 
   Global.filehandle = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                +"_Debug.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle,0,SEEK_END);
      FileWrite(Global.filehandle,TimeCurrent()+texto);
      FileFlush(Global.filehandle);
      FileClose(Global.filehandle);
     }
   else Alert("Operation FileOpen debug failed, error ",GetLastError()); 
   ResetLastError();
   
  }
  
void Debug_Set_Init()
  {
   // abre o arquivo de hints    
   if(Strategy.Simulation) {
   Hints(  "#1|INITIALIZE UNIXTIME\t"
          +"2|INITIALIZE DATETIME\t"
          +"3|FINALIZE UNIXTIME\t"
          +"4|FINALIZE DATETIME\t"
          +"5|DIRECTION\t"
          +"6|STATUS\t"
          +"7|BUY PRICE\t"
          +"8|SELL PRICE\t"
          +"9|STOP LOSS\t"
          +"10|STOP GAIN\t"
          +"11|QUANTITY\t"
          +"12|TICKS"       ); }
   
   // abre o arquivo de debug e aloca o set de gerenciamento de estrategias
   if(Strategy.Debug){
     if(Robo == 0){      // Genesis
     Debug(" Inicio do Debug - Robô: "+MQLInfoString(MQL_PROGRAM_NAME)+" - Ativo: "+Symbol()+"\n"
           +"##### ESTRATEGIAS #####"+"\n"
           +"Habilitar_STOCH1:                "    +Strategy.Habilitar_STOCH1+"\n"
           +"Habilitar_STOCH1_Once:           "    +Strategy.Habilitar_STOCH1_Once+"\n"
           +"Habilitar_STOCH2:                "    +Strategy.Habilitar_STOCH2+"\n"
           +"Habilitar_STOCH2_Once:           "    +Strategy.Habilitar_STOCH2_Once+"\n"
           +"Habilitar_Risk_Control_STOCH_1_2:  "    +Strategy.Habilitar_Risk_Control_STOCH_1_2+"\n"
           +"Habilitar_ACD:                   "    +Strategy.Habilitar_ACD+"\n"
           +"Habilitar_ACD_Once:              "    +Strategy.Habilitar_ACD_Once+"\n"
           +"##### SUB-ESTRATEGIAS #####"+"\n"
           +"Habilitar_Risk_Control:          "    +Strategy.Habilitar_Risk_Control+"\n"
           +"Habilitar_GAP_Control:           "    +Strategy.Habilitar_GAP_Control+"\n"
           +"Habilitar_MA_Control:            "    +Strategy.Habilitar_MA_Control+"\n"
           +"Habilitar_MA_Oscillation:        "    +Strategy.Habilitar_MA_Oscillation+"\n"
           +"Habilitar_Breakeven:             "    +Strategy.Habilitar_Breakeven+"\n"
           +"Habilitar_CS_Control:            "    +Strategy.Habilitar_CS_Control+"\n"
           +"Modo Simulation:                 "    +Strategy.Simulation+"\n"                     ); } 
                          
     if(Robo == 1){      // Impetus
     Debug(" Inicio do Debug - Robô: "+MQLInfoString(MQL_PROGRAM_NAME)+" - Ativo: "+Symbol()+"\n"
           +"##### ESTRATEGIAS #####"+"\n"
           +"Habilitar_EARLY:                 "    +Strategy.Habilitar_EARLY+"\n"
           +"Habilitar_Risk_Control_EARLY:    "    +Strategy.Habilitar_Risk_Control_EARLY+"\n"
           +"Habilitar_EARLY_NY:              "    +Strategy.Habilitar_EARLY_NY+"\n"
           +"Habilitar_Risk_Control_EARLY_NY: "    +Strategy.Habilitar_Risk_Control_EARLY_NY+"\n"
           +"##### SUB-ESTRATEGIAS #####"+"\n"
           +"Habilitar_Risk_Control:          "    +Strategy.Habilitar_Risk_Control+"\n"
           +"Habilitar_GAP_Control:           "    +Strategy.Habilitar_GAP_Control+"\n"
//           +"Habilitar_MA_Control:            "    +Strategy.Habilitar_MA_Control+"\n"
           +"Habilitar_Breakeven:             "    +Strategy.Habilitar_Breakeven+"\n"
           +"Modo Simulation:                 "    +Strategy.Simulation+"\n"                 );} 
           
     if(Robo == 2){      // Nature
     Debug(" Inicio do Debug - Robô: "+MQLInfoString(MQL_PROGRAM_NAME)+" - Ativo: "+Symbol()+"\n"
           +"##### ESTRATEGIAS #####"+"\n"
           +"Habilitar_SQUEEZE:                   "  +Strategy.Habilitar_SQUEEZE+"\n"
           +"Habilitar_SQUEEZE_Once:              "  +Strategy.Habilitar_SQUEEZE_Once+"\n"
           +"Habilitar_Risk_Control_SQUEEZE:      "  +Strategy.Habilitar_Risk_Control_SQUEEZE+"\n"
           +"Habilitar_SQUEEZE_HEAD:              "  +Strategy.Habilitar_SQUEEZE_HEAD+"\n"
           +"Habilitar_Risk_Control_SQUEEZE_HEAD: "  +Strategy.Habilitar_Risk_Control_SQUEEZE_HEAD+"\n"
           +"Habilitar_Habilitar_GAP:             "  +Strategy.Habilitar_GAP+"\n"
//           +"Habilitar_SQUEEZE_P5:                "  +Strategy.Habilitar_SQUEEZE_P5+"\n"
//           +"Habilitar_SQUEEZE_P5_Once:           "  +Strategy.Habilitar_SQUEEZE_P5_Once+"\n"
//           +"Habilitar_Risk_Control_SQUEEZE_P5:   "  +Strategy.Habilitar_Risk_Control_SQUEEZE_P5+"\n"
           +"##### SUB-ESTRATEGIAS #####"+"\n"
           +"Habilitar_Risk_Control:              "  +Strategy.Habilitar_Risk_Control+"\n"
           +"Habilitar_GAP_Control:               "  +Strategy.Habilitar_GAP_Control+"\n"
           +"Habilitar_MA_Control:                "  +Strategy.Habilitar_MA_Control+"\n"
           +"Habilitar_Breakeven:                 "  +Strategy.Habilitar_Breakeven+"\n"
           +"Habilitar_CS_Control:                "  +Strategy.Habilitar_CS_Control+"\n"
           +"Modo Simulation:                     "  +Strategy.Simulation+"\n"                 );}   
           
     if(Robo == 3){      // Akira
     Debug(" Inicio do Debug - Robô: "+MQLInfoString(MQL_PROGRAM_NAME)+" - Ativo: "+Symbol()+"\n"
           +"##### ESTRATEGIAS #####"+"\n"
           +"Habilitar_CANDLESTICKS_P15:               "  +Strategy.Habilitar_CANDLESTICKS_P15+"\n"
           +"Habilitar_CANDLESTICKS_P15_Once:          "  +Strategy.Habilitar_CANDLESTICKS_P15_Once+"\n"
           +"Habilitar_Risk_Control_CANDLESTICKS_P15:  "  +Strategy.Habilitar_Risk_Control_CANDLESTICKS_P15+"\n"
           +"##### SUB-ESTRATEGIAS #####"+"\n"
           +"Habilitar_Risk_Control:                   "  +Strategy.Habilitar_Risk_Control+"\n"
           +"Habilitar_GAP_Control:                    "  +Strategy.Habilitar_GAP_Control+"\n"
           +"Modo Simulation:                          "  +Strategy.Simulation+"\n"                 );}          
           
           }     
  
   // abre o arquivo de alertas
   Debug_Alert(" Inicio do Alert - Robô: "+MQLInfoString(MQL_PROGRAM_NAME)+" - Ativo: "+Symbol() );
   
   // abre o arquivo de PL 
   if(Strategy.PL){
   PL(" Inicio do PL - Robô: "+MQLInfoString(MQL_PROGRAM_NAME)+" - Ativo: "+Symbol()); }
  
  
  }  
  
//+------------------------------------------------------------------+
//| Alerts                                                           |
//+------------------------------------------------------------------+
void Debug_Alert(string texto)
  {
   Global.filehandle_alert = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Alert.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_alert!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_alert,0,SEEK_END);
      FileWrite(Global.filehandle_alert,TimeCurrent()+texto);
      FileFlush(Global.filehandle_alert);
      FileClose(Global.filehandle_alert);
     }
   else Alert("Operation FileOpen alert failed, error: ",GetLastError() );
        ResetLastError();
   
   }
   
//+------------------------------------------------------------------+
//| Tick Control                                                     |
//+------------------------------------------------------------------+
void Debug_Tick_Control(string texto)
  {
   Global.filehandle_tick_control = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                      +"_Tick_Control.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_tick_control!= INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_tick_control,0,SEEK_END);
      FileWrite(Global.filehandle_tick_control,TimeCurrent()+texto);
      FileFlush(Global.filehandle_tick_control);
      FileClose(Global.filehandle_tick_control);
     }
   else Alert("Operation FileOpen tick control failed, error: ",GetLastError() );
        ResetLastError();
   
   }   

//+------------------------------------------------------------------+
//| Hints                                                            |
//+------------------------------------------------------------------+
void Hints(string texto)
  {   
   if(Strategy.Simulation)
     {
      Global.filehandle_hints = FileOpen(Global.subfolder+"\\"+MQLInfoString(MQL_PROGRAM_NAME)
                                                         +"_Hints.txt",FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
      if(Global.filehandle_hints != INVALID_HANDLE)
       {
        FileSeek(Global.filehandle_hints,0,SEEK_END);
        FileWrite(Global.filehandle_hints,texto);
        FileFlush(Global.filehandle_hints);                            
        FileClose(Global.filehandle_hints);         
       }
      else Alert("Operation FileOpen hints failed, error: ",GetLastError() );
           ResetLastError();  
     }
   // Hints de saída em produção  
   else  // produção
     {
      if(Signals.LongPosition)
        {
         string t = TimeCurrent();         
         string saida_long = _Symbol+""+Global.lum+""+t+""+Global.um;
         Global.filehandle_hints = FileOpen(  Global.subfolder_prd+"\\"
                                            + saida_long,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
         if(Global.filehandle_hints != INVALID_HANDLE)
           {       
            FileSeek(Global.filehandle_hints,0,SEEK_END);
            FileWrite(Global.filehandle_hints,texto);
            FileFlush(Global.filehandle_hints);          
            FileClose(Global.filehandle_hints);  
            // envia o hint para o servidor dod-studio
            bool  result = SendFTP(Global.subfolder_prd+"\\"+saida_long);
            if(Strategy.Debug && result)
              {
               Debug(" SendFTP = "+result); 
              }  
            else Alert(" FTP não enviado!!!!!!!! ");  
         
           }
         else Print("Operation FileOpen hints failed, error ",GetLastError() );
              ResetLastError(); 
        } 
      else 
        {
         if(Signals.ShortPosition)
           {
            string t = TimeCurrent();         
            string saida_short = _Symbol+""+Global.sum+""+t+""+Global.um;
            Global.filehandle_hints = FileOpen(  Global.subfolder_prd+"\\"
                                               + saida_short,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
            if(Global.filehandle_hints != INVALID_HANDLE)
              {       
               FileSeek(Global.filehandle_hints,0,SEEK_END);
               FileWrite(Global.filehandle_hints,texto);
               FileFlush(Global.filehandle_hints);          
               FileClose(Global.filehandle_hints);   
               // envia o hint para o servidor dod-studio
               bool  result = SendFTP(Global.subfolder_prd+"\\"+saida_short);
               if(Strategy.Debug && result)
                 {
                  Debug(" SendFTP = "+result); 
                 }  
               else Alert(" FTP não enviado!!!!!!!! ");       
                 }
                 
            else Print("Operation FileOpen hints failed, error ",GetLastError() ); 
                 ResetLastError();
           }   
        }
     }  
  }     

// Hints de entrada short em produção
void Hints_Enter_Short(string texto)
  {   
   string t = TimeCurrent();         
   string entrada_short = _Symbol+""+Global.szero+""+t+""+Global.zero;
   Global.filehandle_hints = FileOpen(  Global.subfolder_prd+"\\"
                                      + entrada_short,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
                              
   if(Global.filehandle_hints != INVALID_HANDLE)
     {       
      FileSeek(Global.filehandle_hints,0,SEEK_END);
      FileWrite(Global.filehandle_hints,texto);
      FileFlush(Global.filehandle_hints);          
      FileClose(Global.filehandle_hints); 
      // envia o hint para o servidor dod-studio
      if(!Strategy.Simulation) 
        { 
         bool  result = SendFTP(Global.subfolder_prd+"\\"+entrada_short);
         if(Strategy.Debug && result)
           {
            Debug(" SendFTP = "+result); 
           }  
         else Alert(" FTP não enviado!!!!!!!! ");  
        }        
     }
    else Print("Operation FileOpen hints failed, error ",GetLastError() );
         ResetLastError();   
   }  

// Hints de entrada long em produção  
void Hints_Enter_Long(string texto)
  {   
   string t = TimeCurrent();         
   string entrada_long = _Symbol+""+Global.lzero+""+t+""+Global.zero;
   Global.filehandle_hints = FileOpen(  Global.subfolder_prd+"\\"
                                      + entrada_long,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
   if(Global.filehandle_hints != INVALID_HANDLE)
     {       
      FileSeek(Global.filehandle_hints,0,SEEK_END);
      FileWrite(Global.filehandle_hints,texto);
      FileFlush(Global.filehandle_hints);          
      FileClose(Global.filehandle_hints);
      // envia o hint para o servidor dod-studio
      if(!Strategy.Simulation) 
        { 
         bool  result = SendFTP(Global.subfolder_prd+"\\"+entrada_long);
         if(Strategy.Debug && result)
           {
            Debug(" SendFTP = "+result); 
           }  
         else Alert(" FTP não enviado!!!!!!!! ");  
        }
      }
    else Print("Operation FileOpen hints failed, error ",GetLastError() ); 
         ResetLastError();   
   }    
  
//+------------------------------------------------------------------+
//| PL                                                               |
//+------------------------------------------------------------------+   
void PL(string texto)
  { 
   Global.filehandle_PL = FileOpen(Global.subfolder+"\\Genesis_PL.txt",FILE_READ|FILE_WRITE|FILE_CSV);
   if(Global.filehandle_PL != INVALID_HANDLE)
     {
      FileSeek(Global.filehandle_PL,0,SEEK_END);
      FileWrite(Global.filehandle_PL,TimeCurrent()+texto);
      FileFlush(Global.filehandle_PL);
      FileClose(Global.filehandle_PL);
     }
   } 






//+------------------------------------------------------------------+