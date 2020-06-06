package numhx.io;

/**
 * ...
 * @author leonaci
 */
class IComplex {
	public var re:Float;
	public var im:Float;
	
	public inline function new() {}
	
	public function toString():String {
		var d = 100000;
		var re = Math.round(this.re * d) / d;
		var im = Math.round(this.im * d) / d;
		return switch[re, im] {
			case [0, 0] : '0';
			case [0, im] if(im<0): '- ${-im}';
			case [0, _] : '$im*j';
			case [re, 0] if(re<0): '$re';
			case [_, 0] : '$re';
			case [re, im] if(re<0 && im<0): '- ${-re} - j*${-im}';
			case [re, _] if(re<0): '- ${-re} + j*$im';
			case [_, im] if(im<0): '$re - j*${-im}';
			case [_, _] : '$re + j*$im';
		}
	}
}

@:forward(re, im)
abstract Complex(IComplex) {
	static public var zero(get, never):Complex;
	static function get_zero():Complex return Complex.from(0);
	
	static public var one(get, null):Complex;
	static function get_one():Complex return Complex.from(1);
	
	static public var j(get, null):Complex;
	static function get_j():Complex return Complex.fromComponents(0, 1);
	
	public var rad(get, never):Float;
	inline function get_rad():Float return Math.sqrt(this.re * this.re + this.im * this.im);
	
	public var arg(get, never):Float;
	inline function get_arg():Float return Math.atan2(this.im, this.re);
	
	private inline function new(re:Float, im:Float):Void {
		this = new IComplex();
		this.re = re;
		this.im = im;
	}
	
	@:op(A+B)
	static public function add(c1:Complex, c2:Complex):Complex {
		return Complex.fromComponents(c1.re + c2.re, c1.im + c2.im);
	}
	
	@:op(A-B)
	static public function sub(c1:Complex, c2:Complex):Complex {
		return Complex.fromComponents(c1.re - c2.re, c1.im - c2.im);
	}
	
	@:op(A*B)
	static public function mul(c1:Complex, c2:Complex):Complex {
		return Complex.fromComponents(c1.re * c2.re - c1.im * c2.im, c1.re * c2.im + c1.im * c2.re);
	}
	
	@:commutative @:op(A*B)
	static public function mulScalar(c:Complex, a:Float):Complex {
		return Complex.fromComponents(a * c.re, a * c.im);
	}
	
	@:op(A/B)
	static public function div(c1:Complex, c2:Complex):Complex {
		var n = 1 / (c2.re * c2.re + c2.im + c2.im);
		return Complex.fromComponents((c1.re * c2.re + c1.im * c2.im)*n, (c1.im * c2.re - c1.re * c2.im)*n);
	}
	
	@:op(A/B)
	static public function divScalar(c:Complex, a:Float):Complex {
		return Complex.fromComponents(c.re / a, c.im / a);
	}
	
	@:op(A^B)
	static public function pow(c:Complex, exp:Float):Complex {
		return Complex.fromPolar(Math.pow(c.re * c.re + c.im * c.im, 0.5 * exp), Math.atan2(c.im, c.re) * exp);
	}
	
	@:op(-A)
	static public function neg(c:Complex):Complex {
		return Complex.fromComponents(-c.re, -c.im);
	}
	
	public function clone():Complex {
		return new Complex(this.re, this.im);
	}
	
	static public function fromComponents(re:Float, im:Float):Complex {
		return new Complex(re, im);
	}
	
	static public function fromPolar(radius:Float, angle:Float):Complex {
		return new Complex(radius * Math.cos(angle), radius * Math.sin(angle));
	}
	
	@:from static public function from(a:Float):Complex {
		return new Complex(a, 0);
	}
	
	public function toString():String {
		return this.toString();
	}
}