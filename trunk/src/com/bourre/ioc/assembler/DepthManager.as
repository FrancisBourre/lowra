package com.bourre.ioc.assembler
{
	import com.bourre.collection.HashMap;
	import com.bourre.log.PixlibStringifier ;
	import com.bourre.log.PixlibDebug ;
	
	public class DepthManager
	{
		private static var _oI : DepthManager;
	
		private var _mDepthID:HashMap;
		private var _mDepthMap:HashMap;
		
		public static function getInstance() : DepthManager
		{
			if ( !(DepthManager._oI is DepthManager) ) DepthManager._oI = new DepthManager( new PrivateConstructorAccess() );
			return DepthManager._oI;
		}
		
		public function DepthManager(access:PrivateConstructorAccess)
		{
			_mDepthID = new HashMap();
			_mDepthMap = new HashMap();
		}
		
		public function clear ():void
		{
			_mDepthID = new HashMap();
			_mDepthMap = new HashMap();
		}
		
		private function _getDepthMap( parentID : String ) : Object
		{
			if ( !(_mDepthMap.containsKey( parentID )) ) _mDepthMap.put( parentID, {} );
			return _mDepthMap.get( parentID );
		}
		
		public function isReservedDepth( parentID : String, depth : Number ) : Boolean
		{
			var o : Object = _getDepthMap( parentID );
			return ( o[ depth ] != null );
		}
		
		public function reserveDepth( mcID : String, parentID : String, depth : Number ) : Number
		{
			if ( !(isReservedDepth( parentID, depth )) )
			{
				var o : Object = _getDepthMap( parentID );
				o[ depth ] = depth;
				return depth;
				
			} else
			{
				var d : Number = getNextHighestDepth( parentID );
				PixlibDebug.WARN( this + ".reserveDepth() failed on '" + parentID + "." + mcID + "' target with '" + depth + "' depth value." );
				PixlibDebug.WARN( this + " assigns depth value: " + d + " to '" + parentID + "." + mcID + "' target." );
				return d;
			}
		}
		
		public function getNextHighestDepth( parentID : String ) : Number
		{
			var d : Number = -1;
			var o : Object = _getDepthMap( parentID );
			
			for ( var p : String in o )
			{
				var n : Number = o[p];
				if ( n > d ) d = n;
			}
			
			d++;
			o[ d ] = d;
			return d;
		}
		
		public function suscribeDepth( mcID : String, parentID : String, depth : Number ) : *
		{
			if ( isNaN( depth ) )
			{
				depth = getNextHighestDepth( parentID );	
			} else
			{
				depth = reserveDepth( mcID, parentID, depth );
			}
			
			return _mDepthID.put( mcID, depth );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
	
}

internal class PrivateConstructorAccess {}