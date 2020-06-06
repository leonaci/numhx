package numhx ;
import numhx.buffer.NdArrayBuffer;
import numhx.buffer.NdArrayBufferManager;
import numhx.buffer.NdArrayBufferView;
import numhx.util.ShapeValidator;
import numhx.util.TypeValidator;

/**
 * ...
 * @author leonaci
 */
typedef NdArrayData = numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;

abstract NdArray(NdArrayData) {
	private var view(get, never):NdArrayBufferView;
	inline function get_view():NdArrayBufferView return NdArrayBufferView.fromData(this);
	
	public var data(get, never):NdArrayBuffer;
	inline function get_data():NdArrayBuffer return this.buffer;
	
	public var shape(get, never):Array<Int>;
	inline function get_shape():Array<Int> return view.shape;
	
	public var strides(get, never):Array<Int>;
	inline function get_strides():Array<Int> return view.strides;
	
	public var ndim(get, never):Int;
	inline function get_ndim():Int return view.ndim;
	
	public var size(get, never):Int;
	inline function get_size():Int return view.size;
	
	public var itemsize(get, never):Int;
	inline function get_itemsize():Int return view.itemsize;
	
	public var nbytes(get, never):Int;
	inline function get_nbytes():Int return view.size * view.itemsize;
	
	public var dtype(get, never):NdArrayDataType;
	inline function get_dtype():NdArrayDataType return view.dtype;
	
	public var T(get, never):NdArray;
	inline function get_T():NdArray return cast view.T;
	
	private function new(manager:NdArrayBufferManager, shape:Array<Int>, dtype:NdArrayDataType) {
		this = new NdArrayBufferView(manager, shape, dtype).toData();
	}
	
	@:op([]) public function get(k:Slice):NdArray {
		return cast view.slice(k);
	}
	
	@:op([]) public function getValue(k:Array<Int>):Dynamic {
		if (k.length != ndim) throw 'error: key length unmatches ndarray dim.';
		
		var targetStrides = [];
		var c = 1;
		targetStrides.unshift(c);
		for (i in 1...ndim) {
			c *= shape[ndim-i-1];
			targetStrides.unshift(c);
		}
		
		var idx = 0;
		for (i in 0...ndim) idx += targetStrides[i] * k[i];
		
		return cast this.get(idx);
	}
	
	@:op([]) public function set(k:Slice, v:NdArray):NdArray {
		var a:NdArray = v;
		var dummyDst:NdArray = cast this;
		var dst:NdArray = cast view.slice(k);
		
		NdArraySession.manager.assign(cast a, cast dummyDst, cast dst);
		
		return dummyDst;
	}
	
	@:op([]) public function setValue(k:Slice, v:Dynamic):NdArray {
		var a:Dynamic = v;
		var dummyDst:NdArray = cast this;
		var dst:NdArray = get(k);
		
		NdArraySession.manager.assignScalar(cast a, cast dummyDst, cast dst);
		
		return dummyDst;
	}
	
	@:op(A + B)
	static public function add(a:NdArray, b:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, ShapeValidator.validateBinOpShape(a, b), TypeValidator.upcast(a.dtype, b.dtype));
		
		NdArraySession.manager.add(cast a, cast b, cast dst);
		
		return dst;
	}
	
	@:op(A += B)
	static public function addAssign(a:NdArray, b:NdArray):NdArray {
		ShapeValidator.validateBinOpShape(a, b);
		TypeValidator.upcast(a.dtype, b.dtype);
		
		NdArraySession.manager.add(cast a, cast b, cast a);
		
		return a;
	}
	
	@:commutative @:op(A + B)
	static public function addScalar(a:NdArray, b:Dynamic):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b)));
		
		NdArraySession.manager.addScalar(cast a, cast b, cast dst);
		
		return dst;
	}
	
	@:op(A += B)
	static public function addScalarAssign(a:NdArray, b:Dynamic):NdArray {
		TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b));
		
		NdArraySession.manager.addScalar(cast a, cast b, cast a);
		
		return a;
	}
	
	@:op(A - B)
	static public function sub(a:NdArray, b:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, ShapeValidator.validateBinOpShape(a, b), TypeValidator.upcast(a.dtype, b.dtype));
		
		NdArraySession.manager.sub(cast a, cast b, cast dst);
		
		return dst;
	}
	
	@:op(A -= B)
	static public function subAssign(a:NdArray, b:NdArray):NdArray {
		ShapeValidator.validateBinOpShape(a, b);
		TypeValidator.upcast(a.dtype, b.dtype);
		
		NdArraySession.manager.sub(cast a, cast b, cast a);
		
		return a;
	}
	
	@:op(A - B)
	static public function subScalar(a:NdArray, b:Dynamic):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b)));
		
		NdArraySession.manager.subScalar(cast a, cast b, cast dst);
		
		return dst;
	}
	
	@:op(A -= B)
	static public function subScalarAssign(a:NdArray, b:Dynamic):NdArray {
		TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b));
		
		NdArraySession.manager.subScalar(cast a, cast b, cast a);
		
		return a;
	}
	
	@:op(A * B)
	static public function mul(a:NdArray, b:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, ShapeValidator.validateBinOpShape(a, b), TypeValidator.upcast(a.dtype, b.dtype));
		
		NdArraySession.manager.mul(cast a, cast b, cast dst);
		
		return dst;
	}
	
	@:op(A *= B)
	static public function mulAssign(a:NdArray, b:NdArray):NdArray {
		ShapeValidator.validateBinOpShape(a, b);
		TypeValidator.upcast(a.dtype, b.dtype);
		
		NdArraySession.manager.mul(cast a, cast b, cast a);
		
		return a;
	}
	
	@:commutative @:op(A * B)
	static public function mulScalar(a:NdArray, b:Dynamic):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b)));
		
		NdArraySession.manager.mulScalar(cast a, cast b, cast dst);
		
		return dst;
	}
	
	@:op(A *= B)
	static public function mulScalarAssign(a:NdArray, b:Dynamic):NdArray {
		TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b));
		
		NdArraySession.manager.mulScalar(cast a, cast b, cast a);
		
		return a;
	}
	
	
	@:op(A / B)
	static public function div(a:NdArray, b:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, ShapeValidator.validateBinOpShape(a, b), TypeValidator.upcast(a.dtype, b.dtype));
		
		NdArraySession.manager.div(cast a, cast b, cast dst);
		
		return dst;
	}
	
	@:op(A /= B)
	static public function divAssign(a:NdArray, b:NdArray):NdArray {
		ShapeValidator.validateBinOpShape(a, b);
		TypeValidator.upcast(a.dtype, b.dtype);
		
		NdArraySession.manager.div(cast a, cast b, cast a);
		
		return a;
	}
	
	@:op(A / B)
	static public function divScalar(a:NdArray, b:Dynamic):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b)));
		
		NdArraySession.manager.divScalar(cast a, cast b, cast dst);
		
		return dst;
	}
	
	@:op(A /= B)
	static public function divScalarAssign(a:NdArray, b:Dynamic):NdArray {
		TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b));
		
		NdArraySession.manager.divScalar(cast a, cast b, cast a);
		
		return a;
	}
	
	@:op(-A)
	static public function negate(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.mulScalar(cast a, -1, cast dst);
		
		return dst;
	}
	
	static public function dot(a:NdArray, b:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, ShapeValidator.validateDotShape(a, b), TypeValidator.upcast(a.dtype, b.dtype));
		
		NdArraySession.manager.dot(cast a, cast b, cast dst);
		
		return dst;
	}
	
	public inline function reshape(shape:Array<Int>):NdArray {
		return cast view.reshape(shape);
	}
	
	public inline function transpose(axis:Array<Int>) {
		return cast view.transpose(axis);
	}
	
	public function copy() : NdArray {
		return cast view.copy();
	}
	
	public inline function toString():String {
		return view.toString();
	}
	
	
	/* static methods */
	
	static public function array(value:Dynamic, ?dtype:NdArrayDataType):NdArray {
		return NdArray.fromArray(value, dtype);
	}
	
	static public function zeros(size:Int, ?dtype:NdArrayDataType):NdArray {
		return NdArray.fromArray([for(i in 0...size) 0], dtype);
	}
	
	static public function ones(size:Int, ?dtype:NdArrayDataType):NdArray {
		return NdArray.fromArray([for(i in 0...size) 1], dtype);
	}
	
	static public function arange(arg1:Int, ?arg2:Int, ?arg3:Int, ?dtype:NdArrayDataType):NdArray {
		var array = [];
		var begin:Int, end:Int, stride:Int;
		
		if (arg2 == null && arg3 == null) {
			begin = 0;
			end = arg1;
			stride = 1;
		}
		else if (arg3 == null) {
			begin = arg1;
			end = arg2;
			stride = 1;
		}
		else {
			begin = arg1;
			end = arg2;
			stride = arg3;
		}
		
		var c = begin;
		while (c < end) {
			array.push(c);
			c += stride;
		}
		
		return NdArray.fromArray(array, dtype);
	}
	
	static public function identity(size:Int, ?dtype:NdArrayDataType=NdArrayDataType.FLOAT):NdArray {
		return NdArray.array([for (i in 0...size) [for (j in 0...size) i == j? 1 : 0]], dtype);
	}
	
	static public function diag(values:Array<Dynamic>, ?dtype:NdArrayDataType):NdArray {
		var size = values.length;
		var ndarray:NdArray = NdArray.array([for (i in 0...size) [for (j in 0...size) i == j? values[i] : 0]], dtype);
		
		return ndarray;
	}
	
	static public function blockDiag(values:Array<NdArray>, ?dtype:NdArrayDataType):NdArray {
		if (values.length == 0) throw 'error: blocks are empty.';
		
		var dtype = dtype == null? values[0].dtype : dtype;
		for (block in values) {
			if (block.ndim != 2) throw 'error: each block should be matrix.';
			if (block.shape[0] != block.shape[1]) throw 'error: each block should be square.';
			dtype = TypeValidator.upcast(block.dtype, dtype);
		}
		
		var length = 0;
		for (block in values) length += block.shape[0];
		
		var strides = 0;
		var array = NdArray.diag([for (i in 0...length) 0], dtype);
		for (block in values) {
			var l = block.shape[0];
			array['${strides}:${strides+l}, ${strides}:${strides+l}'] = block;
			strides += l;
		}
		
		return array;
	}
	
	static public function abs(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, NdArrayDataType.FLOAT);
		
		NdArraySession.manager.abs(cast a, cast dst);
		
		return dst;
	}
	
	static public function min(a:NdArray, b:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, ShapeValidator.validateBinOpShape(a, b), TypeValidator.upcast(a.dtype, b.dtype));
		
		NdArraySession.manager.min(cast a, cast b, cast dst);
		
		return dst;
	}
	
	static public function minScalar(a:NdArray, b:Dynamic):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b)));
		
		NdArraySession.manager.minScalar(cast a, cast b, cast dst);
		
		return dst;
	}
	
	static public function max(a:NdArray, b:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, ShapeValidator.validateBinOpShape(a, b), TypeValidator.upcast(a.dtype, b.dtype));
		
		NdArraySession.manager.max(cast a, cast b, cast dst);
		
		return dst;
	}
	
	static public function maxScalar(a:NdArray, b:Dynamic):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b)));
		
		NdArraySession.manager.maxScalar(cast a, cast b, cast dst);
		
		return dst;
	}
	
	static public function sin(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.sin(cast a, cast dst);
		
		return dst;
	}
	
	static public function cos(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.cos(cast a, cast dst);
		
		return dst;
	}
	
	static public function tan(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.tan(cast a, cast dst);
		
		return dst;
	}
	
	static public function asin(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.asin(cast a, cast dst);
		
		return dst;
	}
	
	static public function acos(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.acos(cast a, cast dst);
		
		return dst;
	}
	
	static public function atan(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.atan(cast a, cast dst);
		
		return dst;
	}
	
	static public function exp(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.exp(cast a, cast dst);
		
		return dst;
	}
	
	static public function log(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.log(cast a, cast dst);
		
		return dst;
	}
	
	static public function pow(a:NdArray, b:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, ShapeValidator.validateBinOpShape(a, b), TypeValidator.upcast(a.dtype, b.dtype));
		
		NdArraySession.manager.pow(cast a, cast b, cast dst);
		
		return dst;
	}
	
	static public function powScalar(a:NdArray, b:Dynamic):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, TypeValidator.upcast(a.dtype, TypeValidator.getDtype(b)));
		
		NdArraySession.manager.powScalar(cast a, cast b, cast dst);
		
		return dst;
	}
	
	static public function sqrt(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.sqrt(cast a, cast dst);
		
		return dst;
	}
	
	static public function round(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.round(cast a, cast dst);
		
		return dst;
	}
	
	static public function floor(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.floor(cast a, cast dst);
		
		return dst;
	}
	
	static public function ceil(a:NdArray):NdArray {
		var dst = new NdArray(NdArraySession.manager, a.shape, a.dtype);
		
		NdArraySession.manager.ceil(cast a, cast dst);
		
		return dst;
	}
	
	static function fromArray(value:Dynamic, ?dtype:NdArrayDataType):NdArray {
		var shape = ShapeValidator.validateShape(value);
		var dtype = TypeValidator.validateType(value, dtype);
		var flatten = TypeValidator.flatten(value, dtype);
		
		var array = new NdArray(NdArraySession.manager, shape, dtype);
		
		//var view:NdArrayBufferView = cast array;
		array.data.setValue(flatten);
		
		return array;
	}
}