package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Doctor implements Serializable {
    private int doctorId;
    private String name;
    private String specialization;
    private String qualification;
    private String experience;
    private String email;
    private String phone;
    private String imageUrl;
     
    public Doctor() {
    }
    
    
    public Doctor(int doctorId, String name, String specialization, String qualification, 
                 String experience, String email, String phone, String imageUrl) {
        this.doctorId = doctorId;
        this.name = name;
        this.specialization = specialization;
        this.qualification = qualification;
        this.experience = experience;
        this.email = email;
        this.phone = phone;
        this.imageUrl = imageUrl;
        
    }
    
    // Getters and Setters
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getQualification() {
        return qualification;
    }
    
    public void setQualification(String qualification) {
        this.qualification = qualification;
    }
    
    public String getExperience() {
        return experience;
    }
    
    public void setExperience(String experience) {
        this.experience = experience;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    private List<Integer> departmentIds;
    
    public List<Integer> getDepartmentIds() {
        return departmentIds;
    }
    
    public void setDepartmentIds(List<Integer> departmentIds) {
        this.departmentIds = departmentIds;
    }
    
    public void addDepartmentId(int departmentId) {
        if (this.departmentIds == null) {
            this.departmentIds = new ArrayList<>();
        }
        this.departmentIds.add(departmentId);
    }
    
    // For backward compatibility
    public int getId() {
        return doctorId;
    }
    
    public void setId(int id) {
        this.doctorId = id;
    }
    
    // For backward compatibility - returns the first department if multiple exist
    public int getDepartmentId() {
        return departmentIds != null && !departmentIds.isEmpty() ? departmentIds.get(0) : 0;
    }
    
    public void setDepartmentId(int departmentId) {
        if (this.departmentIds == null) {
            this.departmentIds = new ArrayList<>();
        }
        
        if (this.departmentIds.isEmpty()) {
            this.departmentIds.add(departmentId);
        } else {
            this.departmentIds.set(0, departmentId);
        }
    }
}
