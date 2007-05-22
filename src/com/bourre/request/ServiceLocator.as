
import com.bourre.request.DataService;
import com.bourre.collection.HashMap;
import com.bourre.core.Locator;

class ServiceLocator implements Locator
{
	protected static var _I : HashMap = new ServiceLocator();
	protected var _owner : IPlugin;
	protected var _m : HashMap;
	
	public function ServiceLocator()
	{
		_m = new HashMap() ;
	}
	 
	public static function getInstance(): ServiceLocator
	{
		return _I
	}
	
	public function getService( serviceKey : DataService )
	{
			return locate( key ) as ServiceLocator;
	}
	
	
	public function isRegistered( key : String ) : Boolean 
	{
		return _m.containsKey( key );
	}
	
	public function locate( key : String ) : Object
	{
		if ( !(isRegistered( key )) ) getLogger().error( "Can't locate model instance with '" + key + "' name in " + this );
		return _m.get( key );
	}
		
		
	public function registerService( serviceKey ) : Boolean
	{
		if ( isRegistered( key ) )
		{
			getLogger().fatal( "model instance is already registered with '" + key + "' name in " + this );
			return false;
		}
		else
		{
			_m.put( key, o );
			return true;
		}
	}
	
	public function unregisterService( key : String ) : void
	{
		_m.remove( key );
	}
		
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this ) + (_owner?", owner: "+_owner:"No owner.");
	}
	


}