/**
 *	<p>This is a humble attempt to implement sort of a debugger.</p>
 *
 *	http://github.com/fjenett/processingjstool
 *
 *	<p>Using lovely <a href="http://www.envjs.com/">Env.js</a>,
 *      another Resig idea, and Mozilla
 *      <a href="http://www.mozilla.org/rhino/">Rhino</a>.</p>
 *		
 *	@author		florian jenett - mail@bezier.de
 *	@modified	##date##
 *	@version	##version## - build ##build##
 */

package de.bezier.tools.export.debug;

import java.io.*;
import org.mozilla.javascript.*;

public class ProcessingJSDebugger extends Thread
{
    public static boolean debug ( File debugger_js, File applet_js, File test_dir )
    {
        ProcessingJSDebugger pjsdt =
            new ProcessingJSDebugger( debugger_js, applet_js, test_dir );
        
        /* Not running this on a separate thread for now */
        pjsdt.run();
        
        return pjsdt.errorsFound;
    }
    
    File debugger_js, applet_js, test_dir;
    boolean errorsFound = false;
    
    private ProcessingJSDebugger ( File _debugger_js, File _applet_js, File _test_dir )
    {
        debugger_js = _debugger_js;
        applet_js = _applet_js;
        test_dir = _test_dir;
    }
    
    public void run ()
    {
        Context cx = Context.enter();
        
        cx.setGeneratingDebug  ( true                );
        cx.setOptimizationLevel( -1                  );
        cx.setLanguageVersion  ( Context.VERSION_1_5 );
        
        PJSDebuggerEnvironment env = new PJSDebuggerEnvironment( test_dir );
        cx.initStandardObjects( env );
        env.defineFunctionProperties( new String[]{ "print", "load" },
                                      PJSDebuggerEnvironment.class,
                                      ScriptableObject.DONTENUM );
        
        String debugger_id = "<inline " +
                              "de.bezier.tools.export.ProcessingJSDebugger>";

        String jsAppletURI =
            applet_js.toURI().toString().replace("file:","file://");
            
        cx.evaluateString( env,
                           "var applet_js = " + "\"" +
                           Context.toString( jsAppletURI ) + "\";",
                           debugger_id, 1, null );
        
        FileReader in = null;
        try
        {
            in = new FileReader( debugger_js );
            
            cx.evaluateReader( env, in,
                               debugger_js.getName(), 1, null );
        
        }
        catch ( Exception e )
        {
            System.err.println( e.toString() );
        }
        finally
        {
            try
            {
                in.close();
            }
            catch ( IOException ioe )
            {
                System.err.println( ioe.toString() );
            }
        }
        
        Context.exit();
        
        errorsFound = env.hasErrors();
    }
}

class PJSDebuggerEnvironment extends ScriptableObject
{
    File folderContext;
    boolean errorsFound = false;
    //String[] errors = new String[0];
    
    PJSDebuggerEnvironment ( File _folderContext )
    {
        this.folderContext = _folderContext;
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
        errorsFound = true;
        
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
    
    public boolean hasErrors ()
    {
        return errorsFound;
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
        PJSDebuggerEnvironment env =
            (PJSDebuggerEnvironment)getTopLevelScope( thisObj );
            
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
    public static void load ( Context cx, Scriptable thisObj,
                              Object[] args, Function funObj )
    {
        PJSDebuggerEnvironment env =
            (PJSDebuggerEnvironment)getTopLevelScope( thisObj );
        
        for (int i = 0; i < args.length; i++)
        {
            env.processSource( cx, Context.toString( args[i] ) );
        }
    }
    
    /* Rhino exmaples / Shell.java */
    private void processSource( Context cx, String srcFile )
    {
        FileReader in = null;
        File fl = new File( folderContext, srcFile );
        
        try
        {
            in = new FileReader( fl );
        
            cx.evaluateReader( this, in, srcFile, 1, null );
        }
        catch ( Exception e )
        {
            System.err.println( e.toString() );
        }
        finally
        {
            try {
                in.close();
            }
            catch ( IOException ioe ) {
                System.err.println( ioe.toString() );
            }
        }
    }
}