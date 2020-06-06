package numhx;

/**
 * ...
 * @author leonaci
 */
enum SliceObject {
	Index(i:Int);
	Object(data:Array<Null<Int>>);
	Ellipsis;
	None;
}

abstract Slice(String) from String
{
	public function resolveSlice(shape:Array<Int>, strides:Array<Int>):Int {
		var newShape = [], newStrides = [];
		
		var slices:Array<SliceObject> = parse();
		
		var numEllipsis = 0;
		var numConstraint = 0;
		for (i in 0...slices.length) switch(slices[i]) {
			case SliceObject.Ellipsis: numEllipsis++;
			case SliceObject.Index(_) | SliceObject.Object(_): numConstraint++;
			case SliceObject.None:
		}
		
		if (numEllipsis > 1) throw 'error: an index can have only a single ellipsis.';
		if (shape.length < numConstraint + numEllipsis) throw 'error: too many indices for array.';
		
		if (numEllipsis == 0 && shape.length > numConstraint) {
			slices.push(SliceObject.Ellipsis);
			numEllipsis++;
		}
		
		var lenEllipsis = shape.length - numConstraint;
		
		var offset = 0;
		var i = 0, j = 0;
		for(slice in slices) switch(slice) {
			case SliceObject.Index(idx):
			{
				if (idx < 0) idx += shape[j];
				offset += idx * strides[j];
				
				i++; j++;
			}
			case SliceObject.Object(data):
			{
				var begin = data[0];
				var end = data[1];
				var stride = data[2];
				
				if (begin < 0) begin += shape[j];
				if (end < 0) end += shape[j];
				
				if (stride == null) stride = 1;
				if (begin == null) begin = stride > 0? 0 : shape[j] - 1;
				if (end == null) end = stride > 0? shape[j] : -1;
				
				newShape.push(Std.int((end-begin+(stride>0?-1:1))/stride)+1);
				newStrides.push(strides[j] * stride);
				offset += begin * strides[j];
				
				i++; j++;
			}
			case SliceObject.Ellipsis:
			{
				for (k in j...j + lenEllipsis)
				{
					newShape.push(shape[k]);
					newStrides.push(strides[k]);
				}
				
				i += lenEllipsis;
				j += lenEllipsis;
			}
			case SliceObject.None:
			{
				newShape.push(1);
				newStrides.push(0);
				
				i++;
			}
		}
		shape.resize(newShape.length);
		for (i in 0...shape.length) shape[i] = newShape[i];
		
		strides.resize(newStrides.length);
		for (i in 0...newStrides.length) strides[i] = newStrides[i];
		
		return offset;
	}
	
	private function parse():Array<SliceObject> {
		var obj:Array<Array<String>> = this.split(',').map(str->str.split(':'));
		
		var result:Array<SliceObject> = [];
		for (i in 0...obj.length) {
			var slice:Array<String> = obj[i].map(str->StringTools.trim(str));
			switch(slice) {
				case ['']: throw 'error: invalid index syntax.';
				case ['None']:
				{
					result.push(SliceObject.None);
				}
				case ['...']:
				{
					result.push(SliceObject.Ellipsis);
				}
				case [idx]:
				{
					var index:Null<Int> = Std.parseInt(idx);
					result.push(SliceObject.Index(index));
				}
				case [b,e]:
				{
					var begin :Null<Int> = b==''? null : Std.parseInt(b);
					var end   :Null<Int> = e==''? null : Std.parseInt(e);
					result.push(SliceObject.Object([begin, end, null]));
				}
				case [b,e,s]:
				{
					var begin :Null<Int> = b==''? null : Std.parseInt(b);
					var end   :Null<Int> = e==''? null : Std.parseInt(e);
					var stride:Null<Int> = s==''? null : Std.parseInt(s);
					if (stride == 0) throw 'error: stride should not be zero.';
					result.push(SliceObject.Object([begin, end, stride]));
					
				}
				case _: throw 'error: invalid index syntax.';
			}
		}
		
		return result;
	}
}