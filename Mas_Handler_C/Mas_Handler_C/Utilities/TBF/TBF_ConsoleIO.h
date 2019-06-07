/*
Dependencies Required:
stdio

*/

#pragma once

//C.P.N.L. : Console Print New Line
#define cpnl \
printf("\n");

#define PaddedConsoleOut(FormatedStringAndParameters) \
cpnl; printf(FormatedStringAndParameters); cpnl;