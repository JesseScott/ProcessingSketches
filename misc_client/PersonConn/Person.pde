
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import de.looksgood.ani.Ani;
import de.looksgood.ani.AniSequence;

public class Person {
	private BasicPersonInfos infos;
	private PersonConn parent;
	private int slotPosition = -1;
	private HashMap<Integer, List<Integer>> connections = new HashMap<Integer, List<Integer>>();
	private ArrayList<Integer> sortedConnectionList = new ArrayList<Integer>();
	private boolean isNew, welcomeDisplay;
	private float in_animation;
	public float strength1 = 170;
	public float strength2 = 230;
	//public float strengthPercentage = 1;
	public float bezierPercentage = 1;
	public float bubblePercentage = 1;
	public float namePercentage = 1;
	public float nameFadeDirection = 0;
	public boolean isIntro = false;
	public Person(PersonConn i_parent, BasicPersonInfos i_infos) {
		infos = i_infos;
		parent = i_parent;
		isNew = true;
		welcomeDisplay = true;
		in_animation = 0;
	}
	
	public void display() {
		if (in_animation > 0) {	//fade out
			displayChosen();
			displayInSlot();
		} else {
			if (slotPosition == -100) {	//is the chosen one
				displayChosen();
			}
			if (slotPosition != -1) {
				displayInSlot();
			}
		}
	}
	
	@SuppressWarnings("static-access")
	private void displayChosen() {
		parent.textFont(parent.welcomeFont, parent.welcomeSize);
		parent.textAlign(parent.CENTER);
		parent.fill(parent.welcomeColor);
		if (isNew || welcomeDisplay) {
			parent.text("W E L C O M E !", parent.welcomePosition[0], parent.welcomePosition[1]);
		}
		
		parent.textFont(parent.nameFont, parent.nameSize);
		parent.fill(parent.nameColor, 255 * namePercentage);
		parent.text(infos.getName(), parent.namePosition[0], parent.namePosition[1] - nameFadeDirection * ((1-namePercentage) * parent.nameOutAnimationYOffset));
		
		parent.textFont(parent.descriptionFont, parent.descriptionSize);
		parent.fill(parent.descriptionColor, 255*namePercentage);
		parent.text(infos.getDescription(),
				parent.descriptionField[0],
				parent.descriptionField[1],
				parent.descriptionField[2],
				parent.descriptionField[3]);
		parent.textAlign(parent.LEFT);
		
		int[] slotConnections = new int[parent.persons.size()];
		int connectionNum = 0;
		for (int sorted : sortedConnectionList) {
			parent.fill(parent.getTagColorCode(connectionNum));
			parent.stroke(parent.getTagColorCode(connectionNum));
			parent.ellipseMode(parent.CENTER);
			parent.textFont(parent.tagFont, parent.tagFontSize);
			parent.textAlign(parent.RIGHT, parent.CENTER);
			
			float tagYposOnRim = 0f;
			if (sortedConnectionList.size() % 2 == 0) {
				if (connectionNum+1 <= (0.5f * sortedConnectionList.size())) {
					float tagPosOffset = ((0.5f * sortedConnectionList.size()) - (connectionNum + 1)) * (parent.tagSpacing + parent.tagFontSize);
					tagYposOnRim = parent.rfidPicMidY - ((0.5f * parent.tagFontSize) + (0.5f * parent.tagSpacing)) - tagPosOffset;
				} else {
					float tagPosOffset = (connectionNum - (0.5f * sortedConnectionList.size())) * (parent.tagSpacing + parent.tagFontSize);
					tagYposOnRim = parent.rfidPicMidY + ((0.5f * parent.tagFontSize) + (0.5f * parent.tagSpacing)) + tagPosOffset;
				}
			} else {
				if (connectionNum+1 <= (0.5f * sortedConnectionList.size())) {
					float tagPosOffset = ((0.5f * sortedConnectionList.size()) + 0.5f - (connectionNum + 1)) * (parent.tagSpacing + parent.tagFontSize);
					tagYposOnRim = parent.rfidPicMidY - tagPosOffset;
				} else {
					float tagPosOffset = (connectionNum - (0.5f * sortedConnectionList.size()) + 0.5f) * (parent.tagSpacing + parent.tagFontSize);
					tagYposOnRim = parent.rfidPicMidY + tagPosOffset;
				}
			}
			
			float bubbleVisibility = 1;
			if (sortedConnectionList.indexOf(sorted) <= (bubbleVisibility * (float)sortedConnectionList.size())) {
				bubbleVisibility = (bubblePercentage * (float)sortedConnectionList.size()) - sortedConnectionList.indexOf(sorted);
			}
			if (bubbleVisibility < 0) {
				bubbleVisibility = 0;
			}
			if (bubbleVisibility > 1) {
				bubbleVisibility = 1;
			}
			parent.ellipse(getXPosOnRim(false, tagYposOnRim),
					tagYposOnRim,
					parent.tagEllipseSize * bubbleVisibility,
					parent.tagEllipseSize * bubbleVisibility);
			parent.ellipse(getXPosOnRim(true, tagYposOnRim),
					tagYposOnRim,
					parent.tagEllipseSize * bubbleVisibility,
					parent.tagEllipseSize * bubbleVisibility);
			
			parent.textAlign(parent.RIGHT);
			parent.fill(parent.getTagColorCode(connectionNum), 255*bubbleVisibility);
			parent.text(infos.getTags().get(sorted),
					getXPosOnRim(true, tagYposOnRim) - parent.tagTextOffsetX,
					tagYposOnRim);
			parent.textAlign(parent.LEFT);
			
			
			for (int connectPos : connections.get(sorted)) {
				slotConnections[connectPos]++;
				
				connectMatchingTags(
						getXPosOnRim(false, tagYposOnRim),
						tagYposOnRim,
						getConnectionEndingX(parent.maxTags),
						getConnectionEndingY(connectPos)
				);
				
				parent.ellipseMode(parent.CENTER);
				parent.fill(parent.getTagColorCode(connectionNum), 255 * bezierPercentage);
				parent.stroke(parent.getTagColorCode(connectionNum), 255 * bezierPercentage);
				parent.ellipse(
						getConnectionEndingX(slotConnections[connectPos]),
						getConnectionEndingY(connectPos),
						parent.availableEllipseSize,
						parent.availableEllipseSize);
			}
			
			parent.textAlign(parent.LEFT, parent.BASELINE);
			connectionNum++;
		}
	}
	
