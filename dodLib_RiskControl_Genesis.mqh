//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"

//+------------------------------------------------------------------+
//| RISK CONTROL strategy                                            |
//+------------------------------------------------------------------+

// PL tick a tick da operação em aberto para verificar limites maximos de ganho e perda
void RISK_CONTROL()
{ 
  // Aloca a posição da trade dada pela corretora
  if(Signals.ShortPosition)
    {
     MqlTick tick;   // Struct for tick info about current prices.
     if(!SymbolInfoTick(Ativo,tick))
       {
        Debug_Alert(" SymbolInfoTick() failed, error = "+GetLastError() ); 
        ResetLastError();
        return;
       }  
     // habilita ou não a geração de arquivo de PL q são longos     
     if(Strategy.PL){
        Global.filehandle_PL = FileOpen(Global.subfolder+"\\PL.txt",FILE_READ|FILE_WRITE|FILE_CSV);
        if(Global.filehandle_PL != INVALID_HANDLE)
          {
           FileSeek(Global.filehandle_PL,0,SEEK_END);
           FileWrite(  Global.filehandle_PL,"TimeCurrent: "+TimeCurrent()
                     +" TickTime: "+tick.time+" PL_short: "
                     +(Global.price_trade_start - tick.ask)    );
           FileFlush(Global.filehandle_PL);          
           FileClose(Global.filehandle_PL);         
          }
        else Debug_Alert("Operation FileOpen PL failed "); }       
     
     // verifica se os parametros de ganho e perda maximos foram passados
     if(   MaxLoss_STOCH_1_2 == 0 
        || MaxGain_STOCH_1_2 == 0 )
       {
        Debug_Alert(" MaxLoss e MaxGain não definidos!!!!"); 
        return;
       }
                 
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA STOCH_1_2 short ##################
     if(   Strategy.Habilitar_Risk_Control_STOCH_1_2 
        && (   Signals.TradeSignal_STOCH1  
            || Signals.TradeSignal_STOCH2 )           )
       {  
        if((Global.price_trade_start - tick.ask) > MaxGain_STOCH_1_2)
          {
           CloseShortPosition(); 
           if(Strategy.Debug){
           Debug(" Fechamento de operação STOCH_2 short por MaxGain com PL: "+(Global.price_trade_start - tick.ask)); }   
           return;
          }
          
        if((Global.price_trade_start - tick.ask) < MaxLoss_STOCH_1_2)
          {
           CloseShortPosition();  
           if(Strategy.Debug){
           Debug(" Fechamento de operação STOCH_2 short por MaxLoss com PL: "+(Global.price_trade_start - tick.ask)); }
          }  
       }            
       
       
     }  // fim do controle short
  
   if(Signals.LongPosition)
    {
     MqlTick tick;   // Struct for tick info about current prices.
     if(!SymbolInfoTick(Ativo,tick))
       {
        Debug_Alert(" SymbolInfoTick() failed, error: "+GetLastError() ); 
        ResetLastError();
        return;
       }
     
     // habilita ou não a geração de arquivo de PL q são longos     
     if(Strategy.PL){    
        Global.filehandle_PL = FileOpen(Global.subfolder+"\\PL.txt",FILE_READ|FILE_WRITE|FILE_CSV);
        if(Global.filehandle_PL != INVALID_HANDLE)
          {
           FileSeek(Global.filehandle_PL,0,SEEK_END);
           FileWrite(Global.filehandle_PL, "TimeCurrent: "+TimeCurrent()
                                          +" TickTime: "+tick.time
                                          +" PL_long: "+(tick.bid - Global.price_trade_start) );
           FileFlush(Global.filehandle_PL);          
           FileClose(Global.filehandle_PL);         
          }
        else Debug_Alert("Operation FileOpen PL failed "); }
     
     // verifica se os parametros de ganho e perda maximos foram passados
     if(   MaxLoss_STOCH_1_2 == 0
        || MaxGain_STOCH_1_2 == 0)
       {
        Debug_Alert(" MaxLoss e MaxGain não definidos!!!!"); 
        return;
       }
        
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA STOCH_1_2 long ##################
     if(   Strategy.Habilitar_Risk_Control_STOCH_1_2 
        && (   Signals.TradeSignal_STOCH1  
            || Signals.TradeSignal_STOCH2 )           )
       {  
        if((tick.bid - Global.price_trade_start) > MaxGain_STOCH_1_2)
          {
           CloseLongPosition();            
           if(Strategy.Debug){ 
           Debug(" Fechamento de operação STOCH_2 long por MaxGain com PL: "
                   +(tick.bid - Global.price_trade_start)); }      
           return;
          } 
          
        if((tick.bid - Global.price_trade_start) < MaxLoss_STOCH_1_2)
          {   
           CloseLongPosition();             
           if(Strategy.Debug){
           Debug(" Fechamento de operação STOCH_2 long por MaxLoss com PL: "
                   +(tick.bid - Global.price_trade_start)); }   
          }
          
       }               
       
       
    }  // fim do controle long 
    
}  // fim da RISK_CONTROL()

//+------------------------------------------------------------------+