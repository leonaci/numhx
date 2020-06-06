package numhx.io;

/**
 * ...
 * @author leonaci
 */
typedef ArrayBufferViewData = ArrayBufferViewImpl;

class ArrayBufferViewImpl {
	public var bytes : haxe.io.Bytes;
	public var byteOffset : Int;
	public var byteLength : Int;
	public function new(bytes, pos, length) {
		this.bytes = bytes;
		this.byteOffset = pos;
		this.byteLength = length;
	}
	public function sub( begin : Int, ?length : Int ) {
		if( length == null ) length = byteLength - begin;
		if( begin < 0 || length < 0 || begin + length > byteLength ) throw haxe.io.Error.OutsideBounds;
		return new ArrayBufferViewImpl(bytes, byteOffset + begin, length);
	}
	public function subarray( ?begin : Int, ?end : Int ) {
		if( begin == null ) begin = 0;
		if( end == null ) end = byteLength - begin;
		return sub(begin, end - begin);
	}
}

abstract ArrayBufferView(ArrayBufferViewData) {
	public var buffer(get,never) : haxe.io.Bytes;
	public var byteOffset(get, never) : Int;
	public var byteLength(get, never) : Int;

	public inline function new( size : Int ) {
		this = new ArrayBufferViewData(haxe.io.Bytes.alloc(size), 0, size);
	}

	inline function get_byteOffset() : Int return this.byteOffset;
	inline function get_byteLength() : Int return this.byteLength;
	inline function get_buffer() : haxe.io.Bytes return this.bytes;

	public inline function subarray( ?begin : Int, ?end : Int ) : ArrayBufferView {
		return fromData(this.subarray(begin,end));
	}

	public inline function getData() : ArrayBufferViewData {
		return this;
	}

	public static inline function fromData( a : ArrayBufferViewData ) : ArrayBufferView {
		return cast a;
	}

	public static function fromBytes( bytes : haxe.io.Bytes, pos = 0, ?length : Int ) : ArrayBufferView {
		if( length == null ) length = bytes.length - pos;
		if( pos < 0 || length < 0 || pos + length > bytes.length ) throw haxe.io.Error.OutsideBounds;
		return fromData(new ArrayBufferViewData(bytes, pos, length));
	}

}