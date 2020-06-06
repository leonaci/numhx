package numhx.buffer;
import numhx.NdArrayDataType;

/**
 * @author leonaci
 */
interface NdArrayBuffer 
{
	var offset(default, null):Int;
	var length(default, null):Int;
	var itemsize(default, null):Int;
	var dtype(default, null):NdArrayDataType;
	var dirty:Bool;
	
	function allocate(length:Int, dtype:NdArrayDataType):Void;
	function get(pos:Int):Dynamic;
	function set(pos:Int, v:Dynamic):Dynamic;
	function getValue():Array<Dynamic>;
	function setValue(v:Array<Dynamic>):Void;
	function fill(?begin:Array<Int>, ?end:Array<Int>, ?step:Array<Int>, v:Dynamic):Void;
	function subarray( ?begin : Int, ?end : Int ) : NdArrayBuffer;
}