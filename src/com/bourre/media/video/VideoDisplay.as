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
	 
package com.bourre.media.video 
{
	import com.bourre.commands.Delegate;
	import com.bourre.commands.Suspendable;
	import com.bourre.error.IllegalArgumentException;
	import com.bourre.load.AbstractLoader;
	import com.bourre.load.LoaderEvent;
	import com.bourre.log.PixlibDebug;
	import com.bourre.media.SoundTransformInfo;
	import com.bourre.media.video.CuePointEvent;
	import com.bourre.media.video.VideoDisplayEvent;
	import com.bourre.structures.Dimension;
	import com.bourre.transitions.MSBeacon;
	import com.bourre.transitions.TickBeacon;
	import com.bourre.transitions.TickListener;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;	

	/**
	 * The VideoDisplay class.
	 * 
	 * <p>TODO Documentation.</p>
	 * 
	 * @author 	Aigret Axel
	 * @author 	Barbero Michael
	 */
	public class      VideoDisplay 
	 	   extends    AbstractLoader 
	 	   implements Suspendable , TickListener
	{
		
		/** manage the time to fire <code>VideoDisplayEvent.onPlayHeadTimeChangeEVENT</code> */
		protected static var TICKBEACON : TickBeacon ;

		public static function setTickBeacon( beacon : TickBeacon ) : void
		{
			TICKBEACON = beacon ; 
		}
		
		public function onTick( e : Event = null )  : void
		{
			onPlayHeadTimeChanged( );
		}
		
		/* use it to learn to manipulate VideoDisplay */
		public    var DEBUG 					: Boolean   =  false ;
		
		protected var _video 					: Video ;
		protected var _connection 				: NetConnection ;
		protected var _stream 					: NetStream ;
		
		protected var _bIsPlaying 				: Boolean ;
		protected var _bIsLoaded 				: Boolean ;
		
		protected var _nBufferTime				: Number = 5 ;
		protected var _bAutoPlay 				: Boolean ;
		protected var _bAutoSize 				: Boolean ;
		protected var _bLoopPlayback 			: Boolean ;
		
		protected var _oMetaData 				: MetaData ; 
		protected var _oSTI 					: SoundTransformInfo ;
		// If a load problem with net stream 
		protected var _bLoadProblem  			: Boolean ; 
		
		protected var _bStreamStarted 			: Boolean = false;

		
		/**
		 * Specifies whether the video should be smoothed (interpolated) when 
		 * it is scaled.
		 * 
		 * @default true
		 */
		public function get smoothing( ) : Boolean
		{
			return _video.smoothing;
		}
		/** @private */
		public function set smoothing( b : Boolean ) : void
		{
			_video.smoothing = b;
		}
		
		public function VideoDisplay( name       : String  = null ,
									  video      : Video   = null ,
									  autoPlay   : Boolean = true ,
									  autoSize   : Boolean = true ,
									  bufferTime : Number  = 2    ,
									  soundTransform : SoundTransformInfo = null )
		{
			super( null );

			_video = video ? video : new Video() ;

			if( name ) setName( name ) ;
			setAutoPlay( autoPlay );
			setAutoSize( autoSize );
			setBufferTime( bufferTime );
			setSoundTransform( soundTransform ?  soundTransform : SoundTransformInfo.NORMAL );
			_bLoopPlayback = false;

			init();
		}
		
		protected function init() : void
		{
			setPlaying( false );
			_bIsLoaded = false;
			initTickBeacon();
		}
		
		
		protected function initTickBeacon() : void
		{
			if( !TICKBEACON )
			{
				var t : MSBeacon = new MSBeacon();
				t.setTickPerSecond( 3 );
				TICKBEACON = t ;
			}
		}

		protected function onPlayHeadTimeChanged( ) : void
		{
			// will be fire only if lastTimeStamp is in Metadata
			if( getMetaData() && getMetaData().getLastTimeStamp() == getPlayheadTime() )
			{
				fireEventType( VideoDisplayEvent.onEndVideoEVENT );
				setPlaying( false );
			}
			
			if( !isLoaded() && !_bLoadProblem )
				fireOnLoadProgressEvent() ;
			
			fireEventType( VideoDisplayEvent.onPlayHeadTimeChangeEVENT );
		}
		
		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG( this + ".load" );
			fireOnLoadStartEvent();
			
			setURL( url );
		}
		
		override protected function onInitialize() : void
		{
			if ( getName() != null ) 
			{
				if ( !(VideoDisplayLocator.getInstance().isRegistered(getName())) )
					VideoDisplayLocator.getInstance().register( getName(), this );
				else
				{
					var msg : String = this + " can't be registered to " + VideoDisplayLocator.getInstance() 
										+ " with '" + getName() + "' name. This name already exists.";
					PixlibDebug.ERROR( msg );
					fireOnLoadErrorEvent( msg );
					throw new IllegalArgumentException( msg );
				}
			}
			super.onInitialize();
		}
		
		protected function _load() : void
		{
			
			if ( !getURL() )
			{
				PixlibDebug.ERROR( this + " can't play without any valid url property, loading fails." );
			} 
			else
			{
				_bLoadProblem = false;
				_connection = new NetConnection();
				_connection.connect( null );
				
				_stream = new NetStream( _connection );
				setContent( _stream );
				
				_stream.bufferTime =  _nBufferTime ;
				_stream.addEventListener(NetStatusEvent.NET_STATUS,  _onNetStatus );
				_stream.client = { onMetaData : Delegate.create( _onMetaData ),
								   onCuePoint : Delegate.create( _onCuePoint ) };
	
				_oMetaData = null ;
		
				_video.attachNetStream( _stream );	
				//_mcHolder.attachAudio( _stream );
				
				_stream.play( getURL().url );
				_oSTI.addStream( _stream )  ;
				
				if ( !isAutoPlay() ) _stream.pause( );
			
				_bIsLoaded = true;
		
				super.load();
			}
		}
		
		public function closeStream() : void {
			
			if(_video) _video.clear();
				
			if( _stream )
			{
				if( _bStreamStarted ) 
				{
					_bStreamStarted = false;
					_removeStream(_stream, null);
				} else {
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
					_stream.addEventListener(NetStatusEvent.NET_STATUS, _onCloseStream(_stream));
				}
			} else {
				if( DEBUG ) PixlibDebug.ERROR(this + " stream not found");
			}
		}
		
		protected function _onMetaData ( metadata : Object ) : void
		{
			if( DEBUG )  PixlibDebug.DEBUG( this + "._onMetaData" );
			_oMetaData = new MetaDataInfo( metadata );
		
			if ( isAutoSize() ) setSize( _oMetaData.getSize() );
			
			fireEventType( VideoDisplayEvent.onMetaDataEVENT );
		}
		
		protected function _onCuePoint ( data : Object ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG( this + "._onCuePoint" );
			var e : CuePointEvent = new CuePointEvent( VideoDisplayEvent.onCuePointEVENT, this, data );
			fireEvent( e );
		}
		
				
		protected function _removeStream(stream:NetStream, e : NetStatusEvent):void
		{
			stream.removeEventListener(NetStatusEvent.NET_STATUS, _onCloseStream(_stream));
			stream.close();
			stream = null;
		}
		
		private function _onCloseStream(stream:NetStream) : Function {
			return function( e:NetStatusEvent ):void {
				_removeStream(stream, e);
			};
		}
		
		protected function _onNetStatus ( e : NetStatusEvent ) : void
		{
			if( DEBUG )  PixlibDebug.DEBUG( this + " _onNetStatus" + e.info.code);
			switch ( e.info.code ) 
			{
				case 'NetStream.Play.Start' :
					PixlibDebug.DEBUG( this + " stream starts playing." );
					if ( !_bIsPlaying   ) setPlaying( true );
					if ( !getMetaData() ) fireOnLoadInitEvent() ;
				
					fireEventType( VideoDisplayEvent.onStartStreamEVENT);
					break;
						
				case 'NetStream.Play.Stop' :
					PixlibDebug.DEBUG( this + " stream stops playing." );
					fireEventType( VideoDisplayEvent.onStopStreamEVENT );
					break;
				
				case 'NetStream.Play.Failed' :	
					var msg :String = this + " An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber not having read access. "; 	
					PixlibDebug.ERROR(msg  );
					fireOnLoadErrorEvent( msg ) ;
					_bLoadProblem = true;
					break;
					
				case 'NetStream.Play.StreamNotFound' :
					PixlibDebug.ERROR( this + " can't find FLV url passed to the play() method : '" + getURL().url + "'" );
					fireOnLoadTimeOut();
					_bLoadProblem = true;
					break;
						
				case 'NetStream.Seek.InvalidTime' :
					PixlibDebug.WARN( this + " seeks invalid time in '" + getURL().url + "'." );
					break;
					
				case 'NetStream.Buffer.Full' :
					PixlibDebug.DEBUG( this + " stream buffer is full." );
					fireEventType( VideoDisplayEvent.onBufferFullEVENT );
					break;
					
				case 'NetStream.Buffer.Empty' :
					PixlibDebug.DEBUG( this + " stream buffer is empty." );
					fireEventType( VideoDisplayEvent.onBufferEmptyEVENT );
					break;
			}
		}
		
		// view
		public function setSize( o : Dimension ) : void
		{
			_video.width  = o.width ;
			_video.height = o.height ;
			
			fireEventType( VideoDisplayEvent.onResizeEVENT );
		}
		
		public function getWidth() : Number
		{
			return _video.width;
		}
		
		public function getHeight() : Number
		{
			return _video.height;
		}
		
		public function getDimension() : Dimension
		{
			return new Dimension( _video.width , _video.height ) ;
		}
		
		public function getVideo() : Video
		{
			return _video;
		}
		
		public function setVideo( v : Video ) : void
		{
			if(_video) 
			{
				_video.attachNetStream( null );
				_video = null;
			}
			_video = v;
			_video.attachNetStream( _stream );
		}
		
		//Php streaming
		public function getKeyFramePosition() : String
		{
			return _seekKeyFramePosition( getPlayheadTime() );
		}
		
		private function _seekKeyFramePosition( n : Number ) : String
		{
			var aKFilePositions : Array = getMetaData().getKeyFilePositions() ;
			var aKTimes : Array  = getMetaData().getKeyTimes() ;
			var l : Number = aKTimes.length;
			while( --l > -1 ) if ( n > aKTimes[ l ] ) return aKFilePositions[ l ];
			return aKTimes[ 0 ];
		}
		
		public function streamFromPHP( n : Number ) : void
		{
			if ( !_bIsLoaded ) 
			{
				load( getURL() );
			} else
			{
				if ( isPlaying() ) _stream.pause( );
				var kfp : String = _seekKeyFramePosition( n );
				_stream.play( this.getURL() + "&position=" + kfp );
				PixlibDebug.DEBUG( this + ".streamFromPHP(" + this.getURL() + "&position=" + kfp + ")" );
				setPlaying( true );
			}
		}
		
		// common use
		public function playVideo( nTimeAbsolute : Number = -1 , nTimeRelative : Number = Number.NaN ) : void
		{
			if( DEBUG ) PixlibDebug.DEBUG( this + ".playVideo" );
			if ( !_bIsLoaded ) _load();
			if ( nTimeAbsolute != -1 && !isNaN( nTimeRelative ))
			{
				PixlibDebug.ERROR( this+".playVideo can seek in absolute and relative way in same time choose one") ;
				return ;
			}
			if ( nTimeAbsolute != -1 && isValidTime(nTimeAbsolute)  ) _stream.seek(  nTimeAbsolute );
			if ( !isNaN( nTimeRelative ) )
			{
				var newTime : Number =  getPlayheadTime() + nTimeRelative ;
				if( isValidTime( newTime ) )  _stream.seek( newTime ) ;
			}
			_stream.resume() ;
			setPlaying( true );
		}
		
		protected function isValidTime( nTimeInSec : Number) : Boolean
		{
			if( !getDuration() || nTimeInSec >= 0 &&  nTimeInSec <= getDuration() )
				return true;
			
			PixlibDebug.WARN( this + ".isValidTime "+nTimeInSec+" is not between 0 and " + getDuration()  );
			return false;
		}
		
		public function pauseVideo() : void
		{
			if( !_bIsLoaded ) return ;
			if( DEBUG ) PixlibDebug.DEBUG( this + ".pauseVideo" );
			_stream.pause() ;
			setPlaying(false);
		}
		
		public function resumeVideo() : void
		{
			if( !_bIsLoaded ) return ;
			if( DEBUG ) PixlibDebug.DEBUG( this + ".resumeVideo" );
			playVideo();
		}
	
		public function stopVideo() : void
		{
			if( DEBUG ) PixlibDebug.DEBUG( this + ".stopVideo" );
			if( !_bIsLoaded ) return ;
			pauseVideo();
			_stream.seek(0);
		}
		
		override public function release() : void
		{
			TICKBEACON.removeTickListener( this ) ;
			_stream.close();
			_connection.close();
			_video.clear();
			
			if ( VideoDisplayLocator.getInstance().isRegistered(getName()) ) 
				VideoDisplayLocator.getInstance().unregister( getName() );
			
			super.release();
		}
		
		//loop playback
		// TODO: to define when we loop at end or for the moment in stop stream ( pixlib )
		public function setLoopPlayback( b : Boolean, position : Number = 0) : void
		{
			if ( _bLoopPlayback != b )
			{
				_bLoopPlayback = b;
				
				if ( _bLoopPlayback )
				{
					addEventListener( VideoDisplayEvent.onStopStreamEVENT, _onLoop, position);
				} else
				{
					removeEventListener( VideoDisplayEvent.onStopStreamEVENT, _onLoop);
				}
			}
		}
		
		protected function _onLoop( e : VideoDisplayEvent, position : Number ) : void
		{
			playVideo( position );
		}
		
		public function isLoopPlayback() : Boolean
		{
			return _bLoopPlayback;
		}
		
		//useful 
		
		public function getMetaData() : MetaData
		{
			return _oMetaData;
		}
		
		public function getDuration() : Number
		{
			return _oMetaData ? _oMetaData.getDuration() : 0 ;
		}
	
		public function getPlayheadTime() : Number
		{
			return _stream ? _stream.time : 0 ;
		}
		
		/*public function setPlayheadTime( n : Number ) : void
		{
			_stream.seek(n);
			
			if ( !_bIsPlaying )
			{
				_stream.resume();
				CommandManagerMS.getInstance().delay( new Delegate( _onFrameUpdate) , 50);
			}
		}
		
		protected function _onFrameUpdate() : void
		{
			_stream.pause() ;
			fireEventType( VideoDisplayEvent.onPlayHeadTimeChangeEVENT );
		}*/
		
		public function isPlaying() : Boolean
		{
			return _bIsPlaying;
		}
	
		protected function setPlaying( b : Boolean ) : void
		{
			if ( b != _bIsPlaying )
			{
				_bIsPlaying = b;
				if ( _bIsPlaying )	TICKBEACON.addTickListener( this ) ;
				else				TICKBEACON.removeTickListener( this ) ;
			}
		}
		
		// sound
		public function setSoundTransform( o : SoundTransformInfo ) : void
		{
			_oSTI = o ;
			if( _stream ) _stream.soundTransform = _oSTI.getSoundTransform() ;
		}
		
		public function getSoundTransform( ) : SoundTransformInfo
		{
			return _oSTI ;
		}

		public function getVolume() : Number
		{
			return _stream ? _oSTI.getVolume() : 0 ;
		}
	
		public function setVolume( n : Number ) : void
		{
			_oSTI.setVolume( n ) ;
		}

		// AbstractLoader
		override public function setURL( url : URLRequest ) : void
		{
			if ( url.url ) 
			{
				// close previous stream
				if(_stream) closeStream();
				
				super.setURL( url );
				
				_bIsLoaded = false;
			
				if (isPlaying())
					playVideo(0);
				else
					_load();
			} else
			{
				PixlibDebug.WARN( this + " got invalid url property, can't load." );
			}
		}
		
		override public function getBytesLoaded() : uint
		{
			return _stream ? _stream.bytesLoaded : 0 ;
		}
	
		override public function getBytesTotal() : uint
		{
			return _stream ? _stream.bytesTotal : 0 ;
		}
		
		public function isAutoPlay() : Boolean
		{
			return _bAutoPlay;
		}
		
		public function setAutoPlay( b : Boolean ) : void
		{
			_bAutoPlay = b;
		}
		
		public function isAutoSize() : Boolean
		{
			return _bAutoSize;
		}
		
		public function setAutoSize( b : Boolean ) : void
		{
			_bAutoSize = b;
		}
		
		public function setBufferTime(n:Number) : void
		{
			_nBufferTime = n;
		}
		
		override protected function getLoaderEvent( type : String, errorMessage : String = "" ) : LoaderEvent
		{
			return new VideoDisplayEvent( type, this, errorMessage );
		}	
		
		/**
		 * Implements Suspendable 
		 * stop is not stopVideo but pauseVideo
		 */
		
		// resume
		public function start() : void
		{
			playVideo();
		}
		
		// pause
		public function stop() : void
		{
			pauseVideo() ;
		}
		
		// stop
		public function reset() : void
		{
			stopVideo();
		}	
	
	}
}
