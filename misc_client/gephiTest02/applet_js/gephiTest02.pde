import org.gephi.data.attributes.api.*;
import org.gephi.filters.api.*;
import org.gephi.graph.api.*;
import org.gephi.io.importer.api.*;
import org.gephi.io.processor.plugin.*;
import org.gephi.layout.plugin.force.*;
import org.gephi.layout.plugin.forceAtlas2.*;
import org.gephi.preview.api.*;
import org.gephi.project.api.*;
import org.gephi.ranking.api.*;
import org.gephi.statistics.plugin.*;
import com.francisli.processing.http.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;

HttpClient client;
GraphModel graphModel;
DirectedGraph graph;
ForceAtlas2 layout;
Degree degree;
AttributeModel attributeModel;
AttributeColumn col;
RankingController rankingController;
PartitionController partitionController;
ExportController exporter;

float minNodeSize = 1;
float maxNodeSize = 30;
int partitionAmount = 0;

Integer[] colors = {
   #FFEA82, #F0CDA4, #995A14, #E4D0A6, #FDFDFD, #E4DFD8, #C0B2A1, #7A6145, #2B2102, #5D5111, #453A09, #CCB735, #A79336
};
PFont mainFont;

int loadID = 0;
ArrayList<String> booksQueue = new ArrayList<String>();
int numBooks = 100;
String theBookTitle = "";
String lastAddedBook = "";

ClipHelper cp = new ClipHelper();

boolean[] keys = new boolean[526];
boolean checkKey(String k)
{
  for (int i = 0; i < keys.length; i++)
    if (KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) return keys[i];  
  return false;
}
String loadingURL = "";

void setup() {
  size(1280, 800);
  // size(screen.width, screen.height);
  smooth();

  mainFont = loadFont("GravurCondensed-Light-48.vlw");
  textFont(mainFont);

  //add mouse wheel listener for basic zooming
  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
    }
  }
  ); 

  initGephi();

  client = new HttpClient(this, "www.amazon.com");  
  // client.GET("/Bauhaus-1919-1933-Taschen-25-Archiv/dp/3822850020/ref=sr_1_1?ie=UTF8&qid=1321797758&sr=8-1");
}

void draw() {
  background(250, 250, 248);

  layout.setAdjustSizes(mousePressed);

  // update graph layout
  if (layout.canAlgo()) layout.goAlgo();

  pushMatrix();
  translate(width/2, height/2);

  // draw edges
  stroke(200);
  strokeWeight(.5);
  for (Edge e : graphModel.getDirectedGraph().getEdges()) {
    org.gephi.graph.api.Node n1, n2;
    n1 = e.getSource();
    n2 = e.getTarget();

    NodeData nd1 = n1.getNodeData();
    NodeData nd2 = n2.getNodeData();

    PVector p1 = new PVector(nd1.x(), nd1.y());
    PVector p2 = new PVector(nd2.x(), nd2.y());

    line(p1.x, p1.y, p2.x, p2.y);
  }

  // draw nodes
  fill(50);
  noStroke();

  for (org.gephi.graph.api.Node n:graph.getNodes()) {
    NodeData nodeData = n.getNodeData();
    float nodeSize = nodeData.getRadius();

    noStroke();
    fill(nodeData.r()*255, nodeData.g()*255, nodeData.b()*255);
    ellipse(nodeData.x(), nodeData.y(), nodeSize, nodeSize);
  }

  // labels
  int labelID = 0;
  for (org.gephi.graph.api.Node n:graph.getNodes()) {
    NodeData nodeData = n.getNodeData();
    float nodeSize = nodeData.getRadius();
    boolean showLabel = false;
    // show labels?
    if (mousePressed) showLabel = true;
    else if (nodeSize > maxNodeSize*.5) showLabel = true;
    if (showLabel) {
      String nodeLabel = nodeData.getLabel().substring(0, min(40, nodeData.getLabel().length()));
      textSize(nodeSize*.75);
      // position left or right of node
      float xOffset = nodeSize*.5;
      if (labelID % 2 == 0) xOffset = - textWidth(nodeLabel) - nodeSize*.5;
      fill(0);//255 - nodeSize*10);
      text(nodeLabel, nodeData.x() + xOffset, nodeData.y() + 2);
    } 
    else {
      // show labels if mouse is in the near
      float distToMouse = dist(nodeData.x() + width/2, nodeData.y() + height/2, mouseX, mouseY);
      if (distToMouse < 30) {
        String nodeLabel = nodeData.getLabel().substring(0, min(40, nodeData.getLabel().length()));
        textSize(14);
        // position left or right of node
        float xOffset = nodeSize*.5;
        if (labelID % 2 == 0) xOffset = - textWidth(nodeLabel) - nodeSize*.5;
        fill(150);
        text(nodeLabel, nodeData.x() + xOffset, nodeData.y() + 2);
      }
    }
    labelID++;
  }

  popMatrix();

  // project info
  int infoY = height-140;
  fill(0);
  textSize(12);
  text("Amazon.com recommendation network for:", 20, infoY + 20);
  textSize(18);
  text(theBookTitle, 20, infoY + 50);
  fill(150);
  textSize(12);
  text("last added: " + lastAddedBook, 20, infoY + 80);
  text("Communities found: " + partitionAmount, 20, infoY + 100);
  text("Nodes: " + graph.getNodeCount() + " Edges: " + graph.getEdgeCount(), 20, infoY + 120);

  // loading url
  fill(50);
  noStroke();
  rect(20, 35, width - 40, 25);
  fill(0);
  textSize(18);
  text("Paste book url here: ", 20, 25);
  textSize(12);
  fill(255);
  text(loadingURL, 23, 52);
  if (loadID > 0) {
    fill(0);
    text("load item: " + loadID + " of " + numBooks, 20, 80);
  }

  // export pdf button
  fill(50);
  rect(width - 85, height - 45, 65, 25);
  fill(255);
  textSize(12);
  text("Export PDF", width - 80, height - 29);
}

