package model;

import java.io.Serializable;

public class Department implements Serializable {
    private int departmentId;
    private String name;
    private String description;
    private String imageUrl;
    
    public Department() {
    }
    
    public Department(int departmentId, String name, String description, String imageUrl) {
        this.departmentId = departmentId;
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl;
    }
    
    // Getters and Setters
    public int getDepartmentId() {
        return departmentId;
    }
    
    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
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
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    // For backward compatibility
    public int getId() {
        return departmentId;
    }
    
    public void setId(int id) {
        this.departmentId = id;
    }
}