	private float getConnectionEndingX(float bubbleOffset) {
		return parent.slotPosition[0] - (bubbleOffset * (parent.availableEllipseSize + parent.availableEllipseSpacing));
	}
	
	private float getXPosOnRim(boolean isLeft, float yValue) {
		double dist = Math.sqrt(((0.5f * parent.rfidPicAperture) * (0.5f * parent.rfidPicAperture))
				- ((parent.rfidPicMidY - yValue) * (parent.rfidPicMidY - yValue)));
		
		if (isLeft) {
			return parent.rfidPicMidX - new Float(dist);
		} else {
			return parent.rfidPicMidX + new Float(dist);
		}
	}
	
	private float getConnectionEndingY(int connectingToSlot) {
		if (connectingToSlot % 2 == 0) {
			return parent.slotPosition[1] - ((0.5f * connectingToSlot) * (parent.slotSize + parent.slotSpacing)) - (0.5f * parent.slotSize);
		} else {
			return parent.slotPosition[2] + ((0.5f * connectingToSlot) * (parent.slotSize + parent.slotSpacing)) - (0.5f * parent.slotSize);
		}
	}
	
	private void connectMatchingTags(float x1, float y1, float x2, float y2) {
		
		parent.noFill();
		parent.strokeWeight(0.5f);
		parent.bezier(
				x1,
				y1,
				x1 + (strength1 * bezierPercentage),
				//x1 + (strength1 * strengthPercentage),
				y1,
				x2 - (strength2 * bezierPercentage) - ((1-bezierPercentage)* (x2-x1)),
				//x2 - (strength2 * strengthPercentage) - ((1-bezierPercentage)* (x2-x1)),
				y2 - ((1-bezierPercentage)* (y2-y1)),
				x2 - ((1-bezierPercentage)* (x2-x1)),
				y2 - ((1-bezierPercentage)* (y2-y1)));
	}
	