void responseReceived(HttpRequest request, HttpResponse response) {
  String mainTitle = parseTitle(response.getContentAsString());
  println("got title: " + mainTitle);
  try {
    String[][] books = parseBookList(response.getContentAsString());
    // add books to loading queue and graph
    addBooks(mainTitle, books);
    addEdges(mainTitle, books);

    getPartitions();
    resetGephiLayout();
  } 
  catch (Exception e) {
    println("some error: " + e.getMessage());
  }

  // load next book
  loadNextBook();
}

String parseTitle(String msg) {
  int titleIndex = msg.indexOf("<title>");
  int titleIndexEnd = msg.indexOf("</title>", titleIndex);
  // temporary title
  String tempTitle = msg.substring(titleIndex + 19, titleIndexEnd);
  String readyTitle = tempTitle;
  // remove "("-thing
  int bracketIndex = tempTitle.lastIndexOf(")");
  if (bracketIndex != -1) {
    int bracketIndexA = tempTitle.lastIndexOf("(");
    readyTitle = tempTitle.substring(0, bracketIndexA-1);
  }

  return readyTitle;
}

String[][] parseBookList(String msg) { 
  // search for string "Kunden, die diesen Artikel gekauft haben, kauften auch"
  // int indexBegin = msg.indexOf("Kunden, die diesen Artikel gekauft haben, kauften auch");
  int indexBegin = msg.indexOf("Customers Who Bought This Item Also Bought");
  // endstring is "Produktinformation"
  int indexEnd = msg.indexOf("Editorial Reviews");
  if (indexEnd == -1) indexEnd = msg.indexOf("Product Details");
  String slicedString = msg.substring(indexBegin, indexEnd);
  String[] bookInformation = slicedString.split("<li>");
  String[][] bookList = new String[bookInformation.length-1][2];
  for (int i=1;i<bookInformation.length;i++) {
    // find first a href item
    int sliceBegin = bookInformation[i].indexOf("<a href");
    int sliceEnd = bookInformation[i].indexOf("product-image");
    String tempString = bookInformation[i].substring(sliceBegin, sliceEnd);
    String amazonString = "http://www.amazon.com/";
    int urlIndex = tempString.indexOf("http://www.amazon.com/");
    int titleIndex = tempString.indexOf("title=");
    int titleEndIndex = tempString.indexOf("class=");

    String url = tempString.substring(urlIndex + amazonString.length(), titleIndex-3);
    String title = tempString.substring(titleIndex+7, titleEndIndex-3);
    String readyTitle = title;
    // remove "("-thing
    int bracketIndex = readyTitle.lastIndexOf(")");
    if (bracketIndex != -1) {
      int bracketIndexA = readyTitle.lastIndexOf("(");
      readyTitle = readyTitle.substring(0, bracketIndexA-1);
    }
    bookList[i-1][0] = url;
    bookList[i-1][1] = readyTitle;
  }
  return bookList;
}

void loadNextBook() {
  if (loadID < numBooks) {
    println("load book: " + loadID + " of " + numBooks);
    client.GET("/" + booksQueue.get(loadID++));
  }
}

