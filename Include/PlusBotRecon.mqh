//|-----------------------------------------------------------------------------------------|
//|                                                                        PlusBotRecon.mq4 |
//|                                                              Copyright 2019, Dennis Lee |
//|                                   https://github.com/dennislwm/MT5-MT4-Telegram-API-Bot |
//|                                                                                         |
//| History                                                                                 |
//|   0.9.0    The PlusBotRecon include file contains the functions that are called by the  |
//|      custom class CPlusBotRecon.                                                        |
//|-----------------------------------------------------------------------------------------|
#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/MT5-MT4-Telegram-API-Bot"
#property strict

#define  NL "\n"

//|-----------------------------------------------------------------------------------------|
//|                                O R D E R S   S T A T U S                                |
//|-----------------------------------------------------------------------------------------|
string BotOrdersTotal(bool noPending=true)
{
   int count=0;
   int total=OrdersTotal();
//--- Assert optimize function by checking total > 0
   if( total<=0 ) return( strBotInt("Total", count) );   
//--- Assert optimize function by checking noPending = false
   if( noPending==false ) return( strBotInt("Total", total) );
   
//--- Assert determine count of all trades that are opened
   for(int i=0;i<total;i++) {
      OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
   //--- Assert OrderType is either BUY or SELL
      if( OrderType() <= 1 ) count++;
   }
   return( strBotInt( "Total", count ) );
}

string BotOrdersTrade(bool noPending=true)
{
   int count=0;
   string msg="";
   const string strPartial="from #";
   int total=OrdersTotal();
//--- Assert optimize function by checking total > 0
   if( total<=0 ) return( msg );   

//--- Assert determine count of all trades that are opened
   for(int i=0;i<total;i++) {
      OrderSelect( i, SELECT_BY_POS, MODE_TRADES );

   //--- Assert OrderType is either BUY or SELL if noPending=true
      if( noPending==true && OrderType() > 1 ) continue ;
      else count++;

      msg = StringConcatenate(msg, strBotInt( "Ticket",OrderTicket() ));
      msg = StringConcatenate(msg, strBotStr( "Symbol",OrderSymbol() ));
      msg = StringConcatenate(msg, strBotInt( "Type",OrderType() ));
      msg = StringConcatenate(msg, strBotDbl( "Lots",OrderLots(),2 ));
      msg = StringConcatenate(msg, strBotDbl( "OpenPrice",OrderOpenPrice(),5 ));
      msg = StringConcatenate(msg, strBotDbl( "CurPrice",OrderClosePrice(),5 ));
      msg = StringConcatenate(msg, strBotDbl( "StopLoss",OrderStopLoss(),5 ));
      msg = StringConcatenate(msg, strBotDbl( "TakeProfit",OrderTakeProfit(),5 ));
      msg = StringConcatenate(msg, strBotTme( "OpenTime",OrderOpenTime() ));
      msg = StringConcatenate(msg, strBotTme( "CloseTime",OrderCloseTime() ));
      
   //--- Assert Partial Trade has comment="from #<historyTicket>"
      if( StringFind( OrderComment(), strPartial )>=0 )
         msg = StringConcatenate(msg, strBotStr( "PrevTicket", StringSubstr(OrderComment(),StringLen(strPartial)) ));
      else
         msg = StringConcatenate(msg, strBotStr( "PrevTicket", "0" ));
   }
//--- Assert msg isnt empty
   if( msg=="" ) return( msg );   
   
//--- Assert append count of trades
   msg = StringConcatenate(strBotInt( "Count",count ), msg);
   return( msg );
}

string BotOrdersTicket(int ticket, bool noPending=true)
{
   return( "" );
}

string BotHistoryTicket(int ticket, bool noPending=true)
{
   string msg=NL;
   const string strPartial="from #";
   int total=OrdersHistoryTotal();
//--- Assert optimize function by checking total > 0
   if( total<=0 ) return( msg );   

//--- Assert determine history by ticket
   if( OrderSelect( ticket, SELECT_BY_TICKET, MODE_HISTORY )==false ) return( msg );
   
//--- Assert OrderType is either BUY or SELL if noPending=true
   if( noPending==true && OrderType() > 1 ) return( msg );
      
//--- Assert OrderTicket is found
   msg = StringConcatenate(msg, strBotInt( "Ticket",OrderTicket() ));
   msg = StringConcatenate(msg, strBotStr( "Symbol",OrderSymbol() ));
   msg = StringConcatenate(msg, strBotInt( "Type",OrderType() ));
   msg = StringConcatenate(msg, strBotDbl( "Lots",OrderLots(),2 ));
   msg = StringConcatenate(msg, strBotDbl( "OpenPrice",OrderOpenPrice(),5 ));
   msg = StringConcatenate(msg, strBotDbl( "ClosePrice",OrderClosePrice(),5 ));
   msg = StringConcatenate(msg, strBotDbl( "StopLoss",OrderStopLoss(),5 ));
   msg = StringConcatenate(msg, strBotDbl( "TakeProfit",OrderTakeProfit(),5 ));
   msg = StringConcatenate(msg, strBotTme( "OpenTime",OrderOpenTime() ));
   msg = StringConcatenate(msg, strBotTme( "CloseTime",OrderCloseTime() ));
   
//--- Assert Partial Trade has comment="from #<historyTicket>"
   if( StringFind( OrderComment(), strPartial )>=0 )
      msg = StringConcatenate(msg, strBotStr( "PrevTicket", StringSubstr(OrderComment(),StringLen(strPartial)) ));
   else
      msg = StringConcatenate(msg, strBotStr( "PrevTicket", "0" ));

   return( msg );
}

string BotOrdersHistoryTotal(bool noPending=true)
{
   return( strBotInt( "Total", OrdersHistoryTotal() ) );
}

//|-----------------------------------------------------------------------------------------|
//|                               A C C O U N T   S T A T U S                               |
//|-----------------------------------------------------------------------------------------|
string BotAccount(void)
{
   string msg=NL;

   msg = StringConcatenate(msg, strBotInt( "Number",AccountNumber() ));
   msg = StringConcatenate(msg, strBotStr( "Currency",AccountCurrency() ));
   msg = StringConcatenate(msg, strBotDbl( "Balance",AccountBalance(),2 ));
   msg = StringConcatenate(msg, strBotDbl( "Equity",AccountEquity(),2 ));
   msg = StringConcatenate(msg, strBotDbl( "Margin",AccountMargin(),2 ));
   msg = StringConcatenate(msg, strBotDbl( "FreeMargin",AccountFreeMargin(),2 ));
   msg = StringConcatenate(msg, strBotDbl( "Profit",AccountProfit(),2 ));
   
   return( msg );
}


//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   F U N C T I O N S                           |
//|-----------------------------------------------------------------------------------------|
string strBotInt(string key, int val)
{
   return( StringConcatenate(NL,key,"=",val) );
}
string strBotDbl(string key, double val, int dgt=5)
{
   return( StringConcatenate(NL,key,"=",NormalizeDouble(val,dgt)) );
}
string strBotTme(string key, datetime val)
{
   return( StringConcatenate(NL,key,"=",TimeToString(val)) );
}
string strBotStr(string key, string val)
{
   return( StringConcatenate(NL,key,"=",val) );
}
string strBotBln(string key, bool val)
{
   string valType;
   if( val )   valType="true";
   else        valType="false";
   return( StringConcatenate(NL,key,"=",valType) );
}
//|-----------------------------------------------------------------------------------------|
//|                            E N D   O F   I N D I C A T O R                              |
//|-----------------------------------------------------------------------------------------|