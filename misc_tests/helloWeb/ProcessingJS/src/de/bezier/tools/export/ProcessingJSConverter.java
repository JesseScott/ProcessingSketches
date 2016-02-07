/**
 *	<p>Generate JavaScript code from Processing code</p>
 *
 *	http://github.com/fjenett/processingjstool
 *		
 *	@author		florian jenett - mail@bezier.de
 *	@modified	##date##
 *	@version	##version## - build ##build##
 */

package de.bezier.tools.export;

import java.io.*;
import org.mozilla.javascript.*;

public class ProcessingJSConverter
{
    private File processingJSScript, envJSScript;
    
    // the processing.js script is dependent on tool folder
    // that's why it needs to be passed in at runtime
    public ProcessingJSConverter ( File _pjs, File _envjs )
    {
        processingJSScript = _pjs;
        envJSScript = _envjs;
    }
    
    public String convert ( String sketchCode )
    {
        Context cx = Context.enter();
        
        cx.setGeneratingDebug  ( true                );
        cx.setOptimizationLevel( -1                  );
        cx.setLanguageVersion  ( Context.VERSION_1_5 );
        
        PJSConverterEnvironment env =
            new PJSConverterEnvironment( processingJSScript.getParentFile(),
                                         sketchCode );
        cx.initStandardObjects( env );
        env.defineFunctionProperties( new String[]{ "print", "getSketchCode" },
                                      PJSConverterEnvironment.class,
                                      ScriptableObject.DONTENUM );
        
        String converter_id = "<inline " +
                              "de.bezier.tools.export.PJSConverterEnvironment>";
        
        FileReader in = null;
        // env.js
        try {
            in = new FileReader( envJSScript );
            cx.evaluateReader( env, in, envJSScript.getName(), 1, null );
        
        } catch ( Exception e ) {
            System.err.println( e.toString() );
        } finally {
            try {
                in.close();
            } catch ( IOException ioe ) {
                System.err.println( ioe.toString() );
            }
        }
        // processing.js
        try {
            in = new FileReader( processingJSScript );
            cx.evaluateReader( env, in, processingJSScript.getName(), 1, null );
        
        } catch ( Exception e ) {
            System.err.println( e.toString() );
        } finally {
            try {
                in.close();
            } catch ( IOException ioe ) {
                System.err.println( ioe.toString() );
            }
        }
        
        Object result = cx.evaluateString( env,
                           "Processing.compile( getSketchCode() ).sourceCode;",
                           converter_id, 1, null );
        
        Context.exit();
        
        return result.toString();
    }
}

class PJSConverterEnvironment extends ScriptableObject
{
    File folderContext;
    String sketchCode;
    
    PJSConverterEnvironment ( File _folderContext, String _sc )
    {
        this.folderContext = _folderContext;
        this.sketchCode = _sc;
    }
    
    public String getSketchCodeImlp ()
    {
        return sketchCode;
    }
    
    private void printString ( String msg )
    {
        if ( msg.matches( "[\\s]*[A-Za-z]+Error:.+" ) )
            printError( msg );
        else
        {
            System.out.println( "" );
            System.out.println( msg );
            System.out.println( "" );
        }
    }
    
    private void printError ( String err )
    {
        System.err.println( "Processing.js tool syntax checker found: " );
        System.err.println( "" );
        System.err.println( err.replaceAll("^[\\s]+","\t") );
        System.err.println( "" );
        
        handleError( err );
    }
    
    private void handleError ( String err )
    {
        if ( err.indexOf( "SyntaxError: identifier is a reserved word" ) != -1 )
        {
            System.out.println( "Most of the time this means that you used " +
                                "one of the conversion methods which are not " +
                                "supported by Processing.js:" );
            System.out.println( "int() / float() / boolean() / ...");
            System.out.println( "" );
            System.out.println( "A solution may be to use parseFloat() instead " +
                                "of float(), parseInt() instead of int(), ..." );
            System.out.println( "" );
            System.out.println( "If it's not that, then check the Mozilla reference for other " +
                                "reserved words that you might have used:" );
            System.out.println( "http://mzl.la/cguVMF" );
        }
    }
    
    /* ScriptableObject */
    @Override
    public String getClassName()
    {
        return "global";
    }
    /* ScriptableObject */
    
    /* Rhino exmaples / Shell.java */
    public static void print ( Context cx, Scriptable thisObj,
                               Object[] args, Function funObj )
    {
        PJSConverterEnvironment env =
            (PJSConverterEnvironment)getTopLevelScope( thisObj );
            
        for (int i=0; i < args.length; i++)
        {
            if ( i > 0 )
                System.out.print(" ");

            String s = Context.toString( args[i] );
            
            if ( !s.startsWith("[  Envjs/1.6") ) // suppress env.js blah
                env.printString( s );
        }
        
        System.out.println();
    }
    
    /* Rhino exmaples / Shell.java */
    public static String getSketchCode ( Context cx, Scriptable thisObj,
                              Object[] args, Function funObj )
    {
        PJSConverterEnvironment env =
            (PJSConverterEnvironment)getTopLevelScope( thisObj );
        
        return env.getSketchCodeImlp();
    }
}