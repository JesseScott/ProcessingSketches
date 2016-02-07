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

