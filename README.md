# ``LValueRef` ``

Pointer semantics simulation in Wolfram Language.

* `Ref[lvalue]` refers to `lvalue`.
* `Deref[ref]` dereference.
* `RefQ[expr]` check if `expr` is a reference.
* `MakeRef[value]` create a reference with the `value`.
* `ExpandDerefAsLValue[expr]` expands dereference in the `expr` as lvalue.

### Usage

Load Package:

```mathematica
Needs["LValueRef`"]
```

Dereference:

```mathematica
a=1;
b=Ref[a];
Deref@b
(*Out[*]= 1*)
```

L-value:

```mathematica
a=1;
b=Ref[a];
Deref@b=2;
a
(*Out[*]= 2*)
```

Or more complicated:

```mathematica
a={1,2,3};
b=Ref[a];
(Deref@b)[[2]]=4;
a
(*Out[*]= {1,4,3}*)
```

Not only symbols can be referenced:

```mathematica
a={1,2,3};
b=Ref[a[[2]]];
Deref@b=4;
a
(*Out[*]= {1,4,3}*)
```

Multiple references:

```mathematica
a=1;
b=Ref[a];
c=Ref[b];
Deref@Deref@c=2;
a
(*Out[*]= 2*)
```

Implicit reference
(`MakeRef` is similar to `new` in Java):

```mathematica
a = MakeRef[1];
Deref[a]
(*Out[*]= 1*)
Deref[a] = 2;
Deref[a]
(*Out[*]= 2*)
```

### Possible alternatives

For simple cases:

```mathematica
a=1;
ra:=Unevaluated@@Hold[a]
f[r_]:=r=2
f[ra];
a
(*Out[*]= 2*)
```
