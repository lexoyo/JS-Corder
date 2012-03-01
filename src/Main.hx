class Main 
{
	private var _externalInterfaceManager:ExternalInterfaceManager;
	private var _jsCorder:JSCorder;
	
	public static function main()
	{
		new Main();
	}
	
	public function new() 
	{
		_jsCorder = new JSCorder();
		_externalInterfaceManager = new ExternalInterfaceManager(_jsCorder);
		_jsCorder.onEvent = _externalInterfaceManager.sendEventToJS;
	}
	
}