void addBooks(String mainTitle, String[][] books) {
  // add this recently loaded book as gephi node if not existing
  if (graph.getNode(mainTitle) == null) {
    // or add new if none is existing
    addNode(mainTitle);
    lastAddedBook = mainTitle;
  }

  // add books to loading queue if not existing
  // are any more books allowed to load ?
  if (booksQueue.size() < numBooks) {
    for (int i=0;i<books.length;i++) {
      // only load if not existing in list
      if (graph.getNode(books[i][1]) == null) {
        booksQueue.add(books[i][0]);
      }
    }
  }

  // add books as gephi nodes
  for (int i=0;i<books.length;i++) {
    if (graphModel.getDirectedGraph().getNode(books[i][1]) == null) {
      // or add new if none is existing
      addNode(books[i][1]);
      lastAddedBook = books[i][1];
    }
  }
}

void clearData() {
  // reset loading queue
  loadID = 0;
  booksQueue = new ArrayList<String>();

  // remove nodes and edges
  graph.clear();
}

void startLoading(String url) {
  clearData();
  String cutString = "http://www.amazon.com";
  if (url.indexOf(cutString) != -1) {
    String thisURL = url.substring(cutString.length(), url.length());
    client.GET(thisURL);
  }
}

void mouseWheel(int delta) {
  Double scalingRatio = layout.getScalingRatio() + delta*.5;
  if (scalingRatio < 0.1) scalingRatio = Double.parseDouble(".1");
  layout.setScalingRatio(scalingRatio);
}

void mousePressed() {
  // paste loadung url
  if (mouseX > 20 && mouseX < width-20 && mouseY > 35 && mouseY < 60) {
    loadingURL = cp.pasteString();
    startLoading(loadingURL);
  }
  // export pdf button
  if (mouseX > width - 85 && mouseX < width-20 && mouseY > height - 45 && mouseY < height - 10) {
    exportPDF();
  }
}

// //////////////////
// Clipboard class for Processing
// by seltar  
// v 0115
// only works with programs. applets require signing

class ClipHelper
{
  Clipboard clipboard;
  ClipHelper()
  {
    getClipboard();
  }

  void getClipboard ()
  {
    // this is our simple thread that grabs the clipboard
    Thread clipThread = new Thread() {
      public void run() {
        clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
      }
    };

    // start the thread as a daemon thread and wait for it to die
    if (clipboard == null) {
      try {
        clipThread.setDaemon(true);
        clipThread.start();
        clipThread.join();
      }  
      catch (Exception e) {
      }
    }
  }

  void copyString (String data)
  {
    copyTransferableObject(new StringSelection(data));
  }

  void copyTransferableObject (Transferable contents)
  {
    getClipboard();
    clipboard.setContents(contents, null);
  }

  String pasteString ()
  {
    String data = null;
    try {
      data = (String)pasteObject(DataFlavor.stringFlavor);
    }  
    catch (Exception e) {
      System.err.println("Error getting String from clipboard: " + e);
    }

    return data;
  }

  Object pasteObject (DataFlavor flavor)  
    throws UnsupportedFlavorException, IOException
  {
    Object obj = null;
    getClipboard();

    Transferable content = clipboard.getContents(null);
    if (content != null)
      obj = content.getTransferData(flavor);

    return obj;
  }
}

void initGephi() {
  // Init a project - and therefore a workspace
  ProjectController pc = Lookup.getDefault().lookup(ProjectController.class);
  pc.newProject();
  Workspace workspace = pc.getCurrentWorkspace();
  rankingController = Lookup.getDefault().lookup(RankingController.class);
  partitionController = Lookup.getDefault().lookup(PartitionController.class);
  exporter = Lookup.getDefault().lookup(ExportController.class);
  // Get models and controllers for this new workspace - will be useful
  // later
  attributeModel = Lookup.getDefault().lookup(
  AttributeController.class).getModel();
  graphModel = Lookup.getDefault().lookup(GraphController.class)
    .getModel();

  degree = new Degree();

  // See if graph is well imported
  graph = graphModel.getDirectedGraph();

  // use forcelayout 2
  layout = new ForceAtlas2(null);
  layout.setGraphModel(graphModel);
  Double scalingRatio = Double.parseDouble("7.0");
  layout.setScalingRatio(scalingRatio);

  // preview settings. they will be used in pdf export
  PreviewModel model = Lookup.getDefault().lookup(PreviewController.class).getModel();

  PreviewProperties prop = model.getProperties();
  prop.putValue(PreviewProperty.SHOW_NODE_LABELS, Boolean.TRUE);
  prop.putValue(PreviewProperty.EDGE_COLOR, new EdgeColor(java.awt.Color.GRAY));
  prop.putValue(PreviewProperty.EDGE_THICKNESS, new Float(0.1f));
  prop.putValue(PreviewProperty.EDGE_CURVED, false);
  prop.putValue(PreviewProperty.NODE_BORDER_WIDTH, new Float(0.0f));

  // prop.putValue(PreviewProperty.NODE_BORDER_COLOR, java.awt.Color.WHITE);
  prop.putValue(PreviewProperty.NODE_LABEL_FONT, prop.getFontValue(PreviewProperty.NODE_LABEL_FONT).deriveFont(8));
  prop.putValue(PreviewProperty.NODE_LABEL_MAX_CHAR, new Integer(40));
  prop.putValue(PreviewProperty.NODE_LABEL_SHORTEN, true);
  prop.putValue(PreviewProperty.NODE_LABEL_PROPORTIONAL_SIZE, true);
}

