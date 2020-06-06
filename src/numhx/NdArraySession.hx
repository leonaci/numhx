package numhx;
import numhx.NdArray;
import numhx.backend.BackendKind;
import numhx.backend.cpu.CpuBackend;
import numhx.buffer.NdArrayBufferManager;

/**
 * ...
 * @author leonaci
 */
class NdArraySession
{
	@:allow(numhx.NdArray) static private var manager(get, null):NdArrayBufferManager;
	static function get_manager():NdArrayBufferManager {
		if (manager == null) throw 'error: no backend is set up yet.';
		return manager;
	}
	
	static public function setBackend(backendKind:BackendKind) 
	{
		var backend = switch(backendKind) {
			case BackendKind.Cpu: new CpuBackend();
		}
		
		manager = new NdArrayBufferManager(backend);
	}
}