	@SuppressWarnings("static-access")
	private void displayInSlot() {
		parent.textFont(parent.slotFont, parent.slotSize);
		if (in_animation > 0) {
			parent.fill(parent.slotColor, 255 * (1 - namePercentage));
		} else {
			parent.fill(parent.slotColor);
		}
		
		parent.textAlign(parent.LEFT, parent.CENTER);
		if (slotPosition != -100) {
			parent.text(infos.getName(),
					parent.slotPosition[0],
					getConnectionEndingY(infos.getOriginalSlotPosition()));
		}
		parent.textAlign(parent.LEFT, parent.BASELINE);
		
		parent.image(parent.checkpointBackground, 
				parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize,
				getConnectionEndingY(infos.getOriginalSlotPosition()) - (0.5f * parent.checkpointBackground.height));
		
		for (Date nextDate : infos.getTimeCheckPoints()) {
			if ((infos.getTimeCheckPoints().indexOf(nextDate) % 2) == 0) {
				parent.noStroke();
				parent.fill(parent.slotColor);
				parent.ellipse(parent.timeLine.getTime_xPos(nextDate),
						getConnectionEndingY(infos.getOriginalSlotPosition()),
						parent.checkpointEllipseSize,
						parent.checkpointEllipseSize);
				
                                // intro ellipse animation
                                if(isIntro) {
                                  if(namePercentage  == 1.0) isIntro = false;
                                  pushStyle();
                                  stroke(0, 55 - namePercentage*55);
                                  strokeWeight(20);
                                  noFill();
                                  ellipse(parent.timeLine.getTime_xPos(nextDate),
						getConnectionEndingY(infos.getOriginalSlotPosition()),
						parent.checkpointEllipseSize*namePercentage*25,
						parent.checkpointEllipseSize*namePercentage*25);
                                  popStyle();
                                }
                                
                                
				if (infos.getTimeCheckPoints().indexOf(nextDate) == infos.getTimeCheckPoints().size() -1) {
					parent.strokeWeight(parent.checkpointLineSize);
					parent.stroke(parent.slotColor);
					parent.line(parent.timeLine.getTime_xPos(infos.getTimeCheckPoints().get(infos.getTimeCheckPoints().indexOf(nextDate))),
							getConnectionEndingY(infos.getOriginalSlotPosition()),
							parent.timeLine.getCurrentTime_xPos(),
							getConnectionEndingY(infos.getOriginalSlotPosition()));
					
				}
			} else {
				parent.strokeWeight(parent.checkpointLineSize);
				parent.stroke(parent.slotColor);
				parent.line(parent.timeLine.getTime_xPos(infos.getTimeCheckPoints().get(infos.getTimeCheckPoints().indexOf(nextDate) - 1)),
						getConnectionEndingY(infos.getOriginalSlotPosition()),
						parent.timeLine.getTime_xPos(infos.getTimeCheckPoints().get(infos.getTimeCheckPoints().indexOf(nextDate))) - parent.checkpointLineEndingOffset,
						getConnectionEndingY(infos.getOriginalSlotPosition()));
				
				parent.strokeWeight(parent.checkpointCrossLineWeight);
				parent.line((-0.5f * parent.checkpointCrossSize) + parent.timeLine.getTime_xPos(infos.getTimeCheckPoints().get(infos.getTimeCheckPoints().indexOf(nextDate))),
						(-0.5f * parent.checkpointCrossSize) + 	getConnectionEndingY(infos.getOriginalSlotPosition()),
						(0.5f * parent.checkpointCrossSize) + parent.timeLine.getTime_xPos(infos.getTimeCheckPoints().get(infos.getTimeCheckPoints().indexOf(nextDate))),
						(0.5f * parent.checkpointCrossSize) + getConnectionEndingY(infos.getOriginalSlotPosition()));
				parent.line((0.5f * parent.checkpointCrossSize) + parent.timeLine.getTime_xPos(infos.getTimeCheckPoints().get(infos.getTimeCheckPoints().indexOf(nextDate))),
						(-0.5f * parent.checkpointCrossSize) + getConnectionEndingY(infos.getOriginalSlotPosition()),
						(-0.5f * parent.checkpointCrossSize) + parent.timeLine.getTime_xPos(infos.getTimeCheckPoints().get(infos.getTimeCheckPoints().indexOf(nextDate))),
						(0.5f * parent.checkpointCrossSize) + getConnectionEndingY(infos.getOriginalSlotPosition()));
			}
		}
	}
	
