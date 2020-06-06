package numhx.util;
import Type.ValueType;
import numhx.NdArrayDataType;
import numhx.io.Complex;

/**
 * ...
 * @author leonaci
 */
class TypeValidator
{
	static public function validateType(value:Dynamic, ?expected:NdArrayDataType):NdArrayDataType {
		if (!Std.is(value, Array)) return getDtype(value);
		
		if (value.length == 0) return null;
		
		var dtypes:Array<NdArrayDataType> = [for (j in 0...value.length) validateType(value[j], expected)];
		var max = expected!=null? expected : dtypes[0];
		
		for (dtype in dtypes) max = upcast(max, dtype);
		
		return max;
	}
	
	static public function flatten(value:Dynamic, required:NdArrayDataType):Array<Dynamic> {
		if (!Std.is(value, Array)) {
			var dtype = getDtype(value);
			dtype = upcast(dtype, required);
			
			return [cast_(value, dtype)];
		}
		
		var flatten = value.length==0? [] : Lambda.flatten([for (j in 0...value.length) flatten(value[j], required)]);
		return flatten;
	}
	
	static public function upcast(dtype1:NdArrayDataType, dtype2:NdArrayDataType):NdArrayDataType {
		if (dtype1 == dtype2) return dtype1;
		
		return switch[dtype1, dtype2] {
			case [NdArrayDataType.FLOAT  , NdArrayDataType.INT    ]
			    |[NdArrayDataType.COMPLEX, NdArrayDataType.INT    ]
			    |[NdArrayDataType.COMPLEX, NdArrayDataType.FLOAT  ]: dtype1;
			case [NdArrayDataType.INT    , NdArrayDataType.FLOAT  ]
			    |[NdArrayDataType.INT    , NdArrayDataType.COMPLEX]
			    |[NdArrayDataType.FLOAT  , NdArrayDataType.COMPLEX]: dtype2;
			case [_, _]: throw 'error: not allowed to upcast ${dtype2} type to ${dtype1} type.';
		}
	}
	
	static public  function cast_(value:Dynamic, required:NdArrayDataType):Dynamic {
		if (getDtype(value) == required) return value;
		
		return switch(required) {
			case NdArrayDataType.INT: cast (value, Int);
			case NdArrayDataType.FLOAT: cast (value, Float);
			case NdArrayDataType.COMPLEX: Complex.from(value);
			case NdArrayDataType.BOOL: cast (value, Bool);
		}
	}
	
	static public function getDtype(value:Dynamic):NdArrayDataType {
		return switch(Type.typeof(value)) {
			case ValueType.TFloat: NdArrayDataType.FLOAT;
			case ValueType.TInt: NdArrayDataType.INT;
			case ValueType.TBool: NdArrayDataType.BOOL;
			case ValueType.TClass(clazz) if (clazz == numhx.io.Complex.IComplex): NdArrayDataType.COMPLEX;
			case _: throw 'error: invalid data type.';
		}
	}
}