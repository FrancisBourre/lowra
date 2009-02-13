/**
* @exampleText Loads complete context
*/
package com.bourre.ioc.load.runtime 
{
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.load.ApplicationLoaderEvent;
	import com.bourre.ioc.parser.ContextNodeNameList;
	import com.bourre.load.LoaderEvent;
	import com.bourre.log.PixlibDebug;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;	

	public class RuntimeContextLoaderSample 
	{
		public function RuntimeContextLoaderSample()
		{
			var node : XML = <object id='obj2' type='Object'><property name='p4' value='hello4' /></object>;
			
			var target : DisplayObjectContainer = BeanFactory.getInstance().locate( ContextNodeNameList.ROOT ) as DisplayObjectContainer;
			
			var loader : RuntimeContextLoader = new RuntimeContextLoader( target );
			loader.sandbox = true;
			loader.addEventListener( ApplicationLoaderEvent.onApplicationInitEVENT, onLoadContext );
			
//			loader.addProcessor( ContextUtils.changeObjectAttribute, "logo", "visible", "false" );
//			loader.addProcessor( ContextUtils.changePropertyValue, "monitor", "x", 200 );//			loader.addProcessor( ContextUtils.changePropertyValue, "monitor", "y", 200 );
//			loader.addProcessor( ContextUtils.addResource, "newStyle", "myStyle.css" );
//			loader.addProcessor( ContextUtils.addNode, node );
			
			loader.load( new URLRequest ( "runtime.xml" ) );
		}
		
		public function onLoadContext( e : LoaderEvent ) : void
		{
			PixlibDebug.INFO( "Context loaded : " + e.getLoader().getURL().url );
			
			var mc : DisplayObject = BeanFactory.getInstance().locate( "logo" ) as DisplayObject;
			mc.alpha = 0.5;
		}
	}
}
