package com.bourre.media.sound
{
	import flash.media.SoundTransform;
	
	import com.bourre.collection.HashMap;
	import com.bourre.error.NoSuchElementException;
	
	import com.bourre.log.PixlibDebug;	
		
	public class MixSoundFactory extends SoundFactory
	{
		private var _nVolume	: Number;
		
		public function MixSoundFactory()
		{
		}
		
		/**
		 * Master Volume 
		 */
		public function getVolume() : Number
		{		
			return _nVolume;
		}
		public function setVolume(n : Number ) : void
		{		
			if( n < 0 )
			{
				n = 0;
			}
			else if( n > 1 )
			{
				n = 1;
			}
			_nVolume = n;
			var a : Array = _mSoundTransform.getKeys();
			var i : Number = a.length;
			while( --i > -1 )
			{
				_adjustVolume( a[i] );
			}								
		}
		
		
		/**
		 * Gain : volume of each sound
		 */ 		
		public function getGain( id : String ) : Number
		{
			if( _mSoundTransform.containsKey( id ) )
			{
				return _mSoundTransform.get( id ).getGain();
			}
			else
			{
				PixlibDebug.ERROR("MixSoundFactory.getGain("+id+") : this id doesn't exist");					
				throw new NoSuchElementException("MixSoundFactory.getGain("+id+") : this id doesn't exist") ;				
			}
		}
		
		public function setGain( id : String, n : Number ) : void
		{
			if( _mSoundTransform.containsKey( id ) )
			{
				if( n < 0 )
				{
					n = 0;
				}
				else if( n > 1 )
				{
					n = 1;
				}
				_mSoundTransform.get( id ).setGain( n );
				_adjustVolume( id );
			}
			else
			{
				PixlibDebug.ERROR("MixSoundFactory.setGain("+id+", "+n+") : this id doesn't exist");					
				throw new NoSuchElementException("MixSoundFactory.setGain("+id+", "+n+") : this id doesn't exist") ;					
			}			
		}
		
		public function setAllGain( n : Number ) : void
		{
			if( n < 0 )
			{
				n = 0;
			}
			else if( n > 1 )
			{
				n = 1;
			}
			var a : Array = _mSoundTransform.getKeys();		
			var i : uint = a.length;
			while( --i > -1 )
			{
				_mSoundTransform.get( a[i] ).setGain( n );
				_adjustVolume( a[i] );
			}	
		}
		
		
		
		public function getPan( id : String ) : Number
		{		
			if( _mSoundTransform.containsKey( id ) )
			{
				return _mSoundTransform.get( id ).getPan();
			}		
			else
			{
				PixlibDebug.ERROR("MixSoundFactory.getPan("+id+") : this id doesn't exist");					
				throw new NoSuchElementException("MixSoundFactory.getPan("+id+") : this id doesn't exist") ;					
			}			
		}
		
		public function setPan( id : String, n : Number ) : void
		{		
			if( _mSoundTransform.containsKey( id ) )
			{
				if( n < -1 )
				{
					n = -1;
				}
				else if( n > 1 )
				{
					n =	 1;
				}
				_mSoundTransform.get( id ).setPan( n );
			}		
			else
			{
				PixlibDebug.ERROR("MixSoundFactory.getPan("+id+") : this id doesn't exist");					
				throw new NoSuchElementException("MixSoundFactory.getPan("+id+") : this id doesn't exist") ;					
			}			
		}
		public function setAllPan( n : Number ) : void
		{		
			if( n < -1 )
			{
				n = -1;
			}
			else if( n > 1 )
			{
				n =	 1;
			}
			
			var a : Array = _mSoundTransform.getKeys();		
			var i : uint = a.length;
			while( --i > -1 )
			{
				_mSoundTransform.get( a[i] ).setPan( n );
			}	
		}
		
		
		private function _adjustVolume( id : String ) : void
		{
			var v:Number = _calculVolume( getGain( id ) );
			_mSoundTransform.get( id ).setVolume( v );
		}
		
		private function _calculVolume( nGain : Number ): Number
		{
			return (nGain*100 / 100) * _nVolume;
		}		

		
						
	}
}