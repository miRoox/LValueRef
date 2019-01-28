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


Unprotect[Ref,Deref,NullRef]


SetUsage[Ref,"Ref[lvalue$] refers to lvalue$."]
SetUsage[Deref,"Deref[ref$] dereference."]
SetUsage[NullRef,"NullRef is a reference that refers to nothing."]
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


Deref::null="NullRef refers to NOTHING!"
Deref::noref="`1` is not a reference."


SetAttributes[iExpandDerefAsLValue,HoldFirst]
SetAttributes[ExpandDerefAsLValue,HoldFirst]
ExpandDerefAsLValue[expr_,wrapper_:Unevaluated]:=wrapper@@iExpandDerefAsLValue[expr]
iExpandDerefAsLValue[lexpr_]:=
  Internal`InheritedBlock[{Deref},
    Unprotect[Deref];DownValues[Deref]={};
    Hold[lexpr]//.{
      Deref[NullRef] :> With[{e=(Message[Deref::null];Throw[$Failed,Deref])},e/;True],
      Deref@HoldPattern[Ref[sym_]] :> sym,
      Deref[expr:Except[_Deref]] :> With[{e=checkRefInsideDeref[Deref[expr]]},e/;True]
    }
  ]

checkRefInsideDeref[Deref[r_?iRefQ]]:=Deref[r]
checkRefInsideDeref[Deref[expr_]]:=(Message[Deref::noref,expr];Throw[$Failed,Deref])


RefQ[expr_]:=iRefQ[expr]
iRefQ[NullRef|_Ref]:=True
iRefQ[_]:=False


SetAttributes[Ref,HoldFirst]
Ref[ref_Ref]:=ref
Ref[NullRef]:=NullRef
Ref[]:=NullRef
Ref[_,__]:=$Failed


Deref[HoldPattern[Ref[obj_]]]:=obj
Deref[NullRef]:=(Message[Deref::null];$Failed)
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
      Catch[
        With[{lhs1 = Unevaluated@@iExpandDerefAsLValue[lhs]},
          set[lhs1, rhs]
        ],
        Deref
      ]
  ],
  {set,{Set,SetDelayed}}
]
Protect[Set,SetDelayed];


(* ::Section::Closed:: *)
(*End*)


End[]


Protect[Ref,Deref,NullRef]


EndPackage[]
