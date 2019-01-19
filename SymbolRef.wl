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
(*SymbolRef*)


BeginPackage["SymbolRef`"]


(* ::Section:: *)
(*Interface*)


Unprotect[Ref,Deref,NullRef]


Ref::usage="Ref[sym] refers to sym."
Deref::usage="Deref[ref] dereference."
NullRef::usage="NullRef is a reference that refers to nothing."
RefQ::usage="RefQ[expr] check if expr is a reference."


SyntaxInformation[Ref]={"ArgumentsPattern"->{_}}
SyntaxInformation[Deref]={"ArgumentsPattern"->{_}}
SyntaxInformation[RefQ]={"ArgumentsPattern"->{_}}


(* ::Section::Closed:: *)
(*Implement*)


Begin["`Private`"]


Ref::nosym="`1` is not a symbol."
Deref::null="NullRef refers to NOTHING!"
Deref::noref="`1` is not a reference."


SetAttributes[expandDerefLHS,HoldFirst]
expandDerefLHS[lhs_]:=
  Internal`InheritedBlock[{Deref},
    Unprotect[Deref];DownValues[Deref]={};
    Hold[lhs]//.{
      Deref[NullRef] :> With[{e=(Message[Deref::null];Throw[$Failed,Deref])},e/;True],
      Deref@HoldPattern[Ref[sym_Symbol]] :> sym,
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
Ref[expr:Except[_Symbol|_Ref|NullRef]]:=(Message[Ref::nosym,expr];NullRef)


Deref[HoldPattern[Ref[obj_]]]:=obj
Deref[NullRef]:=(Message[Deref::null];$Failed)
Deref[expr_]:=(Message[Deref::noref,expr];$Failed)


Unprotect[Set,SetDelayed];
Do[
  With[{set=set},
    Quiet[
      set[lhs_, rhs_]/;MemberQ[Unevaluated[lhs],_Deref,{0,Infinity}]=. ,
      Unset::norep
    ];
    set[lhs_, rhs_]/;MemberQ[Unevaluated[lhs],_Deref,{0,Infinity}]:=
      Catch[
        With[{lhs1 = Unevaluated@@expandDerefLHS[lhs]},
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
