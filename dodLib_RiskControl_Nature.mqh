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
     if(  
           MaxGain_SQUEEZE == 0 
        || MaxLoss_SQUEEZE == 0
        || MaxGain_SQUEEZE == 0 
        || MaxLoss_SQUEEZE == 0
        || MaxGain_SQUEEZE_HEAD == 0 
        || MaxLoss_SQUEEZE_HEAD == 0  )
       {
        Debug_Alert(" MaxLoss e MaxGain não definidos!!!!"); 
        return;
       }
       
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA SQUEEZE short ##################
     if(   Strategy.Habilitar_Risk_Control_SQUEEZE 
        && Global_Get("TradeSignal_SQUEEZE")        )
       {  
        if((Global.price_trade_start - tick.ask) > MaxGain_SQUEEZE)
          {
           CloseShortPosition(); 
           if(Strategy.Debug){
           Debug(" Fechamento de operação SQUEEZE short por MaxGain com PL: "+(Global.price_trade_start - tick.ask)); }   
           return;
          }
          
        if((Global.price_trade_start - tick.ask) < MaxLoss_SQUEEZE)
          {
           CloseShortPosition();  
           if(Strategy.Debug){
           Debug(" Fechamento de operação SQUEEZE short por MaxLoss com PL: "+(Global.price_trade_start - tick.ask)); }
          }  
       }         
       
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA SQUEEZE_HEAD short ##################
     if(   Strategy.Habilitar_Risk_Control_SQUEEZE_HEAD 
        && Global_Get("TradeSignal_SQUEEZE_HEAD")        )
       {  
        if((Global.price_trade_start - tick.ask) > MaxGain_SQUEEZE_HEAD)
          {
           CloseShortPosition(); 
           if(Strategy.Debug){
           Debug(" Fechamento de operação SQUEEZE_HEAD short por MaxGain com PL: "+(Global.price_trade_start - tick.ask)); }   
           return;
          }
          
        if((Global.price_trade_start - tick.ask) < MaxLoss_SQUEEZE_HEAD)
          {
           CloseShortPosition();  
           if(Strategy.Debug){
           Debug(" Fechamento de operação SQUEEZE_HEAD short por MaxLoss com PL: "+(Global.price_trade_start - tick.ask)); }
          }  
       }                
       
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA SQUEEZE_P5 short ##################
     if(   Strategy.Habilitar_Risk_Control_SQUEEZE_P5 
        && Global_Get("TradeSignal_SQUEEZE_P5")        )
       {  
        if((Global.price_trade_start - tick.ask) > MaxGain_SQUEEZE_P5)
          {
           CloseShortPosition(); 
           if(Strategy.Debug){
           Debug(" Fechamento de operação SQUEEZE_P5 short por MaxGain com PL: "+(Global.price_trade_start - tick.ask)); }   
           return;
          }
          
        if((Global.price_trade_start - tick.ask) < MaxLoss_SQUEEZE_P5)
          {
           CloseShortPosition();  
           if(Strategy.Debug){
           Debug(" Fechamento de operação SQUEEZE_P5 short por MaxLoss com PL: "+(Global.price_trade_start - tick.ask)); }
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
     if(   
           MaxGain_SQUEEZE == 0 
        || MaxLoss_SQUEEZE == 0
        || MaxGain_SQUEEZE_P5 == 0 
        || MaxLoss_SQUEEZE_P5 == 0
        || MaxGain_SQUEEZE_HEAD == 0 
        || MaxLoss_SQUEEZE_HEAD == 0   )
       {
        Debug_Alert(" MaxLoss e MaxGain não definidos!!!!"); 
        return;
       }
              
       
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA SQUEEZE long ##################
     if(   Strategy.Habilitar_Risk_Control_SQUEEZE 
        && Global_Get("TradeSignal_SQUEEZE")          )
       {  
        if((tick.bid - Global.price_trade_start) > MaxGain_SQUEEZE)
          {
           CloseLongPosition();            
           if(Strategy.Debug){ 
           Debug(" Fechamento de operação SQUEEZE long por MaxGain com PL: "
                   +(tick.bid - Global.price_trade_start)); }      
           return;
          } 
          
        if((tick.bid - Global.price_trade_start) < MaxLoss_SQUEEZE)
          {   
           CloseLongPosition();             
           if(Strategy.Debug){
           Debug(" Fechamento de operação SQUEEZE long por MaxLoss com PL: "
                   +(tick.bid - Global.price_trade_start)); }   
          }
          
       }         
       
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA SQUEEZE_HEAD long ##################
     if(   Strategy.Habilitar_Risk_Control_SQUEEZE_HEAD
        && Global_Get("TradeSignal_SQUEEZE_HEAD")          )
       {  
        if((tick.bid - Global.price_trade_start) > MaxGain_SQUEEZE_HEAD)
          {
           CloseLongPosition();            
           if(Strategy.Debug){ 
           Debug(" Fechamento de operação SQUEEZE_HEAD long por MaxGain com PL: "
                   +(tick.bid - Global.price_trade_start)); }      
           return;
          } 
          
        if((tick.bid - Global.price_trade_start) < MaxLoss_SQUEEZE_HEAD)
          {   
           CloseLongPosition();             
           if(Strategy.Debug){
           Debug(" Fechamento de operação SQUEEZE_HEAD long por MaxLoss com PL: "
                   +(tick.bid - Global.price_trade_start)); }   
          }
          
       }                
       
//############# CONTROLE DE RISCO EXCLUSIVO DA ESTRATÉGIA SQUEEZE_P5 long ##################
     if(   Strategy.Habilitar_Risk_Control_SQUEEZE_P5 
        && Global_Get("TradeSignal_SQUEEZE_P5")          )
       {  
        if((tick.bid - Global.price_trade_start) > MaxGain_SQUEEZE_P5)
          {
           CloseLongPosition();            
           if(Strategy.Debug){ 
           Debug(" Fechamento de operação SQUEEZE_P5 long por MaxGain com PL: "
                   +(tick.bid - Global.price_trade_start)); }      
           return;
          } 
          
        if((tick.bid - Global.price_trade_start) < MaxLoss_SQUEEZE_P5)
          {   
           CloseLongPosition();             
           if(Strategy.Debug){
           Debug(" Fechamento de operação SQUEEZE_P5 long por MaxLoss com PL: "
                   +(tick.bid - Global.price_trade_start)); }   
          }
          
       }                     
        
                       
    }   // fim do contole de risco long
    
} // fim da RISK_CONTROL()

//+------------------------------------------------------------------+