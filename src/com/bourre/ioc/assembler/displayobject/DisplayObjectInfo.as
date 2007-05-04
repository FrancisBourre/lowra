package com.bourre.ioc.assembler.displayobject
{
	import com.bourre.log.PixlibStringifier ;
	
	public class DisplayObjectInfo
	{
		public var ID 		: String ;
		public var parentID : String ;
		public var depth 	: Number ;
		public var isVisible: Boolean ;
		public var type		: String ;
		private var _sURL	: String ;
		private var _aChilds: Array ;
		
		public function DisplayObjectInfo (ID:String, parentID:String, depth:Number, isVisible:Boolean, url:String=null, type:String="Movieclip")
		{
			this.ID 		= ID ;
			this.parentID 	= parentID ;
			this.depth 		= depth ;
			this.isVisible 	= isVisible ;
			this.type 		= type ;
			_sURL 			= url ;
			_aChilds 		= new Array () ;
		}
		
		public function addChild(o:DisplayObjectInfo):void
		{
			_aChilds.push(o) ;
		}
		
		public function getChild():Array
		{
			return _aChilds.concat() ;
		}
		
		public function hasChild():Boolean
		{
			return (_aChilds.length>0)  ;
		}
		
		public function isEmptyDisplayObject():Boolean
		{
			return (_sURL == null) ;
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
