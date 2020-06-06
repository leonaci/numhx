package numhx.io;

/**
 * ...
 * @author leonaci
 */

typedef BoolArrayData = ArrayBufferView.ArrayBufferViewData;

abstract BoolArray(BoolArrayData) {

	public static inline var ITEM_SIZE = 1;
	public var length(get,never) : Int;
	public var view(get,never) : ArrayBufferView;

	public inline function new( elements : Int ) {
		this = new ArrayBufferView(elements * ITEM_SIZE).getData();
	}

	inline function get_length() {
		return this.byteLength;
	}

	public inline function get_view() : ArrayBufferView {
		return ArrayBufferView.fromData(this);
	}
	
	@:arrayAccess public inline function get( index : Int ) : Bool {
		var value = this.bytes.get(index + this.byteOffset);
		return value == 1;
	}

	@:arrayAccess public inline function set( index : Int, value : Bool ) : Bool {
		if( index >= 0 && index < length ) {
			this.bytes.set(index + this.byteOffset, value? 1 : 0);
			return value;
		}
		return throw 'error: index is out of range.';
	}

	public inline function subarray( ?begin : Int, ?end : Int ) : BoolArray {
		return fromData(this.subarray(begin==null?null:begin,end==null?null:end));
	}

	public inline function getData() : BoolArrayData {
		return this;
	}

	public static function fromData( d : BoolArrayData ) : BoolArray {
		return cast d;
	}

	public static function fromArray( a : Array<Bool>, pos = 0, ?length : Int ) : BoolArray {
		if( length == null ) length = a.length - pos;
		if( pos < 0 || length < 0 || pos + length > a.length ) throw haxe.io.Error.OutsideBounds;
		var i = new BoolArray(a.length);
		for( idx in 0...length )
			i[idx] = a[idx + pos];
		return i;
	}

	public static function fromBytes( bytes : haxe.io.Bytes, bytePos = 0, ?length : Int ) : BoolArray {
		return fromData(ArrayBufferView.fromBytes(bytes,bytePos,length == null ? bytes.length - bytePos : length).getData());
	}
}