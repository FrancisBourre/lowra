package com.bourre.load
{

	/*
	 * Copyright the original author or authors.
	 * 
	 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
	 * you may not use this file except in compliance with the License.
	 * You may obtain a copy of the License at
	 * 
	 *      http://www.mozilla.org/MPL/MPL-1.1.html
	 * 
	 * Unless required by applicable law or agreed to in writing, software
	 * distributed under the License is distributed on an "AS IS" BASIS,
	 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	 * See the License for the specific language governing permissions and
	 * limitations under the License.
	 */

	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */

	import com.bourre.collection.Queue;
	import flash.events.Event;
	import com.bourre.log.PixlibDebug;
	import flash.net.URLRequest;
	
	public class QueueLoader 
		extends AbstractLoader 
		implements LoaderListener
	{
		private var _q : Queue;
		
		public function QueueLoader()
		{
			_q = new Queue( Loader );
		}
		
		public function clear() : Void
		{
			_q.clear();
		}
		
		public function add( loader : Loader, name : String, url : URLRequest ) : Boolean
		{
			return _q.add( loader );
			
			if ( name ) 
			{
				loader.setName( name );
				
				if ( url )
				{
					loader.setURL( url );

				} else if ( loader.getURL().url )
				{
					PixlibDebug.WARN( this + ".add failed, you passed Loader argument without any url property." );
				}

			} else if( !(o.getName()) )
			{
				PixlibDebug.WARN( "You passed Loader argument without any name property in " + this + ".enqueue()." );
			}
			
			if (o.getName() == undefined) o.setName( 'library' + HashCodeFactory.getKey( o ));
			
			_a.enqueue(o);
			return o.getName();
		}
		
		public function onLoadStart( e : LoaderEvent ) : void
		{
			
		}
		
		public override function onLoadInit( e : LoaderEvent ) : void
		{
			
		}
		
		public function onLoadProgress( e : LoaderEvent ) : void
		{
			
		}
		
		public function onLoadTimeOut( e : LoaderEvent ) : void
		{
			
		}
		
		public function onLoadError( e : LoaderEvent ) : void
		{
			
		}
		
		protected override function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new QueueLoaderEvent( type, this );
		}
		
		public override function load( url : String = null ) : void
		{
			release();

			super.load( url );
		}
		
		public override function release() : void
		{
			//

			super.release();
		}
		
		//
		public override function execute( e : Event = null ) : void
		{
			var a : Array = _q.toArray();
			var l : Number = a.length;
			
			while( --l > -1 )
			{
				var loader: Loader = a[l];
				if ( !( loader.getURL() ) )
				{
					PixlibDebug.ERROR( this + " encounters Loader instance without url property, load fails." );
					return;
				}
			}
			
			_onLoadStart();
			
			super.execute( e );
		}

		public function isEmpty() : Boolean
		{
			return _q.isEmpty();
		}

		public function toArray() : Array
		{
			return _q.toArray();
		}
		
		public function size() : uint
		{
			return _q.size();
		}
		
	}
}