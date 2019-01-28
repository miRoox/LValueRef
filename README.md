# ``LValueRef` ``

Pointer semantics simulation in Wolfram Language.

* `Ref[lvalue]` refers to `lvalue`.
* `Deref[ref]` dereference.
* `NullRef` is a reference that refers to nothing.
* `RefQ[expr]` check if `expr` is a reference.

### Usage

Dereference:

```mathematica
In[1]:= a=1;
        b=Ref[a];
        Deref@b
Out[1]= 1
```

L-value:

```mathematica
In[2]:= a=1;
        b=Ref[a];
        Deref@b=2;
        a
Out[2]= 2
```

Or more complicated:

```mathematica
In[3]:= a={1,2,3};
        b=Ref[a];
        (Deref@b)[[2]]=4;
        a
Out[3]= {1,4,3}
```

Multiple references:

```mathematica
In[4]:= a=1;
        b=Ref[a];
        c=Ref[b];
        Deref@Deref@c=2;
        a
Out[4]= 2
```
