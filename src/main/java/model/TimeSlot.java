package model;
public class TimeSlot {
import java.sql.Date;
import java.sql.Time;

public class TimeSlot {
    private int timeslotId;
    private Date slotDate;
    private Time startTime;
    private Time endTime;

    public TimeSlot() {
        // Default constructor
    }	

    public TimeSlot(int timeslotId, Date slotDate, Time startTime, Time endTime) {
        this.timeslotId = timeslotId;
        this.slotDate = slotDate;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public int getTimeslotId() {
        return timeslotId;
    }

    public void setTimeslotId(int timeslotId) {
        this.timeslotId = timeslotId;
    }

    public Date getSlotDate() {
        return slotDate;
    }

    public void setSlotDate(Date slotDate) {
        this.slotDate = slotDate;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }
}
