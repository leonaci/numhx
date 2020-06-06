package numhx.buffer;
import numhx.NdArrayDataType;
import numhx.backend.Backend;
import numhx.backend.NdArrayOperation;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;

/**
 * ...
 * @author leonaci
 */
class NdArrayBufferManager
{
	private var backend:Backend;
	
	private var bufferMap:Array<NdArrayBuffer>;
	private var stack:Array<NdArrayOperation>;
	
	public function new(backend:Backend) 
	{
		this.backend = backend;
		bufferMap = [];
		stack = [];
	}
	
	public function requestBuffer():NdArrayBuffer {
		var buffer = backend.createBuffer();
		bufferMap[bufferMap.length] = buffer;
		return buffer;
	}
	
	public function disposeBuffer(buffer:NdArrayBuffer):Void {
		// pool buffer
	}
	
	public function allocate(buffer:NdArrayBuffer, length:Int, dtype:NdArrayDataType):Void {
		buffer.allocate(length, dtype);
	}
	
	public function copy(source:NdArrayBufferViewData):NdArrayBufferViewData {
		var buffer = backend.createBuffer();
		buffer.allocate(source.size, source.buffer.dtype);
		buffer.setValue(source.getValue());
		
		bufferMap[bufferMap.length] = buffer;
		
		var shape = source.shape.copy();
		var strides = source.strides.copy();
		
		return new NdArrayBufferViewData(source.manager, buffer, shape, source.ndim, strides, source.size, true);
	}
	
	public function subarray(source:NdArrayBuffer, ?begin:Int, ?end:Int):NdArrayBuffer {
		var buffer = source.subarray(begin, end);
		bufferMap[bufferMap.length] = buffer;
		return buffer;
	}
	
	public function update(buffer:NdArrayBuffer):Void {
		var id = getId(buffer);
		
		var ops:Array<NdArrayOperation> = [];
		
		var affected = [id];
		var stack = stack.copy();
		for (i in 0...stack.length) {
			var op = stack[stack.length-i-1];
			for (output in op.outputs) if (affected.indexOf(output.id) != -1) {
				ops.unshift(op);
				this.stack.remove(op);
				for(input in op.inputs) affected.push(input.id);
				
				break;
			}
		}
		
		backend.run(ops);
	}
	
	public function getId(buffer:NdArrayBuffer):Int {
		var id = bufferMap.indexOf(buffer);
		if (id == -1) throw 'error: this buffer does not be registered on the manager.';
		return id;
	}
	
	public function assign(a:NdArrayBufferViewData, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dummyDst.buffer.dirty = true;
		dst.buffer.dirty = true;
		
		var op = backend.assign(a, dummyDst, dst);
		stack.push(op);
	}
	
	public function assignScalar(a:Dynamic, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dummyDst.buffer.dirty = true;
		dst.buffer.dirty = true;
		
		var op = backend.assignScalar(a, dummyDst, dst);
		stack.push(op);
	}
	
	public function add(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.add(a, b, dst);
		stack.push(op);
	}
	
	public function addScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.addScalar(a, b, dst);
		stack.push(op);
	}
	
	public function sub(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.sub(a, b, dst);
		stack.push(op);
	}
	
	public function subScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.subScalar(a, b, dst);
		stack.push(op);
	}
	
	public function mul(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.mul(a, b, dst);
		stack.push(op);
	}
	
	public function mulScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.mulScalar(a, b, dst);
		stack.push(op);
	}
	
	public function div(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.div(a, b, dst);
		stack.push(op);
	}
	
	public function divScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.divScalar(a, b, dst);
		stack.push(op);
	}
	
	public function dot(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.dot(a, b, dst);
		stack.push(op);
	}
	
	// function
	
	public function abs(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.abs(a, dst);
		stack.push(op);
	}
	
	public function min(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.min(a, b, dst);
		stack.push(op);
	}
	
	public function minScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.minScalar(a, b, dst);
		stack.push(op);
	}
	
	public function max(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.max(a, b, dst);
		stack.push(op);
	}
	
	public function maxScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.maxScalar(a, b, dst);
		stack.push(op);
	}
	
	public function sin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.sin(a, dst);
		stack.push(op);
	}

	public function cos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.cos(a, dst);
		stack.push(op);
	}
	
	public function tan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.tan(a, dst);
		stack.push(op);
	}
	
	public function asin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.asin(a, dst);
		stack.push(op);
	}
	
	public function acos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.acos(a, dst);
		stack.push(op);
	}
	
	public function atan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.atan(a, dst);
		stack.push(op);
	}
	
	public function exp(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.exp(a, dst);
		stack.push(op);
	}
	
	public function log(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.log(a, dst);
		stack.push(op);
	}
	
	public function pow(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.pow(a, b, dst);
		stack.push(op);
	}
	
	public function powScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.powScalar(a, b, dst);
		stack.push(op);
	}
	
	public function sqrt(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.sqrt(a, dst);
		stack.push(op);
	}
	
	public function round(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.round(a, dst);
		stack.push(op);
	}
	
	public function floor(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.floor(a, dst);
		stack.push(op);
	}
	
	public function ceil(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):Void {
		dst.buffer.dirty = true;
		
		var op = backend.ceil(a, dst);
		stack.push(op);
	}
}