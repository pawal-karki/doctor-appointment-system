package model;


public class DoctorTimeSlot {
    private int doctorId;
    private int timeslotId;
    private boolean isAvailable;
    
    public DoctorTimeSlot() {
    }
    
    public DoctorTimeSlot(int doctorId, int timeslotId, boolean isAvailable) {
        this.doctorId = doctorId;
        this.timeslotId = timeslotId;
        this.isAvailable = isAvailable;
    }
    
    // Getters and Setters
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public int getTimeslotId() {
        return timeslotId;
    }
    
    public void setTimeslotId(int timeslotId) {
        this.timeslotId = timeslotId;
    }
    
    public boolean isAvailable() {
        return isAvailable;
    }
    
    public void setAvailable(boolean available) {
        isAvailable = available;
    }
}
