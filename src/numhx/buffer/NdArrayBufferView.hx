package numhx.buffer;
import numhx.NdArrayDataType;
import numhx.Slice;
import numhx.buffer.NdArrayBuffer;
import numhx.buffer.NdArrayBufferManager;

/**
 * ...
 * @author leonaci
 */
typedef NdArrayBufferViewData = NdArrayBufferViewImpl;

private class NdArrayBufferViewImpl {
	public var manager:NdArrayBufferManager;
	public var buffer:NdArrayBuffer;
	public var shape:Array<Int>;
	public var ndim:Int;
	public var strides:Array<Int>;
	public var size:Int;
	public var naive:Bool;
	
	public var id(get, never):Int;
	inline function get_id():Int return manager.getId(buffer);
	
	public inline function new(manager:NdArrayBufferManager, buffer:NdArrayBuffer, shape:Array<Int>, ndim:Int, strides:Array<Int>, size:Int, naive:Bool) {
		this.manager = manager;
		this.buffer = buffer;
		this.shape = shape;
		this.ndim = ndim;
		this.strides = strides;
		this.size = size;
		this.naive = naive;
	}
	
	/*
	public inline function get(i:Int):Dynamic {
		update();
		return buffer.get(i);
	}
	
	public inline function getValue():Array<Dynamic> {
		update();
		return buffer.getValue();
	}
	
	public inline function set(i:Int, v:Dynamic):Void {
		buffer.set(i, v);
	}
	
	public inline function setValue(v:Array<Dynamic>):Void {
		buffer.setValue(v);
	}
	*/
	
	public function get(i:Int):Dynamic {
		update();
		
		if (this.naive) return buffer.get(i);
		else {
			var targetStrides = [];
			var c = 1;
			targetStrides.unshift(c);
			for (i in 1...ndim) {
				c *= shape[ndim-i];
				targetStrides.unshift(c);
			}
			
			var j = i;
			var idx = 0;
			for (i in 0...ndim) {
				idx += strides[i] * Std.int(j / targetStrides[i]);
				j %= targetStrides[i];
			}
			
			return buffer.get(idx);
		}
	}
	
	public function getValue():Array<Dynamic> {
		update();
		
		if (this.naive) return buffer.getValue();
		else {
			var targetStrides = [];
			var c = 1;
			targetStrides.unshift(c);
			for (i in 1...ndim) {
				c *= shape[ndim-i];
				targetStrides.unshift(c);
			}
			
			return [for (i in 0...size) {
				var j = i;
				var idx = 0;
				for (i in 0...ndim) {
					idx += strides[i] * Std.int(j / targetStrides[i]);
					j %= targetStrides[i];
				}
				buffer.get(idx);
			}];
		}
	}
	
	public function set(i:Int, v:Dynamic):Void {
		update();
		
		if (this.naive) buffer.set(i, v);
		else {
			var targetStrides = [];
			var c = 1;
			targetStrides.unshift(c);
			for (i in 1...ndim) {
				c *= shape[ndim-i];
				targetStrides.unshift(c);
			}
			
			var j = i;
			var idx = 0;
			for (i in 0...ndim) {
				idx += strides[i] * Std.int(j / targetStrides[i]);
				j %= targetStrides[i];
			}
			
			buffer.set(idx, v);
		}
	}
	
	public function setValue(v:Array<Dynamic>):Void {
		update();
		
		if (this.naive) buffer.setValue(v);
		else {
			var targetStrides = [];
			var c = 1;
			targetStrides.unshift(c);
			for (i in 1...ndim) {
				c *= shape[ndim-i];
				targetStrides.unshift(c);
			}
			
			for (i in 0...size) {
				var j = i;
				var idx = 0;
				for (i in 0...ndim) {
					idx += strides[i] * Std.int(j / targetStrides[i]);
					j %= targetStrides[i];
				}
				buffer.set(idx, v[i]);
			}
		}
	}
	
	public inline function subarray( ?begin : Int, ?end : Int ) : NdArrayBuffer {
		update();
		return manager.subarray(buffer, begin, end);
	}
	
	public function copy() : NdArrayBufferViewData {
		update();
		
		return manager.copy(this);
	}
	
	inline function update():Void {
		if (buffer.dirty) {
			manager.update(buffer);
			buffer.dirty = false;
		}
	}
}

