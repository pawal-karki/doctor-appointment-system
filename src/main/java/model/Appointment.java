package model;

import java.io.Serializable;
import java.util.Date;

public class Appointment implements Serializable {
    private int appointmentId;
    private int userId;
    private int doctorId;
    private int timeSlot;
    private Date appointmentDate;
    private String status; // "pending", "confirmed", "cancelled", "completed"
    private String note;
    
    public Appointment() {
    }
    
    public Appointment(int appointmentId, int userId, int doctorId, int timeSlot, 
                      Date appointmentDate, String status, String note) {
        this.appointmentId = appointmentId;
        this.userId = userId;
        this.doctorId = doctorId;
        this.timeSlot = timeSlot;
        this.appointmentDate = appointmentDate;
        this.status = status;
        this.note = note;
    }
    
    // Getters and Setters
    public int getAppointmentId() {
        return appointmentId;
    }
    
    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public int getTimeSlot() {
        return timeSlot;
    }
    
    public void setTimeSlot(int timeSlot) {
        this.timeSlot = timeSlot;
    }
    
    public Date getAppointmentDate() {
        return appointmentDate;
    }
    
    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getNote() {
        return note;
    }
    
    public void setNote(String note) {
        this.note = note;
    }
    
    // For backward compatibility
    public int getId() {
        return appointmentId;
    }
    
    public void setId(int id) {
        this.appointmentId = id;
    }
    
    // For backward compatibility
    public String getNotes() {
        return note;
    }
    
    public void setNotes(String notes) {
        this.note = notes;
    }
}
