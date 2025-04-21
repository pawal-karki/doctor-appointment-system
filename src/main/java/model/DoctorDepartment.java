package model;

import java.io.Serializable;

/**
 * Junction model representing the many-to-many relationship between Doctor and Department.
 * This class represents entries in the doctor_department table.
 */
public class DoctorDepartment implements Serializable {
    private int id;
    private int doctorId;
    private int departmentId;
    
    // Default constructor
    public DoctorDepartment() {
    }
    
    // Parameterized constructor
    public DoctorDepartment(int id, int doctorId, int departmentId) {
        this.id = id;
        this.doctorId = doctorId;
        this.departmentId = departmentId;
    }
    
    // Constructor without id (for creating new records)
    public DoctorDepartment(int doctorId, int departmentId) {
        this.doctorId = doctorId;
        this.departmentId = departmentId;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public int getDepartmentId() {
        return departmentId;
    }
    
    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        DoctorDepartment that = (DoctorDepartment) obj;
        
        if (doctorId != that.doctorId) return false;
        return departmentId == that.departmentId;
    }
    
    @Override
    public int hashCode() {
        int result = doctorId;
        result = 31 * result + departmentId;
        return result;
    }
} 