# Numhx
Numhx is a numerical calculation library similar to numpy api,
allowing to manipulate multi-dimensional arrays and matrices.

This library currently supports CPU backends only.

## Usage
Declare the backend you use(but CPU backend only available now...)

```haxe
NdArraySession.setBackend(BackendKind.Cpu);
```

Define `NdArray` using numpy-like methods.

```haxe
var a = NdArray.array([
    [
        [0*Complex.j,1,2,3,4],
        [5, 6, 7, 8, 9],
    ],
    [
        [10, 11, 12, 13, 14],
        [15, 16, 17, 18, 19],
    ],
]);
```

You can specify the data type explicitly.

```haxe
NdArray.arange(20, NdArrayDataType.COMPLEX);
```

### Slice
You can access `NdArray` by string expression.
Without colon, you get the element.

```haxe
var a = NdArray.arange(1, 51);
trace(a); // [1, ..., 50]
trace(a['9']); // 10
```

With colon(slice notation), you get the "slice" of the `NdArray`(shallow copy).

```haxe
trace(a['9:40:5']); // [10, 15, 20, 25, 30, 35, 40]
trace(a['::-5']); // [50, 45, 40, 35, 30, 25, 20, 15, 10,  5]
```

You can also use ellipsis `...`

```haxe
a = NdArray.arange(3 * 3 * 3).reshape([3, 3, 3]);
trace(a);
/*
[[[ 0,  1,  2], [ 3,  4,  5], [ 6,  7,  8]],
 [[ 9, 10, 11], [12, 13, 14], [15, 16, 17]],
 [[18, 19, 20], [21, 22, 23], [24, 25, 26]]]
*/

trace(a[':,:,2']); // [[ 2,  5,  8], [11, 14, 17], [20, 23, 26]]
trace(a['...,2']); // [[ 2,  5,  8], [11, 14, 17], [20, 23, 26]]
```

and `None`(insertion new axis).
 
```haxe
trace(a['0,1,2,None']); // [5]
```

### Operation
You can use element-wise operations.

`add`, `addScalar`,
`sub`, `subScalar`,
`mul`, `mulScalar`,
`div`, `divScalar`,
`negate`,
`abs`,
`min`, `minScalar`,
`max`, `macScalar`,
`sin`, `cos`, `tan`,
`asin`, `acos`, `atan`,
`exp`, `log`,
`pow`, `powScalar`,
`sqrt`,
`round`, `floor`, `ceil`

---

`dot` provides not only vector dot product, but also general tensor contraction.

```haxe
var a = NdArray.arange(60).reshape([2,3,10]);
var b = NdArray.arange(30).reshape([10,3]);

trace(a.shape); // [2, 3, 10]
trace(b.shape); // [10, 3]
trace(NdArray.dot(a,b).shape); // [2, 3, 3]
```

In case of two vectors, it applies dot product.
In case of two matrices, it applies matrix product.