	public void setSlot(int new_pos) {
		if (new_pos == -100) {
			if ((isNew) && (welcomeDisplay)) {
				isNew = false;
			} else if (welcomeDisplay) {
				welcomeDisplay = false;
			}
			
			//wait for other name to fade out
			in_animation = -1;
			
			AniSequence strengthIn = new AniSequence(parent);
			strengthIn.beginSequence();
			strengthIn.add(Ani.to(this, parent.completeAnimationTime, "in_animation", 0));
			strengthIn.add(Ani.to(this, 0, "in_animation", 1));			//waited for fade out
			strengthIn.add(Ani.to(this, 0, "slotPosition", new_pos));	//assign new position
			strengthIn.add(Ani.to(this, 0, "bubblePercentage", 0));
			strengthIn.add(Ani.to(this, parent.bubbleAnimationTime, "bubblePercentage", 1));
			strengthIn.add(Ani.to(this, 0, "bezierPercentage", 0));
			strengthIn.add(Ani.to(this, parent.bezierAnimationTime, "bezierPercentage", 1));
			strengthIn.add(Ani.to(this, 0, "nameFadeDirection", -1));
			strengthIn.add(Ani.to(this, 0, "in_animation", 0));
			strengthIn.endSequence();
			
			AniSequence nameIn = new AniSequence(parent);
			nameIn.beginSequence();
			nameIn.add(Ani.to(this, parent.completeAnimationTime, "unimportant", 0));
			nameIn.add(Ani.to(this, 0, "nameFadeDirection", -1));
			nameIn.add(Ani.to(this, 0, "namePercentage", 0));
			nameIn.add(Ani.to(this, parent.completeAnimationTime, "namePercentage", 1, Ani.SINE_OUT));
			nameIn.endSequence();
			
			nameIn.start();
			strengthIn.start();
			
		} else if ((new_pos != -100) && (slotPosition == -100)) {
			in_animation = 1;
			
			namePercentage = 1;
			nameFadeDirection = 1;
			Ani.to(this, parent.completeAnimationTime, "namePercentage", 0, Ani.SINE_IN);
			
			bezierPercentage = 1;
			bubblePercentage = 1;
			AniSequence seqBubblesOut = new AniSequence(parent);
			seqBubblesOut.beginSequence();
			seqBubblesOut.add(Ani.to(this, parent.bezierAnimationTime, "bezierPercentage", 0));
			seqBubblesOut.add(Ani.to(this, parent.bubbleAnimationTime, "bubblePercentage", 0));
			seqBubblesOut.endSequence();
			seqBubblesOut.start();
			
			AniSequence seqOutSetBack = new AniSequence(parent);
			seqOutSetBack.beginSequence();
			seqOutSetBack.add(Ani.to(this, parent.completeAnimationTime, "in_animation", 0));
			seqOutSetBack.add(Ani.to(this, 0, "bezierPercentage", 1));
			seqOutSetBack.add(Ani.to(this, 0, "bubblePercentage", 1));
			seqOutSetBack.add(Ani.to(this, 0, "namePercentage", 1));
			seqOutSetBack.add(Ani.to(this, 0, "nameFadeDirection", 1));
			seqOutSetBack.add(Ani.to(this, 0, "slotPosition", new_pos));
			seqOutSetBack.endSequence();
			seqOutSetBack.start();
		}
	}
	public int getSlot() {
		return slotPosition;
	}
	
	public boolean checkPointEvent(String personRfidTag) {
            boolean retValue = false;		
  if (personRfidTag.equals(infos.getRfidTag())) {
		
    	
  
                  List<Date> all_dates = infos.getTimeCheckPoints();
              
                  
			if (all_dates.size() > 0) {
				if (parent.getCurrentTime().getTime() - all_dates.get(all_dates.size()-1).getTime() > parent.minDelayBetweenTimeCheckPoints) {
					all_dates.add(parent.getCurrentTime());
					infos.setTimeCheckPoints(all_dates);
                                        println("checkout person event");
                                        
                                                  //Modulating over checkin and checkout
                        if(all_dates.size() % 2 == 1) {
                          signon.trigger();
                          isIntro = true;
                        }
                        else {
                           signoff.trigger(); 
                        }
                                        
                                        //signoff.trigger();
				}
			} else {
                                signon.trigger();
                                isIntro = true;
				all_dates.add(parent.getCurrentTime());
				infos.setTimeCheckPoints(all_dates);
                              retValue = true;	
			}
			
			if (slotPosition == -1) {
				int mySlot = parent.getNextFreeSlot();
				//slotPosition = parent.persons.size() + 10;	//old, only for a circular person-choose
				slotPosition = mySlot;
				infos.setOriginalSlotPosition(mySlot);
			}
		}

  return retValue;
	}
	
	public BasicPersonInfos getBasicPersonInfos() {
		return infos;
	}
	
	public boolean isDisplayedInSlots() {
		return (slotPosition != -1);
	}
	
	public boolean isDisplayedAsMaster() {
		return (slotPosition == -100);
	}
	
	public void setConnections(HashMap<Integer, List<Integer>> i_connections) {
		connections = i_connections;
	}
	
	public void setSortedConnectionList(ArrayList<Integer> sortedList) {
		sortedConnectionList = sortedList;
	}
}

