#!/usr/bin/env wolframscript
(* ::Package:: *)

Print["Running tests..."];

getFailedTestsID[tr_TestReportObject]:=#["TestID"]& /@ Flatten[Values /@ Values@tr["TestsFailed"]]

Get["LValueRef`",Path->Directory[]]


With[{tr=TestReport[FileNameJoin[{Directory[],"Tests.wlt"}]]},
  Exit@If[TrueQ@tr["AllTestsSucceeded"],
    Print["All tests passed!"];0,
    Print["Tests failed!\nID: ",getFailedTestsID[tr]];1
  ]
]
