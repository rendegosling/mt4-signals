//+------------------------------------------------------------------+
//|                                                          HAT.mq4 |
//|                              Copyright 2018, Renlester de Guzman |
//|                      https://www.facebook.com/renlester.deguzman |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Renlester de Guzman"
#property link      "https://www.facebook.com/renlester.deguzman"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property description "This is an indicator to put arrows on the chart when heiken ashi changes colors "
#property description "It will also sound an alarm and send a push notification to your phone"
#property indicator_buffers 2
#property indicator_color1 clrGreen
#property indicator_color2 clrRed
#property indicator_width1 3
#property indicator_width2 3

input color up_color=clrGreen;
input color downn_color=clrRed;

double up_arrow[];
double down_arrow[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,up_arrow);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,233);
//---
   SetIndexBuffer(1,down_arrow);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,234);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   int limit=0;
   if(prev_calculated==0)
      limit=rates_total-1;
   else
      limit=rates_total-prev_calculated;

   for(int i=1; i<=limit; i++)
     {
      double current_open=iCustom(NULL,0,"Heiken Ashi",2,i);
      double previous_open = iCustom(NULL, 0, "Heiken Ashi", 2, i+1);
      double current_close = iCustom(NULL, 0, "Heiken Ashi", 3, i);
      double previous_close= iCustom(NULL,0,"Heiken Ashi",3,i+1);

      if(current_close>current_open && previous_close<previous_open)
        {
         up_arrow[i]=Close[i];
         if(i==1)
           {
            Alert("We just got a buy signal on the ",_Period,"M ",_Symbol);
            SendNotification("We just got a buy signal on the "+(string)_Period+"M "+_Symbol);
           }
        }
      if(
         current_close<current_open && previous_close>previous_open)
        {
         down_arrow[i]=Close[i];
         if(i==1)
           {
            Alert("We just got a sell signal on the ",_Period,"M ",_Symbol);
            SendNotification("We just got a sell signal on the "+(string)_Period+"M "+_Symbol);
           }
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
