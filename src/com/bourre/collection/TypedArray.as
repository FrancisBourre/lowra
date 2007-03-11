package com.bourre.collection
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
	// TODO : Benchs > Map Vs Switch
	// TODO : Benchs > Proxy Vs Composition
	
	/**
	 * 
	 * 
	 * @author Cédric Néhémie
	 * 
	 */
	dynamic public class TypedArray extends Proxy
	{
		protected var _a : Array;
		protected var _t : Class;
		
		public function TypedArray ( t : Class = null, ... args )
		{
			_t = t != null ? t : Object ;
			if( args.length == 1 && args[0] is uint )
			{
				_a = new Array ( args[ 0 ] );
			}
			else
			{
				_a = new Array ();
				var item : *;
				var b : Boolean = false;
				for each ( item in args )
	            {
	            	if( !isType( item ) )
	            	{
	            		b = true;
	            		break;
	            	}
	            }
	            if( b )
	            {
	            	_throwTypeError( "Arguments contains elements of a type different than " +
	            					 _t + " in new TypedArray( "+_t+", "+args+" )" );
	            }
	            _a.unshift.apply ( _a, args );
			}
		}
		
		
		/**
		 * Verify if the passed-in object can be inserted in the
		 * current <code>TypedArray</code>.
		 * 
		 * @param	o	Object to verify
		 * @return 	<code>true</code> if the object can be inserted in
		 * the <code>TypedArray</code>, either <code>false</code>.
		 */
		public function isType( o : * ) : Boolean
	    {
	    	return ( o is _t || o == null );
	    }
	    
	    /**
	     * Return the current type allowed in the <code>TypedArray</code>
	     * 
	     * @return <code>Class</code> used to ttype checking.
	     */
	    public function getType () : Class
	    {
	    	return _t;
	    }
		
		override flash_proxy function callProperty( methodName : *, ... args) : * 
		{
	        var res : *;
	        switch ( methodName.toString() ) 
	        {
	        	case 'push' : 
	            	res = _push ( args );
	            	break;
	            	
	            case 'unshift' : 
	            	res = _unshift ( args );
	            	break;
	            	
	            case 'splice' : 
	            	res = _splice ( args );
	            	break;
	            	
	            case 'concat' :
	            	res = _concat ( args );
	            	break;
	            	
	            default :
	                res = _a[ methodName ].apply( _a , args );
	                break;
	        }
	        return res;
	    }
	
	    override flash_proxy function getProperty( name : * ) : * 
	    {
	        return _a[ name ];
	    }
	
	    override flash_proxy function setProperty( name : *, value : * ) : void 
	    {
	    	if( !isType ( value ) )
	    	{
	        	_throwTypeError( value + " is not of type " + _t + " in " + this + "[" + name + "]" );
	     	}
	     	_a[ name ] = value;
	    }
	    
	    protected function _push ( args : Array ) : Number
	    {
	    	if( args.length > 1 )
	    	{
	    		throw new ArgumentError ( this + ".push() called with an invalid number of arguments" );
	    	}
	    	if( !isType( args[ 0 ] ) )
        	{
        		_throwTypeError( args[ 0 ] + " is not of type " + _t + " in " + this + ".push()" );
        	}
        	
        	return _a.push ( args[ 0 ] )
	    }
	    
	    protected function _unshift ( args : Array ) : Number
	    {
	    	var b : Boolean = false;
        	for each ( var item : * in args )
        	{
        		if( !isType( item ) )
            	{
            		b = true;
            		break;
            	}
        	}
        	if( b )
        	{
        		_throwTypeError( "Arguments contains elements of a type different than " +
        						 _t + " in " + this + ".unshift( "+ args + " )" );
        	}

        	return _a.unshift.apply ( _a, args );	
	    }
	    
	    protected function _splice ( args : Array ) : Array
	    {
	    	var a : Array = args.splice (0,2);
        	var b : Boolean = false;
        	for each ( var item : * in args )
        	{
        		if( !isType( item ) )
            	{
            		b = true;
            		break;
            	}
        	}
        	if( b )
        	{
        		_throwTypeError( "Arguments contains elements of a type different than " +
        						 _t + " in " + this + ".splice( "+ a +", "+ args + " )" );
        	}
        	
        	return _a.splice.apply( _a, a.concat(args) );
	    }
	    
	    protected function _concat ( args : Array ) : TypedArray
	    {
	    	var b : Boolean = false;
			var res : *;
			var a : Array;
			
        	mainloop: for each ( var arg : * in args )
        	{
        		if( arg is Array )
        		{
        			for each ( var item : * in arg )
        			{
        				if( !isType( item ) )
            			{
            				b = true;
            				break mainloop;
            			}
        			}
        		}
        		else
        		{
        			if( !isType( arg ) )
        			{
        				b = true;
            			break mainloop;
        			}
        		}
        	}
        	if( b )
        	{
        		_throwTypeError( "Arguments contains elements of a type different than " +
        						 _t + " in " + this + ".concat( "+ args + " )" );
        	}

    		a = _a.concat.apply( _a, args );
    		res = new TypedArray ( _t );
    		for each ( var i:* in a )
    		{
    			res.push( i );
    		}
    		
    		return res;
	    }   
	    
	    protected function _throwTypeError ( m : String ) : void
	    {
	    	//PixlibDebug.ERROR( m );
	    	throw new TypeError ( m );
	    }
	    
	    /**
	    * Returns the <code>String</code> representation of the object.
	    */
	    public function toString () : String
	    {
	    	return PixlibStringifier.stringify( this );
	    }
	}
}