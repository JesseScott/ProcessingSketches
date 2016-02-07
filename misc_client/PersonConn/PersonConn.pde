import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.TimeZone;
import fullscreen.*;
import de.looksgood.ani.*;
import touchatag.*;
import ddf.minim.*;
Minim minim;
AudioSample signon;
AudioSample signoff;


	
	  long serialVersionUID = 1L;
	
RfidListener rfidListener;
	   String listFile = "list.txt";
	   String dateFile = "data/dates.txt";
	   boolean useSavedPersons = false;
	   int appletWidth = 2560;
	   int appletHeight = 1440;
	   int backgrColor = color(230);
	   long minDelayBetweenTimeCheckPoints = 1000 * 60 * 3;	//3 min
	   long delayBetweenPersonChange = 1000 * 30;	//30 sec
	 int maxTags = 0;
	   int[] tagColors = new int[] {
			color(147,78,150),
			color(192,59,135),
			color(188,80,70),
			color(193,152,35), //yellow???
			color(101,164,119), // yellow???
			color(58,144,154),
			color(55,144,183)
	};
	 int welcomeSize = 16;
	 float[] welcomePosition = new float[] {344f, 438f};
	 int welcomeColor = color(40);
	 float[] namePosition = new float[] {344f, 482f};
	 int nameSize = 42;
	 int nameColor = color(40);
	 int descriptionSize = 14;
	 float[] descriptionField = new float[] {217f, 907f, 268f, 132f};
	
	 int descriptionColor = color(40);
	 float[] tagFieldSize = new float[] {100f, 30f};
	 float[] tagFieldPosition = new float[] {30f, 350f};
	 float tagFieldMarginRight = 6f;
	 int tagFontSize = 13;
	 float tagSpacing = 18f;
	 float tagLineLength = 20f;
	 float tagLineSize = 2f;
	 float tagTextOffsetX = 10f;
	 float tagEllipseSize = 5f;
	 int slotSize = 14;
	 float slotSpacing = 17;
	   float slotSpacingMax = 17f;
	   float slotSpacingMin = 7.9f;
	 float[] slotPosition = new float[] {868f, 672f, 740f};
	 int slotColor = color(40);
	 float availableEllipseSize = 5f;
	 float availableEllipseSpacing = 2f;
	 int timeFontSize = 12;
	 int timeColor = color(40);
	 int timeBackgroundColor = color(255);
	   DateFormat dfm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	   String dateAsString = "2011-04-15 19:00:00";
	   int eventInHours = 9;
	   long eventDuration = 1000 * 60 * 60 * eventInHours;
	 float timeYPosition = 706f;
	 float timeLineHeight = 18f;
	 float timeXPositionOffset = 5f;
	 float[] timeLineMarkerBackgroundSize = new float[] {13f, 20f};
	 float timeLineMarkerBubbleSize = 4f;
	 float timeLineMarkerHeight = 8f;
	 float timeLineMarkerWeight = 1f;
	 float checkpointEllipseSize = 9f;
	 float checkpointLineSize = 1.5f;
	 float checkpointCrossLineWeight = 3f;
	 float checkpointCrossSize = 6f;
	 float checkpointLineEndingOffset = 6f;
	 float checkpointBackgroundPointsSize = 2f;
	 int checkpointBackgroundPointsSpacing = 4;
	 int checkpointBackgroundPointsColor = color(150);
	 PGraphics checkpointBackground;
	 PShape rfidPic;
	 float rfidPicX = 346;
	 float rfidPicY = 700;
	 float rfidPicWidth = 292;
	 float rfidPicHeight = 368;
	 float rfidPicMidX = 346;
	 float rfidPicMidY = 706;
	 float rfidPicAperture = 273;
	 float completeAnimationTime = 1;
	 float bezierAnimationTime = 0.5f;
	 float bubbleAnimationTime = 0.5f;
	 float nameOutAnimationYOffset = 60;
	
	   int fps = 30;
	 Date lastPersonChange = new Date();
	 FullScreen fullscreen;
	 List<Person> persons;
	 TimeLine timeLine;
	 Touchatag rfid;
	 Date startDate, endDate = null;
	   boolean useRealTime = true;
	 PFont welcomeFont, nameFont, descriptionFont, slotFont, tagFont, timeFont;
	 float largestNameSize = 1f;
	 int nextFreeSlot = 0;
	 int currentlyDisplayedSlot = 0;
	
	
	 void setup() {
		size(appletWidth, appletHeight, JAVA2D);
		smooth();
                frame.dispose();  
                frame.setUndecorated(true);
                //super.init(); 
 	        frame.setLocation(1920,0);
		frameRate(fps);

                minim = new Minim(this);
                signon = minim.loadSample("signon.wav", 2048);
                signoff = minim.loadSample("signoff.wav", 2048);
  
		Ani.init(this);
		rfid = new Touchatag(this);
		
		nextFreeSlot = 0;
		welcomeFont = createFont("nameFont.ttf", welcomeSize);
		nameFont = createFont("nameFont.ttf", nameSize);
		descriptionFont = createFont("descriptionFont.ttf", descriptionSize);
		slotFont = createFont("slotFont.ttf", slotSize);
		tagFont = createFont("tagFont.ttf", tagFontSize);
		timeFont = createFont("timeFont.ttf", timeFontSize);
		rfidPic = loadShape("rfidPic.svg");
		
		dfm.setTimeZone(TimeZone.getTimeZone("Europe/Berlin"));
		try {
			startDate = dfm.parse(dateAsString);
			endDate = new Date(startDate.getTime() + eventDuration);
		} catch (ParseException e) {
			e.printStackTrace();
			System.exit(0);
		}
		
		timeLine = new TimeLine(this);
		checkpointBackground = createGraphics(appletWidth, 10, JAVA2D);
		checkpointBackground.beginDraw();
		checkpointBackground.smooth();
		checkpointBackground.background(backgrColor);
		checkpointBackground.fill(checkpointBackgroundPointsColor);
		checkpointBackground.ellipseMode(CENTER);
		checkpointBackground.noStroke();
		for (int k = 0; k < appletWidth; k++) {
			if (k % checkpointBackgroundPointsSpacing == 1) {
				checkpointBackground.ellipse(
					k,
					0.5f * checkpointBackground.height,
					checkpointBackgroundPointsSize,
					checkpointBackgroundPointsSize
				);
			}
		}
		checkpointBackground.endDraw();
		
		init_persons();
		largestNameSize = computeLargestNameSize();
		computeMaxTags();
		
                rfidListener = new RfidListener();
                rfidListener.start();
                
		//fullscreen = new FullScreen(this, 0);
		//fullscreen.enter();

	}
	
	 void compute_connections() {
		for (Person person : persons) {
			if (person.isDisplayedAsMaster()) {
				
				HashMap<Integer, List<Integer>> person_connections = new HashMap<Integer, List<Integer>>();
				
				for (String personTag : person.getBasicPersonInfos().getTags()) {
					List<Integer> toOtherPerson = new ArrayList<Integer>();
					
					for (Person other_person : persons) {
						if ((persons.indexOf(other_person) != persons.indexOf(person))
							&& (other_person.isDisplayedInSlots())
							&& (other_person.getBasicPersonInfos().getTags().contains(personTag))) {
							
							toOtherPerson.add(other_person.getSlot());
						}
					}
					
					person_connections.put(person.getBasicPersonInfos().getTags().indexOf(personTag), toOtherPerson);
				}
				
				person.setConnections(person_connections);
				person.setSortedConnectionList(getSortedList(person_connections));
			}
		}
	}
	
	 ArrayList<Integer> getSortedList(HashMap<Integer, List<Integer>> list) {
		ArrayList<Integer> sortedList = new ArrayList<Integer>();
		for (int k = 0; k < list.size(); k++) {
			int biggest = -1;
			int position = -1;
			for (int pos = 0; pos < list.size(); pos++) {
				if (!sortedList.contains(pos) && (list.get(pos).size() >= biggest)) {
					biggest = list.get(pos).size();
					position = pos;
				}
			}
			sortedList.add(position);
		}
		
		return sortedList;
	}
	
	 void init_persons() {
		persons = new ArrayList<Person>();
		List<BasicPersonInfos> all_persons = getAllPersonInfos();
		for (BasicPersonInfos basicPersonInfo : all_persons) {
			persons.add(new Person(this, basicPersonInfo));
		}
		
		if (useSavedPersons) {
			init_saved_persons();
		}
	}
	
	 void init_saved_persons() {
		boolean noOneAdded = false;
		while (!noOneAdded) {
			noOneAdded = true;
			Person nextEarliestPerson = null;
			for (Person person : persons) {
				if ((person.getBasicPersonInfos().getOriginalSlotPosition() == -1) 
					&& (person.getBasicPersonInfos().getTimeCheckPoints().size() > 0)) {
					
					if (nextEarliestPerson != null) {
						if (person.getBasicPersonInfos().getTimeCheckPoints().get(0).getTime() <= 
							nextEarliestPerson.getBasicPersonInfos().getTimeCheckPoints().get(0).getTime()) {
							
							nextEarliestPerson = person;
						}
					} else {
						nextEarliestPerson = person;
					}
				}
			}
			
			if (nextEarliestPerson != null) {
				noOneAdded = false;
				int slot = getNextFreeSlot();
				nextEarliestPerson.setSlot(slot);
				nextEarliestPerson.getBasicPersonInfos().setOriginalSlotPosition(nextEarliestPerson.getSlot());
				
			}
		}
	}
	
	 int getNextFreeSlot() {
		return nextFreeSlot++;
	}
	
	 int getCurrentlyDisplayedSlot() {
		return currentlyDisplayedSlot;
	}
	
	 void saveDateList() {
		String[] toSave = new String[persons.size()];
		for (Person person : persons) {
			toSave[persons.indexOf(person)] = 
				person.getBasicPersonInfos().getName() + ";" +
				person.getBasicPersonInfos().getRfidTag();
			
			for (Date nextDate : person.getBasicPersonInfos().getTimeCheckPoints()) {
				toSave[persons.indexOf(person)] += ";" + nextDate.getTime();
			}
		}
		if (dateFile == null) {
   println("dataFile is null"); 
}
if (toSave == null) {
   println("toSave is null"); 
}

	}
	
	 Date getCurrentTime() {
		if (useRealTime) {
			return new Date();
		} else {
			return new Date(new Date().getTime() + 1000*15*frameCount);	//for testing purposes only
		}
	}
	
	 void draw() {
		background(backgrColor);
//                println(frameRate);
		shapeMode(CENTER);
		shape(rfidPic, rfidPicX, rfidPicY, rfidPicWidth, rfidPicHeight);
		
		for (Person person : persons) {
			person.display();
		}
		
		if ((new Date().getTime() - lastPersonChange.getTime()) > delayBetweenPersonChange) {
			changePersons(-1);
			lastPersonChange = new Date();
		}
		
		timeLine.display();
	}
	
	 void keyPressed() {
		//TODO: delete this function
		if (key == 'r') {
			int randPerson = new Random().nextInt(persons.size());
			System.out.println("chose randomly: " + persons.get(randPerson).getBasicPersonInfos().getName());
			newRfidEvent(persons.get(randPerson).getBasicPersonInfos().getRfidTag());
		} else if (key == 'a') {
			for (Person person : persons) {
				newRfidEvent(person.getBasicPersonInfos().getRfidTag());
			}
		}
		
		if ((key == CODED) && (keyCode == RIGHT)) {
			changePersons(-1);
		}
	}
	
	 void newRfidEvent(String rfidTag) {
                println("new rfid event");
		slotSpacing = slotSpacingMax - ((nextFreeSlot / (float)persons.size()) * (slotSpacingMax - slotSpacingMin));
		
		for (Person person : persons) {
	          if (person.checkPointEvent(rfidTag)) {
                        //signon.trigger();
                        //person.isIntro = true;
                        changePersons(nextFreeSlot-1);
                        lastPersonChange = new Date();
                      }
		}
		//changePersons(nextFreeSlot-1);
		saveDateList();
	}

	 void changePersons(int new_one) {
                println("new person event");
		if (new_one == -1) {
			if (nextFreeSlot > 0) {

				currentlyDisplayedSlot = (1+currentlyDisplayedSlot) % nextFreeSlot;
			}
		} else {
			currentlyDisplayedSlot = new_one;
		}
		
		for (Person person : persons) {
			if (person.getBasicPersonInfos().getOriginalSlotPosition() == currentlyDisplayedSlot) {
				person.setSlot(-100);
			} else {
				person.setSlot(person.getBasicPersonInfos().getOriginalSlotPosition());
			}
		}

		compute_connections();
	}
	
	
	 int getTagColorCode(int position) {
		return tagColors[position%tagColors.length];
	}
	
	 float computeLargestNameSize() {
		float largest = 1;
		
		textFont(slotFont, slotSize);
		for (Person person : persons) {
			if (textWidth(person.getBasicPersonInfos().getName()) > largest) {
				largest = textWidth(person.getBasicPersonInfos().getName());
			}
		}
		
		return largest;
	}
	
	 void computeMaxTags() {
		for (Person person : persons) {
			if (person.getBasicPersonInfos().getTags().size() > maxTags) {
				maxTags = person.getBasicPersonInfos().getTags().size();
			}
		}
	}
	
	 List<BasicPersonInfos> getAllPersonInfos() {
		List<BasicPersonInfos> all_persons = new ArrayList<BasicPersonInfos>();
		
		String[] dates = loadStrings(dateFile);
		
                //TODO: this should be replaced with a non-static return statement (maybe a call from the database)
		String[] lines = loadStrings(listFile);
		for (int k = 0; k < lines.length; k++) {
			//KEEP THE FOLLOWING FORM: rfid;name,description;Tag1;Tag2;...
			String[] data = split(lines[k], ';');
			BasicPersonInfos newPersonInfos = new BasicPersonInfos(data[0], data[1], data[2]);
			
			for (int m = 3; m < data.length; m++) {
				newPersonInfos.addTag(data[m]);
			}
			
			if (useSavedPersons) {
				ArrayList<Date> savedDates = getSavedDates(newPersonInfos.getRfidTag(), dates);
				if (savedDates != null) {
					newPersonInfos.setTimeCheckPoints(savedDates);
				}
			}
			
			all_persons.add(newPersonInfos);
		}
		
		return all_persons;
	}
	
	 ArrayList<Date> getSavedDates(String rfidName, String[] dateList) {
		if (dateList == null) {
			return null;
		}
		
		ArrayList<Date> savedDates = new ArrayList<Date>();
		for (int k = 0; k < dateList.length; k++) {
			String[] entry = split(dateList[k], ';');
	
                        if (entry[1].equals(rfidName)) {
				for (int m = 2; m < entry.length; m++) {
					savedDates.add(new Date(new Long(entry[m])));
				}
			}
		}
		
		return savedDates;
	}


class RfidListener extends Thread {

  public RfidListener() {
  
  }
  
  public void run() {
    while (true) {    
      String[] tagList = rfid.tagsOnReader(0);
      
      if ((tagList != null) && (tagList.length > 0)) {
        System.out.println("tag: "+ tagList[0]);
        newRfidEvent(tagList[0]);
      }
     
       try {
         sleep(200);
       } catch (InterruptedException exc) {
         //nothing
       }
    }
  }
}



void stop() {
  // always close Minim audio classes when you are done with them
  signon.close();
  signoff.close();
  minim.stop();
  super.stop();
}


