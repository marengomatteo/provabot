//|-----------------------------------------------------------------------------------------|
//|                                                                       CPlusBotRecon.mq4 |
//|                                                              Copyright 2019, Dennis Lee |
//|                                   https://github.com/dennislwm/MT5-MT4-Telegram-API-Bot |
//|                                                                                         |
//| History                                                                                 |
//|   0.9.0    The CPlusBotRecon class inherits from CCustomBot. We added general, order    |
//|      status, history status, and account status bot commands:                           |
//|      (1) /help - Display a list of bot commands                                         |
//|      (2) /ordertotal - Return count of orders                                           |
//|      (3) /ordertrade - Return ALL orders, where EACH order includes ticket, symbol,     |
//|            type, lots, openprice, stoploss, takeprofit, opentime and prevticket.        |
//|            Note: curprice, swap, profit, expiration, closetime, magicno, accountno,     |
//|               and expertname are NOT returned.                                          |
//|      (4) /orderticket <ticket> - Return an order by ticket number. If <ticket> is a     |
//|            partial trade, return a chain of orders and history, otherwise return a      |
//|            single trade.                                                                |
//|      (5) /historytotal - Return count of history                                        |
//|      (6) /historyticket <ticket> - Return a history or a chain of history, where EACH   |
//|            history includes ticket, symbol, type, lots, openprice, closeprice, stoploss,|
//|            takeprofit, opentime, closetime, and prevticket.                             |
//|            Note: opentime, swap, profit, expiration, magicno, accountno, and            |
//|            expertname are NOT returned.                                                 |
//|      (7) /account - Return account number, currency, balance, equity, margin,           |
//|            freemargin and profit.                                                       |
//|-----------------------------------------------------------------------------------------|
#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/MT5-MT4-Telegram-API-Bot"
#property strict

//---- Assert Basic externs
#include <PlusBotRecon.mqh>
#include <Telegram.mqh>

//|-----------------------------------------------------------------------------------------|
//|                               M A I N   P R O C E D U R E                               |
//|-----------------------------------------------------------------------------------------|
class CPlusBotRecon: public CCustomBot
{
public:
   void ProcessMessages(void)
   {
      string msg=NL;
      const string strOrderTrade="/ordertrade";
      const string strHistoryTicket="/historyticket";
      int pos=0, ticket=0;
      for( int i=0; i<m_chats.Total(); i++ ) {
         CCustomChat *chat=m_chats.GetNodeAtIndex(i);
         
         if( !chat.m_new_one.done ) {
            chat.m_new_one.done=true;
            
            string text=chat.m_new_one.message_text;
            
            if( text=="/ordertotal" ) {
               SendMessage( chat.m_id, BotOrdersTotal() );
            }
            
            if( StringFind( text, strOrderTrade )>=0 ) {
               pos = StringToInteger( StringSubstr( text, StringLen(strOrderTrade)+1 ) );
               SendMessage( chat.m_id, BotOrdersTrade(pos) );
            }

            if( text=="/historytotal" ) {
               SendMessage( chat.m_id, BotOrdersHistoryTotal() );
            }

            if( StringFind( text, strHistoryTicket )>=0 ) {
               ticket = StringToInteger( StringSubstr( text, StringLen(strHistoryTicket)+1 ) );
               SendMessage( chat.m_id, BotHistoryTicket(ticket) );
            }
            
            if( text=="/account" ) {
               SendMessage( chat.m_id, BotAccount() );
            }
            
            msg = StringConcatenate(msg,"My commands list:",NL);
            msg = StringConcatenate(msg,"/ordertotal-return count of orders",NL);
            msg = StringConcatenate(msg,"/ordertrade-return ALL opened orders",NL);
            msg = StringConcatenate(msg,"/orderticket <ticket>-return an order or a chain of history by ticket",NL);
            msg = StringConcatenate(msg,"/historytotal-return count of history",NL);
            msg = StringConcatenate(msg,"/historyticket <ticket>-return a history or chain of history by ticket",NL);
            msg = StringConcatenate(msg,"/account-return account info",NL);
            msg = StringConcatenate(msg,"/help-get help");
            if( text=="/help" ) {
               SendMessage( chat.m_id, msg );
            }
         }
      }
   }
};