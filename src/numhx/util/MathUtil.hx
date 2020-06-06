package numhx.util;
import numhx.NdArrayDataType;
import numhx.io.Complex;

/**
 * ...
 * @author leonaci
 */
class MathUtil
{
	static public function add(a:Dynamic, b:Dynamic):Dynamic {
		var dtype = TypeValidator.upcast(TypeValidator.getDtype(a), TypeValidator.getDtype(b));
		a = TypeValidator.cast_(a, dtype);
		b = TypeValidator.cast_(b, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: a + b;
			case NdArrayDataType.COMPLEX: Complex.add(a, b);
			case NdArrayDataType.BOOL: a || b;
		}
	}
	
	static public function sub(a:Dynamic, b:Dynamic):Dynamic {
		var dtype = TypeValidator.upcast(TypeValidator.getDtype(a), TypeValidator.getDtype(b));
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		var b:Dynamic = TypeValidator.cast_(b, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: a - b;
			case NdArrayDataType.COMPLEX: Complex.sub(a, b);
			case NdArrayDataType.BOOL: a || cast ~b;
		}
	}
	
	static public function mul(a:Dynamic, b:Dynamic):Dynamic {
		var dtype = TypeValidator.upcast(TypeValidator.getDtype(a), TypeValidator.getDtype(b));
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		var b:Dynamic = TypeValidator.cast_(b, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: a * b;
			case NdArrayDataType.COMPLEX: Complex.mul(a, b);
			case NdArrayDataType.BOOL: a && b;
		}
	}
	
	static public function div(a:Dynamic, b:Dynamic):Dynamic {
		var dtype = TypeValidator.upcast(TypeValidator.getDtype(a), TypeValidator.getDtype(b));
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		var b:Dynamic = TypeValidator.cast_(b, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: a / b;
			case NdArrayDataType.COMPLEX: Complex.div(a, b);
			case NdArrayDataType.BOOL: a && cast ~b;
		}
	}
	
	static public function abs(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: Math.abs(a);
			case NdArrayDataType.COMPLEX: Math.sqrt(a.re * a.re + a.im * a.im);
			case NdArrayDataType.BOOL: a;
		}
	}
	
	static public function min(a:Dynamic, b:Dynamic):Dynamic {
		var dtype = TypeValidator.upcast(TypeValidator.getDtype(a), TypeValidator.getDtype(b));
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		var b:Dynamic = TypeValidator.cast_(b, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: a<b? a : b;
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function max(a:Dynamic, b:Dynamic):Dynamic {
		var dtype = TypeValidator.upcast(TypeValidator.getDtype(a), TypeValidator.getDtype(b));
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		var b:Dynamic = TypeValidator.cast_(b, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: a>b? a : b;
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function sin(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.sin(a);
			case NdArrayDataType.COMPLEX: Complex.fromPolar(0.5*Math.exp(-a.im), a.re - 0.5*Math.PI) - Complex.fromPolar(0.5*Math.exp(a.im), -a.re - 0.5*Math.PI);
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function cos(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.cos(a);
			case NdArrayDataType.COMPLEX: Complex.fromPolar(0.5*Math.exp(-a.im), a.re) + Complex.fromPolar(0.5*Math.exp(a.im), -a.re);
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function tan(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.tan(a);
			case NdArrayDataType.COMPLEX:
			{
				var s:Complex = Complex.fromPolar(Math.exp(-a.im), a.re - 0.5*Math.PI) - Complex.fromPolar(Math.exp(a.im), -a.re - 0.5*Math.PI);
				var c:Complex = Complex.fromPolar(Math.exp( -a.im), a.re) + Complex.fromPolar(Math.exp(a.im), -a.re);
				s / c;
			}
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function asin(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.asin(a);
			//case NdArrayDataType.COMPLEX: Complex.fromPolar(0.5*Math.exp(-a.im), a.re - 0.5*Math.PI) - Complex.fromPolar(0.5*Math.exp(a.im), -a.re - 0.5*Math.PI);
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function acos(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.acos(a);
			//case NdArrayDataType.COMPLEX: Complex.fromPolar(0.5*Math.exp(-a.im), a.re) + Complex.fromPolar(0.5*Math.exp(a.im), -a.re);
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function atan(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.atan(a);
			/*
			case NdArrayDataType.COMPLEX:
			{
				var s:Complex = Complex.fromPolar(Math.exp(-a.im), a.re - 0.5*Math.PI) - Complex.fromPolar(Math.exp(a.im), -a.re - 0.5*Math.PI);
				var c:Complex = Complex.fromPolar(Math.exp( -a.im), a.re) + Complex.fromPolar(Math.exp(a.im), -a.re);
				s / c;
			}
			*/
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function exp(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.exp(a);
			case NdArrayDataType.COMPLEX: Complex.fromPolar(Math.exp(a.re), a.im);
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function log(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.log(a);
			//case NdArrayDataType.COMPLEX: Complex.fromPolar(Math.exp(a.re), a.im);
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function pow(v:Dynamic, exp:Float):Dynamic {
		var dtype = TypeValidator.getDtype(v);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.pow(v, exp);
			case NdArrayDataType.COMPLEX: Complex.pow(v, exp);
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function sqrt(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: Math.sqrt(a);
			case NdArrayDataType.COMPLEX: Complex.fromPolar(Math.sqrt(a.rad), 0.5*a.arg);
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function round(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: Math.round(a);
			case NdArrayDataType.COMPLEX: Complex.fromComponents(Math.round(a.re), Math.round(a.im));
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function floor(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: Math.floor(a);
			case NdArrayDataType.COMPLEX: Complex.fromComponents(Math.floor(a.re), Math.floor(a.im));
			case _: throw 'error: invalid operation.';
		}
	}
	
	static public function ceil(a:Dynamic):Dynamic {
		var dtype = TypeValidator.getDtype(a);
		var a:Dynamic = TypeValidator.cast_(a, dtype);
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT | NdArrayDataType.INT: Math.ceil(a);
			case NdArrayDataType.COMPLEX: Complex.fromComponents(Math.ceil(a.re), Math.ceil(a.im));
			case _: throw 'error: invalid operation.';
		}
	}
}