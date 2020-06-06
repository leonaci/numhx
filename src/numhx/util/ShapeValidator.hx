package numhx.util;

/**
 * ...
 * @author leonaci
 */
class ShapeValidator
{
	static public function validateShape(value:Dynamic):Array<Int> {
		var shape = [];
		validateShape_(0, value, shape);
		return shape;
	}
	
	static public function validateShape_(depth:Int, value:Dynamic, shape:Array<Int>):Int {
		if (!Std.is(value, Array)) return 0;
		
		if(depth == shape.length) shape.push(value.length);
		if (value.length == 0) return value.length;
		
		var sizes:Array<Int> = [for (j in 0...value.length) validateShape_(depth+1, value[j], shape)];
		var size = sizes[0];
		
		for (result in sizes) {
			if (result != size) {
				shape.pop();
				return value.length;
			}
		}
		
		return value.length;
	}
	
	static public function validateBinOpShape(lhs:NdArray, rhs:NdArray):Array<Int> {
		if (lhs.ndim != rhs.ndim) throw 'error: not allowed to add arrays that have different dimensions.';
		for (i in 0...lhs.ndim) if (lhs.shape[i] != rhs.shape[i]) throw 'error: not allowed to add arrays that have different shapes.';
		
		var shape = lhs.shape.copy();
		
		return shape;
	}
	
	static public function validateDotShape(lhs:NdArray, rhs:NdArray):Array<Int> {
		if(lhs.shape[lhs.ndim-1] != rhs.shape[0]) throw 'error: not allowed to contract arrays that have different size.';

		var shape = [];
		for (i in 0...lhs.ndim - 1) shape.push(lhs.shape[i]); 
		for (i in 1...rhs.ndim    ) shape.push(rhs.shape[i]); 
		
		return shape;
	}
}