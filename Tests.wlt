(* Mathematica Test File    *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

BeginTestSection["SymbolRef"]

VerificationTest[
  Deref[Ref[a]]
  ,
  a
  ,
  TestID->"Evaluation_Explicit_1"
]

VerificationTest[
  a=1;
  Deref[Ref[a]]
  ,
  1
  ,
  TestID->"Evaluation_Explicit_2"
]

VerificationTest[
  b=Ref[a];
  Deref[b]
  ,
  a
  ,
  TestID->"Evaluation_Implicit_1"
]

VerificationTest[
  a=1;
  b=Ref[a];
  Deref[b]
  ,
  1
  ,
  TestID->"Evaluation_Implicit_2"
]

VerificationTest[
  Deref[Ref[a]]=1;
  a
  ,
  1
  ,
  TestID->"LValue_Basic_Explicit_1"
]

VerificationTest[
  a=1;
  Deref[Ref[a]]=2;
  a
  ,
  2
  ,
  TestID->"LValue_Basic_Explicit_2"
]

VerificationTest[
  b=Ref[a];
  Deref[b]=1;
  a
  ,
  1
  ,
  TestID->"LValue_Basic_Implicit_1"
]

VerificationTest[
  a=1;
  b=Ref[a];
  Deref[b]=2;
  a
  ,
  2
  ,
  TestID->"LValue_Basic_Implicit_2"
]

VerificationTest[
  a={1,2,3};
  Deref[Ref[a]][[2]]=4;
  a
  ,
  {1,4,3}
  ,
  TestID->"LValue_Part_Explicit_1"
]

VerificationTest[
  a={1,2,3};
  b=Ref[a];
  Deref[b][[2]]=4;
  a
  ,
  {1,4,3}
  ,
  TestID->"LValue_Part_Implicit_1"
]

VerificationTest[
  f[x_]:=x;
  Deref[Ref[f]][x_]:=x^2;
  f[2]
  ,
  4
  ,
  TestID->"LValue_DownValue_Explicit_1"
]

VerificationTest[
  f[x_]:=x;
  Deref[Ref[f]][x_/;x<0]:=x^2;
  {f[2],f[-2]}
  ,
  {2,4}
  ,
  TestID->"LValue_DownValue_Explicit_2"
]

VerificationTest[
  f[x_]:=x;
  rf=Ref[f];
  Deref[rf][x_]:=x^2;
  f[2]
  ,
  4
  ,
  TestID->"LValue_DownValue_Implicit_1"
]

VerificationTest[
  f[x_]:=x;
  rf=Ref[f];
  Deref[rf][x_/;x<0]:=x^2;
  {f[2],f[-2]}
  ,
  {2,4}
  ,
  TestID->"LValue_DownValue_Implicit_2"
]

VerificationTest[
  b=Ref[a];
  Deref@Deref[Ref[b]]=1;
  a
  ,
  1
  ,
  TestID->"LValue2_Basic_Explicit_1"
]

VerificationTest[
  a=1;
  b=Ref[a];
  Deref@Deref[Ref[b]]=2;
  a
  ,
  2
  ,
  TestID->"LValue2_Basic_Explicit_2"
]

VerificationTest[
  b=Ref[a];
  c=Ref[b];
  Deref@Deref[c]=1;
  a
  ,
  1
  ,
  TestID->"LValue2_Basic_Implicit_1"
]

VerificationTest[
  a=1;
  b=Ref[a];
  c=Ref[b];
  Deref@Deref[c]=2;
  a
  ,
  2
  ,
  TestID->"LValue2_Basic_Implicit_2"
]

VerificationTest[
  a={1,2,3};
  b=Ref[a];
  (Deref@Deref@Ref[b])[[2]]=4;
  a
  ,
  {1,4,3}
  ,
  TestID->"LValue2_Part_Explicit_1"
]

VerificationTest[
  a={1,2,3};
  b=Ref[a];
  c=Ref[b];
  (Deref@Deref[c])[[2]]=4;
  a
  ,
  {1,4,3}
  ,
  TestID->"LValue2_Part_Implicit_1"
]

VerificationTest[
  f[x_]:=x;
  rf=Ref[f];
  (Deref@Deref@Ref[rf])[x_]:=x^2;
  f[2]
  ,
  4
  ,
  TestID->"LValue2_DownValue_Explicit_1"
]

VerificationTest[
  f[x_]:=x;
  rf=Ref[f];
  (Deref@Deref@Ref[rf])[x_/;x<0]:=x^2;
  {f[2],f[-2]}
  ,
  {2,4}
  ,
  TestID->"LValue2_DownValue_Explicit_2"
]

VerificationTest[
  f[x_]:=x;
  rf=Ref[f];
  rrf=Ref[rf];
  (Deref@Deref[rrf])[x_]:=x^2;
  f[2]
  ,
  4
  ,
  TestID->"LValue2_DownValue_Implicit_1"
]

VerificationTest[
  f[x_]:=x;
  rf=Ref[f];
  rrf=Ref[rf];
  (Deref@Deref[rrf])[x_/;x<0]:=x^2;
  {f[2],f[-2]}
  ,
  {2,4}
  ,
  TestID->"LValue2_DownValue_Implicit_2"
]

EndTestSection[]
