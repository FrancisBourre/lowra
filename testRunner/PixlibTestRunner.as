import flexunit.framework.TestSuite;

import mx.core.Application;

import com.bourre.TestSettings;

import com.bourre.commands.*;
import com.bourre.collection.*;
import com.bourre.core.*;
import com.bourre.events.*;
import com.bourre.ioc.assembler.* ;
import com.bourre.ioc.bean.*;
import com.bourre.ioc.parser.*;
//import com.bourre.ioc.assembler.property.*;
import com.bourre.load.*;
import com.bourre.load.strategy.*;
import com.bourre.log.*;
import com.bourre.plugin.*;
import com.bourre.request.*;
import com.bourre.utils.*;
import com.bourre.structures.*;
import com.bourre.transitions.*;

private function onCreationComplete():void
{
	Logger.getInstance().setLevel( LogLevel.ALL );
	Logger.getInstance().addLogListener( FlashInspectorLayout.getInstance(), PixlibDebug.CHANNEL );
	Logger.getInstance().addLogListener( SosLayout.getInstance(), PixlibDebug.CHANNEL );
	
	if( Application.application.parameters.testBinPath != null )
		TestSettings.getInstance().testBinPath = Application.application.parameters.testBinPath;
	
	testRunner.test = createSuite();
	testRunner.startTest();	
}

private function createSuite() : TestSuite
{
	var ts:TestSuite = new TestSuite();
	
	// com.bourre.collection
	ts.addTestSuite( HashMapTest );
	ts.addTestSuite( WeakCollectionTest );
	ts.addTestSuite( TypedArrayTest );
	ts.addTestSuite( QueueTest );
	ts.addTestSuite( StackTest );
	ts.addTestSuite( SetTest) ;
	
	// com.bourre.commands
	ts.addTestSuite( DelegateTest );
	ts.addTestSuite( BatchTest );
	ts.addTestSuite( AbstractSyncCommandTest );
	ts.addTestSuite( ASyncCommandSequencerTest );
	ts.addTestSuite( FrontControlerTest );
	ts.addTestSuite( CommandMSTest );
	ts.addTestSuite( CommandFPSTest );
	ts.addTestSuite( ReversedBatchTest ) ;
	
	// com.bourre.core
	ts.addTestSuite( AccessorTest );
	
	// com.bourre.events
	ts.addTestSuite( ChannelBroadcasterTest );
	ts.addTestSuite( EventBroadcasterTest );
	ts.addTestSuite( EventChannelTest );
	ts.addTestSuite( NumberEventTest) ;
	ts.addTestSuite( StringEventTest) ;
	ts.addTestSuite( BooleanEventTest);
	ts.addTestSuite( BasicEventTest) ;
	
	// com.bourre.ioc.assembler
	ts.addTestSuite (DepthManagerTest ) ;
	
	// com.bourre.ioc.bean
	ts.addTestSuite( BeanFactoryTest);
	ts.addTestSuite( BeanEventTest) ;
	//com.bourre.ioc.assembler.property
	//ts.addTestSuite( PropertyEventTest) ;
	//ts.addTestSuite(PropertyExpertTest) ;
	
	//com.bourre.parser
	ts.addTestSuite( ContextNodeNameListTest ) ;
	
	// com.bourre.load
	ts.addTestSuite( LoaderStrategyTest );
	ts.addTestSuite( URLLoaderStrategyTest );	
	ts.addTestSuite( AbstractLoaderTest );
	//ts.addTestSuite( GraphicLoaderTest );
	ts.addTestSuite( XMLLoaderTest );
	ts.addTestSuite(XMLToObjectTest) ;
	
	// com.bourre.log
	ts.addTestSuite( BasicStringifierTest );
	ts.addTestSuite( LogEventTest );
	ts.addTestSuite( LoggerTest );
	ts.addTestSuite( LogLevelTest );
	
	// com.bourre.plugin
	//ts.addTestSuite( PixlibDebugTest );	
	ts.addTestSuite( NullPluginTest );
	ts.addTestSuite( AbstractPluginTest )
	
	//com.bourre.request
	ts.addTestSuite(AbstractDataRequestTest)
	
	// com.bourre.utils
	ts.addTestSuite( FlashInspectorLayoutTest );
	ts.addTestSuite( SosLayoutTest );
	
	// com.bourre.structures
	ts.addTestSuite( PointTest );
	ts.addTestSuite( RectangleTest );
	ts.addTestSuite( RangeTest );
	ts.addTestSuite( GridTest );
	
	// com.bourre.transitions
	ts.addTestSuite( AbstractTweenTest );
	ts.addTestSuite( AbstractMultiTweenTest );
	ts.addTestSuite( TweenMSTest );
	ts.addTestSuite( MultiTweenMSTest );
	
	return ts;
}
