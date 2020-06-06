package numhx.io;

/**
 * ...
 * @author leonaci
 */
typedef Float32ArrayData = ArrayBufferView.ArrayBufferViewData;

abstract Float32Array(Float32ArrayData) {
	public static inline var ITEM_SIZE = 4;
	public var length(get,never) : Int;
	public var view(get,never) : ArrayBufferView;

	public inline function new( elements : Int ) {
		this = new ArrayBufferView(elements * ITEM_SIZE).getData();
	}

	inline function get_length() {
		return this.byteLength >> 2;
	}

	public inline function get_view() : ArrayBufferView {
		return ArrayBufferView.fromData(this);
	}

	@:arrayAccess public inline function get( index : Int ) : Float {
		return this.bytes.getFloat((index<<2) + this.byteOffset);
	}

	@:arrayAccess public inline function set( index : Int, value : Float ) : Float {
		if( index >= 0 && index < length ) {
			this.bytes.setFloat((index<<2) + this.byteOffset, value);
			return value;
		}
		return 0;
	}

	public inline function subarray( ?begin : Int, ?end : Int ) : Float32Array {
		return fromData(this.subarray(begin==null?null:begin<<2,end==null?null:end<<2));
	}

	public inline function getData() : Float32ArrayData {
		return this;
	}

	public static function fromData( d : Float32ArrayData ) : Float32Array {
		return cast d;
	}

	public static function fromArray( a : Array<Float>, pos = 0, ?length : Int ) : Float32Array {
		if( length == null ) length = a.length - pos;
		if( pos < 0 || length < 0 || pos + length > a.length ) throw haxe.io.Error.OutsideBounds;
		var i = new Float32Array(a.length);
		for( idx in 0...length )
			i[idx] = a[idx + pos];
		return i;
	}

	public static function fromBytes( bytes : haxe.io.Bytes, bytePos = 0, ?length : Int ) : Float32Array {
		return fromData(ArrayBufferView.fromBytes(bytes,bytePos,(length == null ? (bytes.length - bytePos)>>2 : length)<<2).getData());
	}
}
