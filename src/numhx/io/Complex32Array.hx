package numhx.io;

/**
 * ...
 * @author leonaci
 */
typedef Complex32ArrayData = ArrayBufferView.ArrayBufferViewData;

abstract Complex32Array(Complex32ArrayData) {
	public static inline var ITEM_SIZE = 8;
	public var length(get,never) : Int;
	public var view(get,never) : ArrayBufferView;

	public inline function new( elements : Int ) {
		this = new ArrayBufferView(elements * ITEM_SIZE).getData();
	}

	inline function get_length() {
		return this.byteLength >> 3;
	}

	public inline function get_view() : ArrayBufferView {
		return ArrayBufferView.fromData(this);
	}

	@:arrayAccess public inline function get( index : Int ) : Complex {
		return Complex.fromComponents(this.bytes.getFloat((index<<3) + this.byteOffset), this.bytes.getFloat((index<<3) + this.byteOffset + 4));
	}

	@:arrayAccess public inline function set( index : Int, value : Complex ) : Complex {
		if( index >= 0 && index < length ) {
			this.bytes.setFloat((index<<3) + this.byteOffset    , value.re);
			this.bytes.setFloat((index<<3) + this.byteOffset + 4, value.im);
			return value;
		}
		return 0;
	}

	public inline function subarray( ?begin : Int, ?end : Int ) : Complex32Array {
		return fromData(this.subarray(begin==null?null:begin<<3,end==null?null:end<<3));
	}

	public inline function getData() : Complex32ArrayData {
		return this;
	}

	public static function fromData( d : Complex32ArrayData ) : Complex32Array {
		return cast d;
	}

	public static function fromArray( a : Array<Complex>, pos = 0, ?length : Int ) : Complex32Array {
		if( length == null ) length = a.length - pos;
		if( pos < 0 || length < 0 || pos + length > a.length ) throw haxe.io.Error.OutsideBounds;
		var i = new Complex32Array(a.length);
		for( idx in 0...length )
			i[idx] = a[idx + pos];
		return i;
	}

	public static function fromBytes( bytes : haxe.io.Bytes, bytePos = 0, ?length : Int ) : Complex32Array {
		return fromData(ArrayBufferView.fromBytes(bytes, bytePos, (length == null ? (bytes.length - bytePos) >> 3 : length) << 3).getData());
	}
}