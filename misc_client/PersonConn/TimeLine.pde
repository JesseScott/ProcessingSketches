
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class TimeLine {
	private PersonConn parent;
	private List<Integer> all_hours;
	private float distanceBetweenTimeStamps;
	
	public TimeLine(PersonConn i_parent) {
		parent = i_parent;
		Calendar cal = Calendar.getInstance();
		all_hours = new ArrayList<Integer>();
		for (int k = 0; k < parent.eventInHours; k++) {
			cal.setTime(parent.startDate);
			Date this_date = new Date(parent.startDate.getTime() + (1000*60*60*k));
			cal.setTime(this_date);
			all_hours.add(cal.get(Calendar.HOUR_OF_DAY));
		}
		distanceBetweenTimeStamps = (parent.appletWidth - (parent.slotPosition[0] + parent.largestNameSize)) / (float)(all_hours.size());
	}
	
	@SuppressWarnings("static-access")
	public void display() {
		parent.noStroke();
		parent.fill(parent.timeBackgroundColor);
		parent.rect(parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize,
				parent.timeYPosition - (0.5f * parent.timeLineHeight),
				getCurrentTime_xPos() - (parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize),
				parent.timeLineHeight);
		
		parent.fill(parent.timeColor);
		parent.textFont(parent.timeFont, parent.timeFontSize);
		for (int hour : all_hours) {
			parent.textAlign(parent.CENTER, parent.CENTER);
			
			String hour_to_display = "";
			for (int m = 0; m < 2; m++) {
				if ((m == 0) && (hour < 10)) {
					hour_to_display += "0 ";
				} else if (m == 0) {
					hour_to_display += (hour / 10) + " ";
				} else {
					hour_to_display += (hour % 10) + " ";
				}
			}
			hour_to_display += ": 0 0";
			
			parent.text(hour_to_display,
				parent.slotPosition[0] - (0.5f * parent.textWidth(hour_to_display)) + parent.timeXPositionOffset + parent.largestNameSize + (0.5f * distanceBetweenTimeStamps) + (distanceBetweenTimeStamps * all_hours.indexOf(hour)),
				parent.timeYPosition - (0.5f * parent.timeLineHeight),
				parent.textWidth(hour_to_display),
				parent.timeLineHeight);
			parent.textAlign(parent.LEFT, parent.BASELINE);
			
			parent.fill(parent.backgrColor);
			parent.noStroke();
			parent.rect(
					parent.slotPosition[0] - (0.5f * parent.timeLineMarkerBackgroundSize[0]) + parent.timeXPositionOffset + parent.largestNameSize + (distanceBetweenTimeStamps * (all_hours.indexOf(hour))),
					parent.timeYPosition - (0.5f * parent.timeLineMarkerBackgroundSize[1]),
					parent.timeLineMarkerBackgroundSize[0],
					parent.timeLineMarkerBackgroundSize[1]);
			
			parent.stroke(parent.timeColor);
			parent.strokeWeight(parent.timeLineMarkerWeight);
			parent.line(
					parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize + (distanceBetweenTimeStamps * (all_hours.indexOf(hour))),
					parent.timeYPosition - (0.5f * parent.timeLineMarkerHeight), 
					parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize + (distanceBetweenTimeStamps * (all_hours.indexOf(hour))),
					parent.timeYPosition + (0.5f * parent.timeLineMarkerHeight));
			
			parent.fill(parent.timeColor);
			parent.noStroke();
			parent.ellipseMode(parent.CENTER);
			parent.ellipse(
					parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize + (distanceBetweenTimeStamps * (all_hours.indexOf(hour))),
					parent.timeYPosition - (0.5f * parent.timeLineMarkerHeight),
					parent.timeLineMarkerBubbleSize,
					parent.timeLineMarkerBubbleSize);
			parent.ellipse(
					parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize + (distanceBetweenTimeStamps * (all_hours.indexOf(hour))),
					parent.timeYPosition + (0.5f * parent.timeLineMarkerHeight),
					parent.timeLineMarkerBubbleSize,
					parent.timeLineMarkerBubbleSize);
		}
	}
	
	public float getCurrentTime_xPos() {
		float startX = parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize;
		float passedX = (parent.appletWidth-startX) * ((parent.getCurrentTime().getTime() - parent.startDate.getTime()) / (float)parent.eventDuration);
		
		return startX + passedX;
	}
	
	public float getTime_xPos(Date ofDate) {
		float startX = parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize;
		float passedX = (parent.appletWidth-startX) * ((ofDate.getTime() - parent.startDate.getTime()) / (float)parent.eventDuration);
		
		return startX + passedX;
	}
	
	public float getStartTime_xPos() {
		return parent.slotPosition[0] + parent.timeXPositionOffset + parent.largestNameSize;
	}
}

