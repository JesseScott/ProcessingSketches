/**
 *	<p>Processing.js export directly from the Processing IDE</p>
 *
 *	http://github.com/fjenett/processingjstool
 *		
 *	@author		florian jenett - mail@bezier.de
 *	@modified	##date##
 *	@version	##version## - build ##build##
 */

package de.bezier.tools.export;

import processing.app.*;
import processing.app.tools.*;
import processing.core.*;

import java.io.*;
import java.net.*;

import de.bezier.tools.export.debug.*;

public class ProcessingJS
implements Tool
{
	Editor editor;
	
	File templateFolder;
	File toolFolder;
	
	// directory names
	final private String APPLET_DIRNAME = "applet_js";
	final private String DEFAULT_TEMPLATE = "template_js";
	
	// minimum needed files for export
	final private String PROCESSING_JS = "processing.js";
	final private String APPLET_HTML = "applet.html";
	
	final private boolean DEBUG = true;
	
	boolean inited = false;
	
	public ProcessingJS () {}
	
	/* called by PDE on start when loading the tools */
	public void init ( Editor _e )
	{
		editor = _e;
	}
	
	/* called by PDE, action code for the menu item */ 
	public void run ( )
	{		
		if ( !findTemplateFolder() || // look for a template folder to use
			  templateFolder == null ||
			 !templateFolder.exists() ||
			 !templateFolder.canRead()  )
		{
			String msg = templateFolder.toString();
			msg += "\n";
			msg += "Expected it to be inside the ProcessingJS folder.";
			Base.showError( "Processing.js export: " +
						    "unable to find \"templates\" folder", msg, null );
			return;
		}
		
		File sketchFolder = editor.getSketch().getFolder();
		
		if ( !sketchFolder.canWrite() )
		{
			printError( "Folder not writable:\n" + sketchFolder.toString() );
			return;
		}
		
		File appletJsFolder = new File(sketchFolder, APPLET_DIRNAME);
		
		if ( appletJsFolder.exists() )
		{
			Base.removeDir(appletJsFolder);
			if ( appletJsFolder.exists() )
			{
				printError( "Unable to remove '" +
						     APPLET_DIRNAME + "' folder." );
				return;
			}
		}
		
		try
		{
			// copy template folder incl. everything inside ...
			Base.copyDir( templateFolder, appletJsFolder );
			
			// remove applet.html since it will be read from template
			// folder to create index.html later
			if ( !(new File( appletJsFolder, APPLET_HTML )).delete() )
			{
				// ignore?
			}
			
		} catch ( IOException ioe ) {
			
			printError( "Unable to create '" + APPLET_DIRNAME + "' folder." );
			ioe.printStackTrace();
			return;
		}
		
		if ( !appletJsFolder.exists() )
		{
			printError( "Unable to copy template folder to '" +
					     APPLET_DIRNAME + "'." );
			return;
		}
		
		if ( !exportApplet( appletJsFolder ) )
		{
			printError( "Unable to export to applet." );
		}
		
		File testDir = new File(toolFolder, "test" );
		
		// disabled debugger for now, without line numbers it's currently useless
		if ( false ) {
			boolean errorsFound = 
			ProcessingJSDebugger.debug(
									new File(testDir, "debugger.js"),
									appletJsFolder,
									testDir );
		
			if ( errorsFound )
			{
				editor.statusError(
					"Processing.js syntax check found a problem in your code."
				);
			}
		}
		
		Base.openFolder( appletJsFolder );
	}
	
	/* Called by PDE to get the title for the menu item */
	public String getMenuTitle ()
	{
		return "Export as Processing.js";
	}
	
	/**
	 *	check if all needed files are there
	 */
	private boolean findTemplateFolder ()
	{
		// find tool folder ...
		try
		{
			// this can be either "tools" next to Processing.exe / Ð.app
			// or from "tools" inside user sketchbook.
			
			java.security.ProtectionDomain pd =
				getClass().getProtectionDomain();
				
			URL classFileUrl = pd.getCodeSource().getLocation();
			
			URI uri = new URI( classFileUrl.toString() );
			
			toolFolder = new File( uri ).getParentFile().getParentFile();
				
	/*
	TODO: replace above with
	Base.getContentFile("tools" + File.separator + "ProcessingJS" )
	and
	Base.getSketchbookFolder() + File.separator + "tools" + File.separator + "ProcessingJS"
	*/
				
			if ( !toolFolder.exists() )
			{
				printError( "Unable to find tool folder.\n" +
							 toolFolder.toString() );
			}
				
				
		}
		catch ( Exception e )
		{
			e.printStackTrace();
			return false;
		}
		
		// look for "templates" folder inside sketch folder first
		
		File sketchFolder = editor.getSketch().getFolder();
		templateFolder = new File( sketchFolder, DEFAULT_TEMPLATE );
		
		if ( templateFolder == null ||
			!templateFolder.exists() ||
			!templateFolder.canRead() )
		{
			// no user-templates found, ok then look for the defaults
			
				templateFolder = new File( toolFolder,
										  "templates" + File.separator +
										   DEFAULT_TEMPLATE );
			
				if ( !templateFolder.exists() )
				{
					printError( "Folder \"templates\" is missing:\n" +
							     templateFolder.toString() );
					return false;
				}
				else if ( !templateFolder.canRead() )
				{
					printError( "Folder \"templates\" is not readable:\n" +
							     templateFolder.toString() );
					return false;
				}
			
		}
		
		//printMessage( "Using this template folder:\n" + templateFolder.toString() );
		
		/*String[] contents = templateFolder.list();
		for ( int i = 0; i < contents.length; i++ )
		{
			System.out.println( "\t" + contents[i] );
		}*/
		
		String[] filesToCheck = new String[]
		{
			PROCESSING_JS, APPLET_HTML
		};
		
		for ( int i = 0; i < filesToCheck.length; i++ )
		{
			File ftc = new File(templateFolder, filesToCheck[i]);
			if ( !ftc.exists() )
			{
				printError( "File not available:\n" + ftc.toString() );
				return false;
			}
			else if ( !ftc.canRead() )
			{
				printError( "File not available:\n" + ftc.toString() );
				return false;
			}
		}
		
		// TODO: check for and download latest processing.js version
		
		return true;
	}
	
	/**
	 *	Handle export to processing.js applet, heavily based on Sketch.exportApplet()
	 *
	 *	@see http://dev.processing.org/source/index.cgi/trunk/processing/app/src/processing/app/Sketch.java?view=markup
	 */
	public boolean exportApplet ( File appletJsFolder )
	{
		Sketch sketch = editor.getSketch();
		SketchCode[] code = sketch.getCode();
		int codeCount = code.length;
	
		int wide = PApplet.DEFAULT_WIDTH;
		int high = PApplet.DEFAULT_HEIGHT;
		String renderer = "";
		
		// This matches against any uses of the size() function, ...
		String sizeRegex =
      		"(?:^|\\s|;)size\\s*\\(\\s*(\\S+)\\s*,\\s*(\\d+),?\\s*([^\\)]*)\\s*\\)";

		String scrubbed = Sketch.scrubComments( code[0].getProgram() );
		String[] matches = PApplet.match( scrubbed, sizeRegex );
	
		if ( matches != null )
		{
		  try
		  {
			wide = Integer.parseInt(matches[1]);
			high = Integer.parseInt(matches[2]);
		
			// Adding back the trim() for 0136 to handle Bug #769
			if (matches.length == 3) renderer = matches[2].trim();
		
		  } catch (NumberFormatException e) {
			// found a reference to size, but it didn't
			// seem to contain numbers
			final String message =
			  "The size of this applet could not automatically be\n" +
			  "determined from your code. You'll have to edit the\n" +
			  "HTML file to set the size of the applet.";
		
			Base.showWarning("Could not find applet size", message, null);
		  }
		}  // else no size() command found
		
		// Grab the Javadoc-style description from the main code.
		// Originally tried to grab this with a regexp matcher, but it wouldn't
		// span over multiple lines for the match. This could prolly be forced,
		// but since that's the case better just to parse by hand.
		
		StringBuffer dbuffer = new StringBuffer();
		String lines[] = PApplet.split( code[0].getProgram(), '\n' );
		
		for (int i = 0; i < lines.length; i++)
		{
		  if (lines[i].trim().startsWith("/**")) // this is our comment
		  {
			// some smartass put the whole thing on the same line
			//if (lines[j].indexOf("*/") != -1) break;
		
			for (int j = i+1; j < lines.length; j++) {
			  if (lines[j].trim().endsWith("*/")) {
				// remove the */ from the end, and any extra *s
				// in case there's also content on this line
				// nah, don't bother.. make them use the three lines
				break;
			  }
		
			  int offset = 0;
			  while ((offset < lines[j].length()) &&
					 ((lines[j].charAt(offset) == '*') ||
					  (lines[j].charAt(offset) == ' '))) {
				offset++;
			  }
			  // insert the return into the html to help w/ line breaks
			  dbuffer.append(lines[j].substring(offset) + "\n");
			}
		  }
		}
		String description = dbuffer.toString();
		
		// Add links to all the code
		// Add code to <script> tag
		StringBuffer sources = new StringBuffer();
		String sourceFiles[] = new String[0];
		StringBuffer codes = new StringBuffer();
		
		String lineSeparator = "\n"; // System.getProperty("line.separator")
		
		String loadRegex = "((" +
							"load(Image|Strings|Shape|Bytes)"+
							"|requestImage" +
							"|create(Input|RawInput|Output)" +
							")[\\s]*\\([\\s]*)";	// loadFont?
							
		boolean alreadyWarnedAboutDataPath = false;
		
		for (int i = 0; i < codeCount; i++) 
		{
			String codeSource = code[i].getProgram();
			
			// always better to educate people than secretly fix their code
			if ( !alreadyWarnedAboutDataPath &&
				 PApplet.match(codeSource, loadRegex) != null  )
			{
				// issue a warning about data-folder if one of these is found:
				// loadImage, requestImage, loadStrings
				// https://processing-js.lighthouseapp.com/projects/41284-processingjs/tickets/558
				System.out.println (
					"\n" +
					"Hint: Processing knows about your data folder, Processing.js doesn't. \n" +
					"If you're loading something from there and it's not showing up, try prepending \"data/\":\n" +
					"\n" +
					"\t\"image.jpg\"  -->  \"data/image.jpg\"\n" /*+
					"\n" +
					"Also note that testing local files in Firefox might result in images not being loaded."*/
					
				);
				
				alreadyWarnedAboutDataPath = true;
			}
			
			// TODO: get fancy here,
			// have this be syntax highlighted?
			// add a way to template these?
			// no title="" Mr. SEO?
			sources.append( "<a href=\"" + code[i].getFileName() + "\" >" +
						    code[i].getPrettyName() + "</a> " );
			sourceFiles = PApplet.append( sourceFiles, code[i].getFileName() );
			
			// inline Processing code is not the standard or official way 
			// to put it into HTML. might someday switch to
			// <canvas data-processing-sources="sketch.pde, sketchTab2.pde" ..
			// http://processingjs.org/reference/articles/p5QuickStart#quickstart
			
			codes.append( lineSeparator );
			codes.append( "/* - - - v " + code[i].getPrettyName() + " start v - - */" );
			codes.append( lineSeparator );
			
			// .. this could be a place to wrap a function around the args to loadImage() et al.
			// to allow us to prepend "data/" if needed.
			//codeSource = codeSource.replaceAll( loadRegex, "$1\"data/\" + " );
			
			codes.append( codeSource );
			codes.append( lineSeparator );
			
			codes.append( lineSeparator );
			codes.append( "/* - - - ^ " + code[i].getPrettyName() + " end ^ - - - */" );
			codes.append( lineSeparator );
			
		}
		
		String jsCode = "";
		
		if ( true ) {
			ProcessingJSConverter conv =
				new ProcessingJSConverter( new File( templateFolder, "processing.js" ),
										   new File( toolFolder, "test" + File.separator +
													 "envjs" + File.separator +
													 "env.rhino.js" ) );
			jsCode = conv.convert( codes.toString() );
			jsCode = "// Generated by the Processing.js exporter for Processing IDE." + "\n" +
					 "// https://github.com/fjenett/processingjstool" + "\n" +
					 "\n" +
					 jsCode;
			
			// this was added as convenience thing, but needs testing
			String jsCodeNamed = jsCode; /*.replaceFirst( "\\(", "var " + sketch.getName() + " = (" );*/
			
			File jsOutputFile = new File( appletJsFolder, sketch.getName() + ".js" );
			PrintWriter jsWriter = PApplet.createWriter(jsOutputFile);
			jsWriter.print( jsCodeNamed );
			jsWriter.flush();
			jsWriter.close();
		}
		
		// where is StringBuffer.prepend( String s ) ?
		codes.insert( 0, "<script type=\"application/processing\">" );
		
		codes.append( lineSeparator );
		codes.append( "</script>" );
		codes.append( lineSeparator );
		
		// Copy the source files to the target, since we like
		// to encourage people to share their code
		for (int i = 0; i < codeCount; i++)
		{
		  try
		  {
			File exportedSource = new File( appletJsFolder, code[i].getFileName() );
			Base.copyFile( code[i].getFile(), exportedSource );
			
		  } catch (IOException e) {
			e.printStackTrace();  // ho hum, just move on...
		  }
		}
		
		// copy data folder and add preloads
		StringBuffer data = new StringBuffer();
		data.append( lineSeparator );
		
		if (sketch.getDataFolder().exists())
		{
			try
			{
				Base.copyDir( sketch.getDataFolder(),
							  new File(appletJsFolder, "data") );
			}
			catch ( java.io.IOException ioe )
			{
				ioe.printStackTrace();
			}
			
			String dataFiles[] =
				Base.listFiles( sketch.getDataFolder().getAbsolutePath(),
								false);
			int offset = sketch.getFolder().getAbsolutePath().length() + 1;
			
			for (int i = 0; i < dataFiles.length; i++) 
			{
				if (PApplet.platform == PApplet.WINDOWS)
				{
				  dataFiles[i] = dataFiles[i].replace('\\', '/');
				}
				
				File dataFile = new File(dataFiles[i]);
				
				String dataFileName = dataFile.getName();
			
				// don't export hidden files
				// skipping dot prefix removes all: . .. .DS_Store
				if (dataFileName.charAt(0) == '.') continue;
				
				if ( dataFile.isDirectory() ) 
				{
					String[] tmp = Base.listFiles( dataFile, false );
					if ( tmp != null && tmp.length > 0 )
					{
						String[] df = new String[dataFiles.length + tmp.length];
						System.arraycopy( dataFiles, 0,
										  df, 0, dataFiles.length );
						System.arraycopy( tmp, 0,
										  df, dataFiles.length, tmp.length );
						dataFiles = df;
						tmp = null;
					}
					continue;
				}
				
				// preloading by adding images to the html is not longer supported.
				// have to think about some other method.
				// i'll leave it in anyways so files will be in the browser cache
				// once loadImage and friends is called ...
				// https://processing-js.lighthouseapp.com/projects/41284-processingjs/tickets/558
				String dataFileNameLow = dataFileName.toLowerCase();
				
				if ( !(dataFileNameLow.endsWith(".jpg") 
					|| dataFileNameLow.endsWith(".gif") 
					|| dataFileNameLow.endsWith(".png")) ) continue;
				
				data.append( "<img " +
								"src=\"" + dataFiles[i].substring(offset) + "\" " +
							    "id=\"" + dataFileName + "\" />" );
			}
		}
		data.append( System.getProperty("line.separator") );
		
		// insert into template
		// @@sketch@@, @@width@@, @@height@@, @@archive@@, @@source@@
		// and now @@description@@
		
		File htmlOutputFile = new File(appletJsFolder, "index.html");
		PrintWriter htmlWriter = PApplet.createWriter(htmlOutputFile);
		
		InputStream is = null;
		
		File customHtml = new File(templateFolder, APPLET_HTML);
		if (customHtml.exists()) 
		{
			try 
			{
		  		is = new FileInputStream(customHtml);
		  	}
		  	catch ( java.io.FileNotFoundException fnfe )
		  	{
		  		fnfe.printStackTrace();
		  	}
		}
		BufferedReader reader = PApplet.createReader(is);
		
		String line = null;
		try 
		{
			while ((line = reader.readLine()) != null) 
			{
			  if (line.indexOf("@@") != -1) {
				StringBuffer sb = new StringBuffer(line);
				int index = 0;
				while ((index = sb.indexOf("@@sketch@@")) != -1) {
				  sb.replace(index, index + "@@sketch@@".length(),
							 sketch.getName());
				}
				while ((index = sb.indexOf("@@source@@")) != -1) {
				  sb.replace(index, index + "@@source@@".length(),
							 sources.toString());
				}
				while ((index = sb.indexOf("@@source-files@@")) != -1) {
				  sb.replace(index, index + "@@source-files@@".length(),
							 PApplet.join( sourceFiles, "," ) );
				}
				while ((index = sb.indexOf("@@sourcejs@@")) != -1) {
				  sb.replace(index, index + "@@sourcejs@@".length(),
							 jsCode);
				}
				while ((index = sb.indexOf("@@code@@")) != -1) {
				  sb.replace(index, index + "@@code@@".length(),
							 codes.toString());
				}
				while ((index = sb.indexOf("@@data@@")) != -1) {
				  sb.replace(index, index + "@@data@@".length(),
							 data.toString());
				}
				while ((index = sb.indexOf("@@width@@")) != -1) {
				  sb.replace(index, index + "@@width@@".length(),
							 String.valueOf(wide));
				}
				while ((index = sb.indexOf("@@height@@")) != -1) {
				  sb.replace(index, index + "@@height@@".length(),
							 String.valueOf(high));
				}
				while ((index = sb.indexOf("@@description@@")) != -1) {
				  sb.replace(index, index + "@@description@@".length(),
							 description);
				}
				line = sb.toString();
			  }
			  htmlWriter.println(line);
			}
			
			reader.close();
		}
		catch ( IOException ioe )
		{
			ioe.printStackTrace();
		}
		
		htmlWriter.flush();
		htmlWriter.close();
		
		return true;
	}
	
	
	private void printError ( String err )
	{
		System.err.println( "Export as Processing.js tool reports an error:" );
		System.err.println( "==============================================" );
		System.err.println( err );
		System.err.println( "==============================================" );
		System.err.println( "If this error persists, please consider reporting it to:" );
		System.err.println( "http://github.com/fjenett/processingjstool/issues" );
	}
	
	private void printMessage ( String msg )
	{
		System.out.println( "Export as Processing.js tool says:" );
		System.out.println( msg );
	}
}