//|-----------------------------------------------------------------------------------------|
//|                                                                       TelegramRecon.mq4 |
//|                                                              Copyright 2019, Dennis Lee |
//|                                     https://github.com/dennislwm/MT4-Telegram-Bot-Recon |
//|                                                                                         |
//| Background                                                                              |
//|      Telegram isn't just for sending and receiving chat messages. It's also for         |
//|   automating your dialog flow, including work flow. Using a Telegram Bot gives you the  |
//|   ability to check prices, query status, manage trades, and even have a fun             |
//|   conversation. And if you're a serious crypto or forex trader, you can create your own |
//|   Telegram Bot to manage your order flow.                                               |
//|                                                                                         |
//|   URL: https://www.mql5.com/en/articles/2355                                            |
//|                                                                                         |
//| Strategy                                                                                |
//|      This EA can be used to manage your order flow.                                     |
//|                                                                                         |
//| Example                                                                                 |
//|      For example, in Telegram, send a message "/help" to your Bot.                      |
//|                                                                                         |
//| History                                                                                 |
//|   0.9.0    The TelegramRecon EA listens for messages from a Telegram Bot. You can use   |
//|      the bot to query your orders from a Metatrader 4 client. You can use this approach |
//|      to manage your order flow and view account details.                                |
//|-----------------------------------------------------------------------------------------|
#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/MT4-Telegram-Bot-Recon"
#property version   "000.900"
#property strict

//---- Assert Basic externs
#include <plusinit.mqh>
#include <plusbig.mqh>
#include <Telegram.mqh>
#include <CPlusBotRecon.mqh>

//|-----------------------------------------------------------------------------------------|
//|                           E X T E R N A L   V A R I A B L E S                           |
//|-----------------------------------------------------------------------------------------|
extern string s1="-->TGR Settings<--";
extern string s1_1="Token - Telegram API Token";
input string  TgrToken;
extern string IndD1="===Debug Properties===";
extern bool   IndViewDebugNotify         = false;
extern int    IndViewDebug               = 0;
extern int    IndViewDebugNoStack        = 100;
extern int    IndViewDebugNoStackEnd     = 10;
int IndDebugCrit=0;
int IndDebugCore=1;
int IndDebugFine=2;
//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   V A R I A B L E S                           |
//|-----------------------------------------------------------------------------------------|
//---- Assert indicator name and version
string IndName="TelegramRecon";
string IndVer="0.9.0";
//---- Assert variables for TGR
CPlusBotRecon bot;
int intResult;

//|-----------------------------------------------------------------------------------------|
//|                             I N I T I A L I Z A T I O N                                 |
//|-----------------------------------------------------------------------------------------|
int OnInit()
{
   InitInit();
   BigInit();
   
   bot.Token(TgrToken);
   intResult=bot.GetMe();
  
//--- create timer
   EventSetTimer(3);
   OnTimer();
   
//---
   return(INIT_SUCCEEDED);
}
//|-----------------------------------------------------------------------------------------|
//|                             D E I N I T I A L I Z A T I O N                             |
//|-----------------------------------------------------------------------------------------|
void OnDeinit(const int reason)
{
//--- destroy timer
   EventKillTimer();
   
   BigDeInit();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
void OnTimer()
{
//--- Assert intResult=0 (success)
   if( intResult!=0 ) {
      BigComment( "Error: "+GetErrorDescription(intResult) );
      return;
   }
   
   BigComment( "Bot name: "+bot.Name() );
   
   bot.GetUpdates();
   
   bot.ProcessMessages();
}
  
//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   F U N C T I O N S                           |
//|-----------------------------------------------------------------------------------------|
void IndDebugPrint(int dbg, string fn, string msg)
{
   static int noStackCount;
   if(IndViewDebug>=dbg)
   {
      if(dbg>=IndDebugFine && IndViewDebugNoStack>0)
      {
         if( MathMod(noStackCount,IndViewDebugNoStack) <= IndViewDebugNoStackEnd )
            Print(IndViewDebug,"-",noStackCount,":",fn,"(): ",msg);
            
         noStackCount ++;
      }
      else
      {
         if(IndViewDebugNotify) SendNotification( IndViewDebug + ":" + fn + "(): " + msg );
         Print(IndViewDebug,":",fn,"(): ",msg);
      }
   }
}
string IndDebugInt(string key, int val)
{
   return( StringConcatenate(";",key,"=",val) );
}
string IndDebugDbl(string key, double val, int dgt=5)
{
   return( StringConcatenate(";",key,"=",NormalizeDouble(val,dgt)) );
}
string IndDebugStr(string key, string val)
{
   return( StringConcatenate(";",key,"=\"",val,"\"") );
}
string IndDebugBln(string key, bool val)
{
   string valType;
   if( val )   valType="true";
   else        valType="false";
   return( StringConcatenate(";",key,"=",valType) );
}
//|-----------------------------------------------------------------------------------------|
//|                            E N D   O F   I N D I C A T O R                              |
//|-----------------------------------------------------------------------------------------|