void addEdges(String mainTitle, String[][] books) {
  org.gephi.graph.api.Node source = graph.getNode(mainTitle);
  for (int i=0;i<books.length;i++) {
    org.gephi.graph.api.Node target = graph.getNode(books[i][1]);
    Edge e = graphModel.factory().newEdge(source, target, 1.0, true);
    graph.addEdge(e);
  }
}

void addNode(String label) {
  org.gephi.graph.api.Node n = graphModel.factory().newNode(label);
  // fix first node that appears on center
  if (graph.getNodeCount() == 0) {
    n.getNodeData().setX(0);
    n.getNodeData().setY(0); 
    n.getNodeData().setFixed(true);
    theBookTitle = label;
  } 
  else {
    // add at last books position
    org.gephi.graph.api.Node lastNode = graphModel.factory().newNode(lastAddedBook);
    n.getNodeData().setX(lastNode.getNodeData().x()*.25);
    n.getNodeData().setY(lastNode.getNodeData().y()*.25);

    // n.getNodeData().setX(random(-50, 50));
    // n.getNodeData().setY(random(-50, 50));
  }
  n.getNodeData().setLabel(label);
  graph.addNode(n);
}

void getPartitions() {
  //Run modularity algorithm - community detection
  Modularity modularity = new Modularity();
  modularity.execute(graph.getGraphModel(), attributeModel);
  //Partition with ‘modularity_class’, just created by Modularity algorithm
  AttributeColumn modColumn = attributeModel.getNodeTable().getColumn(Modularity.MODULARITY_CLASS);
  Partition p = partitionController.buildPartition(modColumn, graph);
  partitionAmount = p.getPartsCount();

  NodeColorTransformer nodeColorTransformer = new NodeColorTransformer();
  nodeColorTransformer.randomizeColors(p);

  // set my own color map
  int colorID = 0;
  for (Map.Entry entry : nodeColorTransformer.getMap().entrySet()) {
    if (colorID < colors.length)
      entry.setValue(new java.awt.Color(colors[colorID++]));
  }
  partitionController.transform(p, nodeColorTransformer);
}

void resetGephiLayout() {
  // reset gephis layout algorithm
  layout.initAlgo();
  // compute degree metrics
  degree.execute(graph.getGraphModel(), attributeModel);
  //Get Centrality column created
  col = attributeModel.getNodeTable().getColumn(Degree.INDEGREE);
  // rank size by in-degree
  Ranking centralityRanking = rankingController.getModel().getRanking(Ranking.NODE_ELEMENT, col.getId());
  AbstractSizeTransformer sizeTransformer = (AbstractSizeTransformer) rankingController.getModel().getTransformer(Ranking.NODE_ELEMENT, org.gephi.ranking.api.Transformer.RENDERABLE_SIZE);
  sizeTransformer.setMinSize(minNodeSize);
  sizeTransformer.setMaxSize(maxNodeSize);
  rankingController.transform(centralityRanking, sizeTransformer);
}

void exportPDF() {
  //Simple PDF export
  //PDF Exporter config and export to Byte array

  PDFExporter pdfExporter = (PDFExporter) exporter.getExporter("pdf");
  pdfExporter.setPageSize(PageSize.A4);
  ByteArrayOutputStream baos = new ByteArrayOutputStream();
  exporter.exportStream(baos, pdfExporter);

  byte[] pdf = baos.toByteArray();
  try {
    println("export pdf");
    exporter.exportFile(new File("amazon_recommendation" + System.currentTimeMillis()/1000 + ".pdf"));
  } 
  catch (IOException ex) {

    ex.printStackTrace();

    return;
  }
}


