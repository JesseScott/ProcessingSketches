
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class BasicPersonInfos {
  private String name;
  private String description;
  private String rfidTag;
  private List<String> tags;
  private List<Date> timeCheckPoints;
  private int originalSlotPosition;

  public BasicPersonInfos(String i_rfidTag, String i_name, String i_description) {
    name = i_name;
    description = i_description;
    rfidTag = i_rfidTag;
    tags = new ArrayList<String>();
    timeCheckPoints = new ArrayList<Date>();
    tags = new ArrayList<String>();
    originalSlotPosition = -1;
  }

  public BasicPersonInfos(String i_rfidTag, String i_name, String i_description, List<String> i_tags) {
    name = i_name;
    description = i_description;
    rfidTag = i_rfidTag;
    tags = i_tags;
    timeCheckPoints = new ArrayList<Date>();
    originalSlotPosition = -1;
  }

  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }

  public String getDescription() {
    return description;
  }
  public void setDescription(String description) {
    this.description = description;
  }

  public String getRfidTag() {
    return rfidTag;
  }
  public void setRfidTag(String rfidTag) {
    this.rfidTag = rfidTag;
  }

  public List<String> getTags() {
    return tags;
  }
  public void setTags(List<String> tags) {
    this.tags = tags;
  }

  public void addTag(String ... tag) {
    for (int k = 0; k < tag.length; k++) {
      this.tags.add(tag[k]);
    }
  }

  public List<Date> getTimeCheckPoints() {
    return timeCheckPoints;
  }
  public void setTimeCheckPoints(List<Date> timeCheckPoints) {
    this.timeCheckPoints = timeCheckPoints;
  }

  public int getOriginalSlotPosition() {
    return originalSlotPosition;
  }

  public void setOriginalSlotPosition(int originalSlotPosition) {
    this.originalSlotPosition = originalSlotPosition;
  }
}

