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
     if(   MaxGain_EARLY == 0 
        || MaxLoss_EARLY == 0  
        || MaxGain_EARLY_NY == 0 
        || MaxLoss_EARLY_NY == 0 )
       {
        Debug_Alert(" MaxLoss e MaxGain não definidos!!!!"); 
        return;
       }
     
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA EARLY short ##################
     if(   Strategy.Habilitar_Risk_Control_EARLY 
        && Signals.TradeSignal_EARLY            )
       {  
        if((Global.price_trade_start - tick.ask) > MaxGain_EARLY)
          {
           CloseShortPosition(); 
           if(Strategy.Debug){
           Debug(" Fechamento de operação EARLY short por MaxGain com PL: "+(Global.price_trade_start - tick.ask)); }   
           return;
          }
          
        if((Global.price_trade_start - tick.ask) < MaxLoss_EARLY)
          {
           CloseShortPosition();  
           if(Strategy.Debug){
           Debug(" Fechamento de operação EARLY short por MaxLoss com PL: "+(Global.price_trade_start - tick.ask)); }
          }  
       }     
       
 //############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA EARLY_NY short ##################
     if(   Strategy.Habilitar_Risk_Control_EARLY_NY 
        && Signals.TradeSignal_EARLY_NY            )
       {  
        if((Global.price_trade_start - tick.ask) > MaxGain_EARLY_NY)
          {
           CloseShortPosition(); 
           if(Strategy.Debug){
           Debug(" Fechamento de operação EARLY_NY short por MaxGain com PL: "+(Global.price_trade_start - tick.ask)); }        
           return;
          }
          
        if((Global.price_trade_start - tick.ask) < MaxLoss_EARLY_NY)
          {
           CloseShortPosition();  
           if(Strategy.Debug){
           Debug(" Fechamento de operação EARLY_NY short por MaxLoss com PL: "+(Global.price_trade_start - tick.ask)); }
          }  
       }           
       
     }  // fim do controle de risco short
     
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
     if(   MaxGain_EARLY == 0 
        || MaxLoss_EARLY == 0 
        || MaxGain_EARLY_NY == 0 
        || MaxLoss_EARLY_NY == 0 )
       {
        Debug_Alert(" MaxLoss e MaxGain não definidos!!!!"); 
        return;
       }
     
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA EARLY long ##################
     if(   Strategy.Habilitar_Risk_Control_EARLY 
        && Signals.TradeSignal_EARLY            )
       {  
        if((tick.bid - Global.price_trade_start) > MaxGain_EARLY)
          {
           CloseLongPosition();            
           if(Strategy.Debug){ 
           Debug(" Fechamento de operação EARLY long por MaxGain com PL: "
                   +(tick.bid - Global.price_trade_start)); }          
           return;
          } 
          
        if((tick.bid - Global.price_trade_start) < MaxLoss_EARLY)
          {   
           CloseLongPosition();             
           if(Strategy.Debug){
           Debug(" Fechamento de operação EARLY long por MaxLoss com PL: "
                   +(tick.bid - Global.price_trade_start)); }       
          }
          
       }                    

//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA EARLY_NY long ##################
     if(   Strategy.Habilitar_Risk_Control_EARLY_NY 
        && Signals.TradeSignal_EARLY_NY            )
       {  
        if((tick.bid - Global.price_trade_start) > MaxGain_EARLY_NY)
          {
           CloseLongPosition();            
           if(Strategy.Debug){ 
           Debug(" Fechamento de operação EARLY_NY long por MaxGain com PL: "
                   +(tick.bid - Global.price_trade_start)); }      
           return;
          } 
          
        if((tick.bid - Global.price_trade_start) < MaxLoss_EARLY_NY)
          {   
           CloseLongPosition();             
           if(Strategy.Debug){
           Debug(" Fechamento de operação EARLY_NY long por MaxLoss com PL: "
                   +(tick.bid - Global.price_trade_start)); }   
          }
          
       }         
                       
    }   // fim do contole de risco long
    
} // fim da RISK_CONTROL()

//+------------------------------------------------------------------+