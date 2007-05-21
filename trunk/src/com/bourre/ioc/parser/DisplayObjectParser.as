package com.bourre.ioc.parser
{
	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.ioc.assembler.DepthManager;
	import com.bourre.plugin.PluginDebug;
	import com.bourre.ioc.error.NullIDException;
	import com.bourre.ioc.core.IDExpert;

	public class DisplayObjectParser
		extends AbstractParser
	{
		public function DisplayObjectParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}

		public override function parse( xml : * ) : void
		{
			for each ( var node : XML in xml.* ) _parseNode( node );
		}
		
		private function _parseNode( xml : XML, parentID : String = null ) : void
		{
			var msg : String;
			
			// Debug missing ids.
			var id : String = ContextAttributeList.getID( xml );
			if ( id == null )
			{
				msg = this + " encounters parsing error with '" + xml.name() + "' node. You must set an id attribute.";
				PluginDebug.getInstance().fatal( msg );
				throw( new NullIDException( msg ) );
			}

			IDExpert.getInstance().register( id );
			
			// Filter reserved nodes (ex: attribute)
			//if ( ContextNodeNameList.getInstance().nodeNameIsReserved( nodeName ) ) return;


			if ( parentID )
			{
				var url : String = ContextAttributeList.getURL( xml );
				var sDepth : String = ContextAttributeList.getDepth( xml );
				var visible : String = ContextAttributeList.getVisible( xml );
				var isVisible : Boolean = visible ? (visible == "true") : true;
				var type : String = ContextAttributeList.getType( xml );
				
				// Evaluate depth with DepthManager providing context id information.
				var depth : Number = DepthManager.getInstance().suscribeDepth( id, parentID, Number(sDepth) );
				
				if ( url.length > 0 )
				{
					// If we need to load a swf file.
					getAssembler().buildDisplayObject( id, parentID, url, depth, isVisible, type );
					
				} else
				{
					// If we need to build an empty MovieClip.
					getAssembler().buildEmptyDisplayObject( id, parentID, depth, isVisible, type );
				}
			}
			
			// Build property.
			for each ( var property : XML in xml[ ContextNodeNameList.PROPERTY ] )
			{
				getAssembler().buildProperty( 	id, 
												ContextAttributeList.getName( property ),
												ContextAttributeList.getValue( property ),
												ContextAttributeList.getType( property ),
												ContextAttributeList.getRef( property ),
												ContextAttributeList.getMethod( property ) );
			}
	


			// Build method call.
			for each ( var method : XML in xml[ ContextNodeNameList.METHOD_CALL ] )
			{
				getAssembler().buildMethodCall( id, 
												ContextAttributeList.getName( method ),
												getArguments( method ) );
			}
			
			// recursivity
			/*var b : ReversedBatch = new ReversedBatch();
			for ( var p : String in nodeContent )
			b.addCommand( new Delegate( this, _parseDisplayNode, p, nodeContent[p], id) );
			b.execute();*/
		
		}
	}
}