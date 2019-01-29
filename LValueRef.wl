(* ::Package:: *)

(* ::Section::Closed:: *)
(*License*)


(* MIT License
 * 
 * Copyright (c) 2019 miRoox
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *)


(* ::Title:: *)
(*LValueRef*)


BeginPackage["LValueRef`",{"GeneralUtilities`"}]


(* ::Section:: *)
(*Interface*)


Unprotect[Ref,Deref]


SetUsage[Ref,"Ref[lvalue$] refers to lvalue$."]
SetUsage[Deref,"Deref[ref$] dereference."]
SetUsage[RefQ,"RefQ[expr$] check if expr$ is a reference."]
SetUsage[ExpandDerefAsLValue,
"ExpandDerefAsLValue[expr$] expands dereference in the expr$ as lvalue.",
"ExpandDerefAsLValue[expr$,wrapper$] expands dereference in the expr$ as lvalue, and the result is wrapped in the wrapper$."]


SyntaxInformation[Ref]={"ArgumentsPattern"->{_}}
SyntaxInformation[Deref]={"ArgumentsPattern"->{_}}
SyntaxInformation[RefQ]={"ArgumentsPattern"->{_}}
SyntaxInformation[ExpandDerefAsLValue]={"ArgumentsPattern"->{_,_.}}


(* ::Section::Closed:: *)
(*Implement*)


Begin["`Private`"]


Deref::noref="`1` is not a reference."


SetAttributes[iExpandDerefAsLValue,HoldFirst]
SetAttributes[ExpandDerefAsLValue,HoldFirst]
ExpandDerefAsLValue[expr_,wrapper_:Unevaluated]:=
  CatchFailureAsMessage[
    Deref,
    wrapper@@iExpandDerefAsLValue[expr]
  ]
iExpandDerefAsLValue[lexpr_]:=
  Internal`InheritedBlock[{Deref},
    Unprotect[Deref];DownValues[Deref]={};
    Hold[lexpr]//.{
      Deref@HoldPattern[Ref[lvalue_]] :> lvalue,
      Deref[expr:Except[_Deref]] :> With[{e=checkRefInsideDeref[Deref[expr]]},e/;True]
    }
  ]

checkRefInsideDeref[Deref[r_?RefQ]]:=Deref[r]
checkRefInsideDeref[Deref[expr_]]:=ThrowFailure[Deref::noref,expr]


RefQ[_Ref]:=True
RefQ[_]:=False


SetAttributes[Ref,HoldFirst]
Ref[ref_Ref]:=ref
Ref[]:=$Failed
Ref[_,__]:=$Failed


Deref[HoldPattern[Ref[obj_]]]:=obj
Deref[expr_]:=(Message[Deref::noref,expr];$Failed)
Deref[]:=$Failed
Deref[_,__]:=$Failed


Unprotect[Set,SetDelayed];
Do[
  With[{set=set},
    Quiet[
      set[lhs_, rhs_]/;MemberQ[Unevaluated[lhs],_Deref,{0,Infinity}]=. ,
      Unset::norep
    ];
    set[lhs_, rhs_]/;MemberQ[Unevaluated[lhs],_Deref,{0,Infinity}]:=
      CatchFailureAsMessage[
        Deref,
        With[{lhs1 = Unevaluated@@iExpandDerefAsLValue[lhs]},
          set[lhs1, rhs]
        ]
      ]
  ],
  {set,{Set,SetDelayed}}
]
Protect[Set,SetDelayed];

Do[
  With[{clr=clr},
    Quiet[
      Deref/:clr[head___,lval_Deref,tail___]=. ,
      TagUnset::norep
    ];
    Deref/:clr[head___,lval_Deref,tail___]:=
      CatchFailureAsMessage[
        Deref,
        With[{lval1 = Unevaluated@@iExpandDerefAsLValue[lval]},
          clr[head, lval1, tail]
        ]
      ]
  ],
  {clr,{Clear,ClearAttributes,ClearAll,Remove}}
]

Unprotect[Unset]
Quiet[
  Unset[lhs_]/;MemberQ[Unevaluated[lhs],_Deref,{0,Infinity}]=. ,
  Unset::norep
];
Unset[lhs_]/;MemberQ[Unevaluated[lhs],_Deref,{0,Infinity}]:=
  CatchFailureAsMessage[
    Deref,
    With[{lhs1 = Unevaluated@@iExpandDerefAsLValue[lhs]},
      Unset[lhs1]
    ]
  ]
Protect[Unset]


(* ::Section::Closed:: *)
(*End*)


End[]


Protect[Ref,Deref]


EndPackage[]
