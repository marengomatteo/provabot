//|-----------------------------------------------------------------------------------------|
//|                                                                             PlusBig.mqh |
//|                                                            Copyright © 2013, Dennis Lee |
//| Assert History                                                                          |
//| 1.0.1   Fixed incorrect calculation of YDISTANCE (top) when BigLineCount increases.     |
//| 1.0.0   Created PlusBig to replace the fixed font size used in MQL function Comment().  |
//|         Tested on script TestPlusBig 1.0.0.                                             |
//|-----------------------------------------------------------------------------------------|
#property   copyright "Copyright © 2013, Dennis Lee"

#define  NL "\n"

//|-----------------------------------------------------------------------------------------|
//|                           E X T E R N A L   V A R I A B L E S                           |
//|-----------------------------------------------------------------------------------------|
extern string     BigS0                      = "-->PlusBig Settings<--";
extern string     BigFontName                = "Arial";
extern double     BigFontSize                = 9;
extern color      BigFontColor               = Yellow;
extern int        BigTopOffset               = 10;
extern int        BigLeftOffset              = 20;
extern int        BigEmptyGap                = 1;
extern int        BigLineGap                 = 15;
//|-----------------------------------------------------------------------------------------|
string BigName       = "PlusBig";
string BigVer        = "1.0.1";
//|-----------------------------------------------------------------------------------------|
extern string     BigD1                      = "===Debug Properties===";
extern bool       BigViewDebugNotify         = false;
extern int        BigViewDebug               = 0;
extern int        BigViewDebugNoStack        = 1000;
extern int        BigViewDebugNoStackEnd     = 10;

//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   V A R I A B L E S                           |
//|-----------------------------------------------------------------------------------------|
string BigLabelName[];//store object names
string BigLabelText[];//store text
int    BigLineCount;// number of NL

//|-----------------------------------------------------------------------------------------|
//|                             I N I T I A L I Z A T I O N                                 |
//|-----------------------------------------------------------------------------------------|
void BigInit()
{
//--- Initialize variables   
   
   return;
}

//|-----------------------------------------------------------------------------------------|
//|                             D E I N I T I A L I Z A T I O N                             |
//|-----------------------------------------------------------------------------------------|
void BigDeInit()
{
//--- Delete objects
   for( int i=0; i<ArraySize(BigLabelName); i++ )
      if( ObjectFind(BigLabelName[i] ) >= 0 )   ObjectDelete(BigLabelName[i]);
      
   return;
}

//|-----------------------------------------------------------------------------------------|
//|                               M A I N   P R O C E D U R E                               |
//|-----------------------------------------------------------------------------------------|
void BigComment(string cmt)
{
   BigStringSplit(cmt);
   if( BigCheckLabel() )
      for( int i=0; i<BigLineCount; i++)
         ObjectSetText( BigLabelName[i], BigLabelText[i], BigFontSize, BigFontName, BigFontColor);
}
//|-----------------------------------------------------------------------------------------|
//|                           E X T E R N A L   F U N C T I O N S                           |
//|-----------------------------------------------------------------------------------------|
int BigStringSplit(string cmt, string by=NL)
{
   string tmp;
   string line;
   int start;
   int next;
   BigLineCount=0;   
//--- Catch wierd cases
   if( cmt=="" ) return( BigLineCount );
   
//--- Normalize string by appending NL to end, if NL is not the end
   int byLen = StringLen(by);
   start = StringLen(cmt) - byLen;
   BigDebugPrint(1, "BigStringSplit",
      BigDebugInt("byLen", byLen) + 
      BigDebugInt("start", start) +
      BigDebugInt("StringFind", StringFind( cmt, by, start)) );
   if( StringFind( cmt, by, start ) == -1 )
      tmp = StringConcatenate( cmt, by );
   else
      tmp = cmt;

//--- Strip comment line by line
//       (1) Find the first occurrence of NL (starts from ZERO)
//       (2) Strip text preceding by into a new record
//       (3) Repeat step (1) until string is empty
   while( StringLen(tmp) > 0 )
   {
      line = "";
      next = StringFind( tmp, by, 0 );
      if( next > 0 ) line = StringSubstr( tmp, 0, next );
      
      BigLineCount++;
      ArrayResize(BigLabelText, BigLineCount);
      BigLabelText[BigLineCount-1] = line;
      
      tmp = StringSubstr( tmp, next + byLen );
   }
   
   for( int i=0; i<BigLineCount; i++)
      BigDebugPrint(1, "BigStringSplit",
         BigDebugInt("i", i) + 
         BigDebugStr("Text", BigLabelText[i]) );
   return( BigLineCount );
}

bool BigCheckLabel()
{
   bool ret = TRUE;
   int i;
   int top = BigTopOffset;
   
   if( BigLineCount > ArraySize(BigLabelName) )   
      ArrayResize(BigLabelName, BigLineCount);
   else
   if( BigLineCount < ArraySize(BigLabelName) )
   {
      for( i=BigLineCount; i<ArraySize(BigLabelName); i++ )
         if( ObjectFind(BigLabelName[i] ) >= 0 )   ObjectDelete(BigLabelName[i]);
      ArrayResize(BigLabelName, BigLineCount);
   }
   
   for( i=0; i<BigLineCount; i++ )
   {
      BigLabelName[i] = StringConcatenate("Big Label ", DoubleToStr(i,0));
      if( StringLen(BigLabelName[i]) == 0 )   
         top = top + BigEmptyGap;
      else                          
         top = top + BigLineGap;
      if( ObjectFind(BigLabelName[i]) == -1 )
      {
         ObjectCreate(BigLabelName[i], OBJ_LABEL, 0, 0, 0);
         ObjectSet(BigLabelName[i], OBJPROP_XDISTANCE, BigLeftOffset);
         ObjectSet(BigLabelName[i], OBJPROP_YDISTANCE, top);
         ObjectSet(BigLabelName[i], OBJPROP_CORNER, 0);
      }
      ret = ret && ObjectFind( BigLabelName[i] ) >= 0;
   }
   
   return(ret);
}

//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   F U N C T I O N S                           |
//|-----------------------------------------------------------------------------------------|
void BigDebugPrint(int dbg, string fn, string msg)
{
   static int noStackCount;
   if(BigViewDebug>=dbg)
   {
      if(dbg>=2 && BigViewDebugNoStack>0)
      {
         if( MathMod(noStackCount,BigViewDebugNoStack) <= BigViewDebugNoStackEnd )
            Print(BigViewDebug,"-",noStackCount,":",fn,"(): ",msg);
            
         noStackCount ++;
      }
      else
      {
         if(BigViewDebugNotify) SendNotification( BigViewDebug + ":" + fn + "(): " + msg );
         Print(BigViewDebug,":",fn,"(): ",msg);
      }
   }
}
string BigDebugInt(string key, int val)
{
   return( StringConcatenate(";",key,"=",val) );
}
string BigDebugDbl(string key, double val, int dgt=5)
{
   return( StringConcatenate(";",key,"=",NormalizeDouble(val,dgt)) );
}
string BigDebugStr(string key, string val)
{
   return( StringConcatenate(";",key,"=\"",val,"\"") );
}
string BigDebugBln(string key, bool val)
{
   string valType;
   if( val )   valType="true";
   else        valType="false";
   return( StringConcatenate(";",key,"=",valType) );
}
//|-----------------------------------------------------------------------------------------|
//|                       E N D   O F   E X P E R T   A D V I S O R                         |
//|-----------------------------------------------------------------------------------------|