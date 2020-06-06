package numhx.backend.cpu;
import numhx.NdArrayDataType;
import numhx.buffer.NdArrayBuffer;
import numhx.io.ArrayBufferView.ArrayBufferViewData;
import numhx.io.BoolArray;
import numhx.io.Complex32Array;
import numhx.io.Float32Array;
import numhx.io.Int32Array;

/**
 * ...
 * @author leonaci
 */
class CpuNdArrayBuffer implements NdArrayBuffer
{
	private var buffer:ArrayBufferViewData;
	
	public var offset(default, null):Int;
	public var length(default, null):Int;
	public var itemsize(default, null):Int;
	public var dtype(default, null):NdArrayDataType;
	public var dirty:Bool;
	
	public function new() {
		offset = 0;
		dirty = false;
	}
	
	public function allocate(length:Int, dtype:NdArrayDataType):Void {
		this.length = length;
		this.dtype = dtype;
		
		switch(dtype) {
			case NdArrayDataType.FLOAT: 
			{
				this.itemsize = Float32Array.ITEM_SIZE;
				this.buffer = new Float32Array(length).getData();
			}
			case NdArrayDataType.INT:
			{
				this.itemsize = Int32Array.ITEM_SIZE;
				this.buffer = new Int32Array(length).getData();
			}
			case NdArrayDataType.COMPLEX:
			{
				this.itemsize = Complex32Array.ITEM_SIZE;
				this.buffer = new Complex32Array(length).getData();
			}
			case NdArrayDataType.BOOL:
			{
				this.itemsize = BoolArray.ITEM_SIZE;
				this.buffer = new BoolArray(length).getData();
			}
		}
	}
	
	public function get(i:Int):Dynamic {
		return switch(dtype) {
			case NdArrayDataType.FLOAT:     Float32Array.fromData(cast buffer)[offset + i];
			case NdArrayDataType.INT:         Int32Array.fromData(cast buffer)[offset + i];
			case NdArrayDataType.COMPLEX: Complex32Array.fromData(cast buffer)[offset + i];
			case NdArrayDataType.BOOL:         BoolArray.fromData(cast buffer)[offset + i];
		}
	}
	
	public function set(i:Int, v:Dynamic):Dynamic {
		return switch(dtype) {
			case NdArrayDataType.FLOAT:     Float32Array.fromData(cast buffer)[offset + i] = v;
			case NdArrayDataType.INT:         Int32Array.fromData(cast buffer)[offset + i] = v;
			case NdArrayDataType.COMPLEX: Complex32Array.fromData(cast buffer)[offset + i] = v;
			case NdArrayDataType.BOOL:         BoolArray.fromData(cast buffer)[offset + i] = v;
		}
	}
	
	public function getValue():Array<Dynamic> {
		return switch(dtype) {
			case NdArrayDataType.FLOAT:   [for(i in 0...this.length) Float32Array.fromData(cast buffer)[offset + i]];
			case NdArrayDataType.INT:     [for(i in 0...this.length) Int32Array.fromData(cast buffer)[offset + i]];
			case NdArrayDataType.COMPLEX: [for(i in 0...this.length) Complex32Array.fromData(cast buffer)[offset + i]];
			case NdArrayDataType.BOOL:    [for(i in 0...this.length) BoolArray.fromData(cast buffer)[offset + i]];
		}
	}
	
	public function setValue(v:Array<Dynamic>):Void {
		if (v.length != this.length) throw 'error: the size of values is mismatched.';
		switch(dtype) {
			case NdArrayDataType.FLOAT:   for(i in 0...this.length) Float32Array.fromData(cast buffer)[offset + i] = v[i];
			case NdArrayDataType.INT:     for(i in 0...this.length) Int32Array.fromData(cast buffer)[offset + i] = v[i];
			case NdArrayDataType.COMPLEX: for(i in 0...this.length) Complex32Array.fromData(cast buffer)[offset + i] = v[i];
			case NdArrayDataType.BOOL:    for(i in 0...this.length) BoolArray.fromData(cast buffer)[offset + i] = v[i];
		}
	}
	
	public function subarray( ?begin : Int, ?end : Int ) : NdArrayBuffer {
		var data = new CpuNdArrayBuffer();
		
		data.buffer = buffer;
		
		if( begin == null ) begin = 0;
		if( end == null ) end = this.length - begin;
		
		data.offset = offset + begin;
		data.length = end - begin;
		data.itemsize = itemsize;
		data.dtype = dtype;
		
		return data;
	}
	
	public function fill(?begin:Array<Int>, ?end:Array<Int>, ?slice:Array<Int>, v:Dynamic):Void {
	}
}