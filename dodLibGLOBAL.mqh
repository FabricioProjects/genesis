//+------------------------------------------------------------------+
//|                                                                  |
//|                             Copyright 2014-2015, Fabrício Amaral |
//|                                         http://executive.com.br/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2015, Fabrício Amaral"
#property link      "http://executive.com.br/"
#include "dodLibStructArgs.mqh"

//+------------------------------------------------------------------+
//| Global functions                                                 |
//+------------------------------------------------------------------+

double Global_Get(const string variable_name) 
   {
    return GlobalVariableGet(Global.identificador+"_"+variable_name);
   }
   
datetime Global_Set(const string variable_name, const double value) 
   {
    return GlobalVariableSet(Global.identificador+"_"+variable_name, value);
   }   
   
bool Global_Check(const string variable_name) 
   {
    return GlobalVariableCheck(Global.identificador+"_"+variable_name);
   }      
   
   
   

   
   