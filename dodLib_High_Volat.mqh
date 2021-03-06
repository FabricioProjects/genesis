//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| High_Volat strategy                                                     |
//+------------------------------------------------------------------+

// Verificação das condições de negociação da estratégia High_Volat  
void Estrategia_High_Volat()
   {
   // Verificação das condições de negociação da estratégia High_Volat    
   if( !PositionSelect(Ativo) )
     {
      // verifica horários não permitidos para entrada de operação
      if(   
//            (str1.hour == TradeStartHour && str1.min <= TradeStartMin)
            (str1.hour >= BlockTradeStartHour && str1.min >= BlockTradeStartMin)
         || (str1.hour == 18 && str1.min >= 00)
         
         // testes
//         || (str1.min == 00)
         || (str1.hour > 9 || str1.min >= min_enter)     // abertura do mercado
//         || (str1.hour < 15 || str1.min >= min_enter)  // pico de liquidez da tarde
                                                    )
        {
         return;    // sai da função e prossegue no mesmo tick
        }
      else  // horário permitido
        {
         High_Volat();  
        }       
     }
   else
     {
      if(Signals.TradeSignal_High_Volat)
        {
         High_Volat_SL_SG();
        }
     }
   }
   
  
void High_Volat()
  {
   Buffers();
   double price = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
   double diff_n = (Ind.BBUp[1] - Ind.BBMid[1]) * sigma_n_factor;  // acrescimo de desvios padroes 
   
   if(Strategy.Habilitar_Short_Enter)
     {
      // Condições de venda High_Volat 
      if(  
            price >= Ind.BBUp_n[1] + diff_n 
         && Ind.BBandwidth_Buffer[1] > volat_limit 
                                                   )                                                   
        {                                             
         OpenShortPosition(); 
         if(Signals.ShortPosition == true)
           {
            Signals.TradeSignal_High_Volat = true;
            if(Strategy.Debug){
            Debug(" Ordem de venda High_Volat: "); }  
           }
         else
           {
            Alert(" Falhou a Tentativa de Entrada!!!");
            Debug_Alert(" Falhou a Tentativa de Entrada!!!");
            return;
           }                    
        }
      } 
     
   if(Strategy.Habilitar_Long_Enter)
     {  
      // Condições de compra High_Volat 
      if(  
            price <= Ind.BBLow_n[1] - diff_n
         && Ind.BBandwidth_Buffer[1] > volat_limit             
                                                   )                                                   
        { 
         OpenLongPosition(); 
         if(Signals.LongPosition == true)
           {
            Signals.TradeSignal_High_Volat = true;
            if(Strategy.Debug){
            Debug(" Ordem de compra High_Volat: "); }  
           }
         else
           {
            Alert(" Falhou a Tentativa de Entrada!!!");
            Debug_Alert(" Falhou a Tentativa de Entrada!!!");
            return;
           }                                              
                           
        }  
      }    
       
  } // fim da High_Volat()   

void High_Volat_SL_SG()
  {  
   Buffers();
   double price = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
   double diff = (Ind.BBUp[1] - Ind.BBMid[1]);    // desvio padrao
   double diff_n = (Ind.BBUp[1] - Ind.BBMid[1]) * sigma_n_factor_stop;  // acrescimo de desvios padroes
   
   // verificação de saidas de posição de compra
   if(Signals.LongPosition)
     { 
     
      // Condições de compra High_Volat dobrando os contratos
      if( 
            Signals.Double_Lots == false 
         && price <= long(Global.price_trade_start) - diff/2            
                                                                 )                                                   
        { 
         Global.contratos = 2*Lots;
         OpenLongPosition(); 
         if(Signals.LongPosition == true)
           {
            Signals.Double_Lots = true;
            if(Strategy.Debug){
            Debug(" Ordem de compra High_Volat dobrando os contratos: "); }  
           }
         else
           {
            Alert(" Falhou a Tentativa de Entrada!!!");
            Debug_Alert(" Falhou a Tentativa de Entrada!!!");
            return;
           }                                              
                           
        }   
        
      // Condições de compra High_Volat triplicando os contratos 
      if( 
            Signals.Triple_Lots == false 
         && price <= long(Global.price_trade_start) - diff            
                                                                 )                                                   
        { 
         Global.contratos = 3*Lots;
         OpenLongPosition(); 
         if(Signals.LongPosition == true)
           {
            Signals.Triple_Lots = true;
            if(Strategy.Debug){
            Debug(" Ordem de compra High_Volat triplicando os contratos: "); }  
           }
         else
           {
            Alert(" Falhou a Tentativa de Entrada!!!");
            Debug_Alert(" Falhou a Tentativa de Entrada!!!");
            return;
           }                                              
                           
        }      
     
      // saida por band 2 sigma
      if( price >= Ind.BBLow2[1] - diff_n )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação long High_Volat por band 2 sigma "); }
         return;
        }    
      
      // saida por TIME    
      if(   str1.hour >= TimeExitHour 
         && str1.min  >= TimeExitMin  )
        {
         CloseLongPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação long High_Volat por TIME "); }
         return;
        }  
                   
     }  // fim da verificação de saidas long

   // verificação de saidas de posição de venda  
   if(Signals.ShortPosition)
     {
     
      // Condições de venda High_Volat dobrando os contratos
      if( 
            Signals.Double_Lots == false 
         && price >= long(Global.price_trade_start) + diff/2
                                                             )                                                   
        {    
         Global.contratos = 2*Lots;                                      
         OpenShortPosition(); 
         if(Signals.ShortPosition == true)
           {
            Signals.Double_Lots = true;
            if(Strategy.Debug){
            Debug(" Ordem de venda High_Volat dobrando os contratos: "); }  
           }
         else
           {
            Alert(" Falhou a Tentativa de Entrada!!!");
            Debug_Alert(" Falhou a Tentativa de Entrada!!!");
            return;
           }                    
        }
        
      // Condições de venda High_Volat dobrando os contratos
      if( 
            Signals.Triple_Lots == false 
         && price >= long(Global.price_trade_start) + diff
                                                             )                                                   
        {    
         Global.contratos = 3*Lots;                                      
         OpenShortPosition(); 
         if(Signals.ShortPosition == true)
           {
            Signals.Triple_Lots = true;
            if(Strategy.Debug){
            Debug(" Ordem de venda High_Volat triplicando os contratos: "); }  
           }
         else
           {
            Alert(" Falhou a Tentativa de Entrada!!!");
            Debug_Alert(" Falhou a Tentativa de Entrada!!!");
            return;
           }                    
        }  
     
      // saida por band 2 sigma
      if( price <= Ind.BBUp2[1] + diff_n )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação short High_Volat por band 2 sigma "); }
         return;
        }    
      
      // saida por TIME  
      if(   str1.hour >= TimeExitHour 
         && str1.min  >= TimeExitMin  )
        {
         CloseShortPosition();
         if(Strategy.Debug){
         Debug(" Stop de operação short High_Volat por TIME "); }
         return;
        } 
        
     }  // fim da verificação de saidas short     
     
  } // fim da High_Volat_SL_SG()
  

//+------------------------------------------------------------------+