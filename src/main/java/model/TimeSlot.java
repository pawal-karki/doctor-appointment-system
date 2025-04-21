package model;

import java.io.Serializable;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class TimeSlot implements Serializable {
    private int timeslotId;
    private Date slotDate;
    private Time startTime;
    private Time endTime;
    
    
    public TimeSlot() {
        this.doctorTimeSlots = new ArrayList<>();
    }
    
    public TimeSlot(int timeslotId, Date slotDate, Time startTime, Time endTime) {
        this.timeslotId = timeslotId;
        this.slotDate = slotDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.doctorTimeSlots = new ArrayList<>();
    }
    
    // Getters and Setters
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
    private List<DoctorTimeSlot> doctorTimeSlots;
    
    public List<DoctorTimeSlot> getDoctorTimeSlots() {
        return doctorTimeSlots;
    }
    
    public void setDoctorTimeSlots(List<DoctorTimeSlot> doctorTimeSlots) {
        this.doctorTimeSlots = doctorTimeSlots;
    }
    
    public void addDoctorTimeSlot(DoctorTimeSlot doctorTimeSlot) {
        if (this.doctorTimeSlots == null) {
            this.doctorTimeSlots = new ArrayList<>();
        }
        this.doctorTimeSlots.add(doctorTimeSlot);
    }
    
    // For backward compatibility
    public int getId() {
        return timeslotId;
    }
    
    public void setId(int id) {
        this.timeslotId = id;
    }
}
