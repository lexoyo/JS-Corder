import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.events.NetStatusEvent;
import flash.media.Camera;

enum Mode
{
	play;
	rec;
	none;
}

class JSCorder
{
	public var fileName:String;
	public var serverURL:String;
	public var applicationName:String;
	public var instanceName:String;
	private var _nc:NetConnection;
	private var _ns:NetStream;
	private var _mode:Mode;
	private var _video:Video;
	private var _eventsManager:EventsManager;
	private var _isReady(getIsReady,null):Bool;
	public var onEvent:Dynamic->Void;

	public function new() 
	{
		_mode = Mode.none;
		_eventsManager = new EventsManager(this);
		_eventsManager.onEvent = _onEvent;
	}
	private function getIsReady():Bool
	{
		return _nc != null && _nc.connected == true && _ns != null;
	}
	public function _onEvent(event:Dynamic):Void
	{
		if (onEvent != null)
			onEvent(event);
	}
	public function connect()
	{
		if (_nc == null)
		{
			_nc = new NetConnection(); 
			_nc.objectEncoding = flash.net.ObjectEncoding.AMF0; 
			_nc.client = _eventsManager;
			_nc.addEventListener(NetStatusEvent.NET_STATUS, _eventsManager.netConnectionHandler);
		}
		//_nc.connect( 'rtmp://localhost/flvplayback' );//live flvplayback
		//_nc.connect( 'rtmp://192.168.1.12/live/test/' );//live flvplayback
		
		var url:String = serverURL;
		if (applicationName != null && applicationName != "") url += applicationName + "/";
		if (instanceName != null && instanceName != "") url += instanceName + "/";
		_nc.connect( url );//live flvplayback
		_eventsManager.onConnect = openStream;
	}
	public function openStream()
	{
		_ns = new NetStream(_nc);
		_ns.addEventListener(NetStatusEvent.NET_STATUS, _eventsManager.netConnectionHandler);
		initVideo();
	}
	public function closeStream()
	{
		_ns.attachCamera(null);
		_ns.close();
		_ns.removeEventListener(NetStatusEvent.NET_STATUS, _eventsManager.netConnectionHandler);
		_ns = null;
		if (_video != null)
		{
			_video.attachCamera(null);
			_video.attachNetStream(null);
			_video.clear();
		}
	}
	public function initVideo()
	{
		if (_video != null)
			return;
		_video = new Video();
		flash.Lib.current.addChild(_video);
		_video.width = flash.Lib.current.stageWidth;
		_video.height = flash.Lib.current.stageHeight;
	}
	public function play():Void
	{
		if (_mode == Mode.rec)
			closeStream();
			
		if (_nc == null || _nc.connected == false)
		{
			connect();
			_eventsManager.onConnect = play;
			return;
		}
		if (_ns == null) 
			openStream();
		
		_video.attachNetStream(_ns);

		trace("play "+fileName);
		_ns.play(fileName);
	}
	public function pause():Void
	{
		if(!_isReady)
		{
			trace("not ready");
			return;
		}
		_ns.pause();
	}
	public function togglePause():Void
	{
		if(!_isReady)
		{
			trace("not ready");
			return;
		}
		_ns.togglePause();
	}
	public function resume():Void
	{
		if(!_isReady)
		{
			trace("not ready");
			return;
		}
		_ns.resume();
	}
	public function stop():Void
	{
		if(!_isReady)
		{
			trace("not ready");
			return;
		}
		//_ns.pause();
		//_ns.seek(0);
		closeStream();
	}
	public function record():Void
	{
		if (_mode == Mode.play)
			closeStream();
			
		if (_nc == null || _nc.connected == false)
		{
			connect();
			_eventsManager.onConnect = record;
			return;
		}
		if (_ns == null) 
			openStream();
		
		var cam:Camera = Camera.getCamera();
		cam.setMode(320, 240, 25); 
		cam.setQuality(0,100);

		_video.width       = cam.width;
		_video.height      = cam.height; 
		_video.attachCamera(cam);
		_ns.attachCamera(cam);
		
		_ns.publish(fileName, "record");//"record", "append", and "live"
	}
	public function live():Void
	{
		if (_mode == Mode.play)
			closeStream();
			
		if (_nc == null || _nc.connected == false)
		{
			connect();
			_eventsManager.onConnect = record;
			return;
		}
		if (_ns == null) 
			openStream();
		
		var cam:Camera = Camera.getCamera();
		_video.attachCamera(cam);
		_ns.attachCamera(cam);
		
		_ns.publish(fileName, "live");//"record", "append", and "live"
	}
	public function append():Void
	{
		if (_mode == Mode.play)
			closeStream();
			
		if (_nc == null || _nc.connected == false)
		{
			connect();
			_eventsManager.onConnect = record;
			return;
		}
		if (_ns == null) 
			openStream();
		
		var cam:Camera = Camera.getCamera();
		_video.attachCamera(cam);
		_ns.attachCamera(cam);
		
		_ns.publish(fileName, "append");//"record", "append", and "live"
	}
	public function seek(offset : Float):Void
	{
		if(!_isReady)
		{
			trace("not ready");
			return;
		}
		_ns.seek(offset / 1000);
		_ns.resume();
	}
	public function getTime():Float
	{
		if(!_isReady)
		{
			trace("not ready");
			return 0;
		}
		return _ns.time * 1000;
	}
}