abstract NdArrayBufferView(NdArrayBufferViewData) {
	public var shape(get, never):Array<Int>;
	inline function get_shape():Array<Int> return this.shape;
	
	public var strides(get, never):Array<Int>;
	inline function get_strides():Array<Int> return this.strides;
	
	public var ndim(get, never):Int;
	inline function get_ndim():Int return this.ndim;
	
	public var size(get, never):Int;
	inline function get_size():Int return this.size;
	
	public var itemsize(get, never):Int;
	inline function get_itemsize():Int return this.buffer.itemsize;
	
	public var dtype(get, never):NdArrayDataType;
	inline function get_dtype():NdArrayDataType return this.buffer.dtype;
	
	public var T(get, never):NdArrayBufferViewData;
	inline function get_T():NdArrayBufferViewData {
		if (ndim < 2) return this;
		
		var shape = this.shape.copy();
		shape.reverse();
		
		var strides = this.strides.copy();
		strides.reverse();
		
		return new NdArrayBufferViewData(this.manager, this.buffer, shape, ndim, strides, size, false);
	}
	
	public inline function new(manager:NdArrayBufferManager, shape:Array<Int>, dtype:NdArrayDataType) {
		var buffer = manager.requestBuffer();
		
		var shape = shape.copy();
		var ndim = shape.length;
		
		var size:Int = 1;
		for (i in 0...ndim) {
			if (shape[i] == -1) {
				size = -1;
				break;
			}
			size *= shape[i];
		}
		
		var strides = [];
		if (size != -1) {
			var c = 1;
			strides.unshift(c);
			for (i in 1...ndim) {
				c *= shape[ndim-i];
				strides.unshift(c);
			}
			
			manager.allocate(buffer, size, dtype);
		}
		
		this = new NdArrayBufferViewData(manager, buffer, shape, ndim, strides, size, true);
	}
	
	public function reshape(shape:Array<Int>):NdArrayBufferView {
		for (i in 0...ndim) {
			if (shape[i] != this.shape[i]) break;
			if(i==ndim-1) return this;
		}
		
		var shape = shape.copy();
		
		var ndim = shape.length;
		
		var size = 1;
		for (i in 0...ndim) {
			if (shape[i] == -1) {
				size = -1;
				break;
			}
			size *= shape[i];
		}
		if (size != this.size) throw 'error: this shape does not match the buffer size.';
		
		var strides = [];
		var c = 1;
		strides.unshift(c);
		for (i in 1...ndim) {
			c *= shape[ndim-i];
			strides.unshift(c);
		}
		
		for (i in 1...this.ndim) if (this.strides[i-1] != this.strides[i]*this.shape[i]) {
			var data = this.copy();
			data.shape = shape;
			data.ndim = ndim;
			data.strides = strides;
			data.size = size;
			return fromData(data);
		}
		
		return new NdArrayBufferViewData(this.manager, this.buffer, shape, ndim, strides, size, false);
	}
	
	public inline function transpose(axis:Array<Int>) {
		if (axis.length != this.ndim) throw 'error: invalid axis.';
		var shape = [for (i in 0...ndim) this.shape[axis[i]]];
		var strides = [for (i in 0...ndim) this.strides[axis[i]]];
		return new NdArrayBufferViewData(this.manager, this.buffer, shape, this.ndim, strides, this.size, false);
	}
	
	public function slice(k:Slice):NdArrayBufferView {
		var shape = this.shape.copy();
		var strides = this.strides.copy();
		
		var offset = k.resolveSlice(shape, strides);
		var buffer = this.subarray(offset);
		var ndim = shape.length;
		
		var size = 1;
		for (i in 0...shape.length) size *= shape[i];
		
		return new NdArrayBufferViewData(this.manager, buffer, shape, ndim, strides, size, false);
	}
	
	public function copy() : NdArrayBufferView {
		return this.copy();
	}
	
	public function toString():String {
		var maxLength = 0;
		var flatten = [];
		
		var value = this.getValue();
		for (i in 0...value.length) {
			var str:String = Std.string(value[i]);
			if (str.length > maxLength) maxLength = str.length;
			flatten.push(str);
		}
		
		var bs:Array<Int> = [];
		var c:Int = this.ndim, b:Int = 1;
		while (c > 0) {
			bs.push(b);
			b *= this.shape[--c];
		}
		bs.push(b);
		
		var ws:Array<Array<String>> = [for(i in 0...bs.length) []];
		for (i in 0...this.size) {
			var t = this.ndim;
			while (t >= 0) {
				if ((i+1) % bs[t] == 0) break;
				t--;
			}
			
			var str = flatten[i];
			
			str = [for(i in 0...maxLength-str.length) ' '].join('') + str;
			ws[0].push(str);
			
			for (k in 0...t) {
				var w = StringTools.replace(ws[k].join(k==0? ', ' : ',' + [for(i in 0...k) '\n'].join('')), '\n', '\n ');
				ws[k+1].push('[$w]');
				ws[k] = [];
			}
		}
		
		var w:String = ws[this.ndim][0];
		return '\n$w';
	}
	
	public inline function toData():NdArrayBufferViewData {
		return this;
	}
	
	@:from static public inline function fromData(data:NdArrayBufferViewData):NdArrayBufferView {
		return cast data;
	}
}